From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 12 Mar 2009 06:24:23 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix a bug found by sparse check.
Message-ID: <1236810263-19023-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We need to use le32_to_cpu to test rec->e_cpos in
ocfs2_dinode_insert_check.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 3a9e5de..19e3a96 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -176,7 +176,8 @@ static int ocfs2_dinode_insert_check(struct inode *inode,
 
 	BUG_ON(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL);
 	mlog_bug_on_msg(!ocfs2_sparse_alloc(osb) &&
-			(OCFS2_I(inode)->ip_clusters != rec->e_cpos),
+			(OCFS2_I(inode)->ip_clusters !=
+			 le32_to_cpu(rec->e_cpos)),
 			"Device %s, asking for sparse allocation: inode %llu, "
 			"cpos %u, clusters %u\n",
 			osb->dev_str,
-- 
1.6.2.rc2.16.gf474c
