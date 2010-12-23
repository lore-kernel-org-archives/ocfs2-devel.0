From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:31:16 +0800
Subject: [Ocfs2-devel] [PATCH 33/34] ocfs2: Remove masklog ML_AIO.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-33-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

There is no user for masklog AIO, so remove it.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/cluster/masklog.c |    1 -
 fs/ocfs2/cluster/masklog.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index 89235aa..aac2251 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -91,7 +91,6 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(DLM_THREAD),
 	define_mask(DLM_MASTER),
 	define_mask(DLM_RECOVERY),
-	define_mask(AIO),
 	define_mask(DLM_GLUE),
 	define_mask(VOTE),
 	define_mask(CONN),
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index a81b883..eac025a 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -93,7 +93,6 @@
 #define ML_DLM_THREAD	0x0000000000000400ULL /* dlm domain thread */
 #define ML_DLM_MASTER	0x0000000000000800ULL /* dlm master functions */
 #define ML_DLM_RECOVERY	0x0000000000001000ULL /* dlm master functions */
-#define ML_AIO		0x0000000000002000ULL /* ocfs2 aio read and write */
 #define ML_DLM_GLUE	0x0000000000080000ULL /* ocfs2 dlm glue layer */
 #define ML_VOTE		0x0000000001000000ULL /* ocfs2 node messaging  */
 #define ML_CONN		0x0000000004000000ULL /* net connection management */
-- 
1.7.0.4
