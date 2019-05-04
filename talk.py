# talk.py
# once running, you can test with the shell commands:
# To start the robot:
# mosquitto_pub -h yodapi.local -t "yoda/talk" -m "yes.mp3"

import paho.mqtt.client as mqtt
import os
import time

clientName = "yoda"
serverAddress = "yoda.local"
mqttClient = mqtt.Client(clientName)

# Test, Yoda should say Yes each time he's started up
# You should change this line so that it contains a file on
# your Raspberry Pi.
os.system('mpg123 /home/pi/sounds/yes.mp3 &')

def connectionStatus(client, userdata, flags, rc):
    print("subscribing")
    mqttClient.subscribe("yoda/talk")
    print("subscribed")

def messageDecoder(client, userdata, msg):
    message = msg.payload.decode(encoding='UTF-8')
    print("^^^ payload message = \(message)")
    os.system('mpg123 /home/pi/sounds/' + message + ' &')
    time.sleep(4.0)

# Set up calling functions to mqttClient
mqttClient.on_connect = connectionStatus
mqttClient.on_message = messageDecoder

# Connect to the MQTT server & loop forever.
# CTRL-C will stop the program from running.
mqttClient.connect(serverAddress)
mqttClient.loop_forever()
