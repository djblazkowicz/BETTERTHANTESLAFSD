with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with CarSystem; use CarSystem;

procedure Main is
   saxo: CarSystem.Car;
   option : Integer := 1;
   speed : SpeedRange := 0;
   speed_int : Integer := -1;
   battery : BatteryChargeRange := 0;
   battery_int : Integer := -1;

   procedure PrintStatus is
   begin
      Ada.Text_IO.Put(ASCII.ESC & "[2J");
      New_Line;
      Put_Line("...........................");
      Put_Line("Car Started: " & saxo.isStarted'Image);
      Put_Line("Selected Gear: " & saxo.gear'Image);
      Put_Line("Battery level: " & saxo.battery'Image);
      Put_Line("Speed: " & saxo.speed'Image);
      Put_Line("Diagnostic Mode: " & saxo.isDiagMode'Image);
      Put_Line("Battery Warning: " & saxo.isBatteryWarning'Image);
      Put_Line("Object Ahead " & ObjectAhead'Image);
      Put_Line("Object Behind " & ObjectBehind'Image);

      --  Put_Line("Tank Status: " & tren.waTank.status'Image);
      Put_Line("...........................");
      New_Line;
   end PrintStatus;

   procedure ClearDelay is
   begin
      delay 2.0;
      --Ada.Text_IO.Put(ASCII.ESC & "[2J");
   end ClearDelay;

begin
   while option /= 0 loop

      PrintStatus;
      New_Line;
      Put_Line("Choose one of the following options: ");
      Put_Line("...........................");
      Put_Line("1.  Start the car");
      Put_Line("2.  Shut the car down");
      Put_line("3.  Put Gearbox in Park");
      Put_line("4.  Put Gearbox in Drive");
      Put_line("5.  Put Gearbox in Reverse");
      Put_line("6.  Charge the battery");
      Put_line("7.  Move the car");
      Put_line("8.  Execute Emergency Stop");
      Put_line("9.  Enter/Exit Diagnostic Mode");
      Put_line("10. Add/Remove Object Ahead");
      Put_line("11. Add/Remove Object Behind");
      Put_Line("0 to exit ");
      Put_Line("...........................");
      New_Line;
      Ada.Integer_Text_IO.Get(option);

      case option is
         when 1    =>
            Put_Line("Start the car...");
            ClearDelay;
            StartProcedure(saxo);
         when 2    =>
            Put_Line("Turning the car off...");
            ClearDelay;
            StopProcedure(saxo);
         when 3    =>
            Put_line("Changing gear...");
            ClearDelay;
            ChangeGear(saxo, 0);
         when 4    =>
            Put_line("Changing gear...");
            ClearDelay;
            ChangeGear(saxo, 1);
         when 5    =>
            Put_line("Changing gear...");
            ClearDelay;
            ChangeGear(saxo, 2);
         when 6 =>

            while battery_int > Integer(BatteryChargeRange'Last) or
              battery_int < Integer(BatteryChargeRange'First) loop
               Put_line("Input desired charge:");
               Ada.Integer_Text_IO.Get(battery_int);
            end loop;
            battery := BatteryChargeRange(battery_int);
            Put_line("Charging battery...");
            ClearDelay;
            ChargeBattery(saxo, battery);
            battery_int := -1;
            battery := 0;
         when 7 =>

            while speed_int > Integer(SpeedRange'Last) or
            speed_int < Integer(SpeedRange'First) loop
               Put_line("Input desired speed:");
               Ada.Integer_Text_IO.Get(speed_int);
            end loop;
            speed := SpeedRange(speed_int);
            Put_line("selected speed: " & speed'Image);
            ClearDelay;

            Put_line("Attemting to move...");
            ClearDelay;
            MoveCar(saxo, speed);
            if saxo.SensorDetect = True then
               Put_line("OBJECT DETECTED, EXECUTING EMERGENCY STOP");
            end if;
            speed_int := -1;
            speed := 0;
         when 8 =>
            Put_line("Executing Emergency Stop...");
            ClearDelay;
            EmergencyStop(saxo);
         when 9 =>
            if saxo.isDiagMode = True then
               Put_line("Exiting Diagnostic Mode");
            else
               Put_line("Entering Diagnostic Mode");
            end if;
            saxo.isDiagMode := not saxo.isDiagMode;
         when 10 =>
            if ObjectAhead = True then
               Put_line("Removing object Ahead...");
            else
               Put_line("Adding object Ahead...");
            end if;
            ObjectAhead := not ObjectAhead;
         when 11 =>
            if ObjectAhead = True then
               Put_line("Removing object Behind...");
            else
               Put_line("Adding object Behind...");
            end if;
            ObjectBehind := not ObjectBehind;

         when 0    =>
            Put_Line ("Exiting...");
            delay 1.0;

         when others =>
            null;
      end case;
      end loop;

end Main;
