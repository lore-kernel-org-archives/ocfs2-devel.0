From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 16 Mar 2010 23:59:11 -0700
Subject: [Ocfs2-devel] [PATCH 2/5] ocfs2: use allocation reservations during
	file write
In-Reply-To: <1268809154-1020-1-git-send-email-mfasheh@suse.com>
References: <1268809154-1020-1-git-send-email-mfasheh@suse.com>
Message-ID: <1268809154-1020-3-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add a per-inode reservations structure and pass it through to the
reservations code.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/alloc.c |    2 ++
 fs/ocfs2/aops.c  |    3 +++
 fs/ocfs2/file.c  |    3 +++
 fs/ocfs2/inode.c |    4 ++++
 fs/ocfs2/inode.h |    2 ++
 fs/ocfs2/super.c |    2 ++
 6 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index d17bdc7..b8f0744 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7307,6 +7307,8 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 		}
 		did_quota = 1;
 
+		data_ac->ac_resv = &OCFS2_I(inode)->ip_la_data_resv;
+
 		ret = ocfs2_claim_clusters(osb, handle, data_ac, 1, &bit_off,
 					   &num);
 		if (ret) {
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 7e9df11..e70f7f8 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1734,6 +1734,9 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 			goto out;
 		}
 
+		if (data_ac)
+			data_ac->ac_resv = &OCFS2_I(inode)->ip_la_data_resv;
+
 		credits = ocfs2_calc_extend_credits(inode->i_sb,
 						    &di->id2.i_list,
 						    clusters_to_alloc);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 558ce03..ff928a9 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -485,6 +485,9 @@ static int ocfs2_truncate_file(struct inode *inode,
 
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
+	ocfs2_resv_discard(&osb->osb_la_resmap,
+			   &OCFS2_I(inode)->ip_la_data_resv);
+
 	/*
 	 * The inode lock forced other nodes to sync and drop their
 	 * pages, which (correctly) happens even if we have a truncate
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 88459bd..2a00c2d 100644
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
index a6f9556..db354d1 100644
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
1.6.4.2
