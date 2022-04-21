package CarSystem with SPARK_Mode is
   
   type BatteryChargeRange is range 0..100;
   type SpeedRange is range 0..100;
   MinCharge : constant Integer := 5;
   SpeedLimit : constant Integer := 70;
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
      speed : Integer range 0..SpeedRange'Last := 0;
      battery : Integer range 0..BatteryChargeRange'Last := 0;
      gear : Integer range 0..GearRange'Last := 0;
   end record;
   
   
   -- start the car, check if already started
   -- check if parked and stationary
   procedure StartProcedure (This : in out Car) with
     Pre=> this.isStarted = False and
     this.gear = 0 and
     this.speed = 0;
   
   -- shut down the car
   procedure StopProcedure (This : in out Car) with
     Pre => this.speed = 0 and
     this.gear = 0,
     Post => this.isDiagMode = False and 
     this.isStarted = False;
   
   -- check sensors
   procedure CheckSensor (This : in out Car);
   
   -- select desired gear
   -- won't change gear if diagnostic mode is on
   -- won't change gear if car is moving (speed)
   -- won't change gear if desired gear is out of range
   procedure ChangeGear (This : in out Car; selectedGear : in GearRange) with
     Pre => this.isDiagMode = False and 
     this.speed = 0 and
     selectedGear <= GearRange'Large and
     selectedGear >= GearRange'First;
   
   -- move the car with desired speed
   -- won't move if not started
   -- won't move if in diagnostic mode
   -- won't move if sensor is detecting
   -- won't move if battery is on minimum charge
   -- won't move if in parking gear
   -- won't move if desired speed is out of range
   -- will cap desired speed at speed limit
   procedure MoveCar (This : in out Car; targetSpeed : in SpeedRange) with
     Pre => this.isStarted = True and
     this.isDiagMode = False and
     this.SensorDetect = False and
     this.battery >= MinCharge and
     this.gear > 0 and
     targetSpeed >= SpeedRange'First and
     targetSpeed <= SpeedRange'Last,
     Post => this.speed <= SpeedLimit;
   
   -- stops the car
   -- will ensure speed is 0
   procedure EmergencyStop (This : in out Car) with
     Post => this.speed = 0;
   
   -- adds desired amount of charge to the battery
   -- won't charge in diagnostic mode
   -- prevents overcharge
   procedure ChargeBattery (This : in out Car; chargeAmount : in BatteryChargeRange) with
     Pre => this.isDiagMode = False and
     chargeAmount >= BatteryChargeRange'First and
     chargeAmount <= BatteryChargeRange'Last,
     Post => this.battery <= BatteryChargeRange'Last;
   
   -- enters diagnostic mode
   procedure EnterDiagMode (This : in out Car) with
     Post => this.isDiagMode = True;

end CarSystem;
