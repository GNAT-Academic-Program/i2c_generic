with I2C_Types;
with I2C_Control;
with I2C_Data;
with System.Storage_Elements;

generic
   type Device is limited private;

   with package Control is new I2C_Control (Device => Device, others => <>);
   with package Data    is new I2C_Data    (Device => Device, others => <>);

package I2C_Interface is

   procedure Open
     (Dev    : in out Device;
      Cfg    : I2C_Types.I2C_Config;
      Result : out I2C_Types.Status);

   procedure Close
     (Dev    : in out Device;
      Result : out I2C_Types.Status);

   procedure Write
     (Dev     : in out Device;
      Target  : I2C_Types.I2C_Address;
      Buf     : System.Storage_Elements.Storage_Array;
      Written : out Natural;
      Result  : out I2C_Types.Status);

   procedure Read
     (Dev    : in out Device;
      Target : I2C_Types.I2C_Address;
      Buf    : out System.Storage_Elements.Storage_Array;
      Read   : out Natural;
      Result : out I2C_Types.Status);

   procedure Write_Read
     (Dev         : in out Device;
      Target      : I2C_Types.I2C_Address;
      Tx_Buf      : System.Storage_Elements.Storage_Array;
      Tx_Written  : out Natural;
      Rx_Buf      : out System.Storage_Elements.Storage_Array;
      Rx_Read     : out Natural;
      Result      : out I2C_Types.Status);

   procedure Recover
     (Dev    : in out Device;
      Result : out I2C_Types.Status);

end I2C_Interface;