From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 27 Jan 2016 11:38:46 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: fix a typo in dlmcommon.h
Message-ID: <56A83BC6.2090205@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Refer to cluster/tcp.h, NET_MAX_PAYLOAD_BYTES is a typo for
O2NET_MAX_PAYLOAD_BYTES.
Since currently DLM_MIG_LOCKRES_RESERVED is not actually used, it won't
cause any problem. But we'd better correct it for further use.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlm/dlmcommon.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 0fe5f50..1d2add6 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -548,7 +548,7 @@ struct dlm_master_requery
  * };
  *
  * from ../cluster/tcp.h
- *    NET_MAX_PAYLOAD_BYTES  (4096 - sizeof(net_msg))
+ *    O2NET_MAX_PAYLOAD_BYTES  (4096 - sizeof(net_msg))
  *    (roughly 4080 bytes)
  * and sizeof(dlm_migratable_lockres) = 112 bytes
  * and sizeof(dlm_migratable_lock) = 16 bytes
@@ -589,7 +589,7 @@ struct dlm_migratable_lockres

 /* from above, 128 bytes
  * for some undetermined future use */
-#define DLM_MIG_LOCKRES_RESERVED   (NET_MAX_PAYLOAD_BYTES - \
+#define DLM_MIG_LOCKRES_RESERVED   (O2NET_MAX_PAYLOAD_BYTES - \
 				    DLM_MIG_LOCKRES_MAX_LEN)

 struct dlm_create_lock
-- 
1.8.4.3
