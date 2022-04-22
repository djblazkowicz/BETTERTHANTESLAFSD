with Ada.Text_IO; use Ada.Text_IO;
package body CarSystem with SPARK_Mode is
   
   procedure ToggleRegenBraking (This : in out Car) is
   begin
      This.isRegenBraking := not This.isRegenBraking;
   end ToggleRegenBraking;
   
   procedure UseRegenBraking (This : in out Car) is
   begin
      if This.isRegenBraking then         
            This.predictedCharge := Integer(This.battery) + (((Integer(This.previousSpeed) - Integer(This.speed))*5)/100);
         if This.predictedCharge > Integer(BatteryChargeRange'Last) then
            Put_line("USING REGENERATIVE BRAKING, PREDICTED CHARGE: " & This.predictedCharge'Image);
            Put_Line("Overcharge protection!!!");
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
   
   procedure CheckBatteryWarning (This : in out Car) is
   begin
      if This.battery <= MinCharge then
         This.isBatteryWarning := True;
      else This.isBatteryWarning := False;
      end if;
   end CheckBatteryWarning;
   
   
   procedure StartProcedure (This : in out Car) is
   begin
      -- implement
      CheckBatteryWarning(This);
      if This.isStarted = False and
        This.gear = 0 and
        This.speed = 0 then
         This.isStarted := True;
         end if;
   end StartProcedure;
   
   procedure StopProcedure (This : in out Car) is
   begin
      CheckBatteryWarning(This);
      if This.speed = 0 and
        This.gear = 0 then
         This.isDiagMode := False;
         This.isStarted := False;
      end if;
   end StopProcedure;
      
   procedure CheckSensor (This : in out Car) is
   begin
      CheckBatteryWarning(This);
      case This.gear is
         when 0 => This.SensorDetect := False; -- this is to reset the sensor when we are in PARK gear
         when 1 => if CarSystem.ObjectAhead = True then This.SensorDetect := True;
            else This.SensorDetect := False;
            end if;            
         when 2 => if CarSystem.ObjectBehind = True then This.SensorDetect := True;
            else This.SensorDetect := False;
            end if;   
      end case;
   end CheckSensor;
               
   procedure ChangeGear (This : in out Car; selectedGear : in GearRange) is
   begin
      if not This.isDiagMode and
        This.speed < 1 and 
        selectedGear <= CarSystem.GearRange'Last and
        selectedGear >= CarSystem.GearRange'First then
         This.gear := selectedGear;
      end if;
      CheckSensor(This);
   end ChangeGear;
   
   procedure MoveCar (This : in out Car) is
   begin
      if This.previousSpeed = 0 then
         This.previousSpeed := This.speed;
      end if;      
      CheckSensor(This);
      CheckBatteryWarning(This);      
      if This.SensorDetect then
         Put_line("OBJECT DETECTED, EXECUTING EMERGENCY STOP");
         delay 2.0;
         EmergencyStop(This);
         return;
      end if;
      if This.isBatteryWarning then
         Put_line("BATTERY WARNING, EXECUTING EMERGENCY STOP");
         delay 2.0;
         EmergencyStop(This);
         return;
      end if;
      if not This.isStarted then
         Put_line("cannot move, car not started");
         delay 2.0;
         return;
      end if;
      if this.isDiagMode then
         Put_line("cannot move, car in DIAGNOSTIC mode");
         delay 2.0;
         return;
      end if;       
      if This.gear = 0 then
         Put_Line("cannot move, car in PARKING gear");
         delay 2.0;
         return; 
      end if;
      if This.isStarted and
         not This.isDiagMode and
         not This.SensorDetect and
         not This.isBatteryWarning and
        This.gear > 0 and
        This.desiredSpeed >= SpeedRange'First and
        This.desiredSpeed <= SpeedRange'Last then
         if This.desiredSpeed > SpeedLimit then
            This.speed := SpeedLimit;
         else
            This.speed := This.desiredSpeed;
         end if;
         if This.speed > 0 and 
           This.battery > MinCharge then
           This.battery := This.battery - 1;
         end if;         
      end if;
      CheckBatteryWarning(This);
      This.desiredSpeed := 0;
     
      CheckRegenBraking(This);
      
      This.previousSpeed := This.speed;
   end MoveCar;
   
   procedure EmergencyStop (This : in out Car) is
   begin
      CheckBatteryWarning(This);
      This.speed := 0;
      This.gear := 0;
      CheckRegenBraking(This);
      This.previousSpeed := 0;
   end EmergencyStop;
    
   procedure ChargeBattery (This : in out Car; desiredCharge : in BatteryChargeRange) is
   begin
      if not This.isDiagMode then
         if desiredCharge > BatteryChargeRange'Last then
            This.battery := BatteryChargeRange'Last;
         else
            This.battery := desiredCharge;
         end if;
         
      end if;
      
      CheckBatteryWarning(This);
   end ChargeBattery;
   
   procedure EnterDiagMode (This : in out Car) is
   begin
      EmergencyStop(This);
      This.isDiagMode := True;
   end EnterDiagMode;
   
   procedure ExitDiagMode (This : in out Car) is
   begin
      This.isDiagMode := False;
   end ExitDiagMode;
        
end CarSystem;
