From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 30 Jan 2009 13:42:31 -0800
Subject: [Ocfs2-devel] [PATCH 5/7] ocfs2: Increase max links count
In-Reply-To: <1233351753-14640-1-git-send-email-mfasheh@suse.com>
References: <1233351753-14640-1-git-send-email-mfasheh@suse.com>
Message-ID: <1233351753-14640-6-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Since we've now got a directory format capable of handling a large number of
entries, we can increase the maximum link count supported. This only gets
increased if the directory indexing feature is turned on.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/inode.c    |    6 +++---
 fs/ocfs2/namei.c    |   44 ++++++++++++++++++++++----------------------
 fs/ocfs2/ocfs2.h    |   37 +++++++++++++++++++++++++++++++++++++
 fs/ocfs2/ocfs2_fs.h |    4 +++-
 4 files changed, 65 insertions(+), 26 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index d273c4a..f1f77b2 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -276,7 +276,7 @@ void ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 		     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 		     (unsigned long long)le64_to_cpu(fe->i_blkno));
 
-	inode->i_nlink = le16_to_cpu(fe->i_links_count);
+	inode->i_nlink = ocfs2_read_links_count(fe);
 
 	if (fe->i_flags & cpu_to_le32(OCFS2_SYSTEM_FL)) {
 		OCFS2_I(inode)->ip_flags |= OCFS2_INODE_SYSTEM_FILE;
@@ -1215,7 +1215,7 @@ int ocfs2_mark_inode_dirty(handle_t *handle,
 	spin_unlock(&OCFS2_I(inode)->ip_lock);
 
 	fe->i_size = cpu_to_le64(i_size_read(inode));
-	fe->i_links_count = cpu_to_le16(inode->i_nlink);
+	ocfs2_set_links_count(fe, inode->i_nlink);
 	fe->i_uid = cpu_to_le32(inode->i_uid);
 	fe->i_gid = cpu_to_le32(inode->i_gid);
 	fe->i_mode = cpu_to_le16(inode->i_mode);
@@ -1252,7 +1252,7 @@ void ocfs2_refresh_inode(struct inode *inode,
 	OCFS2_I(inode)->ip_dyn_features = le16_to_cpu(fe->i_dyn_features);
 	ocfs2_set_inode_flags(inode);
 	i_size_write(inode, le64_to_cpu(fe->i_size));
-	inode->i_nlink = le16_to_cpu(fe->i_links_count);
+	inode->i_nlink = ocfs2_read_links_count(fe);
 	inode->i_uid = le32_to_cpu(fe->i_uid);
 	inode->i_gid = le32_to_cpu(fe->i_gid);
 	inode->i_mode = le16_to_cpu(fe->i_mode);
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 9b198ec..e37a37c 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -255,13 +255,13 @@ static int ocfs2_mknod(struct inode *dir,
 		return status;
 	}
 
-	if (S_ISDIR(mode) && (dir->i_nlink >= OCFS2_LINK_MAX)) {
+	if (S_ISDIR(mode) && (dir->i_nlink >= ocfs2_link_max(osb))) {
 		status = -EMLINK;
 		goto leave;
 	}
 
 	dirfe = (struct ocfs2_dinode *) parent_fe_bh->b_data;
-	if (!dirfe->i_links_count) {
+	if (!ocfs2_read_links_count(dirfe)) {
 		/* can't make a file in a deleted directory. */
 		status = -ENOENT;
 		goto leave;
@@ -381,7 +381,7 @@ static int ocfs2_mknod(struct inode *dir,
 			mlog_errno(status);
 			goto leave;
 		}
-		le16_add_cpu(&dirfe->i_links_count, 1);
+		ocfs2_add_links_count(dirfe, 1);
 		status = ocfs2_journal_dirty(handle, parent_fe_bh);
 		if (status < 0) {
 			mlog_errno(status);
@@ -529,7 +529,8 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	fe->i_mode = cpu_to_le16(inode->i_mode);
 	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
 		fe->id1.dev1.i_rdev = cpu_to_le64(huge_encode_dev(dev));
-	fe->i_links_count = cpu_to_le16(inode->i_nlink);
+
+	ocfs2_set_links_count(fe, inode->i_nlink);
 
 	fe->i_last_eb_blk = 0;
 	strcpy(fe->i_signature, OCFS2_INODE_SIGNATURE);
@@ -667,7 +668,7 @@ static int ocfs2_link(struct dentry *old_dentry,
 	}
 
 	fe = (struct ocfs2_dinode *) fe_bh->b_data;
-	if (le16_to_cpu(fe->i_links_count) >= OCFS2_LINK_MAX) {
+	if (ocfs2_read_links_count(fe) >= ocfs2_link_max(osb)) {
 		err = -EMLINK;
 		goto out_unlock_inode;
 	}
@@ -689,13 +690,13 @@ static int ocfs2_link(struct dentry *old_dentry,
 
 	inc_nlink(inode);
 	inode->i_ctime = CURRENT_TIME;
-	fe->i_links_count = cpu_to_le16(inode->i_nlink);
+	ocfs2_set_links_count(fe, inode->i_nlink);
 	fe->i_ctime = cpu_to_le64(inode->i_ctime.tv_sec);
 	fe->i_ctime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
 
 	err = ocfs2_journal_dirty(handle, fe_bh);
 	if (err < 0) {
-		le16_add_cpu(&fe->i_links_count, -1);
+		ocfs2_add_links_count(fe, -1);
 		drop_nlink(inode);
 		mlog_errno(err);
 		goto out_commit;
@@ -705,7 +706,7 @@ static int ocfs2_link(struct dentry *old_dentry,
 			      OCFS2_I(inode)->ip_blkno,
 			      parent_fe_bh, &lookup);
 	if (err) {
-		le16_add_cpu(&fe->i_links_count, -1);
+		ocfs2_add_links_count(fe, -1);
 		drop_nlink(inode);
 		mlog_errno(err);
 		goto out_commit;
@@ -894,7 +895,7 @@ static int ocfs2_unlink(struct inode *dir,
 	if (S_ISDIR(inode->i_mode))
 		drop_nlink(inode);
 	drop_nlink(inode);
-	fe->i_links_count = cpu_to_le16(inode->i_nlink);
+	ocfs2_set_links_count(fe, inode->i_nlink);
 
 	status = ocfs2_journal_dirty(handle, fe_bh);
 	if (status < 0) {
@@ -1138,7 +1139,7 @@ static int ocfs2_rename(struct inode *old_dir,
 		}
 
 		if (!new_inode && new_dir != old_dir &&
-		    new_dir->i_nlink >= OCFS2_LINK_MAX) {
+		    new_dir->i_nlink >= ocfs2_link_max(osb)) {
 			status = -EMLINK;
 			goto bail;
 		}
@@ -1292,7 +1293,7 @@ static int ocfs2_rename(struct inode *old_dir,
 		}
 
 		if (S_ISDIR(new_inode->i_mode) ||
-		    (newfe->i_links_count == cpu_to_le16(1))){
+		    (ocfs2_read_links_count(newfe) == cpu_to_le16(1))) {
 			status = ocfs2_orphan_add(osb, handle, new_inode,
 						  newfe, orphan_name,
 						  &orphan_insert, orphan_dir);
@@ -1312,9 +1313,9 @@ static int ocfs2_rename(struct inode *old_dir,
 		new_dir->i_version++;
 
 		if (S_ISDIR(new_inode->i_mode))
-			newfe->i_links_count = 0;
+			ocfs2_set_links_count(newfe, 0);
 		else
-			le16_add_cpu(&newfe->i_links_count, -1);
+			ocfs2_add_links_count(newfe, -1);
 
 		status = ocfs2_journal_dirty(handle, newfe_bh);
 		if (status < 0) {
@@ -1408,14 +1409,13 @@ static int ocfs2_rename(struct inode *old_dir,
 		} else {
 			struct ocfs2_dinode *fe;
 			status = ocfs2_journal_access_di(handle, old_dir,
-							 old_dir_bh,
-							 OCFS2_JOURNAL_ACCESS_WRITE);
+						      old_dir_bh,
+						      OCFS2_JOURNAL_ACCESS_WRITE);
 			fe = (struct ocfs2_dinode *) old_dir_bh->b_data;
-			fe->i_links_count = cpu_to_le16(old_dir->i_nlink);
+			ocfs2_set_links_count(fe, old_dir->i_nlink);
 			status = ocfs2_journal_dirty(handle, old_dir_bh);
 		}
 	}
-
 	ocfs2_dentry_move(old_dentry, new_dentry, old_dir, new_dir);
 	status = 0;
 bail:
@@ -1613,7 +1613,7 @@ static int ocfs2_symlink(struct inode *dir,
 	}
 
 	dirfe = (struct ocfs2_dinode *) parent_fe_bh->b_data;
-	if (!dirfe->i_links_count) {
+	if (!ocfs2_read_links_count(dirfe)) {
 		/* can't make a file in a deleted directory. */
 		status = -ENOENT;
 		goto bail;
@@ -1931,8 +1931,8 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 	 * underneath us... */
 	orphan_fe = (struct ocfs2_dinode *) orphan_dir_bh->b_data;
 	if (S_ISDIR(inode->i_mode))
-		le16_add_cpu(&orphan_fe->i_links_count, 1);
-	orphan_dir_inode->i_nlink = le16_to_cpu(orphan_fe->i_links_count);
+		ocfs2_add_links_count(orphan_fe, 1);
+	orphan_dir_inode->i_nlink = ocfs2_read_links_count(orphan_fe);
 
 	status = ocfs2_journal_dirty(handle, orphan_dir_bh);
 	if (status < 0) {
@@ -2015,8 +2015,8 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 	/* do the i_nlink dance! :) */
 	orphan_fe = (struct ocfs2_dinode *) orphan_dir_bh->b_data;
 	if (S_ISDIR(inode->i_mode))
-		le16_add_cpu(&orphan_fe->i_links_count, -1);
-	orphan_dir_inode->i_nlink = le16_to_cpu(orphan_fe->i_links_count);
+		ocfs2_add_links_count(orphan_fe, -1);
+	orphan_dir_inode->i_nlink = ocfs2_read_links_count(orphan_fe);
 
 	status = ocfs2_journal_dirty(handle, orphan_dir_bh);
 	if (status < 0) {
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 0b05fc8..b8aab2d 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -403,6 +403,43 @@ static inline int ocfs2_supports_indexed_dirs(struct ocfs2_super *osb)
 	return 0;
 }
 
+static inline unsigned int ocfs2_link_max(struct ocfs2_super *osb)
+{
+	if (ocfs2_supports_indexed_dirs(osb))
+		return OCFS2_DX_LINK_MAX;
+	return OCFS2_LINK_MAX;
+}
+
+static inline unsigned int ocfs2_read_links_count(struct ocfs2_dinode *di)
+{
+	u32 nlink = le16_to_cpu(di->i_links_count);
+	u32 hi = le16_to_cpu(di->i_links_count_hi);
+
+	nlink |= (hi << OCFS2_LINKS_HI_SHIFT);
+
+	return nlink;
+}
+
+static inline void ocfs2_set_links_count(struct ocfs2_dinode *di, u32 nlink)
+{
+	u16 lo, hi;
+
+	lo = nlink;
+	hi = nlink >> OCFS2_LINKS_HI_SHIFT;
+
+	di->i_links_count = cpu_to_le16(lo);
+	di->i_links_count_hi = cpu_to_le16(hi);
+}
+
+static inline void ocfs2_add_links_count(struct ocfs2_dinode *di, int n)
+{
+	u32 links = ocfs2_read_links_count(di);
+
+	links += n;
+
+	ocfs2_set_links_count(di, links);
+}
+
 /* set / clear functions because cluster events can make these happen
  * in parallel so we want the transitions to be atomic. this also
  * means that any future flags osb_flags must be protected by spinlock
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 5d45bcf..136f843 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -419,6 +419,8 @@ static struct ocfs2_system_inode_info ocfs2_system_inodes[NUM_SYSTEM_INODES] = {
 #define OCFS2_DIR_MIN_REC_LEN	OCFS2_DIR_REC_LEN(1)
 
 #define OCFS2_LINK_MAX		32000
+#define	OCFS2_DX_LINK_MAX	((1U << 31) - 1U)
+#define	OCFS2_LINKS_HI_SHIFT	16
 
 #define S_SHIFT			12
 static unsigned char ocfs2_type_by_mode[S_IFMT >> S_SHIFT] = {
@@ -686,7 +688,7 @@ struct ocfs2_dinode {
 					   belongs to */
 	__le16 i_suballoc_bit;		/* Bit offset in suballocator
 					   block group */
-/*10*/	__le16 i_reserved0;
+/*10*/	__le16 i_links_count_hi;	/* High 16 bits of links count */
 	__le16 i_xattr_inline_size;
 	__le32 i_clusters;		/* Cluster count */
 	__le32 i_uid;			/* Owner UID */
-- 
1.5.6
