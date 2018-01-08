From: Changwei Ge <ge.changwei@h3c.com>
Date: Mon, 8 Jan 2018 01:36:05 +0000
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: make metadata estimation accurate
	and clear
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F290CEEE@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Current code assume that ::w_unwritten_list always has only one item on.
This is not right and hard to get understood.
So improve how to count unwritten item.

Reported-by: John Lightsey <john@nixnuts.net>
Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
---
  fs/ocfs2/aops.c | 4 +++-
  1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index d151632..256986a 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -797,6 +797,7 @@ struct ocfs2_write_ctxt {
  	struct ocfs2_cached_dealloc_ctxt w_dealloc;
  
  	struct list_head		w_unwritten_list;
+	unsigned int			w_unwritten_count;
  };
  
  void ocfs2_unlock_and_free_pages(struct page **pages, int num_pages)
@@ -1386,6 +1387,7 @@ static int ocfs2_unwritten_check(struct inode *inode,
  	desc->c_clear_unwritten = 0;
  	list_add_tail(&new->ue_ip_node, &oi->ip_unwritten_list);
  	list_add_tail(&new->ue_node, &wc->w_unwritten_list);
+	wc->w_unwritten_count++;
  	new = NULL;
  unlock:
  	spin_unlock(&oi->ip_lock);
@@ -2256,7 +2258,7 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
  		ue->ue_phys = desc->c_phys;
  
  		list_splice_tail_init(&wc->w_unwritten_list, &dwc->dw_zero_list);
-		dwc->dw_zero_count++;
+		dwc->dw_zero_count += wc->w_unwritten_count;
  	}
  
  	ret = ocfs2_write_end_nolock(inode->i_mapping, pos, len, len, wc);
-- 
2.7.4
