From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 15 Dec 2009 14:58:17 -0800
Subject: [Ocfs2-devel] [RFC 2/3] ocfs2: use allocation reservations during
	file write
In-Reply-To: <1260917320-15959-1-git-send-email-mfasheh@suse.com>
References: <1260917320-15959-1-git-send-email-mfasheh@suse.com>
Message-ID: <1260917898-16078-2-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add a per-inode reservations structure and pass it through to the
reservations code.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/aops.c  |    2 ++
 fs/ocfs2/file.c  |   19 +++++++++++++++++++
 fs/ocfs2/inode.c |    4 ++++
 fs/ocfs2/inode.h |    2 ++
 fs/ocfs2/super.c |    2 ++
 5 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index deb2b13..03bae5c 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1760,6 +1760,8 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 			goto out;
 		}
 
+		data_ac->ac_resv = &OCFS2_I(inode)->ip_la_data_resv;
+
 		credits = ocfs2_calc_extend_credits(inode->i_sb,
 						    &di->id2.i_list,
 						    clusters_to_alloc);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index de059f4..6a6b7f7 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -144,6 +144,7 @@ leave:
 static int ocfs2_file_release(struct inode *inode, struct file *file)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	mlog_entry("(0x%p, 0x%p, '%.*s')\n", inode, file,
 		       file->f_path.dentry->d_name.len,
@@ -154,6 +155,21 @@ static int ocfs2_file_release(struct inode *inode, struct file *file)
 		oi->ip_flags &= ~OCFS2_INODE_OPEN_DIRECT;
 	spin_unlock(&oi->ip_lock);
 
+#if 0
+	/*
+	 * Disable this for now. Keeping the reservation around a bit
+	 * longer gives an improvement for workloads which rapidly do
+	 * open()/write()/close() against a file.
+	 */
+	if ((file->f_mode & FMODE_WRITE) &&
+	    (atomic_read(&inode->i_writecount) == 1)) {
+		down_write(&oi->ip_alloc_sem);
+		ocfs2_resv_discard(&osb->osb_la_resmap,
+				   &oi->ip_la_data_resv);
+		up_write(&oi->ip_alloc_sem);
+	}
+#endif
+
 	ocfs2_free_file_private(inode, file);
 
 	mlog_exit(0);
@@ -485,6 +501,9 @@ static int ocfs2_truncate_file(struct inode *inode,
 
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
+	ocfs2_resv_discard(&osb->osb_la_resmap,
+			   &OCFS2_I(inode)->ip_la_data_resv);
+
 	/*
 	 * The inode lock forced other nodes to sync and drop their
 	 * pages, which (correctly) happens even if we have a truncate
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 0297fb8..98ec32a 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1097,6 +1097,10 @@ void ocfs2_clear_inode(struct inode *inode)
 	ocfs2_mark_lockres_freeing(&oi->ip_inode_lockres);
 	ocfs2_mark_lockres_freeing(&oi->ip_open_lockres);
 
+	ocfs2_resv_discard(&OCFS2_SB(inode->i_sb)->osb_la_resmap,
+			   &oi->ip_la_data_resv);
+	ocfs2_resv_init_once(&oi->ip_la_data_resv);
+
 	/* We very well may get a clear_inode before all an inodes
 	 * metadata has hit disk. Of course, we can't drop any cluster
 	 * locks until the journal has finished with it. The only
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index ba4fe07..e45edca 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -70,6 +70,8 @@ struct ocfs2_inode_info
 	/* Only valid if the inode is the dir. */
 	u32				ip_last_used_slot;
 	u64				ip_last_used_group;
+
+	struct ocfs2_alloc_reservation	ip_la_data_resv;
 };
 
 /*
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 62b46a2..dcffe70 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1703,6 +1703,8 @@ static void ocfs2_inode_init_once(void *data)
 	oi->ip_blkno = 0ULL;
 	oi->ip_clusters = 0;
 
+	ocfs2_resv_init_once(&oi->ip_la_data_resv);
+
 	ocfs2_lock_res_init_once(&oi->ip_rw_lockres);
 	ocfs2_lock_res_init_once(&oi->ip_inode_lockres);
 	ocfs2_lock_res_init_once(&oi->ip_open_lockres);
-- 
1.5.6
