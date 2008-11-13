From: Joel Becker <joel.becker@oracle.com>
Date: Thu, 13 Nov 2008 14:49:13 -0800
Subject: [Ocfs2-devel] [PATCH 03/11] ocfs2: Consolidate validation of group
	descriptors.
In-Reply-To: <1226616561-29942-1-git-send-email-joel.becker@oracle.com>
References: <1226616561-29942-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1226616561-29942-4-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently the validation of group descriptors is directly duplicated so
that one version can error the filesystem and the other (resize) can
just report the problem.  Consolidate to one function that takes a
boolean.  Wrap that function with the old call for the old users.

This is in preparation for lifting the read+validate step into a
single function.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/resize.c   |   40 +++++----------------------
 fs/ocfs2/suballoc.c |   74 +++++++++++++++++++++++++++++---------------------
 fs/ocfs2/suballoc.h |   20 +++++++++++--
 3 files changed, 68 insertions(+), 66 deletions(-)

diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 739d452..a2de32a 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -396,41 +396,16 @@ static int ocfs2_check_new_group(struct inode *inode,
 				 struct buffer_head *group_bh)
 {
 	int ret;
-	struct ocfs2_group_desc *gd;
+	struct ocfs2_group_desc *gd =
+		(struct ocfs2_group_desc *)group_bh->b_data;
 	u16 cl_bpc = le16_to_cpu(di->id2.i_chain.cl_bpc);
-	unsigned int max_bits = le16_to_cpu(di->id2.i_chain.cl_cpg) *
-				le16_to_cpu(di->id2.i_chain.cl_bpc);
 
+	ret = ocfs2_validate_group_descriptor(inode->i_sb, di, gd, 1);
+	if (ret)
+		goto out;
 
-	gd = (struct ocfs2_group_desc *)group_bh->b_data;
-
-	ret = -EIO;
-	if (!OCFS2_IS_VALID_GROUP_DESC(gd))
-		mlog(ML_ERROR, "Group descriptor # %llu isn't valid.\n",
-		     (unsigned long long)le64_to_cpu(gd->bg_blkno));
-	else if (di->i_blkno != gd->bg_parent_dinode)
-		mlog(ML_ERROR, "Group descriptor # %llu has bad parent "
-		     "pointer (%llu, expected %llu)\n",
-		     (unsigned long long)le64_to_cpu(gd->bg_blkno),
-		     (unsigned long long)le64_to_cpu(gd->bg_parent_dinode),
-		     (unsigned long long)le64_to_cpu(di->i_blkno));
-	else if (le16_to_cpu(gd->bg_bits) > max_bits)
-		mlog(ML_ERROR, "Group descriptor # %llu has bit count of %u\n",
-		     (unsigned long long)le64_to_cpu(gd->bg_blkno),
-		     le16_to_cpu(gd->bg_bits));
-	else if (le16_to_cpu(gd->bg_free_bits_count) > le16_to_cpu(gd->bg_bits))
-		mlog(ML_ERROR, "Group descriptor # %llu has bit count %u but "
-		     "claims that %u are free\n",
-		     (unsigned long long)le64_to_cpu(gd->bg_blkno),
-		     le16_to_cpu(gd->bg_bits),
-		     le16_to_cpu(gd->bg_free_bits_count));
-	else if (le16_to_cpu(gd->bg_bits) > (8 * le16_to_cpu(gd->bg_size)))
-		mlog(ML_ERROR, "Group descriptor # %llu has bit count %u but "
-		     "max bitmap bits of %u\n",
-		     (unsigned long long)le64_to_cpu(gd->bg_blkno),
-		     le16_to_cpu(gd->bg_bits),
-		     8 * le16_to_cpu(gd->bg_size));
-	else if (le16_to_cpu(gd->bg_chain) != input->chain)
+	ret = -EINVAL;
+	if (le16_to_cpu(gd->bg_chain) != input->chain)
 		mlog(ML_ERROR, "Group descriptor # %llu has bad chain %u "
 		     "while input has %u set.\n",
 		     (unsigned long long)le64_to_cpu(gd->bg_blkno),
@@ -449,6 +424,7 @@ static int ocfs2_check_new_group(struct inode *inode,
 	else
 		ret = 0;
 
+out:
 	return ret;
 }
 
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 95d432b..ddba97d 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -146,59 +146,71 @@ static u32 ocfs2_bits_per_group(struct ocfs2_chain_list *cl)
 }
 
 /* somewhat more expensive than our other checks, so use sparingly. */
-int ocfs2_check_group_descriptor(struct super_block *sb,
-				 struct ocfs2_dinode *di,
-				 struct ocfs2_group_desc *gd)
+int ocfs2_validate_group_descriptor(struct super_block *sb,
+				    struct ocfs2_dinode *di,
+				    struct ocfs2_group_desc *gd,
+				    int clean_error)
 {
 	unsigned int max_bits;
 
+#define do_error(fmt, ...)						\
+	do{								\
+		if (clean_error)					\
+			mlog(ML_ERROR, fmt "\n", ##__VA_ARGS__);	\
+		else							\
+			ocfs2_error(sb, fmt, ##__VA_ARGS__);		\
+	} while (0)
+
 	if (!OCFS2_IS_VALID_GROUP_DESC(gd)) {
-		OCFS2_RO_ON_INVALID_GROUP_DESC(sb, gd);
-		return -EIO;
+		do_error("Group Descriptor #%llu has bad signature %.*s",
+			 (unsigned long long)le64_to_cpu(gd->bg_blkno), 7,
+			 gd->bg_signature);
+		return -EINVAL;
 	}
 
 	if (di->i_blkno != gd->bg_parent_dinode) {
-		ocfs2_error(sb, "Group descriptor # %llu has bad parent "
-			    "pointer (%llu, expected %llu)",
-			    (unsigned long long)le64_to_cpu(gd->bg_blkno),
-			    (unsigned long long)le64_to_cpu(gd->bg_parent_dinode),
-			    (unsigned long long)le64_to_cpu(di->i_blkno));
-		return -EIO;
+		do_error("Group descriptor # %llu has bad parent "
+			 "pointer (%llu, expected %llu)",
+			 (unsigned long long)le64_to_cpu(gd->bg_blkno),
+			 (unsigned long long)le64_to_cpu(gd->bg_parent_dinode),
+			 (unsigned long long)le64_to_cpu(di->i_blkno));
+		return -EINVAL;
 	}
 
 	max_bits = le16_to_cpu(di->id2.i_chain.cl_cpg) * le16_to_cpu(di->id2.i_chain.cl_bpc);
 	if (le16_to_cpu(gd->bg_bits) > max_bits) {
-		ocfs2_error(sb, "Group descriptor # %llu has bit count of %u",
-			    (unsigned long long)le64_to_cpu(gd->bg_blkno),
-			    le16_to_cpu(gd->bg_bits));
-		return -EIO;
+		do_error("Group descriptor # %llu has bit count of %u",
+			 (unsigned long long)le64_to_cpu(gd->bg_blkno),
+			 le16_to_cpu(gd->bg_bits));
+		return -EINVAL;
 	}
 
 	if (le16_to_cpu(gd->bg_chain) >=
 	    le16_to_cpu(di->id2.i_chain.cl_next_free_rec)) {
-		ocfs2_error(sb, "Group descriptor # %llu has bad chain %u",
-			    (unsigned long long)le64_to_cpu(gd->bg_blkno),
-			    le16_to_cpu(gd->bg_chain));
-		return -EIO;
+		do_error("Group descriptor # %llu has bad chain %u",
+			 (unsigned long long)le64_to_cpu(gd->bg_blkno),
+			 le16_to_cpu(gd->bg_chain));
+		return -EINVAL;
 	}
 
 	if (le16_to_cpu(gd->bg_free_bits_count) > le16_to_cpu(gd->bg_bits)) {
-		ocfs2_error(sb, "Group descriptor # %llu has bit count %u but "
-			    "claims that %u are free",
-			    (unsigned long long)le64_to_cpu(gd->bg_blkno),
-			    le16_to_cpu(gd->bg_bits),
-			    le16_to_cpu(gd->bg_free_bits_count));
-		return -EIO;
+		do_error("Group descriptor # %llu has bit count %u but "
+			 "claims that %u are free",
+			 (unsigned long long)le64_to_cpu(gd->bg_blkno),
+			 le16_to_cpu(gd->bg_bits),
+			 le16_to_cpu(gd->bg_free_bits_count));
+		return -EINVAL;
 	}
 
 	if (le16_to_cpu(gd->bg_bits) > (8 * le16_to_cpu(gd->bg_size))) {
-		ocfs2_error(sb, "Group descriptor # %llu has bit count %u but "
-			    "max bitmap bits of %u",
-			    (unsigned long long)le64_to_cpu(gd->bg_blkno),
-			    le16_to_cpu(gd->bg_bits),
-			    8 * le16_to_cpu(gd->bg_size));
-		return -EIO;
+		do_error("Group descriptor # %llu has bit count %u but "
+			 "max bitmap bits of %u",
+			 (unsigned long long)le64_to_cpu(gd->bg_blkno),
+			 le16_to_cpu(gd->bg_bits),
+			 8 * le16_to_cpu(gd->bg_size));
+		return -EINVAL;
 	}
+#undef do_error
 
 	return 0;
 }
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index 4df159d..7adfcc4 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -165,9 +165,23 @@ void ocfs2_free_ac_resource(struct ocfs2_alloc_context *ac);
 u64 ocfs2_which_cluster_group(struct inode *inode, u32 cluster);
 
 /* somewhat more expensive than our other checks, so use sparingly. */
-int ocfs2_check_group_descriptor(struct super_block *sb,
-				 struct ocfs2_dinode *di,
-				 struct ocfs2_group_desc *gd);
+/*
+ * By default, ocfs2_validate_group_descriptor() calls ocfs2_error() when it
+ * finds a problem.  A caller that wants to check a group descriptor
+ * without going readonly passes a nonzero clean_error.  This is only
+ * resize, really.
+ */
+int ocfs2_validate_group_descriptor(struct super_block *sb,
+				    struct ocfs2_dinode *di,
+				    struct ocfs2_group_desc *gd,
+				    int clean_error);
+static inline int ocfs2_check_group_descriptor(struct super_block *sb,
+					       struct ocfs2_dinode *di,
+					       struct ocfs2_group_desc *gd)
+{
+	return ocfs2_validate_group_descriptor(sb, di, gd, 0);
+}
+
 int ocfs2_lock_allocators(struct inode *inode, struct ocfs2_extent_tree *et,
 			  u32 clusters_to_add, u32 extents_to_split,
 			  struct ocfs2_alloc_context **data_ac,
-- 
1.5.6.5
