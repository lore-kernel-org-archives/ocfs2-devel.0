From: Jan Kara <jack@suse.cz>
Date: Fri, 31 Oct 2008 07:39:05 +0100
Subject: [Ocfs2-devel] [PATCH 15/27] quota: Keep which entries were set by
	SETQUOTA quotactl
In-Reply-To: <1225435158192-git-send-email-jack@suse.cz>
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
	<1225435158192-git-send-email-jack@suse.cz>
Message-ID: <1225435158807-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Quota in a clustered environment needs to synchronize quota information
among cluster nodes. This means we have to occasionally update some
information in dquot from disk / network. On the other hand we have to
be careful not to overwrite changes administrator did via SETQUOTA.
So indicate in dquot->dq_flags which entries have been set by SETQUOTA
and quota format can clear these flags when it properly propagated
the changes.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dquot.c            |   12 ++++++++++--
 include/linux/quota.h |   26 ++++++++++++++++++++------
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index cf0dac7..6784892 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -2010,25 +2010,33 @@ static int do_set_dqblk(struct dquot *dquot, struct if_dqblk *di)
 	if (di->dqb_valid & QIF_SPACE) {
 		dm->dqb_curspace = di->dqb_curspace;
 		check_blim = 1;
+		__set_bit(DQ_LASTSET_B + QIF_SPACE_B, &dquot->dq_flags);
 	}
 	if (di->dqb_valid & QIF_BLIMITS) {
 		dm->dqb_bsoftlimit = qbtos(di->dqb_bsoftlimit);
 		dm->dqb_bhardlimit = qbtos(di->dqb_bhardlimit);
 		check_blim = 1;
+		__set_bit(DQ_LASTSET_B + QIF_BLIMITS_B, &dquot->dq_flags);
 	}
 	if (di->dqb_valid & QIF_INODES) {
 		dm->dqb_curinodes = di->dqb_curinodes;
 		check_ilim = 1;
+		__set_bit(DQ_LASTSET_B + QIF_INODES_B, &dquot->dq_flags);
 	}
 	if (di->dqb_valid & QIF_ILIMITS) {
 		dm->dqb_isoftlimit = di->dqb_isoftlimit;
 		dm->dqb_ihardlimit = di->dqb_ihardlimit;
 		check_ilim = 1;
+		__set_bit(DQ_LASTSET_B + QIF_ILIMITS_B, &dquot->dq_flags);
 	}
-	if (di->dqb_valid & QIF_BTIME)
+	if (di->dqb_valid & QIF_BTIME) {
 		dm->dqb_btime = di->dqb_btime;
-	if (di->dqb_valid & QIF_ITIME)
+		__set_bit(DQ_LASTSET_B + QIF_BTIME_B, &dquot->dq_flags);
+	}
+	if (di->dqb_valid & QIF_ITIME) {
 		dm->dqb_itime = di->dqb_itime;
+		__set_bit(DQ_LASTSET_B + QIF_ITIME_B, &dquot->dq_flags);
+	}
 
 	if (check_blim) {
 		if (!dm->dqb_bsoftlimit || dm->dqb_curspace < dm->dqb_bsoftlimit) {
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 75bf761..6d98885 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -80,12 +80,21 @@
  * Quota structure used for communication with userspace via quotactl
  * Following flags are used to specify which fields are valid
  */
-#define QIF_BLIMITS	1
-#define QIF_SPACE	2
-#define QIF_ILIMITS	4
-#define QIF_INODES	8
-#define QIF_BTIME	16
-#define QIF_ITIME	32
+enum {
+	QIF_BLIMITS_B = 0,
+	QIF_SPACE_B,
+	QIF_ILIMITS_B,
+	QIF_INODES_B,
+	QIF_BTIME_B,
+	QIF_ITIME_B,
+};
+
+#define QIF_BLIMITS	(1 << QIF_BLIMITS_B)
+#define QIF_SPACE	(1 << QIF_SPACE_B)
+#define QIF_ILIMITS	(1 << QIF_ILIMITS_B)
+#define QIF_INODES	(1 << QIF_INODES_B)
+#define QIF_BTIME	(1 << QIF_BTIME_B)
+#define QIF_ITIME	(1 << QIF_ITIME_B)
 #define QIF_LIMITS	(QIF_BLIMITS | QIF_ILIMITS)
 #define QIF_USAGE	(QIF_SPACE | QIF_INODES)
 #define QIF_TIMES	(QIF_BTIME | QIF_ITIME)
@@ -242,6 +251,11 @@ extern struct dqstats dqstats;
 #define DQ_FAKE_B	3	/* no limits only usage */
 #define DQ_READ_B	4	/* dquot was read into memory */
 #define DQ_ACTIVE_B	5	/* dquot is active (dquot_release not called) */
+#define DQ_LASTSET_B	6	/* Following 6 bits (see QIF_) are reserved\
+				 * for the mask of entries set via SETQUOTA\
+				 * quotactl. They are set under dq_data_lock\
+				 * and the quota format handling dquot can\
+				 * clear them when it sees fit. */
 
 struct dquot {
 	struct hlist_node dq_hash;	/* Hash list in memory */
-- 
1.5.2.4
