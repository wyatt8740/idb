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

`idb` is a script that wraps `ssh` and `scp` to emulate some of the most
often-used functionality encompassed by Android's `adb` (Android Debug Bridge).
It does this over a USB cable using the 'iproxy' program from
[libusbmuxd](https://github.com/libimobiledevice/libusbmuxd.git), which is
located in the 'tools/' subdirectory of its repository.

`iproxy` relays TCP connections over a USB cable, allowing for ssh-over-USB,
and with that `scp` for file transfers over USB. This is extremely useful both
for higher transfer speeds vs. wireless, and for phones with spotty wireless
capabilities following some form of damage.

It *should* work with most of the common Unix/Linux shells, since it targets
bourne shell and (to my knowledge) complies entirely with the POSIX standard.

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
