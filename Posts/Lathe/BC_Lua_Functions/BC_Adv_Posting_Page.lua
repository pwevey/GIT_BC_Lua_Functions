local outputStrings = {}

local function createCheckBox(args)
    local codeBlock = [[
************ CHECK BOX ************
CHECK_BOX,%s,%s
DEFAULT_CHECK,%s,%s

]]
    local str = string.format(codeBlock, args.setPosition, args.assignCheckBoxLabel, args.setPosition, args.setDefaultToOnOff)
    table.insert(outputStrings, str)
end


local function createComboBox(args)
    local choices = table.concat(args.assignChoiceLabels, ",")
    local codeBlock = [[
************ COMBO BOX ************
COMBO_BOX,%s,%s
TEXT_LABEL,%s,%s
DEFAULT_COMBO_INDEX,%s,%s

]]
    local str = string.format(codeBlock, args.setPosition, choices, args.setPosition, args.assignComboBoxLabel, args.setPosition, args.setDefaultSelection)
    table.insert(outputStrings, str)
end


local function createIntegerEditBox(args)
    local codeBlock = [[
************ EDIT BOX WHOLE NUMBER ************
EDIT_BOX,%d,INTEGER
TEXT_LABEL,%d,%s
DEFAULT_INTEGER,%d,%d

]]
    local str = string.format(codeBlock, args.setPosition, args.setPosition, args.assignEditBoxLabel, args.setPosition, args.setDefaultIntegerNumber)
    table.insert(outputStrings, str)
end


local function createRealEditBox(args)
    local codeBlock = [[
************ EDIT BOX DECIMAL NUMBER ************
EDIT_BOX,%d,REAL
TEXT_LABEL,%d,%s
DEFAULT_REAL,%d,%f

]]
    local str = string.format(codeBlock, args.setPosition, args.setPosition, args.assignEditBoxLabel, args.setPosition, args.setDefaultDecimalNumber)
    table.insert(outputStrings, str)
end


local function createStringEditBox(args)
    local codeBlock = [[
************ EDIT BOX TEXT ************
EDIT_BOX,%d,STRING
TEXT_LABEL,%d,%s
DEFAULT_STRING,%d,%s

]]
    local str = string.format(codeBlock, args.setPosition, args.setPosition, args.assignEditBoxLabel, args.setPosition, args.setDefaultStringText)
    table.insert(outputStrings, str)
end


local function writeToFile(content, extension)
    local fileName = arg[0]:match("(.+)%..+$")
    local file = io.open(fileName .. "." .. extension, "w")
    if file then
        file:write(content)
        file:close()
    else
        print("Failed to open file")
    end
end



-- Call the create functions
createCheckBox({setPosition = 1, assignCheckBoxLabel = "Use Tool Changer", setDefaultToOnOff = 1})
createComboBox({setPosition = 1, assignComboBoxLabel = "ComboBox Label 1", setDefaultSelection = 1, assignChoiceLabels = {"Choice 1", "Choice 2", "Choice 3"}})
createComboBox({setPosition = 3, assignComboBoxLabel = "ComboBox Label 2", setDefaultSelection = 1, assignChoiceLabels = {"Choice 1", "Choice 2", "Choice 3"}})
createIntegerEditBox({setPosition = 1, assignEditBoxLabel = "Integer Edit Box", setDefaultIntegerNumber = 10})
createRealEditBox({setPosition = 2, assignEditBoxLabel = "Real Edit Box", setDefaultDecimalNumber = 1.23})
createStringEditBox({setPosition = 3, assignEditBoxLabel = "String Edit Box", setDefaultStringText = "Default Text"})

-- Concatenate all the strings in the outputStrings table
local combinedString = table.concat(outputStrings)

-- Write the output to a file
writeToFile(combinedString, "customsettings")