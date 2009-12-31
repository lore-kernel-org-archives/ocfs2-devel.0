From: Robert Smith <spamfree@wansecurity.com>
Date: Fri, 1 Jan 2010 03:15:29 +0900
Subject: [Ocfs2-devel] 40TB RAID and OCFS2 woes (inode64, JDB2,
	huge partition support,
	Volume might try to write to blocks beyond what jbd can address in 32
	bits)
In-Reply-To: <20091231034243.GA2560@mail.oracle.com>
References: <9A9AABD3-F67F-46D3-B08C-4FD89CA16149@wansecurity.com>
	<20091230203426.GA7272@mail.oracle.com>
	<1D016AC1-13F8-4433-9E1D-6540302C0373@wansecurity.com>
	<20091231034243.GA2560@mail.oracle.com>
Message-ID: <E8CB0062-5A3B-4853-9804-8F345404A635@wansecurity.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Dear Joel, please see below,

On Dec 31, 2009, at 12:42 PM, Joel Becker wrote:

> On Thu, Dec 31, 2009 at 07:25:37AM +0900, Robert Smith wrote:
>> Dear Joel, I am using a custom compiled kernel version 2.6.32.2, using the stock ubuntu 9.10 server-config for the kernel config.
> 
> 	Hmm...
> 
>> root at s2-replay01:~# grep OCFS2 /usr/src/linux-2.6.32.2/.config
>> CONFIG_OCFS2_FS=m
>> CONFIG_OCFS2_FS_O2CB=m
>> CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
>> CONFIG_OCFS2_FS_STATS=y
>> CONFIG_OCFS2_DEBUG_MASKLOG=y
>> # CONFIG_OCFS2_DEBUG_FS is not set
>> CONFIG_OCFS2_FS_POSIX_ACL=y
>> root at s2-replay01:~# 
>> 
>> root at s2-replay01:~# grep -i ocfs /proc/filesystems 
>> nodev   ocfs2_dlmfs
>>        ocfs2
> 
> 	What do you get from 'modinfo ocfs2'?  You should see jbd2 as a
> dependency.  If ocfs2 is loaded, jbd2 should be as well.  Sunil is
> right, 2.6.32 shouldn't have it any other way.
> 	Let's check on your filesystem itself.  How about the output of
> 'tunefs.ocfs2 -Q "%M %H %O\n" /dev/replays/replay-data'?  That should
> include strict-journal-super.  Then check 'debugfs.ocfs2 -R
> "logdump 0" /dev/replays/replay-data'.  We're looking for "Incompat:
> 0x2".  That means 64bit journals.
> 
> Joel

I've removed the LV and created a new one, but here is what it says when we use tunefs.ocfs2 to check the filesystem features after a fresh format:

root at s2-replay02:~# time /sbin/mkfs.ocfs2 -L "ReplayDataVolume001" -C 1M -N 2 -J block64 -F -v -T datafiles -M cluster --fs-feature-level=max-features /dev/replays/ReplayDataVolume001 
mkfs.ocfs2 1.4.3
Cluster stack: classic o2cb
Overwriting existing ocfs2 partition.
WARNING: Cluster check disabled.
Proceed (y/N): y
Filesystem Type of datafiles
Filesystem label=ReplayDataVolume001
Block size=4096 (bits=12)
Cluster size=1048576 (bits=20)
Volume size=39999990923264 (38146964 clusters) (9765622784 blocks)
1183 cluster groups (tail covers 20372 clusters, rest cover 32256 clusters)
Journal size=33554432
Initial number of node slots: 2
Creating bitmaps: done
Initializing superblock: done
Writing system files: done
Writing superblock: done
Writing backup superblock: 6 block(s)
Formatting Journals: done
Formatting slot map: done
Writing lost+found: done
mkfs.ocfs2 successful


real    0m20.666s
user    0m0.150s
sys     0m0.220s
root at s2-replay02:~#


root at s2-replay02:~# tunefs.ocfs2 -Q "%M %H %O\n" /dev/replays/ReplayDataVolume001 
backup-super strict-journal-super sparse extended-slotmap inline-data metaecc xattr unwritten
root at s2-replay02:~#


root at s2-replay02:/usr/src/ocfs2-tools-1.4.3# modinfo ocfs2
filename:       /lib/modules/2.6.32.2.31337/kernel/fs/ocfs2/ocfs2.ko
license:        GPL
author:         Oracle
version:        1.5.0
description:    OCFS2 1.5.0
srcversion:     944B0B239B4DEBAF58A7FE1
depends:        ocfs2_stackglue,quota_tree,ocfs2_nodemanager
vermagic:       2.6.32.2.31337 SMP mod_unload modversions 

root at s2-replay02:/usr/src/ocfs2-tools-1.4.3# lsmod | grep -i jd

root at s2-replay02:/usr/src/ocfs2-tools-1.4.3# lsmod
Module                  Size  Used by
ocfs2                 716067  0 
quota_tree              7902  1 ocfs2
ocfs2_dlmfs            17842  1 
ocfs2_stack_o2cb        3710  0 
ocfs2_dlm             209561  2 ocfs2_dlmfs,ocfs2_stack_o2cb
ocfs2_nodemanager     206035  16 ocfs2,ocfs2_dlmfs,ocfs2_stack_o2cb,ocfs2_dlm
ocfs2_stackglue        11448  2 ocfs2,ocfs2_stack_o2cb
configfs               26645  2 ocfs2_nodemanager
snd_hda_intel          23641  0 
snd_hda_codec          79537  1 snd_hda_intel
snd_hwdep               6506  1 snd_hda_codec
snd_pcm                83465  2 snd_hda_intel,snd_hda_codec
iptable_filter          2679  0 
snd_timer              22574  1 snd_pcm
lp                      9112  0 
snd                    68301  5 snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
psmouse                52687  0 
ip_tables              17422  1 iptable_filter
soundcore               7860  1 snd
parport                36303  1 lp
serio_raw               4704  0 
snd_page_alloc          8388  2 snd_hda_intel,snd_pcm
x_tables               21645  1 ip_tables
reiserfs              234332  1 
usb_storage            47615  0 
usbhid                 39208  0 
tg3                   116607  0 
e1000e                130077  0 
arcmsr                 24000  3 
root at s2-replay02:/usr/src/ocfs2-tools-1.4.3# 


No JBD in the module list? Perhaps it's built-in? (I built this kernel on the other host of the cluster)


wansecurity at s2-replay01:~$ grep -i jbd /usr/src/linux-2.6.32.2/.config
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
wansecurity at s2-replay01:~$ 


As Mr. Sunil Mushran suggested:

root at s2-replay02:~# ls -aFl /proc/fs/
total 0
dr-xr-xr-x   5 root root 0 2009-12-31 11:58 ./
dr-xr-xr-x 180 root root 0 2009-12-31 11:48 ../
dr-xr-xr-x   2 root root 0 2009-12-31 11:58 ext4/
dr-xr-xr-x   2 root root 0 2009-12-31 11:58 jbd2/
dr-xr-xr-x   2 root root 0 2009-12-31 11:58 nfsd/
root at s2-replay02:~# 

There it is, and only version 2 is listed. This is good no!?


So unfortunately, it appears that even the new manual page for the mount.ocfs2 v1.4.3 that I *just* installed does not have the inode64 mount option listed: (I have seen it in a manual page, or maybe at least a proposed one somewhere)

root at s2-replay02:/usr/src/ocfs2-tools-1.4.3# ls -aFl /usr/man/man8/mount.ocfs2.8 
-rw-r--r-- 1 root root 3130 2009-12-31 12:01 /usr/man/man8/mount.ocfs2.8
root at s2-replay02:/usr/src/ocfs2-tools-1.4.3# date
Thu Dec 31 12:01:50 CST 2009
root at s2-replay02:/usr/src/ocfs2-tools-1.4.3# nroff -mandoc /usr/man/man8/mount.ocfs2.8 | grep -i inode
root at s2-replay02:/usr/src/ocfs2-tools-1.4.3#


Well, we'll try it again just for the heck of it:

root at s2-replay02:/usr/src/ocfs2-tools-1.4.3# ls -aFl `which mount.ocfs2`
-rwxr-xr-x 1 root root 185508 2009-12-31 12:01 /sbin/mount.ocfs2*
root at s2-replay02:/usr/src/ocfs2-tools-1.4.3# 


Here we go:

root at s2-replay02:/usr/src/ocfs2-tools-1.4.3# mount.ocfs2 -o inode64 /dev/replays/ReplayDataVolume001 /data/storage/ReplayDataVolume001
mount.ocfs2: Unable to access cluster service while trying initialize cluster

Oops, forgot to restart that:


root at s2-replay02:/usr/src/ocfs2-tools-1.4.3# dpkg-reconfigure ocfs2-tools
update-rc.d: warning: o2cb start runlevel arguments (S) do not match LSB Default-Start values (2 3 5)
update-rc.d: warning: o2cb stop runlevel arguments (0 6) do not match LSB Default-Stop values (none)
Loading filesystem "configfs": OK
Mounting configfs filesystem at /sys/kernel/config: OK
Loading stack plugin "o2cb": 
OK
Loading filesystem "ocfs2_dlmfs": OK
Mounting ocfs2_dlmfs filesystem at /dlm: OK
Setting cluster stack "o2cb": OK
Starting O2CB cluster replaycluster: OK
update-rc.d: warning: ocfs2 start runlevel arguments (S) do not match LSB Default-Start values (2 3 5)
update-rc.d: warning: ocfs2 stop runlevel arguments (0 6) do not match LSB Default-Stop values (none)
Starting Oracle Cluster File System (OCFS2) 
root at s2-replay02:/usr/src/ocfs2-tools-1.4.3#
 
root at s2-replay02:/usr/src/ocfs2-tools-1.4.3# mount.ocfs2 -o inode64 /dev/replays/ReplayDataVolume001 /data/storage/ReplayDataVolume001
mount.ocfs2: Invalid argument while mounting /dev/replays/ReplayDataVolume001 on /data/storage/ReplayDataVolume001. Check 'dmesg' for more information on this error.
root at s2-replay02:/usr/src/ocfs2-tools-1.4.3#

Bummer

root at s2-replay02:/usr/src/ocfs2-tools-1.4.3# dmesg | tail -n 30 
....
....
[ 1017.163255] OCFS2 Node Manager 1.5.0
[ 1017.228882] OCFS2 DLM 1.5.0
[ 1017.232440] ocfs2: Registered cluster interface o2cb
[ 1017.247862] OCFS2 DLMFS 1.5.0
[ 1017.248072] OCFS2 User DLM kernel interface loaded
[ 1032.163970] OCFS2 1.5.0
[ 1032.168415] (3776,6):ocfs2_initialize_super:2166 ERROR: Volume might try to write to blocks beyond what jbd can address in 32 bits.
[ 1032.168490] (3776,6):ocfs2_fill_super:1008 ERROR: status = -22
[ 1032.168525] ocfs2: Unmounting device (252,0) on (node 0)
[ 1220.077245] (3821,5):ocfs2_initialize_super:2166 ERROR: Volume might try to write to blocks beyond what jbd can address in 32 bits.
[ 1220.077306] (3821,5):ocfs2_fill_super:1008 ERROR: status = -22
[ 1220.077342] ocfs2: Unmounting device (252,0) on (node 0)
[ 1228.102152] (3834,4):ocfs2_initialize_super:2166 ERROR: Volume might try to write to blocks beyond what jbd can address in 32 bits.
[ 1228.102276] (3834,4):ocfs2_fill_super:1008 ERROR: status = -22
[ 1228.102317] ocfs2: Unmounting device (252,0) on (node 0)
[ 1236.126519] (3844,4):ocfs2_initialize_super:2166 ERROR: Volume might try to write to blocks beyond what jbd can address in 32 bits.
[ 1236.126581] (3844,4):ocfs2_fill_super:1008 ERROR: status = -22
[ 1236.126621] ocfs2: Unmounting device (252,0) on (node 0)
[ 1244.150444] (3852,4):ocfs2_initialize_super:2166 ERROR: Volume might try to write to blocks beyond what jbd can address in 32 bits.
[ 1244.150504] (3852,4):ocfs2_fill_super:1008 ERROR: status = -22
[ 1244.150539] ocfs2: Unmounting device (252,0) on (node 0)
root at s2-replay02:/usr/src/ocfs2-tools-1.4.3#


Think I need to recompile the kernel and change the built in support for JBD v1 to a module? Or modularize both of them?

-Robert



> 
> -- 
> 
> "And yet I fight,
> And yet I fight this battle all alone.
> No one to cry to;
> No place to call home."
> 
> Joel Becker
> Principal Software Developer
> Oracle
> E-mail: joel.becker at oracle.com
> Phone: (650) 506-8127
