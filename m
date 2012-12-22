From: Xue jiufei <xuejiufei@huawei.com>
Date: Sat, 22 Dec 2012 16:38:21 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: cleanup error handling in
	ocfs2_super_lock
Message-ID: <50D5717D.20205@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  There is no need to determine whether ocfs2_should_refresh_lock_res()
returns less than 0 because it never returns such a value.

Signed-off-by: xuejiufei <xuejiufei@huawei.com>
---
 fs/ocfs2/dlmglue.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 4f7795f..e35ee3e 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2544,10 +2544,6 @@ int ocfs2_super_lock(struct ocfs2_super *osb,
 	 * refreshed, so we do it here. Of course, making sense of
 	 * everything is up to the caller :) */
 	status = ocfs2_should_refresh_lock_res(lockres);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail;
-	}
 	if (status) {
 		status = ocfs2_refresh_slot_info(osb);
 
-- 
1.7.8.6
