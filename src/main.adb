with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with CarSystem; use CarSystem;
with batterysystem; use batterysystem;
with brakingsystem; use brakingsystem;

procedure Main with SPARK_Mode is
   carModel: CarSystem.Car;
   option : Integer := 1;
   speed_int : Integer := -1;
   battery : BatteryChargeRange := 0;
   battery_int : Integer := -1;

   procedure PrintStatus is
   begin
      Ada.Text_IO.Put(ASCII.ESC & "[2J");
      New_Line;
      Put_Line("###########################");
      Put_Line("Car Started: " & carModel.isStarted'Image);
      case carModel.gear is
         when 0 => Put_Line("Selected Gear: PARK");
         when 1 => Put_Line("Selected Gear: DRIVE");
         when 2 => Put_Line("Selected Gear: REVERSE");
      end case;
      if carModel.isBatteryWarning then
         Put_Line("Battery level: " & carModel.battery'Image & " LOW BATTERY");
      else
         Put_Line("Battery level: " & carModel.battery'Image);
      end if;
      Put_Line("Battery CRITICAL Warning: " & carModel.isBatteryCritical'Image);
      Put_Line("Speed: " & carModel.speed'Image);
      --Put_line("Previous Speed: " & carModel.previousSpeed'Image);
      Put_Line("Regenerative Braking: " & carModel.isRegenBraking'Image);
      Put_Line("Diagnostic Mode: " & carModel.isDiagMode'Image);
      Put_Line("SENSOR DETECT: " & carModel.SensorDetect'Image);
      Put_Line("Object Ahead " & ObjectAhead'Image);
      Put_Line("Object Behind " & ObjectBehind'Image);
      Put_Line("###########################");
      New_Line;
   end PrintStatus;
begin
   while option /= 0 loop

      PrintStatus;
      New_Line;
      Put_Line("Choose one of the following options: ");
      Put_Line("###########################");
      Put_Line("1.  START/STOP Button");
      Put_line("2.  Put Gearbox in Park");
      Put_line("3.  Put Gearbox in Drive");
      Put_line("4.  Put Gearbox in Reverse");
      Put_line("5.  Charge the battery");
      Put_line("6.  Toggle Regenerative Braking");
      Put_line("7.  Set Speed");
      Put_line("8.  Maintain Speed");
      Put_line("9.  Execute Emergency Stop");
      Put_line("10. Toggle Diagnostic Mode");
      Put_line("11. Toggle Object Ahead");
      Put_line("12. Toggle Object Behind");
      Put_Line("0 to exit ");
      Put_Line("###########################");
      New_Line;
      Ada.Integer_Text_IO.Get(option);

      case option is
         when 1    =>
            if carModel.isStarted then
               StopProcedure(carModel);
            else
               StartProcedure(carModel);
            end if;
         when 2    =>
            ChangeGear(carModel, 0);
         when 3    =>
            ChangeGear(carModel, 1);
         when 4    =>
            ChangeGear(carModel, 2);
         when 5 =>
            while battery_int > Integer(BatteryChargeRange'Last) or
              battery_int < Integer(BatteryChargeRange'First) loop
               Put_line("Input desired charge:");
               Ada.Integer_Text_IO.Get(battery_int);
            end loop;
            if battery_int <= Integer(BatteryChargeRange'Last) and
              battery_int >= Integer(BatteryChargeRange'First) then
               battery := BatteryChargeRange(battery_int);
               end if;
            ChargeBattery(carModel, battery);
            battery_int := -1;
            battery := 0;
         when 6 =>
            Put_line("Toggle Regenerative Braking...");
            ToggleRegenBraking(carModel);
            delay 2.0;
         when 7 =>
            while speed_int > Integer(SpeedRange'Last) or
            speed_int < Integer(SpeedRange'First) loop
               Put_line("Input desired speed:");
               Ada.Integer_Text_IO.Get(speed_int);
            end loop;
            carModel.desiredSpeed := SpeedRange(speed_int);
            MoveCar(carModel);
            speed_int := -1;
            delay 2.0;
         when 8 =>
            Put_line("Maintaining speed...");
            MaintainSpeed(carModel);
            delay 2.0;
         when 9 =>
            delay 2.0;
            EmergencyStop(carModel);
         when 10 =>
            if carModel.isDiagMode = True then
               Put_line("Exiting Diagnostic Mode");
               delay 2.0;
               ExitDiagMode(carModel);
            else
               Put_line("Entering Diagnostic Mode");
               delay 2.0;
               EnterDiagMode(carModel);
            end if;
         when 11 =>
            if ObjectAhead = True then
               Put_line("Removing object Ahead...");
            else
               Put_line("Adding object Ahead...");
            end if;
            ObjectAhead := not ObjectAhead;
            delay 2.0;
         when 12 =>
            if ObjectBehind = True then
               Put_line("Removing object Behind...");
            else
               Put_line("Adding object Behind...");
            end if;
            ObjectBehind := not ObjectBehind;
            delay 2.0;
         when 0    =>
            Put_Line ("Exiting...");
            delay 1.0;

         when others =>
            null;
      end case;
      end loop;
end Main;
