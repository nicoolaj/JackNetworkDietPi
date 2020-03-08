# JackNetworkDietPi

Audio transmitter over network using 2 RaspberryPi and Hifiberry DAC+ADC

## Long story mode

My TV, and gaming stations are too far from my Audio Receiver. I can't install multiples wires to connect them.

I bought an audio-video input selector with one output (Video + Left-Audio + Right-Audio)

I Use the TV to display the video. The sound is captured by a RaspberryPiHat [HifiBerry DAC+ ADC](https://www.hifiberry.com/shop/boards/hifiberry-dac-adc/). The RaspberryPi is connected to the network via an ethernet cable.

I have a second RaspberryPi connected to my audio-receiver. (For a better quality, Choose to use a [HifiBerry DAC+ ADC](https://www.hifiberry.com/shop/boards/hifiberry-dac-adc/) to render the audio and be able to aquire other audio sources in the future such as my turntable. This RaspberryPi is also connected to the network using a ethernet cable.

Both RaspberryPi are using [Jack-Deamon](https://jackaudio.org/) to capture/play the sound.

## Topology

To connect both Jack server I choose [NetJack2](https://github.com/jackaudio/jackaudio.github.com/wiki/WalkThrough_User_NetJack2). The server is on the audioRecever side. On the TV side is a client.
