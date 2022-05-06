with CarSystem; use CarSystem;
package batterysystem with SPARK_Mode is

   procedure CheckBatteryWarning (This : in out Car);
   
   -- adds desired amount of charge to the battery
   -- won't charge in diagnostic mode
   -- prevents overcharge
   procedure ChargeBattery (This : in out Car; desiredCharge : in BatteryChargeRange) with
     Pre => desiredCharge <= BatteryChargeRange'Last and
     desiredCharge >= BatteryChargeRange'First,
     Post => this.battery <= BatteryChargeRange'Last and
     this.battery >= BatteryChargeRange'First;
   
   
   procedure DrainBattery (This : in out Car);

end batterysystem;
