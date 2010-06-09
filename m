From: Tao Ma <tao.ma@oracle.com>
Date: Wed,  9 Jun 2010 16:43:05 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Limit default local alloc size within
	bitmap range.
Message-ID: <1276072985-7251-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In commit 6b82021b9e91cd689fdffadbcdb9a42597bbe764, we increase
our local alloc size and calculate how much megabytes we can
get according to group size and volume size.
But we also need to check the maximum bits a local alloc block
bitmap can have. With a bs=512, cs=32K, local volume with 160G,
it calculate 96MB while the maximum local alloc size is only
76M. So the bitmap will overflow and corrupt the system truncate
log file. See bug
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1262

Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/localalloc.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 3d74196..ec6adbf 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -118,6 +118,7 @@ unsigned int ocfs2_la_default_mb(struct ocfs2_super *osb)
 {
 	unsigned int la_mb;
 	unsigned int gd_mb;
+	unsigned int la_max_mb;
 	unsigned int megs_per_slot;
 	struct super_block *sb = osb->sb;
 
@@ -182,6 +183,12 @@ unsigned int ocfs2_la_default_mb(struct ocfs2_super *osb)
 	if (megs_per_slot < la_mb)
 		la_mb = megs_per_slot;
 
+	/* We can't store more bits than we can in a block. */
+	la_max_mb = ocfs2_clusters_to_megabytes(osb->sb,
+						ocfs2_local_alloc_size(sb) * 8);
+	if (la_mb > la_max_mb)
+		la_mb = la_max_mb;
+
 	return la_mb;
 }
 
-- 
1.5.5
