# i2c_generic

Generic I2C abstraction layer for bare-metal Ada applications.

## Overview

`i2c_generic` provides a hardware-independent I2C interface for embedded systems. It separates control and data operations through distinct generic packages, enabling flexible instantiation patterns and compile-time optimization for I2C master mode communication.

## Features

- Hardware-agnostic I2C abstraction
- Master mode support with configurable bus speeds (100 kHz, 400 kHz, 1 MHz)
- Separate control and data operation packages
- Combined interface package for convenience
- Support for Write, Read, and Write-Read transactions
- Type-safe 7-bit addressing
- Bus recovery and reset operations
- Zero runtime overhead through generic instantiation

## Architecture

The package is organized into three layers:

- **`I2C_Types`** - Common types and configuration records
- **`I2C_Control`** - Bus initialization, enable/disable, reset, and recovery
- **`I2C_Data`** - Transaction operations (write, read, write-read)
- **`I2C_Interface`** - Combined control and data interface (instantiates Control and Data internally)

## API

### I2C_Types

```ada
package I2C_Types is
   Bus_Fault : exception;
   
   type I2C_Address is mod 2**7 with Size => 7;
   
   subtype Storage_Element is System.Storage_Elements.Storage_Element;
   subtype Storage_Array   is System.Storage_Elements.Storage_Array;
   
   type Ack_State is (Nak, Ack);
   
   type Bus_Speed_Kind is
     (Standard_Mode,   -- 100 kHz
      Fast_Mode,       -- 400 kHz
      Fast_Mode_Plus); -- 1 MHz
   
   type Controller_Role_Kind is (Master_Only);
   
   type Direction is (Write, Read) with Size => 1;
   
   type I2C_Config is record
      Speed : Bus_Speed_Kind := Standard_Mode;
      Role  : Controller_Role_Kind := Master_Only;
   end record;
end I2C_Types;
```

### I2C_Interface

```ada
generic
   type Device_T is limited private;
   with procedure Driver_Init        (Dev : in out Device_T; Cfg : I2C_Types.I2C_Config);
   with procedure Driver_Enable      (Dev : in out Device_T);
   with procedure Driver_Disable     (Dev : in out Device_T);
   with procedure Driver_Reset       (Dev : in out Device_T);
   with procedure Driver_Recover     (Dev : in out Device_T);
   with procedure Driver_Probe       (Dev : in out Device_T; Target : I2C_Types.I2C_Address; Result : out I2C_Types.Ack_State);
   with procedure Driver_Begin_Write (Dev : in out Device_T; Target : I2C_Types.I2C_Address; Length : Natural; Stop : Boolean);
   with procedure Driver_Begin_Read  (Dev : in out Device_T; Target : I2C_Types.I2C_Address; Length : Natural; Stop : Boolean);
   with procedure Driver_Send        (Dev : in out Device_T; B : Storage_Element);
   with procedure Driver_Recv        (Dev : in out Device_T; B : out Storage_Element; Ack : Boolean);
package I2C_Interface is
   subtype Device is Device_T;
   
   procedure Open    (Dev : in out Device; Cfg : I2C_Types.I2C_Config);
   procedure Close   (Dev : in out Device);
   procedure Reset   (Dev : in out Device);
   procedure Recover (Dev : in out Device);
   function Probe    (Dev : in out Device; Target : I2C_Types.I2C_Address) return Boolean;
   procedure Write   (Dev : in out Device; Target : I2C_Types.I2C_Address; Buf : Storage_Array);
   procedure Read    (Dev : in out Device; Target : I2C_Types.I2C_Address; Buf : out Storage_Array);
   procedure Write_Read (Dev : in out Device; Target : I2C_Types.I2C_Address; Tx_Buf : Storage_Array; Rx_Buf : out Storage_Array);
end I2C_Interface;
```

## Usage

### 1. Implement Hardware Driver Layer

Create a hardware-specific generic package with device type and driver procedures. Example for STM32:

```ada
generic
   Periph : not null access STM32_I2C_Peripheral;
   with function Get_Clock return Natural;
   with procedure RCC_Enable;
   with procedure RCC_Reset;
package MCU_I2C is
   type Device is limited private;
   function Make_Device return Device;
   
   procedure Init    (Dev : in out Device; Cfg : I2C_Types.I2C_Config);
   procedure Enable  (Dev : in out Device);
   procedure Disable (Dev : in out Device);
   procedure Reset   (Dev : in out Device);
   procedure Recover (Dev : in out Device);
   procedure Probe   (Dev : in out Device; Target : I2C_Types.I2C_Address; Result : out I2C_Types.Ack_State);
   
   procedure Begin_Write (Dev : in out Device; Target : I2C_Types.I2C_Address; Length : Natural; Stop : Boolean);
   procedure Begin_Read  (Dev : in out Device; Target : I2C_Types.I2C_Address; Length : Natural; Stop : Boolean);
   procedure Send        (Dev : in out Device; B : Storage_Element);
   procedure Recv        (Dev : in out Device; B : out Storage_Element; Ack : Boolean);
end MCU_I2C;
```

### 2. Instantiate MCU-Level Package

```ada
package I2C_Instance is new MCU_I2C
  (Periph     => I2C2_Periph'Access,
   Get_Clock  => Clock_Tree.Get_I2C2_Clock,
   RCC_Enable => Clock_Tree.Enable_I2C2,
   RCC_Reset  => Clock_Tree.Reset_I2C2);
```

### 3. Instantiate Board-Level Interface

```ada
package I2C_Bus is new I2C_Interface
  (Device_T           => I2C_Instance.Device,
   Driver_Init        => I2C_Instance.Init,
   Driver_Enable      => I2C_Instance.Enable,
   Driver_Disable     => I2C_Instance.Disable,
   Driver_Reset       => I2C_Instance.Reset,
   Driver_Recover     => I2C_Instance.Recover,
   Driver_Probe       => I2C_Instance.Probe,
   Driver_Begin_Write => I2C_Instance.Begin_Write,
   Driver_Begin_Read  => I2C_Instance.Begin_Read,
   Driver_Send        => I2C_Instance.Send,
   Driver_Recv        => I2C_Instance.Recv);

I2C_Dev : aliased I2C_Bus.Device := I2C_Instance.Make_Device;
```

### 4. Use I2C

```ada
I2C_Bus.Open (I2C_Dev, (Speed => I2C_Types.Fast_Mode, Role => I2C_Types.Master_Only));

if I2C_Bus.Probe (I2C_Dev, 16#76#) then
   I2C_Bus.Write_Read (I2C_Dev, 16#76#, (1 => 16#D0#), Chip_ID);
end if;
```

## Transaction Examples

Probe for device presence:

```ada
if I2C_Bus.Probe (Dev, 16#76#) then
   -- Device responded
end if;
```

Write single register:

```ada
I2C_Bus.Write (Dev, Sensor_Addr, (Reg_Addr, Value));
```

Read multiple bytes:

```ada
Data : I2C_Types.Storage_Array (1 .. 8);
I2C_Bus.Read (Dev, Sensor_Addr, Data);
```

Write-Read (register read pattern):

```ada
Reg : constant I2C_Types.Storage_Array := (1 => 16#2A#);
Val : I2C_Types.Storage_Array (1 .. 2);
I2C_Bus.Write_Read (Dev, Sensor_Addr, Reg, Val);
```

Bus recovery after fault:

```ada
I2C_Bus.Recover (Dev);
```

## Design Rationale

### Separate Control and Data Packages

Splitting initialization and transaction operations allows different access patterns: configuration once at startup, data operations in application loops.

### Limited Private Device Type

The `Device` type is limited private, preventing accidental copying and ensuring single ownership of hardware resources.

### Generic Instantiation

Hardware abstraction through generics provides zero runtime overhead with no virtual dispatch, compile-time binding to hardware drivers, and type safety.

### Layered Architecture

The separation between generic interface, MCU driver, MCU-level instance, board-level facade, and device object enables portability and clear separation of concerns.

## Integration

Add to your `alire.toml`:

```toml
[[depends-on]]
i2c_generic = "^0.1.0"
```

## License

MIT OR Apache-2.0 WITH LLVM-exception
