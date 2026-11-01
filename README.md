# Cupcake Duels GUI

This repository contains a Roblox Lua GUI script for a fast custom menu with:

- draggable window
- combat toggles
- speed controls for normal, carry, lagger, and lagger carry
- theme selection (sky, galaxy, cyber, sakura, night, blood)
- mobile action buttons
- save/reset configuration
- size and scale controls

File included:
- `MainGUI.lua`

How to use:
1. Open Roblox Studio.
2. Create a LocalScript inside `StarterPlayer > StarterPlayerScripts`.
3. Copy the contents of `MainGUI.lua` into the LocalScript.
4. Press Play and the GUI will appear.
5. Use the `SAVE CONFIG` button to keep your settings for the current session.

Notes:
- The UI is built in pure Roblox Lua.
- Mobile buttons are on-screen buttons that trigger the main actions.
- Numeric inputs allow setting speed values such as `normalSpeed`, `carrySpeed`, `laggerSpeed`, and `laggerCarry`.
- The script is designed to be easy to customize and extend.
