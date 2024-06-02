Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2380C134C4
	for <ocfs2-devel@lists.linux.dev>; Sun,  2 Jun 2024 11:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717327259; cv=none; b=holqnnDrPZuMJTsyYZNIkqo1MnSGDaKXBXKIV7n/wfgDnQdqERhKvWky/ZyXLyDYM0TOFLxiTO1hoP2kGAR7zTcdviXEMjyO0+1Uu3cquKD4RsLhqVQoUH0rlgmmuPSZhjiaVuvleLBKnX+3Q3Ehn5hcTppMx3vo3zQLNlatOsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717327259; c=relaxed/simple;
	bh=nfipXI94TymEn+qEqBsooHnP2eYjxA86tpwL5xx8DaY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jnODqvX9LPFHH7nqov69lNk+QGX//Nw6Fb6iaDkiVE4TfKb6zudq4mcDkYHdBHTgQE38JyGR0EROCK7O7ZAP4yG0mU1TQCNeKyPhXZ9I9UfMX0Tjib2NGKsfE/2wOTg0y8UXsPqSNpuku4HRxk2xVFpCAz0LMoIF2HZFPi35ICQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=MZ48sXGG; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="MZ48sXGG"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1717327248; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=UZu7hMZ3yAcOjo3fr/MnkPuAfXWqV/PzDBww8xuoW7Y=;
	b=MZ48sXGGHJ7dOcsrccAhEDFta1tpH5FLWfu7B5lJ2LmOAVbESbbs9o6cg/0lrAU5brGxqEo76vFCDuxaSdeup1MFZ4mrrrZitmNGM2hnCIobJLc2WASrFy03lw7I4BqdNXsq9oc5vQBGh7+LgS3eRh2N/XyJNvqKN2MPZxgTwvY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067109;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0W7eWwLp_1717327245;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0W7eWwLp_1717327245)
          by smtp.aliyun-inc.com;
          Sun, 02 Jun 2024 19:20:46 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: ocfs2-devel@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Subject: [PATCH v2 2/2] ocfs2: fix NULL pointer dereference in ocfs2_abort_trigger()
Date: Sun,  2 Jun 2024 19:20:45 +0800
Message-Id: <20240602112045.1112708-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240530110630.3933832-2-joseph.qi@linux.alibaba.com>
References: <20240530110630.3933832-2-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bdev->bd_super has been removed and commit 8887b94d9322 change the usage
from bdev->bd_super to b_assoc_map->host->i_sb. Since ocfs2 hasn't set
bh->b_assoc_map, it will trigger NULL pointer dereference when calling
into ocfs2_abort_trigger().

Actually this was pointed out in history, see commit 74e364ad1b13. But
I've made a mistake when reviewing commit 8887b94d9322 and then
re-introduce this regression.

Since we cannot revive bdev in buffer head, so fix this issue by
initializing all types of ocfs2 triggers when fill super, and then get
the specific ocfs2 trigger from ocfs2_caching_info when access journal.

Fixes: 8887b94d9322 ("ocfs2: stop using bdev->bd_super for journal error logging")
Cc: stable@vger.kernel.org # 6.6+
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/journal.c | 182 +++++++++++++++++++++++++--------------------
 fs/ocfs2/ocfs2.h   |  27 +++++++
 fs/ocfs2/super.c   |   4 +-
 3 files changed, 131 insertions(+), 82 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 27c7683c7d3f..86807086b2df 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -479,12 +479,6 @@ int ocfs2_allocate_extend_trans(handle_t *handle, int thresh)
 	return status;
 }
 
-
-struct ocfs2_triggers {
-	struct jbd2_buffer_trigger_type	ot_triggers;
-	int				ot_offset;
-};
-
 static inline struct ocfs2_triggers *to_ocfs2_trigger(struct jbd2_buffer_trigger_type *triggers)
 {
 	return container_of(triggers, struct ocfs2_triggers, ot_triggers);
@@ -548,85 +542,76 @@ static void ocfs2_db_frozen_trigger(struct jbd2_buffer_trigger_type *triggers,
 static void ocfs2_abort_trigger(struct jbd2_buffer_trigger_type *triggers,
 				struct buffer_head *bh)
 {
+	struct ocfs2_triggers *ot = to_ocfs2_trigger(triggers);
+
 	mlog(ML_ERROR,
 	     "ocfs2_abort_trigger called by JBD2.  bh = 0x%lx, "
 	     "bh->b_blocknr = %llu\n",
 	     (unsigned long)bh,
 	     (unsigned long long)bh->b_blocknr);
 
-	ocfs2_error(bh->b_assoc_map->host->i_sb,
+	ocfs2_error(ot->sb,
 		    "JBD2 has aborted our journal, ocfs2 cannot continue\n");
 }
 
-static struct ocfs2_triggers di_triggers = {
-	.ot_triggers = {
-		.t_frozen = ocfs2_frozen_trigger,
-		.t_abort = ocfs2_abort_trigger,
-	},
-	.ot_offset	= offsetof(struct ocfs2_dinode, i_check),
-};
-
-static struct ocfs2_triggers eb_triggers = {
-	.ot_triggers = {
-		.t_frozen = ocfs2_frozen_trigger,
-		.t_abort = ocfs2_abort_trigger,
-	},
-	.ot_offset	= offsetof(struct ocfs2_extent_block, h_check),
-};
-
-static struct ocfs2_triggers rb_triggers = {
-	.ot_triggers = {
-		.t_frozen = ocfs2_frozen_trigger,
-		.t_abort = ocfs2_abort_trigger,
-	},
-	.ot_offset	= offsetof(struct ocfs2_refcount_block, rf_check),
-};
-
-static struct ocfs2_triggers gd_triggers = {
-	.ot_triggers = {
-		.t_frozen = ocfs2_frozen_trigger,
-		.t_abort = ocfs2_abort_trigger,
-	},
-	.ot_offset	= offsetof(struct ocfs2_group_desc, bg_check),
-};
-
-static struct ocfs2_triggers db_triggers = {
-	.ot_triggers = {
-		.t_frozen = ocfs2_db_frozen_trigger,
-		.t_abort = ocfs2_abort_trigger,
-	},
-};
+static void ocfs2_setup_csum_triggers(struct super_block *sb,
+				      enum ocfs2_journal_trigger_type type,
+				      struct ocfs2_triggers *ot)
+{
+	BUG_ON(type >= OCFS2_JOURNAL_TRIGGER_COUNT);
 
-static struct ocfs2_triggers xb_triggers = {
-	.ot_triggers = {
-		.t_frozen = ocfs2_frozen_trigger,
-		.t_abort = ocfs2_abort_trigger,
-	},
-	.ot_offset	= offsetof(struct ocfs2_xattr_block, xb_check),
-};
+	switch (type) {
+	case OCFS2_JTR_DI:
+		ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
+		ot->ot_offset = offsetof(struct ocfs2_dinode, i_check);
+		break;
+	case OCFS2_JTR_EB:
+		ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
+		ot->ot_offset = offsetof(struct ocfs2_extent_block, h_check);
+		break;
+	case OCFS2_JTR_RB:
+		ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
+		ot->ot_offset = offsetof(struct ocfs2_refcount_block, rf_check);
+		break;
+	case OCFS2_JTR_GD:
+		ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
+		ot->ot_offset = offsetof(struct ocfs2_group_desc, bg_check);
+		break;
+	case OCFS2_JTR_DB:
+		ot->ot_triggers.t_frozen = ocfs2_db_frozen_trigger;
+		break;
+	case OCFS2_JTR_XB:
+		ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
+		ot->ot_offset = offsetof(struct ocfs2_xattr_block, xb_check);
+		break;
+	case OCFS2_JTR_DQ:
+		ot->ot_triggers.t_frozen = ocfs2_dq_frozen_trigger;
+		break;
+	case OCFS2_JTR_DR:
+		ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
+		ot->ot_offset = offsetof(struct ocfs2_dx_root_block, dr_check);
+		break;
+	case OCFS2_JTR_DL:
+		ot->ot_triggers.t_frozen = ocfs2_frozen_trigger;
+		ot->ot_offset = offsetof(struct ocfs2_dx_leaf, dl_check);
+		break;
+	case OCFS2_JTR_NONE:
+		/* To make compiler happy... */
+		return;
+	}
 
-static struct ocfs2_triggers dq_triggers = {
-	.ot_triggers = {
-		.t_frozen = ocfs2_dq_frozen_trigger,
-		.t_abort = ocfs2_abort_trigger,
-	},
-};
+	ot->ot_triggers.t_abort = ocfs2_abort_trigger;
+	ot->sb = sb;
+}
 
-static struct ocfs2_triggers dr_triggers = {
-	.ot_triggers = {
-		.t_frozen = ocfs2_frozen_trigger,
-		.t_abort = ocfs2_abort_trigger,
-	},
-	.ot_offset	= offsetof(struct ocfs2_dx_root_block, dr_check),
-};
+void ocfs2_initialize_journal_triggers(struct super_block *sb,
+				       struct ocfs2_triggers triggers[])
+{
+	enum ocfs2_journal_trigger_type type;
 
-static struct ocfs2_triggers dl_triggers = {
-	.ot_triggers = {
-		.t_frozen = ocfs2_frozen_trigger,
-		.t_abort = ocfs2_abort_trigger,
-	},
-	.ot_offset	= offsetof(struct ocfs2_dx_leaf, dl_check),
-};
+	for (type = OCFS2_JTR_DI; type < OCFS2_JOURNAL_TRIGGER_COUNT; type++)
+		ocfs2_setup_csum_triggers(sb, type, &triggers[type]);
+}
 
 static int __ocfs2_journal_access(handle_t *handle,
 				  struct ocfs2_caching_info *ci,
@@ -708,56 +693,91 @@ static int __ocfs2_journal_access(handle_t *handle,
 int ocfs2_journal_access_di(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, ci, bh, &di_triggers, type);
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
+
+	return __ocfs2_journal_access(handle, ci, bh,
+				      &osb->s_journal_triggers[OCFS2_JTR_DI],
+				      type);
 }
 
 int ocfs2_journal_access_eb(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, ci, bh, &eb_triggers, type);
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
+
+	return __ocfs2_journal_access(handle, ci, bh,
+				      &osb->s_journal_triggers[OCFS2_JTR_EB],
+				      type);
 }
 
 int ocfs2_journal_access_rb(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, ci, bh, &rb_triggers,
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
+
+	return __ocfs2_journal_access(handle, ci, bh,
+				      &osb->s_journal_triggers[OCFS2_JTR_RB],
 				      type);
 }
 
 int ocfs2_journal_access_gd(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, ci, bh, &gd_triggers, type);
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
+
+	return __ocfs2_journal_access(handle, ci, bh,
+				     &osb->s_journal_triggers[OCFS2_JTR_GD],
+				     type);
 }
 
 int ocfs2_journal_access_db(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, ci, bh, &db_triggers, type);
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
+
+	return __ocfs2_journal_access(handle, ci, bh,
+				     &osb->s_journal_triggers[OCFS2_JTR_DB],
+				     type);
 }
 
 int ocfs2_journal_access_xb(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, ci, bh, &xb_triggers, type);
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
+
+	return __ocfs2_journal_access(handle, ci, bh,
+				     &osb->s_journal_triggers[OCFS2_JTR_XB],
+				     type);
 }
 
 int ocfs2_journal_access_dq(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, ci, bh, &dq_triggers, type);
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
+
+	return __ocfs2_journal_access(handle, ci, bh,
+				     &osb->s_journal_triggers[OCFS2_JTR_DQ],
+				     type);
 }
 
 int ocfs2_journal_access_dr(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, ci, bh, &dr_triggers, type);
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
+
+	return __ocfs2_journal_access(handle, ci, bh,
+				     &osb->s_journal_triggers[OCFS2_JTR_DR],
+				     type);
 }
 
 int ocfs2_journal_access_dl(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
-	return __ocfs2_journal_access(handle, ci, bh, &dl_triggers, type);
+	struct ocfs2_super *osb = OCFS2_SB(ocfs2_metadata_cache_get_super(ci));
+
+	return __ocfs2_journal_access(handle, ci, bh,
+				     &osb->s_journal_triggers[OCFS2_JTR_DL],
+				     type);
 }
 
 int ocfs2_journal_access(handle_t *handle, struct ocfs2_caching_info *ci,
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index a503c553bab2..8fe826143d7b 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -284,6 +284,30 @@ enum ocfs2_mount_options
 #define OCFS2_OSB_ERROR_FS	0x0004
 #define OCFS2_DEFAULT_ATIME_QUANTUM	60
 
+struct ocfs2_triggers {
+	struct jbd2_buffer_trigger_type	ot_triggers;
+	int				ot_offset;
+	struct super_block		*sb;
+};
+
+enum ocfs2_journal_trigger_type {
+	OCFS2_JTR_DI,
+	OCFS2_JTR_EB,
+	OCFS2_JTR_RB,
+	OCFS2_JTR_GD,
+	OCFS2_JTR_DB,
+	OCFS2_JTR_XB,
+	OCFS2_JTR_DQ,
+	OCFS2_JTR_DR,
+	OCFS2_JTR_DL,
+	OCFS2_JTR_NONE  /* This must be the last entry */
+};
+
+#define OCFS2_JOURNAL_TRIGGER_COUNT OCFS2_JTR_NONE
+
+void ocfs2_initialize_journal_triggers(struct super_block *sb,
+				       struct ocfs2_triggers triggers[]);
+
 struct ocfs2_journal;
 struct ocfs2_slot_info;
 struct ocfs2_recovery_map;
@@ -351,6 +375,9 @@ struct ocfs2_super
 	struct ocfs2_journal *journal;
 	unsigned long osb_commit_interval;
 
+	/* Journal triggers for checksum */
+	struct ocfs2_triggers s_journal_triggers[OCFS2_JOURNAL_TRIGGER_COUNT];
+
 	struct delayed_work		la_enable_wq;
 
 	/*
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 8aabaed2c1cb..afee70125ae3 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1075,9 +1075,11 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	debugfs_create_file("fs_state", S_IFREG|S_IRUSR, osb->osb_debug_root,
 			    osb, &ocfs2_osb_debug_fops);
 
-	if (ocfs2_meta_ecc(osb))
+	if (ocfs2_meta_ecc(osb)) {
+		ocfs2_initialize_journal_triggers(sb, osb->s_journal_triggers);
 		ocfs2_blockcheck_stats_debugfs_install( &osb->osb_ecc_stats,
 							osb->osb_debug_root);
+	}
 
 	status = ocfs2_mount_volume(sb);
 	if (status < 0)
-- 
2.39.3

