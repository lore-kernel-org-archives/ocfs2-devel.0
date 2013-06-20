From: Younger Liu <younger.liu@huawei.com>
Date: Thu, 20 Jun 2013 21:18:39 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: should call ocfs2_journal_access_di()
 before ocfs2_delete_entry() in ocfs2_orphan_del()
Message-ID: <51C3012F.3010408@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


While deleting a file into orphan dir in ocfs2_orphan_del(),
it calls ocfs2_delete_entry() before ocfs2_journal_access_di(). 
If ocfs2_delete_entry() succeeded and ocfs2_journal_access_di() 
failed, there would be a inconsistency: the file is deleted 
from orphan dir, but orphan dir dinode is not updated.

So, need to call ocfs2_journal_access_di() before ocfs2_orphan_del().

Signed-off-by: Younger Liu <younger.liu@huawei.com>
---
 fs/ocfs2/namei.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 087c58b..e3fce49 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2102,17 +2102,17 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 		goto leave;
 	}
 
-	/* remove it from the orphan directory */
-	status = ocfs2_delete_entry(handle, orphan_dir_inode, &lookup);
+	status = ocfs2_journal_access_di(handle,
+					 INODE_CACHE(orphan_dir_inode),
+					 orphan_dir_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
 	}
 
-	status = ocfs2_journal_access_di(handle,
-					 INODE_CACHE(orphan_dir_inode),
-					 orphan_dir_bh,
-					 OCFS2_JOURNAL_ACCESS_WRITE);
+	/* remove it from the orphan directory */
+	status = ocfs2_delete_entry(handle, orphan_dir_inode, &lookup);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
-- 
1.7.9.7
