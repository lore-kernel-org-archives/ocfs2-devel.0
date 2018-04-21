From: Jia Guo <guojia12@huawei.com>
Date: Sat, 21 Apr 2018 19:41:17 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: clean up redundant function
	declarations
Message-ID: <3e225eb0-6f0a-e950-1f53-2721aff49026@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The function ocfs2_extend_allocation has been deleted, clean up its
declaration.

Fixes: 964f14a0d350 ("ocfs2: clean up some dead code")

Signed-off-by: Jia Guo <guojia12@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
---
 fs/ocfs2/file.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
index 1fdc983..7eb7f03 100644
--- a/fs/ocfs2/file.h
+++ b/fs/ocfs2/file.h
@@ -65,8 +65,6 @@ int ocfs2_extend_no_holes(struct inode *inode, struct buffer_head *di_bh,
 			  u64 new_i_size, u64 zero_to);
 int ocfs2_zero_extend(struct inode *inode, struct buffer_head *di_bh,
 		      loff_t zero_to);
-int ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
-		u32 clusters_to_add, int mark_unwritten);
 int ocfs2_setattr(struct dentry *dentry, struct iattr *attr);
 int ocfs2_getattr(const struct path *path, struct kstat *stat,
 		  u32 request_mask, unsigned int flags);
-- 
