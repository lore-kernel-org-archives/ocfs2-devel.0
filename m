From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Thu Aug 26 01:43:33 2004
Subject: [Ocfs2-devel] [PATCH] fix big 116 -- umount cause crash after
	some operation
Message-ID: <3ACA40606221794F80A5670F0AF15F84054F3E60@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ok. seems put ocfs_dismount_volume in put_super can resolve half of the =
problem.
But there still have busy inode when rmdir and umount at once. see =
message:
"VFS:Busy inodes after unmount. Self-destruct in 5 seconds. Have a nice =
day..."
rmmod and re-insert will cause segmentation fault due the slab problem.
for mkdir, it may also happen, but not every time.



>-----Original Message-----
>From: Mark Fasheh [mailto:mark.fasheh@oracle.com]=20
>Sent: 2004=C4=EA8=D4=C226=C8=D5 1:40
>To: Ling, Xiaofeng
>Cc: ocfs2-devel@oss.oracle.com
>Subject: Re: [Ocfs2-devel] [PATCH] fix big 116 -- umount cause=20
>crash after some operation
>
>On Wed, Aug 25, 2004 at 09:04:39AM +0800, Ling, Xiaofeng wrote:
>> So what we see is not the same.=20
>> The bug 116 is easy to reproduce, just do a command line as
>> root#mkdir /ocfs/aaa;umount /ocfs
>> follow the umount to mkdir tightly.
>Ok, I think I see what's going on here.
>
>if I do this:
>
>mkdir /ocfs2/foobar/baz; umount /ocfs2
>
>assuming that foobar was created a while ago so the commit=20
>thread has no
>work currently then the umount goes through fine, we wait on the commit
>thread and he flushes everything.
>
>however,
>
>mkdir /ocfs/foo; umount /ocfs2
>
>will crash things almost immediately. What's the only difference there?
>Basically that the root inode is in the commit thread on the=20
>second case.
>
>What I believe is happening is that umount succeeds without calling
>clear_inode on the root inode because we still have a=20
>reference on it, so
>none of the actual work for umounting has been done, yet umount exits.
>That'd explain the busy inodes message we always get and the=20
>random crashes
>in one or the other ocfs2 thread.
>
>Can you try this patch and see if it reproduces? Running with=20
>this, I can't
>get it to crash any more :) We did dismount from clear_inode=20
>for historical
>reasons having to do with some data structures we used to alloc on the
>inodes. We no longer have those issues due to our sane=20
>handling of inode
>private nowadays, so I think it's fine to actually umount from=20
>our put_super
>method like other file systems :)
>	--Mark
>
>--
>Mark Fasheh
>Software Developer, Oracle Corp
>mark.fasheh@oracle.com
>
>Index: super.c
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>--- super.c	(revision 1383)
>+++ super.c	(working copy)
>@@ -712,7 +712,8 @@ static void ocfs_put_super (struct super
> 	LOG_ENTRY_ARGS ("(0x%p)\n", sb);
>=20
> 	ocfs_sync_blockdev(sb);
>-	LOG_TRACE_STR ("put super... do nothing!  DONE!!!!");
>+	ocfs_dismount_volume (sb);
>+
> 	LOG_EXIT ();
>=20
> 	LOG_CLEAR_CONTEXT();
>Index: inode.c
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>--- inode.c	(revision 1383)
>+++ inode.c	(working copy)
>@@ -757,15 +757,6 @@ void ocfs_clear_inode (struct inode *ino
> 	ocfs_extent_map_destroy (&OCFS_I(inode)->ip_ext_map);
> 	ocfs_extent_map_init (&OCFS_I(inode)->ip_ext_map);
>=20
>-	if (inode =3D=3D osb->root_inode) {
>-		LOG_TRACE_STR("this is the root inode, doing=20
>cleanup now!");
>-		ocfs_sync_blockdev(inode->i_sb);
>-		LOG_TRACE_STR ("syncing past root inode");
>-		LOG_TRACE_STR ("calling dismount");
>-		ocfs_dismount_volume (inode->i_sb);
>-		goto bail;
>-	}
>-
> 	down(&recovery_list_sem);
> 	list_del(&OCFS_I(inode)->ip_recovery_list);
> 	up(&recovery_list_sem);
>
