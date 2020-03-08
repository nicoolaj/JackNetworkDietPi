# JackNetworkDietPi

Audio transmitter over network using 2 RaspberryPi and Hifiberry DAC+ADC

## Basic install

### Package installation and configuration

#### update available apt packages

```bash
apt-get update
```

#### Install Jackd and utils

```bash
echo "Answer YES for realtime"
apt-get -y install jackd2 jack-tools
```

#### Install VideoLanClient

```bash
apt-get -y install vlc vlc-plugin-jack
sed -i 's/geteuid/getppid/' /usr/bin/vlc
```

### Master and slave specificities

#### Master _(Only)_

```bash
cat master.sh >> /var/lib/dietpi/dietpi-autostart/custom.sh
```

#### Slave _(Only)_

```bash
cat slave.sh >> /var/lib/dietpi/dietpi-autostart/custom.sh
```

## Optional packages

```bash
apt-get install -y \
    vim exuberant-ctags \
    bash-completion \
    curl wget \
    xz-utils tar bzip2 \
    libnss-mdns avahi-daemon \
    snetz
```
