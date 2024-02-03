# Learn OS

A repo for learning the basics of OS development.

## Development environment

This project is building a hobby OS for AMD64. Here are instructions to get a development environment working on an ARM64 macOS machine (I am using an M1 Mac with macOS v14).

### 1. Install UTM

UTM allows you to run virtual machines (VMs) with different architectures on your Mac. You can buy it from the app store or download it for free from GitHub: [UTM v4.4.5](https://github.com/utmapp/UTM/releases/tag/v4.4.5)

### 2. Get a virtual machine preset

Download and unzip the [Debian 12 (Rosetta) preset](https://mac.getutm.app/gallery/debian-12-rosetta) from the [UTM gallery](https://mac.getutm.app/gallery/).

### 3. Create a virtual machine

1. In UTM choose `Create a New Virtual Machine` > `Open...` and select your preset.
1. Right click on the machine and choose `Edit` to change the VM settings.
1. In the `Network Mode` section select `Bridged (Advanced)` for internet access.
1. In the `Sharing` section choose `Add` and navigate to `./mount` for a shared directory between the host machine (your Mac) and the guest machine (the Debian VM).
1. Also in the `Sharing` check the `Add read only` checkbox, choose `Add` and navigate to `./` for readonly access to this repo from inside the VM.
1. Increase the VM’s RAM and disk space if required.

### 4. Set up the virtual machine

1. Start the VM and log in as user `debian` with password `debian`.
1. Open a terminal in the VM.
1. Run the installation script: `/media/share/learn-os/install.sh`.
1. Make a writable local clone of the repo: `git clone file:///media/share/learn-os`.

#### Optional settings

Through the VM GUI I also like to change some other things:

1. `Settings` > `Screen` > Turn off screen lock and set blank screen delay to `Never`.
1. Dark mode for OS.
1. Pin Terminal application to dock for easy access via `Cmd + 1`.
1. Dark mode for Terminal.

### 5. SSH into the VM

It will probably be more convenient in general to interact with the VM via SSH from a terminal running on your host machine. The installation script prepared this for you. Find the local IP address of the VM from the installation script output, then do the following on your host machine:

1. Install your host’s SSH public key on the VM: `ssh-copy-id debian@ip` (where `ip` is the VM’s local IP).
1. Add this to your host’s `~/.ssh/config` file (where `ip` is the VM’s local IP):

   ```ssh
   Host learn-os
   HostName ip
   User debian
   ```

1. SSH into the VM: `ssh learn-os`.

## Tooling

### Assembler

NASM:

### Cross-compiler

GCC:

### Linker

ld:

### Virtual machine

Bochs:

### Debugger

GDB:

### Build automation

Make:

### Utilities

- dd:
