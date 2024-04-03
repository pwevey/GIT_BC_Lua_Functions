# Repository Overview

This repository contains a library of functions used with BobCAD-CAM Post Processors. 
The scripts are written in Lua and are organized based on the machine type. 

## Directory Structure

The repository is organized into the following directories:

- [Lua Functions](Posts/BC_Lua_Functions/)

Test Post Processors
- [Lathe](Posts/Lathe/)
- [Mill](Posts/Mill/)
- [MillTurn](Posts/MillTurn/)

## Key Files

- BC_Lua_Functions.lua: This file contains Lua functions for retrieving and displaying operation data from the CAM system. 
It is the main lua file used in all machine types to find and 
display data from the software such as data from any operation.
- BC_NC_Output_Lua_Functions.lua: This file contains functions that are used to manipulate the output of the NC file.
These functions are primarily used directly in a standard post block and called like: lua_func_formatNumber({num = "MILL_Get_SRot", prefix = "A"}).
However, there are also functions like round() that can be used in lua blocks 2701 - 2799 like: local threads_per_inch = "E" .. round(1 / pitch, 0) 

## Usage

To use these lua functions, do the following:

1. Navigate to the link below to Enable to IsEnableLuaPlugin DWord Reg Key:

    [Registry Key to Enable](https://bobcad.com/components/webhelp/BC_Lua/RegistryKeytoEnable.html)

2. Make a folder in one of the following directory to store the lua files

    C:\BobCAD-CAM Data\BobCAD-CAM V36\Posts

    eg. create a folder called, "BC_Lua_Functions" 

3. Place the Lua files from this Github repository in the newly created local folder

    eg. place in C:\BobCAD-CAM Data\BobCAD-CAM V36\Posts\BC_Lua_Functions

4. Add the following Post Question to your Post Processor and use the name of the folder you just created

    732\. Lua sub folder? "../BC_Lua_Functions" 

    Note: Make sure to add "../" since this is a relative file path and the folder was created back one in the file directory.

5. You can now use the lua functions through out the Post Processor. 

Two main ways:

1: Place the following function call in a Post Block:
    
No Parameters: 
```
lua_func_FuncionName
```
Parameters:
```lua
lua_func_FuncionName(argument1, argument2)
```

Parameters using a Table: (See formatNumber function in BC_NC_Output_Lua_Functions.lua)
```lua
lua_func_FuncionName({argument1 = value1, argument2 = value2, argument6 = value6})
```

2: Call the functions directly in a Lua Block
Lua Blocks: 2701 (lua_block_1) through 2799 (lua_block_2)


2701\. Lua Block 1.

```lua
-- This is an external lua function that come from the file BC_Lua_Functions.lua
-- in the posts folder here: C:\BobCAD-CAM Data\BobCAD-CAM V36\Posts\Lathe\BC_Lua_Functions 
ShowOperationData()

local pitch = GetValue("thread_pitch")
```



Navigate here for more info:
[Post Processing with Lua](https://bobcad.com/components/webhelp/BC_Lua/PostProcessing.html)

