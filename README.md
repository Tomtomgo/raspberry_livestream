# Raspberry Pi livestreaming
---
## Streaming live video from a webcam to the web over RTMP using a Raspberry Pi and Nginx

Imagine you're in a shared office with a foosball table and many people in the office like to play foosball. Then sometimes when you want to play you'll make a trip down the stairs just to find out its in use and you'll have to go up the stairs again. That's pretty sad, useless and a waste of time. 

The fix is obvious: get a Raspberry Pi, a webcam and stream the foosball table so you'll always know if it's free!

Because we ran into quite a few difficulties we decided to write a little how-to. Sharing is caring ;)

If you find anything is missing, create an issue here!

## Hardware

This is the hardware we used. You will probably have some other stuff... which should work as well.

- RaspberryPi B+ with Raspbian installed
- 8 GB SD card
- Logitech C310 webcam
- 2A power adapter

## Installing the necessary software

Everything here should be done on the Raspberry Pi (as opposed to on your computes). 

### Basics

```bash
sudo apt-get install ffmpeg
sudo apt-get install supervisor
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

### Edit `stream.sh` for your environment

Replace **<STREAM_NAME>** and **<RASPBERRY_IP>** with suitable values for you. 

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
cp /tmp/nginx-rtmp-module-master/stat.xsl 
```

### Run the systems!

This will (re)start Nginx and the stream itself.

```bash
sudo service supervisor stop
sudo service supervisor start
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

That should do it!

## Credits

Built at [Rockstart](http://rockstart.com) by [Sjoerd Huisman](https://github.com/shuisman) from [Congressus](https://www.congressus.nl/) and [Tom Aizenberg](https://github.com/Tomtomgo) from [Achieved](http://achieved.co).
