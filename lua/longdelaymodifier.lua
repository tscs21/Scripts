LONG_DELAY = 500  -- in milliseconds.

function OnEvent(event, arg)
    if event=="G_PRESSED" and arg==1 then 
        timeStamp = GetRunningTime() 
    end
        
    if event=="G_RELEASED" and arg==1 then
        if (GetRunningTime() - timeStamp) < LONG_DELAY then
            PressAndReleaseKey("r")
        else
            PressAndReleaseKey("f")
        end
        timeStamp = nil
    end
end 
