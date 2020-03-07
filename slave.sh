JACK_NO_AUDIO_RESERVATION=2 jackd -R -p16 -v -d alsa -dhw:0 -p 256 -n 3 -r 44100  -s &
sleep 3
jack_load netadapter
# local-input mode to network
jack_connect system:capture_1 netadapter:playback_1
jack_connect system:capture_2 netadapter:playback_2
# network to local-output
jack_connect netadapter:capture_1 system:playback_1
jack_connect netadapter:capture_2 system:playback_2
