using Gtk;

namespace Ennio {
    public class Window : ApplicationWindow {
		private HeaderBar hbar = new HeaderBar();
		private Box hbarleft = new Box (Orientation.HORIZONTAL, 0);
		private Box hbarright = new Box (Orientation.HORIZONTAL, 0);
		public Notebook tabs = new Notebook();
		private Button save = new Button.with_label ("Save");
		private Button open = new Button.with_label ("Open");
		public Window (Application app) {
			Object (application: app);
			set_titlebar(hbar);
			icon_name = "accessories-text-editor";
            hbar.subtitle = "Ennio Editor";
            hbar.title = "Unsaved";
			hbar.show_close_button = true;
			hbar.pack_start(hbarleft);
			hbar.pack_end(hbarright);
            var newfile = new Button.from_icon_name ("tab-new-symbolic", IconSize.BUTTON);
            newfile.action_name = "app.new";

            save.action_name = "win.save";
            open.action_name = "win.open";
            
            hbarleft.pack_start (open, false, false, 0);
            hbarleft.pack_start (newfile, false, false, 0);
            hbarleft.get_style_context().add_class ("linked");
            hbarright.pack_start (save, false, false, 0);

			tabs.switch_page.connect((page) => {
				title = ((DocumentLabel) tabs.get_tab_label(page)).text;
			});

			SimpleAction saveasact = new SimpleAction("saveas", null);
			saveasact.activate.connect(() => {
				tabs.current.saveas ();
			});
			this.add_action (saveasact);

			SimpleAction openact = new SimpleAction("open", null);
			openact.activate.connect(() => {
				if(!Application.settings.get_boolean("picker-in-dialog")) {
					var popover = new Popover(this.get_titlebar());
					var picker = new Box(Orientation.VERTICAL, 5);
					picker.margin = 5;
					var chooser = new FileChooserWidget(FileChooserAction.OPEN);
					chooser.select_multiple = false;
					picker.add(chooser);
					var btns = new Box(Orientation.HORIZONTAL, 0);
					btns.get_style_context().add_class("linked");
					btns.homogeneous = true;
					var openbtn = new Button.with_label("Open");
					openbtn.get_style_context().add_class("suggested-action");
					openbtn.clicked.connect(() => {
						var doc = new Document.from_file(tabs, chooser.get_file());
						tabs.add_doc (doc);
						popover.popdown();
					});
					var cancelbtn = new Button.with_label("Cancel");
					cancelbtn.clicked.connect(() => {
						popover.popdown();
					});
					btns.add(openbtn);
					btns.add(cancelbtn);
					picker.add(btns);
					picker.width_request = 500;
					picker.expand = false;
					picker.show_all();
					popover.add(picker);
					popover.popup();
				} else {
					var pick = new FileChooserDialog("Open", this,
						FileChooserAction.OPEN, "_Cancel",
						ResponseType.CANCEL, "_Open",                                           
						ResponseType.ACCEPT);
					pick.select_multiple = false;
					if (pick.run () == ResponseType.ACCEPT) {
						var doc = new Document.from_file(tabs, pick.get_file());
						tabs.add_doc (doc);
					}
					pick.destroy ();
				}
			});
			this.add_action (openact);

			SimpleAction saveact = new SimpleAction("save", null);
			saveact.activate.connect(() => {
				tabs.current.save();
			});
			this.add_action (saveact);

			var menu = new GLib.Menu ();
			menu.append ("Save As...", "win.saveas");

            var winmenu = new MenuButton();
            winmenu.image = new Image.from_icon_name("open-menu-symbolic", IconSize.MENU);
            winmenu.margin_start = 5;
            winmenu.menu_model = app.get_menu_by_id("win-menu");
			winmenu.use_popover = true;
            hbarright.pack_start (winmenu, false, false, 0);
            
            this.add (tabs);
            this.set_default_size (800, 700);
            this.window_position = WindowPosition.CENTER;
		}
    }
}
