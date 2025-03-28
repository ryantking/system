# System Configuration

Repository for managing system configurations on desktops and servers.

## Setup

### Prerequisites

These steps assume that you have a host with a fresh Linux install on it, which will include a non-root user. An Ubuntu server migh have the `ubuntu` user while a workstation will have your chosen username.

To configure your host, you will need to sure that the OpenSSH server is installed and runing. This should be the default on servers, but not on workstations. You can then move onto bootstrapping the host if you don't mind passing in your password to Ansible on the first run. Ideally, you should install your SSH key on the host to avoid any sort of password.

One final change to make is allowing your non-root admin user the abiliy to use sudo witout a password by editing `/etc/sudoers` or preferably making a new file in `/etc/sudoers.d/` to avoid touching default configs. Add the following line and replace `admin` with your admin username of choice. You can leave this step out if you prefer passing in your password to Ansible each time you need a role with root permissions.

```sudo
%admin ALL=(ALL) NOPASSWD:ALL
```

Once this is all done, you should be able to SSH into your host and execute a sudo command without being prompted for a password (unless you want passwords):

```sh
ubuntu@controller:~$ ssh new-host
ubuntu@server:~$ suod ls /
```

### Bootstrap

To bootstrap your host, you can run the following command:

```bash
```
