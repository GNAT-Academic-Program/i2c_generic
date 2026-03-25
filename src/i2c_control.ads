with I2C_Types;

generic
   type Device is limited private;

   with procedure Driver_Init
     (Dev    : in out Device;
      Cfg    : I2C_Types.I2C_Config);

   with procedure Driver_Enable
     (Dev    : in out Device;
      Result : out I2C_Types.Status);

   with procedure Driver_Disable
     (Dev    : in out Device;
      Result : out I2C_Types.Status);

   with procedure Driver_Reset
     (Dev    : in out Device;
      Result : out I2C_Types.Status);

   with procedure Driver_Recover_Bus
     (Dev    : in out Device;
      Result : out I2C_Types.Status);

package I2C_Control is

   procedure Init
     (Dev    : in out Device;
      Cfg    : I2C_Types.I2C_Config;
      Result : out I2C_Types.Status);

   procedure Enable
     (Dev    : in out Device;
      Result : out I2C_Types.Status);

   procedure Disable
     (Dev    : in out Device;
      Result : out I2C_Types.Status);

   procedure Reset
     (Dev    : in out Device;
      Result : out I2C_Types.Status);

   procedure Recover_Bus
     (Dev    : in out Device;
      Result : out I2C_Types.Status);

end I2C_Control;