From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Wed Mar 24 22:05:51 2004
Subject: [Ocfs2-devel] [BUG] strange behavior with mknod on ocfs2
Message-ID: <200403250405.i2P45gYf017979@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I just created a new bug in bugzilla for some wacky bahavior around mknod.

The following is cut out of the bug report at ==>
http://oss.oracle.com/bugzilla/show_bug.cgi?id=52

On a 2.4 build, creating devices with mknod will result in the in-memory major
and minor numbers not matching the on-disk major and minor numbers (untill the
filesystem is remounted.)

For example:
[root@penguin nodetest2]# mknod somenode b 1 1
[root@penguin nodetest2]# ls -l somenode
brw-r--r--    1 root     root      11,   0 Mar 24 19:47 somenode
[root@penguin nodetest2]# cd /
[root@penguin /]# umount /oracle
[root@penguin /]# mount -t ocfs2 /dev/sda1 /oracle
[root@penguin /]# cd -
/oracle/nodetest2
[root@penguin nodetest2]# ls -l somenode
brw-r--r--    1 root     root       1,   1 Mar 24 19:47 somenode
[root@penguin nodetest2]#

On a 2.6 kernel I see a slightly different bahavior, where aa ls(1) of any 
device file will show a major of 8 and a minor of 17, regardless of what 
is on disk.

From a 2.6 system...

[root@nobody nodetest2]# mknod somenode b 1 1
[root@nobody nodetest2]# ls -l somenode
brw-r--r--    1 root     root       8,  17 Mar 24 19:52 somenode
[root@nobody nodetest2]# cd /
[root@nobody /]# umount /oracle/
[root@nobody /]# mount -t ocfs2 /dev/sdb1 /oracle
[root@nobody /]# cd -
/oracle/nodetest2
[root@nobody nodetest2]# ls -l somenode
brw-r--r--    1 root     root       8,  17 Mar 24 19:52 somenode
[root@nobody nodetest2]# mknod somenode c 122 99992
[root@nobody nodetest2]# ls -l somenode
crw-r--r--    1 root     root       8,  17 Mar 24 19:55 somenode

If I mount the volume from a 2.4 build, then I see the correct 
major and minor numbers, so the device info is correct on disk.
