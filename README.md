# WindowFetch

This is just a simple script and MacOS plist file for automatically
grabbing live image streams and setting them as the Desktop 
background image.

***Requires the ImageMagick command-line tools to be installed.***

## Nuts & Bolts
The windowfetch.sh script grabs full jpg images of two traffic cams 
and combines them into a single image for display onto an ultra-wide
monitor. 

[Note: The general public does not have access to the URLs featured in
this code. Use your own. The code is entirely demonstrative.]

The script is put under control of MacOS launchd using the plist
file org.dog.task.windowfetch.plist. 

```bash
cp org.dog.task.windowfetch.plist ~/Library/LaunchAgents/
```

The task defined in that file is called "org.dog.task.windowfetch". After
copying it to the LaunchAgents directory, it is invoked with

```bash
launchctl load -w ~/Library/LaunchAgents/org.dog.task.windowfetch.plist
```

where the "-w" flag will cause daemon to run it without waiting for a
system reboot.  

Verify that it loaded with

```bash
launchctl list
```

The task can always be temporarilty halted or restarted by

```bash
launchctl stop org.dog.task.windowfetch
```
or
```bash
launchctl start org.dog.task.windowfetch
```

The task can be permanently disabled from the command line with

```bash
launchctl unload -w ~/Library/LaunchAgents/org.dog.task.windowfetch.plist
rm ~/Library/LaunchAgents/org.dog.task.windowfetch.plist
```
