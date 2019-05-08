# talk.py
# once running, you can test with the shell commands:
# To start the robot:
# mosquitto_pub -h talkpi.local -t "talkpi/talk" -m "yes.mp3"

import paho.mqtt.client as mqtt
import pygame
import time

clientName = "talk"
serverAddress = "talkpi" # problems connecting? try <your server name>.local
mqttClient = mqtt.Client(clientName)
fileLocation = "/home/pi/sounds/"

# init pygame.mixer, which plays audio in our program.
# Test, Yoda should say Yes each time he's started up
# You should change this line so that it contains a file on
# your Raspberry Pi.
pygame.mixer.init()
pygame.mixer.music.load(fileLocation + "yes.mp3") # assumes you have a file with this name in a /home/pi/sounds directory
speakerVolume = "0.5" # initially sets speaker at 50%
pygame.mixer.music.set_volume(float(speakerVolume))
pygame.mixer.music.play()

def connectionStatus(client, userdata, flags, rc):
    print("subscribing")
    mqttClient.subscribe("talkpi/talk")
    print("subscribed")

def messageDecoder(client, userdata, msg):
    message = msg.payload.decode(encoding='UTF-8')
    # Feel free to remove the print, but confirmation in the terminal is nice.
    print("^^^ payload message = ", message)
    if message.startswith("vol-"):
        # Mac slider sends messages as a String "vol-#.#" where #.# is from 0.0 to 1.0.
        message = message.strip("vol-")
        speakerVolume = float(message)
        pygame.mixer.music.set_volume(speakerVolume)
    else:
        pygame.mixer.music.load(fileLocation + message)
        pygame.mixer.music.play()
        time.sleep(1.0) # wait 4 seconds between plays.

# Set up calling functions to mqttClient
mqttClient.on_connect = connectionStatus
mqttClient.on_message = messageDecoder

# Connect to the MQTT server & loop forever.
# CTRL-C will stop the program from running.
mqttClient.connect(serverAddress)
mqttClient.loop_forever()
