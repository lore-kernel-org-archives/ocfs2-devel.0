From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Thu Apr 22 21:45:34 2004
Subject: [Ocfs2-devel] About 2.6 porting bug 58 "system halt when unmount
	a volumeimmediately after read/write"
Message-ID: <3ACA40606221794F80A5670F0AF15F8404151CE6@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Yes, seems if umount only, it will print call trace:=20
"kernel BUG at /usr/src/linux-2.6.3/fs/buffer.c:2660!"
and the system is not halt,If then follows rmmod at once, there will be =
kernel panic and system halt.
So problem has ready happened when unmounting.

> -----Original Message-----
> From: ocfs2-devel-bounces@oss.oracle.com=20
> [mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Zhang, Sonic
> Sent: 2004=C4=EA4=D4=C222=C8=D5 15:59
> To: Ocfs2-Devel
> Subject: [Ocfs2-devel] About 2.6 porting bug 58 "system halt=20
> when unmount a volumeimmediately after read/write"
>=20
>=20
> Hi,
>=20
> 	We find this bug since svn version 847, in which a=20
> patch against kernel 2.4 is merged in.=20
>=20
> 	This 2.6 porting bug occurs only when unmount a volume=20
> immediately after read/write and before the=20
> journal_commit_cache() is called in journal_commit_thread.=20
>=20
> 	Kernel reports:
> 	VFS: Busy inodes after unmount. Self-destruct in 5=20
> seconds. Have a nice day...
>=20
> 	It has nothing to do with remod.
>=20
> 	Any suggestion?
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
> Ocfs2-devel@oss.oracle.com=20
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>=20
