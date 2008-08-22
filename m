From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 21 Aug 2008 17:12:57 -0700
Subject: [Ocfs2-devel] [PATCH 07/10] ocfs2: Determine an extent
	tree's	max_leaf_clusters in an et_op.
In-Reply-To: <20080821232920.GM14096@mail.oracle.com>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
	<1219286905-28104-8-git-send-email-joel.becker@oracle.com>
	<20080821222504.GR4563@wotan.suse.de>
	<20080821232920.GM14096@mail.oracle.com>
Message-ID: <20080822001257.GA15838@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 21, 2008 at 04:29:20PM -0700, Joel Becker wrote:
> On Thu, Aug 21, 2008 at 03:25:04PM -0700, Mark Fasheh wrote:
> > On Wed, Aug 20, 2008 at 07:48:22PM -0700, Joel Becker wrote:
> > > --- a/fs/ocfs2/alloc.c
> > > +++ b/fs/ocfs2/alloc.c
> > > @@ -76,6 +76,8 @@ struct ocfs2_extent_tree_operations {
> > >  	/* These are internal to ocfs2_extent_tree and don't have
> > >  	 * accessor functions */
> > >  	void (*eo_fill_root_el)(struct ocfs2_extent_tree *et);
> > 
> > A comment here, noting that it's optional and what the expected behavior is
> > if it isn't set would be nice. Otherwise, this patch looks great.
> 
> 	eo_fill_root_el() is required, but really I think the entire set
> of ops should be commented.  I only didn't because the initial set
> wasn't.  I was wrong, and probably should have even specified the
> comments in the original review of Tao's patches.

	What about this:

From f11a2890332ac830c87d0c9edef8f8f1a337c505 Mon Sep 17 00:00:00 2001
From: Joel Becker <joel.becker@oracle.com>
Date: Thu, 21 Aug 2008 17:11:10 -0700
Subject: [PATCH] ocfs2: Comment struct ocfs2_extent_tree_operations.

struct ocfs2_extent_tree_operations provides methods for the different
on-disk btrees in ocfs2.  Describing what those methods do is probably a
good idea.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |   45 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 3ca6087..bbd7cb7 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -50,21 +50,62 @@
 #include "buffer_head_io.h"
 
 
+/*
+ * Operations for a specific extent tree type.
+ *
+ * To implement an on-disk btree (extent tree) type in ocfs2, add
+ * an ocfs2_extent_tree_operations structure and the matching
+ * ocfs2_get_<thingy>_extent_tree() function.  That's pretty much it
+ * for the allocation portion of the extent tree.
+ */
 struct ocfs2_extent_tree_operations {
+	/*
+	 * last_eb_blk is the block number of the right most leaf extent
+	 * block.  Most on-disk structures containing an extent tree store
+	 * this value for fast access.  The ->eo_set_last_eb_blk() and
+	 * ->eo_get_last_eb_blk() operations access this value.  They are
+	 *  both required.
+	 */
 	void (*eo_set_last_eb_blk)(struct ocfs2_extent_tree *et,
 				   u64 blkno);
 	u64 (*eo_get_last_eb_blk)(struct ocfs2_extent_tree *et);
+
+	/*
+	 * The on-disk structure usually keeps track of how many total
+	 * clusters are stored in this extent tree.  This function updates
+	 * that value.  new_clusters is the delta, and must be
+	 * added to the total.  Required.
+	 */
 	void (*eo_update_clusters)(struct inode *inode,
 				   struct ocfs2_extent_tree *et,
 				   u32 new_clusters);
+
+	/*
+	 * If ->eo_insert_check() exists, it is called before rec is
+	 * inserted into the extent tree.  It is optional.
+	 */
 	int (*eo_insert_check)(struct inode *inode,
 			       struct ocfs2_extent_tree *et,
 			       struct ocfs2_extent_rec *rec);
 	int (*eo_remove_check)(struct inode *inode, struct ocfs2_extent_tree *et);
 
-	/* These are internal to ocfs2_extent_tree and don't have
-	 * accessor functions */
+	/*
+	 * --------------------------------------------------------------
+	 * The remaining are internal to ocfs2_extent_tree and don't have
+	 * accessor functions
+	 */
+
+	/*
+	 * ->eo_fill_root_el() takes et->et_object and sets et->et_root_el.
+	 * It is required.
+	 */
 	void (*eo_fill_root_el)(struct ocfs2_extent_tree *et);
+
+	/*
+	 * ->eo_fill_max_leaf_clusters sets et->et_max_leaf_clusters if
+	 * it exists.  If it does not, et->et_max_leaf_clusters is set
+	 * to 0 (unlimited).  Optional.
+	 */
 	void (*eo_fill_max_leaf_clusters)(struct inode *inode,
 					  struct ocfs2_extent_tree *et);
 };
-- 
1.5.6.3


-- 

"The doctrine of human equality reposes on this: that there is no
 man really clever who has not found that he is stupid."
	- Gilbert K. Chesterson

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
