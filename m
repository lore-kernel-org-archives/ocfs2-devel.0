From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Thu Apr 29 20:20:12 2004
Subject: [Ocfs2-devel] What's your opinion on the patch to fix bug 58 for
	kernel 2.6 porting?
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65E95@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

	In kernel 2.6 VFS routine sys_umount()->...->generic_shutdown_super(), =
if the inode usage count i_count is not 0, error information is =
reported. Then, the system will halt in routine =
kill_bdev()->truncate_inode_pages().
	If we don't fix it in OCFS2 driver, we have to change the kernel 2.6 =
VFS sys_umount code. Is it a good solution?

	Thanks.


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
*********************************************=20

-----Original Message-----
From: Mark Fasheh [mailto:mark.fasheh@oracle.com]=20
Sent: 2004=C4=EA4=D4=C230=C8=D5 1:32
To: Zhang, Sonic
Cc: Ocfs2-Devel
Subject: Re: [Ocfs2-devel] What's your opinion on the patch to fix bug =
58 for kernel 2.6 porting?

Well, to be perfectly honest I don't think this is the right solution.
Instead of peppering the code with signal stuff, why not try to figure =
out
what the timing issue is (it seems that the umount thread should wait on
pending operations) and fix it that way?
	--Mark

On Thu, Apr 29, 2004 at 10:10:56AM +0800, Zhang, Sonic wrote:
> Hi Mark,
>=20
> 	Do you have any opinion on the patch to fix bug 58 for kernel
> 2.6 porting?
> 	Could you add the patch into the source tree?=20
>=20
> 	Thank you.
>=20
>=20
> *********************************************
> Sonic Zhang
> Software Engineer
> Intel China Software Lab
> Tel: (086)021-52574545-1667
> iNet: 752-1667
> *********************************************=20
>=20


> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
