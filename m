From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Fri Apr 23 03:40:25 2004
Subject: [Ocfs2-devel] About 2.6 porting bug 58 "system halt when unmount
	a volumeimmediately after read/write"
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65E7C@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

	I think I find some clues of this bug.

	Since svn version 847, function ocfs_release_oin() is removed from the =
file oin.c. In function ocfs_file_release() of the former version, the =
inode usage count i_count is decreased in ocfs_release_oin() each time =
dentry->d_count is 0. But, in the latest version, it won't be decreased =
until the journal lock is released in journal_commit_cache().

	I remember that this change is to avoid access empty inode pointer =
reserved in journal lock. Am I right?

	In kernel 2.6 VFS routine sys_umount()->...->generic_shutdown_super(), =
if the inode usage count i_count is not 0, error information is =
reported. Then, the system will halt in routine =
kill_bdev()->truncate_inode_pages().

	I am looking for a good solution for this bug. Do you have some advice?

	Thank you.


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
*********************************************=20

-----Original Message-----
From: ocfs2-devel-bounces@oss.oracle.com =
[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Zhang, Sonic
Sent: 2004=C4=EA4=D4=C222=C8=D5 15:59
To: Ocfs2-Devel
Subject: [Ocfs2-devel] About 2.6 porting bug 58 "system halt when =
unmount a volumeimmediately after read/write"

Hi,

	We find this bug since svn version 847, in which a patch against
kernel 2.4 is merged in.=20

	This 2.6 porting bug occurs only when unmount a volume
immediately after read/write and before the journal_commit_cache() is
called in journal_commit_thread.=20

	Kernel reports:
	VFS: Busy inodes after unmount. Self-destruct in 5 seconds. Have
a nice day...

	It has nothing to do with remod.

	Any suggestion?


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
*********************************************=20

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel
