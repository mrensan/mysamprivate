# MySam-Private

This is a tool for sharing private stuff in cloud. You can use it by defining
a fix shared path in your desired cloud (e.g. Dropbox) and a local path.

**MySam-Private** will take care of sharing your private stuff in cloud easily
by encrypting them by using [GPG](https://gnupg.org/).

I was personally using [CryFS](https://www.cryfs.org/) for some years. It uses
[macFUSE](https://osxfuse.github.io/) to mount a virtual drive for decrypted file.
It was very annoying recently though as was broking by every minor `macOS` upgrading,
so I ended up to write a simple script to handle the job easily. Hope you find it
useful.

## Install

Copy the script to your desired place of choice in your machine, you can also
consider adding it to your path. You should have `tar` and `gpg` installed on
your machine.

This script is tested successfully on `macOS Big Sur`. Testing on different 
flavour of `Linux` will be added.

## Configuration

1. Edit script and set your desired local and shared path in it:

```sh
LOCAL_PATH=$HOME/Documents/SAM_LOCAL
SHARED_PATH=$HOME/Dropbox\ \(Personal\)/SAM_SHARED
```

2. Also you can change the file name:

```sh
MEDIA=private
```

## Usage

- `persist`: After adding all of your information including files and directories
to the local path, run this command to encrypt and move everything to your shared 
path in cloud. The old version of encrypted information on shared path will be 
**OVERWRITTEN**.

```sh
mysam.sh persist
```

- `open`: To move information from cloud (shared path) to your local path run
this command. All of your information will be decrypt and available on your
local path. Any old information on your local path will be **DELETED** before this
operation started.

```sh
mysam.sh open
```

- `close`: To clean local machine safely, run this command. This command will
***DELETE** all information in your local path without updating them in the shared
path. It's useful to be run after read-only usage of information and before
leaving the machine alone. Particularly in shared machines like the company laptop!

```sh
mysam.sh close
```
