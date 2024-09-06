#!/bin/bash
sudo apt-get -y update
sudo apt-get install -y python3-pip
git clone https://github.com/Purnima-02/php.git
cd Php/
pip3 install -r requirements.txt
screen -m -d python3 app.py
