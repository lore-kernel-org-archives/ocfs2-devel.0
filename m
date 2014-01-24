From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Fri, 24 Jan 2014 12:47:07 -0800
Subject: [Ocfs2-devel] [patch 08/11] ocfs2: should call
	ocfs2_journal_access_di() before ocfs2_delete_entry() in
	ocfs2_orphan_del()
Message-ID: <20140124204708.4CAEB5A4203@corp2gmr1-2.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Younger Liu <younger.liu@huawei.com>
Subject: ocfs2: should call ocfs2_journal_access_di() before ocfs2_delete_entry() in ocfs2_orphan_del()

While deleting a file into orphan dir in ocfs2_orphan_del(), it calls
ocfs2_delete_entry() before ocfs2_journal_access_di().  If
ocfs2_delete_entry() succeeded and ocfs2_journal_access_di() failed, there
would be a inconsistency: the file is deleted from orphan dir, but orphan
dir dinode is not updated.

So we need to call ocfs2_journal_access_di() before ocfs2_orphan_del().

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Reviewed-by: Jensen <shencanquan@huawei.com>
Cc: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del
+++ a/fs/ocfs2/namei.c
@@ -2207,17 +2207,17 @@ int ocfs2_orphan_del(struct ocfs2_super
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
_
