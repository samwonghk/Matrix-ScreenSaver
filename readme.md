# Matrix Digital Rain Screen Saver

This is a tiny version of Matrix Digital Rain screen saver.
You may clone the project and edit as you like.

Share it for FREE!

## To install
1. Download the latest version in the Release section and Unzip it
2. Double-click the Matrix-ScreenSaver.saver to install

### Screen
<img width="1440" alt="Matrix-ScreenSaver Screen" src="https://user-images.githubusercontent.com/4035368/117927120-5c18e380-b32c-11eb-8e84-75584aa29518.png">

### Video
https://user-images.githubusercontent.com/4035368/117944217-9b046480-b33f-11eb-9fe9-18ea45379921.mov

### Limitation
There is a known limitation in the latest macOS version that .saver Screen Savers are running by legacyScreenSaver.appex. This causes the screen savers not being unloaded.

To fix this issue, install the kill_legacy.sh in the crontab.
1. Open a Terminal
2. chmod 777 path/to/kill_legacy.sh
3. Run "crontab -e"
4. Add the line "00 * * * * path/to/kill_legacy.sh" and save the crontab
5. It should run the kill_legacy.sh every hour

* You may also need to enable Full Disk Access in System Preference -> Privacy & Security



[![Creative Commons Licence](https://i.creativecommons.org/l/by-nc/4.0/88x31.png)](http://creativecommons.org/licenses/by-nc/4.0/)  
This work is licensed under a [Creative Commons Attribution-NonCommercial 4.0 International License](http://creativecommons.org/licenses/by-nc/4.0/).
