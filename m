From: alex chen <alex.chen@huawei.com>
Date: Tue, 13 Jan 2015 09:27:01 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix journal commit deadlock in
	ocfs2_convert_inline_data_to_extents
Message-ID: <54B47465.1050205@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Similar to ocfs2_write_end_nolock() which is metioned at commit
136f49b917(ocfs2: fix journal commit deadlock), we should unlock pages
before ocfs2_commit_trans() in ocfs2_convert_inline_data_to_extents,
otherwise, it will cause a deadlock with journal commit threads.

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/alloc.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index a93bf98..6d15c32 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6871,7 +6871,7 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		mlog_errno(ret);
-		goto out_unlock;
+		goto out;
 	}

 	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
@@ -6929,7 +6929,7 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 		if (ret) {
 			mlog_errno(ret);
 			need_free = 1;
-			goto out_commit;
+			goto out_unlock;
 		}

 		page_end = PAGE_CACHE_SIZE;
@@ -6962,12 +6962,16 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 		if (ret) {
 			mlog_errno(ret);
 			need_free = 1;
-			goto out_commit;
+			goto out_unlock;
 		}

 		inode->i_blocks = ocfs2_inode_sector_count(inode);
 	}

+out_unlock:
+	if (pages)
+		ocfs2_unlock_and_free_pages(pages, num_pages);
+
 out_commit:
 	if (ret < 0 && did_quota)
 		dquot_free_space_nodirty(inode,
@@ -6987,15 +6991,11 @@ out_commit:

 	ocfs2_commit_trans(osb, handle);

-out_unlock:
+out:
 	if (data_ac)
 		ocfs2_free_alloc_context(data_ac);
-
-out:
-	if (pages) {
-		ocfs2_unlock_and_free_pages(pages, num_pages);
+	if (pages)
 		kfree(pages);
-	}

 	return ret;
 }
-- 
1.8.4.3
