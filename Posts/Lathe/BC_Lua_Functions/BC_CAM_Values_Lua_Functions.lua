--[[
    The following functions are used throught out other functions
    in this file
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
    Format a number to a specified number of decimal places, with an optional leading zero and thousands separator
    args:
        num: The number to be formatted
        numDecimalPlaces: The number of decimal places to round to
        [includeLeadingZero]: (Optional) Whether to include a leading zero for numbers less than 1. Default is false.
        [useThousandsSeparator]: (Optional) Whether to include a thousands separator. Default is false.
    returns:
        The formatted number as a string
]]
function formatNumber(args)
    -- Provide default values for optional parameters
    local num = args.num
    local numDecimalPlaces = args.numDecimalPlaces or 0
    local includeLeadingZero = args.includeLeadingZero or false
    local useThousandsSeparator = args.useThousandsSeparator or false
    local includeDotAfterInt = args.includeDotAfterInt or false


    -- Round to the specified number of decimal places
    local mult = 10^(numDecimalPlaces or 0)
    num = math.floor(num * mult + 0.5) / mult

    -- Convert to string to manipulate as string
    local numStr = tostring(num)

    -- Remove leading zero if necessary
    if not includeLeadingZero and num > 0 and num < 1 then
        numStr = numStr:sub(2)
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

    return numStr
end
--[[
-- Scenario 1: Format a number with 2 decimal places, include leading zero, and use thousands separator
print(formatNumber({num = 1234.5678, numDecimalPlaces = 2, includeLeadingZero = true, useThousandsSeparator = true}))  -- Outputs: 1,234.57

-- Scenario 2: Format a number with no decimal places, include leading zero, and use thousands separator
print(formatNumber({num = 1234.5678, numDecimalPlaces = 0, includeLeadingZero = true, useThousandsSeparator = true}))  -- Outputs: 1,235

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
]]



--[[
    Lua functions used in the post processor
    Use lua_func_FunctionName
        FunctionName: The name of the function to be used in the post block
    If the function takes an argument, use lua_func_FunctionName(argument)
        argument: The argument to be used in the function
]]

--[[
    Convert a pitch value to threads per inch for the Lathe Thread operation
    args:
        prefix: The prefix to be used in the threads per inch value
    Returns:
        The threads per inch value rounded to the nearest whole number
    Set in Post Processor:
        Use lua_func_ThreadsPerInch("prefix")
        Or, call ThreadsPerInch(prefix) in Lua Blocks (2701 - 2799)
    Used for Post Blocks:
        1087 (Start of thread (G76) cycle)
]]
function ThreadsPerInch(prefix)
    function GetValue(searchKey)
        local op_id = BcPost.GetValueOfOperation("ID")
        local retTable = Bcc.GetCamObjParameters(op_id)

        for key, value in pairs(retTable) do
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

    local pitch = GetValue("thread_pitch")

    if pitch then
        -- Bcc.ShowMessageBox(searchKey .. ": " .. tostring(pitch), {Title="Value from Toolpath Operation"})
    else
        Bcc.ShowMessageBox("Key or subkey not found. For a lathe thread operation, please use threads per inch.", {Title="Error"})
    end


    local threads_per_inch = "E" .. round(1 / round(pitch, 4), 0)
    -- Bcc.ShowMessageBox(threads_per_inch)

    return threads_per_inch
end