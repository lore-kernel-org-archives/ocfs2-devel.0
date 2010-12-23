From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:31:17 +0800
Subject: [Ocfs2-devel] [PATCH 34/34] ocfs2: Make the left masklogs compat.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-34-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

Since we have removed almost all of the masklogs in fs/ocfs2/*,
make the left masklogs compat.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/cluster/masklog.h |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index eac025a..7e90312 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -82,27 +82,27 @@
 
 /* bits that are frequently given and infrequently matched in the low word */
 /* NOTE: If you add a flag, you need to also update mlog.c! */
-#define ML_TCP		0x0000000000000004ULL /* net cluster/tcp.c */
-#define ML_MSG		0x0000000000000008ULL /* net network messages */
-#define ML_SOCKET	0x0000000000000010ULL /* net socket lifetime */
-#define ML_HEARTBEAT	0x0000000000000020ULL /* hb all heartbeat tracking */
-#define ML_HB_BIO	0x0000000000000040ULL /* hb io tracing */
-#define ML_DLMFS	0x0000000000000080ULL /* dlm user dlmfs */
-#define ML_DLM		0x0000000000000100ULL /* dlm general debugging */
-#define ML_DLM_DOMAIN	0x0000000000000200ULL /* dlm domain debugging */
-#define ML_DLM_THREAD	0x0000000000000400ULL /* dlm domain thread */
-#define ML_DLM_MASTER	0x0000000000000800ULL /* dlm master functions */
-#define ML_DLM_RECOVERY	0x0000000000001000ULL /* dlm master functions */
-#define ML_DLM_GLUE	0x0000000000080000ULL /* ocfs2 dlm glue layer */
-#define ML_VOTE		0x0000000001000000ULL /* ocfs2 node messaging  */
-#define ML_CONN		0x0000000004000000ULL /* net connection management */
-#define ML_QUORUM	0x0000000008000000ULL /* net connection quorum */
-#define ML_BASTS	0x0000001000000000ULL /* dlmglue asts and basts */
+#define ML_TCP		0x0000000000000001ULL /* net cluster/tcp.c */
+#define ML_MSG		0x0000000000000002ULL /* net network messages */
+#define ML_SOCKET	0x0000000000000004ULL /* net socket lifetime */
+#define ML_HEARTBEAT	0x0000000000000008ULL /* hb all heartbeat tracking */
+#define ML_HB_BIO	0x0000000000000010ULL /* hb io tracing */
+#define ML_DLMFS	0x0000000000000020ULL /* dlm user dlmfs */
+#define ML_DLM		0x0000000000000040ULL /* dlm general debugging */
+#define ML_DLM_DOMAIN	0x0000000000000080ULL /* dlm domain debugging */
+#define ML_DLM_THREAD	0x0000000000000100ULL /* dlm domain thread */
+#define ML_DLM_MASTER	0x0000000000000200ULL /* dlm master functions */
+#define ML_DLM_RECOVERY	0x0000000000000400ULL /* dlm master functions */
+#define ML_DLM_GLUE	0x0000000000000800ULL /* ocfs2 dlm glue layer */
+#define ML_VOTE		0x0000000000001000ULL /* ocfs2 node messaging  */
+#define ML_CONN		0x0000000000002000ULL /* net connection management */
+#define ML_QUORUM	0x0000000000004000ULL /* net connection quorum */
+#define ML_BASTS	0x0000000000008000ULL /* dlmglue asts and basts */
 /* bits that are infrequently given and frequently matched in the high word */
-#define ML_ERROR	0x0000000100000000ULL /* sent to KERN_ERR */
-#define ML_NOTICE	0x0000000200000000ULL /* setn to KERN_NOTICE */
-#define ML_KTHREAD	0x0000000400000000ULL /* kernel thread activity */
-#define ML_CLUSTER	0x0000001000000000ULL /* cluster stack */
+#define ML_ERROR	0x0000000000010000ULL /* sent to KERN_ERR */
+#define ML_NOTICE	0x0000000000020000ULL /* setn to KERN_NOTICE */
+#define ML_KTHREAD	0x0000000000040000ULL /* kernel thread activity */
+#define ML_CLUSTER	0x0000000000080000ULL /* cluster stack */
 
 #define MLOG_INITIAL_AND_MASK (ML_ERROR|ML_NOTICE)
 #ifndef MLOG_MASK_PREFIX
-- 
1.7.0.4
