From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Mon Jul  5 04:27:21 2004
Subject: [Ocfs2-devel] 
	[Patch] fix  for continuous receiving FLAG_VOTE_UPDATE_RETRY
Message-ID: <3ACA40606221794F80A5670F0AF15F8404CD968E@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It seems the inode lock system map file is not released after =
acquired.That causes when another node want to acquire it,
this node found it is already holded.

-------------------------------------------------------------------------=
-------
Index: alloc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- alloc.c	(revision 1238)
+++ alloc.c	(working copy)
@@ -482,6 +482,21 @@
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
+	}
+=09
+	for (i =3D 0; i < osb->max_nodes; i++) {
 		if (ext_alloc_free[i] !=3D NULL) {
 			down_write(&OCFS_I(ext_alloc_inode[i])->ip_io_sem);
 			status =3D ocfs_release_lock (osb,
>-----Original Message-----
>From: ocfs2-devel-bounces@oss.oracle.com=20
>[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Ling, Xiaofeng
>Sent: 2004=C4=EA7=D4=C25=C8=D5 13:32
>To: Ocfs2-Devel
>Subject: RE: [Ocfs2-devel] [Patch] fix block when receive=20
>reply with retry--unsigned statuscause block=20
>
>I've found the FLAG_VOTE_UPDATE_RETRY is sent at nm.c line=20
>1515(svn 1238),=20
>because lockres->lock_holders>0.
>
>The reproduce step:
>Node A:
>mkdir /ocfs/aa
>Node B:
>rmdir /ocfs/aa
>Node A:
>mkdir /ocfs/bb
>...now Node A receive FLAG_VOTE_UPDATE_RETRY and always resend=20
>the CHANGE_MASTER message.
>
>=20
>
>>-----Original Message-----
>>From: ocfs2-devel-bounces@oss.oracle.com=20
>>[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of=20
>Ling, Xiaofeng
>>Sent: 2004=C4=EA7=D4=C22=C8=D5 14:20
>>To: Mark Fasheh
>>Cc: Ocfs2-Devel
>>Subject: [Ocfs2-devel] [Patch] fix block when receive reply=20
>>with retry-- unsigned statuscause block=20
>>
>>the vote_stauts of ocfs_vote_obj is defined as __u32, this causes
>>"obj->vote_status < 0" always fail in ocfs_comm_process_vote_reply.
>>When receive reply message with FLAG_VOTE_UPDATE_RETRY, the process is
>>block.
>>I have not found what causes FLAG_VOTE_UPDATE_RETRY is sent back.
>>
>>-------------------------------------------------------------------
>>Index: ocfs.h
>>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>--- ocfs.h      (revision 1232)
>>+++ ocfs.h      (working copy)
>>@@ -753,7 +753,7 @@
>>        spinlock_t lock;
>>        __u32 vote_state;
>>        __u32 req_lock_type;
>>-       __u32 vote_status;
>>+       int vote_status;
>>        ocfs_node_map req_vote_map;
>>        ocfs_node_map got_vote_map;
>>        ocfs_node_map tmp_openmap;
>>_______________________________________________
>>Ocfs2-devel mailing list
>>Ocfs2-devel@oss.oracle.com
>>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
>>
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
