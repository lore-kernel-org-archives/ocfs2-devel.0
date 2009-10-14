From: Jan Kara <jack@suse.cz>
Date: Wed, 14 Oct 2009 20:08:56 +0200
Subject: [Ocfs2-devel] [PATCH 2/5] Implement support for quota changes in
	libocfs2
In-Reply-To: <1255543739-23844-1-git-send-email-jack@suse.cz>
References: <1255543739-23844-1-git-send-email-jack@suse.cz>
Message-ID: <1255543739-23844-3-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Implement some common functions for changing quotas in libocfs2
so that they don't have to be reimplemented in several users.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/ocfs2/ocfs2.h |   16 ++++++
 libocfs2/quota.c      |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 143 insertions(+), 0 deletions(-)

diff --git a/include/ocfs2/ocfs2.h b/include/ocfs2/ocfs2.h
index d7be734..bf64fa0 100644
--- a/include/ocfs2/ocfs2.h
+++ b/include/ocfs2/ocfs2.h
@@ -685,6 +685,7 @@ int ocfs2_qtree_entry_unused(struct ocfs2_global_disk_dqblk *ddquot);
 errcode_t ocfs2_init_global_quota_file(ocfs2_filesys *fs, int type);
 errcode_t ocfs2_init_fs_quota_info(ocfs2_filesys *fs, int type);
 errcode_t ocfs2_read_global_quota_info(ocfs2_filesys *fs, int type);
+errcode_t ocfs2_load_fs_quota_info(ocfs2_filesys *fs);
 errcode_t ocfs2_write_global_quota_info(ocfs2_filesys *fs, int type);
 errcode_t ocfs2_write_dquot(ocfs2_filesys *fs, int type,
 			    ocfs2_cached_dquot *dquot);
@@ -702,9 +703,24 @@ errcode_t ocfs2_find_quota_hash(ocfs2_quota_hash *hash, qid_t id,
 				ocfs2_cached_dquot **dquotp);
 errcode_t ocfs2_find_create_quota_hash(ocfs2_quota_hash *hash, qid_t id,
 				       ocfs2_cached_dquot **dquotp);
+errcode_t ocfs2_find_read_quota_hash(ocfs2_filesys *fs, ocfs2_quota_hash *hash,
+				     int type, qid_t id,
+				     ocfs2_cached_dquot **dquotp);
 errcode_t ocfs2_compute_quota_usage(ocfs2_filesys *fs,
 				    ocfs2_quota_hash *usr_hash,
 				    ocfs2_quota_hash *grp_hash);
+errcode_t ocfs2_init_quota_change(ocfs2_filesys *fs,
+				  ocfs2_quota_hash **usrhash,
+				  ocfs2_quota_hash **grphash);
+errcode_t ocfs2_finish_quota_change(ocfs2_filesys *fs,
+				    ocfs2_quota_hash *usrhash,
+				    ocfs2_quota_hash *grphash);
+errcode_t ocfs2_apply_quota_change(ocfs2_filesys *fs,
+				   ocfs2_quota_hash *usrhash,
+				   ocfs2_quota_hash *grphash,
+				   uid_t uid, gid_t gid,
+				   int64_t space_change,
+				   int64_t inode_change);
 errcode_t ocfs2_iterate_quota_hash(ocfs2_quota_hash *hash,
 				   errcode_t (*f)(ocfs2_cached_dquot *, void *),
 				   void *data);
diff --git a/libocfs2/quota.c b/libocfs2/quota.c
index e36b12f..9e0ca33 100644
--- a/libocfs2/quota.c
+++ b/libocfs2/quota.c
@@ -229,6 +229,30 @@ errcode_t ocfs2_find_create_quota_hash(ocfs2_quota_hash *hash, qid_t id,
 	return 0;
 }
 
+errcode_t ocfs2_find_read_quota_hash(ocfs2_filesys *fs, ocfs2_quota_hash *hash,
+				     int type, qid_t id,
+				     ocfs2_cached_dquot **dquotp)
+{
+	errcode_t err;
+
+	err = ocfs2_find_quota_hash(hash, id, dquotp);
+	if (err)
+		return err;
+	if (*dquotp)
+		return 0;
+
+	err = ocfs2_read_dquot(fs, type, id, dquotp);
+	if (err)
+		return err;
+
+	err = ocfs2_insert_quota_hash(hash, *dquotp);
+	if (err) {
+		ocfs2_free(dquotp);
+		return err;
+	}
+	return 0;
+}
+
 errcode_t ocfs2_compute_quota_usage(ocfs2_filesys *fs,
 				    ocfs2_quota_hash *usr_hash,
 				    ocfs2_quota_hash *grp_hash)
@@ -296,6 +320,84 @@ out:
 	return err;
 }
 
+errcode_t ocfs2_init_quota_change(ocfs2_filesys *fs,
+				  ocfs2_quota_hash **usrhash,
+				  ocfs2_quota_hash **grphash)
+{
+	errcode_t err;
+
+	if (OCFS2_HAS_RO_COMPAT_FEATURE(OCFS2_RAW_SB(fs->fs_super),
+					OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
+		err = ocfs2_new_quota_hash(usrhash);
+		if (err)
+			return err;
+	}
+	if (OCFS2_HAS_RO_COMPAT_FEATURE(OCFS2_RAW_SB(fs->fs_super),
+					OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)) {
+		err = ocfs2_new_quota_hash(grphash);
+		if (err) {
+			ocfs2_free_quota_hash(*usrhash);
+			return err;
+		}
+	}
+	return 0;
+}
+
+errcode_t ocfs2_finish_quota_change(ocfs2_filesys *fs,
+				    ocfs2_quota_hash *usrhash,
+				    ocfs2_quota_hash *grphash)
+{
+	errcode_t ret = 0, err;
+
+	if (usrhash) {
+		err = ocfs2_write_release_dquots(fs, USRQUOTA, usrhash);
+		if (!ret)
+			ret = err;
+		err = ocfs2_free_quota_hash(usrhash);
+		if (!ret)
+			ret = err;
+	}
+	if (grphash) {
+		err = ocfs2_write_release_dquots(fs, GRPQUOTA, grphash);
+		if (!ret)
+			ret = err;
+		err = ocfs2_free_quota_hash(grphash);
+		if (!ret)
+			ret = err;
+	}
+
+	return ret;
+}
+
+errcode_t ocfs2_apply_quota_change(ocfs2_filesys *fs,
+				   ocfs2_quota_hash *usrhash,
+				   ocfs2_quota_hash *grphash,
+				   uid_t uid, gid_t gid,
+				   int64_t space_change,
+				   int64_t inode_change)
+{
+	ocfs2_cached_dquot *dquot;
+	errcode_t err;
+
+	if (usrhash) {
+		err = ocfs2_find_read_quota_hash(fs, usrhash, USRQUOTA, uid,
+						 &dquot);
+		if (err)
+			return err;
+		dquot->d_ddquot.dqb_curspace += space_change;
+		dquot->d_ddquot.dqb_curinodes += inode_change;
+	}
+	if (grphash) {
+		err = ocfs2_find_read_quota_hash(fs, grphash, GRPQUOTA, gid,
+						 &dquot);
+		if (err)
+			return err;
+		dquot->d_ddquot.dqb_curspace += space_change;
+		dquot->d_ddquot.dqb_curinodes += inode_change;
+	}
+	return 0;
+}
+
 errcode_t ocfs2_iterate_quota_hash(ocfs2_quota_hash *hash,
 				   errcode_t (*f)(ocfs2_cached_dquot *, void *),
 				   void *data)
@@ -614,6 +716,31 @@ bail:
 	return ret;
 }
 
+errcode_t ocfs2_load_fs_quota_info(ocfs2_filesys *fs)
+{
+	errcode_t err;
+
+	if (OCFS2_HAS_RO_COMPAT_FEATURE(OCFS2_RAW_SB(fs->fs_super),
+					OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
+		err = ocfs2_init_fs_quota_info(fs, USRQUOTA);
+		if (err)
+			return err;
+		err = ocfs2_read_global_quota_info(fs, USRQUOTA);
+		if (err)
+			return err;
+	}
+	if (OCFS2_HAS_RO_COMPAT_FEATURE(OCFS2_RAW_SB(fs->fs_super),
+					OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)) {
+		err = ocfs2_init_fs_quota_info(fs, GRPQUOTA);
+		if (err)
+			return err;
+		err = ocfs2_read_global_quota_info(fs, GRPQUOTA);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 #define OCFS2_GLOBAL_QF_INIT_BLOCKS 2
 
 errcode_t ocfs2_init_global_quota_file(ocfs2_filesys *fs, int type)
-- 
1.6.0.2
