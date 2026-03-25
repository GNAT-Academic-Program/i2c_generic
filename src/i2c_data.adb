package body I2C_Data is

   procedure Write
      (Dev    : in out Device;
       Target : I2C_Types.I2C_Address;
       Buf    : System.Storage_Elements.Storage_Array)
   is
   begin
      Driver_Begin_Write_Segment (Dev, Target, Buf'Length, Auto_Stop => True);
      for I in Buf'Range loop
         Driver_Send_Byte (Dev, I2C_Types.Byte (Buf (I)));
      end loop;
   end Write;

   --  procedure Write
   --     (Dev     : in out Device;
   --      Target  : I2C_Types.I2C_Address;
   --      Buf     : System.Storage_Elements.Storage_Array)
   --  is
   --     Len : constant Natural := Natural (Buf'Length);
   --  begin
   --     Written := 0;

   --     if Len = 0 then
   --        Result.Kind := I2C_Types.Invalid_Parameter;
   --        return;
   --     end if;

   --     Result := Driver_Begin_Write_Segment (Dev, Target, Len, Auto_Stop => True);
   --     if not I2C_Types.Success (Result) then
   --        Driver_Stop (Dev);
   --        return;
   --     end if;

   --     for I in Buf'Range loop
   --        Result := Driver_Send_Byte (Dev, I2C_Types.Byte (Buf (I)));
   --        exit when not I2C_Types.Success (Result);
   --        Written := Written + 1;
   --     end loop;

   --     if not I2C_Types.Success (Result) then
   --        Driver_Stop (Dev);
   --     end if;
   --  end Write;

   --  procedure Write
   --     (Dev     : in out Device;
   --      Target  : I2C_Types.I2C_Address;
   --      Buf     : System.Storage_Elements.Storage_Array;
   --      Written : out Natural;
   --      Result  : out I2C_Types.Status)
   --  is
   --     Len : constant Natural := Natural (Buf'Length);
   --  begin
   --     Written := 0;

   --     if Len = 0 then
   --        Result.Kind := I2C_Types.Invalid_Parameter;
   --        return;
   --     end if;

   --     Result := Driver_Begin_Write_Segment (Dev, Target, Len, Auto_Stop => True);
   --     if not I2C_Types.Success (Result) then
   --        Driver_Stop (Dev);
   --        return;
   --     end if;

   --     for I in Buf'Range loop
   --        Result := Driver_Send_Byte (Dev, I2C_Types.Byte (Buf (I)));
   --        exit when not I2C_Types.Success (Result);
   --        Written := Written + 1;
   --     end loop;

   --     if not I2C_Types.Success (Result) then
   --        Driver_Stop (Dev);
   --     end if;
   --  end Write;

   procedure Read
      (Dev    : in out Device;
       Target : I2C_Types.I2C_Address;
       Buf    : out System.Storage_Elements.Storage_Array)
   is
      B : I2C_Types.Byte;
   begin
      Driver_Begin_Read_Segment (Dev, Target, Buf'Length, Auto_Stop => True);
      for I in Buf'Range loop
         Driver_Recv_Byte (Dev, B, (I /= Buf'Last));
         Buf (I) := Storage_Element (B);
      end loop;
   end Read;

   --  procedure Read
   --     (Dev    : in out Device;
   --      Target : I2C_Types.I2C_Address;
   --      Buf    : out System.Storage_Elements.Storage_Array;
   --      Read   : out Natural;
   --      Result : out I2C_Types.Status)
   --  is
   --     use System.Storage_Elements;
   --     Len : constant Natural := Natural (Buf'Length);
   --     B   : I2C_Types.Byte;
   --  begin
   --     Read := 0;

   --     if Len = 0 then
   --        Result.Kind := I2C_Types.Invalid_Parameter;
   --        return;
   --     end if;

   --     Result := Driver_Begin_Read_Segment (Dev, Target, Len, Auto_Stop => True);
   --     if not I2C_Types.Success (Result) then
   --        Driver_Stop (Dev);
   --        return;
   --     end if;

   --     for I in Buf'Range loop
   --        Buf (I) := 0;
   --     end loop;

   --     for I in Buf'Range loop
   --        Result := Driver_Recv_Byte (Dev, B, (I /= Buf'Last));
   --        exit when not I2C_Types.Success (Result);

   --        Buf (I) := Storage_Element (B);
   --        Read := Read + 1;
   --     end loop;

   --     if not I2C_Types.Success (Result) then
   --        Driver_Stop (Dev);
   --     end if;
   --  end Read;

   procedure Write_Read
      (Dev        : in out Device;
       Target     : I2C_Types.I2C_Address;
       Tx_Buf     : Storage_Array;
       Rx_Buf     : out Storage_Array)
   is
      B : I2C_Types.Byte;
   begin
      Driver_Begin_Write_Segment (Dev, Target, Tx_Buf'Length, Auto_Stop => False);
      for I in Tx_Buf'Range loop
         Driver_Send_Byte (Dev, I2C_Types.Byte (Tx_Buf (I)));
      end loop;

      Driver_Begin_Read_Segment (Dev, Target, Rx_Buf'Length, Auto_Stop => True);
      for I in Rx_Buf'Range loop
         Driver_Recv_Byte (Dev, B, (I /= Rx_Buf'Last));
         Rx_Buf (I) := Storage_Element (B);
      end loop;
   end Write_Read;

   --  procedure Write_Read
   --     (Dev         : in out Device;
   --      Target      : I2C_Types.I2C_Address;
   --      Tx_Buf      : System.Storage_Elements.Storage_Array;
   --      Tx_Written  : out Natural;
   --      Rx_Buf      : out System.Storage_Elements.Storage_Array;
   --      Rx_Read     : out Natural;
   --      Result      : out I2C_Types.Status)
   --  is
   --     use System.Storage_Elements;
   --     Tx_Len : constant Natural := Natural (Tx_Buf'Length);
   --     Rx_Len : constant Natural := Natural (Rx_Buf'Length);
   --     B      : I2C_Types.Byte;
   --  begin
   --     Tx_Written := 0;
   --     Rx_Read    := 0;

   --     if Tx_Len = 0 or else Rx_Len = 0 then
   --        Result.Kind := I2C_Types.Invalid_Parameter;
   --        return;
   --     end if;

   --     --  Register-address phase (no AUTOEND): repeated START will follow.
   --     Result := Driver_Begin_Write_Segment (Dev, Target, Tx_Len, Auto_Stop => False);
   --     if not I2C_Types.Success (Result) then
   --        Driver_Stop (Dev);
   --        return;
   --     end if;

   --     for I in Tx_Buf'Range loop
   --        Result := Driver_Send_Byte (Dev, I2C_Types.Byte (Tx_Buf (I)));
   --        exit when not I2C_Types.Success (Result);
   --        Tx_Written := Tx_Written + 1;
   --     end loop;

   --     if not I2C_Types.Success (Result) then
   --        Driver_Stop (Dev);
   --        return;
   --     end if;

   --     --  Payload phase with AUTOEND to let hardware emit STOP.
   --     Result := Driver_Begin_Read_Segment (Dev, Target, Rx_Len, Auto_Stop => True);
   --     if not I2C_Types.Success (Result) then
   --        Driver_Stop (Dev);
   --        return;
   --     end if;

   --     for I in Rx_Buf'Range loop
   --        Rx_Buf (I) := 0;
   --     end loop;

   --     for I in Rx_Buf'Range loop
   --        Result := Driver_Recv_Byte (Dev, B, (I /= Rx_Buf'Last));
   --        exit when not I2C_Types.Success (Result);

   --        Rx_Buf (I) := Storage_Element (B);
   --        Rx_Read := Rx_Read + 1;
   --     end loop;

   --     if not I2C_Types.Success (Result) then
   --        Driver_Stop (Dev);
   --     end if;
   --  end Write_Read;

end I2C_Data;
