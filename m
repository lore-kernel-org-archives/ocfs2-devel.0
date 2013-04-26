From: Sachin Kamat <sachin.kamat@linaro.org>
Date: Fri, 26 Apr 2013 11:00:22 -0000
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/dlm: Remove redundant null pointer
	check
Message-ID: <1366973262-2730-1-git-send-email-sachin.kamat@linaro.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

kfree on a NULL pointer is a no-op. Hence remove the redundant null
pointer check.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 fs/ocfs2/dlm/dlmrecovery.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index ba1e689..5f9e476 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1498,10 +1498,8 @@ leave:
 
 	dlm_put(dlm);
 	if (ret < 0) {
-		if (buf)
-			kfree(buf);
-		if (item)
-			kfree(item);
+		kfree(buf);
+		kfree(item);
 		mlog_errno(ret);
 	}
 
-- 
1.7.9.5
