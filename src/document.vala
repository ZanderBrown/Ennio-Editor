using Gtk;

namespace Ennio {
	public class Document : Overlay {
		public SourceBuffer buffer = new SourceBuffer(null);
		public SourceView text;
		public DocumentLabel label;
		public SourceFile file;
		public bool untitled { get; set; default = true; }
		private Notebook container;

		private Label statusbar = new Label(null);
		private uint? statusid = null;
		public string status {
			set {
				print(value);
				statusbar.label = value;
				statusbar.visible = true;
				if (statusid != null) {
					Source.remove(statusid);
				}
				statusid = Timeout.add(2500, () => {
					statusbar.visible = false;
					statusid = null;
					return false;
				});
			}
		}

		public Document (Notebook container) {
			this.container = container;
			text = new SourceView.with_buffer(buffer);
			text.wrap_mode = WrapMode.NONE;
			text.indent = 2;
			text.monospace = true;
			text.buffer.text = "";

			/* Bind Prefrences */
			// Bind auto-indent option
			Application.settings.bind("editor-auto-indent", text, "auto_indent", SettingsBindFlags.DEFAULT);

			// Bind tab indent setting
			Application.settings.bind("editor-indent-on-tab", text, "indent_on_tab", SettingsBindFlags.DEFAULT);

			// Bind the line number margin prefrence
			Application.settings.bind("editor-show-line-numbers", text, "show_line_numbers", SettingsBindFlags.DEFAULT);
			Application.settings.bind("editor-highlight-current-line", text, "highlight_current_line", SettingsBindFlags.DEFAULT);
			text.smart_home_end = SourceSmartHomeEndType.BEFORE;
			Application.settings.bind("editor-show-right-margin", text, "show_right_margin", SettingsBindFlags.DEFAULT);
			buffer.set_style_scheme(SourceStyleSchemeManager.get_default().get_scheme(Application.settings.get_string("colour-scheme")));
			Application.settings.changed["colour-scheme"].connect(() => {
				buffer.set_style_scheme(SourceStyleSchemeManager.get_default().get_scheme(Application.settings.get_string("colour-scheme")));
			});
			/* Bind Prefrences */

			var scroll = new ScrolledWindow(null, null);
			scroll.add (text);
			add(scroll);
			
			statusbar.get_style_context().add_class("statusbar");
			statusbar.halign = Align.CENTER;
			statusbar.valign = Align.CENTER;
			statusbar.no_show_all = true;
			statusbar.visible = false;
			add_overlay (statusbar);
			set_overlay_pass_through (statusbar, true);

			label = new DocumentLabel("Untitled");
			label.close_clicked.connect(() => {
				if (label.unsaved) {
					var confirm = new Popover(label);
					var box = new Box(Orientation.VERTICAL, 5);
					box.add(new Label("This document has unsaved changes"));
					var btns = new Box(Orientation.HORIZONTAL, 0);
					btns.get_style_context().add_class("linked");
					var savebtn = new Button.with_label("Save");
					savebtn.get_style_context().add_class("suggested-action");
					savebtn.clicked.connect(() => {
						save();
						close();
					});
					var discardbtn = new Button.with_label("Discard");
					discardbtn.get_style_context().add_class("destructive-action");
					discardbtn.clicked.connect(() => {
						close();
					});
					var cancelbtn = new Button.with_label("Cancel");
					cancelbtn.clicked.connect(() => {
						confirm.popdown();
					});
					btns.add(savebtn);
					btns.add(discardbtn);
					btns.add(cancelbtn);
					box.margin = 5;
					box.add(btns);
					confirm.add(box);
					box.show_all();
					confirm.popup();
				} else {
					close();
				}
			});
			buffer.changed.connect(() => {
				label.unsaved = true;
			});
			buffer.notify["can_undo"].connect(() => {
				((SimpleAction) ((Application) GLib.Application.get_default()).current_win.lookup_action("win.undo")).set_enabled(buffer.can_undo);
			});
			buffer.notify["can_redo"].connect(() => {
				((SimpleAction) ((Application) GLib.Application.get_default()).current_win.lookup_action("win.redo")).set_enabled(buffer.can_redo);
			});
		}
		
		public Document.from_file (Notebook container, File gfile) {
			this(container);
			untitled = false;
			var lm = new SourceLanguageManager();
			var language = lm.guess_language(gfile.get_path(), null);
			
			if (language != null) {
				buffer.language = language;
				buffer.highlight_syntax = true;
			} else {
				buffer.highlight_syntax = false;
			}

			label.text = gfile.get_basename();
			try {
				var info = gfile.query_info ("standard::*", FileQueryInfoFlags.NONE);
				tooltip_markup = "<b>" + gfile.get_path() + "</b>\nSize: " + format_size(info.get_size());
			} catch (Error e) {
				tooltip_text = gfile.get_path();
			}

			file = new SourceFile();
			file.location = gfile;
			var source_file_loader = new SourceFileLoader(buffer, file);
			label.unsaved = false;
			label.working = true;
			source_file_loader.load_async.begin (Priority.DEFAULT, null, () => {
				Timeout.add(5, () => {
					label.working = false;
					label.unsaved = false;
					return false;
				});
			});
		}
		
		private void close () {
			var pagenum = container.page_num(this);
			container.remove_page(pagenum);
			if (container.get_n_pages() <= 0) {
				container.add_doc(new Document(container));
			}
		}
		
		public void saveas () {
			var pick = new FileChooserDialog("Save As",
											 (Window) this.get_toplevel(),
											 FileChooserAction.SAVE,
											 "_Cancel",
											 ResponseType.CANCEL,
											 "_Save",
											 ResponseType.ACCEPT);
			pick.select_multiple = false;
			if (pick.run () == ResponseType.ACCEPT) {
				file = new SourceFile();
				file.location = pick.get_file();
				untitled = false;
				label.text = pick.get_file().get_basename();
				// FIX THIS
				label.tooltip_text = pick.get_file().get_path();
				pick.destroy ();
				save ();
			} else {
				pick.destroy ();
				return;
			}
		}
		
		public void save () {
			if (untitled) {
				saveas();
				return;
			}
			var source_file_saver = new SourceFileSaver(buffer, file);
			label.working = true;
			buffer.set_modified(false);
			source_file_saver.save_async.begin (Priority.DEFAULT, null, () => {
				label.unsaved = false;
				label.working = false;
				var lm = new SourceLanguageManager();
				var language = lm.guess_language(file.location.get_path(), null);
				if (language != null) {
					buffer.language = language;
					buffer.highlight_syntax = true;
				} else {
					buffer.highlight_syntax = false;
				}
			});
		}
	}
}
