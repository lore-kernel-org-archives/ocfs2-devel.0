From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 21 Aug 2009 22:55:52 +0800
Subject: [Ocfs2-devel] [PATCH 19/41] ocfs2: Integrate CoW in file write.
In-Reply-To: <4A8E028B.50802@oracle.com>
References: <4A8E028B.50802@oracle.com>
Message-ID: <1250866552-10333-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,
	Here is the solution for refcounted+non-refcounted+refcounted issues.
	Please review.

Regards,
Tao

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 02244bb..0978abe 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1677,6 +1677,47 @@ static int ocfs2_expand_nonsparse_inode(struct inode *inode, loff_t pos,
 	return ret;
 }
 
+/*
+ * CoW all refcounted clusters within [cow_start, cow_start + cow_len).
+ *
+ * Note: We may meet with non-refcounted clusters or even holes, just skip
+ * them and iterate until we reach cow_start + cow_len.
+ */
+static int ocfs2_refcount_clusters(struct inode *inode,
+				   struct buffer_head *di_bh,
+				   u32 cow_start, u32 cow_len)
+{
+	int ret = 0;
+	u32 p_cluster, num_clusters;
+	unsigned int ext_flags;
+
+	while (cow_len) {
+		ret = ocfs2_get_clusters(inode, cow_start, &p_cluster,
+					 &num_clusters, &ext_flags);
+		if (ret) {
+			mlog_errno(ret);
+			break;
+		}
+
+		if (cow_len < num_clusters)
+			num_clusters = cow_len;
+
+		if (ext_flags & OCFS2_EXT_REFCOUNTED) {
+			ret = ocfs2_refcount_cow(inode, di_bh, cow_start,
+						 num_clusters);
+			if (ret) {
+				mlog_errno(ret);
+				break;
+			}
+		}
+
+		cow_len -= num_clusters;
+		cow_start += num_clusters;
+	}
+
+	return ret;
+}
+
 int ocfs2_write_begin_nolock(struct address_space *mapping,
 			     loff_t pos, unsigned len, unsigned flags,
 			     struct page **pagep, void **fsdata,
@@ -1730,8 +1771,8 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 		BUG_ON(refcounted_cpos == UINT_MAX);
 		cow_len = wc->w_clen - (refcounted_cpos - wc->w_cpos);
 
-		ret = ocfs2_refcount_cow(inode, di_bh,
-					 refcounted_cpos, cow_len);
+		ret = ocfs2_refcount_clusters(inode, di_bh,
+					      refcounted_cpos, cow_len);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
