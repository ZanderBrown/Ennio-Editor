AC_INIT([ennio], [0.0])
AC_CONFIG_AUX_DIR([build])

AM_SILENT_RULES([yes])
AM_INIT_AUTOMAKE([foreign subdir-objects])
AM_MAINTAINER_MODE([enable])


AC_PROG_CC
AM_PROG_VALAC 

pkg_modules="gtksourceview-3.0 gtk+-3.0 >= 3.12.0"
PKG_CHECK_MODULES(ENNIO, [$pkg_modules]) 
AC_SUBST(ENNIO_CFLAGS) 
AC_SUBST(ENNIO_LIBS) 

GLIB_GSETTINGS

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
