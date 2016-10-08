LONG_DELAY = 800 -- in milliseconds.

function OnEvent(event, arg)
	if event=="G_PRESSED" and arg==1 then 
		timeStamp = GetRunningTime() 
	end

	if event=="G_RELEASED" and arg==1 then
		if (GetRunningTime() - timeStamp) < LONG_DELAY then
			PressAndReleaseKey("1")
		else
			PressKey("lshift") PressKey ("1") ReleaseKey ("1") ReleaseKey ("lshift")
		end
		timeStamp = nil
	end
end
