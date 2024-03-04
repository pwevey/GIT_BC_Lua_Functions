local function createCheckBox(args)
    local codeBlock = [[
        
************ CHECK BOXES ************
CHECK_BOX,%s,%s
DEFAULT_CHECK,%s,%s
]]
    return string.format(codeBlock, args.setPosition, args.assignCheckBoxLabel, args.setPosition, args.setDefaultToOnOff)
end


local function createComboBox(args)
    local choices = table.concat(args.assignChoiceLabels, ",")
    local codeBlock = [[
        
************ COMBO BOXES ************
COMBO_BOX,%s,%s
TEXT_LABEL,%s,%s
DEFAULT_COMBO_INDEX,%s,%s
]]
    return string.format(codeBlock, args.setPosition, choices, args.setPosition, args.assignComboBoxLabel, args.setPosition, args.setDefaultSelection)
end


local function createIntegerEditBox(args)
    local codeBlock = [[

************ EDIT BOXES ************
EDIT_BOX,%d,INTEGER
TEXT_LABEL,%d,%s
DEFAULT_INTEGER,%d,%d
]]
    return string.format(codeBlock, args.setPosition, args.setPosition, args.assignEditBoxLabel, args.setPosition, args.setDefaultIntegerNumber)
end


local function createRealEditBox(args)
    local codeBlock = [[

************ EDIT BOXES ************
EDIT_BOX,%d,REAL
TEXT_LABEL,%d,%s
DEFAULT_REAL,%d,%f
]]
    return string.format(codeBlock, args.setPosition, args.setPosition, args.assignEditBoxLabel, args.setPosition, args.setDefaultDecimalNumber)
end


local function createStringEditBox(args)
    local codeBlock = [[

************ EDIT BOXES ************
EDIT_BOX,%d,STRING
TEXT_LABEL,%d,%s
DEFAULT_STRING,%d,%s
]]
    return string.format(codeBlock, args.setPosition, args.setPosition, args.assignEditBoxLabel, args.setPosition, args.setDefaultStringText)
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



local checkBoxString = createCheckBox({setPosition = 1, assignCheckBoxLabel = "Use Tool Changer", setDefaultToOnOff = 1})
local comboBoxString1 = createComboBox({setPosition = 1, assignComboBoxLabel = "ComboBox Label 1", setDefaultSelection = 1, assignChoiceLabels = {"Choice 1", "Choice 2", "Choice 3"}})
local comboBoxString2 = createComboBox({setPosition = 3, assignComboBoxLabel = "ComboBox Label 2", setDefaultSelection = 1, assignChoiceLabels = {"Choice 1", "Choice 2", "Choice 3"}})
local integerEditBoxString = createIntegerEditBox({setPosition = 1, assignEditBoxLabel = "Integer Edit Box", setDefaultIntegerNumber = 10})
local realEditBoxString = createRealEditBox({setPosition = 2, assignEditBoxLabel = "Real Edit Box", setDefaultDecimalNumber = 1.23})
local stringEditBoxString = createStringEditBox({setPosition = 3, assignEditBoxLabel = "String Edit Box", setDefaultStringText = "Default Text"})

local combinedString = checkBoxString .. comboBoxString1 .. comboBoxString2 .. integerEditBoxString .. realEditBoxString .. stringEditBoxString
writeToFile(combinedString, "customsettings")