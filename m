From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Fri Jul  2 01:21:19 2004
Subject: [Ocfs2-devel] 
	[Patch] fix block when receive reply with retry-- unsigned status
	cause block 
Message-ID: <3ACA40606221794F80A5670F0AF15F8404C7A9F6@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

the vote_stauts of ocfs_vote_obj is defined as __u32, this causes
"obj->vote_status < 0" always fail in ocfs_comm_process_vote_reply.
When receive reply message with FLAG_VOTE_UPDATE_RETRY, the process is
block.
I have not found what causes FLAG_VOTE_UPDATE_RETRY is sent back.

-------------------------------------------------------------------
Index: ocfs.h
===================================================================
--- ocfs.h      (revision 1232)
+++ ocfs.h      (working copy)
@@ -753,7 +753,7 @@
        spinlock_t lock;
        __u32 vote_state;
        __u32 req_lock_type;
-       __u32 vote_status;
+       int vote_status;
        ocfs_node_map req_vote_map;
        ocfs_node_map got_vote_map;
        ocfs_node_map tmp_openmap;
