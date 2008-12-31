From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 31 Dec 2008 11:28:54 -0800
Subject: [Ocfs2-devel] [PATCH 19/56] mm: Export pdflush_operation()
In-Reply-To: <20081225010544.GB17410@wotan.suse.de>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
	<1229982517-3455-20-git-send-email-mfasheh@suse.com>
	<20081222160104.6633cd77.akpm@linux-foundation.org>
	<20081225010544.GB17410@wotan.suse.de>
Message-ID: <20081231192854.GK17410@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, joel.becker@oracle.com, jack@suse.cz

On Wed, Dec 24, 2008 at 05:05:44PM -0800, Mark Fasheh wrote:
> On Mon, Dec 22, 2008 at 04:01:04PM -0800, Andrew Morton wrote:
> > On Mon, 22 Dec 2008 13:48:00 -0800
> > Mark Fasheh <mfasheh@suse.com> wrote:
> > 
> > > OCSF2 will need to queue up work for periodic syncing of quotas
> > > among nodes in the cluster. pdflush() is good thread for this so
> > > export it's controlling function so that OCFS2 can use it.
> > 
> > I trust that nothing will explode if pdflush_operation() fails
> > to do anything and returns -1?
> 
> Hmm, Jan do you have any opinion here? I'm wondering if we just need our own
> thread for this after all...
> 	--Mark

Ok, looking at this closer, it seems like this could be a problem after all.
Starving the quota syncing thread doesn't seem like a great idea either.

The following patch changes things to use a workqueue. Really, this doesn't
seem like a big deal anyway - the workqueue has reasonable overhead.

I could add this on top of my upstream branch along with a revert of the
'mm: Export pdflush_operation()' patch, or I could work this into the patch
series so we never get the export patch in the 1st place.
	--Mark

--
Mark Fasheh

From: Mark Fasheh <mfasheh@suse.com>

ocfs2/quota: Use workqueue for periodic syncing instead of pdflush()

Using pdflush_operation() for this was potentially buggy - we could get into
a situation where the work function never gets run. Instead, just create a
workqueue, 'o2quota' and just constantly queue a delayed work item. The
impact of this should be pretty minimal.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/quota.h        |    5 ++++-
 fs/ocfs2/quota_global.c |   45 ++++++++++++++++++++++++++++-----------------
 fs/ocfs2/quota_local.c  |    2 +-
 fs/ocfs2/super.c        |    6 ++++++
 4 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/quota.h b/fs/ocfs2/quota.h
index abf6941..6d190c0 100644
--- a/fs/ocfs2/quota.h
+++ b/fs/ocfs2/quota.h
@@ -60,7 +60,7 @@ struct ocfs2_mem_dqinfo {
 	struct buffer_head *dqi_lqi_bh;	/* Buffer head with local quota file inode */
 	struct buffer_head *dqi_ibh;	/* Buffer with information header */
 	struct qtree_mem_dqinfo dqi_gi;	/* Info about global file */
-	struct timer_list dqi_sync_timer;	/* Timer for syncing dquots */
+	struct delayed_work dqi_sync_work;	/* Work for syncing dquots */
 	struct ocfs2_quota_recovery *dqi_rec;	/* Pointer to recovery
 						 * information, in case we
 						 * enable quotas on file
@@ -114,4 +114,7 @@ int ocfs2_read_quota_block(struct inode *inode, u64 v_block,
 extern struct dquot_operations ocfs2_quota_operations;
 extern struct quota_format_type ocfs2_quota_format;
 
+int ocfs2_quota_setup(void);
+void ocfs2_quota_shutdown(void);
+
 #endif /* _OCFS2_QUOTA_H */
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 9184953..fa9101c 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -7,8 +7,8 @@
 #include <linux/quotaops.h>
 #include <linux/dqblk_qtree.h>
 #include <linux/jiffies.h>
-#include <linux/timer.h>
 #include <linux/writeback.h>
+#include <linux/workqueue.h>
 
 #define MLOG_MASK_PREFIX ML_QUOTA
 #include <cluster/masklog.h>
@@ -25,7 +25,9 @@
 #include "uptodate.h"
 #include "quota.h"
 
-static void qsync_timer_fn(unsigned long oinfo_ptr);
+static struct workqueue_struct *ocfs2_quota_wq = NULL;
+
+static void qsync_work_fn(struct work_struct *work);
 
 static void ocfs2_global_disk2memdqb(struct dquot *dquot, void *dp)
 {
@@ -348,10 +350,10 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 	oinfo->dqi_gi.dqi_usable_bs = sb->s_blocksize -
 						OCFS2_QBLK_RESERVED_SPACE;
 	oinfo->dqi_gi.dqi_qtree_depth = qtree_depth(&oinfo->dqi_gi);
-	setup_timer(&oinfo->dqi_sync_timer, qsync_timer_fn,
-		    (unsigned long)oinfo);
-	mod_timer(&oinfo->dqi_sync_timer,
-		  round_jiffies(jiffies + oinfo->dqi_syncjiff));
+	INIT_DELAYED_WORK(&oinfo->dqi_sync_work, qsync_work_fn);
+	queue_delayed_work(ocfs2_quota_wq, &oinfo->dqi_sync_work,
+			   oinfo->dqi_syncjiff);
+
 out_err:
 	mlog_exit(status);
 	return status;
@@ -594,21 +596,16 @@ out:
 	return status;
 }
 
-static void ocfs2_do_qsync(unsigned long oinfo_ptr)
+static void qsync_work_fn(struct work_struct *work)
 {
-	struct ocfs2_mem_dqinfo *oinfo = (struct ocfs2_mem_dqinfo *)oinfo_ptr;
+	struct ocfs2_mem_dqinfo *oinfo = container_of(work,
+						      struct ocfs2_mem_dqinfo,
+						      dqi_sync_work.work);
 	struct super_block *sb = oinfo->dqi_gqinode->i_sb;
 
 	dquot_scan_active(sb, ocfs2_sync_dquot_helper, oinfo->dqi_type);
-}
-
-static void qsync_timer_fn(unsigned long oinfo_ptr)
-{
-	struct ocfs2_mem_dqinfo *oinfo = (struct ocfs2_mem_dqinfo *)oinfo_ptr;
-
-	pdflush_operation(ocfs2_do_qsync, oinfo_ptr);
-	mod_timer(&oinfo->dqi_sync_timer,
-		  round_jiffies(jiffies + oinfo->dqi_syncjiff));
+	queue_delayed_work(ocfs2_quota_wq, &oinfo->dqi_sync_work,
+			   oinfo->dqi_syncjiff);
 }
 
 /*
@@ -1009,3 +1006,17 @@ struct dquot_operations ocfs2_quota_operations = {
 	.alloc_dquot	= ocfs2_alloc_dquot,
 	.destroy_dquot	= ocfs2_destroy_dquot,
 };
+
+int ocfs2_quota_setup(void)
+{
+	ocfs2_quota_wq = create_workqueue("o2quot");
+	if (!ocfs2_quota_wq)
+		return -ENOMEM;
+	return 0;
+}
+
+void ocfs2_quota_shutdown(void)
+{
+	flush_workqueue(ocfs2_quota_wq);
+	destroy_workqueue(ocfs2_quota_wq);
+}
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index a5f6e2a..07deec5 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -780,7 +780,7 @@ static int ocfs2_local_free_info(struct super_block *sb, int type)
 	/* At this point we know there are no more dquots and thus
 	 * even if there's some sync in the pdflush queue, it won't
 	 * find any dquots and return without doing anything */
-	del_timer_sync(&oinfo->dqi_sync_timer);
+	cancel_delayed_work_sync(&oinfo->dqi_sync_work);
 	iput(oinfo->dqi_gqinode);
 	ocfs2_simple_drop_lockres(OCFS2_SB(sb), &oinfo->dqi_gqlock);
 	ocfs2_lock_res_free(&oinfo->dqi_gqlock);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index a79e67b..25ccf22 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1326,6 +1326,10 @@ static int __init ocfs2_init(void)
 		mlog(ML_ERROR, "Unable to create ocfs2 debugfs root.\n");
 	}
 
+	status = ocfs2_quota_setup();
+	if (status)
+		goto leave;
+
 	ocfs2_set_locking_protocol();
 
 	status = register_quota_format(&ocfs2_quota_format);
@@ -1347,6 +1351,8 @@ static void __exit ocfs2_exit(void)
 {
 	mlog_entry_void();
 
+	ocfs2_quota_shutdown();
+
 	if (ocfs2_wq) {
 		flush_workqueue(ocfs2_wq);
 		destroy_workqueue(ocfs2_wq);
-- 
1.5.6
