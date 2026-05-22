with I2C_Types;
with System.Storage_Elements; use System.Storage_Elements;

generic
   type Device_T is limited private;

   with procedure Driver_Init        (Dev    : in out Device_T;
                                      Cfg    : I2C_Types.I2C_Config);
   with procedure Driver_Enable      (Dev    : in out Device_T);
   with procedure Driver_Disable     (Dev    : in out Device_T);
   with procedure Driver_Reset       (Dev    : in out Device_T);
   with procedure Driver_Recover     (Dev    : in out Device_T);
   with procedure Driver_Probe       (Dev    : in out Device_T;
                                      Target : I2C_Types.I2C_Address;
                                      Result : out I2C_Types.Ack_State);
   with procedure Driver_Begin_Write (Dev    : in out Device_T;
                                      Target : I2C_Types.I2C_Address;
                                      Length : Natural;
                                      Stop   : Boolean);
   with procedure Driver_Begin_Read  (Dev    : in out Device_T;
                                      Target : I2C_Types.I2C_Address;
                                      Length : Natural;
                                      Stop   : Boolean);
   with procedure Driver_Send        (Dev    : in out Device_T;
                                      B      : Storage_Element);
   with procedure Driver_Recv        (Dev    : in out Device_T;
                                      B      : out Storage_Element;
                                      Ack    : Boolean);

package I2C_Interface is

   subtype Device is Device_T;

   procedure Open    (Dev : in out Device;
                      Cfg : I2C_Types.I2C_Config);

   procedure Close   (Dev : in out Device);

   procedure Reset   (Dev : in out Device);

   procedure Recover (Dev : in out Device);

   function Probe    (Dev    : in out Device;
                      Target : I2C_Types.I2C_Address) return Boolean;
   --  True if Target ACKed its address. Never raises on NAK;
   --  raises Bus_Fault only on a genuine bus fault.

   procedure Write   (Dev    : in out Device;
                      Target : I2C_Types.I2C_Address;
                      Buf    : Storage_Array);

   procedure Read    (Dev    : in out Device;
                      Target : I2C_Types.I2C_Address;
                      Buf    : out Storage_Array);

   procedure Write_Read (Dev    : in out Device;
                         Target : I2C_Types.I2C_Address;
                         Tx_Buf : Storage_Array;
                         Rx_Buf : out Storage_Array);

end I2C_Interface;