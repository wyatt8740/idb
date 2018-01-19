# iOS Debug Bridge (idb)

Currently, the documentation is all in a huge comment block at the start of the
shell script itself. This might change soon when I have more time.

You will want to edit the script yourself anyway, because you will have to set up
the port you have `sshd` listening on on your iDevice at the bare minimum.

#### Brief TL;DR on what this is

`idb` is a script that wraps `ssh` and `scp` to emulate some of the most
often-used functionality encompassed by Android's `adb` (Android Debug Bridge).

It *should* work with most of the common Unix/Linux shells.

As an Android developer with an old jailbroken iPhone 4S I toy with
occasionally, I was getting annoyed with typing in `ssh`/`scp` commands
constantly to make my device do things, so I decided to write a script for
it.

You'll want to edit the script itself if you want it to work. `sshd` listens
by default on port 22, but I run it on port 50022 on my iDevice, so that at
the bare minimum will need changing.

All the variables that I think are likely to need changing are near the top of
the file (right below the comment block which contains further documentation).
