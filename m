From: Adrian Bunk <bunk@kernel.org>
Date: Sun Feb 17 00:21:13 2008
Subject: [Ocfs2-devel] [2.6 patch] make ocfs2_downconvert_thread() static
Message-ID: <20080217082038.GU3848@cs181133002.pp.htv.fi>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mark.fasheh@oracle.com, kurt.hackel@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

This patch makes the needlessly global ocfs2_downconvert_thread() 
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
bdbb7c3c448132142fffd0fbb8dc71f5a9efb594 diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 351130c..841df58 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3356,7 +3356,7 @@ static int ocfs2_downconvert_thread_should_wake(struct ocfs2_super *osb)
 	return should_wake;
 }
 
-int ocfs2_downconvert_thread(void *arg)
+static int ocfs2_downconvert_thread(void *arg)
 {
 	int status = 0;
 	struct ocfs2_super *osb = arg;
