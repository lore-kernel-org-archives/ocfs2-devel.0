From: Kui Zhang <kuizhang@gmail.com>
Date: Thu, 14 Apr 2011 23:07:31 -0700
Subject: [Ocfs2-devel] ocfs2 1.6 2.6.38-2-amd64 kernel panic when unmount
Message-ID: <BANLkTikp9qdgYwhtqrNMArqO9P4mAGSHXw@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello

We have an ocfs2 1.6 via drbd dual master.

drbd0 -> sda7 (node1)
drbd0 -> sda7 (node2)

ocfs2 1.6 2.6.38-2-amd64 kernel panic when unmount.


when unmount drbd0 on both node around the same time using dsh.

umount -v /dev/drbd0

the umount process hangs for a while, 30mins or so

pts/0    D+   20:50   0:00 umount /dev/drbd0 -vvvvv

Then, one of the node kernel panics

Message from syslogd at node? at Apr 14 21:14:07 ...
 kernel:[ 3987.895005] ------------[ cut here ]------------

Message from syslogd at node? at Apr 14 21:14:07 ...
 kernel:[ 3987.908454] invalid opcode: 0000 [#1] SMP

Message from syslogd at node? at Apr 14 21:14:07 ...
 kernel:[ 3987.915264] last sysfs file: /sys/fs/ocfs2/loaded_cluster_plugins

Message from syslogd at node? at Apr 14 21:14:07 ...
 kernel:[ 3988.101686] Stack:

Message from syslogd at node? at Apr 14 21:14:07 ...
 kernel:[ 3988.135840] Call Trace:

Message from syslogd at node? at Apr 14 21:14:07 ...
 kernel:[ 3988.328876] Code: 00 00 53 48 89 fb 89 c2 c1 fa 10 66 39 c2
75 04 0f 0b eb fe f6 87 d2 00 00 00 20 74 05 e8 b5 47 ff ff f6 83 d2
00 00 00 20 74 04 <0f> 0b eb fe f0 ff 83 ac 00 00 00 5b c3 55 48 89 fd
53 48 89 f3

Message from syslogd at node? at Apr 14 21:14:07 ...
 kernel:[ 3988.397108] Kernel panic - not syncing: Fatal exception

Unmount on the other node finishes.

[18066.352020] o2net: no longer connected to node node1 (num 1) at
192.168.0.5:7777
[18066.367353] ocfs2: Unmounting device (147,0) on (node 0)
[18142.527745] o2net: accepted connection from node node1 (num 1) at
192.168.0.5:7777
[18146.144648] o2dlm: Nodes in domain 8FE8B448109C4DBEA78241004023AB1E: 0 1
[18146.158441] ocfs2: Mounting device (147,0) on (node 0, slot 0) with
ordered data mode.



Thanks
KuiZ
