From: Takashi Iwai <tiwai@suse.de>
Date: Wed, 11 Mar 2020 10:35:16 +0100
Subject: [Ocfs2-devel] [PATCH] ocfs2: Use scnprintf() for avoiding potential
	buffer overflow
Message-ID: <20200311093516.25300-1-tiwai@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 fs/ocfs2/cluster/heartbeat.c |  10 ++---
 fs/ocfs2/cluster/netdebug.c  |   4 +-
 fs/ocfs2/dlm/dlmdebug.c      | 100 +++++++++++++++++++++----------------------
 fs/ocfs2/super.c             |  46 ++++++++++----------
 4 files changed, 80 insertions(+), 80 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 78cb48d6a596..89d13e0705fe 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1307,7 +1307,7 @@ static int o2hb_debug_open(struct inode *inode, struct file *file)
 
 	case O2HB_DB_TYPE_REGION_NUMBER:
 		reg = (struct o2hb_region *)db->db_data;
-		out += snprintf(buf + out, PAGE_SIZE - out, "%d\n",
+		out += scnprintf(buf + out, PAGE_SIZE - out, "%d\n",
 				reg->hr_region_num);
 		goto done;
 
@@ -1317,12 +1317,12 @@ static int o2hb_debug_open(struct inode *inode, struct file *file)
 		/* If 0, it has never been set before */
 		if (lts)
 			lts = jiffies_to_msecs(jiffies - lts);
-		out += snprintf(buf + out, PAGE_SIZE - out, "%lu\n", lts);
+		out += scnprintf(buf + out, PAGE_SIZE - out, "%lu\n", lts);
 		goto done;
 
 	case O2HB_DB_TYPE_REGION_PINNED:
 		reg = (struct o2hb_region *)db->db_data;
-		out += snprintf(buf + out, PAGE_SIZE - out, "%u\n",
+		out += scnprintf(buf + out, PAGE_SIZE - out, "%u\n",
 				!!reg->hr_item_pinned);
 		goto done;
 
@@ -1331,8 +1331,8 @@ static int o2hb_debug_open(struct inode *inode, struct file *file)
 	}
 
 	while ((i = find_next_bit(map, db->db_len, i + 1)) < db->db_len)
-		out += snprintf(buf + out, PAGE_SIZE - out, "%d ", i);
-	out += snprintf(buf + out, PAGE_SIZE - out, "\n");
+		out += scnprintf(buf + out, PAGE_SIZE - out, "%d ", i);
+	out += scnprintf(buf + out, PAGE_SIZE - out, "\n");
 
 done:
 	i_size_write(inode, out);
diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index 02bf4a1774cc..667a5c5e1f66 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -443,8 +443,8 @@ static int o2net_fill_bitmap(char *buf, int len)
 	o2net_fill_node_map(map, sizeof(map));
 
 	while ((i = find_next_bit(map, O2NM_MAX_NODES, i + 1)) < O2NM_MAX_NODES)
-		out += snprintf(buf + out, PAGE_SIZE - out, "%d ", i);
-	out += snprintf(buf + out, PAGE_SIZE - out, "\n");
+		out += scnprintf(buf + out, PAGE_SIZE - out, "%d ", i);
+	out += scnprintf(buf + out, PAGE_SIZE - out, "\n");
 
 	return out;
 }
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index c5c6efba7b5e..4b8b41d23e91 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -244,11 +244,11 @@ static int stringify_lockname(const char *lockname, int locklen, char *buf,
 		memcpy((__be64 *)&inode_blkno_be,
 		       (char *)&lockname[OCFS2_DENTRY_LOCK_INO_START],
 		       sizeof(__be64));
-		out += snprintf(buf + out, len - out, "%.*s%08x",
+		out += scnprintf(buf + out, len - out, "%.*s%08x",
 				OCFS2_DENTRY_LOCK_INO_START - 1, lockname,
 				(unsigned int)be64_to_cpu(inode_blkno_be));
 	} else
-		out += snprintf(buf + out, len - out, "%.*s",
+		out += scnprintf(buf + out, len - out, "%.*s",
 				locklen, lockname);
 	return out;
 }
@@ -260,7 +260,7 @@ static int stringify_nodemap(unsigned long *nodemap, int maxnodes,
 	int i = -1;
 
 	while ((i = find_next_bit(nodemap, maxnodes, i + 1)) < maxnodes)
-		out += snprintf(buf + out, len - out, "%d ", i);
+		out += scnprintf(buf + out, len - out, "%d ", i);
 
 	return out;
 }
@@ -278,34 +278,34 @@ static int dump_mle(struct dlm_master_list_entry *mle, char *buf, int len)
 		mle_type = "MIG";
 
 	out += stringify_lockname(mle->mname, mle->mnamelen, buf + out, len - out);
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"\t%3s\tmas=%3u\tnew=%3u\tevt=%1d\tuse=%1d\tref=%3d\n",
 			mle_type, mle->master, mle->new_master,
 			!list_empty(&mle->hb_events),
 			!!mle->inuse,
 			kref_read(&mle->mle_refs));
 
-	out += snprintf(buf + out, len - out, "Maybe=");
+	out += scnprintf(buf + out, len - out, "Maybe=");
 	out += stringify_nodemap(mle->maybe_map, O2NM_MAX_NODES,
 				 buf + out, len - out);
-	out += snprintf(buf + out, len - out, "\n");
+	out += scnprintf(buf + out, len - out, "\n");
 
-	out += snprintf(buf + out, len - out, "Vote=");
+	out += scnprintf(buf + out, len - out, "Vote=");
 	out += stringify_nodemap(mle->vote_map, O2NM_MAX_NODES,
 				 buf + out, len - out);
-	out += snprintf(buf + out, len - out, "\n");
+	out += scnprintf(buf + out, len - out, "\n");
 
-	out += snprintf(buf + out, len - out, "Response=");
+	out += scnprintf(buf + out, len - out, "Response=");
 	out += stringify_nodemap(mle->response_map, O2NM_MAX_NODES,
 				 buf + out, len - out);
-	out += snprintf(buf + out, len - out, "\n");
+	out += scnprintf(buf + out, len - out, "\n");
 
-	out += snprintf(buf + out, len - out, "Node=");
+	out += scnprintf(buf + out, len - out, "Node=");
 	out += stringify_nodemap(mle->node_map, O2NM_MAX_NODES,
 				 buf + out, len - out);
-	out += snprintf(buf + out, len - out, "\n");
+	out += scnprintf(buf + out, len - out, "\n");
 
-	out += snprintf(buf + out, len - out, "\n");
+	out += scnprintf(buf + out, len - out, "\n");
 
 	return out;
 }
@@ -353,7 +353,7 @@ static int debug_purgelist_print(struct dlm_ctxt *dlm, char *buf, int len)
 	int out = 0;
 	unsigned long total = 0;
 
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"Dumping Purgelist for Domain: %s\n", dlm->name);
 
 	spin_lock(&dlm->spinlock);
@@ -365,13 +365,13 @@ static int debug_purgelist_print(struct dlm_ctxt *dlm, char *buf, int len)
 		out += stringify_lockname(res->lockname.name,
 					  res->lockname.len,
 					  buf + out, len - out);
-		out += snprintf(buf + out, len - out, "\t%ld\n",
+		out += scnprintf(buf + out, len - out, "\t%ld\n",
 				(jiffies - res->last_used)/HZ);
 		spin_unlock(&res->spinlock);
 	}
 	spin_unlock(&dlm->spinlock);
 
-	out += snprintf(buf + out, len - out, "Total on list: %lu\n", total);
+	out += scnprintf(buf + out, len - out, "Total on list: %lu\n", total);
 
 	return out;
 }
@@ -410,7 +410,7 @@ static int debug_mle_print(struct dlm_ctxt *dlm, char *buf, int len)
 	int i, out = 0;
 	unsigned long total = 0, longest = 0, bucket_count = 0;
 
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"Dumping MLEs for Domain: %s\n", dlm->name);
 
 	spin_lock(&dlm->master_lock);
@@ -428,7 +428,7 @@ static int debug_mle_print(struct dlm_ctxt *dlm, char *buf, int len)
 	}
 	spin_unlock(&dlm->master_lock);
 
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"Total: %lu, Longest: %lu\n", total, longest);
 	return out;
 }
@@ -467,7 +467,7 @@ static int dump_lock(struct dlm_lock *lock, int list_type, char *buf, int len)
 
 #define DEBUG_LOCK_VERSION	1
 	spin_lock(&lock->spinlock);
-	out = snprintf(buf, len, "LOCK:%d,%d,%d,%d,%d,%d:%lld,%d,%d,%d,%d,%d,"
+	out = scnprintf(buf, len, "LOCK:%d,%d,%d,%d,%d,%d:%lld,%d,%d,%d,%d,%d,"
 		       "%d,%d,%d,%d\n",
 		       DEBUG_LOCK_VERSION,
 		       list_type, lock->ml.type, lock->ml.convert_type,
@@ -491,13 +491,13 @@ static int dump_lockres(struct dlm_lock_resource *res, char *buf, int len)
 	int i;
 	int out = 0;
 
-	out += snprintf(buf + out, len - out, "NAME:");
+	out += scnprintf(buf + out, len - out, "NAME:");
 	out += stringify_lockname(res->lockname.name, res->lockname.len,
 				  buf + out, len - out);
-	out += snprintf(buf + out, len - out, "\n");
+	out += scnprintf(buf + out, len - out, "\n");
 
 #define DEBUG_LRES_VERSION	1
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"LRES:%d,%d,%d,%ld,%d,%d,%d,%d,%d,%d,%d\n",
 			DEBUG_LRES_VERSION,
 			res->owner, res->state, res->last_used,
@@ -509,17 +509,17 @@ static int dump_lockres(struct dlm_lock_resource *res, char *buf, int len)
 			kref_read(&res->refs));
 
 	/* refmap */
-	out += snprintf(buf + out, len - out, "RMAP:");
+	out += scnprintf(buf + out, len - out, "RMAP:");
 	out += stringify_nodemap(res->refmap, O2NM_MAX_NODES,
 				 buf + out, len - out);
-	out += snprintf(buf + out, len - out, "\n");
+	out += scnprintf(buf + out, len - out, "\n");
 
 	/* lvb */
-	out += snprintf(buf + out, len - out, "LVBX:");
+	out += scnprintf(buf + out, len - out, "LVBX:");
 	for (i = 0; i < DLM_LVB_LEN; i++)
-		out += snprintf(buf + out, len - out,
+		out += scnprintf(buf + out, len - out,
 					"%02x", (unsigned char)res->lvb[i]);
-	out += snprintf(buf + out, len - out, "\n");
+	out += scnprintf(buf + out, len - out, "\n");
 
 	/* granted */
 	list_for_each_entry(lock, &res->granted, list)
@@ -533,7 +533,7 @@ static int dump_lockres(struct dlm_lock_resource *res, char *buf, int len)
 	list_for_each_entry(lock, &res->blocked, list)
 		out += dump_lock(lock, 2, buf + out, len - out);
 
-	out += snprintf(buf + out, len - out, "\n");
+	out += scnprintf(buf + out, len - out, "\n");
 
 	return out;
 }
@@ -683,41 +683,41 @@ static int debug_state_print(struct dlm_ctxt *dlm, char *buf, int len)
 	}
 
 	/* Domain: xxxxxxxxxx  Key: 0xdfbac769 */
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"Domain: %s  Key: 0x%08x  Protocol: %d.%d\n",
 			dlm->name, dlm->key, dlm->dlm_locking_proto.pv_major,
 			dlm->dlm_locking_proto.pv_minor);
 
 	/* Thread Pid: xxx  Node: xxx  State: xxxxx */
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"Thread Pid: %d  Node: %d  State: %s\n",
 			task_pid_nr(dlm->dlm_thread_task), dlm->node_num, state);
 
 	/* Number of Joins: xxx  Joining Node: xxx */
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"Number of Joins: %d  Joining Node: %d\n",
 			dlm->num_joins, dlm->joining_node);
 
 	/* Domain Map: xx xx xx */
-	out += snprintf(buf + out, len - out, "Domain Map: ");
+	out += scnprintf(buf + out, len - out, "Domain Map: ");
 	out += stringify_nodemap(dlm->domain_map, O2NM_MAX_NODES,
 				 buf + out, len - out);
-	out += snprintf(buf + out, len - out, "\n");
+	out += scnprintf(buf + out, len - out, "\n");
 
 	/* Exit Domain Map: xx xx xx */
-	out += snprintf(buf + out, len - out, "Exit Domain Map: ");
+	out += scnprintf(buf + out, len - out, "Exit Domain Map: ");
 	out += stringify_nodemap(dlm->exit_domain_map, O2NM_MAX_NODES,
 				 buf + out, len - out);
-	out += snprintf(buf + out, len - out, "\n");
+	out += scnprintf(buf + out, len - out, "\n");
 
 	/* Live Map: xx xx xx */
-	out += snprintf(buf + out, len - out, "Live Map: ");
+	out += scnprintf(buf + out, len - out, "Live Map: ");
 	out += stringify_nodemap(dlm->live_nodes_map, O2NM_MAX_NODES,
 				 buf + out, len - out);
-	out += snprintf(buf + out, len - out, "\n");
+	out += scnprintf(buf + out, len - out, "\n");
 
 	/* Lock Resources: xxx (xxx) */
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"Lock Resources: %d (%d)\n",
 			atomic_read(&dlm->res_cur_count),
 			atomic_read(&dlm->res_tot_count));
@@ -729,29 +729,29 @@ static int debug_state_print(struct dlm_ctxt *dlm, char *buf, int len)
 		cur_mles += atomic_read(&dlm->mle_cur_count[i]);
 
 	/* MLEs: xxx (xxx) */
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"MLEs: %d (%d)\n", cur_mles, tot_mles);
 
 	/*  Blocking: xxx (xxx) */
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"  Blocking: %d (%d)\n",
 			atomic_read(&dlm->mle_cur_count[DLM_MLE_BLOCK]),
 			atomic_read(&dlm->mle_tot_count[DLM_MLE_BLOCK]));
 
 	/*  Mastery: xxx (xxx) */
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"  Mastery: %d (%d)\n",
 			atomic_read(&dlm->mle_cur_count[DLM_MLE_MASTER]),
 			atomic_read(&dlm->mle_tot_count[DLM_MLE_MASTER]));
 
 	/*  Migration: xxx (xxx) */
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"  Migration: %d (%d)\n",
 			atomic_read(&dlm->mle_cur_count[DLM_MLE_MIGRATION]),
 			atomic_read(&dlm->mle_tot_count[DLM_MLE_MIGRATION]));
 
 	/* Lists: Dirty=Empty  Purge=InUse  PendingASTs=Empty  ... */
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"Lists: Dirty=%s  Purge=%s  PendingASTs=%s  "
 			"PendingBASTs=%s\n",
 			(list_empty(&dlm->dirty_list) ? "Empty" : "InUse"),
@@ -760,12 +760,12 @@ static int debug_state_print(struct dlm_ctxt *dlm, char *buf, int len)
 			(list_empty(&dlm->pending_basts) ? "Empty" : "InUse"));
 
 	/* Purge Count: xxx  Refs: xxx */
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"Purge Count: %d  Refs: %d\n", dlm->purge_count,
 			kref_read(&dlm->dlm_refs));
 
 	/* Dead Node: xxx */
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"Dead Node: %d\n", dlm->reco.dead_node);
 
 	/* What about DLM_RECO_STATE_FINALIZE? */
@@ -775,19 +775,19 @@ static int debug_state_print(struct dlm_ctxt *dlm, char *buf, int len)
 		state = "INACTIVE";
 
 	/* Recovery Pid: xxxx  Master: xxx  State: xxxx */
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"Recovery Pid: %d  Master: %d  State: %s\n",
 			task_pid_nr(dlm->dlm_reco_thread_task),
 			dlm->reco.new_master, state);
 
 	/* Recovery Map: xx xx */
-	out += snprintf(buf + out, len - out, "Recovery Map: ");
+	out += scnprintf(buf + out, len - out, "Recovery Map: ");
 	out += stringify_nodemap(dlm->recovery_map, O2NM_MAX_NODES,
 				 buf + out, len - out);
-	out += snprintf(buf + out, len - out, "\n");
+	out += scnprintf(buf + out, len - out, "\n");
 
 	/* Recovery Node State: */
-	out += snprintf(buf + out, len - out, "Recovery Node State:\n");
+	out += scnprintf(buf + out, len - out, "Recovery Node State:\n");
 	list_for_each_entry(node, &dlm->reco.node_data, list) {
 		switch (node->state) {
 		case DLM_RECO_NODE_DATA_INIT:
@@ -815,7 +815,7 @@ static int debug_state_print(struct dlm_ctxt *dlm, char *buf, int len)
 			state = "BAD";
 			break;
 		}
-		out += snprintf(buf + out, len - out, "\t%u - %s\n",
+		out += scnprintf(buf + out, len - out, "\t%u - %s\n",
 				node->node_num, state);
 	}
 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 05dd68ade293..ac61eeaf3837 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -220,31 +220,31 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 	int i, out = 0;
 	unsigned long flags;
 
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"%10s => Id: %-s  Uuid: %-s  Gen: 0x%X  Label: %-s\n",
 			"Device", osb->dev_str, osb->uuid_str,
 			osb->fs_generation, osb->vol_label);
 
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"%10s => State: %d  Flags: 0x%lX\n", "Volume",
 			atomic_read(&osb->vol_state), osb->osb_flags);
 
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"%10s => Block: %lu  Cluster: %d\n", "Sizes",
 			osb->sb->s_blocksize, osb->s_clustersize);
 
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"%10s => Compat: 0x%X  Incompat: 0x%X  "
 			"ROcompat: 0x%X\n",
 			"Features", osb->s_feature_compat,
 			osb->s_feature_incompat, osb->s_feature_ro_compat);
 
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"%10s => Opts: 0x%lX  AtimeQuanta: %u\n", "Mount",
 			osb->s_mount_opt, osb->s_atime_quantum);
 
 	if (cconn) {
-		out += snprintf(buf + out, len - out,
+		out += scnprintf(buf + out, len - out,
 				"%10s => Stack: %s  Name: %*s  "
 				"Version: %d.%d\n", "Cluster",
 				(*osb->osb_cluster_stack == '\0' ?
@@ -255,7 +255,7 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 	}
 
 	spin_lock_irqsave(&osb->dc_task_lock, flags);
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"%10s => Pid: %d  Count: %lu  WakeSeq: %lu  "
 			"WorkSeq: %lu\n", "DownCnvt",
 			(osb->dc_task ?  task_pid_nr(osb->dc_task) : -1),
@@ -264,32 +264,32 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 	spin_unlock_irqrestore(&osb->dc_task_lock, flags);
 
 	spin_lock(&osb->osb_lock);
-	out += snprintf(buf + out, len - out, "%10s => Pid: %d  Nodes:",
+	out += scnprintf(buf + out, len - out, "%10s => Pid: %d  Nodes:",
 			"Recovery",
 			(osb->recovery_thread_task ?
 			 task_pid_nr(osb->recovery_thread_task) : -1));
 	if (rm->rm_used == 0)
-		out += snprintf(buf + out, len - out, " None\n");
+		out += scnprintf(buf + out, len - out, " None\n");
 	else {
 		for (i = 0; i < rm->rm_used; i++)
-			out += snprintf(buf + out, len - out, " %d",
+			out += scnprintf(buf + out, len - out, " %d",
 					rm->rm_entries[i]);
-		out += snprintf(buf + out, len - out, "\n");
+		out += scnprintf(buf + out, len - out, "\n");
 	}
 	spin_unlock(&osb->osb_lock);
 
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"%10s => Pid: %d  Interval: %lu\n", "Commit",
 			(osb->commit_task ? task_pid_nr(osb->commit_task) : -1),
 			osb->osb_commit_interval);
 
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"%10s => State: %d  TxnId: %lu  NumTxns: %d\n",
 			"Journal", osb->journal->j_state,
 			osb->journal->j_trans_id,
 			atomic_read(&osb->journal->j_num_trans));
 
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"%10s => GlobalAllocs: %d  LocalAllocs: %d  "
 			"SubAllocs: %d  LAWinMoves: %d  SAExtends: %d\n",
 			"Stats",
@@ -299,7 +299,7 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 			atomic_read(&osb->alloc_stats.moves),
 			atomic_read(&osb->alloc_stats.bg_extends));
 
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"%10s => State: %u  Descriptor: %llu  Size: %u bits  "
 			"Default: %u bits\n",
 			"LocalAlloc", osb->local_alloc_state,
@@ -307,7 +307,7 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 			osb->local_alloc_bits, osb->local_alloc_default_bits);
 
 	spin_lock(&osb->osb_lock);
-	out += snprintf(buf + out, len - out,
+	out += scnprintf(buf + out, len - out,
 			"%10s => InodeSlot: %d  StolenInodes: %d, "
 			"MetaSlot: %d  StolenMeta: %d\n", "Steal",
 			osb->s_inode_steal_slot,
@@ -316,20 +316,20 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
 			atomic_read(&osb->s_num_meta_stolen));
 	spin_unlock(&osb->osb_lock);
 
-	out += snprintf(buf + out, len - out, "OrphanScan => ");
-	out += snprintf(buf + out, len - out, "Local: %u  Global: %u ",
+	out += scnprintf(buf + out, len - out, "OrphanScan => ");
+	out += scnprintf(buf + out, len - out, "Local: %u  Global: %u ",
 			os->os_count, os->os_seqno);
-	out += snprintf(buf + out, len - out, " Last Scan: ");
+	out += scnprintf(buf + out, len - out, " Last Scan: ");
 	if (atomic_read(&os->os_state) == ORPHAN_SCAN_INACTIVE)
-		out += snprintf(buf + out, len - out, "Disabled\n");
+		out += scnprintf(buf + out, len - out, "Disabled\n");
 	else
-		out += snprintf(buf + out, len - out, "%lu seconds ago\n",
+		out += scnprintf(buf + out, len - out, "%lu seconds ago\n",
 				(unsigned long)(ktime_get_seconds() - os->os_scantime));
 
-	out += snprintf(buf + out, len - out, "%10s => %3s  %10s\n",
+	out += scnprintf(buf + out, len - out, "%10s => %3s  %10s\n",
 			"Slots", "Num", "RecoGen");
 	for (i = 0; i < osb->max_slots; ++i) {
-		out += snprintf(buf + out, len - out,
+		out += scnprintf(buf + out, len - out,
 				"%10s  %c %3d  %10d\n",
 				" ",
 				(i == osb->slot_num ? '*' : ' '),
-- 
2.16.4
