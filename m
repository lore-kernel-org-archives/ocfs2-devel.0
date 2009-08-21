From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 20 Aug 2009 20:55:48 -0700
Subject: [Ocfs2-devel] [PATCH 17/41] ocfs2: Add CoW support.
In-Reply-To: <20090821025136.GK10558@mail.oracle.com>
References: <4A8A47DF.8020707@oracle.com>
	<1250576382-27080-17-git-send-email-tao.ma@oracle.com>
	<20090821005932.GE10558@mail.oracle.com>
	<4A8E00A2.1050902@oracle.com>
	<20090821025136.GK10558@mail.oracle.com>
Message-ID: <20090821035547.GA20755@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 20, 2009 at 07:51:36PM -0700, Joel Becker wrote:
> 	I'm halfway through a modification of this code that splits out
> MAX_COW_BYTES from write_len.  Let me finish it tomorrow.

	I just did it.  What do you think?

Joel

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index d59860d..7790e1d 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2499,7 +2499,7 @@ out:
 	return ret;
 }
 
-#define	MAX_COW_BYTES	1048576
+#define	MAX_CONTIG_BYTES	1048576
 /*
  * Calculate out the start and number of virtual clusters we need to to CoW.
  *
@@ -2508,9 +2508,8 @@ out:
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
@@ -2525,10 +2524,11 @@ static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
 	struct buffer_head *eb_bh = NULL;
 	struct ocfs2_extent_block *eb = NULL;
 	struct ocfs2_extent_rec *rec;
-	int max_clusters = ocfs2_clusters_for_bytes(inode->i_sb, MAX_COW_BYTES);
+	int want_clusters;
+	int contig_clusters =
+		ocfs2_clusters_for_bytes(inode->i_sb, MAX_CONTIG_BYTES);
 	int leaf_clusters, rec_end = 0;
 
-	max_clusters = max_clusters < write_len ? write_len : max_clusters;
 	if (tree_height > 0) {
 		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, cpos, &eb_bh);
 		if (ret) {
@@ -2587,53 +2587,84 @@ static int ocfs2_refcount_cal_cow_clusters(struct inode *inode,
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
+		 * than contig_clusters, we try for
+		 * contig_clustes.
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
+		if (leaf_clusters < contig_clusters)
 			*cow_len += leaf_clusters;
+		else if (*cow_len || (*cow_start == cpos)) {
+			/*
+			 * This extent needs to be CoW'd from its
+			 * beginning, so all we have to do is compute
+			 * how many clusters to grab.
+			 */
+			if (leaf_clusters < want_clusters)
+				*cow_len += leaf_clusters;
+			else
+				*cow_len += want_clusters;
+		} else if ((*cow_start + contig_clusters) >
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
+			 */
+			*cow_start = cpos;
+			*cow_len = rec_end - cpos;
+		} else {
+			/*
+			 * Ok, the entire write lives in the middle of
+			 * this extent.
+			 * Let's try to slice the extentup nicely.
+			 * Optimally, our CoW region starts at a
+			 * multiple of contig_clusters.  If that doesn't
+			 * fit, we give up and just CoW@cpos.
+			 */
+			*cow_start += (cpos - *cow_start) &
+				~(contig_clusters - 1);
+			if ((*cow_start + want_clusters) <
+			    (cpos + write_len))
+				*cow_start = cpos;
+			*cow_len = want_clusters;
+		}
+
+		/* Have we covered our entire write yet? */
+		if ((*cow_start + *cow_len) >= (cpos + write_len))
+			break;
 
 		/*
 		 * If we reach the end of the extent block and don't get enough


-- 

Life's Little Instruction Book #450

	"Don't be afraid to say, 'I need help.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
