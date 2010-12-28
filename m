From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 28 Dec 2010 19:40:41 +0800
Subject: [Ocfs2-devel] [PATCH 1/8] Ocfs2: Adding new ioctl code
	'OCFS2_IOC_MOVE_EXT' to ocfs2.
In-Reply-To: <1293536448-20516-1-git-send-email-tristan.ye@oracle.com>
References: <1293536448-20516-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1293536448-20516-2-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Patch also manages to add an manipulative struture for this ioctl.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/ocfs2_ioctl.h |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ocfs2_ioctl.h b/fs/ocfs2/ocfs2_ioctl.h
index b46f39b..9340ad3 100644
--- a/fs/ocfs2/ocfs2_ioctl.h
+++ b/fs/ocfs2/ocfs2_ioctl.h
@@ -171,4 +171,31 @@ enum ocfs2_info_type {
 
 #define OCFS2_IOC_INFO		_IOR('o', 5, struct ocfs2_info)
 
+#define OCFS2_MOVE_EXT_FL_AUTO_DEFRAG	(0x00000001)	/* Kernel manages to
+							   claim new clusters
+							   as the goal place
+							   for extents moving */
+#define OCFS2_MOVE_EXT_FL_COMPLETE	(0x00000002)	/* Move or defragmenation
+							   completely gets done.
+							 */
+struct ocfs2_move_extents {
+/* All values are in bytes */
+	/* in */
+	__u64 me_start;		/* Virtual start in the file to move */
+	__u64 me_len;		/* Length of the extents to be moved */
+	__u64 me_goal;		/* Physical offset of the goal */
+	__u64 me_thresh;	/* Maximum distance from goal or threshold
+				   for auto defragmentation */
+	__u64 me_flags;		/* flags for the operation:
+				 * - auto defragmentation.
+				 * - refcount,xattr cases.
+				 */
+	/* out */
+	__u64 me_moved_len;	/* moved length */
+	__u64 me_new_offset;	/* Resulting physical location */
+	__u32 me_reserved[2];	/* reserved for futhure */
+};
+
+#define OCFS2_IOC_MOVE_EXT	_IOW('o', 6, struct ocfs2_move_extents)
+
 #endif /* OCFS2_IOCTL_H */
-- 
1.5.5
