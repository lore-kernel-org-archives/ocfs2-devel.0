From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Mon Mar  1 11:25:08 2004
Subject: [Ocfs2-devel] [PATCH]trivial warning fixes
Message-ID: <200403011724.i21HOjqc017905@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following patch fixes some simple compile warnings.

    --rusty

Index: src/nm.c
===================================================================
--- src/nm.c	(revision 738)
+++ src/nm.c	(working copy)
@@ -39,6 +39,7 @@
 
 void ocfs_process_vote_worker(void *val);
 
+#ifdef VERBOSE_PROCESS_VOTE
 static const char *process_vote_strings[] = {
 	"INVALID_REQUEST",      // reply with a NO vote
 	"UPDATE_OIN_INODE",     // update both oin and inode
@@ -51,6 +52,7 @@
 	"REMASTER_THIS",        // remaster lock to me
 	"REMASTER_REQUESTOR"    // remaster lock to requestor
 };
+#endif
 
 /*
  * ocfs_recv_thread()
@@ -228,7 +230,8 @@
 	int status = 0;
 	__u8 *buffer = NULL;
 	ocfs_publish *publish;
-	__u32 i, j;
+	__u32 i;
+	unsigned long j;
 	__u32 highest_vote_node;
 	__u64 offset = 0;
 	__u32 num_nodes = 0;
Index: src/file.c
===================================================================
--- src/file.c	(revision 738)
+++ src/file.c	(working copy)
@@ -347,7 +347,9 @@
         ocfs_super * osb;
         ocfs_inode *oin = NULL;
         struct dentry *dentry;
+#ifdef DO_PARENT_INODE_INC
         struct inode *parent;
+#endif
 	bool last_close = false;
 
 	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, '%*s')\n", inode, file,
