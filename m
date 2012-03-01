From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  1 Mar 2012 11:34:21 -0800
Subject: [Ocfs2-devel] [PATCH 7/9] ocfs2: Fix oops in fallocate()
In-Reply-To: <1330630463-30305-1-git-send-email-sunil.mushran@oracle.com>
References: <1330630463-30305-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1330630463-30305-7-git-send-email-sunil.mushran@oracle.com>
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
