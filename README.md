# Repository Overview

This repository contains a library of functions used with BobCAD-CAM Post Processors. 
The scripts are written in Lua and are organized based on the machine type. 

## Directory Structure

The repository is organized into the following directories:

- [General](Posts/General)
- [Lathe](Posts/Lathe)
- [Mill](Posts/Mill)
- [MillTurn](Posts/MillTurn)

## Key Files

- BC_Lua_Functions.lua: This file contains Lua functions for retrieving and displaying operation data from the CAM system. It includes the `ShowOperationData` function which retrieves the current operations ID value of the Operation in the CAM Tree, and the `ShowValueFromOperation` function which takes a searchKey as an argument and retrieves the current operations ID value in the CAM Tree.

- BC_CAM_Values_Lua_Functions.lua: This file is specific to the Lathe operations and contains Lua functions related to them.

- Starting_MILL_Folder.txt.txt: This file is specific to the Mill operations.

- Starting_MILLTURN_Folder.txt.txt: This file is specific to the MillTurn operations.

## Usage

To use these scripts, you would typically load them into your CAM system and run them to perform the operations they are designed for. Please refer to your CAM system's documentation for instructions on how to load and run Lua scripts.
