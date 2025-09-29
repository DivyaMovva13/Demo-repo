
class router_test extends uvm_test;
`uvm_component_utils(router_test)

int no_of_wragents=1;
//int no_of_rdagents=3;
bit has_router_wr_agt_top=1;
//bit has_router_rd_agt_top=1;
//bit has_scoreboard=1;
//bit has_virtual_sequencer=1;

router_wr_agent_config w_cfg;
//router_rd_agent_config r_cfg[];
router_env_config cfg;
router_env env;

extern function new(string name="router_test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void end_of_elaboration_phase(uvm_phase phase);


endclass

function router_test:: new(string name="router_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_test:: build_phase(uvm_phase phase);
	
	cfg=router_env_config::type_id::create("cfg");
  
		w_cfg=router_wr_agent_config::type_id::create("w_cfg");
		if(!uvm_config_db #(virtual wr_in)::get(this,"","vif",w_cfg.vif))
			`uvm_fatal("TEST","cannot get config data");
      
		w_cfg.is_active=UVM_ACTIVE;
   
	  cfg.w_cfg=w_cfg;
	
	/*r_cfg=new[no_of_rdagents];
  cfg.r_cfg=new[no_of_rdagents];
 
  foreach(r_cfg[i])
	begin
		r_cfg[i]=router_rd_agent_config::type_id::create($sformatf("r_cfg[%0d]",i));
    
		if(!uvm_config_db #(virtual rd_in)::get(this,"",$sformatf("vif[%0d]",i),r_cfg[i].vif))
			`uvm_fatal("TEST","cannot get config data");
      
		r_cfg[i].is_active=UVM_ACTIVE;
   cfg.r_cfg[i]=r_cfg[i];
	  
  end*/
	
 
	cfg.no_of_wragents=no_of_wragents;
	//cfg.no_of_rdagents=no_of_rdagents;
  cfg.has_router_wr_agt_top=has_router_wr_agt_top;
  //cfg.has_router_rd_agt_top=has_router_rd_agt_top;
	//cfg.has_scoreboard=has_scoreboard;
	//cfg.has_virtual_sequencer=has_virtual_sequencer;
	
  uvm_config_db#(router_env_config) ::set(this,"*","router_env_config",cfg);
	super.build_phase(phase);
	env=router_env::type_id::create("env",this);
endfunction


function void router_test::end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
  uvm_top.print_topology();
endfunction		


//-----small----
class small_test extends router_test;
`uvm_component_utils(small_test)

router_wr_seq_small w_seq_s;


extern function new(string name="small_test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function small_test:: new(string name="small_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void small_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction		

task small_test::run_phase(uvm_phase phase);
super.run_phase(phase);
	w_seq_s=router_wr_seq_small::type_id::create("w_seq_s");
	
  phase.raise_objection(this);
	w_seq_s.start(env.w_ag_t.w_ag.wr_seqr);
	phase.drop_objection(this);
endtask


//--medium-----
class medium_test extends router_test;
`uvm_component_utils(medium_test)

router_wr_seq_medium w_seq_m;

extern function new(string name="medium_test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function medium_test:: new(string name="medium_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void medium_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction		

task medium_test::run_phase(uvm_phase phase);
super.run_phase(phase);
	w_seq_m=router_wr_seq_medium::type_id::create("w_seq_m");
	
  phase.raise_objection(this);
	w_seq_m.start(env.w_ag_t.w_ag.wr_seqr);
	phase.drop_objection(this);
endtask


//----------large--
class large_test extends router_test;
`uvm_component_utils(large_test)

router_wr_seq_large w_seq_l;


extern function new(string name="large_test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function large_test:: new(string name="large_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void large_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction		

task large_test::run_phase(uvm_phase phase);
super.run_phase(phase);
	w_seq_l=router_wr_seq_large::type_id::create("w_seq_l");
	
  phase.raise_objection(this);
	w_seq_l.start(env.w_ag_t.w_ag.wr_seqr);
	phase.drop_objection(this);
endtask


























