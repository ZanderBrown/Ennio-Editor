AM_CPPFLAGS = $(ENNIO_CFLAGS) 

bin_PROGRAMS = ennio
resfile = io.github.michaelrutherford.Ennio-Editor.gresource.xml

ennio_SOURCES =														   \
	src/application.vala											   \
	src/window.vala													   \
	src/prefrence.vala												   \
	src/ennio.vala													   \
	resources.c

ennio_LDADD = $(ENNIO_LIBS)
ennio_VALAFLAGS = --pkg gtk+-3.0 --pkg gtksourceview-3.0 --target-glib=2.38 --gresources $(resfile)

CLEANFILES = *.h *.c *.vapi *.stamp

gsettings_SCHEMAS = io.github.michaelrutherford.Ennio-Editor.gschema.xml
@GSETTINGS_RULES@

resource_files = $(shell glib-compile-resources --generate-dependencies $(resfile))

resources.c: $(resfile) $(resource_files)
	$(AM_V_GEN) glib-compile-resources --target=$@ --generate-source $<
