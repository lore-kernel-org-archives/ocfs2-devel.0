From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Fri, 21 Aug 2015 14:40:52 -0700
Subject: [Ocfs2-devel] [patch 01/24] ocfs2: set filesytem read-only when
 ocfs2_delete_entry failed.
Message-ID: <55d79ae4.m3H+UDNIIgjRg5aT%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2: set filesytem read-only when ocfs2_delete_entry failed.

In ocfs2_rename, it will lead to an inode with two entried(old and new) if
ocfs2_delete_entry(old) failed.  Thus, filesystem will be inconsistent.

The case is described below:

ocfs2_rename
    -> ocfs2_start_trans
    -> ocfs2_add_entry(new)
    -> ocfs2_delete_entry(old)
        -> __ocfs2_journal_access *failed* because of -ENOMEM
    -> ocfs2_commit_trans

So filesystem should be set to read-only at the moment.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/namei.c~ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed
+++ a/fs/ocfs2/namei.c
@@ -1544,12 +1544,25 @@ static int ocfs2_rename(struct inode *ol
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
 
_
