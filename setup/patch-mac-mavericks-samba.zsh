#!/usr/bin/env zsh
# -o sync,noatime,

# maybe flags

# noatime     Do not update the file access time when reading from a file.
#             This option is useful on file systems where there are large
#             numbers of files and performance is more critical than updating
#             the file access time (which is rarely ever important).

# nobrowse    This option indicates that the mount point should not be visible
#             via the GUI (i.e., appear on the Desktop as a separate volume).

# nosuid      Do not allow set-user-identifier or set-group-identifier bits to
#             take effect.



# mount -t smbfs //uspayrolladmin:p@1.2.3.5/c /cygdrive/c



# ----------------------------------------------------------
# This is intended to fix a Git issue:
# Git pull hangs on SMB shared repository.
#    http://stackoverflow.com/questions/20973351/git-pull-hangs-on-smb-shared-repository
#
# Credits:
# Much props goes to Jeff Lion and his excellent writeup
# "SMB Windows Sharing Permissions Issue in OS X 10.9 by
#  installing Samba"
#  http://blog.rubbingalcoholic.com/post/39412902216/fix-smb-windows-sharing-permissions-issue-in-os-x-10-7
# ----------------------------------------------------------



# ----------------------------------------------------------
# 1. Start off by turning off File Sharing:
#
#   System Preferences > Sharing > File Sharing
#
# Untick the checkbox for File Sharing
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' '1. Start off by turning off File Sharing. Press enter to open System Preferences [Enter]: ';
read foo;
open /System/Library/PreferencePanes/SharingPref.prefPane;
printf '\033[0;32m%s\033[0m\n' 'Press enter to continue [Enter]: ';
read foo;


# ----------------------------------------------------------
# 2. Move the current service ports that OS X's Samba uses to
# a different port. This way, if file sharing accidently gets
# turned on in the Sharing Preferences, you won't have
# conflicting services trying to run on the same port.
#
# Edit /etc/services to do this:
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' '2. Move the current service ports that OS X Samba uses to a different port';
printf '\033[0;32m%s\033[0m\n' 'Modify the entries with the following port numbers 137, 138, 139 and 445 and prepend 19 to them';
printf '\033[0;32m%s\033[0m\n' '    netbios-ns      137/udp     # NETBIOS Name Service';
printf '\033[0;32m%s\033[0m\n' '    netbios-ns      137/tcp     # NETBIOS Name Service';
printf '\033[0;32m%s\033[0m\n' '    netbios-dgm     138/udp     # NETBIOS Datagram Service';
printf '\033[0;32m%s\033[0m\n' '    netbios-dgm     138/tcp     # NETBIOS Datagram Service';
printf '\033[0;32m%s\033[0m\n' '    netbios-ssn     139/udp     # NETBIOS Session Service';
printf '\033[0;32m%s\033[0m\n' '    netbios-ssn     139/tcp     # NETBIOS Session Service';
printf '\033[0;32m%s\033[0m\n' '    ...';
printf '\033[0;32m%s\033[0m\n' '    microsoft-ds    445/udp     # Microsoft-DS';
printf '\033[0;32m%s\033[0m\n' '    microsoft-ds    445/tcp     # Microsoft-DS';
printf '\033[0;32m%s\033[0m\n' '\nResults should look like the following:';
printf '\033[0;32m%s\033[0m\n' '    netbios-ns      19137/udp     # NETBIOS Name Service';
printf '\033[0;32m%s\033[0m\n' '    netbios-ns      19137/tcp     # NETBIOS Name Service';
printf '\033[0;32m%s\033[0m\n' '    netbios-dgm     19138/udp     # NETBIOS Datagram Service';
printf '\033[0;32m%s\033[0m\n' '    netbios-dgm     19138/tcp     # NETBIOS Datagram Service';
printf '\033[0;32m%s\033[0m\n' '    netbios-ssn     19139/udp     # NETBIOS Session Service';
printf '\033[0;32m%s\033[0m\n' '    netbios-ssn     19139/tcp     # NETBIOS Session Service';
printf '\033[0;32m%s\033[0m\n' '    ...';
printf '\033[0;32m%s\033[0m\n' '    microsoft-ds    19445/udp     # Microsoft-DS';
printf '\033[0;32m%s\033[0m\n' '    microsoft-ds    19445/tcp     # Microsoft-DS';
printf '\033[0;32m%s\033[0m\n' 'Press enter to edit /etc/services [Enter]: ';
sudo nano /etc/services;

# ----------------------------------------------------------
# Modify the entries with the following port numbers 137,
# 138, 139 and 445 and prepend 19 to them.
# ----------------------------------------------------------
# netbios-ns      137/udp     # NETBIOS Name Service
# netbios-ns      137/tcp     # NETBIOS Name Service
# netbios-dgm     138/udp     # NETBIOS Datagram Service
# netbios-dgm     138/tcp     # NETBIOS Datagram Service
# netbios-ssn     139/udp     # NETBIOS Session Service
# netbios-ssn     139/tcp     # NETBIOS Session Service
# ...
# microsoft-ds    445/udp     # Microsoft-DS
# microsoft-ds    445/tcp     # Microsoft-DS

# ----------------------------------------------------------
# Results should look like the following:
# ----------------------------------------------------------
# netbios-ns      19137/udp     # NETBIOS Name Service
# netbios-ns      19137/tcp     # NETBIOS Name Service
# netbios-dgm     19138/udp     # NETBIOS Datagram Service
# netbios-dgm     19138/tcp     # NETBIOS Datagram Service
# netbios-ssn     19139/udp     # NETBIOS Session Service
# netbios-ssn     19139/tcp     # NETBIOS Session Service
# ...
# microsoft-ds    19445/udp     # Microsoft-DS
# microsoft-ds    19445/tcp     # Microsoft-DS



# ----------------------------------------------------------
# 3. Uninstall Samba if it's already there and then install
# our version using Homebrew.
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' '3. Uninstall Samba if its already there and then install our version using Homebrew';
if [[ -n $(brew list | grep autogen) ]]; then
  brew uninstall autogen;
fi
if [[ -n $(brew list | grep samba) ]]; then
  brew uninstall samba;
  rm "$(brew --cache)/"samba*;
fi
brew doctor;
brew update;
brew install autogen;
brew install --env=std https://raw2.github.com/psyrendust/homebrew/mavericks-samba-fix/Library/Formula/samba.rb;
brew cleanup;



# ----------------------------------------------------------
# 4. Install system LaunchDaemons to launch the new version
# of Samba.
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' '4. Install system LaunchDaemons to launch the new version of Samba';
curl -s https://gist.github.com/psyrendust/8466620/raw/7f814423920ddc0f53da895d408c6e1ed922b023/org.samba.nmbd.plist | xargs -0 echo > "${HOME}/Downloads/org.samba.nmbd.plist";
curl -s https://gist.github.com/psyrendust/8466620/raw/a5d4aedf029c7a90181d67d431cf3bcea1c8bf2a/org.samba.smbd.plist | xargs -0 echo > "${HOME}/Downloads/org.samba.smbd.plist";

sudo mv "${HOME}/Downloads/org.samba.nmbd.plist" "/Library/LaunchDaemons/org.samba.nmbd.plist";
sudo mv "${HOME}/Downloads/org.samba.smbd.plist" "/Library/LaunchDaemons/org.samba.smbd.plist";



# ----------------------------------------------------------
# 5. Fix the owner and permissions so that OS X doesn't have
# any issues trying to launch these plist files.
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' '5. Fix the owner and permissions so that OS X doesnt have any issues trying to launch these plist files';
sudo chown root:wheel "/Library/LaunchDaemons/org.samba."*;
sudo chmod 744 "/Library/LaunchDaemons/org.samba."*;



# ----------------------------------------------------------
# 6. Just to make this script more portable we'll set the
# version number of Samba we are installing.
# ----------------------------------------------------------
smbversion="3.6.20";
printf '\033[0;32m%s\033[0m\n' '6. Installing SMB Version ${smbversion}';



# ----------------------------------------------------------
# 7. Create a private folder to store Samba's private
# passwords if it doesn't exist.
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' '7. Create a private folder to store Samba private passwords if it doesnt exist';
[[ -d "/usr/local/Cellar/samba/${smbversion}/private" ]] || mkdir "/usr/local/Cellar/samba/${smbversion}/private";



# ----------------------------------------------------------
# 8. Brew has created a symlink to smb.conf in
#
#   /usr/local/etc/smb.conf
#
# which points to
#
#   /usr/local/Cellar/samba/3.6.20/etc/smb.conf
#
# I don't really like this, because if you do an upgrade you
# could potentially loose your configurations. Let's replace
# the symlink with our own. We'll symlink both locations
# just to be safe.
# ----------------------------------------------------------
# Grab a starter template. Make sure to change out the following
# - [c]         : name of the folder you are mounting
# - path        : location of your local path you are mounting to
# - valid users : username that has access to the share
printf '\033[0;32m%s\033[0m\n' '8. Setting up a smb.conf starter template';
curl -s https://gist.github.com/psyrendust/8466620/raw/7315c73c709cf48f8af88d88fc243b921847d515/smb.conf | xargs -0 echo > "/usr/local/etc/smb_custom.conf";

# Change the owner, group and permissions
printf '\033[0;32m%s\033[0m\n' '    - Change the owner, group and permissions';
sudo chown $(echo $USER):admin "/usr/local/etc/smb_custom.conf";
sudo chmod 755 "/usr/local/etc/smb_custom.conf";

# Create the symlinks
printf '\033[0;32m%s\033[0m\n' '    - Create the symlinks';
ln -sf "/usr/local/etc/smb_custom.conf" "/usr/local/etc/smb.conf";
ln -sf "/usr/local/etc/smb_custom.conf" "/usr/local/Cellar/samba/${smbversion}/etc/smb.conf";




# ----------------------------------------------------------
# 9. Set our new Samba service to launch when the computer
# starts.
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' '9. Set our new Samba service to launch when the computer starts';
sudo launchctl load -w /Library/LaunchDaemons/org.samba.smbd.plist;
sudo launchctl load -w /Library/LaunchDaemons/org.samba.nmbd.plist;
