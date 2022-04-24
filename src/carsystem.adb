with Ada.Text_IO; use Ada.Text_IO;
with batterysystem; use batterysystem;
with brakingsystem; use brakingsystem;
package body CarSystem with SPARK_Mode is
      

   
   
   procedure StartProcedure (This : in out Car) is
   begin
      CheckBatteryWarning(This);
      if not This.isDiagMode then
         if This.battery = 0 then
            Put_Line("Cannot start with a depleted battery!");
            delay 2.0;
            return;
         end if;        
         if This.isStarted then
            Put_Line("Cannot start up if already running!");
            delay 2.0;
            return;
         end if;
         if This.gear > 0 then
            Put_line("Can only START/STOP in PARK Gear!");
            delay 2.0;
            return;
         end if;
         if This.speed > 0 then
            Put_line("Can only START/STOP when stationary!");
            delay 2.0;
            return;
         end if;
         if not This.isStarted and
           This.gear = 0 and
           This.speed = 0 then
            This.isStarted := True;
            Put_Line("Starting up...");
            delay 2.0;
         end if;         
      else
         Put_Line("Cannot START/STOP up in Diagnostic Mode!");
         delay 2.0;
      end if;
      return;
   end StartProcedure;
   
   procedure StopProcedure (This : in out Car) is
   begin
      CheckBatteryWarning(This);
      if not This.isDiagMode then
         if not This.isStarted then
            Put_Line("Car is already shut down!");
            delay 2.0;
            return;
         end if;
         if This.gear > 0 then
            Put_Line("Can only START/STOP in PARK Gear!");
            delay 2.0;
            return;
         end if;
         if This.speed > 0 then
            Put_Line("Can only START/STOP when stationary!");
            delay 2.0;
            return;
         end if;
         if This.isStarted and
              This.gear = 0 and
              This.speed = 0 then
            This.isStarted := False;
            Put_Line("Shutting Down...");
            delay 2.0;
         end if;
      else
         Put_Line("Cannot START/STOP up in Diagnostic Mode!");
         delay 2.0;
      end if;
      return;
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
      if not This.isDiagMode then
         if This.speed > 0 then
            Put_line("Can only change Gear when stationary!");
            delay 2.0;
            return;
         end if;
         if This.speed = 0 and
           selectedGear <= CarSystem.GearRange'Last and
           selectedGear >= CarSystem.GearRange'First then
            case selectedGear is
            when 0 =>
               Put_Line("Changing to PARK gear...");
               delay 2.0;
            when 1 =>
               Put_Line("Changing to DRIVE gear...");
               delay 2.0;
            when 2 =>
               Put_Line("Changing to Reverse gear...");
               delay 2.0;
         end case;
            This.gear := selectedGear;
            CheckSensor(This);
         end if;
      else
         Put_line("Cannot change Gear in DIAGNOSTIC Mode!");
         delay 2.0;
      end if;
   end ChangeGear;
   
   procedure MoveCar (This : in out Car) is
   begin
      if This.previousSpeed = 0 then
         This.previousSpeed := This.speed;
      end if;      
      CheckSensor(This);
      CheckBatteryWarning(This);
      if not This.isDiagMode then
         if not This.isStarted then
            Put_line("Cannot move. Car is not running!");
            delay 2.0;
            return;
         end if;       
         if This.gear = 0 then
            Put_Line("Cannot move. Car in PARKING Gear!");
            delay 2.0;
            return; 
         end if;         
         if This.SensorDetect then
            Put_line("OBJECT DETECTED!");
            delay 2.0;
            EmergencyStop(This);
            return;
         end if;
         if This.isBatteryWarning then
            Put_line("BATTERY MINIMUM CHARGE WARNING!");
            delay 2.0;
            EmergencyStop(This);
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
            Put_Line("Adjusted spped to " & This.speed'Image);
            delay 2.0;
            if This.speed > 0 and 
               This.battery > MinCharge then
               --This.battery := This.battery - 1;
               DrainBattery(This);
            end if;         

         end if;
      else
         Put_line("Cannot move! Car is in DIAGNOSTIC Mode!");
         delay 2.0;
         return;
      end if;

      CheckBatteryWarning(This);
      This.desiredSpeed := 0;
     
      CheckRegenBraking(This);
      
      This.previousSpeed := This.speed;
   end MoveCar;
   
   procedure MaintainSpeed (This : in out Car) is
   begin
      if This.desiredSpeed = 0 and
        This.previousSpeed = 0 then
         Put_line("Car is stationary, ignoring");
      else
         This.desiredSpeed := This.previousSpeed;
         MoveCar(This);
      end if;
   end;
   
   
   procedure EmergencyStop (This : in out Car) is
   begin
      if not This.isDiagMode then
         CheckBatteryWarning(This);
         This.speed := 0;
         This.gear := 0;
         Put_Line("Executing Emergency Stop!");
         delay 2.0;
         CheckRegenBraking(This);
         This.previousSpeed := 0;
      else
         Put_Line("Cannot execute Emergency Stop in DIAGNOSTIC Mode!");
      end if;
   end EmergencyStop;
    
   
   procedure EnterDiagMode (This : in out Car) is
   begin
      if This.speed > 0 then
         EmergencyStop(This);
      end if;
      This.isDiagMode := True;
   end EnterDiagMode;
   
   procedure ExitDiagMode (This : in out Car) is
   begin
      This.isDiagMode := False;
   end ExitDiagMode;
        
end CarSystem;
