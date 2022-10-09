import pyaudio
import os
import sys
import socket
from threading import Thread






bu = 0
po = 31000
ip = "0.0.0.0"
ra = 44100
ch = 2
cu = 1024


import argparse

parser = argparse.ArgumentParser(description='A test program.')

parser.add_argument("-b", "--buffer", help="insert buffer", type=int)
parser.add_argument("-p", "--port", help="insert port", type=int)
parser.add_argument("-i", "--ip", help="insert ip", type=str)
parser.add_argument("-r", "--rate", help="insert rate", type=int)
parser.add_argument("-c", "--channel", help="insert channel", type=int)
parser.add_argument("-u", "--chunk", help="insert chunk", type=int)

args = parser.parse_args()

if (args.buffer):
    bu = args.buffer
if (args.port):
    po = args.port
if (args.ip):
    ip = args.ip
if (args.rate):
    ra = args.rate
if (args.channel):
    ch = args.channel
if (args.chunk):
    cu = args.chunk
print("buffer size =", bu,"|| port =", po, "|| ip address =", ip)

frames = []

count = 0
def set_globvar_to_one():
    global count    # Needed to modify global copy of globvar
    count += 1
def print_globvar():
        if count > 1000000: 
            os.execv(sys.argv[0], sys.argv)

def udpStream(CHUNK):

    udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    udp.bind((ip , po))

    while True:
        soundData, addr = udp.recvfrom(CHUNK*CHANNELS*2)
        frames.append(soundData)
    udp.close()

def play(stream, CHUNK):
    BUFFER = bu
    while True:
        if len(frames) == BUFFER:
            while True:
                try:
                    stream.write(frames.pop(0), CHUNK)
                except:
                    continue

if __name__ == "__main__":
    FORMAT = pyaudio.paInt16
    CHUNK = cu
    CHANNELS = ch 
    RATE = ra

    Audio = pyaudio.PyAudio()

    stream = Audio.open(format=FORMAT,
            channels = CHANNELS,
            rate = RATE,
            output = True,
            frames_per_buffer = CHUNK,
            )

    udpThread  = Thread(target = udpStream, args=(CHUNK,))
    AudioThread  = Thread(target = play, args=(stream, CHUNK,))
    udpThread .setDaemon(True)
    AudioThread.setDaemon(True)
    udpThread .start()
    AudioThread.start()
    udpThread .join()
    AudioThread.join()


