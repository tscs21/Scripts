--[[
    Game:       Hitman: Codename 47
    Author:     Dr. John B. Williston
    Updated:    10/08/2009

    I find Hitman's control scheme unpleasant for several reasons, not least among which is
    that it completely separates walking and running. I much prefer having a modifier key
    (e.g., shift) that ideally speeds up movement in any direction as in more recent games.

    My ideal isn't possible with this game, but it is possible to make at least forward motion
    work the way I wish through a bit of scripting. This script monitors two G keys, a walk
    key and a modifier/run key, and considers the player's avatar to be in one of four possible 
    states in light of these two G keys:

        1. The player is "Still" if neither key is pressed.
        2. The player is "Walking" if only the walk key is pressed.
        3. The player is "Run-pending" if only the run key is pressed.
        4. The player is "Running" if both the walk and run keys are pressed.

    I've declared the relevant G key numbers, as well as the output key to use, as variables 
    below, so that they may be changed easily. NB: though the output key(s) may be changed 
    here, all macros defined in this profile assume that the game has its WASD scheme loaded.
]]

WlkGKey = 4             -- G key number for the walk key
RunGKey = 15            -- G key number for the modifier or run key
WlkKey = "s"            -- output key for walking
RunKey = "w"            -- output key for running

--[[
    The following variables track the state of the two G keys whose numbers are defined above.
    Goofy as it sounds, there is no API exposed by the Logitech software to query the status of
    the G keys, so we have to track their state manually.
]]

WlkGKeyPressed = false  -- tracks the state of the walk key (true if pressed)
RunGKeyPressed = false  -- tracks the state of the run key (true if pressed)


-- Here begins the main event handler defined for any script.

function OnEvent(event, arg)

    --OutputLogMessage("event = %s, arg = %s\n", event, arg);

    -- This section updates the variables that track the status of the walk and run keys.

    if (event == "G_PRESSED" and arg == WlkGKey) then
        WlkGKeyPressed = true
        OutputLogMessage("Wlk (G%02i) Pressed  -> ", WlkGKey)
    elseif (event == "G_PRESSED" and arg == RunGKey) then
        RunGKeyPressed = true
        OutputLogMessage("Run (G%02i) Pressed  -> ", RunGKey)
    elseif (event == "G_RELEASED" and arg == WlkGKey) then
        WlkGKeyPressed = false
        OutputLogMessage("Wlk (G%02i) Released -> ", WlkGKey)
    elseif (event == "G_RELEASED" and arg == RunGKey) then
        RunGKeyPressed = false
        OutputLogMessage("Run (G%02i) Released -> ", RunGKey)
    end

    -- This section determines the new, resulting state (if any) and presses the output key.

    if (arg == WlkGKey or arg == RunGKey) then
    
        --[[    
            These two calls to release both the output keys somewhat simplify the following 
            code. A more precise script would keep track of which of the output keys was
            pressed and release only those that need to be. But this cleans up the code and doesn't
            seem to have any adverse effects if the keys aren't already pressed.
        ]]

        ReleaseKey(WlkKey)
        ReleaseKey(RunKey)

        --[[
            Finally, some very simple logic determines which state, and thus which output key, 
            we need to press (if any). The four possibilities are based on the two G key inputs 
            as follows:

                Run Key | Walk Key | State       | Output Key
                ---------------------------------------------
                Up      | Up       | Still       | None
                Up      | Down     | Walking     | Walk key
                Down    | Up       | Run-pending | None
                Down    | Down     | Running     | Run key
        ]]

        if (WlkGKeyPressed and not RunGKeyPressed) then
            PressKey(WlkKey)
            OutputLogMessage("Walking  (Key: %s)\n", WlkKey)
        elseif (WlkGKeyPressed and RunGKeyPressed) then
            PressKey(RunKey)
            OutputLogMessage("Running  (Key: %s)\n", RunKey)
        else
            -- This block is here only for sake of debugging.

            if (RunGKeyPressed) then
                OutputLogMessage("Run-pending\n")
            else
                OutputLogMessage("Still\n")
            end
        end
    end

    -- OTHER SCRIPT CODE MAY BE ADDED BELOW AS NEEDED

end