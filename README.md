# Ennio Editor
A lightweight GTK+ text editor written in Vala.

## TODO

- [] Create 'Find' functionality.
- [] Create 'Replace' functionality.
- [] Allow user to pick a custom editor theme.
- [] Create a desktop file.

## COMPILING

Open a terminal to the folder containg ennio's files

Ennio follows the traditional pattern of `./configure && make && make install`

That is `./configure` checks you have all the programs & libraries to compile ennio and generates a *Makefile*
`make` runs the instructions in the generated *Makefile*. Now ennino is compiled but won't run because GSettings, the system used to store user prefrences, won't know abount Ennio's existence
So we finally run `make install` (some setups may require prefixing with `sudo`) to copy ennino to the executable directory and it's gsettings data to the data directry

Now ennion can be run with `ennio`

## LINKS
* Apache: http://www.apache.org/licenses/LICENSE-2.0.html
* GTK+: http://www.gtk.org/
* Vala: https://wiki.gnome.org/Projects/Vala
* Valadoc: http://valadoc.org/
