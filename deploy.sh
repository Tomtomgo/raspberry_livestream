#! /bin/bash 

if [[ $1 != "" ]]
then
  echo "Deploying to $1"
else
  echo "You should set PI's IP address!"
  exit 1
fi

scp -r ./ pi@$1:/home/pi