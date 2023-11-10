#!/bin/bash
sudo apt-get -y update
sudo apt-get install -y python3-pip
git clone https://github.com/GOUSERABBANI44/Penguin-.git
cd Penguin-/
pip3 install -r requirements.txt
screen -m -d python3 app.py
