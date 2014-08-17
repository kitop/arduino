To upload firmata if `artoo upload` not working:

Install `ino` via homebrew:
```
brew install ino
```

Upload firmata: (change board/port if necessary)
```
ino upload -m atmega328 -p /dev/tty.usbserial-A600ezfM
```
