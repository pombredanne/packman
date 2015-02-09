class Gtkx < PACKMAN::Package
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.25.tar.xz'
  sha1 '017ee13f172a64026c4e77c3744eeabd5e017694'
  version '2.24.25'

  depends_on 'glib'
  depends_on 'libiconv'
  depends_on 'gettext'
  depends_on 'jpeg'
  depends_on 'libpng'
  depends_on 'libtiff'
  depends_on 'fontconfig'
  depends_on 'freetype'
  depends_on 'gdk_pixbuf'
  depends_on 'pango'
  depends_on 'jasper'
  depends_on 'atk'
  depends_on 'cairo'
  depends_on 'x11'
  depends_on 'gobject_introspection'

  def install
    args = %W[
      --prefix=#{PACKMAN.prefix self}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-glibtest
      --enable-introspection=yes
      --disable-visibility
    ]
    PACKMAN::AutotoolHelper.set_cppflags_and_ldflags args,
      [Glib, Libiconv, Gettext, Jpeg, Libpng, Libtiff, Fontconfig, Freetype,
       Gdk_pixbuf, Pango, Jasper, Atk, Cairo, X11, Gobject_introspection]
    PACKMAN.run './configure', *args
    PACKMAN.run 'make install'
  end
end