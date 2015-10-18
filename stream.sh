#!/bin/bash

# Run avconv to stream the webcam's video to the RTMP server.

avconv  -f video4linux2 \       # Webcam format goes in 
        -s 320x176 \            # Small is big enough
        -r "10" \               # Fixed framerate at 10fps, somehow this needs to be a string
        -b 256k \               # Fixed bitrate
        -i /dev/video0 \        # Webcam device
        -vcodec libx264 \       # h264.1 video encoder
        -preset ultrafast \     # Use the fastest encodeing preset
        -f flv \                # Flash video goes out
        -an \                   # No audio!
        rtmp://<RASPBERRY_IP>/live/<STREAM_NAME>
