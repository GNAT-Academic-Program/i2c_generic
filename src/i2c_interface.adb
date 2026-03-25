package body I2C_Interface is

   ----------
   -- Open --
   ----------

   procedure Open
     (Dev    : in out Device;
      Cfg    : I2C_Types.I2C_Config;
      Result : out I2C_Types.Status)
   is
   begin
      --Control.Init (Dev, Cfg, Result);
      Control.Init (Dev, Cfg, Result);

      --  if I2C_Types.Success (Result) then
      --     Control.Enable (Dev, Result);
      --  end if;
      Control.Enable (Dev, Result);
   end Open;


   -----------
   -- Close --
   -----------

   procedure Close
     (Dev    : in out Device;
      Result : out I2C_Types.Status)
   is
   begin
      Control.Disable (Dev, Result);
   end Close;


   -----------
   -- Write --
   -----------

   procedure Write
     (Dev     : in out Device;
      Target  : I2C_Types.I2C_Address;
      Buf     : System.Storage_Elements.Storage_Array;
      Written : out Natural;
      Result  : out I2C_Types.Status)
   is
   begin
      -- Data.Write (Dev, Target, Buf, Written, Result);
      Data.Write (Dev, Target, Buf);
      Written := Natural (Buf'Length);
      Result.Kind := I2C_Types.Ok;
   end Write;


   ----------
   -- Read --
   ----------

   procedure Read
     (Dev    : in out Device;
      Target : I2C_Types.I2C_Address;
      Buf    : out System.Storage_Elements.Storage_Array;
      Read   : out Natural;
      Result : out I2C_Types.Status)
   is
   begin
      --Data.Read (Dev, Target, Buf, Read, Result);
      Data.Read (Dev, Target, Buf);
      Read := Natural (Buf'Length);
      Result.Kind := I2C_Types.Ok;
   end Read;


   ----------------
   -- Write_Read --
   ----------------

   procedure Write_Read
     (Dev         : in out Device;
      Target      : I2C_Types.I2C_Address;
      Tx_Buf      : System.Storage_Elements.Storage_Array;
      Tx_Written  : out Natural;
      Rx_Buf      : out System.Storage_Elements.Storage_Array;
      Rx_Read     : out Natural;
      Result      : out I2C_Types.Status)
   is
   begin
      Data.Write_Read
        (Dev,
         Target,
         Tx_Buf,
         Rx_Buf);
      Tx_Written := Natural (Tx_Buf'Length);
      Rx_Read := Natural (Rx_Buf'Length);
      Result.Kind := I2C_Types.Ok;
      --  Data.Write_Read
      --    (Dev,
      --     Target,
      --     Tx_Buf,
      --     Tx_Written,
      --     Rx_Buf,
      --     Rx_Read);
   end Write_Read;


   -------------
   -- Recover --
   -------------

   procedure Recover
     (Dev    : in out Device;
      Result : out I2C_Types.Status)
   is
   begin
      Control.Recover_Bus (Dev, Result);
   end Recover;

end I2C_Interface;