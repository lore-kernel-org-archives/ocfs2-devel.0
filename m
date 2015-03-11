From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 11 Mar 2015 14:27:23 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: use actual name length when find entry
	in ocfs2_orphan_del
Message-ID: <54FFE04B.8080306@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If the namelen is 20 and name only has actual length 16, it will fail
in ocfs2_find_entry because of mismatch.
So use actual name length when find entry.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
---
 fs/ocfs2/namei.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index b5c3a5e..4983740 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2322,10 +2322,10 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,

 	trace_ocfs2_orphan_del(
 	     (unsigned long long)OCFS2_I(orphan_dir_inode)->ip_blkno,
-	     name, namelen);
+	     name, strlen(name));

 	/* find it's spot in the orphan directory */
-	status = ocfs2_find_entry(name, namelen, orphan_dir_inode,
+	status = ocfs2_find_entry(name, strlen(name), orphan_dir_inode,
 				  &lookup);
 	if (status) {
 		mlog_errno(status);
-- 
1.8.4.3
