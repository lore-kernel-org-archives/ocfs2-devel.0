From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 30 Jan 2012 13:53:21 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Fix oops in fallocate()
Message-ID: <1327960401-12623-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

fallocate() was oopsing on ocfs2 because we were passing in a
NULL file pointer.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 061591a..8f30e74 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2012,7 +2012,7 @@ static long ocfs2_fallocate(struct file *file, int mode, loff_t offset,
 	sr.l_start = (s64)offset;
 	sr.l_len = (s64)len;
 
-	return __ocfs2_change_file_space(NULL, inode, offset, cmd, &sr,
+	return __ocfs2_change_file_space(file, inode, offset, cmd, &sr,
 					 change_size);
 }
 
-- 
1.7.7.6
