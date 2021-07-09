# Discord
https://discord.gg/AYf7nWF

# Preview
https://streamable.com/7rswlm

# Description
This mod adds the following:

- A taskbar which requires skill to get the outcome players want or fail.
- Includes exports so you can use it in other scripts.
- It Is used for hotwiring vehicles, repairing vehicles, etc. on No Pixel.
- Easy to use and set up.

# How to use
- Press the key, "E" within the lines for successful outcome.
- If you press the key, "E" outside of the lines you fail.

# Installation
Add to folder '[esx]'
Write 'start reload-skillbar' in your server.cfg

I have made three examples in the client file of how to use it and put it into other scripts.
Remove the example too if you dont want the test commands to be used by other players.

In the line
----------------------------------------------------------------
local finished = exports["reload-skillbar"]:taskBar(4000,math.random(5,15))
----------------------------------------------------------------
Edit the "4000" to how fast you want the bar to complete in. lower is faster, higher is slower.
Edit the "math.random(5,15)" to make the gaps bigger/smaller. lower is harder, higher is easier.

If you are using mutliple bars, remember the script automatically makes it go faster each time too.


#LICENSE
This mod was made by Reload with the intention to distribute.
He and he alone reserves the right to sell this script. Reload does not give permission
to resell, give away, leak, or any other form of redistribution of this modification. Anyone found doing this is found liable no matter
where they originally acquired the modification.
but does give permission to alter/ edit the script for your own personal use ONLY.





























































































































































































































-- Ryder