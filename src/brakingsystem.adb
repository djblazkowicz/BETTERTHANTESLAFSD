with CarSystem; use CarSystem;
with Ada.Text_IO; use Ada.Text_IO;

package body brakingsystem with SPARK_Mode is

   procedure ToggleRegenBraking (This : in out Car) is
   begin
      if not This.isDiagMode then
         This.isRegenBraking := not This.isRegenBraking;
      else
         Put_Line("Cannot Toggle Regenerative Braking in Diagnostic Mode!");
         delay 2.0;
         return;
      end if;
   end ToggleRegenBraking;
   
   procedure UseRegenBraking (This : in out Car) is
   begin
      if This.isRegenBraking then         
            This.predictedCharge := Integer(This.battery) + (((Integer(This.previousSpeed) - Integer(This.speed))*5)/100);
         if This.predictedCharge > Integer(BatteryChargeRange'Last) then
            Put_line("USING REGENERATIVE BRAKING, PREDICTED CHARGE: " & This.predictedCharge'Image);
            Put_Line("OVERCHARGE PROTECTION!");
            delay 2.0;            
            ChargeBattery(This, BatteryChargeRange'Last);
         else
            if This.predictedCharge >= Integer(BatteryChargeRange'First) then
               Put_line("USING REGENERATIVE BRAKING, PREDICTED CHARGE: " & This.predictedCharge'Image);
               delay 2.0;
               ChargeBattery(This, BatteryChargeRange(This.predictedCharge));
               end if;
         end if;
      end if;
   end UseRegenBraking;
   
   procedure CheckRegenBraking (This : in out Car) is
   begin
      if (This.previousSpeed - This.speed) > 0 and
        This.isRegenBraking then
         UseRegenBraking(This);
      end if;
   end CheckRegenBraking;

end brakingsystem;
