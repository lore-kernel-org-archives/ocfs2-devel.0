From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 16 Dec 2008 15:49:17 -0800
Subject: [Ocfs2-devel] [PATCH 3/9] ocfs2: Exposes the file system state via
	debugfs
In-Reply-To: <1229471363-15887-1-git-send-email-sunil.mushran@oracle.com>
References: <1229471363-15887-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1229471363-15887-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Patch creates a per mount debugfs file, fs_state, which exposes information
like, cluster stack in use, states of the downconvert, recovery and commit
threads, number of journal txns, some allocation stats, list of all slots, etc.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/ocfs2.h |    1 +
 fs/ocfs2/super.c |  220 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 221 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 3fed9e3..d912b70 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -301,6 +301,7 @@ struct ocfs2_super
 	struct ocfs2_dlm_debug *osb_dlm_debug;
 
 	struct dentry *osb_debug_root;
+	struct dentry *osb_ctxt;
 
 	wait_queue_head_t recovery_event;
 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 304b63a..7808866 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -619,6 +619,214 @@ static int ocfs2_verify_userspace_stack(struct ocfs2_super *osb,
 	return 0;
 }
 
+#ifdef CONFIG_DEBUG_FS
+struct ocfs2_debug_buffer {
+	int len;
+	char *buf;
+};
+
+static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
+{
+	int out = 0;
+	int i;
+	struct ocfs2_cluster_connection *cconn = osb->cconn;
+	struct ocfs2_recovery_map *rm = osb->recovery_map;
+
+	out += snprintf(buf + out, len - out,
+			"%10s => Id: %-s  Uuid: %-s  Gen: 0x%X  Label: %-s\n",
+			"Device", osb->dev_str, osb->uuid_str,
+			osb->fs_generation, osb->vol_label);
+
+	out += snprintf(buf + out, len - out,
+			"%10s => State: %d  Flags: 0x%lX\n", "Volume",
+			atomic_read(&osb->vol_state), osb->osb_flags);
+
+	out += snprintf(buf + out, len - out,
+			"%10s => Block: %lu  Cluster: %d\n", "Sizes",
+			osb->sb->s_blocksize, osb->s_clustersize);
+
+	out += snprintf(buf + out, len - out,
+			"%10s => Compat: 0x%X  Incompat: 0x%X  "
+			"ROcompat: 0x%X\n",
+			"Features", osb->s_feature_compat,
+			osb->s_feature_incompat, osb->s_feature_ro_compat);
+
+	out += snprintf(buf + out, len - out,
+			"%10s => Opts: 0x%lX  AtimeQuanta: %u\n", "Mount",
+			osb->s_mount_opt, osb->s_atime_quantum);
+
+	out += snprintf(buf + out, len - out,
+			"%10s => Stack: %s  Name: %*s  Version: %d.%d\n",
+			"Cluster",
+			(*osb->osb_cluster_stack == '\0' ?
+			 "o2cb" : osb->osb_cluster_stack),
+			cconn->cc_namelen, cconn->cc_name,
+			cconn->cc_version.pv_major, cconn->cc_version.pv_minor);
+
+	spin_lock(&osb->dc_task_lock);
+	out += snprintf(buf + out, len - out,
+			"%10s => Pid: %d  Count: %lu  WakeSeq: %lu  "
+			"WorkSeq: %lu\n", "DownCnvt",
+			task_pid_nr(osb->dc_task), osb->blocked_lock_count,
+			osb->dc_wake_sequence, osb->dc_work_sequence);
+	spin_unlock(&osb->dc_task_lock);
+
+	spin_lock(&osb->osb_lock);
+	out += snprintf(buf + out, len - out, "%10s => Pid: %d  Nodes:",
+			"Recovery",
+			(osb->recovery_thread_task ?
+			 task_pid_nr(osb->recovery_thread_task) : -1));
+	if (rm->rm_used == 0)
+		out += snprintf(buf + out, len - out, " None\n");
+	else {
+		for (i = 0; i < rm->rm_used; i++)
+			out += snprintf(buf + out, len - out, " %d",
+					rm->rm_entries[i]);
+		out += snprintf(buf + out, len - out, "\n");
+	}
+	spin_unlock(&osb->osb_lock);
+
+	out += snprintf(buf + out, len - out,
+			"%10s => Pid: %d  Interval: %lu  Needs: %d\n", "Commit",
+			task_pid_nr(osb->commit_task), osb->osb_commit_interval,
+			atomic_read(&osb->needs_checkpoint));
+
+	out += snprintf(buf + out, len - out,
+			"%10s => State: %d  NumTxns: %d  TxnId: %lu\n",
+			"Journal", osb->journal->j_state,
+			atomic_read(&osb->journal->j_num_trans),
+			osb->journal->j_trans_id);
+
+	out += snprintf(buf + out, len - out,
+			"%10s => GlobalAllocs: %d  LocalAllocs: %d  "
+			"SubAllocs: %d  LAWinMoves: %d  SAExtends: %d\n",
+			"Stats",
+			atomic_read(&osb->alloc_stats.bitmap_data),
+			atomic_read(&osb->alloc_stats.local_data),
+			atomic_read(&osb->alloc_stats.bg_allocs),
+			atomic_read(&osb->alloc_stats.moves),
+			atomic_read(&osb->alloc_stats.bg_extends));
+
+	out += snprintf(buf + out, len - out,
+			"%10s => State: %u  Descriptor: %llu  Size: %u bits  "
+			"Default: %u bits\n",
+			"LocalAlloc", osb->local_alloc_state,
+			(unsigned long long)osb->la_last_gd,
+			osb->local_alloc_bits, osb->local_alloc_default_bits);
+
+	spin_lock(&osb->osb_lock);
+	out += snprintf(buf + out, len - out,
+			"%10s => Slot: %d  NumStolen: %d\n", "Steal",
+			osb->s_inode_steal_slot,
+			atomic_read(&osb->s_num_inodes_stolen));
+	spin_unlock(&osb->osb_lock);
+
+	out += snprintf(buf + out, len - out, "%10s => %3s  %10s\n",
+			"Slots", "Num", "RecoGen");
+
+	for (i = 0; i < osb->max_slots; ++i) {
+		out += snprintf(buf + out, len - out,
+				"%10s  %c %3d  %10d\n",
+				" ",
+				(i == osb->slot_num ? '*' : ' '),
+				i, osb->slot_recovery_generations[i]);
+	}
+
+	return out;
+}
+
+static int ocfs2_osb_debug_open(struct inode *inode, struct file *file)
+{
+	struct ocfs2_debug_buffer *odb = NULL;
+	struct ocfs2_super *osb = inode->i_private;
+
+	odb = kzalloc(sizeof(struct ocfs2_debug_buffer), GFP_KERNEL);
+	if (!odb)
+		goto bail;
+
+	odb->len = PAGE_SIZE;
+	odb->buf = kmalloc(odb->len, GFP_KERNEL);
+	if (!odb->buf) {
+		kfree(odb);
+		goto bail;
+	}
+
+	odb->len = ocfs2_osb_dump(osb, odb->buf, odb->len);
+
+	file->private_data = odb;
+
+	return 0;
+bail:
+	return -ENOMEM;
+}
+
+static int ocfs2_debug_release(struct inode *inode, struct file *file)
+{
+	struct ocfs2_debug_buffer *odb =
+			(struct ocfs2_debug_buffer *)file->private_data;
+
+	kfree(odb->buf);
+	kfree(odb);
+
+	return 0;
+}
+
+static ssize_t ocfs2_debug_read(struct file *file, char __user *buf,
+				size_t nbytes, loff_t *ppos)
+{
+	struct ocfs2_debug_buffer *odb =
+			(struct ocfs2_debug_buffer *)file->private_data;
+
+	return simple_read_from_buffer(buf, nbytes, ppos, odb->buf, odb->len);
+}
+
+static loff_t ocfs2_debug_llseek(struct file *file, loff_t off, int whence)
+{
+	struct ocfs2_debug_buffer *odb =
+			(struct ocfs2_debug_buffer *)file->private_data;
+	loff_t new = -1;
+
+	switch (whence) {
+	case 0:
+		new = off;
+		break;
+	case 1:
+		new = file->f_pos + off;
+		break;
+	}
+
+	if (new < 0 || new > odb->len)
+		return -EINVAL;
+
+	return (file->f_pos = new);
+}
+#else
+static int ocfs2_osb_debug_open(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+static int ocfs2_debug_release(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+static ssize_t ocfs2_debug_read(struct file *file, char __user *buf,
+				size_t nbytes, loff_t *ppos)
+{
+	return 0;
+}
+static loff_t ocfs2_debug_llseek(struct file *file, loff_t off, int whence)
+{
+	return NULL;
+}
+#endif	/* CONFIG_DEBUG_FS */
+
+static struct file_operations ocfs2_osb_debug_fops = {
+	.open =		ocfs2_osb_debug_open,
+	.release =	ocfs2_debug_release,
+	.read =		ocfs2_debug_read,
+	.llseek =	ocfs2_debug_llseek,
+};
+
 static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct dentry *root;
@@ -720,6 +928,16 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 		goto read_super_error;
 	}
 
+	osb->osb_ctxt = debugfs_create_file("fs_state", S_IFREG|S_IRUSR,
+					    osb->osb_debug_root,
+					    osb,
+					    &ocfs2_osb_debug_fops);
+	if (!osb->osb_ctxt) {
+		status = -EINVAL;
+		mlog_errno(status);
+		goto read_super_error;
+	}
+
 	status = ocfs2_mount_volume(sb);
 	if (osb->root_inode)
 		inode = igrab(osb->root_inode);
@@ -1303,6 +1521,8 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	osb = OCFS2_SB(sb);
 	BUG_ON(!osb);
 
+	debugfs_remove(osb->osb_ctxt);
+
 	ocfs2_shutdown_local_alloc(osb);
 
 	ocfs2_truncate_log_shutdown(osb);
-- 
1.5.6.3
