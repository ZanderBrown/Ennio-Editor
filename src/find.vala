using Gtk;

namespace Ennio {
	[GtkTemplate (ui = "/io/github/michaelrutherford/Ennio-Editor/find.glade")]
	public class Find : Popover {
		[GtkChild]
		private Entry entry;

		[GtkChild]
		private Entry replace_entry;

		[GtkChild]
		private Revealer replace_wrap;

		private TextIter iter;
		private TextIter current_start = TextIter();
		private TextIter current_end = TextIter();
		
		private SourceSearchContext context;
		private Document doc;

		public Find (Document doc) {
			this.doc = doc;
			relative_to = doc.label;
			context = new SourceSearchContext(doc.buffer, null);
			context.highlight = true;
			doc.buffer.get_iter_at_mark(out iter, doc.buffer.get_insert());
		}

		[GtkCallback]
		private void search () {
			doc.buffer.get_iter_at_mark(out iter, doc.buffer.get_insert());
			context.settings.search_text = entry.text;
		}

		[GtkCallback]
		private void replace () {
			print(replace_entry.text);
		}

		[GtkCallback]
		private void replace_toggled (ToggleButton btn) {
			replace_wrap.reveal_child = btn.active;
		}

		[GtkCallback]
		private void next () {
			doc.status = "Next";
			context.forward_async.begin (iter, null, (start, end) => {
				/*current_start = start;
				current_end = end;*/
			});
		}

		[GtkCallback]
		private void last () {
			doc.status = "Last";
			context.backward_async.begin (iter, null, (start, end) => {
				/*current_start = start;
				current_end = end;*/
			});
		}

		[GtkCallback]
		private void close () {
			this.popdown();
		}
	}
}
