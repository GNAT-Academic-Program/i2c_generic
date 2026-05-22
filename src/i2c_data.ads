with I2C_Types;
with System.Storage_Elements; use System.Storage_Elements;

generic
   type Device is limited private;

   with procedure Driver_Begin_Write (Dev    : in out Device;
                                      Target : I2C_Types.I2C_Address;
                                      Length : Natural;
                                      Stop   : Boolean);
   with procedure Driver_Begin_Read  (Dev    : in out Device;
                                      Target : I2C_Types.I2C_Address;
                                      Length : Natural;
                                      Stop   : Boolean);
   with procedure Driver_Send        (Dev    : in out Device;
                                      B      : Storage_Element);
   with procedure Driver_Recv        (Dev    : in out Device;
                                      B      : out Storage_Element;
                                      Ack    : Boolean);

package I2C_Data is

   procedure Write (Dev    : in out Device;
                    Target : I2C_Types.I2C_Address;
                    Buf    : Storage_Array);

   procedure Read  (Dev    : in out Device;
                    Target : I2C_Types.I2C_Address;
                    Buf    : out Storage_Array);

   procedure Write_Read (Dev    : in out Device;
                         Target : I2C_Types.I2C_Address;
                         Tx_Buf : Storage_Array;
                         Rx_Buf : out Storage_Array);

end I2C_Data;