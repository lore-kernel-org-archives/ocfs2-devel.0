From: Ashish Samant <ashish.samant@oracle.com>
Date: Fri, 30 Mar 2018 10:42:17 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Take inode cluster lock before moving
	reflinked inode from orphan dir
Message-ID: <1522431737-4134-1-git-send-email-ashish.samant@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

While reflinking an inode, we create a new inode in orphan directory, then
take EX lock on it, reflink the original inode to orphan inode and release
EX lock. Once the lock is released another node might request it in PR mode
which causes downconvert of the lock to PR mode.

Later we attempt to initialize security acl for the orphan inode and move
it to the reflink destination. However, while doing this we dont take EX
lock on the inode. So effectively, we are doing this and accessing the
journal for this inode while holding PR lock. While accessing the journal,
we make

ci->ci_last_trans = journal->j_trans_id

At this point, if there is another downconvert request on this inode from
another node (PR->NL), we will trip on the following condition in
ocfs2_ci_checkpointed()

BUG_ON(lockres->l_level != DLM_LOCK_EX && !checkpointed);

because we hold the lock in PR mode and journal->j_trans_id is not greater
than ci_last_trans for the inode.

Fix this by taking orphan inode cluster lock in EX mode before
initializing security and moving orphan inode to reflink destination.
Use the __tracker variant while taking inode lock to avoid recursive
locking in the ocfs2_init_security_and_acl() call chain.

Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
---
 fs/ocfs2/refcounttree.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index ab156e3..1b1283f 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4250,10 +4250,11 @@ static int __ocfs2_reflink(struct dentry *old_dentry,
 static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
 			 struct dentry *new_dentry, bool preserve)
 {
-	int error;
+	int error, had_lock;
 	struct inode *inode = d_inode(old_dentry);
 	struct buffer_head *old_bh = NULL;
 	struct inode *new_orphan_inode = NULL;
+	struct ocfs2_lock_holder oh;
 
 	if (!ocfs2_refcount_tree(OCFS2_SB(inode->i_sb)))
 		return -EOPNOTSUPP;
@@ -4295,6 +4296,14 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
 		goto out;
 	}
 
+	had_lock = ocfs2_inode_lock_tracker(new_orphan_inode, NULL, 1,
+					    &oh);
+	if (had_lock < 0) {
+		error = had_lock;
+		mlog_errno(error);
+		goto out;
+	}
+
 	/* If the security isn't preserved, we need to re-initialize them. */
 	if (!preserve) {
 		error = ocfs2_init_security_and_acl(dir, new_orphan_inode,
@@ -4302,14 +4311,15 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
 		if (error)
 			mlog_errno(error);
 	}
-out:
 	if (!error) {
 		error = ocfs2_mv_orphaned_inode_to_new(dir, new_orphan_inode,
 						       new_dentry);
 		if (error)
 			mlog_errno(error);
 	}
+	ocfs2_inode_unlock_tracker(new_orphan_inode, 1, &oh, had_lock);
 
+out:
 	if (new_orphan_inode) {
 		/*
 		 * We need to open_unlock the inode no matter whether we
-- 
1.9.1
