#!/bin/sh

#!/bin/sh
# A simple bash script to screen capture
#
# Supply three arguments:
#  hex window id (via xwininfo)
#  number of captures
#  delay between captures (seconds)

let x=1

# loop until it has captured the number of captures requested
while [ "$x" -le "$2" ]
do
  import -window $1 "capture$x.miff"
  # uncomment the line below
  # if you want more time in between screen captures
  sleep $3
  let x+=1
done
