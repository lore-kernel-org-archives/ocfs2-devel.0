From: Jan Kara <jack@suse.cz>
Date: Wed, 10 Sep 2014 21:22:52 +0200
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2: Don't use MAXQUOTAS value
In-Reply-To: <1410376972-18417-1-git-send-email-jack@suse.cz>
References: <1410376972-18417-1-git-send-email-jack@suse.cz>
Message-ID: <1410376972-18417-6-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

MAXQUOTAS value defines maximum number of quota types VFS supports.
This isn't necessarily the number of types ocfs2 supports and with
addition of project quotas these two numbers stop matching. So make
ocfs2 use its private definition.

CC: Mark Fasheh <mfasheh@suse.com>
CC: Joel Becker <jlbec@evilplan.org>
CC: ocfs2-devel at oss.oracle.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/file.c         |  4 ++--
 fs/ocfs2/quota.h        |  5 ++++-
 fs/ocfs2/quota_global.c |  4 ++--
 fs/ocfs2/quota_local.c  | 33 +++++++++++++++++----------------
 fs/ocfs2/super.c        | 30 +++++++++++++++++-------------
 5 files changed, 42 insertions(+), 34 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 2930e231f3f9..0a8619a772ef 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1125,7 +1125,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 	struct buffer_head *bh = NULL;
 	handle_t *handle = NULL;
-	struct dquot *transfer_to[MAXQUOTAS] = { };
+	struct dquot *transfer_to[OCFS2_MAXQUOTAS] = { };
 	int qtype;
 
 	trace_ocfs2_setattr(inode, dentry,
@@ -1253,7 +1253,7 @@ bail:
 	brelse(bh);
 
 	/* Release quota pointers in case we acquired them */
-	for (qtype = 0; qtype < MAXQUOTAS; qtype++)
+	for (qtype = 0; qtype < OCFS2_MAXQUOTAS; qtype++)
 		dqput(transfer_to[qtype]);
 
 	if (!status && attr->ia_valid & ATTR_MODE) {
diff --git a/fs/ocfs2/quota.h b/fs/ocfs2/quota.h
index f266d67df3c6..1eae330193a6 100644
--- a/fs/ocfs2/quota.h
+++ b/fs/ocfs2/quota.h
@@ -17,6 +17,9 @@
 
 #include "ocfs2.h"
 
+/* Number of quota types we support */
+#define OCFS2_MAXQUOTAS 2
+
 /*
  * In-memory structures
  */
@@ -39,7 +42,7 @@ struct ocfs2_recovery_chunk {
 };
 
 struct ocfs2_quota_recovery {
-	struct list_head r_list[MAXQUOTAS];	/* List of chunks to recover */
+	struct list_head r_list[OCFS2_MAXQUOTAS];	/* List of chunks to recover */
 };
 
 /* In-memory structure with quota header information */
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index b990a62cff50..c93d67220887 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -336,8 +336,8 @@ void ocfs2_unlock_global_qf(struct ocfs2_mem_dqinfo *oinfo, int ex)
 int ocfs2_global_read_info(struct super_block *sb, int type)
 {
 	struct inode *gqinode = NULL;
-	unsigned int ino[MAXQUOTAS] = { USER_QUOTA_SYSTEM_INODE,
-					GROUP_QUOTA_SYSTEM_INODE };
+	unsigned int ino[OCFS2_MAXQUOTAS] = { USER_QUOTA_SYSTEM_INODE,
+					      GROUP_QUOTA_SYSTEM_INODE };
 	struct ocfs2_global_disk_dqinfo dinfo;
 	struct mem_dqinfo *info = sb_dqinfo(sb, type);
 	struct ocfs2_mem_dqinfo *oinfo = info->dqi_priv;
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 2001862bf2b1..10b653930ee2 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -166,12 +166,12 @@ static int ocfs2_read_quota_block(struct inode *inode, u64 v_block,
 /* Check whether we understand format of quota files */
 static int ocfs2_local_check_quota_file(struct super_block *sb, int type)
 {
-	unsigned int lmagics[MAXQUOTAS] = OCFS2_LOCAL_QMAGICS;
-	unsigned int lversions[MAXQUOTAS] = OCFS2_LOCAL_QVERSIONS;
-	unsigned int gmagics[MAXQUOTAS] = OCFS2_GLOBAL_QMAGICS;
-	unsigned int gversions[MAXQUOTAS] = OCFS2_GLOBAL_QVERSIONS;
-	unsigned int ino[MAXQUOTAS] = { USER_QUOTA_SYSTEM_INODE,
-					GROUP_QUOTA_SYSTEM_INODE };
+	unsigned int lmagics[OCFS2_MAXQUOTAS] = OCFS2_LOCAL_QMAGICS;
+	unsigned int lversions[OCFS2_MAXQUOTAS] = OCFS2_LOCAL_QVERSIONS;
+	unsigned int gmagics[OCFS2_MAXQUOTAS] = OCFS2_GLOBAL_QMAGICS;
+	unsigned int gversions[OCFS2_MAXQUOTAS] = OCFS2_GLOBAL_QVERSIONS;
+	unsigned int ino[OCFS2_MAXQUOTAS] = { USER_QUOTA_SYSTEM_INODE,
+					      GROUP_QUOTA_SYSTEM_INODE };
 	struct buffer_head *bh = NULL;
 	struct inode *linode = sb_dqopt(sb)->files[type];
 	struct inode *ginode = NULL;
@@ -336,7 +336,7 @@ void ocfs2_free_quota_recovery(struct ocfs2_quota_recovery *rec)
 {
 	int type;
 
-	for (type = 0; type < MAXQUOTAS; type++)
+	for (type = 0; type < OCFS2_MAXQUOTAS; type++)
 		free_recovery_list(&(rec->r_list[type]));
 	kfree(rec);
 }
@@ -382,7 +382,7 @@ static struct ocfs2_quota_recovery *ocfs2_alloc_quota_recovery(void)
 	rec = kmalloc(sizeof(struct ocfs2_quota_recovery), GFP_NOFS);
 	if (!rec)
 		return NULL;
-	for (type = 0; type < MAXQUOTAS; type++)
+	for (type = 0; type < OCFS2_MAXQUOTAS; type++)
 		INIT_LIST_HEAD(&(rec->r_list[type]));
 	return rec;
 }
@@ -392,10 +392,11 @@ struct ocfs2_quota_recovery *ocfs2_begin_quota_recovery(
 						struct ocfs2_super *osb,
 						int slot_num)
 {
-	unsigned int feature[MAXQUOTAS] = { OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
-					    OCFS2_FEATURE_RO_COMPAT_GRPQUOTA};
-	unsigned int ino[MAXQUOTAS] = { LOCAL_USER_QUOTA_SYSTEM_INODE,
-					LOCAL_GROUP_QUOTA_SYSTEM_INODE };
+	unsigned int feature[OCFS2_MAXQUOTAS] = {
+					OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
+					OCFS2_FEATURE_RO_COMPAT_GRPQUOTA};
+	unsigned int ino[OCFS2_MAXQUOTAS] = { LOCAL_USER_QUOTA_SYSTEM_INODE,
+					      LOCAL_GROUP_QUOTA_SYSTEM_INODE };
 	struct super_block *sb = osb->sb;
 	struct ocfs2_local_disk_dqinfo *ldinfo;
 	struct inode *lqinode;
@@ -412,7 +413,7 @@ struct ocfs2_quota_recovery *ocfs2_begin_quota_recovery(
 		return ERR_PTR(-ENOMEM);
 	/* First init... */
 
-	for (type = 0; type < MAXQUOTAS; type++) {
+	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
 		if (!OCFS2_HAS_RO_COMPAT_FEATURE(sb, feature[type]))
 			continue;
 		/* At this point, journal of the slot is already replayed so
@@ -589,8 +590,8 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 				struct ocfs2_quota_recovery *rec,
 				int slot_num)
 {
-	unsigned int ino[MAXQUOTAS] = { LOCAL_USER_QUOTA_SYSTEM_INODE,
-					LOCAL_GROUP_QUOTA_SYSTEM_INODE };
+	unsigned int ino[OCFS2_MAXQUOTAS] = { LOCAL_USER_QUOTA_SYSTEM_INODE,
+					      LOCAL_GROUP_QUOTA_SYSTEM_INODE };
 	struct super_block *sb = osb->sb;
 	struct ocfs2_local_disk_dqinfo *ldinfo;
 	struct buffer_head *bh;
@@ -604,7 +605,7 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 	       "slot %u\n", osb->dev_str, slot_num);
 
 	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
-	for (type = 0; type < MAXQUOTAS; type++) {
+	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
 		if (list_empty(&(rec->r_list[type])))
 			continue;
 		trace_ocfs2_finish_quota_recovery(slot_num);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index ddb662b32447..aa35d6309b93 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -899,11 +899,12 @@ static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend)
 {
 	int type;
 	struct super_block *sb = osb->sb;
-	unsigned int feature[MAXQUOTAS] = { OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
-					     OCFS2_FEATURE_RO_COMPAT_GRPQUOTA};
+	unsigned int feature[OCFS2_MAXQUOTAS] = {
+					OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
+					OCFS2_FEATURE_RO_COMPAT_GRPQUOTA};
 	int status = 0;
 
-	for (type = 0; type < MAXQUOTAS; type++) {
+	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
 		if (!OCFS2_HAS_RO_COMPAT_FEATURE(sb, feature[type]))
 			continue;
 		if (unsuspend)
@@ -927,17 +928,19 @@ static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend)
 
 static int ocfs2_enable_quotas(struct ocfs2_super *osb)
 {
-	struct inode *inode[MAXQUOTAS] = { NULL, NULL };
+	struct inode *inode[OCFS2_MAXQUOTAS] = { NULL, NULL };
 	struct super_block *sb = osb->sb;
-	unsigned int feature[MAXQUOTAS] = { OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
-					     OCFS2_FEATURE_RO_COMPAT_GRPQUOTA};
-	unsigned int ino[MAXQUOTAS] = { LOCAL_USER_QUOTA_SYSTEM_INODE,
+	unsigned int feature[OCFS2_MAXQUOTAS] = {
+					OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
+					OCFS2_FEATURE_RO_COMPAT_GRPQUOTA};
+	unsigned int ino[OCFS2_MAXQUOTAS] = {
+					LOCAL_USER_QUOTA_SYSTEM_INODE,
 					LOCAL_GROUP_QUOTA_SYSTEM_INODE };
 	int status;
 	int type;
 
 	sb_dqopt(sb)->flags |= DQUOT_QUOTA_SYS_FILE | DQUOT_NEGATIVE_USAGE;
-	for (type = 0; type < MAXQUOTAS; type++) {
+	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
 		if (!OCFS2_HAS_RO_COMPAT_FEATURE(sb, feature[type]))
 			continue;
 		inode[type] = ocfs2_get_system_file_inode(osb, ino[type],
@@ -952,12 +955,12 @@ static int ocfs2_enable_quotas(struct ocfs2_super *osb)
 			goto out_quota_off;
 	}
 
-	for (type = 0; type < MAXQUOTAS; type++)
+	for (type = 0; type < OCFS2_MAXQUOTAS; type++)
 		iput(inode[type]);
 	return 0;
 out_quota_off:
 	ocfs2_disable_quotas(osb);
-	for (type = 0; type < MAXQUOTAS; type++)
+	for (type = 0; type < OCFS2_MAXQUOTAS; type++)
 		iput(inode[type]);
 	mlog_errno(status);
 	return status;
@@ -972,7 +975,7 @@ static void ocfs2_disable_quotas(struct ocfs2_super *osb)
 
 	/* We mostly ignore errors in this function because there's not much
 	 * we can do when we see them */
-	for (type = 0; type < MAXQUOTAS; type++) {
+	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
 		if (!sb_has_quota_loaded(sb, type))
 			continue;
 		/* Cancel periodic syncing before we grab dqonoff_mutex */
@@ -993,8 +996,9 @@ static void ocfs2_disable_quotas(struct ocfs2_super *osb)
 /* Handle quota on quotactl */
 static int ocfs2_quota_on(struct super_block *sb, int type, int format_id)
 {
-	unsigned int feature[MAXQUOTAS] = { OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
-					     OCFS2_FEATURE_RO_COMPAT_GRPQUOTA};
+	unsigned int feature[OCFS2_MAXQUOTAS] = {
+					OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
+					OCFS2_FEATURE_RO_COMPAT_GRPQUOTA};
 
 	if (!OCFS2_HAS_RO_COMPAT_FEATURE(sb, feature[type]))
 		return -EINVAL;
-- 
1.8.1.4
