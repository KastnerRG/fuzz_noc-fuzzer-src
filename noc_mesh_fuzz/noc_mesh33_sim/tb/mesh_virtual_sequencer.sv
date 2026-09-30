
class mesh_virtual_sequencer extends uvm_sequencer;
    
    router_sequencer sqr_0_0;
    router_sequencer sqr_0_1;
    router_sequencer sqr_0_2;
    router_sequencer sqr_1_0;
    router_sequencer sqr_1_1;
    router_sequencer sqr_1_2;
    router_sequencer sqr_2_0;
    router_sequencer sqr_2_1;
    router_sequencer sqr_2_2;


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction 
     
    `uvm_component_utils(mesh_virtual_sequencer)

endclass