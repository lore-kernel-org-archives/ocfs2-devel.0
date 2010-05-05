From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed,  5 May 2010 16:25:08 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/dlm: Increase o2dlm lockres hash
	size
Message-ID: <1273101908-20804-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Lockres hash size of 16KB is far too small for large filesystems (where we
have hundreds of thousands of lock resources stored in the table).
This patch increases it to 128KB.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 0102be3..4011568 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -37,7 +37,7 @@
 #define DLM_THREAD_SHUFFLE_INTERVAL    5     // flush everything every 5 passes
 #define DLM_THREAD_MS                  200   // flush at least every 200 ms
 
-#define DLM_HASH_SIZE_DEFAULT	(1 << 14)
+#define DLM_HASH_SIZE_DEFAULT	(1 << 17)
 #if DLM_HASH_SIZE_DEFAULT < PAGE_SIZE
 # define DLM_HASH_PAGES		1
 #else
-- 
1.7.0.4
