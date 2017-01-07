using Gtk;

namespace Ennio {
	[GtkTemplate (ui = "/io/github/michaelrutherford/Ennio-Editor/prefs.glade")]
	public class Prefrences : Box {
		[GtkChild]
		private Switch line_numbers;

		[GtkChild]
		private Switch right_margin;

		[GtkChild]
		private Switch line_highlight;

		[GtkChild]
		private Switch auto_indent;

		[GtkChild]
		private Switch tab_indent;

		[GtkChild]
		private Switch prefs_dialog;

		[GtkChild]
		private Switch picker_dialog;

		[GtkChild]
		private Button reset;

		public Prefrences () {
			Application.settings.bind("editor-show-line-numbers", line_numbers, "active", SettingsBindFlags.DEFAULT);
			Application.settings.bind("editor-show-right-margin", right_margin, "active", SettingsBindFlags.DEFAULT);
			Application.settings.bind("editor-highlight-current-line", line_highlight, "active", SettingsBindFlags.DEFAULT);
			Application.settings.bind("editor-auto-indent", auto_indent, "active", SettingsBindFlags.DEFAULT);
			Application.settings.bind("editor-indent-on-tab", tab_indent, "active", SettingsBindFlags.DEFAULT);
			Application.settings.bind("prefs-in-dialog", prefs_dialog, "active", SettingsBindFlags.DEFAULT);
			Application.settings.bind("picker-in-dialog", picker_dialog, "active", SettingsBindFlags.DEFAULT);
		}

		public static void open (Window parent) {
			if(Application.settings.get_boolean("prefs-in-dialog")) {
				var dialog = new Dialog();
				dialog.transient_for = parent;
				dialog.get_content_area().add(new Prefrences());
				dialog.show_all();
			} else {
				var popover = new Popover(parent.get_titlebar());
				popover.add(new Prefrences());
				popover.popup();
			}
		}

		[GtkCallback]
		private void reset_all () {
			var popover = new Popover(reset);
			var box = new Box(Orientation.VERTICAL, 0);
			box.margin = 5;
			box.add(new Label("Reset all prefrences?"));
			var btn = new Button.with_label("Reset");
			btn.get_style_context().add_class("destructive-action");
			btn.clicked.connect(() => {
				foreach (var key in Application.settings.settings_schema.list_keys()) {
					Application.settings.reset(key);
				}
			});
			box.add(btn);
			box.show_all();
			popover.add(box);
			popover.popup();
		}
	}
}
