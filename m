From: Tao Ma <tao.ma@oracle.com>
Date: Fri Nov 16 00:44:35 2007
Subject: [Ocfs2-devel] [PATCH 1/2] Initalize bitmap_cpg of ocfs2_super to be
	the maximum,take 1
In-Reply-To: <20071116082736.GA3732@tma-pc1.cn.oracle.com>
Message-ID: <20071116084110.GA3893@tma-pc1.cn.oracle.com>
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

 fs/ocfs2/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

a73e1353a2dbcaffc73e4b76e5a3c2b2cc5347cc
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index be562ac..9aa31bc 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1554,7 +1554,7 @@ static int ocfs2_initialize_super(struct
 	}
 
 	di = (struct ocfs2_dinode *) bitmap_bh->b_data;
-	osb->bitmap_cpg = le16_to_cpu(di->id2.i_chain.cl_cpg);
+	osb->bitmap_cpg = ocfs2_group_bitmap_size(sb) * 8;
 	brelse(bitmap_bh);
 	mlog(0, "cluster bitmap inode: %llu, clusters per group: %u\n",
 	     (unsigned long long)osb->bitmap_blkno, osb->bitmap_cpg);
-- 
1.3.3
