# GetSmartPlaylistDetails.scpt

A script for fetching the rules used for creating all smart playlists  in the Library chosen. Script is capacble of iterating through folders and get complete path of the smart playlist.
Output format is

SMART::Subfolder Name::Smart Playlist Name:-:Smart Playlist Cnditions (separated by comma)

In case of multiple sub folders they all will be printed in same line one after other

Sample output will look like below.

1. SMART::Malayalam Film Songs::Year wise::2006-2010:-:Year,is in the range,2006-2010 <-- folder & subfolder
1. SMART::Malayalam Film Songs::Year wise::2011:-:Year,is,2011 <-- folder & sub folder
1. SMART::Hindi::hindi-Kumar Sanu Hits:-:Comments,is,Hindi-Kumar Sanu Hits <-- One folder
1. SMART::AMbu:-:Comments,contains,Ambu <-- No folder

The first line in the output says that 
- "Malayalam Film Songs" is a folder
   - "Year wise" is a subfloder
     - "2006-2010" is the name of smart playlist
        - "Year,is in the range,2006-2010" is the rule.
 
Third line int the output says that
 - "Hindi" is a folder
   - "hindi-Kumar Sanu Hits" is the name of the smart playlist
      - "Comments,is,Hindi-Kumar Sanu Hits". is the rule

Fourth line in the out put says that
- "AMbu" is the name of the smart playlist
   - "Comments,contains,Ambu" is the rule

How to use this script :

Execute following command on Mac terminal (shell)

$ osascript GetSmartPlaylistDetails.scpt
- ITunes window will be activated now 
- Choose the Library / Device
- You will see iTunes iterating through each smart playlists, opening and closing them to read rules.
- Please make sure that you leave iTunes windows untouched while the script runs.  You can swtich to terminal once you see the window ""I am done !. Look at the terminal for Playlist details"
- Output of the script will be available on the Terminal
