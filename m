From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Mon Jul  5 00:32:00 2004
Subject: [Ocfs2-devel] [Patch] fix block when receive reply with retry--
	unsigned statuscause block 
Message-ID: <3ACA40606221794F80A5670F0AF15F8404CD9368@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I've found the FLAG_VOTE_UPDATE_RETRY is sent at nm.c line 1515(svn =
1238),=20
because lockres->lock_holders>0.

The reproduce step:
Node A:
mkdir /ocfs/aa
Node B:
rmdir /ocfs/aa
Node A:
mkdir /ocfs/bb
...now Node A receive FLAG_VOTE_UPDATE_RETRY and always resend the =
CHANGE_MASTER message.

=20

>-----Original Message-----
>From: ocfs2-devel-bounces@oss.oracle.com=20
>[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Ling, Xiaofeng
>Sent: 2004=C4=EA7=D4=C22=C8=D5 14:20
>To: Mark Fasheh
>Cc: Ocfs2-Devel
>Subject: [Ocfs2-devel] [Patch] fix block when receive reply=20
>with retry-- unsigned statuscause block=20
>
>the vote_stauts of ocfs_vote_obj is defined as __u32, this causes
>"obj->vote_status < 0" always fail in ocfs_comm_process_vote_reply.
>When receive reply message with FLAG_VOTE_UPDATE_RETRY, the process is
>block.
>I have not found what causes FLAG_VOTE_UPDATE_RETRY is sent back.
>
>-------------------------------------------------------------------
>Index: ocfs.h
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>--- ocfs.h      (revision 1232)
>+++ ocfs.h      (working copy)
>@@ -753,7 +753,7 @@
>        spinlock_t lock;
>        __u32 vote_state;
>        __u32 req_lock_type;
>-       __u32 vote_status;
>+       int vote_status;
>        ocfs_node_map req_vote_map;
>        ocfs_node_map got_vote_map;
>        ocfs_node_map tmp_openmap;
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
>
