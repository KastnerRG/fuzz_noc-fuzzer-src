/*

1> this sequence read transactions from binary file, transfer that to transaction, send to sequence.
2> communicate with AFL through AFL-proxy
3> hardware grammar: transcations(packets) are sent to port(ESNWP) one by one 

*/


<%
     X_SIZE = 3
     Y_SIZE = 3
     router_queue = []
     for i in range(0,X_SIZE):
          for j in range(0,Y_SIZE):
               router_this = str(i) + '_' + str(j)
               router_queue.append(router_this)
%>


class mesh_virtual_sequence_fuzz extends uvm_sequence;
   packet_transaction m_trans;

    bit[7:0] data[0:1000];    //buffer data from fuzzing input file
    int data_ptr;                   //point which data has be iterated
    int data_len;
    int packets_num; 
   
   `uvm_object_utils(mesh_virtual_sequence_fuzz)
   `uvm_declare_p_sequencer(mesh_virtual_sequencer) 

   function new(string name = "mesh_virtual_sequence_fuzz");
      super.new(name);
      data_ptr = 0;
   endfunction

   virtual task body();
      string file_name;
      int file_handle;
      int file_size;

      <%
      print('')
      for r in router_queue:
         print("  router_sequence seq_{};".format(r))
      
      print('')
      for r in router_queue:
         print("  seq_{} = router_sequence::type_id::create(\"seq_{}\");".format(r,r))
      %>
      
      // read input files from fuzzing env
      file_name = "../input";
      file_handle = $fopen(file_name, "rb");
      if (file_handle == 0) begin
          $display("Error: could not open file %s", file_name);
          $finish;
      end
      // Read the binary data into the byte array
      data_len = $fread(data, file_handle);
      if (data_len == 0) begin
          $display("Error: could not read file %s", file_name);
          $finish;
      end

      $fclose(file_handle);

      // each transaction takes 4 bytes
      packets_num = data_len/4;
   
      <%
         for r in router_queue:
            print("     for(int i=0; i<packets_num/{}; i++) begin".format(X_SIZE*Y_SIZE))
            print("        m_trans = new(\"tr\");")
            print("        generate_next_transaction(m_trans);")
            print("        seq_{}.trans_q.push_front(m_trans);\n".format(r))
            print("     end")
      %> 
      
      fork
         <%
            print('')
            for r in router_queue:
               print("            seq_{}.start(p_sequencer.sqr_{}); ".format(r,r))
         %>
      join

      // wait for last packet finish
      #300000;
         
   endtask


   task generate_packet(packet_transaction m_trans, int free_flag, bit[`PAYLOAD_LEN-1:0] payload_len, bit[`CHIP_ID_WIDTH-1:0] dst_chip_id, bit[`XY_WIDTH-1:0] dst_x, bit[`XY_WIDTH-1:0] dst_y, bit[`FINAL_BITS-1:0] final_bits);
      bit [`HEADER_LEFT-1:0] header_left_rand;
      bit [`DATA_WIDTH-1:0] payload_flit_rand;
  
      // generate free packet
      if(free_flag) begin
          m_trans.payload = new[1];
          m_trans.payload_len = payload_len;
          m_trans.payload[0] = `DATA_WIDTH'b0;  //free flag
          return;
      end
  
      // generate valid packet
      m_trans.payload_len = payload_len;
      m_trans.dst_chip_id = dst_chip_id;
      m_trans.dst_x = dst_x;
      m_trans.dst_y = dst_y;
      m_trans.final_bits = final_bits;
      m_trans.payload = new[m_trans.payload_len + 1];
  
      header_left_rand = {$urandom} % (2**`HEADER_LEFT);
      m_trans.payload[0] = { m_trans.dst_chip_id, m_trans.dst_x, m_trans.dst_y, m_trans.final_bits, m_trans.payload_len, header_left_rand};  //header
      
      for(int i=0; i<m_trans.payload_len; i++) begin       //payload
          payload_flit_rand[`DATA_WIDTH-1:`DATA_WIDTH-32] = {$urandom};
          payload_flit_rand[`DATA_WIDTH-33:0] = {$urandom};
          m_trans.payload[i+1] = payload_flit_rand;
      end
  endtask

  //translate byte array to transaction
  //hardware grammar
  task generate_next_transaction(packet_transaction m_trans);
      int free_flag = 0;
      bit[`PAYLOAD_LEN-1:0] payload_len;
      bit[`XY_WIDTH-1:0] dst_x;
      bit[`XY_WIDTH-1:0] dst_y;
      bit[`FINAL_BITS-1:0] final_bits;
      bit[`CHIP_ID_WIDTH-1:0] dst_chip_id;
      bit[7:0] next_byte;
      
      // free_flag;
      next_byte = get_one_byte();
      if(next_byte<51) free_flag = 1;

      
      //payload len
      next_byte = get_one_byte();
      payload_len = next_byte % 20;

      // //dst_x,y
      next_byte = get_one_byte();
      dst_x = next_byte % (`LOC_X_MAX+1);
      next_byte = get_one_byte();
      dst_y = next_byte % (`LOC_Y_MAX+1);
      
      // // crv average dist
      // // dst_x dist {`LOC_X:=60, [$:`LOC_X-1]:=20, [`LOC_X+1:`LOC_X_MAX]:=20};
      // // dst_y dist {`LOC_Y:=34, [$:`LOC_Y-1]:=33, [`LOC_Y+1:`LOC_Y_MAX]:=33};
      // next_byte = get_one_byte();
      // if(next_byte<153) dst_x = `LOC_X;
      // else if(next_byte<204) dst_x = next_byte%`LOC_X;
      // else dst_x = next_byte%(`LOC_X_MAX-`LOC_X)+`LOC_X+1;
      // next_byte = get_one_byte();
      // if(next_byte<87) dst_y = `LOC_Y;
      // else if(next_byte<171) dst_y = next_byte%`LOC_Y;
      // else dst_y = next_byte%(`LOC_Y_MAX-`LOC_Y)+`LOC_Y+1;

      final_bits = `FINAL_NONE;
      dst_chip_id = `CHIP_ID;

      generate_packet(m_trans, free_flag, payload_len, dst_chip_id, dst_x, dst_y, final_bits);
      
  endtask

  function bit[7:0] get_one_byte();
      bit[7:0] ret = data[data_ptr];
      data_ptr++;
      return ret;
  endfunction

endclass