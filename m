From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Thu, 01 Dec 2016 16:55:14 -0800
Subject: [Ocfs2-devel] [PATCH 8/8] ocfs2: charge quota for reflinked blocks
In-Reply-To: <148064006267.14039.3248903225701175868.stgit@birch.djwong.org>
References: <148064006267.14039.3248903225701175868.stgit@birch.djwong.org>
Message-ID: <148064011424.14039.9933990570615486837.stgit@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, akpm@linux-foundation.org, jlbec@evilplan.org, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, ocfs2-devel@oss.oracle.com

When ocfs2 shares blocks from one file to another, it's necessary to
charge that many blocks to the quota because ocfs2 tallies block charges
according to the number of blocks mapped, not the number of physical
blocks used.

Without this patch, reflinking X blocks and then CoWing all of them
causes quota usage to *decrease* by X as seen in generic/305.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/refcounttree.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 57297ce..33555d58 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3934,6 +3934,13 @@ static int ocfs2_add_refcounted_extent(struct inode *inode,
 	ret = ocfs2_increase_refcount(handle, ref_ci, ref_root_bh,
 				      p_cluster, num_clusters,
 				      meta_ac, dealloc);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ret = dquot_alloc_space_nodirty(inode,
+		ocfs2_clusters_to_bytes(osb->sb, num_clusters));
 	if (ret)
 		mlog_errno(ret);
 
