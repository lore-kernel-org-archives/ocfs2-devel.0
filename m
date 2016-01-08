From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 8 Jan 2016 14:55:11 +0800
Subject: [Ocfs2-devel] ocfs2/dlm: cleanup redunant lksb flags in dlmcommon.h
Message-ID: <568F5D4F.80208@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

lksb flags are defined both in dlmapi.h and dlmcommon.h. So clean them
up from dlmcommon.h.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jiufei Xue <xuejiufei@huawei.com>
---
 fs/ocfs2/dlm/dlmcommon.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index e88ccf8..68c607e 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -376,17 +376,6 @@ struct dlm_lock
 		 lksb_kernel_allocated:1;
 };

-
-#define DLM_LKSB_UNUSED1           0x01
-#define DLM_LKSB_PUT_LVB           0x02
-#define DLM_LKSB_GET_LVB           0x04
-#define DLM_LKSB_UNUSED2           0x08
-#define DLM_LKSB_UNUSED3           0x10
-#define DLM_LKSB_UNUSED4           0x20
-#define DLM_LKSB_UNUSED5           0x40
-#define DLM_LKSB_UNUSED6           0x80
-
-
 enum dlm_lockres_list {
 	DLM_GRANTED_LIST = 0,
 	DLM_CONVERTING_LIST = 1,
-- 
1.8.4.3
