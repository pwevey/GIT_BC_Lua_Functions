--[[
    The following functions are used throught out other functions
    in this file
]]

--[[
    Round a number to a specified number of decimal places
]]
function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end


--[[
    Lua functions used in the post processor
    Use lua_func_FunctionName
        FunctionName: The name of the function to be used in the post block
    If the function takes an argument, use lua_func_FunctionName(argument)
        argument: The argument to be used in the function
]]

--[[
    Convert a pitch value to threads per inch for the Lathe Thread operation
    Parameters:
        prefix: The prefix to be used in the threads per inch value
    Returns:
        The threads per inch value rounded to the nearest whole number
    Set in Post Processor:
        Use lua_func_ThreadsPerInch("prefix")
        prefix: The prefix to be used for the threads per inch value
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