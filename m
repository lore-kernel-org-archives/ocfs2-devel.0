From: Tao Ma <tao.ma@oracle.com>
Date: Fri Nov 16 00:50:47 2007
Subject: [Ocfs2-devel] [PATCH 4/6] Modfiy cl_cpg in global_bitmap to be
	maximum value during mkfs,take 1
In-Reply-To: <20071116083920.GA3879@tma-pc1.cn.oracle.com>
Message-ID: <20071116084727.GA3946@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

cl_cpg is used in ocfs2 kernel to calculate the group no
for a given cluster. Change it to maximum number so that
there is no need to update it durin online resize.

Signed-off-by: Tao Ma <tao.ma@oracle.com>

---

 fsck.ocfs2/pass0.c |    2 +-
 mkfs.ocfs2/mkfs.c  |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

fe4f6a9996e36994e36196422efac3665dca90f8
diff --git a/fsck.ocfs2/pass0.c b/fsck.ocfs2/pass0.c
index d53c76d..1e4c243 100644
--- a/fsck.ocfs2/pass0.c
+++ b/fsck.ocfs2/pass0.c
@@ -393,7 +393,7 @@ static void mark_group_used(o2fsck_state
 }
 
 /*
- * Due to a glitch in mkfs, cl->cl_cpg for the GLOBAL BITMAP could be
+ * Due to a glitch in old mkfs, cl->cl_cpg for the GLOBAL BITMAP could be
  * less than the max possible for volumes having just one cluster
  * group. Fix.
  */
diff --git a/mkfs.ocfs2/mkfs.c b/mkfs.ocfs2/mkfs.c
index 0ade0ab..57784a6 100644
--- a/mkfs.ocfs2/mkfs.c
+++ b/mkfs.ocfs2/mkfs.c
@@ -1910,7 +1910,8 @@ format_file(State *s, SystemFileDiskReco
 	if (rec->cluster_bitmap) {
 		di->id2.i_chain.cl_count = 
 			ocfs2_chain_recs_per_inode(s->blocksize);
-		di->id2.i_chain.cl_cpg = s->global_cpg;
+		di->id2.i_chain.cl_cpg =
+				 ocfs2_group_bitmap_size(s->blocksize) * 8;
 		di->id2.i_chain.cl_bpc = 1;
 		if (s->nr_cluster_groups > 
 		    ocfs2_chain_recs_per_inode(s->blocksize)) {
-- 
1.3.3
