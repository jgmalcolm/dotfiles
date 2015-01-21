#!/bin/sh

fps=15
width=512
height=512
obr=`expr $width \* $height \* 50 \* 25 / 256`
opt="vbitrate=$obr:mbd=2:keyint=132:vqblur=1.0:cmp=2:subcmp=2:dia=2:mv0:last_pred=3"
codec="msmpeg4v2"
rm -f divx2pass.log
mencoder -ovc lavc -lavcopts vcodec=$codec:$opt:vpass=1 -nosound mf://*.png -mf type=png:fps=$fps -o output.avi
# mencoder -ovc lavc -lavcopts vcodec=$codec:$opt:vpass=1 -nosound mf://*.png -mf type=png:fps=$fps -o /dev/null
# mencoder -ovc lavc -lavcopts vcodec=$codec:$opt:vpass=2 -nosound mf://*.png -mf type=png:fps=$fps -o output.avi
rm -f divx2pass.log
