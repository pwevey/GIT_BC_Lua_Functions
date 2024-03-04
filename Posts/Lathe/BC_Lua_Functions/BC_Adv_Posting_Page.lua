local outputStrings = {}

function CreateCheckBox(args)
    local codeBlock = [[
************ CHECK BOX ************
CHECK_BOX,%s,%s
DEFAULT_CHECK,%s,%s

]]
    local str = string.format(codeBlock, args.setPosition, args.assignCheckBoxLabel, args.setPosition, args.setDefaultToOnOff)
    table.insert(outputStrings, str)
    -- Bcc.ShowMessageBox("createCheckBox output: " .. str)
end


function CreateComboBox(args)
    local choices = table.concat(args.assignChoiceLabels, ",")
    local codeBlock = [[
************ COMBO BOX ************
COMBO_BOX,%s,%s
TEXT_LABEL,%s,%s
DEFAULT_COMBO_INDEX,%s,%s

]]
    local str = string.format(codeBlock, args.setPosition, choices, args.setPosition, args.assignComboBoxLabel, args.setPosition, args.setDefaultSelection)
    table.insert(outputStrings, str)
    -- Bcc.ShowMessageBox("createComboBox output: " .. str)
end


function CreateIntegerEditBox(args)
    local codeBlock = [[
************ EDIT BOX WHOLE NUMBER ************
EDIT_BOX,%d,INTEGER
TEXT_LABEL,%d,%s
DEFAULT_INTEGER,%d,%d

]]
    local str = string.format(codeBlock, args.setPosition, args.setPosition, args.assignEditBoxLabel, args.setPosition, args.setDefaultIntegerNumber)
    table.insert(outputStrings, str)
    -- Bcc.ShowMessageBox("createIntegerEditBox output: " .. str)
end


function CreateRealEditBox(args)
    local codeBlock = [[
************ EDIT BOX DECIMAL NUMBER ************
EDIT_BOX,%d,REAL
TEXT_LABEL,%d,%s
DEFAULT_REAL,%d,%f

]]
    local str = string.format(codeBlock, args.setPosition, args.setPosition, args.assignEditBoxLabel, args.setPosition, args.setDefaultDecimalNumber)
    table.insert(outputStrings, str)
    -- Bcc.ShowMessageBox("createRealEditBox output: " .. str)
end


function CreateStringEditBox(args)
    local codeBlock = [[
************ EDIT BOX TEXT ************
EDIT_BOX,%d,STRING
TEXT_LABEL,%d,%s
DEFAULT_STRING,%d,%s

]]
    local str = string.format(codeBlock, args.setPosition, args.setPosition, args.assignEditBoxLabel, args.setPosition, args.setDefaultStringText)
    table.insert(outputStrings, str)
    -- Bcc.ShowMessageBox("createStringEditBox output: " .. str)
end


function FinalizeAdvPostingPage(args)
    -- Concatenate all the strings in the outputStrings table
    local combinedString = getCombinedString()
    -- Bcc.ShowMessageBox("Final output: " .. combinedString)

    -- Write the output to a file
    writeToFile(combinedString, args.postProcessorName, args.extension, args.jobType)
end

function writeToFile(content, postProcessorName, extension, jobType)
    local fileName = postProcessorName
    local baseFilePath = Bcc.GetDataFolder() .. "\\Posts\\"
    jobType = string.lower(jobType)
    -- Bcc.ShowMessageBox("jobType: " .. jobType .. "\nbaseFilePath: " .. baseFilePath .. "\nfileName: " .. fileName .. "\nextension: " .. extension .. "\ncontent: " .. content .. "\n")

    -- Append the jobType to the base file path
    local jobTypePath
    if jobType == "mill" then
        jobTypePath = "Mill\\"
    elseif jobType == "lathe" then
        jobTypePath = "Lathe\\"
    elseif jobType == "millturn" then
        jobTypePath = "MillTurn\\"
    else
        Bcc.ShowMessageBox("Invalid jobType: " .. jobType)
        return
    end

    local filePath = baseFilePath .. jobTypePath .. fileName .. "." .. extension

    local file, err = io.open(filePath, "w")
    if file then
        file:write(content)
        file:close()
    else
        Bcc.ShowMessageBox("Failed to open file: " .. filePath .. "\nError: " .. err)
    end
end

function getCombinedString()
    return table.concat(outputStrings)
end


--[[
-- Call the create functions
CreateCheckBox({setPosition = 1, assignCheckBoxLabel = "Use Tool Changer", setDefaultToOnOff = 1})
CreateComboBox({setPosition = 1, assignComboBoxLabel = "ComboBox Label 1", setDefaultSelection = 1, assignChoiceLabels = {"Choice 1", "Choice 2", "Choice 3"}})
CreateComboBox({setPosition = 3, assignComboBoxLabel = "ComboBox Label 2", setDefaultSelection = 1, assignChoiceLabels = {"Choice 1", "Choice 2", "Choice 3"}})
CreateIntegerEditBox({setPosition = 1, assignEditBoxLabel = "Integer Edit Box", setDefaultIntegerNumber = 10})
CreateRealEditBox({setPosition = 2, assignEditBoxLabel = "Real Edit Box", setDefaultDecimalNumber = 1.23})
CreateStringEditBox({setPosition = 3, assignEditBoxLabel = "String Edit Box", setDefaultStringText = "Default Text"})
]]

-- Finalize the output
-- FinalizeAdvPostingPage({postProcessorName = "BC_Single_Line_TESTING_LUA_FUNCS", extension = "CustomSettings", jobType = "Lathe"})
