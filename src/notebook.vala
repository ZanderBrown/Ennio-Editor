using Gtk;

namespace Ennio {
	public class Notebook : Gtk.Notebook {
		public Document current {
			get {
				return (Document) this.get_nth_page(
					this.get_current_page()
				);
			}
		}
		public Notebook () {
			scrollable = true;
			show_border = false;
		}
		public void add_doc(Document doc) {
			var label = new DocumentLabel("Untitled");
			label.close_clicked.connect(() => {
				var pagenum = this.page_num(doc);
				this.remove_page(pagenum);
				if (this.get_n_pages() <= 0) {
					add_doc(new Document(this));
				}
			});
			this.set_current_page(this.append_page (doc, doc.label));
			this.set_tab_reorderable(doc, true);
			doc.show_all();
		}
	}
}
