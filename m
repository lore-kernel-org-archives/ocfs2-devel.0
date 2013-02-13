From: Tim Gardner <tim.gardner@canonical.com>
Date: Wed, 13 Feb 2013 19:44:55 -0000
Subject: [Ocfs2-devel] [PATCH 1/2 linux-next] ocfs2: remove kfree()
	redundant null checks
Message-ID: <1360784676-74994-1-git-send-email-tim.gardner@canonical.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

smatch analysis:

fs/ocfs2/alloc.c:6138 ocfs2_begin_truncate_log_recovery() info:
 redundant null check on *tl_copy calling kfree()

fs/ocfs2/alloc.c:6755 ocfs2_zero_range_for_truncate() info:
 redundant null check on pages calling kfree()

Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel at oss.oracle.com
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 fs/ocfs2/alloc.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 31b9463..42c0e49 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6134,11 +6134,8 @@ bail:
 		iput(tl_inode);
 	brelse(tl_bh);
 
-	if (status < 0 && (*tl_copy)) {
-		kfree(*tl_copy);
-		*tl_copy = NULL;
-		mlog_errno(status);
-	}
+	kfree(*tl_copy);
+	*tl_copy = NULL;
 
 	return status;
 }
@@ -6751,8 +6748,7 @@ int ocfs2_zero_range_for_truncate(struct inode *inode, handle_t *handle,
 		mlog_errno(ret);
 
 out:
-	if (pages)
-		kfree(pages);
+	kfree(pages);
 
 	return ret;
 }
-- 
1.7.9.5
