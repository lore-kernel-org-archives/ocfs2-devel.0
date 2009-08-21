From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 21 Aug 2009 11:39:44 -0700
Subject: [Ocfs2-devel] [PATCH 17/41] ocfs2: Add CoW support.
In-Reply-To: <1250843065-6381-1-git-send-email-tao.ma@oracle.com>
References: <20090821070737.GB20755@mail.oracle.com>
	<1250843065-6381-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090821183944.GA4330@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Aug 21, 2009 at 04:24:25PM +0800, Tao Ma wrote:
> 	As our talk in irc, here is the updated one. Please review.

	Perfect.
	Here's a version with the math wrapped in shiny readable
inlines.  Some comments were updated too.  I didn't actually change the
logic, so please verify I got it right.

Joel

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index d59860d..8f0d210 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2499,7 +2499,52 @@ out:
 	return ret;
 }
 
-#define	MAX_COW_BYTES	1048576
+#define	MAX_CONTIG_BYTES	1048576
+
+static inline unsigned int ocfs2_cow_contig_clusters(struct super_block *sb)
+{
+	return ocfs2_clusters_for_bytes(sb, MAX_CONTIG_BYTES);
+}
+
+static inline unsigned int ocfs2_cow_contig_mask(struct super_block *sb)
+{
+	return ~(ocfs2_cow_contig_clusters(sb) - 1);
+}
+
+/*
+ * Given an extent that starts at 'start and an I/O that starts at
+ * 'cpos, find an offset (start * (n * contig_clusters)) that is closest
+ * to cpos while still being less than or equal to it.
+ *
+ * The goal is to break the extent at a multiple of contig_clusters.
+ */
+static inline unsigned int ocfs2_cow_align_start(struct super_block *sb,
+						 unsigned int start,
+						 unsigned int cpos)
+{
+	BUG_ON(start > cpos);
+
+	return start + ((cpos - start) & ocfs2_cow_contig_mask(sb));
+}
+
+/*
+ * Given a cluster count of len, pad it out so that it is a multiple
+ * of contig_clusters.
+ */
+static inline unsigned int ocfs2_cow_align_length(struct super_block *sb,
+						  unsigned int len)
+{
+	unsigned int padded =
+		(len + (ocfs2_cow_contig_clusters(sb) - 1)) &
+		ocfs2_cow_contig_mask(sb);
+
+	/* Did we wrap? */
+	if (padded < len)
+		padded = UINT_MAX;
+
+	return padded;
+}
+
 /*
  * Calculate out the start and number of virtual clusters we need to to CoW.
  *
@@ -2508,9 +2553,8 @@ out:
  * max_cpos is the place where we want to stop CoW intentionally.
  *
  * Normal we will start CoW from the beginning of extent record cotaining cpos.
- * And We will try to Cow as much clusters as we can until we reach
- * MAX_COW_BYTES. If the write_len is larger than MAX_COW_BYTES, we will
- * use that value as the maximum clusters.
+ * We try to break up extents on boundaries of MAX_CONTIG_BYTES so that we
+ * get good I/O from the resulting extent tree.
  */
 static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
 					   struct ocfs2_extent_list *el,
@@ -2525,10 +2569,10 @@ static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
 	struct buffer_head *eb_bh = NULL;
 	struct ocfs2_extent_block *eb = NULL;
 	struct ocfs2_extent_rec *rec;
-	int max_clusters = ocfs2_clusters_for_bytes(inode->i_sb, MAX_COW_BYTES);
-	int leaf_clusters, rec_end = 0;
+	unsigned int want_clusters, rec_end = 0;
+	int contig_clusters = ocfs2_cow_contig_clusters(inode->i_sb);
+	int leaf_clusters;
 
-	max_clusters = max_clusters < write_len ? write_len : max_clusters;
 	if (tree_height > 0) {
 		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, cpos, &eb_bh);
 		if (ret) {
@@ -2587,53 +2631,98 @@ static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
 			leaf_clusters = rec_end - le32_to_cpu(rec->e_cpos);
 		}
 
-		if (*cow_len + leaf_clusters >= max_clusters) {
-			if (*cow_len == 0) {
-				/*
-				 * cpos is in a very large extent record.
-				 * So just split max_clusters from the
-				 * extent record.
-				 */
-				if ((rec_end - cpos) <= max_clusters) {
-					/*
-					 * We can take max_clusters off
-					 * the end and cover all of our
-					 * write.
-					 */
-					*cow_start = rec_end - max_clusters;
-				} else if ((*cow_start + max_clusters) >
-					   (cpos + write_len)) {
-					/*
-					 * We can take max_clusters off
-					 * the front and cover all of
-					 * our write.
-					 */
-					/* NOOP, *cow_start is already set */
-				} else {
-					/*
-					 * We're CoWing more data than
-					 * write_len for contiguousness,
-					 * but it doesn't fit at the
-					 * front or end of this extent.
-					 * Let's try to slice the extent
-					 * up nicely.  Optimally, our
-					 * CoW region starts at a
-					 * multiple of max_clusters.  If
-					 * that doesn't fit, we give up
-					 * and just CoW at cpos.
-					 */
-					*cow_start +=
-						(cpos - *cow_start) &
-							~(max_clusters - 1);
-					if ((*cow_start + max_clusters) <
-					    (cpos + write_len))
-						*cow_start = cpos;
-				}
-			}
-			*cow_len = max_clusters;
-			break;
-		} else
+		/*
+		 * How many clusters do we actually need from
+		 * this extent?  First we see how many we actually
+		 * need to complete the write.  If that's smaller
+		 * than contig_clusters, we try for contig_clusters.
+		 */
+		if (!*cow_len)
+			want_clusters = write_len;
+		else
+			want_clusters = (cpos + write_len) -
+				(*cow_start + *cow_len);
+		if (want_clusters < contig_clusters)
+			want_clusters = contig_clusters;
+
+		/*
+		 * If the write does not cover the whole extent, we
+		 * need to calculate how we're going to split the extent.
+		 * We try to do it on contig_clusters boundaries.
+		 *
+		 * Any extent smaller than contig_clusters will be
+		 * CoWed in its entirety.
+		 */
+		if (leaf_clusters <= contig_clusters)
 			*cow_len += leaf_clusters;
+		else if (*cow_len || (*cow_start == cpos)) {
+			/*
+			 * This extent needs to be CoW'd from its
+			 * beginning, so all we have to do is compute
+			 * how many clusters to grab.  We align
+			 * want_clusters to the edge of contig_clusters
+			 * to get better I/O.
+			 */
+			want_clusters = ocfs2_cow_align_length(inode->i_sb,
+							       want_clusters);
+
+			if (leaf_clusters < want_clusters)
+				*cow_len += leaf_clusters;
+			else
+				*cow_len += want_clusters;
+		} else if ((*cow_start + contig_clusters) >=
+			   (cpos + write_len)) {
+			/*
+			 * Breaking off contig_clusters at the front
+			 * of the extent will cover our write.  That's
+			 * easy.
+			 */
+			*cow_len = contig_clusters;
+		} else if ((rec_end - cpos) <= contig_clusters) {
+			/*
+			 * Breaking off contig_clusters at the tail of
+			 * this extent will cover cpos.
+			 */
+			*cow_start = rec_end - cpos;
+			*cow_len = contig_clusters;
+		} else if ((rec_end - cpos) <= want_clusters) {
+			/*
+			 * While we can't fit the entire write in this
+			 * extent, we know that the write goes from cpos
+			 * to the end of the extent.  Break that off.
+			 * We try to break it@some multiple of
+			 * contig_clusters from the front of the extent.
+			 * Failing that (ie, cpos is within
+			 * contig_clusters of the front), we'll CoW the
+			 * entire extent.
+			 */
+			*cow_start = ocfs2_cow_align_start(inode->i_sb,
+							   *cow_start, cpos);
+			*cow_len = rec_end - *cow_start;
+		} else {
+			/*
+			 * Ok, the entire write lives in the middle of
+			 * this extent.  Let's try to slice the extent up
+			 * nicely.  Optimally, our CoW region starts at
+			 * m*contig_clusters from the beginning of the
+			 * extent and goes for n*contig_clusters,
+			 * covering the entire write.
+			 */
+			*cow_start = ocfs2_cow_align_start(inode->i_sb,
+							   *cow_start, cpos);
+
+			want_clusters = (cpos + write_len) - *cow_start;
+			want_clusters = ocfs2_cow_align_length(inode->i_sb,
+							       want_clusters);
+			if (*cow_start + want_clusters <= rec_end)
+				*cow_len = want_clusters;
+			else
+				*cow_len = rec_end - *cow_start;
+		}
+
+		/* Have we covered our entire write yet? */
+		if ((*cow_start + *cow_len) >= (cpos + write_len))
+			break;
 
 		/*
 		 * If we reach the end of the extent block and don't get enough
-- 

"Any man who is under 30, and is not a liberal, has not heart;
 and any man who is over 30, and is not a conservative, has no brains."
         - Sir Winston Churchill 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
