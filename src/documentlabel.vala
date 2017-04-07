using Gtk;

namespace Ennio {
	public class DocumentLabel : Box {
		public signal void close_clicked();
		
		private Spinner spinner = new Spinner();
		
		public string text {
			get { return label.label; }
			set { label.label = value; }
		}
		
		private bool _unsaved;
		public bool unsaved {
			get {
				return _unsaved;
			}
			set {
				_unsaved = value;
				label.attributes = new Pango.AttrList();
				if (value) {
					label.attributes.change(Pango.attr_style_new(Pango.Style.ITALIC));
				} else {
					label.attributes.change(Pango.attr_style_new(Pango.Style.NORMAL));
				}
			}
		}
		
		public bool working {
			get { return spinner.active; }
			set { spinner.active = value; }
		}
		
		private Label label;
		public DocumentLabel(string label_text) {
			orientation = Orientation.HORIZONTAL;
			spacing = 5;
			tooltip_text = "This document has not been saved";

			pack_start(spinner, false, false, 0);

			label = new Label(label_text);
			label.expand = true;
			
			set_center_widget(label);

			var button = new Button();
			button.relief = ReliefStyle.NONE;
			button.focus_on_click = false;
			button.add(new Image.from_icon_name("window-close-symbolic", IconSize.MENU));
			button.clicked.connect(() => { close_clicked(); });
			button.get_style_context().add_class("close-tab-button");
			pack_end(button, false, false, 0);
			show_all();
		}
	}
}

