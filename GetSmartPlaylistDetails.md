# GetSongDetails.scpt

A script for fetching the rules used for creating all smart playlists  in the Library chosen. Script is capacble of iterating through folders and get complete path of the smart playlist.

Sample output will look like below.

- SMART::Malayalam Film Songs::Year wise::2006-2010:-:Year,is in the range,2006-2010
- SMART::Malayalam Film Songs::Year wise::2011:-:Year,is,2011
- SMART::Light Songs:-:Comments,is,Light Songs

The firs tline says that "Malayalam Film Songs" is a folder ,  "Year wise" is a subfloder , "2006-2010" is the name of smart playlist and "Year,is in the range,2006-2010" is the rule.



**_Title of song : Album name : Album artist (Lyricist): Composer : year : Aritists (Singers) : Comments_**



How to use this script :

Execute following command on Mac terminal (shell)

$ osascript GetSongDetails.scpt
- ITunes window will be activated now 
- Choose the Library / Device  
- Output will be available on the Terminal
