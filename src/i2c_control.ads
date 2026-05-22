with I2C_Types;

generic
   type Device is limited private;

   with procedure Driver_Init    (Dev : in out Device;
                                  Cfg : I2C_Types.I2C_Config);
   with procedure Driver_Enable  (Dev : in out Device);
   with procedure Driver_Disable (Dev : in out Device);
   with procedure Driver_Reset   (Dev : in out Device);
   with procedure Driver_Recover (Dev : in out Device);
   with procedure Driver_Probe   (Dev    : in out Device;
                                  Target : I2C_Types.I2C_Address;
                                  Result : out I2C_Types.Ack_State);

package I2C_Control is

   procedure Init    (Dev : in out Device;
                      Cfg : I2C_Types.I2C_Config);

   procedure Enable  (Dev : in out Device);

   procedure Disable (Dev : in out Device);

   procedure Reset   (Dev : in out Device);

   procedure Recover (Dev : in out Device);

   function Probe    (Dev    : in out Device;
                      Target : I2C_Types.I2C_Address)
                      return I2C_Types.Ack_State;

end I2C_Control;