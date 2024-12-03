zig build -Doptimize=ReleaseFast -Dtarget=native-windows
POWER=`powercfg.exe /GETACTIVESCHEME | cut -f4 -d' '`
powercfg.exe /SETACTIVE a1841308-3541-4fab-bc81-f71556f20b4a
sleep 5
powercfg.exe /SETACTIVE 3adf7f55-24e0-459d-a20e-e30d7309178b
cmd.exe /c "START /B /WAIT /REALTIME /NODE 0 /AFFINITY 0x2000000 zig-out/bin/advent-of-code.exe -w 1000 -b 100"
powercfg.exe /SETACTIVE $POWER
