From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Tue Apr 27 20:55:33 2004
Subject: [Ocfs2-devel] system halt when create a directory in ocfs2 volume
	(svn 866 kernel 2.6)
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65E88@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

	We run the test on a DELL P4 with 256 M memory.

Stack trace:

check_rootdir_overwrite
ocfs_journal_dirty
ocfs_mknod_locked
ocfs_mknod
ocfs_mkdir



*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
*********************************************=20

-----Original Message-----
From: Mark Fasheh [mailto:mark.fasheh@oracle.com]=20
Sent: 2004=C4=EA4=D4=C228=C8=D5 2:23
To: Zhang, Sonic
Cc: Ocfs2-Devel
Subject: Re: [Ocfs2-devel] system halt when create a directory in ocfs2 =
volume (svn 866 kernel 2.6)

On Tue, Apr 27, 2004 at 04:47:49PM +0800, Zhang, Sonic wrote:
> Hi,
>=20
> 	When create a directory, system halts with error information.
> This bug is found since svn 866 in kernel 2.6. Because we fail to =
mount
> an ocfs volume under kernel 2.4 with this version of driver, we can't
> make sure if it is kernel independent.=20
We've seen some possibly similar behavior on an x86-64 box we've got =
over
here. Can you tell me what hardware you're running on? Also, do you have =
a
stack trace?
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
