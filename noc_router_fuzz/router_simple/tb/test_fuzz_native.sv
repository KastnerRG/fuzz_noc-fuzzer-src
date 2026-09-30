`ifndef FUZZ_TEST__SV
`define FUZZ_TEST__SV
import "DPI-C" function void nocfuzzer_feedback(int errors, int disabled);
import "DPI-C" function void nocfuzzer_fatal();

// VCS normally turns UVM_FATAL into a successful $finish.
class nocfuzzer_report_catcher extends uvm_report_catcher;
   function new(string name = "nocfuzzer_report_catcher");
      super.new(name);
   endfunction
   virtual function action_e catch();
      if (get_severity() == UVM_FATAL) begin
         $display("NOCFUZZER_UVM_FATAL: %s", get_message());
         nocfuzzer_fatal();
      end
      return THROW;
   endfunction
endclass

class fuzz_test extends uvm_test;
   router_env env;
   virtual router_rst_if rst_vif;
   nocfuzzer_report_catcher catcher;
   `uvm_component_utils(fuzz_test)

   function new(string name = "fuzz_test", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      catcher = new();
      uvm_report_cb::add(null, catcher);
      env = router_env::type_id::create("env", this);
      if (!uvm_config_db#(virtual router_rst_if)::get(this, "", "rst_if", rst_vif))
         `uvm_fatal("fuzz_test", "reset signal must be set")
   endfunction

   task main_phase(uvm_phase phase);
      router_virtual_sequence_1 vseq;
      uvm_report_server server;
      int errors;
      phase.raise_objection(this);
      rst_vif.rst <= 1'b1;
      #1000;
      rst_vif.rst <= 1'b0;
      vseq = new();
      vseq.start(env.vsqr);
      // Check for dropped packets before accepting this individual testcase.
      env.scb.check_empty();
      server = get_report_server();
      errors = server.get_severity_count(UVM_ERROR) + server.get_severity_count(UVM_FATAL);
      $coverage_dump("nocfuzzer_case");
      // VCS writes the test data in the next simulation step.
      #1;
      nocfuzzer_feedback(errors, $test$plusargs("nocfuzzer_disable_feedback"));
      phase.drop_objection(this);
   endtask
endclass
`endif
