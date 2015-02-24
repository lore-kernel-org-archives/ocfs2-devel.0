From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Tue, 24 Feb 2015 19:25:49 +0900
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove goto statement in
	ocfs2_check_dir_for_entry()
Message-ID: <20150224102548.GA3371@devel.8.8.4.4>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, akpm@linux-foundation.org
Cc: jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 fs/ocfs2/dir.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index c63f2b6..b3ab2a6 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2043,22 +2043,19 @@ int ocfs2_check_dir_for_entry(struct inode *dir,
 			      const char *name,
 			      int namelen)
 {
-	int ret;
+	int ret = 0;
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 
 	trace_ocfs2_check_dir_for_entry(
 		(unsigned long long)OCFS2_I(dir)->ip_blkno, namelen, name);
 
-	ret = -EEXIST;
-	if (ocfs2_find_entry(name, namelen, dir, &lookup) == 0)
-		goto bail;
+	if (ocfs2_find_entry(name, namelen, dir, &lookup) == 0) {
+		ret = -EEXIST;
+		mlog_errno(ret);
+	}
 
-	ret = 0;
-bail:
 	ocfs2_free_dir_lookup_result(&lookup);
 
-	if (ret)
-		mlog_errno(ret);
 	return ret;
 }
 
-- 
1.7.1
