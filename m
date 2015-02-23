From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Mon, 23 Feb 2015 19:39:11 +0900
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: need to handle error for
 ocfs2_journal_access_di() call
Message-ID: <20150223103911.GA16889@devel.8.8.4.4>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, akpm@linux-foundation.org
Cc: jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

There is no error handle when ocfs2_journal_access_di() is failed.
And also it doesn't need to call ocfs2_dx_dir_insert() when
ocfs2_journal_access_db() is failed.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 fs/ocfs2/dir.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index c1ab24f..c63f2b6 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1703,15 +1703,15 @@ int __ocfs2_add_entry(handle_t *handle,
 								 insert_bh,
 					      OCFS2_JOURNAL_ACCESS_WRITE);
 
-				if (ocfs2_dir_indexed(dir)) {
+				if (!retval && ocfs2_dir_indexed(dir))
 					retval = ocfs2_dx_dir_insert(dir,
 								handle,
 								lookup);
-					if (retval)
-						goto bail;
-				}
 			}
 
+			if (retval)
+				goto bail;
+
 			/* By now the buffer is marked for journaling */
 			offset += le16_to_cpu(de->rec_len);
 			if (le64_to_cpu(de->inode)) {
-- 
1.7.1
