From: Tim Gardner <tim.gardner@canonical.com>
Date: Wed, 13 Feb 2013 19:45:06 -0000
Subject: [Ocfs2-devel] [PATCH 2/2 linux-next] ocfs2:
	ocfs2_begin_truncate_log_recovery(): consolidate status error
	logging
In-Reply-To: <1360784676-74994-1-git-send-email-tim.gardner@canonical.com>
References: <1360784676-74994-1-git-send-email-tim.gardner@canonical.com>
Message-ID: <1360784676-74994-2-git-send-email-tim.gardner@canonical.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel at oss.oracle.com
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 fs/ocfs2/alloc.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 42c0e49..1689ca1 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6090,10 +6090,8 @@ int ocfs2_begin_truncate_log_recovery(struct ocfs2_super *osb,
 	trace_ocfs2_begin_truncate_log_recovery(slot_num);
 
 	status = ocfs2_get_truncate_log_info(osb, slot_num, &tl_inode, &tl_bh);
-	if (status < 0) {
-		mlog_errno(status);
+	if (status < 0)
 		goto bail;
-	}
 
 	di = (struct ocfs2_dinode *) tl_bh->b_data;
 
@@ -6109,7 +6107,6 @@ int ocfs2_begin_truncate_log_recovery(struct ocfs2_super *osb,
 		*tl_copy = kmalloc(tl_bh->b_size, GFP_KERNEL);
 		if (!(*tl_copy)) {
 			status = -ENOMEM;
-			mlog_errno(status);
 			goto bail;
 		}
 
@@ -6123,10 +6120,8 @@ int ocfs2_begin_truncate_log_recovery(struct ocfs2_super *osb,
 
 		ocfs2_compute_meta_ecc(osb->sb, tl_bh->b_data, &di->i_check);
 		status = ocfs2_write_block(osb, tl_bh, INODE_CACHE(tl_inode));
-		if (status < 0) {
-			mlog_errno(status);
+		if (status < 0)
 			goto bail;
-		}
 	}
 
 bail:
@@ -6134,6 +6129,9 @@ bail:
 		iput(tl_inode);
 	brelse(tl_bh);
 
+	if (status < 0)
+		mlog_errno(status);
+
 	kfree(*tl_copy);
 	*tl_copy = NULL;
 
-- 
1.7.9.5
