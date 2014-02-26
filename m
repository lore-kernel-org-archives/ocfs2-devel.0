From: Jan Kara <jack@suse.cz>
Date: Wed, 26 Feb 2014 17:49:33 +0100
Subject: [Ocfs2-devel] [PATCH 6/6] ocfs2: Revert iput deferring code in
	ocfs2_drop_dentry_lock
In-Reply-To: <1393433373-28767-1-git-send-email-jack@suse.cz>
References: <1393433373-28767-1-git-send-email-jack@suse.cz>
Message-ID: <1393433373-28767-7-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Goldwyn Rodrigues <rgoldwyn@suse.de>

The following patches are reverted in this patch because these
patches caused performance regression in the remote unlink() calls.

ea455f8ab68338ba69f5d3362b342c115bea8e13 - ocfs2: Push out dropping
of dentry lock to ocfs2_wq
f7b1aa69be138ad9d7d3f31fa56f4c9407f56b6a - ocfs2: Fix deadlock on umount
5fd131893793567c361ae64cbeb28a2a753bbe35 - ocfs2: Don't oops in
ocfs2_kill_sb on a failed mount

Previous patches in this series removed the possible deadlocks from
downconvert thread so the above patches shouldn't be needed anymore.

The regression is caused because these patches delay the iput() in case
of dentry unlocks. This also delays the unlocking of the open lockres.
The open lockresource is required to test if the inode can be wiped from
disk or not. When the deleting node does not get the open lock, it marks
it as orphan (even though it is not in use by another node/process)
and causes a journal checkpoint. This delays operations following the
inode eviction. This also moves the inode to the orphaned inode
which further causes more I/O and a lot of unneccessary orphans.

The following script can be used to generate the load causing issues:
declare -a create
declare -a remove
declare -a iterations=(1 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384)
unique="`mktemp -u XXXXX`"
script="/tmp/idontknow-${unique}.sh"
cat <<EOF > "${script}"
for n in {1..8}; do mkdir -p test/dir\${n}
  eval touch test/dir\${n}/foo{1.."\$1"}
done
EOF
chmod 700 "${script}"

function fcreate ()
{
  exec 2>&1 /usr/bin/time --format=%E "${script}" "$1"
}

function fremove ()
{
  exec 2>&1 /usr/bin/time --format=%E ssh node2 "cd `pwd`; rm -Rf test*"
}

function fcp ()
{
  exec 2>&1 /usr/bin/time --format=%E ssh node3 "cd `pwd`; cp -R test test.new"
}

echo -------------------------------------------------
echo "| # files | create #s | copy #s | remove #s |"
echo -------------------------------------------------
for ((x=0; x < ${#iterations[*]} ; x++)) do
  create[$x]="`fcreate ${iterations[$x]}`"
  copy[$x]="`fcp ${iterations[$x]}`"
  remove[$x]="`fremove`"
  printf "| %8d | %9s | %9s | %9s |\n" ${iterations[$x]} ${create[$x]} ${copy[$x]} ${remove[$x]}
done
rm "${script}"
echo "------------------------"

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/dcache.c | 61 +++----------------------------------------------------
 fs/ocfs2/dcache.h | 12 +----------
 fs/ocfs2/ocfs2.h  | 28 ++++---------------------
 fs/ocfs2/super.c  | 30 +--------------------------
 4 files changed, 9 insertions(+), 122 deletions(-)

diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index 0d3a97d2d5f6..e2e05a106beb 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -37,7 +37,6 @@
 #include "dlmglue.h"
 #include "file.h"
 #include "inode.h"
-#include "super.h"
 #include "ocfs2_trace.h"
 
 void ocfs2_dentry_attach_gen(struct dentry *dentry)
@@ -346,52 +345,6 @@ out_attach:
 	return ret;
 }
 
-DEFINE_SPINLOCK(dentry_list_lock);
-
-/* We limit the number of dentry locks to drop in one go. We have
- * this limit so that we don't starve other users of ocfs2_wq. */
-#define DL_INODE_DROP_COUNT 64
-
-/* Drop inode references from dentry locks */
-static void __ocfs2_drop_dl_inodes(struct ocfs2_super *osb, int drop_count)
-{
-	struct ocfs2_dentry_lock *dl;
-
-	spin_lock(&dentry_list_lock);
-	while (osb->dentry_lock_list && (drop_count < 0 || drop_count--)) {
-		dl = osb->dentry_lock_list;
-		osb->dentry_lock_list = dl->dl_next;
-		spin_unlock(&dentry_list_lock);
-		iput(dl->dl_inode);
-		kfree(dl);
-		spin_lock(&dentry_list_lock);
-	}
-	spin_unlock(&dentry_list_lock);
-}
-
-void ocfs2_drop_dl_inodes(struct work_struct *work)
-{
-	struct ocfs2_super *osb = container_of(work, struct ocfs2_super,
-					       dentry_lock_work);
-
-	__ocfs2_drop_dl_inodes(osb, DL_INODE_DROP_COUNT);
-	/*
-	 * Don't queue dropping if umount is in progress. We flush the
-	 * list in ocfs2_dismount_volume
-	 */
-	spin_lock(&dentry_list_lock);
-	if (osb->dentry_lock_list &&
-	    !ocfs2_test_osb_flag(osb, OCFS2_OSB_DROP_DENTRY_LOCK_IMMED))
-		queue_work(ocfs2_wq, &osb->dentry_lock_work);
-	spin_unlock(&dentry_list_lock);
-}
-
-/* Flush the whole work queue */
-void ocfs2_drop_all_dl_inodes(struct ocfs2_super *osb)
-{
-	__ocfs2_drop_dl_inodes(osb, -1);
-}
-
 /*
  * ocfs2_dentry_iput() and friends.
  *
@@ -416,24 +369,16 @@ void ocfs2_drop_all_dl_inodes(struct ocfs2_super *osb)
 static void ocfs2_drop_dentry_lock(struct ocfs2_super *osb,
 				   struct ocfs2_dentry_lock *dl)
 {
+	iput(dl->dl_inode);
 	ocfs2_simple_drop_lockres(osb, &dl->dl_lockres);
 	ocfs2_lock_res_free(&dl->dl_lockres);
-
-	/* We leave dropping of inode reference to ocfs2_wq as that can
-	 * possibly lead to inode deletion which gets tricky */
-	spin_lock(&dentry_list_lock);
-	if (!osb->dentry_lock_list &&
-	    !ocfs2_test_osb_flag(osb, OCFS2_OSB_DROP_DENTRY_LOCK_IMMED))
-		queue_work(ocfs2_wq, &osb->dentry_lock_work);
-	dl->dl_next = osb->dentry_lock_list;
-	osb->dentry_lock_list = dl;
-	spin_unlock(&dentry_list_lock);
+	kfree(dl);
 }
 
 void ocfs2_dentry_lock_put(struct ocfs2_super *osb,
 			   struct ocfs2_dentry_lock *dl)
 {
-	int unlock;
+	int unlock = 0;
 
 	BUG_ON(dl->dl_count == 0);
 
diff --git a/fs/ocfs2/dcache.h b/fs/ocfs2/dcache.h
index b79eff709958..55f58892b153 100644
--- a/fs/ocfs2/dcache.h
+++ b/fs/ocfs2/dcache.h
@@ -29,13 +29,8 @@
 extern const struct dentry_operations ocfs2_dentry_ops;
 
 struct ocfs2_dentry_lock {
-	/* Use count of dentry lock */
 	unsigned int		dl_count;
-	union {
-		/* Linked list of dentry locks to release */
-		struct ocfs2_dentry_lock *dl_next;
-		u64			dl_parent_blkno;
-	};
+	u64			dl_parent_blkno;
 
 	/*
 	 * The ocfs2_dentry_lock keeps an inode reference until
@@ -49,14 +44,9 @@ struct ocfs2_dentry_lock {
 int ocfs2_dentry_attach_lock(struct dentry *dentry, struct inode *inode,
 			     u64 parent_blkno);
 
-extern spinlock_t dentry_list_lock;
-
 void ocfs2_dentry_lock_put(struct ocfs2_super *osb,
 			   struct ocfs2_dentry_lock *dl);
 
-void ocfs2_drop_dl_inodes(struct work_struct *work);
-void ocfs2_drop_all_dl_inodes(struct ocfs2_super *osb);
-
 struct dentry *ocfs2_find_local_alias(struct inode *inode, u64 parent_blkno,
 				      int skip_unhashed);
 
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 64c02239ba46..a780e20d4fba 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -275,19 +275,16 @@ enum ocfs2_mount_options
 	OCFS2_MOUNT_HB_GLOBAL = 1 << 14, /* Global heartbeat */
 };
 
-#define OCFS2_OSB_SOFT_RO			0x0001
-#define OCFS2_OSB_HARD_RO			0x0002
-#define OCFS2_OSB_ERROR_FS			0x0004
-#define OCFS2_OSB_DROP_DENTRY_LOCK_IMMED	0x0008
-
-#define OCFS2_DEFAULT_ATIME_QUANTUM		60
+#define OCFS2_OSB_SOFT_RO	0x0001
+#define OCFS2_OSB_HARD_RO	0x0002
+#define OCFS2_OSB_ERROR_FS	0x0004
+#define OCFS2_DEFAULT_ATIME_QUANTUM	60
 
 struct ocfs2_journal;
 struct ocfs2_slot_info;
 struct ocfs2_recovery_map;
 struct ocfs2_replay_map;
 struct ocfs2_quota_recovery;
-struct ocfs2_dentry_lock;
 struct ocfs2_super
 {
 	struct task_struct *commit_task;
@@ -415,11 +412,6 @@ struct ocfs2_super
 	struct list_head blocked_lock_list;
 	unsigned long blocked_lock_count;
 
-	/* List of dentry locks to release. Anyone can add locks to
-	 * the list, ocfs2_wq processes the list  */
-	struct ocfs2_dentry_lock *dentry_lock_list;
-	struct work_struct dentry_lock_work;
-
 	/* List of dquot structures to drop last reference to */
 	struct llist_head dquot_drop_list;
 	struct work_struct dquot_drop_work;
@@ -584,18 +576,6 @@ static inline void ocfs2_set_osb_flag(struct ocfs2_super *osb,
 	spin_unlock(&osb->osb_lock);
 }
 
-
-static inline unsigned long  ocfs2_test_osb_flag(struct ocfs2_super *osb,
-						 unsigned long flag)
-{
-	unsigned long ret;
-
-	spin_lock(&osb->osb_lock);
-	ret = osb->osb_flags & flag;
-	spin_unlock(&osb->osb_lock);
-	return ret;
-}
-
 static inline void ocfs2_set_ro_flag(struct ocfs2_super *osb,
 				     int hard)
 {
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0a8972deae2b..5597e42eae54 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1238,30 +1238,11 @@ static struct dentry *ocfs2_mount(struct file_system_type *fs_type,
 	return mount_bdev(fs_type, flags, dev_name, data, ocfs2_fill_super);
 }
 
-static void ocfs2_kill_sb(struct super_block *sb)
-{
-	struct ocfs2_super *osb = OCFS2_SB(sb);
-
-	/* Failed mount? */
-	if (!osb || atomic_read(&osb->vol_state) == VOLUME_DISABLED)
-		goto out;
-
-	/* Prevent further queueing of inode drop events */
-	spin_lock(&dentry_list_lock);
-	ocfs2_set_osb_flag(osb, OCFS2_OSB_DROP_DENTRY_LOCK_IMMED);
-	spin_unlock(&dentry_list_lock);
-	/* Wait for work to finish and/or remove it */
-	cancel_work_sync(&osb->dentry_lock_work);
-out:
-	kill_block_super(sb);
-}
-
 static struct file_system_type ocfs2_fs_type = {
 	.owner          = THIS_MODULE,
 	.name           = "ocfs2",
 	.mount          = ocfs2_mount,
-	.kill_sb        = ocfs2_kill_sb,
-
+	.kill_sb        = kill_block_super,
 	.fs_flags       = FS_REQUIRES_DEV|FS_RENAME_DOES_D_MOVE,
 	.next           = NULL
 };
@@ -1932,12 +1913,6 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	debugfs_remove(osb->osb_ctxt);
 
-	/*
-	 * Flush inode dropping work queue so that deletes are
-	 * performed while the filesystem is still working
-	 */
-	ocfs2_drop_all_dl_inodes(osb);
-
 	/* Orphan scan should be stopped as early as possible */
 	ocfs2_orphan_scan_stop(osb);
 
@@ -2281,9 +2256,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
 	journal->j_state = OCFS2_JOURNAL_FREE;
 
-	INIT_WORK(&osb->dentry_lock_work, ocfs2_drop_dl_inodes);
-	osb->dentry_lock_list = NULL;
-
 	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
 	init_llist_head(&osb->dquot_drop_list);
 
-- 
1.8.1.4
