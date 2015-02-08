// Shit. This is a C# file, not a C/C++ file.
// I'll have to reverse engineer this shit into a language I can compile

namespace bxl {
   public class Decoder {
       static uchar[]  source_buffer;
       public bool     is_filled   { get; private set; default = false; }
       public int      max_level   { get; private set; default = 8; }
       public int      node_count  { get; private set; default = -1; }
       public int      leaf_count  { get;  set; default = 0; }
       public int      level       { get; private set; default = 0; }
       public Node     root        { get; private set; default = null; }

       protected class Node {
           public int      level       { get; private set; default = 0; }
           public Node     parent      { get; set; default = null; }
           public Node     left        { get; set; default = null; }
           public Node     right       { get; set; default = null; }
           public int      symbol      { get; private set; default = -1; }
           public int      weight      { get; set; default = 0; }

           public Node (Node? parent, int symbol) {
               if (parent != null) {
                   this.parent = parent;
                   this.level  = parent.level+1;
               } else {
                   this.level = 0;
               }
               if (level > 7) {
                   this.symbol = symbol;
               }
           }

           public Node? add_child(int symbol){
               Node ret = null;
               if (level  7);
           }

           public Node? sibling(Node node){
               if  (node != right) {
                   return right;
               } else  {
                   return left;
               }
           }

           public bool need_swapping() {
               if (parent != null &&
                   parent.parent != null && // root node
                   weight  > parent.weight) {
                       return true;
               }
               return false;
           }
       }

       public Decoder (string filename) {
           create_tree();
           fill_buffer(filename);
       }

       private int read_next_bit(ref int source_index, ref int source_char, ref int bit) {
           int result = 0;
           if (bit < 0) {
               // Fetch next byte from source_buffer
               bit = 7;
               source_char = source_buffer[source_index];
               result = source_char & (1 << bit);
               source_index ++;
           } else {
               result = source_char & (1 << bit);
           }
           bit--;
           return result;
       }

       private void swap (Node n1, Node n2, Node? n3) {
           if (n3 != null)     {   n3.parent   = n1;}
           if (n1.right == n2) {   n1.right    = n3; return; }
           if (n1.left == n2)  {   n1.left     = n3; return; }
       }

       private void create_tree() {
           // create root node
           var node = new Node (null, 0);
           root = node;
           // fill levels
           while(node != null) {
               node = root.add_child(leaf_count);
               if(node != null && node.is_leaf()) { leaf_count++; }
           }
       }

       private void update_tree(Node? current) {
           if (current != null && current.need_swapping()) {
               var parent = current.parent;
               var grand_parent = parent.parent;
               var parent_sibling = grand_parent.sibling(parent);
               swap(grand_parent, parent,  current);
               swap(grand_parent, parent_sibling, parent);
               swap(parent,       current, parent_sibling);
               parent.weight       = parent.right.weight + parent.left.weight;
               grand_parent.weight = current.weight + parent.weight;
               update_tree(parent);
               update_tree(grand_parent);
               update_tree(current);

           }
       }

       private int uncompressed_size () {
            // Uncompressed size = 
               B0b7 * 1<<0 + B0b6 * 1<<1 + ... + B0b0 * 1<<7 +
               B1b7 * 1<<0 + B1b6 * 1<<1 + ... + B2b0 * 1<<7 +
               B2b7 * 1<<0 + B2b6 * 1<<1 + ... + B3b0 * 1<<7 +
               B3b7 * 1<<0 + B3b6 * 1<<1 + ... + B4b0 * 1<=0 ; i--) {
               if ((source_buffer[0] & (1 << i)) != 0) {
                   size |= (1 <=0 ; i--) {
               if ((source_buffer[1] & (1 << i)) != 0) {
                   size |= (1<=0 ; i--) {
               if ((source_buffer[2] & (1 << i)) != 0) {
                   size |= (1<=0 ; i--) {
               if ((source_buffer[3] & (1 << i)) != 0) {
                   size |= (1<<mask);
               }
               mask++;
           }
           return size;
       }

       public string decode() {
           var out_file_length = uncompressed_size ();
           var source_char = 0;
           var bit = 0;
           var source_index = 4;
           var sb = new StringBuilder();
           while (source_index < source_buffer.length && sb.len != out_file_length) {
               var node = root;
               while (!node.is_leaf()) {
                   // find leaf node
                   if (read_next_bit(ref source_index, ref source_char, ref bit) != 0) {
                       node = node.left;
                   } else {
                       node = node.right;
                   }
               }
               sb.append_c ((char)(node.symbol&0xff));
               node.weight+=1;
               update_tree(node);
           }
           source_buffer = null;
           is_filled = false;
           return sb.str;
       }

       public int fill_buffer(string filename) {
           try {
               var file = File.new_for_path (filename);
               var file_info = file.query_info ('*', FileQueryInfoFlags.NONE);

               source_buffer = new uchar[file_info.get_size ()];
               var file_stream = file.read ();
               size_t read = 0;

               file_stream.read_all(source_buffer, out read, null);
               if ( read == source_buffer.length) {
                   is_filled = true;
               }

           } catch (FileError e) {
               stderr.printf ('FileError: %s\n', e.message);
               return 1;
           } catch (Error e) {
               stderr.printf ('Error: %d %s\n', e.code, e.message);
               return 1;
           }

           return 0;
       }
   }
}