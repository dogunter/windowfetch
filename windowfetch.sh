#! /bin/bash
# windowfetch
#   Retrieves background images from a URL and sets them as the OS X
#   background. Useful for images that change regularly, e.g. for weather
#   update or traffic cam purposes.
#
#   This script runs on a single ultra-wide monitor but contains
#   commented code for dual monitor (or more).

# A bit about my file names. I work in a windowless office. When I want
# to know if the weather is conducive to a lunchtime bike ride, or just
# to check traffic, a grab to image feeds from cameras facing east and west

# Add necessary bits into PATH (namely, ImageMagick from MacPorts)
PATH=/opt/local/bin:$PATH

# Set the directory where local images and scripts will be kept
WINDOW_DIR=/Users/dog/windowfetch

# Applescript to set background image
function set_image () {
osascript <<AppleScript
tell application "System Events"
  set picture of desktop $1 to POSIX file "$2"
end tell
AppleScript
}

# Delete previous jpg files
/bin/rm -f $WINDOW_DIR/window-east*
/bin/rm -f $WINDOW_DIR/window-west*

# The AppleScript to set a background image will do nothing if the name of the file
# containing the image hasn't changed, so we affix a timestamp to the filename
#
# Timestamp for new file
sfx=`date +"%Y%m%d%H%M%S"`

# Fetch the new image(s)
curl --silent http://driveit.lanl.gov/img/east.jpg > $WINDOW_DIR/window-east-$sfx.jpg
curl --silent http://driveit.lanl.gov/img/west.jpg > $WINDOW_DIR/window-west-$sfx.jpg

# Fit images to size 1720x986 and add a black 8-pixel border
convert -bordercolor black -border 8 -resize 1720x986\! $WINDOW_DIR/window-east-$sfx.jpg $WINDOW_DIR/window-east-$sfx.jpg
convert -bordercolor black -border 8 -resize 1720x986\! $WINDOW_DIR/window-west-$sfx.jpg $WINDOW_DIR/window-west-$sfx.jpg

# Combine images to one single background image
montage -geometry 100% $WINDOW_DIR/window-west-$sfx.jpg $WINDOW_DIR/window-east-$sfx.jpg $WINDOW_DIR/window-west-east-$sfx.jpg
# Overlay the frame
composite -gravity center $WINDOW_DIR/window-west-east-$sfx.jpg $WINDOW_DIR/dark_grey_tech-3440x1440.jpg $WINDOW_DIR/window-west-east-$sfx.jpg

# Update to the latest images after checking for non-zero file size
# i.e. website or network wasn't down
# Do this for a single ultra-wide display
if [ -s $WINDOW_DIR/window-west-east-$sfx.jpg ]; then
   set_image 1 "$WINDOW_DIR/window-west-east-$sfx.jpg"
fi
# Do this for a dual display set-up
#if [ -s $WINDOW_DIR/window-east-$sfx.jpg ]; then
#   set_image 1 "$WINDOW_DIR/window-east-$sfx.jpg"
#fi
#  Desktop 2
#if [ -s $WINDOW_DIR/window-west-$sfx.jpg ]; then
#   set_image 2 "$WINDOW_DIR/window-west-$sfx.jpg"
#fi
