local outputStrings = {}


--[[
    Function: CreateCheckBox
    Description: Creates a Check Box on the Adv Posting Page set to a default value..
    Revision History:
        Version: 1.0 (2024-03-21) Author: Paul Wever
    Args: A table with the following keys
        setPosition: An integer number that sets the location of the check box on the Adv Posting page. 
        Starting at Position 1 through 9
        assignCheckBoxLabel: A string of the name given to the check box to distinguish what the check box is used for.
        setDefaultToOnOff: An integer number that sets the default value of the check box. (0 = Off, 1 = On)
    Returns:
        A string containing the code block for the check box.
]]
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


--[[
    Function: CreateComboBox
    Description: Creates a Combo Box on the Adv Posting Page set to a default value.
    Revision History:
        Version: 1.0 (2024-03-21) Author: Paul Wever
    Args: A table with the following keys:
        setPosition: An integer number that sets the location of the check box on the Adv Posting page. 
        Starting at Position 1 through 25. Positions 21 – 25 are wider.
        assignComboBoxLabel: A string of the name given to the combo box to distinguish what the combo box is used for.
        setDefaultSelection: An integer number that sets the default choice of the combo box. Starting at an index of 0 
        through the number of choice labels setup. (eg. Choice 1 = 0, Choice 3 = 2)
        assignChoiceLabels: a table of choices for selection in the combo box. 
        eg. assignChoiceLabels = {"Choice 1", "Choice 2", "Choice 3"}
    Returns:
        A string containing the code block for the combo box.
]]
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


--[[
    Function: CreateIntegerEditBox
    Description: Creates a Whole Number Edit Box on the Adv Posting Page set to a default value.
    Revision History:
        Version: 1.0 (2024-03-21) Author: Paul Wever
    Args: A table with the following keys
        setPosition: An integer number that sets the location of the check box on the Adv Posting page. 
        Starting at Position 1 through 25. Positions 21 – 25 are wider.
        assignEditBoxLabel: A string of the name given to the integer edit box to distinguish what the edit box is used for.
        setDefaultIntegerNumber: An integer number that sets the default edit box value.
    Returns:
        A string containing the code block for the integer edit box.
]]
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


--[[
    Function: CreateRealEditBox
    Description: Creates a Real Edit Box on the Adv Posting Page set to a default value.
    Revision History:
        Version: 1.0 (2024-03-21) Author: Paul Wever
    Args: A table with the following keys
        setPosition: An integer number that sets the location of the check box on the Adv Posting page. 
        Starting at Position 1 through 25. Positions 21 – 25 are wider.
        assignEditBoxLabel: A string of the name given to the real edit box to distinguish what the edit box is used for.
        setDefaultDecimalNumber: A decimal number that sets the default edit box value.
    Returns:
        A string containing the code block for the real edit box.
]]
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


--[[
    Function: CreateStringEditBox
    Description: Creates a Real Edit Box on the Adv Posting Page set to a default value.
    Revision History:
        Version: 1.0 (2024-03-21) Author: Paul Wever
    Args: A table with the following keys
        setPosition: An integer number that sets the location of the check box on the Adv Posting page. 
        Starting at Position 1 through 25. Positions 21 – 25 are wider.
        assignEditBoxLabel: A string of the name given to the string edit box to distinguish what the edit box is used for.
        setDefaultDecimalNumber: A string that sets the default edit box value.
    Returns:
        A string containing the code block for the string edit box.
]]
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


--[[
    Function: FinalizeAdvPostingPage
    Description: Takes the string text of the Create functions defined and creates an Advanced Posting Custom File in the 
    specified C:\BobCAD-CAM Data\BobCAD-CAM V36\Posts folder.
    IMPORTANT: This function is required for all post processors that utilize the Adv Posting Lua Functions. Place it at 
    the bottom of all the Create Adv Posting lua functions.
    Revision History:
        Version: 1.0 (2024-03-21) Author: Paul Wever
    Args: A table with the following keys
        postProcessorName: A string of the exact name of the post processor minus the extension.
        extension: A string of the extension for the Advanced Posting Custom file.
        jobType: A string of the post processor’s job type. Use: “mill”, “lathe”, or “millturn”
    Returns:
        An Advanced Posting Custom File placed in the BobCAD-CAM Data folder. View the “Adv Posting” page in the software 
        once you “Post” out the current job at least once.
]]
function FinalizeAdvPostingPage(args)
    local function getCombinedString()
        return table.concat(outputStrings)
    end

    -- Concatenate all the strings in the outputStrings table
    local combinedString = getCombinedString()
    -- Bcc.ShowMessageBox("Final output: " .. combinedString)

    local function writeToFile(content, postProcessorName, extension, jobType)
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

    -- Write the output to a file
    writeToFile(combinedString, args.postProcessorName, args.extension, args.jobType)
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
