package body I2C_Control is

   -----------
   -- Init --
   -----------

   procedure Init
     (Dev    : in out Device;
      Cfg    : I2C_Types.I2C_Config;
      Result : out I2C_Types.Status)
   is
   begin
      Driver_Init (Dev, Cfg);
      Result.Kind := I2C_Types.Ok; 
   end Init;

   -------------
   -- Enable --
   -------------

   procedure Enable
     (Dev    : in out Device;
      Result : out I2C_Types.Status)
   is
   begin
      Driver_Enable (Dev, Result);
   end Enable;


   --------------
   -- Disable --
   --------------

   procedure Disable
     (Dev    : in out Device;
      Result : out I2C_Types.Status)
   is
   begin
      Driver_Disable (Dev, Result);
   end Disable;


   -----------
   -- Reset --
   -----------

   procedure Reset
     (Dev    : in out Device;
      Result : out I2C_Types.Status)
   is
   begin
      Driver_Reset (Dev, Result);
   end Reset;


   -----------------
   -- Recover_Bus --
   -----------------

   procedure Recover_Bus
     (Dev    : in out Device;
      Result : out I2C_Types.Status)
   is
   begin
      Driver_Recover_Bus (Dev, Result);
   end Recover_Bus;

end I2C_Control;