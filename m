From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Tue,  5 Jan 2016 18:27:11 -0800
Subject: [Ocfs2-devel] [PATCH] revert to using ocfs2_acl_chmod to avoid
	inode cluster lock hang
Message-ID: <1452047231-30569-1-git-send-email-tariq.x.saeed@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Orabug: 21793017

commit 743b5f1434f5 ("ocfs2: take inode lock in ocfs2_iop_set/get_acl()")
introduced this issue.  ocfs2_setattr called by chmod command
holds cluster wide inode lock (Orabug 21685187) when calling
posix_acl_chmod. This latter function in turn calls ocfs2_iop_get_acl
and ocfs2_iop_set_acl.  These two are also called directly from vfs
layer for getfacl/setfacl commands and therefore acquire the cluster wide
inode lock. If a remote conversion request comes after the first inode
lock in ocfs2_setattr, OCFS2_LOCK_BLOCKED will be set in l_flags. This
will cause the second call to inode lock from the  ocfs2_iop_get_acl()
to block indefinetly.

To solve this, we need to use nolock version of getacl.  Since
nolock version of posix_acl_chmod does not exist, we restore a slightly
modified version of  ocfs2_acl_chmod, which was removed in
commit 702e5bc68ad2 ("ocfs2: use generic posix ACL infrastructure")
that uses nolock version of getacl.

Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
---
 fs/ocfs2/acl.c  |   25 +++++++++++++++++++++++++
 fs/ocfs2/acl.h  |    1 +
 fs/ocfs2/file.c |    4 ++--
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 0cdf497..0fbd18c 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -322,3 +322,28 @@ struct posix_acl *ocfs2_iop_get_acl(struct inode *inode, int type)
 	brelse(di_bh);
 	return acl;
 }
+
+int ocfs2_acl_chmod(struct inode *inode, struct buffer_head *bh)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct posix_acl *acl;
+	int ret;
+
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
+		return 0;
+
+	acl = ocfs2_get_acl_nolock(inode, ACL_TYPE_ACCESS, bh);
+	if (IS_ERR(acl) || !acl)
+		return PTR_ERR(acl);
+	ret = __posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
+	if (ret)
+		return ret;
+	ret = ocfs2_set_acl(NULL, inode, NULL, ACL_TYPE_ACCESS,
+			    acl, NULL, NULL);
+	posix_acl_release(acl);
+	return ret;
+}
+
diff --git a/fs/ocfs2/acl.h b/fs/ocfs2/acl.h
index 3fce68d..035e587 100644
--- a/fs/ocfs2/acl.h
+++ b/fs/ocfs2/acl.h
@@ -35,5 +35,6 @@ int ocfs2_set_acl(handle_t *handle,
 			 struct posix_acl *acl,
 			 struct ocfs2_alloc_context *meta_ac,
 			 struct ocfs2_alloc_context *data_ac);
+extern int ocfs2_acl_chmod(struct inode *, struct buffer_head *);
 
 #endif /* OCFS2_ACL_H */
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 0e5b451..77d30cb 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1268,20 +1268,20 @@ bail_unlock_rw:
 	if (size_change)
 		ocfs2_rw_unlock(inode, 1);
 bail:
-	brelse(bh);
 
 	/* Release quota pointers in case we acquired them */
 	for (qtype = 0; qtype < OCFS2_MAXQUOTAS; qtype++)
 		dqput(transfer_to[qtype]);
 
 	if (!status && attr->ia_valid & ATTR_MODE) {
-		status = posix_acl_chmod(inode, inode->i_mode);
+		status = ocfs2_acl_chmod(inode, bh);
 		if (status < 0)
 			mlog_errno(status);
 	}
 	if (inode_locked)
 		ocfs2_inode_unlock(inode, 1);
 
+	brelse(bh);
 	return status;
 }
 
-- 
1.7.1
