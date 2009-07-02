From: Jeff Liu <jeff.liu@oracle.com>
Date: Thu,  2 Jul 2009 22:13:18 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] [ocfs2-devel] NET_MAX_PAYLOAD_BYTES typo?
In-Reply-To: <>
References: <>
Message-ID: <1246543998-32316-1-git-send-email-jeff.liu@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I've read fs/ocfs2/dlm/dlmcommon.h to study the structure of dlm_migratable_lockres.
However, I may find a typo for the DLM_MIG_LOCKRES_MAX_LEN,
the NET_MAX_PAYLOAD_BYTES should be O2NET_MAX_PAYLOAD_BYTES, I think.
In comments, the sizeof(net_msg) should be sizeof(o2net_msg) by referring to fs/ocfs2/cluster/tcp.h.

Signed-off-by: Jeff Liu <jeff.liu@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 0102be3..2dfe89e 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -540,7 +540,7 @@ struct dlm_master_requery
  * };
  *
  * from ../cluster/tcp.h
- *    NET_MAX_PAYLOAD_BYTES  (4096 - sizeof(net_msg))
+ *    O2NET_MAX_PAYLOAD_BYTES  (4096 - sizeof(o2net_msg))
  *    (roughly 4080 bytes)
  * and sizeof(dlm_migratable_lockres) = 112 bytes
  * and sizeof(dlm_migratable_lock) = 16 bytes
@@ -581,7 +581,7 @@ struct dlm_migratable_lockres
 
 /* from above, 128 bytes
  * for some undetermined future use */
-#define DLM_MIG_LOCKRES_RESERVED   (NET_MAX_PAYLOAD_BYTES - \
+#define DLM_MIG_LOCKRES_RESERVED   (O2NET_MAX_PAYLOAD_BYTES - \
 				    DLM_MIG_LOCKRES_MAX_LEN)
 
 struct dlm_create_lock
-- 
1.5.4.3
