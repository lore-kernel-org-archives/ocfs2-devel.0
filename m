From: Changwei Ge <ge.changwei@h3c.com>
Date: Tue, 9 Jan 2018 14:24:29 +0800
Subject: [Ocfs2-devel] [PATCH RESEND v3 1/2] ocfs2: make metadata estimation
	accurate and clear
Message-ID: <1515479070-32653-1-git-send-email-ge.changwei@h3c.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

For Andrew's convenience, resend this patch

Current code assume that ::w_unwritten_list always has only one item on.
This is not right and hard to get understood.
So improve how to count unwritten item.

Reported-by: John Lightsey <john@nixnuts.net>
Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
---
 fs/ocfs2/aops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 88a31e9..77ec9b4 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -784,6 +784,7 @@ struct ocfs2_write_ctxt {
 	struct ocfs2_cached_dealloc_ctxt w_dealloc;
 
 	struct list_head		w_unwritten_list;
+	unsigned int			w_unwritten_count;
 };
 
 void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages)
@@ -1373,6 +1374,7 @@ static int ocfs2_unwritten_check(struct inode *inode,
 	desc->c_clear_unwritten = 0;
 	list_add_tail(&new->ue_ip_node, &oi->ip_unwritten_list);
 	list_add_tail(&new->ue_node, &wc->w_unwritten_list);
+	wc->w_unwritten_count++;
 	new = NULL;
 unlock:
 	spin_unlock(&oi->ip_lock);
@@ -2246,7 +2248,7 @@ static int ocfs2_dio_get_block(struct inode *inode, sector_t iblock,
 		ue->ue_phys = desc->c_phys;
 
 		list_splice_tail_init(&wc->w_unwritten_list, &dwc->dw_zero_list);
-		dwc->dw_zero_count++;
+		dwc->dw_zero_count += wc->w_unwritten_count;
 	}
 
 	ret = ocfs2_write_end_nolock(inode->i_mapping, pos, len, len, wc);
-- 
2.7.4
