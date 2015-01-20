From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 20 Jan 2015 16:35:12 +0800
Subject: [Ocfs2-devel] [PATCH 9/9 v6] ocfs2: set append dio as a ro compat
	feature
Message-ID: <54BE1340.6000903@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Intruduce a bit OCFS2_FEATURE_RO_COMPAT_APPEND_DIO and check it in
write flow. If the bit is not set, fall back to the old way.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Weiwei Wang <wangww631@huawei.com>
---
 fs/ocfs2/file.c     | 17 ++++++++++++++++-
 fs/ocfs2/ocfs2.h    |  8 ++++++++
 fs/ocfs2/ocfs2_fs.h |  8 +++++++-
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 4a712cf..41700d8 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2213,6 +2213,15 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 		}

 		/*
+		 * Fallback to old way if the feature bit is not set.
+		 */
+		if (end > i_size_read(inode) &&
+				!ocfs2_supports_append_dio(osb)) {
+			*direct_io = 0;
+			break;
+		}
+
+		/*
 		 * We don't fill holes during direct io, so
 		 * check for them here. If any are found, the
 		 * caller will have to retake some cluster
@@ -2220,7 +2229,13 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 		 */
 		ret = ocfs2_check_range_for_holes(inode, saved_pos, count);
 		if (ret == 1) {
-			*direct_io = 0;
+			/*
+			 * Fallback to old way if the feature bit is not set.
+			 * Otherwise try dio first and then complete the rest
+			 * request through buffer io.
+			 */
+			if (!ocfs2_supports_append_dio(osb))
+				*direct_io = 0;
 			ret = 0;
 		} else if (ret < 0)
 			mlog_errno(ret);
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 131cc1c..bcc1cd6 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -498,6 +498,14 @@ static inline int ocfs2_writes_unwritten_extents(struct ocfs2_super *osb)
 	return 0;
 }

+static inline int ocfs2_supports_append_dio(struct ocfs2_super *osb)
+{
+	if (osb->s_feature_ro_compat & OCFS2_FEATURE_RO_COMPAT_APPEND_DIO)
+		return 1;
+	return 0;
+}
+
+
 static inline int ocfs2_supports_inline_data(struct ocfs2_super *osb)
 {
 	if (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_INLINE_DATA)
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index cf4fa43..20e37a3 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -105,7 +105,8 @@
 					 | OCFS2_FEATURE_INCOMPAT_CLUSTERINFO)
 #define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN \
 					 | OCFS2_FEATURE_RO_COMPAT_USRQUOTA \
-					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)
+					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA \
+					 | OCFS2_FEATURE_RO_COMPAT_APPEND_DIO)

 /*
  * Heartbeat-only devices are missing journals and other files.  The
@@ -199,6 +200,11 @@
 #define OCFS2_FEATURE_RO_COMPAT_USRQUOTA	0x0002
 #define OCFS2_FEATURE_RO_COMPAT_GRPQUOTA	0x0004

+/*
+ * Append Direct IO support
+ */
+#define OCFS2_FEATURE_RO_COMPAT_APPEND_DIO	0x0008
+
 /* The byte offset of the first backup block will be 1G.
  * The following will be 4G, 16G, 64G, 256G and 1T.
  */
-- 
1.8.4.3
