# Streaming live video from a webcam over RTMP using a Raspberry Pi and Nginx


![Live stream for foosball in action, much inception!](/livestream-working.jpg?raw=true "Live stream for foosball in action, much inception!")

**Live stream for foosball in action, much inception!**

- - - 

Imagine you're in a shared office with a foosball table and many people in the office like to play foosball. Then sometimes when you want to play you'll make a trip down the stairs just to find out it's in use and you'll have to go up the stairs again. That's pretty sad, useless and a waste of time. That time should be spent in awesome projects like these.

The fix is obvious: Hackaton! Get a Raspberry Pi, a webcam and stream the foosball table so you'll always know if it's free! There are also some additional bennefits, such as secretly analysing competitor tactics

Because we ran into quite a few difficulties we decided to write a little how-to. Sharing is caring ;)

If you find anything is missing, please create an issue [here](https://github.com/Tomtomgo/raspberry_livestream/issues)!

## Hardware

This is the hardware we used. You will probably have some other stuff... which should work as well.

- RaspberryPi B+ with Raspbian installed
- 8 GB SD card
- Logitech C310 webcam
- 2A power adapter
- All these things connected appropriately

## Installing the necessary software

Everything here should be done on the Raspberry Pi (as opposed to on your computes) unless stated otherwise. 

### Basics

Some basic dependencies:

```bash
sudo apt-get install ffmpeg supervisor
```

### Build Nginx with RTMP module

To stream our video to the web we use [Nginx](http://nginx.org/) with an [RTMP module](https://github.com/arut/nginx-rtmp-module). This module has to be compiled into Nginx, so let's do it:

```bash
cd /tmp
wget https://github.com/arut/nginx-rtmp-module/archive/master.zip
wget http://nginx.org/download/nginx-1.7.9.tar.gz
tar -zxvf nginx-1.7.9.tar.gz
unzip master.zip

cd nginx-1.7.9
./configure --add-module=/tmp/nginx-rtmp-module-master
make # <- This takes a few minutes on a Raspberry Pi
sudo make install
```

### Get the files!

You can fork the entire repo, or clone to your computer:

```bash
git clone https://github.com/Tomtomgo/raspberry_livestream.git
```

### Edit `stream.sh` for your environment

Replace \<STREAM_NAME\> and \<RASPBERRY_IP\> in `stream.sh` with suitable values for you. 

### Copy files to Raspberry Pi

From this folder on your machine:

```bash
scp -r ./ pi@<RASPBERRY_IP>:/home/pi
```

### Copy config files

```bash
cd ~
sudo cp nginx.conf /usr/local/nginx/conf/nginx.conf
cp stream.supervisor.conf /etc/supervisor/conf.d/stream.supervisor.conf 
```

### Run the systems!

This will (re)start Nginx and the stream itself.

```bash
sudo service supervisor stop
sudo service supervisor start
```

## Verify the stream

You can check that it's actually streaming by opening this URI in [VLC](http://www.videolan.org/vlc/index.html) on your computes:

```uri
rtmp://<RASPBERRY_IP/live/<STREAM_NAME> 
```

## Showing the stream on a web page

We used [HDW Player](http://www.hdwplayer.com) for showing the RTMP-stream, but there are probably many more.

Download it and put the `player` folder in a project folder somewhere.

Then to show the video you can do something like this (replace <THESE_THINGS>):

```html
<html>
  <head>
    <script src="<PROJECT_FOLDER>/player/hdwplayer.js"></script>
  </head>
  <body>
    <div id="player"></div>
    <script type="text/javascript">
      hdwplayer({ 
        id        : 'player',
        swf       : '<PROJECT_FOLDER>/player/player.swf',
        width     : '640',
        height    : '334',
        type      : 'rtmp',
        streamer  : 'rtmp://<RASPBERRY_IP/live',
        video     : '<STREAM_NAME>',
        autoStart : 'true',
        controlBar: 'false'
        });
    </script>
  </body>
</html>
```

That should do it! Go fot it!

## Adventures
As mentioned, we ran into a little bit of trouble before it worked. Hereby a short summary what we tried and why it did not work;

1. Stream to [bambuser.com](http://bambuser.com)

   We never got the stream connected  at Bamuser. The RMTP-addresses were unclear and did not accepted the connections.
  
2. Stream to [twitch.tv](http://twitch.tv)

   This did not worked as we got banned several times, because we were not streaming gaming content. Wierd! Foosball is the best sport ever.
   
3. Stream to [youtube.com](http://youtube.com)

   This attempt almost worked, we had a few cases were the stram was received. But in the end YouTube did not accepted the low bitrate coming from the RasberryPi.

## Credits

Built at [Rockstart](http://rockstart.com) by [Sjoerd Huisman](https://github.com/shuisman) from [Congressus](https://www.congressus.nl/) and [Tom Aizenberg](https://github.com/Tomtomgo) from [Achieved](http://achieved.co).
