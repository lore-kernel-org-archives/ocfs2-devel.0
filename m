From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Mon Apr 26 20:32:17 2004
Subject: [Ocfs2-devel] Patch to fix OCFS2 bug 58 "system halt when
	unmountavolumeimmediately after read/write"
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65E83@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

This bug is not hit when shutdown. It occurs only when unmount a volume =
immediately after open/read/write/close files in it and before =
ocfs_commit_cache() is called in ocfs_commit_thread().

Bug 58 details.
http://oss.oracle.com/bugzilla/show_bug.cgi?id=3D58

Steps: (should do in script)
1. load_ocfs2
2. mount /dev/hda4 /ocfs
3. write and read files in /ocfs.
4. close files.
5. umount /ocfs immediately=20


Results:
System halts with error information.
VFS: Busy inodes after unmount. Self-destruct in 5 seconds. Have a nice =
day...



*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
*********************************************=20

-----Original Message-----
From: Mark Fasheh [mailto:mark.fasheh@oracle.com]=20
Sent: 2004=C4=EA4=D4=C227=C8=D5 5:11
To: Zhang, Sonic
Cc: Ocfs2-Devel
Subject: Re: [Ocfs2-devel] Patch to fix OCFS2 bug 58 "system halt when =
unmountavolumeimmediately after read/write"

On Mon, Apr 26, 2004 at 05:19:06PM +0800, Zhang, Sonic wrote:
> Hi,
>=20
> 	I changed a little to my original patch. I also send signal in
> 	ocfs_rename() and ocfs_unlink().=20
Can you explain why we need this?

> ... This new patch is against the
> 	latest svn version 867. I have run xiaofeng's test suite many times
> 	and got no problems by now.
Ok, if it's for a bug that you're hitting on shutdown, could you explain
also what exactly that bug is?

Thakns for all the work debugging this.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
