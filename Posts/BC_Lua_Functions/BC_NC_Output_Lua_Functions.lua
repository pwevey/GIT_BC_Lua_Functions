--[[
    Function: round
    Description: Round a number to a specified number of decimal places
    Revision History:
        Version: 1.0 (2024-03-21) Author: Paul Wever
    Args:
        num: The number to be rounded
        numDecimalPlaces: The number of decimal places to round to
    Returns:
        The rounded number
]]
function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    if num >= 0 then
        return math.floor(num * mult + 0.5) / mult
    else
        return math.ceil(num * mult - 0.5) / mult
    end
end


--[[
    Function: formatNumber
    Description: Format a number to a specified number of decimal places, with optional leading zero, thousands separator, 
    and dot after integer.
    Revision History:
        Version: 1.0 (2024-03-21) Author: Paul Wever
    Args: A table with the following keys:
        num: (required) The number to be formatted
        numDecimalPlaces: The number of decimal places to round to. Default is rounded to 4 decimal places.
        multiply: (Optional) A multiplier to be applied to the number before formatting. Default is 1.
        add: (Optional) A value to be added to the number before formatting. Default is 0.
        subtract: (Optional) A value to be subtracted from the number before formatting. Default is 0.
        divide: (Optional) A value to be divided by the number before formatting. Default is 1.
        includeLeadingZero: (Optional) Whether to include a leading zero for numbers less than 1. Default is true.
        useThousandsSeparator: (Optional) Whether to include a thousands separator. Default is false.
        includeDotAfterInt: (Optional) Whether to include a dot after the integer part if the number is a whole number. Default is true.
        prefix: (Optional) A prefix to be added to the formatted number. (Primarily used for BobCAD API functions)
        noOutputIfZero: (Optional) If true, the function will return nil if the number is 0. Default is false.
    returns:
        The formatted number as a string
    Example:
        In a post block: (If X Rapid plane is 2.25 (radius))
        lua_func_formatNumber({num = "MILL_GetXRapid", numDecimalPlaces = 1 , includeDotAfterInt = false, multiply = 100, prefix = "X"}) // Outputs: X225
    Dependencies:
        This function does NOT depend on other lua functions in this file
]]
-- Define a global flag for the error message
formatNumberErrorMessageShown = false

function formatNumber(args)
    -- Check if num parameter is provided
    if args.num == nil then
        -- Only show the error message if it hasn't been shown before
        if not formatNumberErrorMessageShown then
            Bcc.ShowMessageBox("Error: 'num' parameter is missing or not a number (formatNumber lua function). \nMake sure you provide the num parameter. \n\neg. lua_func_formatNumber({num = -1234.5678, numDecimalPlaces = 2})", {Title="formatNumber function Error"})
            formatNumberErrorMessageShown = true
        end
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

    local numDecimalPlaces = args.numDecimalPlaces or 4
    local useThousandsSeparator = args.useThousandsSeparator or false
    local noOutputIfZero = args.noOutputIfZero or false
    local multiplier = args.multiply or 1
    local add = args.add or 0
    local subtract = args.subtract or 0
    local divide = args.divide or 1

    local includeDotAfterInt = args.includeDotAfterInt
    if includeDotAfterInt == nil then includeDotAfterInt = true end

    local includeLeadingZero = args.includeLeadingZero
    if includeLeadingZero == nil then includeLeadingZero = true end

    -- Apply the multiplier, addition, subtraction, and division
    num = num * multiplier
    num = num / divide
    num = num + add
    num = num - subtract

    -- Round to the specified number of decimal places
    local mult = 10^(numDecimalPlaces or 0)
    if num >= 0 then
        num = math.floor(num * mult + 0.5) / mult
    else
        num = math.ceil(num * mult - 0.5) / mult
    end

    -- Convert to string to manipulate as string
    local numStr = tostring(num)

    
    -- If the number is 0 after rounding, set numStr to "0" directly
    if num == 0 then
        numStr = "0"
        -- If noOutputIfZero is true, return nil
        if noOutputIfZero then
            return nil
        end
    else
        -- Remove leading zero if necessary
        if not includeLeadingZero and num > -1 and num < 0 then
            numStr = "-" .. numStr:sub(3)
        end
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
    Function: convertAngle
    Description: Convert an angle between degrees and radians.
    Revision History:
        Version: 1.0 (2024-03-21) Author: Paul Wever
    Args:
        angle: The angle to be converted
        mode: The conversion mode. Can be "degreesToRadians" or "radiansToDegrees".
        numDecimalPlaces: (Optional) The number of decimal places to round to. Default is no rounding.
    returns:
        The converted angle
    Dependencies:
        round: to round the result to the specified number of decimal places       
]]
function convertAngle(angle, mode, numDecimalPlaces)
    local pi = math.pi
    local result
    if mode == "degreesToRadians" then
        result = angle * (pi / 180)
    elseif mode == "radiansToDegrees" then
        result = angle * (180 / pi)
    else
        error("Invalid mode: " .. mode)
    end

    if numDecimalPlaces then
        return round(result, numDecimalPlaces)
    else
        return result
    end
end
--[[
local radians = convertAngle(180, "degreesToRadians")  -- Outputs: 3.1415926535898 (which is pi)
print(radians)
local degrees = convertAngle(radians, "radiansToDegrees")  -- Outputs: 180
print(degrees)
local radians = convertAngle(180, "degreesToRadians", 3)  -- Outputs: 3.142 (which is pi)
print(radians)
local degrees = convertAngle(radians, "radiansToDegrees", 4)  -- Outputs: 180
print(degrees)
]]


--[[
    Function: includeDotAfterNum
    Description: Include a dot after the integer numbers
    Revision History:
        Version: 1.0 (2024-03-21) Author: Paul Wever
    Args:
        num: The number to be formatted
        includeDotAfterInt: (true or false) Whether to include a dot after the integer part of the number
    returns:
        The number with a dot after the integer part if includeDotAfterInt is true
]]
function includeDotAfterNum(num, includeDotAfterInt)
    -- Convert num to a string
    num = tostring(num)

    -- If includeDotAfterInt is true and num is a whole number, add a dot after the integer part of num
    if includeDotAfterInt and num == tostring(math.floor(num)) then
        num = num .. "."
    end

    return num
end



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
    Function: GetValueFromOperation
    Description: Get a value from the current operation based on a search key.
    Args:
        searchKey: The key to search for in the operation's parameters.
    Revision History:
        Version: 1.0 (2024-03-21) Author: Paul Wever
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

    Bcc.MessageBox("The operation_value used was not found. Please use lua_func_ShowOperationData in a Post Block\n for the target Toolpath Operation to find out what 'operation_value' should be used.")
    return nil
end


--[[ General FUNCTIONS ]]

--[[
    Function: UnitsComment
    Description: Outputs a comment in the NC file with the units of the job.
    Revision History:
        Version: 1.0 (2024-03-21) Author: Paul Wever
    Returns:
        Outputs a comment in the NC file with the units of the job.
    Set in Post Processor:
        Use lua_func_UnitsComment
    Used for Post Blocks:
        Used for start of file blocks, but could also be used in tool change blocks as well
        630 and 631: Adjust these post questions to set the comment syntax
    Dependencies:
        This function calls the following functions within this file:
        - GetValueFromOperation: to get the units from the operation
]]
function UnitsComment()
    local units = GetValueFromOperation("Unit")
	-- Bcc.ShowMessageBox("ArcIvalue: " .. ArcIvalue ..  "\nArcKvalue: " .. ArcKvalue, {Title="Arc Center Values"})

	BcPost.ProcessPostLine("comment_start,'Units: "..units.." ',comment_end")
end


--[[ LATHE FUNCTIONS ]]

--[[
    Function: ThreadsPerInch
    Description: Convert a pitch value to threads per inch for the Lathe Thread Operation
    Revision History:
        Version: 1.0 (2024-03-21) Author: Paul Wever
    Args:
        prefix: The prefix to be used in the threads per inch value
        numDecimalPlaces: (Optional) The number of decimal places to round the threads per inch value to. Default is 4.
        includeDotAfterInt: (Optional) (true or false) Whether to include a dot after the integer part of the value
    Returns:
        The threads per inch value with a prefix rounded to the nearest whole number
    Set in Post Processor:
        Use lua_func_ThreadsPerInch("prefix")
        Or, call ThreadsPerInch(prefix) in Lua Blocks (2701 - 2799)
    Used for Post Blocks:
        1087 (Start of thread (G76) cycle)
    Dependencies:
        This function calls the following functions within this file:
        - GetValueFromOperation: to get the pitch value from the operation
        - round: to round the threads per inch value to the nearest whole number
        - includeDotAfterNum: to optionally add a dot after the integer part of the threads per inch value
]]
threadsPerInchErrorMessageShown = false
function ThreadsPerInch(prefix, numDecimalPlaces, includeDotAfterInt)

    local pitch = GetValueFromOperation("thread_pitch")

    if pitch then
        -- Bcc.ShowMessageBox(searchKey .. ": " .. tostring(pitch), {Title="Value from Toolpath Operation"})
    else
        if not threadsPerInchErrorMessageShown then
            Bcc.ShowMessageBox("Key or subkey not found. This function is meant for a lathe thread operation.", {Title="ThreadsPerInch(prefix) Function Error"})
            threadsPerInchErrorMessageShown = true
        end
        return
    end

    numDecimalPlaces = numDecimalPlaces or 4

    local threads_per_inch = round(1 / pitch, numDecimalPlaces)
    threads_per_inch = includeDotAfterNum(threads_per_inch, includeDotAfterInt)
    threads_per_inch = prefix .. threads_per_inch
    -- Bcc.ShowMessageBox(threads_per_inch)

    return threads_per_inch
end


--[[
    Function: GrooveDepth
    Description: Outputs Groove Depth of Cut for a Lathe Groove Canned Cycle and outputs the value multiplied by 
    1000 for inch units and 10000 for metric units
    Revision History:
        Version: 1.0 (2024-03-21) Author: Paul Wever
    Args:
        prefix: A string of the prefix to be used
    Returns:
        The converted value with the specified prefix
    Set in Post Processor:
        lua_func_GrooveDepth("prefix")
    Used for Post Blocks:
        1074. Start of groove (G75) turning cycle
        1078. Start of groove (G74) facing cycle
    Dependencies:
        - round: to round the value to the nearest whole number
        - GetValueFromOperation: to get the depth of cut value from the operation
]]
function GrooveDepth(prefix)
    local units = GetValueFromOperation("Unit") -- "inch" or "metric"
    local depth_of_cut = GetValueFromOperation("depth_of_cut_or_stepover")

    if units == "inch" then
        return prefix .. round(depth_of_cut * 1000, 0)
    elseif units == "metric" then
        return prefix .. round(depth_of_cut * 10000, 0)
    end
end


--[[
    Function: GroovePeckIncrement
    Description: Outputs Groove Peck Increment for a Lathe Groove Canned Cycle and outputs the value multiplied by 
    1000 for inch units and 10000 for metric units
    Revision History:
        Version: 1.0 (2024-03-21) Author: Paul Wever
    Args:
        prefix: A string of the prefix to be used
    Returns:
        The converted value with the specified prefix
    Set in Post Processor:
        lua_func_GroovePeckIncrement("prefix")
    Used for Post Blocks:
        1074. Start of groove (G75) turning cycle
        1078. Start of groove (G74) facing cycle
    Dependencies:
        - round: to round the value to the nearest whole number
        - GetValueFromOperation: to get the Groove Peck Increment value from the operation
]]
function GroovePeckIncrement(prefix)
    local units = GetValueFromOperation("Unit") -- "inch" or "metric"
    local peck_increment = GetValueFromOperation("peck_increment")

    if units == "inch" then
        return prefix .. round(peck_increment * 1000, 0)
    elseif units == "metric" then
        return prefix .. round(peck_increment * 10000, 0)
    end
end


--[[
    Function: DrillPeckIncrement
    Description: Outputs Drill Peck Depth for a Lathe Peck Drill Canned Cycle and outputs the value 
    multiplied by 1000 for inch units and 10000 for metric units
    Revision History:
        Version: 1.0 (2024-03-21) Author: Paul Wever
    Args:
        prefix: A string of the prefix to be used
    Returns:
        The converted value with the specified prefix
    Set in Post Processor:
        lua_func_DrillPeckIncrement("prefix")
    Used for Post Blocks:
        1126. Peck Drill Canned Cycle
    Dependencies:
        - round: to round the value to the nearest whole number
        - GetValueFromOperation: to get the Drill Peck Depth value from the operation
]]
function DrillPeckIncrement(prefix)
    local units = GetValueFromOperation("Unit") -- "inch" or "metric"
    local peck_increment = BcPost.RunVBApi("LATHE_GetPeckIncrement")

    if units == "inch" then
        return prefix .. round(peck_increment * 1000, 0)
    elseif units == "metric" then
        return prefix .. round(peck_increment * 10000, 0)
    end
end


--[[
    Function: RadiusIArcMoveBlock1025
    Description: Outputs the Lathe arc move post block with I values converted from diameter to radius
    Revision History:
        Version: 1.0 (2024-03-21) Author: Paul Wever
    Returns:
        The whole post block for the Lathe Arc Move (Post Block: 1025) with I values converted from diameter to radius
    Set in Post Processor:
        Use lua_func_RadiusIArcMoveBlock1025
    Used for Post Blocks:
        1025 (Arc move (Lathe))
    Dependencies:
        This function calls the following functions within this file:
        - round: to round the I and K values to 4 decimal places
]]
function RadiusIArcMoveBlock1025()
    local arc_i_value = "I" .. round(BcPost.RunVBApi("LATHE_GetArcCenterX"), 4)
	local arc_k_value = "K" .. round(BcPost.RunVBApi("LATHE_GetArcCenterZ"), 4)
	-- Bcc.ShowMessageBox("ArcIvalue: " .. ArcIvalue ..  "\nArcKvalue: " .. ArcKvalue, {Title="Arc Center Values"})

	BcPost.ProcessPostLine("n,g_arc_move,x_f,z_f,'"..arc_i_value.."','"..arc_k_value.."',feed_rate")
end


--[[
    Function: ArcCenterXToRadius
    Description: Outputs the arc center I and K (Or other specified prefix) values for the Lathe Arc Move post block
    Revision History:
        Version: 1.0 (2024-03-21) Author: Paul Wever
    Args:
        prefixI: The prefix to be used in the I value
        prefixK: The prefix to be used in the K value
        numDecimalPlaces: (Optional) The number of decimal places to round the I and K values to. Default is 4.
    Returns:
        The I and K (Or other specified prefix) values for the Lathe Arc Move post block
    Set in Post Processor:
        Use lua_func_ArcCenterXToRadius("I", "K")
        Example Post Block Line: n,g_arc_move,x_f,z_f,lua_func_ArcCenterXToRadius("I", "K"),feed_rate
    Used for Post Blocks:
        1025 (Arc move (Lathe))
    Dependencies:
        This function calls the following functions within this file:
        - round: to round the I and K values to 4 decimal places
]]
-- Define a global flag for the error message
ArcCenterXToRadiuserrorMessageShown = false

function ArcCenterXToRadius(prefixI, prefixK, numDecimalPlaces)
    if tonumber(prefixI) or tonumber(prefixK) then
        if not ArcCenterXToRadiuserrorMessageShown then
            Bcc.ShowMessageBox("Error: 'prefixI' or 'prefixK' parameter is a number (ArcCenterToRadius lua function). \nMake sure you provide both prefix parameters as strings. \n\neg. ArcCenterToRadius(\"I\", \"K\", 4)", {Title="ArcCenterToRadius function Error"})
            ArcCenterXToRadiuserrorMessageShown = true
        end
        return
    end

    if not prefixI or not prefixK then
        if not ArcCenterXToRadiuserrorMessageShown then
            Bcc.ShowMessageBox("Error: 'prefixI' or 'prefixK' parameter is missing (ArcCenterToRadius lua function). \nMake sure you provide both prefix parameters. \n\neg. ArcCenterToRadius(\"I\", \"K\")", {Title="ArcCenterToRadius function Error"})
            ArcCenterXToRadiuserrorMessageShown = true
        end
        return
    end

    numDecimalPlaces = numDecimalPlaces or 4

    local arc_i_value = prefixI .. round(BcPost.RunVBApi("LATHE_GetArcCenterX"), numDecimalPlaces)
    local arc_k_value = prefixK .. round(BcPost.RunVBApi("LATHE_GetArcCenterZ"), numDecimalPlaces)
    return arc_i_value .. " " .. arc_k_value
end


--[[ MILL & LATHE FUNCTIONS ]]

--[[
    Function: IfDwellOutput
    Description: Check if a dwell exists and ouput with a prefix if it does This function is needed for 
    Peck Drilling cycles since they do not have a separate dwell post block
    Revision History:
        Version: 1.0 (2024-03-21) Author: Paul Wever
    Args:
        prefix: The prefix to be used in the dwell value
        includeDotAfterInt: (true or false) Whether to include a dot after the integer part of the value
    Returns:
        The dwell value with a prefix if dwell exists, otherwise nil
    Set in Post Processor:
        Use lua_func_IfDwellOutput("prefix")
        Or, call IfDwellOutput(prefix) in Lua Blocks (2701 - 2799)
    Used for Post Blocks:
        Mill: 
            73. High speed peck drill canned cycle - Fast peck
            83. Peck drill canned cycle
            Any other post block that uses a 'dwell' post variable
        Lathe: 
            1126. Peck drill canned cycle
            1121. High speed peck drill canned cycle
            Any other post block that uses a 'dwell' post variable
    Dependencies:
        This function calls the following functions within this file:
        - round: to round the dwell value to 4 decimal places
        - includeDotAfterNum: to optionally add a dot after the integer part of the dwell value
]]
function IfDwellOutput(prefix, includeDotAfterInt)
    local dwell = round(BcPost.RunVBApi("MILL_GetDwell"), 4)

    if dwell == 0 then
        dwell = round(BcPost.RunVBApi("LATHE_GetDrillDwell"), 4)
    end

    if dwell ~= 0 then
        dwell = includeDotAfterNum(dwell, includeDotAfterInt)
        dwell = prefix .. dwell
        return dwell
    end

    return nil
end


--[[ MILL FUNCTIONS ]]