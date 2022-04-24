with batterysystem; use batterysystem;
with CarSystem; use CarSystem;
package brakingsystem with SPARK_Mode is

   procedure ToggleRegenBraking (This : in out Car);
   
   procedure UseRegenBraking (This : in out Car) with
     Pre => this.isRegenBraking and
     this.predictedCharge <= Integer'Last and
     this.predictedCharge >= Integer'First,
     Post => this.battery <= BatteryChargeRange'Last;
   
   procedure CheckRegenBraking (This : in out Car);

end brakingsystem;
