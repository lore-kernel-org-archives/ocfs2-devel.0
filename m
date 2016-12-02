From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Thu, 01 Dec 2016 16:54:48 -0800
Subject: [Ocfs2-devel] [PATCH 4/8] ocfs2: budget for extent tree splits when
 adding refcount flag
In-Reply-To: <148064006267.14039.3248903225701175868.stgit@birch.djwong.org>
References: <148064006267.14039.3248903225701175868.stgit@birch.djwong.org>
Message-ID: <148064008865.14039.14914244854918274723.stgit@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, akpm@linux-foundation.org, jlbec@evilplan.org, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, ocfs2-devel@oss.oracle.com

When we're adding the refcount flag to an extent, we have to budget
enough space to handle a full extent btree split in addition to
whatever modifications have to be made to the refcount btree.  We
don't currently do this, with the result that generic/186 crashes
when we need an extent split but not a refcount split because meta_ac
never gets allocated.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/refcounttree.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 3410eb1..6c98d56 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3692,6 +3692,9 @@ int ocfs2_add_refcount_flag(struct inode *inode,
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_alloc_context *meta_ac = NULL;
 
+	/* We need to be able to handle at least an extent tree split. */
+	ref_blocks = ocfs2_extend_meta_needed(data_et->et_root_el);
+
 	ret = ocfs2_calc_refcount_meta_credits(inode->i_sb,
 					       ref_ci, ref_root_bh,
 					       p_cluster, num_clusters,
