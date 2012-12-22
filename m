From: Xue jiufei <xuejiufei@huawei.com>
Date: Sat, 22 Dec 2012 14:52:25 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: unlock osb_super_lockres when refresh
	slot info failed
Message-ID: <50D558A9.6080701@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Function ocfs2_super_lock() actually do two jobs: applying for EX
lock of osb_super_lockres and refreshing slot info. If it happened
that a node cannot refresh slot info after acquired the lock, it will
never drop it. And other nodes who applying for osb_super_lockres will
wait for it for ever. 
  This patch drop super lock when ocfs2_refresh_slot_info() return
error.

Signed-off-by: xuejiufei <xuejiufei@huawei.com>
---
 fs/ocfs2/dlmglue.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 4f7795f..205f9eb 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2546,7 +2546,7 @@ int ocfs2_super_lock(struct ocfs2_super *osb,
 	status = ocfs2_should_refresh_lock_res(lockres);
 	if (status < 0) {
 		mlog_errno(status);
-		goto bail;
+		goto unlock;
 	}
 	if (status) {
 		status = ocfs2_refresh_slot_info(osb);
@@ -2557,6 +2557,10 @@ int ocfs2_super_lock(struct ocfs2_super *osb,
 			mlog_errno(status);
 		ocfs2_track_lock_refresh(lockres);
 	}
+unlock:
+	if (status < 0)
+		ocfs2_super_unlock(osb, ex);
+
 bail:
 	return status;
 }
-- 
1.7.8.6
