From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 26 Jan 2015 11:20:47 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: fix warning 'ocfs2_orphan_del' uses
 dynamic stack allocation
Message-ID: <54C5B28F.8030704@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_orphan_del it uses dynamic stack allocation for orphan entry
name. Fix it by using dynamic heap allocation.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Xuejiufei <xuejiufei@huawei.com>
Reviewed-by: alex chen <alex.chen@huawei.com>
---
 fs/ocfs2/namei.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 873b40a..5fe3af9 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2298,18 +2298,22 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 {
 	int namelen = dio ? OCFS2_DIO_ORPHAN_PREFIX_LEN + OCFS2_ORPHAN_NAMELEN :
 			OCFS2_ORPHAN_NAMELEN;
-	char name[namelen + 1];
+	char *name;
 	struct ocfs2_dinode *orphan_fe;
 	int status = 0;
 	struct ocfs2_dir_lookup_result lookup = { NULL, };

+	name = kmalloc(namelen + 1, GFP_NOFS);
+	if (!name)
+		goto leave;
+
 	if (dio) {
 		status = snprintf(name, OCFS2_DIO_ORPHAN_PREFIX_LEN + 1, "%s",
 				OCFS2_DIO_ORPHAN_PREFIX);
 		if (status != OCFS2_DIO_ORPHAN_PREFIX_LEN) {
 			status = -EINVAL;
 			mlog_errno(status);
-			return status;
+			goto leave;
 		}

 		status = ocfs2_blkno_stringify(OCFS2_I(inode)->ip_blkno,
@@ -2357,6 +2361,7 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 	ocfs2_journal_dirty(handle, orphan_dir_bh);

 leave:
+	kfree(name);
 	ocfs2_free_dir_lookup_result(&lookup);

 	if (status)
-- 
1.8.4.3
