From: Jan Kara <jack@suse.cz>
Date: Fri, 31 Oct 2008 07:38:54 +0100
Subject: [Ocfs2-devel] [PATCH 04/27] quota: Make _SUSPENDED just a flag
In-Reply-To: <1225435157218-git-send-email-jack@suse.cz>
References: y <12254351572189-git-send-email-jack@suse.cz>
	<12254351571914-git-send-email-jack@suse.cz>
	<1225435157625-git-send-email-jack@suse.cz>
	<1225435157218-git-send-email-jack@suse.cz>
Message-ID: <12254351571677-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Upto now, DQUOT_USR_SUSPENDED behaved like a state - i.e., either quota
was enabled or suspended or none. Now allowed states are 0, ENABLED,
ENABLED | SUSPENDED. This will be useful later when we implement separate
enabling of quota usage tracking and limits enforcement because we need to
keep track of a state which has been suspended.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dquot.c               |   10 ++++++----
 include/linux/quotaops.h |    6 ++++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index 735e2c3..1f9f1f1 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -1570,18 +1570,20 @@ static inline void reset_enable_flags(struct quota_info *dqopt, int type,
 {
 	switch (type) {
 		case USRQUOTA:
-			dqopt->flags &= ~DQUOT_USR_ENABLED;
 			if (remount)
 				dqopt->flags |= DQUOT_USR_SUSPENDED;
-			else
+			else {
+				dqopt->flags &= ~DQUOT_USR_ENABLED;
 				dqopt->flags &= ~DQUOT_USR_SUSPENDED;
+			}
 			break;
 		case GRPQUOTA:
-			dqopt->flags &= ~DQUOT_GRP_ENABLED;
 			if (remount)
 				dqopt->flags |= DQUOT_GRP_SUSPENDED;
-			else
+			else {
+				dqopt->flags &= ~DQUOT_GRP_ENABLED;
 				dqopt->flags &= ~DQUOT_GRP_SUSPENDED;
+			}
 			break;
 	}
 }
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index adcc7ba..ffd9707 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -67,8 +67,10 @@ static inline struct mem_dqinfo *sb_dqinfo(struct super_block *sb, int type)
 static inline int sb_has_quota_enabled(struct super_block *sb, int type)
 {
 	if (type == USRQUOTA)
-		return sb_dqopt(sb)->flags & DQUOT_USR_ENABLED;
-	return sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED;
+		return (sb_dqopt(sb)->flags & DQUOT_USR_ENABLED)
+			&& !(sb_dqopt(sb)->flags & DQUOT_USR_SUSPENDED);
+	return (sb_dqopt(sb)->flags & DQUOT_GRP_ENABLED)
+		&& !(sb_dqopt(sb)->flags & DQUOT_GROUP_SUSPENDED);
 }
 
 static inline int sb_any_quota_enabled(struct super_block *sb)
-- 
1.5.2.4
