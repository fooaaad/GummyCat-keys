import pyaudio
import socket
from threading import Thread
 
po = 32000
ip = "192.168.1.57"
ra = 44100
ch = 2
cu = 1024

import argparse

parser = argparse.ArgumentParser(description='A test program.')

parser.add_argument("-p", "--port", help="insert port", type=int)
parser.add_argument("-i", "--ip", help="insert ip", type=str)
parser.add_argument("-r", "--rate", help="insert rate", type=int)
parser.add_argument("-c", "--channel", help="insert channel", type=int)
parser.add_argument("-u", "--chunk", help="insert chunk", type=int)

args = parser.parse_args()

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
print("port =", po, "|| ip address =", ip)

frames = []

def udpStream():
    udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    print("Sending audio...")
    while True:
        if len(frames) > 0:
            udp.sendto(frames.pop(0), (ip, po)) #
    udp.close()

def record(stream, CHUNK):
    while True:
        frames.append(stream.read(CHUNK))

if __name__ == "__main__":
    CHUNK = cu
    FORMAT = pyaudio.paInt16 #Audio Codec
    CHANNELS = ch #Stereo or Mono
    RATE = ra #Sampling Rate

    Audio = pyaudio.PyAudio()

    stream = Audio.open(format = FORMAT,
                    channels = CHANNELS,
                    rate = RATE,
                    input = True,
                    frames_per_buffer = CHUNK,
                    )

#Initialize Threads
    AudioThread = Thread(target = record, args = (stream, CHUNK,))
    udpThread = Thread(target = udpStream)
    AudioThread.setDaemon(True)
    udpThread.setDaemon(True)
    AudioThread.start()
    udpThread.start()
    AudioThread.join()
    udpThread.join()
