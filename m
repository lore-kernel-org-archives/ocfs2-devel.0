From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Thu, 30 Nov 2017 14:24:40 -0800
Subject: [Ocfs2-devel] [patch 10/11] ocfs2: add ocfs2_overwrite_io()
Message-ID: <5a208528.nZGENOlql9oMjjxc%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Gang He <ghe@suse.com>
Subject: ocfs2: add ocfs2_overwrite_io()

Add ocfs2_overwrite_io(), which is used to judge if overwrite allocated
blocks, otherwise, the write will bring extra block allocation overhead.

[ghe at suse.com: v2]
  Link: https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_1511944612-2D9629-2D3-2Dgit-2Dsend-2Demail-2Dghe-40suse.com&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=C4AZ7lGI2-gfFtbla8puNvYIA3a9Cr_XOH6oyx94oGo&s=QhxdPyP9gdEJZTa2UhuSk0x7ENXyGXUOIBV_LyP8oZw&e=
Link: https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_1511775987-2D841-2D3-2Dgit-2Dsend-2Demail-2Dghe-40suse.com&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=C4AZ7lGI2-gfFtbla8puNvYIA3a9Cr_XOH6oyx94oGo&s=T9Ljku-nipBqCaeXWukY2hAwcHQL95gtlU7pS3l1fgs&e=
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/extent_map.c |   41 ++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/extent_map.h |    3 ++
 2 files changed, 44 insertions(+)

diff -puN fs/ocfs2/extent_map.c~ocfs2-add-ocfs2_overwrite_io-function fs/ocfs2/extent_map.c
--- a/fs/ocfs2/extent_map.c~ocfs2-add-ocfs2_overwrite_io-function
+++ a/fs/ocfs2/extent_map.c
@@ -832,6 +832,47 @@ out:
 	return ret;
 }
 
+/* Is IO overwriting allocated blocks? */
+int ocfs2_overwrite_io(struct inode *inode, struct buffer_head *di_bh,
+		       u64 map_start, u64 map_len)
+{
+	int ret = 0, is_last;
+	u32 mapping_end, cpos;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_extent_rec rec;
+
+	if ((OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
+	   ((map_start + map_len) <= i_size_read(inode)))
+		goto out;
+
+	cpos = map_start >> osb->s_clustersize_bits;
+	mapping_end = ocfs2_clusters_for_bytes(inode->i_sb,
+					       map_start + map_len);
+	is_last = 0;
+	while (cpos < mapping_end && !is_last) {
+		ret = ocfs2_get_clusters_nocache(inode, di_bh, cpos,
+						 NULL, &rec, &is_last);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		if (rec.e_blkno == 0ULL)
+			break;
+
+		if (rec.e_flags & OCFS2_EXT_REFCOUNTED)
+			break;
+
+		cpos = le32_to_cpu(rec.e_cpos) +
+			le16_to_cpu(rec.e_leaf_clusters);
+	}
+
+	if (cpos < mapping_end)
+		ret = -EAGAIN;
+out:
+	return ret;
+}
+
 int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int whence)
 {
 	struct inode *inode = file->f_mapping->host;
diff -puN fs/ocfs2/extent_map.h~ocfs2-add-ocfs2_overwrite_io-function fs/ocfs2/extent_map.h
--- a/fs/ocfs2/extent_map.h~ocfs2-add-ocfs2_overwrite_io-function
+++ a/fs/ocfs2/extent_map.h
@@ -53,6 +53,9 @@ int ocfs2_extent_map_get_blocks(struct i
 int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		 u64 map_start, u64 map_len);
 
+int ocfs2_overwrite_io(struct inode *inode, struct buffer_head *di_bh,
+		       u64 map_start, u64 map_len);
+
 int ocfs2_seek_data_hole_offset(struct file *file, loff_t *offset, int origin);
 
 int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
_
