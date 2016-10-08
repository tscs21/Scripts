LONG_DELAY = 250  -- in milliseconds.

function OnEvent(event, arg, family)
	MState = GetMKeyState()
	OutputLogMessage("MState is %d \n", MState)
    --
    if MState == 1 then -- M1-Mode
        if event=="G_PRESSED" and arg <= 10 then -- G1 to G10 Presses
            timeStamp = GetRunningTime() 
        end
        if event=="G_RELEASED" and arg <= 10 then -- G1 to G10 Releases
             --if arg == 10 then myKey = 0 else 
			myKey = arg -- select key
			myKey = arg % 10
			OutputLogMessage("mkey is %d \n", myKey)
             if (GetRunningTime() - timeStamp) < LONG_DELAY then -- short press => number only
                PressAndReleaseKey(tostring(myKey))
             else
                PressKey("lshift")
                --Sleep(10)
                PressAndReleaseKey(tostring(myKey))
                --Sleep(10)
                ReleaseKey("lshift")
             end
             timeStamp = nil
         end
     end
end
