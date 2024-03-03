--[[
    ShowOperationData function
    This function retrieves the current operations ID value of the Operation in the CAM Tree,
    iterates through the returned table and displays the key-value pairs in a message box.
    Use ShowValueFromOperation function to extract the key or subkey you need to use
    
    functions in camelCase are general functions
    functions in PascalCase contain BobCAD Lua API functions
]]
function ShowOperationData()
    -- Get the current operations ID value in the CAM Tree
    local op_id = BcPost.GetValueOfOperation("ID")

    -- Bcc.ShowMessageBox(type(op_id) .. " " .. op_id) -- Should be a number

    local retTable = Bcc.GetCamObjParameters(op_id)

    -- Initialize an empty string to hold the table values
    local table_values = ""

    -- Iterate through the table
    for key, value in pairs(retTable) do
        -- Check if value is a table
        if type(value) == "table" then
            -- If it's a table, iterate through it and add its values to the string
            for k, v in pairs(value) do
                table_values = table_values .. "Key: " .. key .. ", Subkey: " .. k .. ", Value: " .. tostring(v) .. "\n"
            end
        else
            -- If it's not a table, add it to the string as before
            table_values = table_values .. "Key: " .. key .. ", Value: " .. tostring(value) .. "\n"
        end
    end

    -- Show the table values in a message box
    Bcc.ShowMessageBox(table_values, {Title="ALL Operation Data"})
end


--[[
    ShowValueFromOperation function
    This function takes a searchKey as an argument, retrieves the current operations ID value in the CAM Tree,
    iterates through the returned table and returns the value of the key or subkey that matches the searchKey.
    If the key or subkey is not found, it returns nil.
    Use ShowOperationData function to find out to key you need to use
]]
function ShowValueFromOperation(searchKey)
    -- Get the current operations ID value in the CAM Tree
    local op_id = BcPost.GetValueOfOperation("ID")

    local retTable = Bcc.GetCamObjParameters(op_id)

    -- Bcc.ShowMessageBox(searchKey)

    -- Iterate through the table
    for key, value in pairs(retTable) do
        -- Check if the key matches the search key
        if key == searchKey then
            Bcc.ShowMessageBox("Value: " .. tostring(value), {Title="Value from Toolpath Operation"})
            return value
        end

        -- Check if value is a table
        if type(value) == "table" then
            -- If it's a table, iterate through it
            for k, v in pairs(value) do
                -- Check if the subkey matches the search key
                if k == searchKey then
                    Bcc.ShowMessageBox(searchKey .. ": " .. tostring(v), {Title="Value from Toolpath Operation"})
                    return v
                end
            end
        end
    end

    -- If the key or subkey was not found, show an error message
    Bcc.ShowMessageBox("Key or subkey not found", {Title="Error"})
end

