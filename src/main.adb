with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with CarSystem; use CarSystem;
with batterysystem; use batterysystem;
with brakingsystem; use brakingsystem;

procedure Main with SPARK_Mode is
   saxo: CarSystem.Car;
   option : Integer := 1;
   speed_int : Integer := -1;
   battery : BatteryChargeRange := 0;
   battery_int : Integer := -1;

   procedure PrintStatus is
   begin
      Ada.Text_IO.Put(ASCII.ESC & "[2J");
      New_Line;
      Put_Line("...........................");
      Put_Line("Car Started: " & saxo.isStarted'Image);
      case saxo.gear is
         when 0 => Put_Line("Selected Gear: PARK");
         when 1 => Put_Line("Selected Gear: DRIVE");
         when 2 => Put_Line("Selected Gear: REVERSE");
      end case;
      if saxo.isBatteryWarning then
         Put_Line("Battery level: " & saxo.battery'Image & " LOW BATTERY");
      else
         Put_Line("Battery level: " & saxo.battery'Image);
      end if;
      Put_Line("Battery CRITICAL Warning: " & saxo.isBatteryCritical'Image);
      Put_Line("Speed: " & saxo.speed'Image);
      --Put_line("Previous Speed: " & saxo.previousSpeed'Image);
      Put_Line("Regenerative Braking: " & saxo.isRegenBraking'Image);
      Put_Line("Diagnostic Mode: " & saxo.isDiagMode'Image);
      Put_Line("SENSOR DETECT: " & saxo.SensorDetect'Image);
      --Put_Line("Object Ahead " & ObjectAhead'Image);
      --Put_Line("Object Behind " & ObjectBehind'Image);
      Put_Line("...........................");
      New_Line;
   end PrintStatus;
begin
   while option /= 0 loop

      PrintStatus;
      New_Line;
      Put_Line("Choose one of the following options: ");
      Put_Line("...........................");
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
      Put_Line("...........................");
      New_Line;
      Ada.Integer_Text_IO.Get(option);

      case option is
         when 1    =>
            if saxo.isStarted then
               StopProcedure(saxo);
            else
               StartProcedure(saxo);
            end if;
         when 2    =>
            ChangeGear(saxo, 0);
         when 3    =>
            ChangeGear(saxo, 1);
         when 4    =>
            ChangeGear(saxo, 2);
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
            ChargeBattery2(saxo, battery);
            battery_int := -1;
            battery := 0;
         when 6 =>
            Put_line("Toggle Regenerative Braking...");
            ToggleRegenBraking(saxo);
            delay 2.0;
         when 7 =>
            while speed_int > Integer(SpeedRange'Last) or
            speed_int < Integer(SpeedRange'First) loop
               Put_line("Input desired speed:");
               Ada.Integer_Text_IO.Get(speed_int);
            end loop;
            saxo.desiredSpeed := SpeedRange(speed_int);
            MoveCar(saxo);
            speed_int := -1;
            delay 2.0;
         when 8 =>
            Put_line("Maintaining speed...");
            MaintainSpeed(saxo);
            delay 2.0;
         when 9 =>
            delay 2.0;
            EmergencyStop(saxo);
         when 10 =>
            if saxo.isDiagMode = True then
               Put_line("Exiting Diagnostic Mode");
               delay 2.0;
               ExitDiagMode(saxo);
            else
               Put_line("Entering Diagnostic Mode");
               delay 2.0;
               EnterDiagMode(saxo);
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
            if ObjectAhead = True then
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
