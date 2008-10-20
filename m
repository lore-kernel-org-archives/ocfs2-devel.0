From: Jan Kara <jack@suse.cz>
Date: Mon, 20 Oct 2008 19:23:46 +0200
Subject: [Ocfs2-devel] [PATCH] quota: Allow negative usage of space and
	inodes
In-Reply-To: y
References: y
Message-ID: <1224523442371-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

For clustered filesystems, it can happen that space / inode usage goes
negative temporarily (because some node is allocating another node
is freeing and they are not completely in sync). So let quota code
allow this and change qsize_t so a signed type so that we don't
underflow the variables.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dquot.c            |    6 ++++--
 include/linux/quota.h |    3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index 904bd67..f4258fe 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -845,7 +845,8 @@ static inline void dquot_incr_space(struct dquot *dquot, qsize_t number)
 
 static inline void dquot_decr_inodes(struct dquot *dquot, qsize_t number)
 {
-	if (dquot->dq_dqb.dqb_curinodes > number)
+	if (sb_dqopt(dquot->dq_sb)->flags & DQUOT_NEGATIVE_USAGE ||
+	    dquot->dq_dqb.dqb_curinodes >= number)
 		dquot->dq_dqb.dqb_curinodes -= number;
 	else
 		dquot->dq_dqb.dqb_curinodes = 0;
@@ -856,7 +857,8 @@ static inline void dquot_decr_inodes(struct dquot *dquot, qsize_t number)
 
 static inline void dquot_decr_space(struct dquot *dquot, qsize_t number)
 {
-	if (dquot->dq_dqb.dqb_curspace > number)
+	if (sb_dqopt(dquot->dq_sb)->flags & DQUOT_NEGATIVE_USAGE ||
+	    dquot->dq_dqb.dqb_curspace >= number)
 		dquot->dq_dqb.dqb_curspace -= number;
 	else
 		dquot->dq_dqb.dqb_curspace = 0;
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 3dca22c..597e8e9 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -170,7 +170,7 @@ enum {
 #include <asm/atomic.h>
 
 typedef __kernel_uid32_t qid_t; /* Type in which we store ids in memory */
-typedef __u64 qsize_t;          /* Type in which we store sizes */
+typedef __s64 qsize_t;          /* Type in which we store sizes */
 
 extern spinlock_t dq_data_lock;
 
@@ -341,6 +341,7 @@ enum {
 						 * responsible for setting
 						 * S_NOQUOTA, S_NOATIME flags
 						 */
+#define DQUOT_NEGATIVE_USAGE	(1 << 7)	/* Allow negative quota usage */
 
 static inline unsigned int dquot_state_flag(unsigned int flags, int type)
 {
-- 
1.5.2.4
