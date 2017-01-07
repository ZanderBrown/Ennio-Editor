using Gtk;

// These cass(s) are part of ennio
namespace Ennio {
	// Our custom application class extending Gtk.Application
    public class Application : Gtk.Application {
		public Window current_win {
			get { return (Window) active_window; }
		}
		public static GLib.Settings settings = new GLib.Settings("io.github.michaelrutherford.Ennio-Editor");
		public bool dark_mode {
			get {
				return Gtk.Settings.get_default().gtk_application_prefer_dark_theme;
			}
			set {
				Gtk.Settings.get_default().gtk_application_prefer_dark_theme = value;
			}
		}
		public Application () {
			Object(application_id: "io.github.michaelrutherford.Ennio-Editor", flags: ApplicationFlags.FLAGS_NONE);
		}
		protected override void startup () {
			base.startup();
			SimpleAction about = new SimpleAction("about", null);
			about.activate.connect(() => {
				show_about_dialog (
					active_window,
					"program_name", "Ennio Editor",
					"comments", "A bare-bones GTK+ text editor written in Vala.",
					"authors", new string[] {
						"Michael Rutherford",
						"Zander Brown"
					},
					"logo_icon_name", "accessories-text-editor",
					"website", "http://michaelrutherford.github.io",
					"version", "Version: 0.0",
					"copyright", "Copyright © 2015-2016 Michael Rutherford \r\n Copyright © 2017 Zander Brown",
					"license", "Ennio Editor is released under the Apache v2.0 license.",
					"wrap_license", true,
					null
				);
			});
			this.add_action (about);
			
			SimpleAction quit = new SimpleAction("quit", null);
			quit.activate.connect(this.quit);
			this.add_action (quit);

			SimpleAction newtab = new SimpleAction("new", null);
			newtab.activate.connect(this.newtab);
			this.add_action (newtab);

			SimpleAction prefact = new SimpleAction("preferences", null);
			prefact.activate.connect(() => {
				(new Prefrences(current_win.get_titlebar())).popup();
			});
			this.add_action (prefact);

			SimpleAction dark = new SimpleAction.stateful ("dark", null, new Variant.boolean (false));
			dark.activate.connect(() => {
				Variant state = dark.get_state ();
				bool b = state.get_boolean ();
				dark.set_state (new Variant.boolean (!b));
				dark_mode = !b;
			});
			this.add_action (dark);

			settings.bind("dark-mode", this, "dark_mode", SettingsBindFlags.DEFAULT);
		}
		protected override void activate () {
            var editor = new Window (this);
            editor.show_all();
            newtab();
		}
		public void newtab () {
			var doc = new Document(current_win.tabs);
            current_win.tabs.add_doc (doc);
		}
	}
}
