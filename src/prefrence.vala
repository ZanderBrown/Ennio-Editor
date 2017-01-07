using Gtk;

namespace Ennio {
	[GtkTemplate (ui = "/io/github/michaelrutherford/Ennio-Editor/prefs.glade")]
	public class Prefrences : Popover {
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

		public Prefrences (Widget parent) {
			relative_to = parent;
			Application.settings.bind("editor-show-line-numbers", line_numbers, "active", SettingsBindFlags.DEFAULT);
			Application.settings.bind("editor-show-right-margin", right_margin, "active", SettingsBindFlags.DEFAULT);
			Application.settings.bind("editor-highlight-current-line", line_highlight, "active", SettingsBindFlags.DEFAULT);
			Application.settings.bind("editor-auto-indent", auto_indent, "active", SettingsBindFlags.DEFAULT);
			Application.settings.bind("editor-indent-on-tab", tab_indent, "active", SettingsBindFlags.DEFAULT);
		}
	}
}
