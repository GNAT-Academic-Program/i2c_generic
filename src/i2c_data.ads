with I2C_Types;
with System.Storage_Elements; use System.Storage_Elements;

generic
   type Device is limited private;

   with procedure Driver_Begin_Write_Segment
      (Dev       : in out Device;
       Target    : I2C_Types.I2C_Address;
       Length    : Natural;
       Auto_Stop : Boolean);

   with procedure Driver_Begin_Read_Segment
     (Dev       : in out Device;
      Target    : I2C_Types.I2C_Address;
      Length    : Natural;
      Auto_Stop : Boolean);

   with procedure Driver_Stop
     (Dev    : in out Device);

   with procedure Driver_Send_Byte
     (Dev    : in out Device;
      B      : I2C_Types.Byte);

   with procedure Driver_Recv_Byte
     (Dev    : in out Device;
      B      : out I2C_Types.Byte;
      Ack    : Boolean);

package I2C_Data is

   procedure Write
     (Dev     : in out Device;
      Target  : I2C_Types.I2C_Address;
      Buf     : System.Storage_Elements.Storage_Array);

   procedure Read
     (Dev    : in out Device;
      Target : I2C_Types.I2C_Address;
      Buf    : out System.Storage_Elements.Storage_Array);

   procedure Write_Read
      (Dev        : in out Device;
       Target     : I2C_Types.I2C_Address;
       Tx_Buf     : Storage_Array;
       Rx_Buf     : out Storage_Array);

   --  procedure Write_Read
   --    (Dev         : in out Device;
   --     Target      : I2C_Types.I2C_Address;
   --     Tx_Buf      : System.Storage_Elements.Storage_Array;
   --     Tx_Written  : out Natural;
   --     Rx_Buf      : out System.Storage_Elements.Storage_Array;
   --     Rx_Read     : out Natural;
   --     Result      : out I2C_Types.Status);

end I2C_Data;
