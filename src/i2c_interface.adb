with I2C_Control;
with I2C_Data;

package body I2C_Interface is

   package Control is new I2C_Control
     (Device         => Device,
      Driver_Init    => Driver_Init,
      Driver_Enable  => Driver_Enable,
      Driver_Disable => Driver_Disable,
      Driver_Reset   => Driver_Reset,
      Driver_Recover => Driver_Recover,
      Driver_Probe   => Driver_Probe);

   package Data is new I2C_Data
     (Device             => Device,
      Driver_Begin_Write => Driver_Begin_Write,
      Driver_Begin_Read  => Driver_Begin_Read,
      Driver_Send        => Driver_Send,
      Driver_Recv        => Driver_Recv);

   procedure Open
     (Dev : in out Device;
      Cfg : I2C_Types.I2C_Config)
   is
   begin
      Control.Init   (Dev, Cfg);
      Control.Enable (Dev);
   end Open;

   procedure Close (Dev : in out Device) is
   begin
      Control.Disable (Dev);
   end Close;

   procedure Reset (Dev : in out Device) is
   begin
      Control.Reset (Dev);
   end Reset;

   procedure Recover (Dev : in out Device) is
   begin
      Control.Recover (Dev);
   end Recover;

   function Probe
     (Dev    : in out Device;
      Target : I2C_Types.I2C_Address) return Boolean
   is
      use type I2C_Types.Ack_State;
   begin
      return Control.Probe (Dev, Target) = I2C_Types.Ack;
   end Probe;

   procedure Write
     (Dev    : in out Device;
      Target : I2C_Types.I2C_Address;
      Buf    : Storage_Array)
   is
   begin
      Data.Write (Dev, Target, Buf);
   end Write;

   procedure Read
     (Dev    : in out Device;
      Target : I2C_Types.I2C_Address;
      Buf    : out Storage_Array)
   is
   begin
      Data.Read (Dev, Target, Buf);
   end Read;

   procedure Write_Read
     (Dev    : in out Device;
      Target : I2C_Types.I2C_Address;
      Tx_Buf : Storage_Array;
      Rx_Buf : out Storage_Array)
   is
   begin
      Data.Write_Read (Dev, Target, Tx_Buf, Rx_Buf);
   end Write_Read;

end I2C_Interface;