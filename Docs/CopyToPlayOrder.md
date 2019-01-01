# CopyToPlayOrder.scpt

This script is for updating  playlists on a device. iTunes doesnt automatically update smart playlists when you add new songs into the library.
Assume you had a smat playlist named 2010 which is based on the ID3V2 tag year . Suppose you added few more songs later into the library which has year value 2010 . In order to get your playlist '2010' updated you have to right-click on the playlist and then choose 'copy to play order'.
You can manually do this as long as you have few smart playlists. But when you have many smart playlists and you added lots of songs into the library then it make snese to use a script.

How to use this script :

Execute following command on Mac terminal (shell)

$ osascript CopyToPlayOrder.scpt 
- ITunes window will be activated now 
- A window will be poped-up to choose the Library / Device
- Choose 'Standard playlist' or 'smart playlist' in next window
- Choose playlists to be updated in the next widnow (you can choose multiple if needed)
- On completion a dialog box shows 'Completed !'
- Any error, debugging information will be shown on terminal

Pre-requisites:
1. This script need access to system events to get status of music device. Please follow below steps to allow your script to get correct access
- Goto system preferences
- Click on Privacy tab
- Choose Accessibility on the left panel, now you see 'Allow the apps below to control your computer'
- Click on + button , type terminal on the finder window, choose 'Terminal.app' , click on Open button

1. /opt/local/bin/cliclick
## It is important to leave ITunes window and Mac untouched while this script runs. 
