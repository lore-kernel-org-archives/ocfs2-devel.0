From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 17 Jun 2016 22:03:16 +0200
Subject: [Ocfs2-devel] [PATCH] quota: use time64_t internally
Message-ID: <20160617200344.2096348-1-arnd@arndb.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.com>
Cc: y2038@lists.linaro.org, linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

The quota subsystem has two formats, the old v1 format using architecture
specific time_t values on the on-disk format, while the v2 format
(introduced in Linux 2.5.16 and 2.4.22) uses fixed 64-bit little-endian.

While there is no future for the v1 format beyond y2038, the v2 format
is almost there on 32-bit architectures, as both the user interface
and the on-disk format use 64-bit timestamps, just not the time_t
inbetween.

This changes the internal representation to use time64_t, which will
end up doing the right thing everywhere for v2 format.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/ocfs2/quota_global.c |  2 +-
 fs/quota/dquot.c        | 16 ++++++++--------
 include/linux/quota.h   |  4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index ab6a6cdcf91c..87e577a49b0d 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -483,7 +483,7 @@ int __ocfs2_sync_dquot(struct dquot *dquot, int freeing)
 	struct ocfs2_mem_dqinfo *info = sb_dqinfo(sb, type)->dqi_priv;
 	struct ocfs2_global_disk_dqblk dqblk;
 	s64 spacechange, inodechange;
-	time_t olditime, oldbtime;
+	time64_t olditime, oldbtime;
 
 	err = sb->s_op->quota_read(sb, type, (char *)&dqblk,
 				   sizeof(struct ocfs2_global_disk_dqblk),
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index ff21980d0119..b1322dd9d136 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1133,7 +1133,7 @@ static void dquot_decr_inodes(struct dquot *dquot, qsize_t number)
 	else
 		dquot->dq_dqb.dqb_curinodes = 0;
 	if (dquot->dq_dqb.dqb_curinodes <= dquot->dq_dqb.dqb_isoftlimit)
-		dquot->dq_dqb.dqb_itime = (time_t) 0;
+		dquot->dq_dqb.dqb_itime = (time64_t) 0;
 	clear_bit(DQ_INODES_B, &dquot->dq_flags);
 }
 
@@ -1145,7 +1145,7 @@ static void dquot_decr_space(struct dquot *dquot, qsize_t number)
 	else
 		dquot->dq_dqb.dqb_curspace = 0;
 	if (dquot->dq_dqb.dqb_curspace <= dquot->dq_dqb.dqb_bsoftlimit)
-		dquot->dq_dqb.dqb_btime = (time_t) 0;
+		dquot->dq_dqb.dqb_btime = (time64_t) 0;
 	clear_bit(DQ_BLKS_B, &dquot->dq_flags);
 }
 
@@ -1292,7 +1292,7 @@ static int check_idq(struct dquot *dquot, qsize_t inodes,
 	if (dquot->dq_dqb.dqb_isoftlimit &&
 	    newinodes > dquot->dq_dqb.dqb_isoftlimit &&
 	    dquot->dq_dqb.dqb_itime &&
-	    get_seconds() >= dquot->dq_dqb.dqb_itime &&
+	    ktime_get_real_seconds() >= dquot->dq_dqb.dqb_itime &&
             !ignore_hardlimit(dquot)) {
 		prepare_warning(warn, dquot, QUOTA_NL_ISOFTLONGWARN);
 		return -EDQUOT;
@@ -1302,7 +1302,7 @@ static int check_idq(struct dquot *dquot, qsize_t inodes,
 	    newinodes > dquot->dq_dqb.dqb_isoftlimit &&
 	    dquot->dq_dqb.dqb_itime == 0) {
 		prepare_warning(warn, dquot, QUOTA_NL_ISOFTWARN);
-		dquot->dq_dqb.dqb_itime = get_seconds() +
+		dquot->dq_dqb.dqb_itime = ktime_get_real_seconds() +
 		    sb_dqopt(dquot->dq_sb)->info[dquot->dq_id.type].dqi_igrace;
 	}
 
@@ -1334,7 +1334,7 @@ static int check_bdq(struct dquot *dquot, qsize_t space, int prealloc,
 	if (dquot->dq_dqb.dqb_bsoftlimit &&
 	    tspace > dquot->dq_dqb.dqb_bsoftlimit &&
 	    dquot->dq_dqb.dqb_btime &&
-	    get_seconds() >= dquot->dq_dqb.dqb_btime &&
+	    ktime_get_real_seconds() >= dquot->dq_dqb.dqb_btime &&
             !ignore_hardlimit(dquot)) {
 		if (!prealloc)
 			prepare_warning(warn, dquot, QUOTA_NL_BSOFTLONGWARN);
@@ -1346,7 +1346,7 @@ static int check_bdq(struct dquot *dquot, qsize_t space, int prealloc,
 	    dquot->dq_dqb.dqb_btime == 0) {
 		if (!prealloc) {
 			prepare_warning(warn, dquot, QUOTA_NL_BSOFTWARN);
-			dquot->dq_dqb.dqb_btime = get_seconds() +
+			dquot->dq_dqb.dqb_btime = ktime_get_real_seconds() +
 			    sb_dqopt(sb)->info[dquot->dq_id.type].dqi_bgrace;
 		}
 		else
@@ -2695,7 +2695,7 @@ static int do_set_dqblk(struct dquot *dquot, struct qc_dqblk *di)
 			clear_bit(DQ_BLKS_B, &dquot->dq_flags);
 		} else if (!(di->d_fieldmask & QC_SPC_TIMER))
 			/* Set grace only if user hasn't provided his own... */
-			dm->dqb_btime = get_seconds() + dqi->dqi_bgrace;
+			dm->dqb_btime = ktime_get_real_seconds() + dqi->dqi_bgrace;
 	}
 	if (check_ilim) {
 		if (!dm->dqb_isoftlimit ||
@@ -2704,7 +2704,7 @@ static int do_set_dqblk(struct dquot *dquot, struct qc_dqblk *di)
 			clear_bit(DQ_INODES_B, &dquot->dq_flags);
 		} else if (!(di->d_fieldmask & QC_INO_TIMER))
 			/* Set grace only if user hasn't provided his own... */
-			dm->dqb_itime = get_seconds() + dqi->dqi_igrace;
+			dm->dqb_itime = ktime_get_real_seconds() + dqi->dqi_igrace;
 	}
 	if (dm->dqb_bhardlimit || dm->dqb_bsoftlimit || dm->dqb_ihardlimit ||
 	    dm->dqb_isoftlimit)
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 9dfb6bce8c9e..8486d27cf360 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -200,8 +200,8 @@ struct mem_dqblk {
 	qsize_t dqb_ihardlimit;	/* absolute limit on allocated inodes */
 	qsize_t dqb_isoftlimit;	/* preferred inode limit */
 	qsize_t dqb_curinodes;	/* current # allocated inodes */
-	time_t dqb_btime;	/* time limit for excessive disk use */
-	time_t dqb_itime;	/* time limit for excessive inode use */
+	time64_t dqb_btime;	/* time limit for excessive disk use */
+	time64_t dqb_itime;	/* time limit for excessive inode use */
 };
 
 /*
-- 
2.9.0
