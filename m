From: Roel Kluin <12o3l@tiscali.nl>
Date: Fri Oct 26 15:20:51 2007
Subject: [Ocfs2-devel] [PATCH] Fix priority mistakes in fs/ocfs2/{alloc.c,
	dlmglue.c}
Message-ID: <47226834.7030507@tiscali.nl>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Fixes priority mistakes similar to '!x & y'
    
Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 4ba7f0b..ce62c15 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3946,7 +3946,7 @@ static int __ocfs2_mark_extent_written(struct inode *inode,
 	struct ocfs2_merge_ctxt ctxt;
 	struct ocfs2_extent_list *rightmost_el;
 
-	if (!rec->e_flags & OCFS2_EXT_UNWRITTEN) {
+	if (!(rec->e_flags & OCFS2_EXT_UNWRITTEN)) {
 		ret = -EIO;
 		mlog_errno(ret);
 		goto out;
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 41c76ff..ef09fd2 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -670,7 +670,7 @@ static inline void ocfs2_generic_handle_attach_action(struct ocfs2_lock_res *loc
 {
 	mlog_entry_void();
 
-	BUG_ON((!lockres->l_flags & OCFS2_LOCK_BUSY));
+	BUG_ON((!(lockres->l_flags & OCFS2_LOCK_BUSY)));
 	BUG_ON(lockres->l_flags & OCFS2_LOCK_ATTACHED);
 
 	if (lockres->l_requested > LKM_NLMODE &&
