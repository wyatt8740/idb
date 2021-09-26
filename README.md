# idb - "iOS Debug Bridge"
An emulation of a handful of useful adb commands I use for Android devices,
adapted for jailbroken iOS devices connected via USB.

It currently has been tested on iDevices ranging from iOS 4 to iOS 10, but it
should work on 2.x up through whatever the most recent that can run an SSH
daemon is.

Now (as of early 2020) supports multiple iOS devices connected simultaneously!
Use `idb -u UDID [command]` to try it!

#### History

As an Android developer with an old jailbroken iPhone 4S (and others) that I
toy with occasionally, I was getting annoyed with typing in `ssh`/`scp`
commands constantly to make my device do things, so I decided to write a
script for it.

By the way, I had absolutely no idea Facebook had an identically named project.

I wholly expect theirs is far more capable, at least on Mac OS machines, but I
like mine and I will continue using it.

Due to being a POSIX shell script, my version is quite flexible, and (I hope)
rather easy to pick up and hack on. I have commented the script heavily, in
the hopes that it should even be approachable for someone with next to no shell
scripting experience for tweaking.

## Usage:

Note that this is currently slightly out of date; there are more options
available than are documented. For the moment, you can search the shell script
for it. I hope to have time to clean this document up in the future and add the
functions to the help text, but some of them need a little polishing before
I'll feel like they're airworthy.

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

  * Because of the new multi-device support, libimobiledevice's "tools" are
  also required (specifically, "idevice_id"). These tools are in the 'tools'
  directory of https://github.com/libimobiledevice/libimobiledevice.git .

  * `iproxy`, found in the 'tools' subdirectory of [https://github.com/libimobiledevice/libusbmuxd.git](https://github.com/libimobiledevice/libusbmuxd.git).
  It is also obtainable in some linux distros - in Debian (and presumably
  Ubuntu), it is in the package `libusbmuxd-tools`.

Whatever the case, if you compile `iproxy`, put the binary in a directory in
your `$PATH` variable. I use `iproxy-quiet`, which is a custom version of it
that I made that doesn't print information except on certain errors (i.e. it
follows the Unix philosophy better). **You will have to edit the script to use
`iproxy-quiet`** (just change the variable `IPROXY_PROG` near the top of the
file). You will also have to apply the patch to the libusbmuxd repository and
build your own version of the tool if you take this route; I'd suggest you just
use the one that they provide you and accept the extra prints. I only provide
the patch because I personally use it.

  * `ideviceinstaller` for some functionality. From [this repository](https://github.com/libimobiledevice/ideviceinstaller) of libimobiledevice.

  * Included in this repository is a patch which should allow you to build
your own `iproxy-quiet`, if you choose. Apply the patch with either
`git apply iproxy-quiet.patch` or `patch -p1 < iproxy-quiet.patch` from the
libusbmuxd source root.

  * There's also a soft (optional) dependency on 'escapify,' a tiny C program
I wrote which I have included in this repository.  It's something I might be
able to replace with native shell stuff some day, but for me it was easier to
write in C. Basically, it just makes escaping strings with things like spaces
more intuitive and consistent by formatting them so programs like `scp` will
accept them. If you don't use it, you may have to add some backslashes to your
strings with spaces in them for things like `push` and `pull` to work as
intended. Compile it with the makefile, or run a command similar to
`cc -o escapify escapify.c`, and then put the binary in a directory that's in
your PATH variable. If available, the script will automatically utilize it.

### On the iDevice:
  * The device has to be connected via USB and have sshd listening on the port
defined in the script as REMOTEPORT. Due to the sshd requirement, the device
must be jailbroken. In Cydia, sshd is installed through the package "OpenSSH"
(called "openssh", note the casing, if you install it via apt on the
command-line). Newer iOS versions may need to install Dropbear as their SSH
daemon instead; I have not done so on my newer iDevices yet (newest is a 5S).
A couple of commands may work without SSH, such as `install`.

  * Note also that you can get openssh either from Saurik's repository
(available by default on basically any jailbroken iDevice), or from other
sources like ios-webstack ~~(see http://ios-webstack.tk )~~ (repo is dead; try
https://cydia.akemi.ai/webstack/ instead). ios-webstack has a newer version of
OpenSSH than Saurik's repository does as of January 2018.

  * This script can probably be easily adapted for wireless transfers by
commenting out the iproxy stuff and changing the IP address/LOCALPORT to
the device address and the port that it's sshd is listening on.

### Password-less Authentication
To avoid having to type a password every time, set up key authentication
between the computer and the iDevice. I DO NOT RECOMMEND disabling password
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
applications. If you have multiple devices, try setting up their LOCALPORT
values separately in the new `idb.conf` file. See the example idb.conf file for
an example of how it works. Put it in `~/.config/idb.conf`.

  * `ssh_exchange_identification: read: Connection reset by peer`
  
Check that the variable REMOTEPORT is set to the port that the idevice is
listening for SSH connections on it. Also make sure `usbmuxd` is running and
has permissions to access your device (might require a udev rule or similar.)

### Notes/Miscellania

This script currently has several features that aren't advertised above in this
readme, with the justification that they are sort of hard to use, or hacks
that work well enough for me but which are sort of silly to expect others to
pick up easily. I'll briefly list a few of them here.

If you want to learn more about one of these features, read the shell script -
and, if you have questions, contact me. You can either file an issue or send
an email; both are fine. I'll probably respond more quickly to an issue than
a plain email, though.

* `idb.conf`: a file containing a colon-separated list of values. You can use
this if you have multiple iDevices attached at once, to differentiate them when
using SSH with `iproxy`. Each device must use iproxy listening on a separate
port on the host, so this file lets you assign device UUID's to addresses.

  * This could also be used to allow wireless device access - at least for SSH
  based functionality. The example idb.conf file in this repository tries to
  illustrate the syntax. But it's quite hacky.

* Screenshots: this functionality requires mounting a developer disk image on
the iDevice in question. Since different iOS versions have different
developer disk images, there's no easy way I could think of to make a generic
function for it in the script. So you can provide a path to an appropriate
developer disk image in `idb.conf` for your given UUID.

* debug: wrapper for `idevicedebug`
I just haven't gotten around to documenting this properly yet. Check the
comments in the script for more.

I'd like to implement iFUSE-based file transfers, too - that way, idb could be
used to push files into application directories just like iTunes can. This is
currently not implemented.
