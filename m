From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Tue May  4 01:08:04 2004
Subject: [Ocfs2-devel] What's your opinion on the patch to fix bug 58 for
	kernel 2.6 porting?
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65E9D@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

	OK, see below.

This bug occurs only when unmount a volume immediately after =
open/read/write/close files.

Bug 58 details.
http://oss.oracle.com/bugzilla/show_bug.cgi?id=3D58

Steps: (done in one bash script)
1. load_ocfs2
2. mount /dev/hda4 /ocfs
3. write and read files in /ocfs.
4. close files.
5. umount /ocfs immediately=20

Results:
System halts with error information.
VFS: Busy inodes after unmount. Self-destruct in 5 seconds. Have a nice =
day...


Possible Cause:
	This error information is printed out in kernel 2.6 VFS routine =
generic_shutdown_super() after the second call to invalidate_inodes(). =
In invalidate_inodes(), only inodes with 0 usage count are added to the =
dispose list. And the ocfs_clear_inode(), which lead to =
ocfs_dismount_volume(), is only invoked for those inodes in the dispose =
list.=20

	In ocfs2 after svn version 847, ocfs_clear_inodes() is not invoked if =
unmount a volume immediately after open/read/write/close files, because =
the inode usage counts of the OCFS2 volume are not 0. The i_count isn't =
decreased in function ocfs_file_release() until the journal lock is =
released in ocfs_commit_thread().

	I remember that this change is adopted to avoid the =
ocfs_commit_thread() to access invalid inode referenced in journal lock. =
Am I right?

	In order to fix this bug, I think we have 2 approaches.=20
	One is to keep the mnt_count in struct vfsmount larger than 2 before =
the all inode usage counters are decreased to 0. The other is to =
decrease all inode usage counters before invalide_inodes() is called. =
This can be done in ocfs_put_super(), which is invoked just before the =
second call to invalidate_inodes().

	Any suggestion?
	Thank you.


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
*********************************************=20

-----Original Message-----
From: joel.becker@oracle.com [mailto:joel.becker@oracle.com]=20
Sent: 2004=C4=EA5=D4=C21=C8=D5 0:53
To: Zhang, Sonic
Cc: Mark Fasheh; Ocfs2-Devel
Subject: Re: [Ocfs2-devel] What's your opinion on the patch to fix bug =
58 for kernel 2.6 porting?

On Fri, Apr 30, 2004 at 09:19:19AM +0800, Zhang, Sonic wrote:
> 	In kernel 2.6 VFS routine =
sys_umount()->...->generic_shutdown_super(), if the inode usage count =
i_count is not 0, error information is reported. Then, the system will =
halt in routine kill_bdev()->truncate_inode_pages().
> 	If we don't fix it in OCFS2 driver, we have to change the kernel 2.6 =
VFS sys_umount code. Is it a good solution?

	The issue is not whether to fix it in the OCFS2 driver.  The
issue is solving the problem without resorting to ugly stuff like
signals.
	Can you provide a complete description of what happens to cause
the problem, so we can look at it?

Joel

--=20

"Depend on the rabbit's foot if you will, but remember, it didn't
 help the rabbit."
	- R. E. Shay

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
