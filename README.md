# iOS Debug Bridge (idb)

Currently, the documentation is all in a huge comment block at the start of the
shell script itself. This might change soon when I have more time.

You will want to edit the script yourself anyway, because you will have to set up
the port you have `sshd` listening on on your iDevice at the bare minimum.

#### Brief TL;DR on what this is

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

There are several variables defined inside the script (such as the user to
log in as, the port `sshd` is listening on on the iDevice, and what port is
desired to bind it to on the host machine).

Optionally, to remove the requirement to enter a password with every push/pull/
shell command, one may use key authentication to log in. See the documentation
in the script itself for details.

#### History

As an Android developer with an old jailbroken iPhone 4S I toy with
occasionally, I was getting annoyed with typing in `ssh`/`scp` commands
constantly to make my device do things, so I decided to write a script for
it.

You'll want to edit the script itself if you want it to work. `sshd` listens
by default on port 22, but I run it on port 50022 on my iDevice, so that at
the bare minimum will need changing.

All the variables that I think are likely to need changing are near the top of
the file (right below the comment block which contains further documentation).
