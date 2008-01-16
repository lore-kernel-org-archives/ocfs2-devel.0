From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan 16 11:33:18 2008
Subject: [Ocfs2-devel] [PATCH 01/20] ocfs2: Fix priority mistakes in
	fs/ocfs2/{alloc.c, dlmglue.c}
In-Reply-To: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
References: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200511977-19513-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 3cf0c507dd28de0e1a4c24304d806e6b3976f0f5
Author: Roel Kluin <12o3l@tiscali.nl>
Date: Sat, 27 Oct 2007 00:20:36 +0200

Fixes priority mistakes similar to '!x & y'

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/alloc.c   |    2 +-
 fs/ocfs2/dlmglue.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 4791433..1a6455e 100644
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
-- 
1.5.3.4
