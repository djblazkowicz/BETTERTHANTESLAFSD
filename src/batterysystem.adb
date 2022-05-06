with CarSystem; use CarSystem;
with Ada.Text_IO; use Ada.Text_IO;
package body batterysystem with SPARK_Mode is

   procedure CheckBatteryWarning (This : in out Car) is
   begin
      if This.battery <= MinCharge then
         This.isBatteryWarning := True;
      else This.isBatteryWarning := False;
      end if;
      if This.battery <= CriticalCharge then
         This.isBatteryCritical := True;
      else This.isBatteryCritical := False;
      end if;     
   end CheckBatteryWarning;
   
   procedure ChargeBattery (This : in out Car; desiredCharge : in BatteryChargeRange) is
   begin
      if not This.isDiagMode then
         --if desiredCharge > BatteryChargeRange'Last then
         --   This.battery := BatteryChargeRange'Last;
         --else
         This.battery := desiredCharge;
         --end if;     
      else
         Put_Line("Cannot charge in DIAGNOSTIC mode!");
         delay 2.0;
      end if;
      CheckBatteryWarning(This);
   end ChargeBattery;
   
   procedure ChargeBattery2 (This : in out Car; desiredCharge : in BatteryChargeRange) is
   begin
      if not This.isDiagMode then
         if (Integer(desiredCharge) + Integer(This.battery)) > Integer(BatteryChargeRange'Last) then
            This.battery := BatteryChargeRange'Last;
            Put_Line("OVERCHARGE PROTECTION!");
            delay 2.0;
         else
            This.battery := This.battery + desiredCharge;
         end if;
      else
         Put_Line("Cannot charge in DIAGNOSTIC mode!");
         delay 2.0;
      end if;
      CheckBatteryWarning(This);
   end ChargeBattery2;
   
   procedure DrainBattery (This : in out Car) is
   begin
      This.batteryDrain := Integer(This.speed / 10);
      
      if This.batteryDrain < 1 and Integer(This.speed) > 0 then
         This.batteryDrain := 1;
      end if;

      Put_Line("Predicted Battery Drain at current speed: " & This.batteryDrain'Image);
      delay 2.0;
      if (Integer(This.battery) - This.batteryDrain) < Integer(BatteryChargeRange'First) then
         This.battery := BatteryChargeRange'First;
      else
         This.battery := This.battery - BatteryChargeRange(This.batteryDrain);
      end if;

      CheckBatteryWarning(This);
   end DrainBattery;

end batterysystem;
