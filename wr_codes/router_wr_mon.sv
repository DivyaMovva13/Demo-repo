class router_wr_mon extends uvm_monitor;
`uvm_component_utils(router_wr_mon);

virtual wr_in.W_MON_MP vif;
router_wr_agent_config w_cfg;
uvm_analysis_port #(write_xtn) ap_w;
write_xtn xtn;

extern function new(string name="router_wr_mon",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data;

endclass

function router_wr_mon::new(string name="router_wr_mon",uvm_component parent);
	super.new(name,parent);
	
endfunction

function void router_wr_mon::build_phase(uvm_phase phase);
super.build_phase(phase);
	if(!uvm_config_db #(router_wr_agent_config)::get(this,"","router_wr_agent_config",w_cfg))
		`uvm_fatal("mon","cannot get config data");
	
endfunction

function void router_wr_mon::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=w_cfg.vif;
endfunction

task router_wr_mon::run_phase(uvm_phase phase);
	forever
		collect_data;
endtask

task router_wr_mon::collect_data;

  xtn=write_xtn::type_id::create("xtn");
  wait(~vif.w_mon_cb.busy)
	wait(vif.w_mon_cb.pkt_valid)
	xtn.header=vif.w_mon_cb.data_in;
	xtn.payload_data=new[xtn.header[7:2]];
	@(vif.w_mon_cb);
	for(int i=0;i<xtn.header[7:2];i++)
		begin
				wait(~vif.w_mon_cb.busy)
				xtn.payload_data[i]=vif.w_mon_cb.data_in;
				@(vif.w_mon_cb);
		end
	wait(~vif.w_mon_cb.busy)
	xtn.parity=vif.w_mon_cb.data_in;
  repeat(2)
  @(vif.w_mon_cb);
  xtn.err=vif.w_mon_cb.err;
	xtn.print();
	
	ap_w.write(xtn);
endtask
