class router_wr_dr extends uvm_driver #(write_xtn);
`uvm_component_utils(router_wr_dr);

virtual wr_in.W_DR_MP vif;
router_wr_agent_config w_cfg;

extern function new(string name="router_wr_dr",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(write_xtn xtn);

endclass

function router_wr_dr::new(string name="router_wr_dr",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_wr_dr::build_phase(uvm_phase phase);
super.build_phase(phase);

	if(!uvm_config_db #(router_wr_agent_config)::get(this,"","router_wr_agent_config",w_cfg))
		`uvm_fatal("dr","cannot get config data");
	
endfunction

function void router_wr_dr::connect_phase(uvm_phase phase);
	vif=w_cfg.vif;
endfunction

task router_wr_dr::run_phase(uvm_phase phase);
super.run_phase(phase);
	@(vif.w_dr_cb);
	vif.w_dr_cb.resetn<=0;
	@(vif.w_dr_cb);
  @(vif.w_dr_cb);
	vif.w_dr_cb.resetn<=1;
	forever
		begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done;
		end
endtask

task router_wr_dr::send_to_dut(write_xtn xtn);

	xtn.print;
	wait(~vif.w_dr_cb.busy)
	@(vif.w_dr_cb);
	vif.w_dr_cb.pkt_valid<=1;
	vif.w_dr_cb.data_in<=xtn.header;
	@(vif.w_dr_cb);
	for(int i=0;i<xtn.header[7:2];i++)
		begin
				wait(~vif.w_dr_cb.busy)
				vif.w_dr_cb.data_in<=xtn.payload_data[i];
				@(vif.w_dr_cb);
		end
	wait(~vif.w_dr_cb.busy)
	vif.w_dr_cb.pkt_valid<=0;
	vif.w_dr_cb.data_in<=xtn.parity;
	@(vif.w_dr_cb);
endtask
