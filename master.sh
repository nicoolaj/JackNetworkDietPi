substr() {
	local length=${3}

	if [ -z "${length}" ]; then
		length=$((${#1} - ${2}))
	fi

	local str=${1:${2}:${length}}

	if [ "${#str}" -eq "${#1}" ]; then
		echo "${1}"
	else
		echo "${str}"
	fi
}

strpos() {
	local str=${1}
	local offset=${3}

	if [ -n "${offset}" ]; then
		str=$(substr "${str}" ${offset})
	else
		offset=0
	fi

	str=${str/${2}*/}

	if [ "${#str}" -eq "${#1}" ]; then
		return 0
	fi

	echo $((${#str} + ${offset}))
}

eval_looper() {
	echo "nb = $#"
	my_command='jack_lsp |grep -v "Jack: "'

	for args in "$@"; do
		echo "$args"
		my_command="${my_command} |grep \"${args}\""
	done

	my_command="${my_command} |wc -l"
	echo ${my_command}
	looper=$(eval ${my_command})
}

wait_for_moduleLoading() {
	looper=0
	while [ "$looper" -lt 2 ]; do
		eval_looper $1
		echo -n "waiting for jack to load netmanager $1. ("
		echo "$looper)"
		sleep 1
	done
}

connectStereo() {
	for interfaceNumber in 1 2; do
		jack_connect $1_${interfaceNumber} $2_${interfaceNumber}
	done
}

identify_vlc() {
	vlcNumber=$(jack_lsp | grep "vlc_in" | grep "_1")
	delimiterPos=$(eval strpos "${vlcNumber}" "_1")
	vlcNumber=$(eval substr "${vlcNumber}" 0 ${delimiterPos})
	echo ${vlcNumber}
}

mainConnectionRoutine() {
	#echo -e "#### il y a $# arguments. \nle premier est:$1"
	if [ $# -le 1 ]; then
		inputCable="system:capture"
		module="$1"
	else
		inputCable="$1"
		module="$2"
	fi
	wait_for_moduleLoading "${module}"
	connectStereo "${inputCable}" "${module}"
}

# Start Jack server
JACK_NO_AUDIO_RESERVATION=2 jackd -R -p16 -v -d alsa -p 256 -n 3 -r 44100 -s &
# Wait for Jack daemon to start
sleep 5
# load NetJack2 Master
jack_load netmanager
mainConnectionRoutine "AudioJackOut:to_slave"

if [ $(which vlc | wc -l) -eq 1 ]; then
	# start vlc as a Jack output
	vlc --quiet --loop --no-video -I http --http-password=vlc --sout '#transcode{acodec=mp4a,ab='128',channels=2,samplerate=44100}:http{dst=':1234',mux=ts}' access_jack:// &
	sleep 1
	# find vlc real PID
	mainConnectionRoutine $(eval identify_vlc)
	# connect network-input to local-output
	mainConnectionRoutine "system:playback" "AudioJackOut:from_slave"
fi
