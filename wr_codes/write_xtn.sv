
class write_xtn extends uvm_sequence_item;
`uvm_object_utils(write_xtn);
rand bit[7:0]header;
rand bit[7:0]payload_data[];
bit [7:0] parity;
bit err;

constraint addr{header[1:0]!=2'b11;}
constraint valid_length{header[7:2]!=0;}
constraint size{payload_data.size ==header[7:2];}


extern function new(string name = "write_xtn");
extern function void post_randomize();
extern function void do_print(uvm_printer printer);


endclass:write_xtn


	function write_xtn::new(string name = "write_xtn");
		super.new(name);
	endfunction:new

function void write_xtn::post_randomize();
	parity=header;
	foreach(payload_data[i])
		begin
		parity=payload_data[i]^parity;
		end
endfunction

function void  write_xtn::do_print (uvm_printer printer);
    super.do_print(printer);
   printer.print_field( "header",this.header,8,UVM_BIN);
   foreach(payload_data[i])
     printer.print_field( $sformatf("payload_data[%d]",i),this.payload_data[i],8,UVM_DEC);
   printer.print_field( "parity",this.parity,8,UVM_BIN);
   
   endfunction:do_print
   

    
 
 