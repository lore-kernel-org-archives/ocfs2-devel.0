From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 20 Apr 2009 21:34:18 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Add missing iput() during error
	handling in ocfs2_dentry_attach_lock()
Message-ID: <1240288458-14162-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_dentry_attach_lock(), if unable to get the dentry lock(), we need to
call iput(inode) because a failure here means no d_instantiate(), which means
the normally matching iput() will not be called during dput(dentry).

This patch fixes the oops that accompanies the following message:
(3996,1):dlm_empty_lockres:2708 ERROR: lockres W00000000000000000a1046b06a4382 still has local locks!
kernel BUG in dlm_empty_lockres at /rpmbuild/smushran/BUILD/ocfs2-1.4.2/fs/ocfs2/dlm/dlmmaster.c:2709!

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dcache.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index 7d60448..b574431 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -290,6 +290,21 @@ out_attach:
 	else
 		mlog_errno(ret);
 
+	/*
+	 * In case of error, manually free the allocation and do the iput().
+	 * We need to do this because error here means no d_instantiate(),
+	 * which means iput() will not be called during dput(dentry).
+	 */
+	if (ret < 0 && !alias) {
+		ocfs2_lock_res_free(&dl->dl_lockres);
+		BUG_ON(dl->dl_count != 1);
+		spin_lock(&dentry_attach_lock);
+		dentry->d_fsdata = NULL;
+		spin_unlock(&dentry_attach_lock);
+		kfree(dl);
+		iput(inode);
+	}
+
 	dput(alias);
 
 	return ret;
-- 
1.5.6.3
