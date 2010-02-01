From: Tristan Ye <tristan.ye@oracle.com>
Date: Mon,  1 Feb 2010 18:29:33 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Fix punching hole codes to
	correctly do CoW during cluster zeroing.
In-Reply-To: <1265020173-14623-1-git-send-email-tristan.ye@oracle.com>
References: <1265020173-14623-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1265020173-14623-2-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Based on the former patch of truncating optimization, bugfix for refcount on
punching holes can be fairly easy and straightforward since most of work we
should take into account for refcounting have been completed already in func
ocfs2_remove_btree_range(), which is also being used by our truncating codes.

The patch just did CoW for reflinks when a hole is being punched whose start
and end offset were within one cluster, which means partial zeroing for a cluster
will be performed soon.

The patch has been tested fixing the following bug:

http://oss.oracle.com/bugzilla/show_bug.cgi?id=1216

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/file.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index e0c9d1c..bb15a1e 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1458,6 +1458,27 @@ static int ocfs2_remove_inode_range(struct inode *inode,
 		goto out;
 	}
 
+	/*
+	 * For reflinks, we may need to CoW 2 clusters which might be
+	 * partially zero'd later, if hole's start and end offset were
+	 * within one cluster(means is not exactly aligned to clustersize).
+	 */
+
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL) {
+
+		ret = ocfs2_cow_file_pos(inode, di_bh, byte_start);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		ret = ocfs2_cow_file_pos(inode, di_bh, byte_start + byte_len);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+	}
+
 	trunc_start = ocfs2_clusters_for_bytes(osb->sb, byte_start);
 	trunc_len = (byte_start + byte_len) >> osb->s_clustersize_bits;
 	if (trunc_len >= trunc_start)
-- 
1.5.5
