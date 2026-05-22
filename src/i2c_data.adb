package body I2C_Data is

   procedure Write
     (Dev    : in out Device;
      Target : I2C_Types.I2C_Address;
      Buf    : Storage_Array)
   is
   begin
      Driver_Begin_Write (Dev, Target, Buf'Length, Stop => True);
      for I in Buf'Range loop
         Driver_Send (Dev, Buf (I));
      end loop;
   end Write;

   procedure Read
     (Dev    : in out Device;
      Target : I2C_Types.I2C_Address;
      Buf    : out Storage_Array)
   is
      B : Storage_Element;
   begin
      Driver_Begin_Read (Dev, Target, Buf'Length, Stop => True);
      for I in Buf'Range loop
         Driver_Recv (Dev, B, Ack => I /= Buf'Last);
         Buf (I) := B;
      end loop;
   end Read;

   procedure Write_Read
     (Dev    : in out Device;
      Target : I2C_Types.I2C_Address;
      Tx_Buf : Storage_Array;
      Rx_Buf : out Storage_Array)
   is
      B : Storage_Element;
   begin
      Driver_Begin_Write (Dev, Target, Tx_Buf'Length, Stop => False);
      for I in Tx_Buf'Range loop
         Driver_Send (Dev, Tx_Buf (I));
      end loop;

      Driver_Begin_Read (Dev, Target, Rx_Buf'Length, Stop => True);
      for I in Rx_Buf'Range loop
         Driver_Recv (Dev, B, Ack => I /= Rx_Buf'Last);
         Rx_Buf (I) := B;
      end loop;
   end Write_Read;

end I2C_Data;