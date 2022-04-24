package CarSystem with SPARK_Mode is
   
   type BatteryChargeRange is range 0..100;
   type SpeedRange is range 0..100;
   MinCharge : constant BatteryChargeRange := 5;
   SpeedLimit : constant SpeedRange := 70;
   ObjectAhead : Boolean := False;
   ObjectBehind : Boolean := False;
   
   -- gearbox
   -- 0 = park 1 = drive 2 = reverse
   type GearRange is range 0..2;
      
   --define car data structure
   type Car is record
      isStarted : Boolean := False;
      SensorDetect : Boolean := False;
      isDiagMode : Boolean := False;
      isBatteryWarning : Boolean := False;
      isRegenBraking : Boolean := False;
      predictedCharge : Integer := 0;
      previousSpeed : SpeedRange := 0;
      speed : SpeedRange := 0;
      desiredSpeed : SpeedRange := 0;
      battery : BatteryChargeRange := 0;
      batteryDrain : Integer := 0;
      gear : GearRange := 0;
   end record;
   
   
   -- start the car, check if already started
   -- check if parked and stationary
   procedure StartProcedure (This : in out Car);
   
   -- shut down the car
   procedure StopProcedure (This : in out Car);
   
   -- check sensors
   procedure CheckSensor (This : in out Car);
   
   -- select desired gear
   -- won't change gear if diagnostic mode is on
   -- won't change gear if car is moving (speed)
   -- won't change gear if desired gear is out of range
   procedure ChangeGear (This : in out Car; selectedGear : in GearRange); --with
     --  Pre => this.isDiagMode = False and
     --  this.speed = 0 and
     --  selectedGear <= GearRange'Last and
     --  selectedGear >= GearRange'First;

   procedure MoveCar (This : in out Car) with
     Pre => this.desiredSpeed >= SpeedRange'First and
     this.desiredSpeed <= SpeedRange'Last;
   procedure MaintainSpeed (This : in out Car);
   -- stops the car
   -- will ensure speed is 0
   procedure EmergencyStop (This : in out Car); --with
     --Post => this.speed = 0;
   

   -- enters diagnostic mode
   procedure EnterDiagMode (This : in out Car) with
     Post => this.isDiagMode = True;
   
   procedure ExitDiagMode (This : in out Car) with
     Pre => this.isDiagMode = True,
     Post => this.isDiagMode = False;

end CarSystem;
