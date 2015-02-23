From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Mon, 23 Feb 2015 19:38:45 +0900
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: remove extra mlog_errno() call in
 __ocfs2_add_entry()
Message-ID: <20150223103845.GA16884@devel.8.8.4.4>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, akpm@linux-foundation.org
Cc: jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 fs/ocfs2/dir.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 1478a50..c1ab24f 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1689,10 +1689,8 @@ int __ocfs2_add_entry(handle_t *handle,
 		if (ocfs2_dirent_would_fit(de, rec_len)) {
 			dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 			retval = ocfs2_mark_inode_dirty(handle, dir, parent_fe_bh);
-			if (retval < 0) {
-				mlog_errno(retval);
+			if (retval < 0)
 				goto bail;
-			}
 
 			if (insert_bh == parent_fe_bh)
 				retval = ocfs2_journal_access_di(handle,
@@ -1709,10 +1707,8 @@ int __ocfs2_add_entry(handle_t *handle,
 					retval = ocfs2_dx_dir_insert(dir,
 								handle,
 								lookup);
-					if (retval) {
-						mlog_errno(retval);
+					if (retval)
 						goto bail;
-					}
 				}
 			}
 
-- 
1.7.1
