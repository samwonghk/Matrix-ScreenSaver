### Limitation
There is a known limitation in the latest macOS version that .saver Screen Savers are running by legacyScreenSaver.appex. This causes the screen savers not being unloaded.

To fix this issue, install the kill_legacy.sh in the crontab.
1. Open a Terminal
2. chmod 777 path/to/kill_legacy.sh
3. Run "crontab -e"
4. Add the line "00 * * * * path/to/kill_legacy.sh" and save the crontab
5. It should run the kill_legacy.sh every hour

* You may also need to enable Full Disk Access in System Preference -> Privacy & Security
