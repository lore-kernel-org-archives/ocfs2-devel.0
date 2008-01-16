From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan 16 11:33:14 2008
Subject: [Ocfs2-devel] [PATCH 17/20] ocfs2: Don't panic when truncating an
	empty extent
In-Reply-To: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
References: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200511977-19513-18-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 92295d8054289eff0d52b4d12349f9b9df0f58e4
Author: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon, 3 Dec 2007 15:02:10 -0800

This BUG_ON() was unintentionally left in after the sparse file support was
written.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/alloc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 1a6455e..5714618 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6092,8 +6092,6 @@ start:
 	mlog(0, "clusters_to_del = %u in this pass, tail blk=%llu\n",
 	     clusters_to_del, (unsigned long long)path_leaf_bh(path)->b_blocknr);
 
-	BUG_ON(clusters_to_del == 0);
-
 	mutex_lock(&tl_inode->i_mutex);
 	tl_sem = 1;
 	/* ocfs2_truncate_log_needs_flush guarantees us at least one
-- 
1.5.3.4
