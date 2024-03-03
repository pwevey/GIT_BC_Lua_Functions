--[[
    TODO: Evaluate ThreadsPerInch(prefix) so that you can place the lua_func_ on the same line as of post variables
            Link: https://bobcad.atlassian.net/servicedesk/customer/portal/3/BIT-864
]]

--[[
    The following functions are used throught out other functions
    in this file
    
    functions in camelCase are general functions
    functions in PascalCase contain BobCAD Lua API functions
]]

--[[
    Round a number to a specified number of decimal places
    args:
        num: The number to be rounded
        numDecimalPlaces: The number of decimal places to round to
    returns:
        The rounded number
]]
function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end


--[[
    Format a number to a specified number of decimal places, with optional leading zero, thousands separator, and dot after integer.
    args: A table with the following keys:
        num: (required) The number to be formatted
        numDecimalPlaces: The number of decimal places to round to. Default is round to nearest whole number.
        multiplier: (Optional) A multiplier to be applied to the number before formatting. Default is 1.
        includeLeadingZero: (Optional) Whether to include a leading zero for numbers less than 1. Default is true.
        useThousandsSeparator: (Optional) Whether to include a thousands separator. Default is false.
        includeDotAfterInt: (Optional) Whether to include a dot after the integer part if the number is a whole number. Default is true.
        prefix: (Optional) A prefix to be added to the formatted number. (Primarily used for BobCAD API functions)
    returns:
        The formatted number as a string
]]
function formatNumber(args)
    -- Check if num parameter is provided
    if args.num == nil then
        Bcc.ShowMessageBox("Error: 'num' parameter is missing or not a number (formatNumber lua function). \nMake sure you provide the num parameter. \n\neg. lua_func_formatNumber({num = -1234.5678, numDecimalPlaces = 2})", {Title="formatNumber function Error"})
        return
    end
    
    -- Provide default values for optional parameters
    local num = args.num
    local prefix = args.prefix or ""
    -- Bcc.ShowMessageBox("init num: "..num)
    
    -- If num is a function (BobCAD API), call it and use its return value
    if type(num) == "string" then
        num = BcPost.RunVBApi(num)
        -- Bcc.ShowMessageBox("API num: "..num)
    end

    local numDecimalPlaces = args.numDecimalPlaces or 0
    local useThousandsSeparator = args.useThousandsSeparator or false
    local multiplier = args.multiplier or 1

    local includeDotAfterInt = args.includeDotAfterInt
    if includeDotAfterInt == nil then includeDotAfterInt = true end

    local includeLeadingZero = args.includeLeadingZero
    if includeLeadingZero == nil then includeLeadingZero = true end

    -- Apply the multiplier
    num = num * multiplier

    -- Round to the specified number of decimal places
    local mult = 10^(numDecimalPlaces or 0)
    if num >= 0 then
        num = math.floor(num * mult + 0.5) / mult
    else
        num = math.ceil(num * mult - 0.5) / mult
    end

    -- Convert to string to manipulate as string
    local numStr = tostring(num)

    
    -- Remove leading zero if necessary
    if not includeLeadingZero and num > 0 and num < 1 then
        numStr = numStr:sub(2)
    end

    -- If the number is 0 after rounding, set numStr to "0" directly
    if num == 0 then
        numStr = "0"
    else
        -- Remove leading zero if necessary
        if not includeLeadingZero and num > -1 and num < 0 then
            numStr = "-" .. numStr:sub(3)
        end
    end

    -- Add thousands separator if necessary
    if useThousandsSeparator then
        local beforeDecimal, afterDecimal = numStr:match("([^.]*)%.?(.*)")
        beforeDecimal = beforeDecimal:reverse():gsub("(%d%d%d)", "%1,"):reverse()
        numStr = beforeDecimal .. (afterDecimal ~= "" and "." .. afterDecimal or "")
    end

    -- Add dot after integer if necessary
    if includeDotAfterInt and num == math.floor(num) then
        numStr = numStr .. "."
    end

    -- Add prefix if necessary
    if prefix ~= "" then
        numStr = prefix .. numStr
    end


    -- Show the formatted number in a message box
    -- Bcc.ShowMessageBox(numStr)

    return numStr
end
--[[
-- Scenario 1: Format a number with 2 decimal places, include leading zero, and use thousands separator
print(formatNumber({num = 1234.5678, numDecimalPlaces = 2, includeLeadingZero = true, useThousandsSeparator = true}))  -- Outputs: 1,234.57

-- Scenario 2: Format a number with no decimal places, include leading zero, and use thousands separator
print(formatNumber({num = 1234.5678, numDecimalPlaces = 0, includeLeadingZero = true, useThousandsSeparator = true}))  -- Outputs: 1,235.

-- Scenario 3: Format a number with 2 decimal places, include leading zero, and do not use thousands separator
print(formatNumber({num = 1234.5678, numDecimalPlaces = 2, includeLeadingZero = true, useThousandsSeparator = false}))  -- Outputs: 1234.57

-- Scenario 5: Format a fractional number with 2 decimal places, include leading zero, and use thousands separator
print(formatNumber({num = 0.5678, numDecimalPlaces = 2, includeLeadingZero = true, useThousandsSeparator = true}))  -- Outputs: 0.57

-- Scenario 6: Format a number with 3 decimal places, do not include leading zero, and use thousands separator
print(formatNumber({num = 0.5678, numDecimalPlaces = 3, includeLeadingZero = false, useThousandsSeparator = true}))  -- Outputs: .568

-- Scenario 7: Round a number only
print(formatNumber({num = 1234.5678, numDecimalPlaces = 1}))  -- Outputs: 1234.6

-- Scenario 8: Include a dot after the integer
print(formatNumber({num = 24, numDecimalPlaces = 0, includeDotAfterInt = true}))  -- Outputs: 24.

-- Scenario 9: do not include leading zero 0 
print(formatNumber({num = 0.125, numDecimalPlaces = 2, includeLeadingZero = false}))  -- Outputs: .13

-- Scenario 10: do not include leading zero 0 for negative number 
print(formatNumber({num = -0.125, numDecimalPlaces = 2, includeLeadingZero = false}))  -- Outputs: -.13

-- Scenario 10: include leading zero 0 for negative number 
print(formatNumber({num = -0.125, numDecimalPlaces = 2, includeLeadingZero = true}))  -- Outputs: -0.13

-- Scenario 11: Format a negaitve number with 2 decimal places
print(formatNumber({num = -1234.5678, numDecimalPlaces = 2}))  -- Outputs: -1234.57

-- Scenario 12: include leading zero 0 for negative number 
print(formatNumber({num = -0.125, numDecimalPlaces = 2}))  -- Outputs: -0.13

-- Scenario 13: Do not include a dot after the negaitve integer
print(formatNumber({num = -24.35443, numDecimalPlaces = 0, includeDotAfterInt = false}))  -- Outputs: -24

-- Scenario 14: Do not include a dot after the integer
print(formatNumber({num = 24.35443, numDecimalPlaces = 0, includeDotAfterInt = false}))  -- Outputs: 24

-- Scenario 15: negative number with 3 decimal places and no leading zero
print(formatNumber({num = -.35453, numDecimalPlaces = 3, includeLeadingZero = false}))  -- Outputs: -.355

print(formatNumber({num = .35453})) -- Outputs: 0.

print(formatNumber({num = -.35453})) -- Outputs: 0.

print(formatNumber({num = -3.35453})) -- Outputs: -3.

print(formatNumber({num = 3.35453, includeDotAfterInt = false})) -- Outputs: 3

-- Error: ShowMessageBox will display an error message
print(formatNumber({includeDotAfterInt = false})) -- Outputs: Error, no num parameter provided

-- Scenario: Will return a bobcad api function value with the number formatted
-- lua_func_formatNumber({num = "MILL_GetXRapid", numDecimalPlaces = 1 , includeDotAfterInt = false}) -- Outputs 2.3

-- lua_func_formatNumber({num = "MILL_GetXRapid", prefix = "X", numDecimalPlaces = 1 , includeDotAfterInt = false}) -- Outputs X2.3
]]




--[[
    Convert an angle between degrees and radians.
    args:
        angle: The angle to be converted
        mode: The conversion mode. Can be "degreesToRadians" or "radiansToDegrees".
    returns:
        The converted angle

]]
function convertAngle(angle, mode)
    local pi = math.pi
    if mode == "degreesToRadians" then
        -- Bcc.ShowMessageBox("Angle in Radians: " .. angle * (pi / 180))
        return angle * (pi / 180)
    elseif mode == "radiansToDegrees" then
        -- Bcc.ShowMessageBox("Angle in Radians: " .. angle * (180 / pi))
        return angle * (180 / pi)
    else
        error("Invalid mode: " .. mode)
    end
end
--[[
local radians = convertAngle(180, "degreesToRadians")  -- Outputs: 3.1415926535898 (which is pi)
print(radians)
local degrees = convertAngle(radians, "radiansToDegrees")  -- Outputs: 180
print(degrees)
]]



--[[
    Below are Lua functions used in the post processor
    Method 1:
        Use lua_func_FunctionName
            FunctionName: The name of the function to be used in the post block
        If the function takes an argument, use lua_func_FunctionName(argument)
            argument: The argument to be used in the function
    Method 2:
        Call the function directly in a lua block (2701 - 2799)
]]

--[[
    Get a value from the current operation based on a search key.
        searchKey: The key to search for in the operation's parameters.
    Returns:
        The value associated with the search key, or nil if the key is not found.

    Usage scenarios:
        -- Get the thread pitch from the current operation
        local threadPitch = GetValueFromOperation("thread_pitch")  -- Outputs: The value of thread_pitch, or nil if not found
]]
function GetValueFromOperation(searchKey)
    local op_id = BcPost.GetValueOfOperation("ID")
    local ret_table = Bcc.GetCamObjParameters(op_id)

    for key, value in pairs(ret_table) do
        if key == searchKey then
            return value
        end

        if type(value) == "table" then
            for k, v in pairs(value) do
                if k == searchKey then
                    return v
                end
            end
        end
    end

    return nil
end


--[[ General FUNCTIONS ]]

--[[
    Outputs a comment in the NC file with the units of the job.
    Returns:
        Outputs a comment in the NC file with the units of the job.
    Set in Post Processor:
        Use lua_func_UnitsComment
    Used for Post Blocks:
        Used for start of file blocks, but could also be used in tool change blocks as well
        630 and 631: Adjust these post questions to set the comment syntax
]]
function UnitsComment()
    local units = GetValueFromOperation("Unit")
	-- Bcc.ShowMessageBox("ArcIvalue: " .. ArcIvalue ..  "\nArcKvalue: " .. ArcKvalue, {Title="Arc Center Values"})

	BcPost.ProcessPostLine("comment_start,'Units: "..units.." ',comment_end")
end


--[[ LATHE FUNCTIONS ]]

--[[
    Convert a pitch value to threads per inch for the Lathe Thread Operation
    args:
        prefix: The prefix to be used in the threads per inch value
    Returns:
        The threads per inch value with a prefix rounded to the nearest whole number
    Set in Post Processor:
        Use lua_func_ThreadsPerInch("prefix")
        Or, call ThreadsPerInch(prefix) in Lua Blocks (2701 - 2799)
    Used for Post Blocks:
        1087 (Start of thread (G76) cycle)
]]
function ThreadsPerInch(prefix)

    local pitch = GetValueFromOperation("thread_pitch")

    if pitch then
        -- Bcc.ShowMessageBox(searchKey .. ": " .. tostring(pitch), {Title="Value from Toolpath Operation"})
    else
        Bcc.ShowMessageBox("Key or subkey not found. This function is meant for a lathe thread operation.", {Title="ThreadsPerInch(prefix) Function Error"})
    end


    local threads_per_inch = prefix .. round(1 / pitch, 0)
    -- Bcc.ShowMessageBox(threads_per_inch)

    return threads_per_inch
end


--[[
    Outputs the Lathe arc move post block with I values converted from diameter to radius
    Returns:
        The whole post block for the Lathe Arc Move (Post Block: 1025) with I values converted from diameter to radius
    Set in Post Processor:
        Use lua_func_RadiusIArcMoveBlock1025
    Used for Post Blocks:
        1025 (Arc move (Lathe))
]]
function RadiusIArcMoveBlock1025()
    local arc_i_value = "I" .. round(BcPost.RunVBApi("LATHE_GetArcCenterX"), 4)
	local arc_k_value = "K" .. round(BcPost.RunVBApi("LATHE_GetArcCenterZ"), 4)
	-- Bcc.ShowMessageBox("ArcIvalue: " .. ArcIvalue ..  "\nArcKvalue: " .. ArcKvalue, {Title="Arc Center Values"})

	BcPost.ProcessPostLine("n,g_arc_move,x_f,z_f,'"..arc_i_value.."','"..arc_k_value.."',feed_rate")
end


--[[ MILL FUNCTIONS ]]

--[[
    Check if a dwell exists and ouput with a prefix if it does
    This function is needed for Peck Drilling cycles since they do not 
    have a separate dwell post block
    args:
        prefix: The prefix to be used in the dwell value
    Returns:
        The dwell value with a prefix if dwell exists, otherwise nil
    Set in Post Processor:
        Use lua_func_IfDwellOutput("prefix")
        Or, call IfDwellOutput(prefix) in Lua Blocks (2701 - 2799)
    Used for Post Blocks:
        73. High speed peck drill canned cycle - Fast peck
        83. Peck drill canned cycle
        Any other post block that uses a 'dwell' post variable
]]
function IfDwellOutput(prefix)
    local dwell = round(BcPost.RunVBApi("MILL_GetDwell"), 4)

    if dwell ~= 0 then
        dwell = prefix .. dwell
        return dwell
    end

    return nil
end
