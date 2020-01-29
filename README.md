# idb - "iOS Debug Bridge"
An emulation of a handful of useful adb commands I use for Android devices,
adapted for jailbroken iOS devices connected via USB.

Now (as of early 2020) supports multiple iOS devices connected simultaneously!
Use `idb -u UDID [command]` to try it!

#### History

As an Android developer with an old jailbroken iPhone 4S I toy with
occasionally, I was getting annoyed with typing in `ssh`/`scp` commands
constantly to make my device do things, so I decided to write a script for
it.

## Usage:
````
idb [-u <UDID>] command [options]
    -u <UDID> can optionally be placed before most commands to make them operate
    on the device with the given UDID (check with "idb devices" or "idb list").

Detailed command usage:
idb push [target] [destination]
    Copies a targeted file on the computer to a destination on the iDevice.
idb pull [target] [destination]
    Copies a targeted file from the iDevice to a destination on the computer.
idb shell
    Starts a remote shell on the iDevice.
idb shell [command]
    Starts a remote shell on the iDevice, runs the given command, and exits.
idb forward [local] [remote]
    Forwards socket connections (currently only TCP ports are tested).
    Unlike ADB, [local] and [remote] here should be integer values. That is,
    'tcp:25565', the ADB syntax, would be just '25565' here.
idb install [target]
    Installs the indicated target IPA on the iDevice using `ipainstaller`.
    Will need modification to work with other CLI IPA installer programs
    (which need to be installed on the iDevice itself via Cydia or similar).
idb uninstall [appid]
    Try to remove the app with the given ID from the iDevice. May fail on
    system apps.
idb remove [appid]
    Synonym for `idb uninstall`.
idb list-packages [-a|-u|-s|-x] [appid]
    Lists packages installed on the iDevice. Has several optional flags:
      -a: List all packages on the iDevice.
      -u: List user packages on the iDevice (default).
      -s: List system packages on the iDevice.
      -x: List all packages on the iDevice in XML format.
    If 'appid' is specified, only that package's information is displayed.
    This is incompatible with -x (for now at least).
idb devices
    Lists the UDID's of all connected devices. Part of preliminary
    (incomplete but planned) support for multi-device capability.
idb list
    Synonym for `idb devices`.
idb kill-server
    Kills all instances of 'iproxy,' the TCP-over-usbmuxd forwarding program.
idb help
    Show this usage information.
idb -h
    Synonym for `idb help`.
idb --help
    Synonym for `idb help`.
````
### System Requirements:
#### On the computer:
  * `usbmuxd` ([https://github.com/libimobiledevice/usbmuxd.git](https://github.com/libimobiledevice/usbmuxd.git)) needs to be
running for this to work. Tested on Debian Linux, but probably works in
Mac OS (or Windows with MSYS/Cygwin), based on past experience. On those
platforms, installing iTunes from Apple will get you usbmuxd, but you'll
still need to get or compile the "iproxy" tool from the open-source clone,
libusbmuxd (see the next item in this list.)

  * `iproxy`, found in the 'tools' subdirectory of [https://github.com/libimobiledevice/libusbmuxd.git](https://github.com/libimobiledevice/libusbmuxd.git).
It is also obtainable in some linux distros - in Debian (and presumably
Ubuntu), it is in the package `libusbmuxd-tools`.

  * `ideviceinstaller` for some functionality. From [this repository](https://github.com/libimobiledevice/ideviceinstaller) of libimobiledevice.

Whatever the case, if you compile `iproxy`, put the binary in a directory in
your `$PATH` variable. I use `iproxy-quiet`, which is a custom version of it
that I made that doesn't print information except on certain errors (i.e. it
follows the Unix philosophy better). You will have to edit the script to use
regular `iproxy` (just change the variable `IPROXY_PROG` near the top of the
file).

  * Included in this repository is a patch which should allow you to build
your own `iproxy-quiet`, if you choose. Apply the patch with either
`git apply iproxy-quiet.patch` or `patch -p1 < iproxy-quiet.patch` from the
libusbmuxd source root.

  * For *incomplete* (currently inoperable) multi-device support,
libimobiledevice's "tools" are also required (specifically, "idevice_id").
These tools are in the 'tools' directory of
https://github.com/libimobiledevice/libimobiledevice.git . This can be skipped
if you don't want to help fix multi-device support or attempt to use it.

### On the iDevice:
  * The device has to be connected via USB and have sshd listening on the port
defined above as REMOTEPORT. Due to the sshd requirement, the device must be
jailbroken. In Cydia, sshd is installed through the package "OpenSSH" (called
"openssh", note the casing, if you install it via apt on the command-line).

  * Note also that you can get openssh either from Saurik's repository
(available by default on basically any jailbroken iDevice), or from other
sources like ios-webstack (see http://ios-webstack.tk ). ios-webstack has
a newer version of OpenSSH than Saurik's repository does as of January 2018.

  * This script can probably be easily adapted for wireless transfers by
commenting out the iproxy stuff and changing the IP address/LOCALPORT to
the device address and the port that it's sshd is listening on.

### Password-less Authentication
To avoid having to type a password every time, set up key authentication
between the computer and the iDevice. I DO NOT RECCOMEND disabling password
login once key authentication is established.

On the computer, run:
````
    ssh-keygen
    (leave default filenames for the keys)
    ssh-keygen -p
    (leave default filenames for the keys)
````

On the iDevice (probably over ssh), run:
````
    mkdir /var/mobile/.ssh
    echo authstr >> /var/mobile/.ssh/authorized_keys
````

(where authstr is the output of `cat ~/.ssh/id_rsa.pub` on the computer)

Alternatively if you want to log in as root, you'd change the "DEVICE_USER" field
above in this script and write to /var/root/.ssh/authorized_keys instead.

### Troubleshooting

Errors I've encountered:
  * `bind(): Permission denied` when forwarding
  
Make sure your selected local and remote ports are not already bound by other
applications.

  * `ssh_exchange_identification: read: Connection reset by peer`
  
Check that the variable REMOTEPORT is set to the port that the idevice is
listening for SSH connections on. Also make sure `usbmuxd` is running and has
permissions to access your device (might require a udev rule or similar.)

# Old readme
Kept for posterity while I work on the rewritten readme.

# iOS Debug Bridge (idb)

Currently, the documentation is all in a huge comment block at the start of the
shell script itself. This might change soon when I have more time.

You will want to edit the script yourself anyway, because you will have to set up
the port you have `sshd` listening on on your iDevice at the bare minimum.

#### History

As an Android developer with an old jailbroken iPhone 4S I toy with
occasionally, I was getting annoyed with typing in `ssh`/`scp` commands
constantly to make my device do things, so I decided to write a script for
it.

#### TL;DR description of functionality

`idb` is a POSIX bourne shell script that wraps `ssh` and `scp` to emulate
some of the most often-used functionality encompassed by Android's `adb`
(Android Debug Bridge). It does this over a USB cable using the `iproxy`
program from [libusbmuxd](https://github.com/libimobiledevice/libusbmuxd.git),
which is located in the 'tools/' subdirectory of its repository.

`iproxy` relays TCP connections over a USB cable, allowing for ssh-over-USB,
and with that `scp` for file transfers over USB. This is extremely useful both
for higher transfer speeds vs. wireless, and for phones with spotty wireless
capabilities following some form of damage or defective design.

It *should* work with most of the common Unix/Linux shells, since it targets
bourne shell and (to my knowledge) complies entirely with the POSIX standard.
Let me know if you find somewhere it doesn't.

#### Setting up/connecting to the device

You'll want to edit the script itself if you want it to work. I have attempted
to put variables related to nearly anything I anticipate a user might want to
tweak at the top of the script, to aid in searching through the code for places
they are used.

There are several variables defined inside the script (such as the user to
log in as, the port `sshd` is listening on on the iDevice, and what port is
desired to bind it to on the host machine).

`sshd` listens by default on port 22, but I run it on port 50022 on my iDevice,
so that at the bare minimum might need changing.

All the variables that I think are likely to need changing are near the top of
the file (right below the comment block which contains further documentation).

#### Authenticating with the device

By default, you will need to type your user's password on each command.

Optionally, however, to remove the requirement to enter a password with every push/pull/
shell command, one may use key authentication to log in. See the documentation
in the script itself for details.

If you need any more help with this functionality, I can try to help out if you
file a bug report, but here is a summary that I hope will help:

1. Find your desktop/laptop's SSH public key file (usually
`~/.ssh/id_rsa.pub`). If it does not exist, run `ssh-keygen` to create it.
2. Do an `idb push` or manual `scp` to copy the file over to your idevice.
   You will be prompted for a password, in either case. By default, on
   jailbroken devices, I believe this password is "alpine" - but I assume that
   this password is set arbitrarily by the jailbreaking software.
3. Confirm that ~/.ssh exists and is a directory on the idevice. Typically,
   this will be either `/var/mobile/.ssh` or `/var/root/.ssh`, depending on if
   your preferred user is the root account on the device or not.
3. On a shell on the idevice, run `cat /path/to/pubkey >> 
   ~/.ssh/authorized_keys` (where you are logged in with the account you want
   to run your `idb` commands as on the device).
