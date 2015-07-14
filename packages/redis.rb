class Redis < PACKMAN::Package
  url 'http://download.redis.io/releases/redis-3.0.2.tar.gz'
  sha1 'a38755fe9a669896f7c5d8cd3ebbf76d59712002'
  version '3.0.2'

  label :compiler_insensitive

  option 'use_jemalloc' => false

  def install
    args = %W[
      PREFIX=#{prefix}
      CC=#{PACKMAN.compiler('c').command}
    ]
    args << 'MALLOC=jemalloc' if use_jemalloc?
    PACKMAN.run 'make install', *args
    %w[run db/redis log].each { |p| PACKMAN.mkdir var+'/'+p }
    PACKMAN.replace 'redis.conf', {
      '/var/run/redis.pid' => var+'/run/redis.pid',
      'dir ./' => 'dir '+var+'/db/redis/',
      '# bind 127.0.0.1' => 'bind 127.0.0.1'
    }
    PACKMAN.mkdir etc
    PACKMAN.cp 'redis.conf', etc
    PACKMAN.cp 'sentinel.conf', etc+'/redis-sentinel.conf'
  end

  def start
    PACKMAN.os.start_cron_job({
      :label => 'org.packman.redis',
      :command => bin+'/redis-server',
      :arguments => etc+'/redis.conf',
      :working_directory => var,
      :run_at_load => true,
      :stdout => var+'/log/redis.log',
      :stderr => var+'/log/redis.log'
    })
  end

  def status
    PACKMAN.os.status_cron_job 'org.packman.redis'
  end

  def stop
    PACKMAN.os.stop_cron_job 'org.packman.redis'
  end
end