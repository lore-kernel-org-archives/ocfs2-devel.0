From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri,  2 Sep 2011 10:50:24 +0800
Subject: [Ocfs2-devel] [PATCH] unlock open_lock within inode_lock -V2
Message-ID: <201109020250.p822oMSb001368@acsmt358.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There is a race between 2(+) nodes that calls iput_final() on same inode.
time sequence is like the following. The result is neither of the 2(+) node
does real inode deletion work and the unlinked inode is left in orphandir.

Problem is triggered when it is running as this in time order:
-------------------------------------------------------------------
node A                                  node B

open_lock PR

                                        open_LOCK PR

.......

                                         .......

inode_lock EX
try open_lock EX -->cant grant(B has PR)
ignore the deletion
inode_unlock EX

                                        #in ocfs2_delete_inode()
                                        inode_lock EX
                                        #in ocfs2_query_inode_wipe
                                        try open_lock EX -->can't grant(A has PR)
                                        ignore the deletion
                                        inode_unlock EX

open_unlock EX
drop open_lock

                                         #in ocfs2_clear_inode()
                                         open_unlock EX
-------------------------------------------------------------------

The test case to reproduce the problem:

in a three-node cluster,
1) node A copies kernel tree to ocfs2 volume
2) node B and C keeps "ls -R" the tree which is under copying
3) after the copy finished, remove the whole tree by "rm -rf xxx" on node A while
   Node B and C are still "ls -R"ing.
4) stop the "ls -R" on node B/C when "rm" on node A is finished.
5) umount all three nodes.
There are entries left in orphandirs(could for all slots).
Actually copying whole is time consuming, I can hit the problem when copied part
of the kernel tree.

I confirmed that the cause is "remotely opened" by printing logs.
log showed that all the three nodes think "there is other node(s) still opening
the inode", so they don't do dinode deletion.

Fix:
The fix is to force dlm_unlock earlier on open_lock within inode_lock. see
comment embedded in patch.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/inode.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index b4c8bb6..961b0f5 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1052,6 +1052,22 @@ static void ocfs2_delete_inode(struct inode *inode)
 	OCFS2_I(inode)->ip_flags |= OCFS2_INODE_DELETED;
 
 bail_unlock_inode:
+	/*
+	 * since we don't take care of deleting the on disk inode any longer
+	 * from now on, we must release the open_lock(dlm unlock) immediately
+	 * within inode_lock. Otherwise, trying open_lock for EX from other node
+	 * can fail if it comes before we released PR on open_lock later,
+	 * so that both/all nodes think other node(s) is/are opening the inode
+	 * thus neither/none of them do real dinode deletion.
+	 *
+	 * ocfs2_open_unlock/ocfs2_simple_drop_lockres against open_lock will be
+	 * called again soon from in ocfs2_clear_inode/ocfs2_drop_inode_locks
+	 * repectively. no problem found to call those two functions against
+	 * open_lock twice.
+	 */
+	ocfs2_open_unlock(inode);
+	ocfs2_simple_drop_lockres(OCFS2_SB(inode->i_sb),
+				  &OCFS2_I(inode)->ip_open_lockres);
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 
-- 
1.7.5.2
