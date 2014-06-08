From: Ben Hutchings <ben@decadent.org.uk>
Date: Sun, 08 Jun 2014 23:26:35 +0100
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: Do not write error flag to user
 structure we cannot copy from/to
Message-ID: <1402266395.23860.39.camel@deadeye.wl.decadent.org.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If we failed to copy from the structure, writing back the flags leaks
31 bits of kernel memory (the rest of the ir_flags field).

In any case, if we cannot copy from/to the structure, why should we
expect putting just the flags to work?

Also make sure ocfs2_info_handle_freeinode() returns the right error
code if the copy_to_user() fails.

Compile-tested only.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Fixes: ddee5cdb70e6 ('Ocfs2: Add new OCFS2_IOC_INFO ioctl for ocfs2 v8.')
---
v2: no cc to stable

 fs/ocfs2/ioctl.c | 129 +++++++++++++++++++------------------------------------
 1 file changed, 43 insertions(+), 86 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 490229f..2e6bdd4 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -35,9 +35,8 @@
 		copy_to_user((typeof(a) __user *)b, &(a), sizeof(a))
 
 /*
- * This call is void because we are already reporting an error that may
- * be -EFAULT.  The error will be returned from the ioctl(2) call.  It's
- * just a best-effort to tell userspace that this request caused the error.
+ * This is just a best-effort to tell userspace that this request
+ * caused the error.
  */
 static inline void o2info_set_request_error(struct ocfs2_info_request *kreq,
 					struct ocfs2_info_request __user *req)
@@ -146,136 +145,105 @@ bail:
 int ocfs2_info_handle_blocksize(struct inode *inode,
 				struct ocfs2_info_request __user *req)
 {
-	int status = -EFAULT;
 	struct ocfs2_info_blocksize oib;
 
 	if (o2info_from_user(oib, req))
-		goto bail;
+		return -EFAULT;
 
 	oib.ib_blocksize = inode->i_sb->s_blocksize;
 
 	o2info_set_request_filled(&oib.ib_req);
 
 	if (o2info_to_user(oib, req))
-		goto bail;
-
-	status = 0;
-bail:
-	if (status)
-		o2info_set_request_error(&oib.ib_req, req);
+		return -EFAULT;
 
-	return status;
+	return 0;
 }
 
 int ocfs2_info_handle_clustersize(struct inode *inode,
 				  struct ocfs2_info_request __user *req)
 {
-	int status = -EFAULT;
 	struct ocfs2_info_clustersize oic;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	if (o2info_from_user(oic, req))
-		goto bail;
+		return -EFAULT;
 
 	oic.ic_clustersize = osb->s_clustersize;
 
 	o2info_set_request_filled(&oic.ic_req);
 
 	if (o2info_to_user(oic, req))
-		goto bail;
-
-	status = 0;
-bail:
-	if (status)
-		o2info_set_request_error(&oic.ic_req, req);
+		return -EFAULT;
 
-	return status;
+	return 0;
 }
 
 int ocfs2_info_handle_maxslots(struct inode *inode,
 			       struct ocfs2_info_request __user *req)
 {
-	int status = -EFAULT;
 	struct ocfs2_info_maxslots oim;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	if (o2info_from_user(oim, req))
-		goto bail;
+		return -EFAULT;
 
 	oim.im_max_slots = osb->max_slots;
 
 	o2info_set_request_filled(&oim.im_req);
 
 	if (o2info_to_user(oim, req))
-		goto bail;
+		return -EFAULT;
 
-	status = 0;
-bail:
-	if (status)
-		o2info_set_request_error(&oim.im_req, req);
-
-	return status;
+	return 0;
 }
 
 int ocfs2_info_handle_label(struct inode *inode,
 			    struct ocfs2_info_request __user *req)
 {
-	int status = -EFAULT;
 	struct ocfs2_info_label oil;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	if (o2info_from_user(oil, req))
-		goto bail;
+		return -EFAULT;
 
 	memcpy(oil.il_label, osb->vol_label, OCFS2_MAX_VOL_LABEL_LEN);
 
 	o2info_set_request_filled(&oil.il_req);
 
 	if (o2info_to_user(oil, req))
-		goto bail;
+		return -EFAULT;
 
-	status = 0;
-bail:
-	if (status)
-		o2info_set_request_error(&oil.il_req, req);
-
-	return status;
+	return 0;
 }
 
 int ocfs2_info_handle_uuid(struct inode *inode,
 			   struct ocfs2_info_request __user *req)
 {
-	int status = -EFAULT;
 	struct ocfs2_info_uuid oiu;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	if (o2info_from_user(oiu, req))
-		goto bail;
+		return -EFAULT;
 
 	memcpy(oiu.iu_uuid_str, osb->uuid_str, OCFS2_TEXT_UUID_LEN + 1);
 
 	o2info_set_request_filled(&oiu.iu_req);
 
 	if (o2info_to_user(oiu, req))
-		goto bail;
-
-	status = 0;
-bail:
-	if (status)
-		o2info_set_request_error(&oiu.iu_req, req);
+		return -EFAULT;
 
-	return status;
+	return 0;
 }
 
 int ocfs2_info_handle_fs_features(struct inode *inode,
 				  struct ocfs2_info_request __user *req)
 {
-	int status = -EFAULT;
 	struct ocfs2_info_fs_features oif;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	if (o2info_from_user(oif, req))
-		goto bail;
+		return -EFAULT;
 
 	oif.if_compat_features = osb->s_feature_compat;
 	oif.if_incompat_features = osb->s_feature_incompat;
@@ -284,39 +252,28 @@ int ocfs2_info_handle_fs_features(struct inode *inode,
 	o2info_set_request_filled(&oif.if_req);
 
 	if (o2info_to_user(oif, req))
-		goto bail;
+		return -EFAULT;
 
-	status = 0;
-bail:
-	if (status)
-		o2info_set_request_error(&oif.if_req, req);
-
-	return status;
+	return 0;
 }
 
 int ocfs2_info_handle_journal_size(struct inode *inode,
 				   struct ocfs2_info_request __user *req)
 {
-	int status = -EFAULT;
 	struct ocfs2_info_journal_size oij;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	if (o2info_from_user(oij, req))
-		goto bail;
+		return -EFAULT;
 
 	oij.ij_journal_size = i_size_read(osb->journal->j_inode);
 
 	o2info_set_request_filled(&oij.ij_req);
 
 	if (o2info_to_user(oij, req))
-		goto bail;
+		return -EFAULT;
 
-	status = 0;
-bail:
-	if (status)
-		o2info_set_request_error(&oij.ij_req, req);
-
-	return status;
+	return 0;
 }
 
 int ocfs2_info_scan_inode_alloc(struct ocfs2_super *osb,
@@ -372,7 +329,7 @@ int ocfs2_info_handle_freeinode(struct inode *inode,
 	u32 i;
 	u64 blkno = -1;
 	char namebuf[40];
-	int status = -EFAULT, type = INODE_ALLOC_SYSTEM_INODE;
+	int status, type = INODE_ALLOC_SYSTEM_INODE;
 	struct ocfs2_info_freeinode *oifi = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct inode *inode_alloc = NULL;
@@ -384,8 +341,10 @@ int ocfs2_info_handle_freeinode(struct inode *inode,
 		goto out_err;
 	}
 
-	if (o2info_from_user(*oifi, req))
-		goto bail;
+	if (o2info_from_user(*oifi, req)) {
+		status = -EFAULT;
+		goto out_free;
+	}
 
 	oifi->ifi_slotnum = osb->max_slots;
 
@@ -423,14 +382,16 @@ int ocfs2_info_handle_freeinode(struct inode *inode,
 
 	o2info_set_request_filled(&oifi->ifi_req);
 
-	if (o2info_to_user(*oifi, req))
-		goto bail;
+	if (o2info_to_user(*oifi, req)) {
+		status = -EFAULT;
+		goto out_free;
+	}
 
 	status = 0;
 bail:
 	if (status)
 		o2info_set_request_error(&oifi->ifi_req, req);
-
+out_free:
 	kfree(oifi);
 out_err:
 	return status;
@@ -657,7 +618,7 @@ int ocfs2_info_handle_freefrag(struct inode *inode,
 {
 	u64 blkno = -1;
 	char namebuf[40];
-	int status = -EFAULT, type = GLOBAL_BITMAP_SYSTEM_INODE;
+	int status, type = GLOBAL_BITMAP_SYSTEM_INODE;
 
 	struct ocfs2_info_freefrag *oiff;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
@@ -670,8 +631,10 @@ int ocfs2_info_handle_freefrag(struct inode *inode,
 		goto out_err;
 	}
 
-	if (o2info_from_user(*oiff, req))
-		goto bail;
+	if (o2info_from_user(*oiff, req)) {
+		status = -EFAULT;
+		goto out_free;
+	}
 	/*
 	 * chunksize from userspace should be power of 2.
 	 */
@@ -710,14 +673,14 @@ int ocfs2_info_handle_freefrag(struct inode *inode,
 
 	if (o2info_to_user(*oiff, req)) {
 		status = -EFAULT;
-		goto bail;
+		goto out_free;
 	}
 
 	status = 0;
 bail:
 	if (status)
 		o2info_set_request_error(&oiff->iff_req, req);
-
+out_free:
 	kfree(oiff);
 out_err:
 	return status;
@@ -726,23 +689,17 @@ out_err:
 int ocfs2_info_handle_unknown(struct inode *inode,
 			      struct ocfs2_info_request __user *req)
 {
-	int status = -EFAULT;
 	struct ocfs2_info_request oir;
 
 	if (o2info_from_user(oir, req))
-		goto bail;
+		return -EFAULT;
 
 	o2info_clear_request_filled(&oir);
 
 	if (o2info_to_user(oir, req))
-		goto bail;
+		return -EFAULT;
 
-	status = 0;
-bail:
-	if (status)
-		o2info_set_request_error(&oir, req);
-
-	return status;
+	return 0;
 }
 
 /*

-- 
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity.
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 828 bytes
Desc: This is a digitally signed message part
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20140608/205ad910/attachment.bin 
