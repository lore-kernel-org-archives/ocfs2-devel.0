From: jiangyiwen <jiangyiwen@huawei.com>
Date: Sat, 25 Apr 2015 11:01:31 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: set filesytem read-only when
 ocfs2_delete_entry failed.
Message-ID: <553B038B.7090206@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_rename, it will lead to an inode with two entried(old and new)
if ocfs2_delete_entry(old) failed. Thus, filesystem will be
inconsistent.
The case is described below:
ocfs2_rename
    -> ocfs2_start_trans
    -> ocfs2_add_entry(new)
    -> ocfs2_delete_entry(old)
        -> __ocfs2_journal_access *failed* because of -ENOMEM
    -> ocfs2_commit_trans
So filesystem should be set to read-only at the moment.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
---
 fs/ocfs2/namei.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index b5c3a5e..d2b52c1 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1551,12 +1551,25 @@ static int ocfs2_rename(struct inode *old_dir,
 	status = ocfs2_find_entry(old_dentry->d_name.name,
 				  old_dentry->d_name.len, old_dir,
 				  &old_entry_lookup);
-	if (status)
+	if (status) {
+		if (!is_journal_aborted(osb->journal->j_journal)) {
+			ocfs2_error(osb->sb, "new entry %.*s is added, but old entry %.*s "
+					"is not deleted.",
+					new_dentry->d_name.len, new_dentry->d_name.name,
+					old_dentry->d_name.len, old_dentry->d_name.name);
+		}
 		goto bail;
+	}

 	status = ocfs2_delete_entry(handle, old_dir, &old_entry_lookup);
 	if (status < 0) {
 		mlog_errno(status);
+		if (!is_journal_aborted(osb->journal->j_journal)) {
+			ocfs2_error(osb->sb, "new entry %.*s is added, but old entry %.*s "
+					"is not deleted.",
+					new_dentry->d_name.len, new_dentry->d_name.name,
+					old_dentry->d_name.len, old_dentry->d_name.name);
+		}
 		goto bail;
 	}

-- 
1.8.3.4
