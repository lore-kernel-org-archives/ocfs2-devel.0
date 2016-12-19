From: Gang He <ghe@suse.com>
Date: Mon, 19 Dec 2016 17:21:27 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: embed kobject in ocfs2_super
	structure
In-Reply-To: <1482139287-19040-1-git-send-email-ghe@suse.com>
References: <1482139287-19040-1-git-send-email-ghe@suse.com>
Message-ID: <1482139287-19040-3-git-send-email-ghe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, jlbec@evilplan.org
Cc: Gang He <ghe@suse.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

Embed kobject in ocfs2_super structure, then we can use container_of
method to get our own data pointor via kobject pointer. Second, I adjust
the related code in create/remove online file check sysfs entry.

Signed-off-by: Gang He <ghe@suse.com>
---
 fs/ocfs2/ocfs2.h |  8 ++++++++
 fs/ocfs2/super.c | 27 +++++++++++++++++++++++----
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index e63af7d..b00c983 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -50,6 +50,8 @@
 
 #include "reservations.h"
 
+#include "filecheck.h"
+
 /* Caching of metadata buffers */
 
 /* Most user visible OCFS2 inodes will have very few pieces of
@@ -472,6 +474,12 @@ struct ocfs2_super
 	 * workqueue and schedule on our own.
 	 */
 	struct workqueue_struct *ocfs2_wq;
+
+	/* sysfs directory per partition */
+	struct kset *osb_dev_kset;
+
+	/* file check related stuff */
+	struct ocfs2_filecheck_sysfs_entry osb_fc_ent;
 };
 
 #define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index f56fe39..9ab3467 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1162,6 +1162,23 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	ocfs2_complete_mount_recovery(osb);
 
+	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
+						&ocfs2_kset->kobj);
+	if (!osb->osb_dev_kset) {
+		status = -ENOMEM;
+		mlog(ML_ERROR, "Unable to create device kset %s.\n", sb->s_id);
+		goto read_super_error;
+	}
+
+	/* Create filecheck sysfs related directories/files at
+	 * /sys/fs/ocfs2/<devname>/filecheck */
+	if (ocfs2_filecheck_create_sysfs(osb)) {
+		status = -ENOMEM;
+		mlog(ML_ERROR, "Unable to create filecheck sysfs directory at "
+			"/sys/fs/ocfs2/%s/filecheck.\n", sb->s_id);
+		goto read_super_error;
+	}
+
 	if (ocfs2_mount_local(osb))
 		snprintf(nodestr, sizeof(nodestr), "local");
 	else
@@ -1200,9 +1217,6 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	/* Start this when the mount is almost sure of being successful */
 	ocfs2_orphan_scan_start(osb);
 
-	/* Create filecheck sysfile /sys/fs/ocfs2/<devname>/filecheck */
-	ocfs2_filecheck_create_sysfs(sb);
-
 	return status;
 
 read_super_error:
@@ -1653,7 +1667,6 @@ static void ocfs2_put_super(struct super_block *sb)
 
 	ocfs2_sync_blockdev(sb);
 	ocfs2_dismount_volume(sb, 0);
-	ocfs2_filecheck_remove_sysfs(sb);
 }
 
 static int ocfs2_statfs(struct dentry *dentry, struct kstatfs *buf)
@@ -1896,6 +1909,12 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	osb = OCFS2_SB(sb);
 	BUG_ON(!osb);
 
+	/* Remove file check sysfs related directores/files,
+	 * and wait for the pending file check operations */
+	ocfs2_filecheck_remove_sysfs(osb);
+
+	kset_unregister(osb->osb_dev_kset);
+
 	debugfs_remove(osb->osb_ctxt);
 
 	/* Orphan scan should be stopped as early as possible */
-- 
1.8.5.6
