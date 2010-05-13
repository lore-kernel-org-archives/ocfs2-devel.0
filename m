From: Jan Kara <jack@suse.cz>
Date: Thu, 13 May 2010 21:58:03 +0200
Subject: [Ocfs2-devel] [PATCH 7/7] ocfs2: Use __dquot_transfer to avoid lock
	inversion
In-Reply-To: <1273780683-3638-1-git-send-email-jack@suse.cz>
References: <1273780683-3638-1-git-send-email-jack@suse.cz>
Message-ID: <1273780683-3638-8-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

dquot_transfer() acquires own references to dquots via dqget(). Thus it waits
for dq_lock which creates a lock inversion because dq_lock ranks above
transaction start but transaction is already started in ocfs2_setattr(). Fix
the problem by passing own references directly to __dquot_transfer.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/file.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index e20ba9f..312b8f5 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -946,9 +946,8 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 	struct buffer_head *bh = NULL;
 	handle_t *handle = NULL;
-	int qtype;
-	struct dquot *transfer_from[MAXQUOTAS] = { };
 	struct dquot *transfer_to[MAXQUOTAS] = { };
+	int qtype;
 
 	mlog_entry("(0x%p, '%.*s')\n", dentry,
 	           dentry->d_name.len, dentry->d_name.name);
@@ -1032,9 +1031,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 		    OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
 			transfer_to[USRQUOTA] = dqget(sb, attr->ia_uid,
 						      USRQUOTA);
-			transfer_from[USRQUOTA] = dqget(sb, inode->i_uid,
-							USRQUOTA);
-			if (!transfer_to[USRQUOTA] || !transfer_from[USRQUOTA]) {
+			if (!transfer_to[USRQUOTA]) {
 				status = -ESRCH;
 				goto bail_unlock;
 			}
@@ -1044,9 +1041,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 		    OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)) {
 			transfer_to[GRPQUOTA] = dqget(sb, attr->ia_gid,
 						      GRPQUOTA);
-			transfer_from[GRPQUOTA] = dqget(sb, inode->i_gid,
-							GRPQUOTA);
-			if (!transfer_to[GRPQUOTA] || !transfer_from[GRPQUOTA]) {
+			if (!transfer_to[GRPQUOTA]) {
 				status = -ESRCH;
 				goto bail_unlock;
 			}
@@ -1058,7 +1053,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 			mlog_errno(status);
 			goto bail_unlock;
 		}
-		status = dquot_transfer(inode, attr);
+		status = __dquot_transfer(inode, transfer_to);
 		if (status < 0)
 			goto bail_commit;
 	} else {
@@ -1098,10 +1093,8 @@ bail:
 	brelse(bh);
 
 	/* Release quota pointers in case we acquired them */
-	for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+	for (qtype = 0; qtype < MAXQUOTAS; qtype++)
 		dqput(transfer_to[qtype]);
-		dqput(transfer_from[qtype]);
-	}
 
 	if (!status && attr->ia_valid & ATTR_MODE) {
 		status = ocfs2_acl_chmod(inode);
-- 
1.6.4.2
