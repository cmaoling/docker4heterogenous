echo $DISPLAY
echo $MOZREPL_PORT
Xvfb  $DISPLAY &
firefox -repl &
x11vnc -display $DISPLAY -localhost
