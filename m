From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Mon Jul  5 22:28:52 2004
Subject: [Ocfs2-devel] [Patch] fix  for continuous receiving
	FLAG_VOTE_UPDATE_RETRY
Message-ID: <3ACA40606221794F80A5670F0AF15F8404CD9BDD@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

=20

>-----Original Message-----
>From: Mark Fasheh [mailto:mark.fasheh@oracle.com]=20
>Sent: 2004=C4=EA7=D4=C26=C8=D5 1:58
>To: Ling, Xiaofeng
>Cc: ocfs2-devel@oss.oracle.com
>Subject: Re: [Ocfs2-devel] [Patch] fix for continuous=20
>receiving FLAG_VOTE_UPDATE_RETRY
>
>
>Hmm, since we loop on the same conditions (i <=20
>osb->max_nodes), could you
>resend with both 'if' blocks within the same 'for' loop? Also,=20
>if you feel
>like fixing the bug noted above in the same patch, that'd be=20
>just fine with
>me :)
>	--Mark
I resend the patch and also adding the free of inode_alloc_inode.
But I have a concern about combinding loop.
At acquiring, the loop is separated, that is after acquired all the =
inode_alloc_inode and then
begin to acquire ext_alloc_inode. Is there any special consideration? =
Does release need the
same process?

-------------------------------------------------------------------------=
-
Index: alloc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- alloc.c	(revision 1238)
+++ alloc.c	(working copy)
@@ -482,6 +482,19 @@
 	}
=20
 	for (i =3D 0; i < osb->max_nodes; i++) {
+		if (inode_alloc_free[i] !=3D NULL) {
+			down_write(&OCFS_I(inode_alloc_inode[i])->ip_io_sem);
+			status =3D ocfs_release_lock (osb,
+						    OCFS_LKM_EXMODE,
+						    FLAG_FILE_CREATE,
+						    NULL, inode_alloc_inode[i]);
+			up_write(&OCFS_I(inode_alloc_inode[i])->ip_io_sem);
+			if (status < 0) {
+				LOG_ERROR_STATUS (status);
+				goto finally;
+			}
+		}
+
 		if (ext_alloc_free[i] !=3D NULL) {
 			down_write(&OCFS_I(ext_alloc_inode[i])->ip_io_sem);
 			status =3D ocfs_release_lock (osb,
@@ -497,6 +510,13 @@
 	}
=20
 finally:
+	if (inode_alloc_inode) {
+		for (i =3D 0; i < osb->max_nodes; i++) {
+			if (inode_alloc_inode[i])
+				iput(inode_alloc_inode[i]);
+		}
+		kfree(inode_alloc_inode);
+	}
=20
 	if (ext_alloc_inode) {
 		for (i =3D 0; i < osb->max_nodes; i++) {
