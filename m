From: Tao Ma <tao.ma@oracle.com>
Date: Tue Nov 27 00:20:57 2007
Subject: [Ocfs2-devel] [PATCH 1/3] Initalize bitmap_cpg of ocfs2_super to be
	the maximum.
In-Reply-To: <20071127081123.GA4345@tma-pc1.cn.oracle.com>
Message-ID: <20071127082019.GA4461@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This value is initialized from global_bitmap->id2.i_chain.cl_cpg. If there
is only 1 group, it will be equal to the total clusters in the volume. So
as for online resize, it should change for all the nodes in the cluster.
It isn't easy and there is no corresponding lock for it.

bitmap_cpg is only used in 2 areas:
1. Check whether the suballoc is too large for us to allocate from the global
   bitmap, so it is little used. And now the suballoc size is 2048, it rarely
   meet this situation and the check is almost useless.
2. Calculate which group a cluster belongs to. We use it during truncate to
   figure out which cluster group an extent belongs too. But we should be OK
   if we increase it though as the cluster group calculated shouldn't change
   and we only ever have a small bitmap_cpg on file systems with a single
   cluster group.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/super.c |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index be562ac..9f3d73c 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1315,7 +1315,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	int i, cbits, bbits;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
 	struct inode *inode = NULL;
-	struct buffer_head *bitmap_bh = NULL;
 	struct ocfs2_journal *journal;
 	__le32 uuid_net_key;
 	struct ocfs2_super *osb;
@@ -1539,25 +1538,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	}
 
 	osb->bitmap_blkno = OCFS2_I(inode)->ip_blkno;
-
-	/* We don't have a cluster lock on the bitmap here because
-	 * we're only interested in static information and the extra
-	 * complexity at mount time isn't worht it. Don't pass the
-	 * inode in to the read function though as we don't want it to
-	 * be put in the cache. */
-	status = ocfs2_read_block(osb, osb->bitmap_blkno, &bitmap_bh, 0,
-				  NULL);
 	iput(inode);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
 
-	di = (struct ocfs2_dinode *) bitmap_bh->b_data;
-	osb->bitmap_cpg = le16_to_cpu(di->id2.i_chain.cl_cpg);
-	brelse(bitmap_bh);
-	mlog(0, "cluster bitmap inode: %llu, clusters per group: %u\n",
-	     (unsigned long long)osb->bitmap_blkno, osb->bitmap_cpg);
+	osb->bitmap_cpg = ocfs2_group_bitmap_size(sb) * 8;
 
 	status = ocfs2_init_slot_info(osb);
 	if (status < 0) {
-- 
gitgui.0.9.0.gd794
