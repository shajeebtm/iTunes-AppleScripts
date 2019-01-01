# iTunes-AppleScripts
AppleScripts for getting some difficult tasks automated via iTunes

These scripts are mainly useful 
- if you manage ipod/iphone/ipad music library directly, means not synced with your laptop music library
- if you have thousands of songs with ID3V2 tag information set
- if you care about Album Name, Track Name, Artist Name, Composer Name and Album Artist Name
- if you organize songs into Folders, Playlists , esepcially smart playlists
- if you would like to copy playlists across multiple devices
- if you often add/remove songs in your device library and you want playlist & smart playlist to be updated


*Thanks to many online documents and discussions on managing iTunes by AppleScripts 


Following scripts are available in this project

1. [GetSongDetails.scpt](Scripts/GetSongDetails.scpt) - _A simple script for getting ID3V2 tags of every song in the Library chosen._
2. [GetSmartPlaylistDetails.scpt](Scripts/GetSmartPlaylistDetails.scpt) - _Script for getting conditions of every smart playlists in the Library chosen._
3. [CreateNestedFolders.scpt](Scripts/CreateNestedFolders.scpt) - _A simple script for creating a root folder and subfolders inside iphone/ipad/ipod music app_
4. [CreateSmartPlaylist.scpt](Scripts/CreateSmartPlaylist.scpt) - _A script for creating multiple smart playlists based on the rules listed in an input file_
5. [CopyToPlayOrder.scpt](Scripts/CopyToPlayOrder.scpt) - _A script is for updating smart playlists in a device_


Pre-requisites : 
1. MacBook or MacBook-pro or MacBook-air as these scripts can be used only on MacOS.
1. Ipad or Iphone , Ipod etc where music is stored.
1. Some of the scripts here  need access to system events to get status of music device. Please follow below steps to allow your script to get correct access
   * Goto system preferences
   * Click on Privacy tab
   * Choose Accessibility on the left panel, now you see 'Allow the apps below to control your computer'
   * Click on + button , type terminal on the finder window, choose 'Terminal.app' , click on Open button
