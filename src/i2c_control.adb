package body I2C_Control is

   procedure Init
     (Dev : in out Device;
      Cfg : I2C_Types.I2C_Config)
   is
   begin
      Driver_Init (Dev, Cfg);
   end Init;

   procedure Enable (Dev : in out Device) is
   begin
      Driver_Enable (Dev);
   end Enable;

   procedure Disable (Dev : in out Device) is
   begin
      Driver_Disable (Dev);
   end Disable;

   procedure Reset (Dev : in out Device) is
   begin
      Driver_Reset (Dev);
   end Reset;

   procedure Recover (Dev : in out Device) is
   begin
      Driver_Recover (Dev);
   end Recover;

   function Probe
     (Dev    : in out Device;
      Target : I2C_Types.I2C_Address)
      return I2C_Types.Ack_State
   is
      Result : I2C_Types.Ack_State;
   begin
      Driver_Probe (Dev, Target, Result);
      return Result;
   end Probe;

end I2C_Control;