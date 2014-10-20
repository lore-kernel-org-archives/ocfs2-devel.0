From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Mon, 20 Oct 2014 13:28:41 +0800
Subject: [Ocfs2-devel] [PATCH] [ocfs2]: drop(unlock) dentry before iput in
	ocfs2_do_drop_dentry_lock
Message-ID: <1413782921-22224-1-git-send-email-wen.gang.wang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There is dead lock case like this(the Dentry is a dentry to the Inode):

node 1				node 2
-------------------             --------------------------

granted inode lock

requesting dentry lock
                                responding to node 1 request on dentry lock,
				it calls ocfs2_do_drop_dentry_lock with the
				call trace:
				  #4   wait_for_completion
				  #5   __ocfs2_cluster_lock
				  #6   ocfs2_inode_lock_full_nested
				  #7   ocfs2_evict_inode
				  #8   evict
				  #9   iput
				  #10  ocfs2_do_drop_dentry_lock

You can see node 2 is requesting the inode lock before unlocking dentry lock
thus a two nodes dead lock formed.

The story is like this:

Responding node 1's request, Node 2, ocfs2_dentry_convert_worker, returned
UNBLOCK_STOP_POST which means don't downconvert but do post_unlock action.
It was doing so because it thought it doesn't need to downconvert but will do
an unlock instead in the post_unlock action ocfs2_dentry_post_unlock().
By doing so it can save a clusted downconvert request for performace
consideration. But in ocfs2_dentry_post_unlock() before unlock the dentry lock,
it was requesting the inode lock forming the deadlock expectedly.

Fix:
unlock dentry lock first before the requesting inode lock in
ocfs2_do_drop_dentry_lock.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index e2e05a1..19a7d6c 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -369,9 +369,9 @@ out_attach:
 static void ocfs2_drop_dentry_lock(struct ocfs2_super *osb,
 				   struct ocfs2_dentry_lock *dl)
 {
-	iput(dl->dl_inode);
 	ocfs2_simple_drop_lockres(osb, &dl->dl_lockres);
 	ocfs2_lock_res_free(&dl->dl_lockres);
+	iput(dl->dl_inode);
 	kfree(dl);
 }
 
-- 
1.8.3.1
