From: Lynch, Rusty <rusty.lynch@intel.com>
Date: Thu Apr 29 14:14:11 2004
Subject: [Ocfs2-devel] FW: [Bug 67] New: umount hangs on 2.6.x builds
Message-ID: <032EB457B9DBC540BFB1B7B519C78B0E0411BEF4@orsmsx404.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

FYI: I submitted a new bug describing a problem that only exists for 2.6
kernels where umount will not return.

    --rusty

-----Original Message-----
From: bugzilla-daemon@oss.oracle.com
[mailto:bugzilla-daemon@oss.oracle.com] 
Sent: Thursday, April 29, 2004 12:09 PM
To: Lynch, Rusty
Subject: [Bug 67] New: umount hangs on 2.6.x builds

http://oss.oracle.com/bugzilla/show_bug.cgi?id=67

           Summary: umount hangs on 2.6.x builds
           Product: OCFS v2 (WIP)
           Version: unspecified
          Platform: PC
        OS/Version: other
            Status: NEW
          Severity: normal
          Priority: P2
         Component: other
        AssignedTo: kurt.hackel@oracle.com
        ReportedBy: rusty.lynch@intel.com


There are some bugs reported that the title sounds simular to this, but
I do not
think this actually the same bug.

On svn version 882, if ocfs2 is built and loaded on a 2.6.x kernel (I
have
personally tested against 2.6.1), calling umount on a mounted ocfs2
volume will
result in umount hanging (just the umount process, not the entire
system.)

Using the magic sysrq key feature on a debug build of the kernel, I am
able to
get the following stack trace of the umount task:

umount        R 35237B41     0  3089   2290                     (NOTLB)
c9d83cf8 00000082 cff519e0 35237b41 000000cd cda9e9e0 beb20959 000000bb
       c0339060 35237b41 000000cd c9d83d0c 00000246 00000062 d90e3f2c
000000cd
       cb9cdba0 0008a4ad c9d83d0c 00000c11 c9d83d34 c012000e c9d83d0c
0008a4ad
Call Trace:
 [<c012000e>] schedule_timeout+0x5e/0xb0
 [<c011ffa0>] process_timeout+0x0/0x10
 [<d08dba4e>] ocfs_sleep+0x8e/0x100 [ocfs2]
 [<d08a8309>] ocfs_acquire_lockres_ex+0x119/0x2e0 [ocfs2]
 [<d08bae8f>] ocfs_clear_inode+0x3ef/0x630 [ocfs2]
 [<c0166519>] write_inode_now+0x39/0x60
 [<c015fc06>] clear_inode+0xa6/0xc0
 [<c01608f3>] generic_forget_inode+0xe3/0x110
 [<c0160996>] iput+0x56/0x80
 [<d08b6961>] ocfs_inode_hash_prune_all+0xe1/0x250 [ocfs2]
 [<c0115560>] default_wake_function+0x0/0x20
 [<d08b6b48>] ocfs_inode_hash_destroy+0x78/0x170 [ocfs2]
 [<d08d9318>] ocfs_dismount_volume+0x368/0x6c0 [ocfs2]
 [<d08bb026>] ocfs_clear_inode+0x586/0x630 [ocfs2]
 [<c012e548>] __filemap_fdatawrite+0x98/0xa0
 [<c015fc06>] clear_inode+0xa6/0xc0
 [<c015fc6d>] dispose_list+0x4d/0x90
 [<c015fdf4>] invalidate_inodes+0x84/0xa0
 [<c014f390>] generic_shutdown_super+0x60/0x110
 [<c014fd4d>] kill_block_super+0x1d/0x50
 [<c014f296>] deactivate_super+0x46/0x70
 [<c016296c>] sys_umount+0x3c/0x90
 [<c01629d7>] sys_oldumount+0x17/0x20
 [<c0108f3d>] sysenter_past_esp+0x52/0x71
 
Also, I have the following info in my syslog...

lockres: lockid=2417152, this=0, master=0, locktype=8, flags=40004010,
ronode=-1, romap=00000000
ocfs2: waiting on lockres 1802201963.1802201963, mypid = 3089, thread_id
=
1802201963

So far I have seen this on both a debug UP build of the kernel, and a
debug
SMP/PREEMPT build of the kernel run on a machine with two PIII's



------- You are receiving this mail because: -------
You reported the bug, or are watching the reporter.
