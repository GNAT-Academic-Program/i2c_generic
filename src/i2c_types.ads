with Interfaces;
with System.Storage_Elements;

package I2C_Types is
   pragma Pure;

   subtype Byte is Interfaces.Unsigned_8;

   Bus_Fault : exception;

   type I2C_Address is mod 2**7 with Size => 7;

   subtype Storage_Element is System.Storage_Elements.Storage_Element;
   subtype Storage_Array   is System.Storage_Elements.Storage_Array;

   type Status_Kind is
      (Ok,
       Busy,
       Timeout,
       Nack,
       Arbitration_Lost,
       Bus_Error,
       Overrun,
       Unsupported,
       Invalid_Parameter,
       Error);

   type Status is record
      Kind : Status_Kind := Ok;
   end record;

   function Success (S : Status) return Boolean is (S.Kind = Ok);

   type Bus_Speed_Kind is
     (Standard_Mode,   -- 100 kHz
      Fast_Mode,       -- 400 kHz
      Fast_Mode_Plus,  -- 1 MHz
      High_Speed_Mode  -- 3.4 MHz, if supported
     );

   type Controller_Role_Kind is
     (Master_Only
      --  Slave support can be added later if you really want it
     );

   type Direction is (Write, Read) with Size => 1;
   for Direction use (Write => 0, Read  => 1);

   type I2C_Config is record
      Speed   : Bus_Speed_Kind     := Standard_Mode;
      Role    : Controller_Role_Kind := Master_Only;
   end record;

end I2C_Types;