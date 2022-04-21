package body CarSystem with SPARK_Mode is
   
   procedure StartProcedure (This : in out Car) is
   begin
      -- implement
      if This.isStarted = False and
        This.gear = 0 and
        This.speed = 0 then
         This.isStarted := True;
         end if;
   end StartProcedure;
   
   procedure StopProcedure (This : in out Car) is
   begin
      if This.speed = 0 and
        This.gear = 0 then
         This.isDiagMode := False;
         This.isStarted := False;
      end if;
   end StopProcedure;
      
   procedure CheckSensor (This : in out Car) is
   begin
      case This.gear is
         when 0 => return;
         when 1 => if CarSystem.ObjectAhead = True then This.SensorDetect := True;
               end if;
         when 2 => if CarSystem.ObjectBehind = True then This.SensorDetect := True;
            end if;
      end case;
   end CheckSensor;
               
   procedure ChangeGear (This : in out Car; selectedGear : in GearRange) is
   begin
      if This.isDiagMode = False and
        This.speed = 0 and 
        selectedGear <= CarSystem.GearRange'Last and
        selectedGear >= CarSystem.GearRange'First then
         This.gear := selectedGear;
         end if;
   end ChangeGear;
   
   procedure MoveCar (This : in out Car; targetSpeed : in SpeedRange) is
   begin
      --check correct sensor before moving
      --execute emergency stop if object detected
      CheckSensor(This);
      if This.SensorDetect = True then
         EmergencyStop(This);
         return;
      end if;
      --move car if everything is good
      if This.isStarted = True and
        This.isDiagMode = False and
        This.SensorDetect = False and
        This.battery >= MinCharge and
        This.gear > 0 and
        targetSpeed >= SpeedRange'First and
        targetSpeed <= SpeedRange'Last then
         if targetSpeed > SpeedLimit then
            This.speed := SpeedLimit;
         else This.speed := targetSpeed;
         end if;
      end if;        
   end MoveCar;
   
   procedure EmergencyStop (This : in out Car) is
   begin
      --implement
      This.speed := 0;
      This.gear := 0;
   end EmergencyStop;
      
   procedure ChargeBattery (This : in out Car; chargeAmount : in BatteryChargeRange) is
   expectedCharge : BatteryChargeRange := This.battery + chargeAmount;
   begin
      --overcharge protection
      if This.isDiagMode = False and
        chargeAmount >= BatteryChargeRange'First and
        chargeAmount <= BatteryChargeRange'Last then
         if expectedCharge >= BatteryChargeRange'Last then
            This.battery := BatteryChargeRange'Last;
         else
            This.battery := This.battery + chargeAmount;
         end if;
      end if;
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
