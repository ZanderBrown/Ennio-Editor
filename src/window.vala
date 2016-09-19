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

            save.action_name = "app.save";
            open.action_name = "app.open";
            
            hbarleft.pack_start (open, false, false, 0);
            hbarleft.pack_start (newfile, false, false, 0);
            hbarleft.get_style_context().add_class ("linked");
            hbarright.pack_start (save, false, false, 0);

			tabs.switch_page.connect((page) => {
				title = ((DocumentLabel) tabs.get_tab_label(page)).text;
			});
            
            this.add (tabs);
            this.set_default_size (800, 700);
            this.window_position = WindowPosition.CENTER;

			const Gtk.TargetEntry[] targets = {
				{"text/uri-list", 0, 0}
			};
            drag_dest_set (this, DestDefaults.ALL, targets, Gdk.DragAction.COPY);
			this.drag_data_received.connect ((widget, drag_context, x, y, data, info, time) => {
				var dialog = new MessageDialog (this,
                                           DialogFlags.MODAL |
                                           DialogFlags.DESTROY_WITH_PARENT,
                                           MessageType.INFO,
                                           ButtonsType.YES_NO,
                                           "Drag Received");
				dialog.run();
				foreach(var uri in data.get_uris ()){
					var dialog2 = new MessageDialog (this,
											   DialogFlags.MODAL |
											   DialogFlags.DESTROY_WITH_PARENT,
											   MessageType.INFO,
											   ButtonsType.YES_NO,
											   uri);
					dialog2.run();
					var doc = new Document.from_file(tabs, File.new_for_uri(uri));
					tabs.add_doc (doc);
				}

				drag_finish (drag_context, true, false, time);
			});
		}
    }
}
