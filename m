From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Tue Mar  2 10:28:46 2004
Subject: [Ocfs2-devel] [PATCH]trivial warning fixes
In-Reply-To: <200403011724.i21HOjqc017905@penguin.co.intel.com>
References: <200403011724.i21HOjqc017905@penguin.co.intel.com>
Message-ID: <20040302162448.GA25830@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 01, 2004 at 09:24:45AM -0800, Rusty Lynch wrote:
> The following patch fixes some simple compile warnings.
> 
>     --rusty

Recent tree changes removed one of the compile warnings (the
one for an unused variable named parent.)  Here is the patch
recreated against this mornings svn tree.


Index: src/nm.c
===================================================================
--- src/nm.c	(revision 744)
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
