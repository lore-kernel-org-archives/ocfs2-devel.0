From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 20 Nov 2009 17:12:55 -0800
Subject: [Ocfs2-devel] [PATCH 08/10] ocfs2: Handle missing new quota format
In-Reply-To: <1258765977-4334-1-git-send-email-sunil.mushran@oracle.com>
References: <1258765977-4334-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258765977-4334-9-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 1ccd14b9c271c1ac6eec5c5ec5def433100e7248 changed the quota
format. This patch disables enabling the quotas feature when built on the
older EL5 kernel.

Changes introduced by mainline commits b85f4b87a511bea86dac68c4f0fabaee2cac6c4c
and e3d4d56b9715e40ded2a84d0d4fa7f3b6c58983c were also handled in this patch.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in               |    1 +
 Makefile                     |    3 ++-
 configure.in                 |    6 ++++++
 fs/ocfs2/Makefile            |    4 ++++
 fs/ocfs2/dlmglue.c           |   15 ++++++++++++---
 fs/ocfs2/file.c              |   10 ++++++++--
 fs/ocfs2/journal.c           |   17 +++++++++++++++++
 fs/ocfs2/quota.h             |   25 +++++++++++++++++++++++++
 fs/ocfs2/quota_global.c      |    3 +++
 fs/ocfs2/quota_local.c       |    3 +++
 fs/ocfs2/super.c             |   22 ++++++++++++++++++++++
 kapi-compat/include/quotas.h |   19 +++++++++++++++++++
 12 files changed, 122 insertions(+), 6 deletions(-)
 create mode 100644 kapi-compat/include/quotas.h

diff --git a/Config.make.in b/Config.make.in
index dd2e406..8675982 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -82,6 +82,7 @@ SKIP_SPLICE = @SKIP_SPLICE@
 SKIP_BUFFER_TRIGGERS = @SKIP_BUFFER_TRIGGERS@
 NO_NAME_IN_BACKING_DEV_INFO=@NO_NAME_IN_BACKING_DEV_INFO@
 NO_KOBJ_ATTRIBUTE = @NO_KOBJ_ATTRIBUTE@
+SKIP_QUOTAS= @SKIP_QUOTAS@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/Makefile b/Makefile
index 7c48788..07adc70 100644
--- a/Makefile
+++ b/Makefile
@@ -39,7 +39,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/mnt_want_write.h		\
 	kapi-compat/include/hardsect.h			\
 	kapi-compat/include/triggers.h			\
-	kapi-compat/include/compat_kobject.h
+	kapi-compat/include/compat_kobject.h		\
+	kapi-compat/include/quotas.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 22245ec..3dfe596 100644
--- a/configure.in
+++ b/configure.in
@@ -446,6 +446,12 @@ OCFS2_CHECK_KERNEL([struct kobj_attribute in kobject.h], kobject.h,
 AC_SUBST(NO_KOBJ_ATTRIBUTE)
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $NO_KOBJ_ATTRIBUTE"
 
+SKIP_QUOTAS=
+OCFS2_CHECK_KERNEL([new quota format in dqblk_qtree.h], dqblk_qtree.h,
+ , SKIP_QUOTAS=quotas.h, [#define QTREE_INIT_ALLOC])
+AC_SUBST(SKIP_QUOTAS)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $SKIP_QUOTAS"
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index c02cbee..7a03c94 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -128,6 +128,10 @@ FS_SOURCES += compat_kobject.c
 EXTRA_CFLAGS += -DNO_KOBJ_ATTRIBUTE
 endif
 
+ifdef SKIP_QUOTAS
+EXTRA_CFLAGS += -DSKIP_QUOTAS
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 0b73382..dab6b8e 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -71,7 +71,9 @@ struct ocfs2_mask_waiter {
 static struct ocfs2_super *ocfs2_get_dentry_osb(struct ocfs2_lock_res *lockres);
 static struct ocfs2_super *ocfs2_get_inode_osb(struct ocfs2_lock_res *lockres);
 static struct ocfs2_super *ocfs2_get_file_osb(struct ocfs2_lock_res *lockres);
+#ifndef SKIP_QUOTAS
 static struct ocfs2_super *ocfs2_get_qinfo_osb(struct ocfs2_lock_res *lockres);
+#endif
 
 /*
  * Return value from ->downconvert_worker functions.
@@ -108,8 +110,9 @@ static int ocfs2_dentry_convert_worker(struct ocfs2_lock_res *lockres,
 
 static void ocfs2_dentry_post_unlock(struct ocfs2_super *osb,
 				     struct ocfs2_lock_res *lockres);
-
+#ifndef SKIP_QUOTAS
 static void ocfs2_set_qinfo_lvb(struct ocfs2_lock_res *lockres);
+#endif
 
 static int ocfs2_check_refcount_downconvert(struct ocfs2_lock_res *lockres,
 					    int new_level);
@@ -277,13 +280,13 @@ static struct ocfs2_lock_res_ops ocfs2_flock_lops = {
 	.get_osb	= ocfs2_get_file_osb,
 	.flags		= 0,
 };
-
+#ifndef SKIP_QUOTAS
 static struct ocfs2_lock_res_ops ocfs2_qinfo_lops = {
 	.set_lvb	= ocfs2_set_qinfo_lvb,
 	.get_osb	= ocfs2_get_qinfo_osb,
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH | LOCK_TYPE_USES_LVB,
 };
-
+#endif
 static struct ocfs2_lock_res_ops ocfs2_refcount_block_lops = {
 	.check_downconvert = ocfs2_check_refcount_downconvert,
 	.downconvert_worker = ocfs2_refcount_convert_worker,
@@ -571,12 +574,14 @@ static struct ocfs2_super *ocfs2_get_inode_osb(struct ocfs2_lock_res *lockres)
 	return OCFS2_SB(inode->i_sb);
 }
 
+#ifndef SKIP_QUOTAS
 static struct ocfs2_super *ocfs2_get_qinfo_osb(struct ocfs2_lock_res *lockres)
 {
 	struct ocfs2_mem_dqinfo *info = lockres->l_priv;
 
 	return OCFS2_SB(info->dqi_gi.dqi_sb);
 }
+#endif
 
 static struct ocfs2_super *ocfs2_get_file_osb(struct ocfs2_lock_res *lockres)
 {
@@ -700,6 +705,7 @@ void ocfs2_file_lock_res_init(struct ocfs2_lock_res *lockres,
 	lockres->l_flags |= OCFS2_LOCK_NOCACHE;
 }
 
+#ifndef SKIP_QUOTAS
 void ocfs2_qinfo_lock_res_init(struct ocfs2_lock_res *lockres,
 			       struct ocfs2_mem_dqinfo *info)
 {
@@ -710,6 +716,7 @@ void ocfs2_qinfo_lock_res_init(struct ocfs2_lock_res *lockres,
 				   OCFS2_LOCK_TYPE_QINFO, &ocfs2_qinfo_lops,
 				   info);
 }
+#endif
 
 void ocfs2_refcount_lock_res_init(struct ocfs2_lock_res *lockres,
 				  struct ocfs2_super *osb, u64 ref_blkno,
@@ -3704,6 +3711,7 @@ static int ocfs2_refcount_convert_worker(struct ocfs2_lock_res *lockres,
 	return UNBLOCK_CONTINUE;
 }
 
+#ifndef SKIP_QUOTAS
 static void ocfs2_set_qinfo_lvb(struct ocfs2_lock_res *lockres)
 {
 	struct ocfs2_qinfo_lvb *lvb;
@@ -3815,6 +3823,7 @@ bail:
 	mlog_exit(status);
 	return status;
 }
+#endif	/* SKIP_QUOTAS */
 
 int ocfs2_refcount_lock(struct ocfs2_refcount_tree *ref_tree, int ex)
 {
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 81bd622..c729d7c 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -945,9 +945,11 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 	struct buffer_head *bh = NULL;
 	handle_t *handle = NULL;
+#ifndef SKIP_QUOTAS
 	int qtype;
 	struct dquot *transfer_from[MAXQUOTAS] = { };
 	struct dquot *transfer_to[MAXQUOTAS] = { };
+#endif
 
 	mlog_entry("(0x%p, '%.*s')\n", dentry,
 	           dentry->d_name.len, dentry->d_name.name);
@@ -1017,7 +1019,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 			goto bail_unlock;
 		}
 	}
-
+#ifndef SKIP_QUOTAS
 	if ((attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
 	    (attr->ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid)) {
 		/*
@@ -1060,6 +1062,9 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 		if (status < 0)
 			goto bail_commit;
 	} else {
+#else
+	{
+#endif	/* SKIP_QUOTAS */
 		handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
 		if (IS_ERR(handle)) {
 			status = PTR_ERR(handle);
@@ -1095,12 +1100,13 @@ bail_unlock_rw:
 bail:
 	brelse(bh);
 
+#ifndef SKIP_QUOTAS
 	/* Release quota pointers in case we acquired them */
 	for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
 		dqput(transfer_to[qtype]);
 		dqput(transfer_from[qtype]);
 	}
-
+#endif
 	if (!status && attr->ia_valid & ATTR_MODE) {
 		status = ocfs2_acl_chmod(inode);
 		if (status < 0)
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 217f30a..ab69048 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1199,7 +1199,9 @@ void ocfs2_complete_recovery(kapi_work_struct_t *work)
 	struct ocfs2_super *osb = journal->j_osb;
 	struct ocfs2_dinode *la_dinode, *tl_dinode;
 	struct ocfs2_la_recovery_item *item, *n;
+#ifndef SKIP_QUOTAS
 	struct ocfs2_quota_recovery *qrec;
+#endif
 	LIST_HEAD(tmp_la_list);
 
 	mlog_entry_void();
@@ -1247,6 +1249,7 @@ void ocfs2_complete_recovery(kapi_work_struct_t *work)
 		if (ret < 0)
 			mlog_errno(ret);
 
+#ifndef SKIP_QUOTAS
 		qrec = item->lri_qrec;
 		if (qrec) {
 			mlog(0, "Recovering quota files");
@@ -1256,6 +1259,7 @@ void ocfs2_complete_recovery(kapi_work_struct_t *work)
 				mlog_errno(ret);
 			/* Recovery info is already freed now */
 		}
+#endif
 
 		kfree(item);
 	}
@@ -1286,8 +1290,10 @@ static void ocfs2_queue_recovery_completion(struct ocfs2_journal *journal,
 		if (tl_dinode)
 			kfree(tl_dinode);
 
+#ifndef SKIP_QUOTAS
 		if (qrec)
 			ocfs2_free_quota_recovery(qrec);
+#endif
 
 		mlog_errno(-ENOMEM);
 		return;
@@ -1343,9 +1349,11 @@ static int __ocfs2_recovery_thread(void *arg)
 	int status, node_num, slot_num;
 	struct ocfs2_super *osb = arg;
 	struct ocfs2_recovery_map *rm = osb->recovery_map;
+#ifndef SKIP_QUOTAS
 	int *rm_quota = NULL;
 	int rm_quota_used = 0, i;
 	struct ocfs2_quota_recovery *qrec;
+#endif
 
 	mlog_entry_void();
 
@@ -1354,11 +1362,14 @@ static int __ocfs2_recovery_thread(void *arg)
 		goto bail;
 	}
 
+#ifndef SKIP_QUOTAS
 	rm_quota = kzalloc(osb->max_slots * sizeof(int), GFP_NOFS);
 	if (!rm_quota) {
 		status = -ENOMEM;
 		goto bail;
 	}
+#endif
+
 restart:
 	status = ocfs2_super_lock(osb, 1);
 	if (status < 0) {
@@ -1390,6 +1401,7 @@ restart:
 		}
 		mlog(0, "node %d was using slot %d\n", node_num, slot_num);
 
+#ifndef SKIP_QUOTAS
 		/* It is a bit subtle with quota recovery. We cannot do it
 		 * immediately because we have to obtain cluster locks from
 		 * quota files and we also don't want to just skip it because
@@ -1399,6 +1411,7 @@ restart:
 		for (i = 0; i < rm_quota_used && rm_quota[i] != slot_num; i++);
 		if (i == rm_quota_used)
 			rm_quota[rm_quota_used++] = slot_num;
+#endif
 
 		status = ocfs2_recover_node(osb, node_num, slot_num);
 skip_recovery:
@@ -1423,6 +1436,7 @@ skip_recovery:
 	if (status < 0)
 		mlog_errno(status);
 
+#ifndef SKIP_QUOTAS
 	/* Now it is right time to recover quotas... We have to do this under
 	 * superblock lock so that noone can start using the slot (and crash)
 	 * before we recover it */
@@ -1436,6 +1450,7 @@ skip_recovery:
 		ocfs2_queue_recovery_completion(osb->journal, rm_quota[i],
 						NULL, NULL, qrec);
 	}
+#endif
 
 	ocfs2_super_unlock(osb, 1);
 
@@ -1456,8 +1471,10 @@ bail:
 
 	mutex_unlock(&osb->recovery_lock);
 
+#ifndef SKIP_QUOTAS
 	if (rm_quota)
 		kfree(rm_quota);
+#endif
 
 	mlog_exit(status);
 	/* no one is callint kthread_stop() for us so the kthread() api
diff --git a/fs/ocfs2/quota.h b/fs/ocfs2/quota.h
index e5df9d1..a6c99de 100644
--- a/fs/ocfs2/quota.h
+++ b/fs/ocfs2/quota.h
@@ -9,6 +9,8 @@
 #ifndef _OCFS2_QUOTA_H
 #define _OCFS2_QUOTA_H
 
+#ifndef SKIP_QUOTAS
+
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/quota.h>
@@ -115,4 +117,27 @@ extern struct quota_format_type ocfs2_quota_format;
 int ocfs2_quota_setup(void);
 void ocfs2_quota_shutdown(void);
 
+#else	/* SKIP_QUOTAS */
+
+struct ocfs2_dquot {
+	unsigned long dummy;
+};
+
+struct ocfs2_quota_recovery {
+	struct list_head r_list[MAXQUOTAS];	/* List of chunks to recover */
+};
+
+struct ocfs2_quota_chunk {
+	unsigned long dummy;
+};
+
+struct ocfs2_quota_recovery *ocfs2_begin_quota_recovery(
+				struct ocfs2_super *osb, int slot_num);
+int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
+				struct ocfs2_quota_recovery *rec,
+				int slot_num);
+void ocfs2_free_quota_recovery(struct ocfs2_quota_recovery *rec);
+
+#endif	/* SKIP_QUOTAS */
+
 #endif /* _OCFS2_QUOTA_H */
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 0f319fb..24e127a 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -1,6 +1,8 @@
 /*
  *  Implementation of operations over global quota file
  */
+
+#ifndef SKIP_QUOTAS
 #include <linux/spinlock.h>
 #include <linux/fs.h>
 #include <linux/quota.h>
@@ -883,3 +885,4 @@ void ocfs2_quota_shutdown(void)
 		ocfs2_quota_wq = NULL;
 	}
 }
+#endif	/* SKIP_QUOTAS */
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 1a2c50a..65399f8 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -2,6 +2,8 @@
  *  Implementation of operations over local quota file
  */
 
+#ifndef SKIP_QUOTAS
+
 #include <linux/fs.h>
 #include <linux/quota.h>
 #include <linux/quotaops.h>
@@ -1340,3 +1342,4 @@ struct quota_format_type ocfs2_quota_format = {
 	.qf_ops = &ocfs2_format_ops,
 	.qf_owner = THIS_MODULE
 };
+#endif	/* SKIP_QUOTAS */
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0a7a621..5092558 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -131,9 +131,11 @@ static int ocfs2_get_sector(struct super_block *sb,
 			    int sect_size);
 static struct inode *ocfs2_alloc_inode(struct super_block *sb);
 static void ocfs2_destroy_inode(struct inode *inode);
+#ifndef SKIP_QUOTAS
 static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend);
 static int ocfs2_enable_quotas(struct ocfs2_super *osb);
 static void ocfs2_disable_quotas(struct ocfs2_super *osb);
+#endif
 
 #ifdef SOP_IS_NOT_CONST
 static struct super_operations ocfs2_sops = {
@@ -150,8 +152,10 @@ static const struct super_operations ocfs2_sops = {
 	.put_super	= ocfs2_put_super,
 	.remount_fs	= ocfs2_remount,
 	.show_options   = ocfs2_show_options,
+#ifndef SKIP_QUOTAS
 	.quota_read	= ocfs2_quota_read,
 	.quota_write	= ocfs2_quota_write,
+#endif
 };
 
 enum {
@@ -679,6 +683,7 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 		}
 unlock_osb:
 		spin_unlock(&osb->osb_lock);
+#ifndef SKIP_QUOTAS
 		/* Enable quota accounting after remounting RW */
 		if (!ret && !(*flags & MS_RDONLY)) {
 			if (sb_any_quota_suspended(sb))
@@ -694,6 +699,7 @@ unlock_osb:
 				goto out;
 			}
 		}
+#endif
 	}
 
 	if (!ret) {
@@ -858,6 +864,7 @@ static int ocfs2_verify_userspace_stack(struct ocfs2_super *osb,
 	return 0;
 }
 
+#ifndef SKIP_QUOTAS
 static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend)
 {
 	int type;
@@ -982,6 +989,7 @@ static const struct quotactl_ops ocfs2_quotactl_ops = {
 	.get_dqblk	= vfs_get_dqblk,
 	.set_dqblk	= vfs_set_dqblk,
 };
+#endif	/* SKIP_QUOTAS */
 
 static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 {
@@ -1026,6 +1034,16 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	}
 #endif
 
+#ifdef SKIP_QUOTAS
+	if (OCFS2_HAS_RO_COMPAT_FEATURE(sb, OCFS2_FEATURE_RO_COMPAT_USRQUOTA) ||
+	    OCFS2_HAS_RO_COMPAT_FEATURE(sb, OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)) {
+		status = -EINVAL;
+		mlog(ML_ERROR, "File system cannot mount volume with the Quotas"
+		     "feature enabled.\n");
+		goto read_super_error;
+	}
+#endif
+
 	if (!(osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_XATTR))
 		parsed_options.mount_opt &= ~OCFS2_MOUNT_POSIX_ACL;
 
@@ -1181,6 +1199,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	atomic_set(&osb->vol_state, VOLUME_MOUNTED);
 	wake_up(&osb->osb_mount_event);
 
+#ifndef SKIP_QUOTAS
 	/* Now we can initialize quotas because we can afford to wait
 	 * for cluster locks recovery now. That also means that truncation
 	 * log recovery can happen but that waits for proper quota setup */
@@ -1196,6 +1215,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 			return status;
 		}
 	}
+#endif
 
 	ocfs2_complete_quota_recovery(osb);
 
@@ -1987,8 +2007,10 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	sb->s_fs_info = osb;
 	sb->s_op = &ocfs2_sops;
 	sb->s_export_op = &ocfs2_export_ops;
+#ifndef SKIP_QUOTAS
 	sb->s_qcop = &ocfs2_quotactl_ops;
 	sb->dq_op = &ocfs2_quota_operations;
+#endif
 	sb->s_xattr = ocfs2_xattr_handlers;
 	sb->s_time_gran = 1;
 	sb->s_flags |= MS_NOATIME;
diff --git a/kapi-compat/include/quotas.h b/kapi-compat/include/quotas.h
new file mode 100644
index 0000000..0f03805
--- /dev/null
+++ b/kapi-compat/include/quotas.h
@@ -0,0 +1,19 @@
+#ifndef KAPI_QUOTAS_H
+#define KAPI_QUOTAS_H
+
+#define vfs_dq_alloc_space_nodirty	DQUOT_ALLOC_SPACE_NODIRTY
+#define vfs_dq_free_space_nodirty	DQUOT_FREE_SPACE_NODIRTY
+#define vfs_dq_transfer			DQUOT_TRANSFER
+#define vfs_dq_free_space		DQUOT_FREE_SPACE
+#define vfs_dq_free_inode		DQUOT_FREE_INODE
+#define vfs_dq_init			DQUOT_INIT
+#define register_quota_format(a)	0
+#define unregister_quota_format(a)
+#define sb_any_quota_active(a)		0
+#define ocfs2_quota_shutdown()
+#define ocfs2_quota_setup()		0
+#define ocfs2_disable_quotas(a)
+#define ocfs2_susp_quotas(a, b)		0
+
+#endif
+
-- 
1.5.6.5
