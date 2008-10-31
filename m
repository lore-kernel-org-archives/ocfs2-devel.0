From: Jan Kara <jack@suse.cz>
Date: Fri, 31 Oct 2008 07:39:04 +0100
Subject: [Ocfs2-devel] [PATCH 14/27] quota: Allow negative usage of space
	and inodes
In-Reply-To: <122543515838-git-send-email-jack@suse.cz>
References: y <12254351572189-git-send-email-jack@suse.cz>
	<12254351571914-git-send-email-jack@suse.cz>
	<1225435157625-git-send-email-jack@suse.cz>
	<1225435157218-git-send-email-jack@suse.cz>
	<12254351571677-git-send-email-jack@suse.cz>
	<1225435157894-git-send-email-jack@suse.cz>
	<12254351582004-git-send-email-jack@suse.cz>
	<12254351581363-git-send-email-jack@suse.cz>
	<12254351582759-git-send-email-jack@suse.cz>
	<12254351582523-git-send-email-jack@suse.cz>
	<12254351583984-git-send-email-jack@suse.cz>
	<12254351582475-git-send-email-jack@suse.cz>
	<12254351583997-git-send-email-jack@suse.cz>
	<122543515838-git-send-email-jack@suse.cz>
Message-ID: <1225435158192-git-send-email-jack@suse.cz>
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
index f4d6f7e..cf0dac7 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -847,7 +847,8 @@ static inline void dquot_incr_space(struct dquot *dquot, qsize_t number)
 
 static inline void dquot_decr_inodes(struct dquot *dquot, qsize_t number)
 {
-	if (dquot->dq_dqb.dqb_curinodes > number)
+	if (sb_dqopt(dquot->dq_sb)->flags & DQUOT_NEGATIVE_USAGE ||
+	    dquot->dq_dqb.dqb_curinodes >= number)
 		dquot->dq_dqb.dqb_curinodes -= number;
 	else
 		dquot->dq_dqb.dqb_curinodes = 0;
@@ -858,7 +859,8 @@ static inline void dquot_decr_inodes(struct dquot *dquot, qsize_t number)
 
 static inline void dquot_decr_space(struct dquot *dquot, qsize_t number)
 {
-	if (dquot->dq_dqb.dqb_curspace > number)
+	if (sb_dqopt(dquot->dq_sb)->flags & DQUOT_NEGATIVE_USAGE ||
+	    dquot->dq_dqb.dqb_curspace >= number)
 		dquot->dq_dqb.dqb_curspace -= number;
 	else
 		dquot->dq_dqb.dqb_curspace = 0;
diff --git a/include/linux/quota.h b/include/linux/quota.h
index e51dfdc..75bf761 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -168,7 +168,7 @@ enum {
 #include <asm/atomic.h>
 
 typedef __kernel_uid32_t qid_t; /* Type in which we store ids in memory */
-typedef __u64 qsize_t;          /* Type in which we store sizes */
+typedef long long qsize_t;	/* Type in which we store sizes */
 
 extern spinlock_t dq_data_lock;
 
@@ -336,6 +336,7 @@ enum {
 						 * responsible for setting
 						 * S_NOQUOTA, S_NOATIME flags
 						 */
+#define DQUOT_NEGATIVE_USAGE	(1 << 7)	/* Allow negative quota usage */
 
 static inline unsigned int dquot_state_flag(unsigned int flags, int type)
 {
-- 
1.5.2.4
