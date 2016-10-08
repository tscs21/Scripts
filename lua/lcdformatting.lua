-- Formatting LCD / alignment + 4-line-text displaying (c)reated by UPIA --
-- --------------------------------------------------------------------- --
-- PRESS G Buttons to see LCD Output

function OnEvent(event, arg)
    if event=="PROFILE_ACTIVATED" then
        ClearLog()
        --
        string="This scritp can format your text!"
        text=getText()
    end
    if event=="G_PRESSED" then
        if arg==1 then 
            f_printL(string, "l", 60000, 0, 1) -- shows left alignment, for 60seconds, 0 = no / 1 = line break, 0 = no / 1 = ClearLCD 
         elseif arg==2 then
            f_printL(string, "c", 60000, 0, 1) -- shows center alignment
         elseif arg==3 then
            f_printL(string, "r", 60000, 0, 1) -- shows right alignment
         elseif arg==4 then
            f_printL(string, "b", 60000, 0, 1) -- shows block text
         elseif arg==5 then
            ClearLCD();OutputLCDMessage("The string has "..f_str2pixl(string).." pixels!",60000) -- shows pixels of the string
         elseif arg==6 then
            f_printT(text, "b", 60000, 1) -- display text in 4-lines at a time (push again to toggle)
         elseif arg==7 then
            clock()
         elseif arg==8 then
            str="ABCDEFGHIJ"; ClearLCD();LCD(f_bigFont(str, "uN"),600000)
         elseif arg==9 then
            str=[[KLMNOPQRS]]; ClearLCD();LCD(f_bigFont(str, "uN"),600000)
        elseif arg==10 then
            str="TUVWXYZ"; ClearLCD();LCD(f_bigFont(str, "uN"),600000)
        elseif arg==11 then
            str=[[1234567890]]; ClearLCD();LCD(f_bigFont(str, "uN"),600000)
        elseif arg==15 then
            str="ABCDEFGHI"; ClearLCD();LCD(f_bigFont(str, "uH"),600000)
        elseif arg==16 then
            str=[[JKLMNOPQR]]; ClearLCD();LCD(f_bigFont(str, "uH"),600000)
        elseif arg==17 then
            str="STUVWXYZ"; ClearLCD();LCD(f_bigFont(str, "uH"),600000)
        elseif arg==18 then
            str=[[1234567890]]; ClearLCD();LCD(f_bigFont(str, "uH"),600000)
        elseif arg==20 then
            str=[[:/|,.=;\%+*-_()]]; ClearLCD();LCD(f_bigFont(str, "uH"),600000)
        elseif arg==21 then
            str=[[÷|‰|²|³|™|$#]]; ClearLCD();LCD(f_bigFont(str, "uH"),600000)
        elseif arg==22 then
            str=[[^°?!{}]]; ClearLCD();LCD(f_bigFont(str, "uH"),600000)
        elseif arg==23 then
        elseif arg==24 then
        end
    end
end
-- Shortcut Functions
function LOG(...)
    OutputLogMessage(...)
end
function LCD(...)
    OutputLCDMessage(...)
end
function eval(str) -- evaluates a command defined in "str"
    return assert(loadstring(str))()
end
---------------------------------------------- f_FUNCTIONS ---------------------------------------------------- FOR TEXT & LINE FORMATTING
-- FORMAT & TOGGLE MULTI-LINE TEXT
function f_printT(text, position, time, clear, vBox)
    if (vBox~=nil and type(vBox)=="table") then dispW=vBox[2];dispH=vBox[3] else dispW=160;dispH=4 end
    --showLines=4;
    if f_printT_ini==nil then f_printT_ini=1; sL=1; sLM=sL*dispH
        nob={}; String={}; pixls=0; counter=1; String[counter]=""
        lines=f_explode("\n", text); n_lines=table.getn(lines)
        for i=1,n_lines,1 do
            p_line=f_str2pixl(lines[i])
            if p_line>dispW then 
                words=f_explode(" ", lines[i]); n_words=table.getn(words)
                for j=1,n_words,1 do
                    p_word=f_str2pixl(words[j])
                    if (pixls+p_word+2)<dispW then pixls=(pixls+p_word+2); if String[counter]=="" then String[counter]=words[j] else String[counter]=String[counter].." "..words[j] end
                    else nob[counter]=0; counter=counter+1; String[counter]=words[j]; pixls=p_word; end
                end
            else String[counter]=lines[i] end
        nob[counter]=1
        if i<n_lines then pixls=0; counter=counter+1; String[counter]="" end
        end
    else if sLM>= table.getn(String) then sL=1; sLM=sL*dispH else sL=sL+dispH; sLM=sLM+dispH; if sLM>table.getn(String) then sLM=table.getn(String) end; end end
    ClearLCD();
    for i=sL,sLM,1 do 
        if i<table.getn(String) then 
            if (position=="b" and nob[i]==1) then f_printL(String[i], "l", time, 1, nil) else f_printL(String[i], position, time, 1, nil) end
        else if (position=="b" and nob[i]==1) then f_printL(String[i], "l", time, nil, nil) else f_printL(String[i], position, time, nil, nil) end
        end 
    end
end

-- FORMAT SINGLE LINE
function f_printL(string, position, time, lbreak, clear)
    if type(string)~="string" or type(position)~="string" or type(time)~="number" or time<1 then OutputLogMessage("f_ERROR: BAD FORMAT!\n");OutputLCDMessage("f_ERROR: BAD FORMAT!"); return
    else
        if (clear~=nil and clear>0) then ClearLCD() end
         OutputLCDMessage(f_AlignL(string, position), time)
        if (lbreak~=nil and lbreak>0) then OutputLCDMessage("\n", time) end
    end
end

-- HANDLER FOR LINE ALIGNEMENT
function f_AlignL(f_string, f_align, f_break, f_upper, f_lspace, f_border, vBox) -- align line
    if (vBox~=nil and type(vBox)=="table") then dispW=vBox[2] else dispW=160 end -- get display width
    if checkERRORS~=nil then -- check error or empty string
    else
        f_pixl=f_str2pixl(f_string) -- get pixels of string
        if (f_upper~=nil and f_upper==1) then -- check string 2 upper string
            n_string="";for i=1,string.len(f_string),1 do n_string=n_string..string.upper(string.sub(f_string,i,i)) end
            f_string=n_string;n_string=nil;f_pixl=f_str2pixl(f_string)
        end
        if (f_lspace~=nil and f_lspace>0) then -- check letterspacing
            f_lspace=(math.ceil(f_lspace/2)*2) -- set space to even number
            n_string="";for i=1,(string.len(f_string)-1),1 do n_string=n_string..string.sub(f_string,i,i)..string.char(32) end; n_string=n_string..string.sub(f_string,string.len(f_string),string.len(f_string))
            f_string=n_string;n_string=nil;f_pixl=f_str2pixl(f_string)
        end
        if (f_border~=nil and type(f_border)=="table") then -- check border
            if (f_border[1]==nil or f_border[1]<1) then f_border[1]=0 end;if (f_border[2]==nil or f_border[2]<1) then f_border[2]=0 end
            if (f_border[1]>0 or f_border[2]>0) then
                f_border[1]=(math.ceil(f_border[1]/2)*2);f_border[1]=(math.ceil(f_border[1]/2)*2) -- set bordersize to even number
                if f_border[1]==0 then l_border="" else l_border=""; for i=1,f_border[1],1 do l_border=l_border..string.char(32) end end
                if f_border[2]==0 then r_border="" else r_border=""; for i=1,r_border[2],1 do r_border=r_border..string.char(32) end end
                f_string=l_border..f_string..r_border;l_border=nil;r_border=nil;f_pixl=f_pixl+f_border[1]+f_border[2]
            end
        end
        pixl=f_pixl
        if pixl<=dispW then 
            spacepixl=dispW-pixl
            if ((f_align=="c" and spacepixl>=4) or (spacepixl>=2 and f_align~="c")) then
                sp_str=""
                if f_align=="c" then spacepixl=math.floor(spacepixl/2) end
                if spacepixl>=2 then for i=1,math.floor(spacepixl/2) do sp_str=sp_str..f_string.char(32) end end
                if f_align=="l" then f_string=f_string
                elseif f_align=="r" then f_string=sp_str..f_string
                elseif f_align=="c" then f_string=sp_str..f_string
                elseif f_align=="b" then
                    str_parts=f_explode(" ", f_string); parts=table.getn(str_parts)
                    if parts>1 then
                        if spacepixl>=parts*2 then
                            sp2add=math.floor(spacepixl/2);spPsp=math.floor(sp2add/(parts-1)); rest=sp2add-spPsp*(parts-1)
                            if spPsp>0 then sp_str=f_string.char(32); for i=1,spPsp,1 do sp_str=sp_str..f_string.char(32) end end
                            f_string=""
                            for i=1,parts,1 do 
                                if i<parts then 
                                    if rest>0 then f_string=f_string..str_parts[i]..sp_str..f_string.char(32); rest=rest-1
                                    else f_string=f_string..str_parts[i]..sp_str end
                                else f_string=f_string..str_parts[i] end
                            end
                        end
                    end
                else OutputLogMessage("f_ERROR: BAD FORMAT @ f_align\n"); return "f_ERROR: BAD FORMAT!" end
                return f_string
            else return f_string
            end
        else -- crop
            for i=1,string.len(f_string),1 do 
                if f_str2pixl(string.sub(f_string,1,i))<=dispW then stringC=string.sub(f_string,1,i) else break; end
            end
            return stringC
        end
    end
end

function f_str2pixl(string) -- converts string to LCD pixels
    pixl=0
    if f_pixl==nil then f_pixl=f_getPixl() end
    for i=1,string.len(string),1 do
        found=nil
        for j=1,table.getn(f_pix),1 do
            for k=1,table.getn(f_pix[j]) do
                if string.sub(string,i,i)==f_pix[j][k] then pixl=pixl+j;found=1 end
            end
        end
        if found==nil then OutputLogMessage("f_ERROR: UNKNOWN LETTER FOUND: "..string.sub(string,i,i).."\n") end
        -- add exchange unknown letter with ? and add pixl of (?)!
    end
    return pixl
end

function f_explode ( seperator, str ) -- http://luanet.net/lua/function/explode
 	local pos, arr = 0, {}
	for st, sp in function() return string.find( str, seperator, pos, true ) end do
		table.insert( arr, string.sub( str, pos, st-1 ) )
		pos = sp + 1
	end
	table.insert( arr, string.sub( str, pos ) )
	return arr
end

function f_getPixl() -- array of pixel-widthes 
    f_pix={}; f_pix[1]={}
    f_pix[2]={"i","j","l","!","´","'",".",",",":",";","°"," "}
    f_pix[3]={"f","r","t","I","3","{","}","*","-","(",")","[","]",[[\]],[[`]],[[’]]}
    f_pix[4]={"a","c","e","h","k","n","s","u","v","x","y","z","J","L","P","T","Z","4","+","~","<",">","€","^","§","=","$",[["]]}
    f_pix[5]={"b","d","g","o","p","q","E","F","H","R","S","2","3","4","5","6","8","9","0","?","_"}
    f_pix[6]={"m","w","B","C","D","G","K","N","O","Q","U","#"}
    f_pix[7]={"A","V","W","X","Y"}
    f_pix[8]={"M","@"}
    return f_pix
end
--

---------------------------------------------- f_FUNCTIONS ---------------------------------------------------- BIG 3-LINE FONT STUFF

function f_bigFont(str, font)
    if font=="uN" then bigChr=bigChrs() else bigChr=bigChrs2() end
    String={};String[1]="";String[2]="";String[3]=""; width=0
    for i=1,string.len(str),1 do
        sString=string.upper(string.sub(str,i,i)); foundL=nil
        for j=1,table.getn(bigChr),1 do
            if sString==bigChr[j][1] then 
                String[1]=String[1]..bigChr[j][3]; 
                String[2]=String[2]..bigChr[j][4]; 
                String[3]=String[3]..bigChr[j][5]; 
                foundL=1; 
                width=width+bigChr[j][2]
            end
        end
        if foundL==nil then 
            OutputLogMessage("f_ERROR: UNKNOWN LETTER FOUND: "..sString.." \n")
            String[1]=String[1]..bigChr[43][3]; 
            String[2]=String[2]..bigChr[43][4]; 
            String[3]=String[3]..bigChr[43][5]; 
            width=width+bigChr[43][2]
        end
    end
    return String[1].."\n"..String[2].."\n"..String[3] -- return array instead
    --return {String,width}
end



function bigChrs() -- FULL-3-LINE-FONT ... "UN" (UPIA_HIGH:)
    bigChr={}
    -- bigChr[index]= { letter, pixels, line1,line2,line3 }
    bigChr[1]={"1", 8, "´|  "," |  "," |  "}
    bigChr[2]={"2", 16, " "..string.char(175,175).."|  ",","..string.char(6,6).."'  ","|__  "}
    bigChr[3]={"3", 14, string.char(175,175).."|  ",string.char(151).."|  "," _{  "}
    bigChr[4]={"4", 16, "|    |  ","'"..string.char(151).."|  ","     |  "}
    bigChr[5]={"5", 16, "|"..string.char(175,175).."   ","'"..string.char(6,6)..",  ","__|  "}
    bigChr[6]={"6", 18, "|"..string.char(175,175).."    ","| "..string.char(151)..",  ","|__|  "}
    bigChr[7]={"7", 15, string.char(175,175).."/  ","   /   ","  /    "}
    bigChr[8]={"8", 18, "|"..string.char(175).." "..string.char(175).."|  ","|"..string.char(6).." "..string.char(6).."|  ","|__|  "}
    bigChr[9]={"9", 18, "| "..string.char(175,175).."|  ","'"..string.char(6,6).." |  "," __|  "}
    bigChr[10]={"0", 18, "|"..string.char(175).." "..string.char(175).."|  ","|     |  ","|__|  "}
    bigChr[11]={"A", 18, " /"..string.char(175).."\\   ","}"..string.char(151).."{  ","|     |  "}
    bigChr[12]={"B", 14, "}"..string.char(175).."\\  ","}-<  ","|_/  "}
    bigChr[13]={"C", 16, "|"..string.char(175,175).."   ","|       ","|__  "}
    bigChr[14]={"D", 16, "}"..string.char(175).."\\   ","|    |  ","|_/   "}
    bigChr[15]={"E", 14, "|"..string.char(175,175).."  ","|"..string.char(151).."  ","}_   "}
    bigChr[16]={"F", 16, "|"..string.char(175,175).."   ","|"..string.char(151).."   ","|       "}
    bigChr[17]={"G", 18, "|"..string.char(175,175).."'   ","|   "..string.char(6)..",  ","|__|  "}
    bigChr[18]={"H", 16, "|    |  ","|"..string.char(151).."|  ","|    |  "}
    bigChr[19]={"I", 6, "|  ","|  ","|  "}
    bigChr[20]={"J", 14, "  "..string.char(175).."|  ","    |  ","\\_|  "}
    bigChr[21]={"K", 13, "|  /  ","}<   ","|  \\  "}
    bigChr[22]={"L", 16, "|       ","|       ","|__  "}
    bigChr[23]={"M", 18, "|\\  /|  ","| \\/ |  ","|     |  "}
    bigChr[24]={"N", 15, "|\\  |  ","| \\ |  ","|  \\|  "} -- new test
    bigChr[25]={"O", 18, "|"..string.char(175).." "..string.char(175).."|  ","|     |  ","|__|  "}
    bigChr[26]={"P", 16, "|"..string.char(175,175).."|  ","|"..string.char(151).."'  ","|       "}
    bigChr[27]={"Q", 18, "/ "..string.char(175).." \\  ","|     |  ","\\ _x  "}
    bigChr[28]={"R", 18, "|"..string.char(175,175,175).."|  ","|--\\-'  ","}    \\   "}
    bigChr[29]={"S", 16, "|"..string.char(175,175).."   ", "'"..string.char(151)..",  ","__|  "}
    bigChr[30]={"T", 18, "'"..string.char(175).."|"..string.char(175).."'  ","   |     ","   |     "}
    bigChr[31]={"U", 18, "|     |  ","|     |  ","|__|  "}
    bigChr[32]={"V", 16, "\\    /  "," \\  /   ","  \\/    "}
    bigChr[33]={"W", 20, "|      |  ","| /\\  |  ","|/   \\|  "}
    bigChr[34]={"X", 16, "\\   /  "," ><   ","/   \\  "}
    bigChr[35]={"Y", 16, "\\   /  "," \\ /   ","   |    "}
    bigChr[36]={"Z", 19, "’"..string.char(175)..string.char(175).."/   ","    /    ","  /__ "}
    -- Special Characters
    bigChr[37]={" ", 4, "  ","  ","  "}
    bigChr[38]={"_", 14, "       ", "       ", "__  "}
    bigChr[39]={".", 8, "    ", "    ", string.char(7).."  "}
    bigChr[40]={",", 6, "   ", "   ", string.char(204).."  "}
    bigChr[41]={";", 6, "   ", "   ", "j  "}
    bigChr[42]={":", 8, "    ", string.char(19)..[[  ]], string.char(19)..[[  ]]}
    bigChr[43]={"?", 12, string.char(175,175).."| ", " |"..string.char(175).."  ", " "..string.char(7).."   "}
    bigChr[44]={"!", 10, " |   ", " |   ", " "..string.char(7).."  "}
    bigChr[45]={"|", 6, "|  ", "|  ", "|  "}
    bigChr[46]={"/", 11, "  /  ", " /   ", "/    "}
    bigChr[47]={[[\]], 11,[[\    ]], [[ \   ]], [[  \  ]]}
    bigChr[48]={"*", 14, "       ", ">"..string.char(166).."<  ", "       "}
    bigChr[49]={"+", 8, "    ", string.char(16).."  ", "    "}
    bigChr[50]={"-", 12, "      ", string.char(151).."  ", "      "}
    bigChr[51]={"=", 12, "      ", string.char(151)..[[  ]], string.char(151)..[[  ]]}
    bigChr[52]={"%", 13, string.char(7).."/   ", " /    ", "/ "..string.char(7).."  "}
    bigChr[53]={"$", 18, ","..string.char(150).."|"..string.char(150).."   ", "'"..string.char(150).."|"..string.char(150)..",  ", " "..string.char(150).."|"..string.char(150).."'  "}
    bigChr[54]={"#", 20, "  |  |    ", string.char(175).."|"..string.char(175).."|"..string.char(175).."  ", string.char(175).."|"..string.char(175).."|"..string.char(175).."  "}
    bigChr[55]={"(", 9, " /  ", "}   ", " \\  "}
    bigChr[56]={")", 9, "\\   ", " {  ", "/   "}
    bigChr[57]={"[", 10, ","..string.char(150).."  ", "|    ", "'"..string.char(150).."  "}
    bigChr[58]={"]", 10, string.char(150)..",  ", "  |  ", string.char(150).."'  "}
    bigChr[59]={"{", 12, "  ,"..string.char(150).."  ", string.char(150).."|    ", "  '"..string.char(150).."  "}
    bigChr[60]={"}", 12, string.char(150)..",    ", "  |"..string.char(150).."  ", string.char(150).."'    "}
    bigChr[61]={"°", 10, "O  ","     ","     "}
    bigChr[62]={"^", 10, "/\\  ","     ","     "}
    bigChr[63]={"÷", 12, " "..string.char(7).."   ", string.char(151).."  ", " "..string.char(7).."   "}
    bigChr[64]={"‰", 17, string.char(7).."/     ", " /      ", "/ "..string.char(7)..string.char(7).."  "}
    bigChr[65]={"²", 12, "`2  ", "      ", "      "}
    bigChr[66]={"³", 12, "`3  ", "      ", "      "}
    bigChr[67]={"™", 16, "TM  ", "        ", "        "}
    -- Simplified Characters
    bigChr[68]={"@", 10, "     ","@ ","     "}
    bigChr[69]={"<", 8, "    ", "<  ", "    "}
    bigChr[70]={">", 8, "    ", ">  ", "    "}
    bigChr[71]={"§", 8, "    ", "§  ", "    "}
    bigChr[72]={"€", 8, "    ", "€  ", "    "}
    bigChr[73]={"~", 8, "    ", "~  ", "    "}
    bigChr[74]={"©", 8, "    ", "©  ", "    "}
    -- Similar Characters
    return bigChr
end

function bigChrs2() -- FULL-3-LINE-FONT ... "UN" (UPIA_NARROW)
    bigChr={}
    -- bigChr[index]= { letter, pixels, line1,line2,line3 }
    bigChr[1]={"1", 6, ",  ","|  ","|  "}
    bigChr[2]={"2", 16, "__   ","__|  ","|__  "}
    bigChr[3]={"3", 16, "__   ","__|  ","__|  "}
    bigChr[4]={"4", 18, ",     ,  ","|__|  ","      |  "}
    bigChr[5]={"5", 18, " __   ","|__   "," __|  "}
    bigChr[6]={"6", 18, " __   ","|__   ","|__|  "}
    bigChr[7]={"7", 14, "__  ","    |  ","    |  "}
    bigChr[8]={"8", 18, " __   ","|__|  ","|__|  "}
    bigChr[9]={"9", 18, " __   ","|__|  "," __|  "}
    bigChr[10]={"0", 18, " __   ","|     |  ","|__|  "}
    bigChr[11]={"A", 18, " __   ","|__|  ","|     |  "}
    bigChr[12]={"B", 21, "___   "," |__/  "," |__\\  "}
    bigChr[13]={"C", 18, " __   ","|        ","|__   "}
    bigChr[14]={"D", 21, "___   "," |     \\  "," |__/  "}
    bigChr[15]={"E", 16, " __  ","|__  ","|__  "}
    bigChr[16]={"F", 16, " __  ","|__  ","|       "}
    bigChr[17]={"G", 18, " __   ","}  _   ","|__|  "}
    bigChr[18]={"H", 18, ",     ,  ","|__|  ","|     |  "}
    bigChr[19]={"I", 6, ",  ","|  ","|  "}
    bigChr[20]={"J", 14, "    ,  ","    |  ","\\_|  "}
    bigChr[21]={"K", 16, ",    ,  ","|_/   ","}  \\   "}
    bigChr[22]={"L", 16, ",       ","|       ","|__  "}
    bigChr[23]={"M", 18, ",     ,  ","|\\  /|  ","| \\/ |  "}
    bigChr[24]={"N", 16, ",    ,  ","|\\  {  ","}  \\|  "}
    bigChr[25]={"O", 18, " __   ","|     |  ","|__|  "}
    bigChr[26]={"P", 18, " __   ","|__|  ","|        "}
    --bigChr[27]={"Q", 18, "         ","/ "..string.char(175).." \\  ","\\ _x  "}
    bigChr[27]={"Q", 18, " __   ","|     |  ","|_X  "}
    bigChr[28]={"R", 20, " __    ","|__|   ","}  \\     "}
    bigChr[29]={"S", 18, " __   ","|__   "," __|  "}
    bigChr[30]={"T", 16, "_ _  ","  |     ","  |     "}
    bigChr[31]={"U", 18, ",     ,  ","|     |  ","|__|  "}
    bigChr[32]={"V", 16, " ,   ,  "," \\  /  ","  \\/   "}
    bigChr[33]={"W", 20, ",      ,  ","| /\\  |  ","|/   \\|  "}
    bigChr[34]={"X", 16, ",    ,  "," \\ /   ","/   \\  "}
    bigChr[35]={"Y", 16, ",    ,  "," \\_|  ","__|  "}
    bigChr[36]={"Z", 19, "___  ","    /    ","  /__ "}
    -- Special Characters
    bigChr[37]={" ", 4, "  ","  ","  "}
    bigChr[38]={"_", 14, "       ", "       ", "__  "}
    bigChr[39]={".", 8, "    ", "    ", string.char(7).."  "}
    bigChr[40]={",", 6, "   ", "   ", string.char(204).."  "}
    bigChr[41]={";", 6, "   ", "   ", "j  "}
    bigChr[42]={":", 8, "    ", string.char(19)..[[  ]], string.char(19)..[[  ]]}
    bigChr[43]={"?", 12, string.char(175,175).."| ", " |"..string.char(175).."  ", " "..string.char(7).."   "}
    bigChr[44]={"!", 10, " |   ", " |   ", " "..string.char(7).."  "}
    bigChr[45]={"|", 6, "|  ", "|  ", "|  "}
    bigChr[46]={"/", 11, "  /  ", " /   ", "/    "}
    bigChr[47]={[[\]], 11,[[\    ]], [[ \   ]], [[  \  ]]}
    bigChr[48]={"*", 14, "       ", ">"..string.char(166).."<  ", "       "}
    bigChr[49]={"+", 8, "    ", string.char(16).."  ", "    "}
    bigChr[50]={"-", 12, "      ", string.char(151).."  ", "      "}
    bigChr[51]={"=", 12, "      ", string.char(151)..[[  ]], string.char(151)..[[  ]]}
    bigChr[52]={"%", 13, string.char(7).."/   ", " /    ", "/ "..string.char(7).."  "}
    bigChr[53]={"$", 18, ","..string.char(150).."|"..string.char(150).."   ", "'"..string.char(150).."|"..string.char(150)..",  ", " "..string.char(150).."|"..string.char(150).."'  "}
    bigChr[54]={"#", 20, "  |  |    ", string.char(175).."|"..string.char(175).."|"..string.char(175).."  ", string.char(175).."|"..string.char(175).."|"..string.char(175).."  "}
    bigChr[55]={"(", 9, " /  ", "}   ", " \\  "}
    bigChr[56]={")", 9, "\\   ", " {  ", "/   "}
    bigChr[57]={"[", 10, ","..string.char(150).."  ", "|    ", "'"..string.char(150).."  "}
    bigChr[58]={"]", 10, string.char(150)..",  ", "  |  ", string.char(150).."'  "}
    bigChr[59]={"{", 12, "  ,"..string.char(150).."  ", string.char(150).."|    ", "  '"..string.char(150).."  "}
    bigChr[60]={"}", 12, string.char(150)..",    ", "  |"..string.char(150).."  ", string.char(150).."'    "}
    bigChr[61]={"°", 10, "O  ","     ","     "}
    bigChr[62]={"^", 10, "/\\  ","     ","     "}
    bigChr[63]={"÷", 12, " "..string.char(7).."   ", string.char(151).."  ", " "..string.char(7).."   "}
    bigChr[64]={"‰", 17, string.char(7).."/     ", " /      ", "/ "..string.char(7)..string.char(7).."  "}
    bigChr[65]={"²", 12, "`2  ", "      ", "      "}
    bigChr[66]={"³", 12, "`3  ", "      ", "      "}
    bigChr[67]={"™", 16, "TM  ", "        ", "        "}
    -- Simplified Characters
    bigChr[68]={"@", 12, "      ","@  ","      "}
    bigChr[69]={"<", 8, "    ", "<  ", "    "}
    bigChr[70]={">", 8, "    ", ">  ", "    "}
    bigChr[71]={"§", 8, "    ", "§  ", "    "}
    bigChr[72]={"€", 8, "    ", "€  ", "    "}
    bigChr[73]={"~", 8, "    ", "~  ", "    "}
    bigChr[74]={"©", 8, "    ", "©  ", "    "}
    -- Similar Characters 
    return bigChr
end

function clock() -- sample for a script clock
    OutputLogMessage("STOP CLOCK BY HOLDING RIGHT CONTROL!!!\n")
    loop=1
    while loop==1 do
        time = string.sub(GetDate(),10,17)
        ClearLCD();OutputLCDMessage(f_bigFont(time, "uN").."\nstop with [RightCONTROL]",1100)
        if IsModifierPressed("rctrl") then loop=0;break end
        Sleep(1000)
    end
end


function bigNums_wide() -- old, not used, but working
    bigNum={}
    bigNum[1]={",  ","|  ","|  "}
    bigNum[2]={"___   ","___|  ","|___  "}
    bigNum[3]={"___   ","___|  ","___|  "}
    bigNum[4]={"            ","/___|  ","      `|  "}
    bigNum[5]={" ___   ","|___   "," ___|  "}
    bigNum[6]={" ___   ","|___   ","|___|  "}
    bigNum[7]={"___  ","    /   ","   /    "}
    bigNum[8]={" ___   ","|___|  ","|___|  "}
    bigNum[9]={" ___   ","|___|  "," ___|  "}
    bigNum[0]={" ___   ","|   `   |  ","|___|  "}
    return bigNum
end

function getText() -- sample text
text= "What we have here is one team that won’t be satisfied with anything less than a championship, along with four teams who would be satisfied just to make the playoffs.\n"..
        "GOLDEN STATE WARRIORS\nWith Nellie’s monstrous, all-consuming ego banished to Hawaii, the Warriors will be more disciplined, more spirited and more harmonious.\n"..
        "Warriors at a glance\nGolden State Warriors Looking for the latest on the Warriors? Get the inside slant, stats, scores, schedules and more scoops right here."
return text
end
