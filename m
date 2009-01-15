From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 16 Jan 2009 06:00:40 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Optimize inode group allocation by
	recording last used group.
In-Reply-To: <1232056719-27716-1-git-send-email-tao.ma@oracle.com>
References: <1232056719-27716-1-git-send-email-tao.ma@oracle.com>
Message-ID: <1232056840-27736-3-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2, the block group search looks for the "emptiest" group
to allocate from. So if the allocator has many equally(or almost
equally) empty groups, new block group will tend to get spread
out amongst them.

So we add osb_inode_alloc_group in ocfs2_super to record the last
used inode allocation group.
For more details, please see
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/InodeAllocationStrategy.

I have done some basic test and the results are cool.
1. single node test:
first column is the result without inode allocation patches, and the
second one with inode allocation patched enabled. You see we have
great improvement with the second "ls -lR".

echo 'y'|mkfs.ocfs2 -b 4K -C 4K -M local /dev/sda11

mount -t ocfs2 /dev/sda11 /mnt/ocfs2/
time tar jxvf /home/taoma/linux-2.6.28.tar.bz2 -C /mnt/ocfs2/ 1>/dev/null

real	0m20.548s 0m20.106s

umount /mnt/ocfs2/
echo 2 > /proc/sys/vm/drop_caches
mount -t ocfs2 /dev/sda11 /mnt/ocfs2/
time ls -lR /mnt/ocfs2/ 1>/dev/null

real	0m13.965s 0m13.766s

umount /mnt/ocfs2/
echo 2 > /proc/sys/vm/drop_caches
mount -t ocfs2 /dev/sda11 /mnt/ocfs2/
time rm /mnt/ocfs2/linux-2.6.28/ -rf

real	0m13.198s 0m13.091s

umount /mnt/ocfs2/
echo 2 > /proc/sys/vm/drop_caches
mount -t ocfs2 /dev/sda11 /mnt/ocfs2/
time tar jxvf /home/taoma/linux-2.6.28.tar.bz2 -C /mnt/ocfs2/ 1>/dev/null

real	0m23.022s 0m21.360s

umount /mnt/ocfs2/
echo 2 > /proc/sys/vm/drop_caches
mount -t ocfs2 /dev/sda11 /mnt/ocfs2/
time ls -lR /mnt/ocfs2/ 1>/dev/null

real	2m45.189s 0m15.019s(yes, that is it. :) )

2. Tested with 4 nodes(megabyte switch for both cross-node
communication and iscsi), with the same command sequence(using
openmpi to run the command simultaneously). Although we spend
a lot of time in cross-node communication, we still have some
performance improvement.

the 1st tar:
real	356.22s  357.70s

the 1st ls -lR:
real	187.33s  187.32s

the rm:
real	260.68s  262.42s

the 2nd tar:
real	371.92s  358.47s

the 2nd ls:
real	197.16s  188.36s

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2.h    |    3 +++
 fs/ocfs2/suballoc.c |   32 ++++++++++++++++++++++++++++----
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index ad5c24a..f0377bd 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -335,6 +335,9 @@ struct ocfs2_super
 	struct ocfs2_node_map		osb_recovering_orphan_dirs;
 	unsigned int			*osb_orphan_wipes;
 	wait_queue_head_t		osb_wipe_event;
+
+	/* the group we used to allocate inodes. */
+	u64				osb_inode_alloc_group;
 };
 
 #define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index b7a065e..4c1399c 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -66,6 +66,7 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 				   struct inode *alloc_inode,
 				   struct buffer_head *bh,
 				   u64 max_block,
+				   u64 *last_alloc_group,
 				   int flags);
 
 static int ocfs2_cluster_group_search(struct inode *inode,
@@ -407,6 +408,7 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 				   struct inode *alloc_inode,
 				   struct buffer_head *bh,
 				   u64 max_block,
+				   u64 *last_alloc_group,
 				   int flags)
 {
 	int status, credits;
@@ -444,6 +446,11 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 		goto bail;
 	}
 
+	if (last_alloc_group && *last_alloc_group != 0) {
+		mlog(0, "use old allocation group %llu for block group alloc\n",
+		     (unsigned long long)*last_alloc_group);
+		ac->ac_last_group = *last_alloc_group;
+	}
 	status = ocfs2_claim_clusters(osb,
 				      handle,
 				      ac,
@@ -518,6 +525,11 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 	alloc_inode->i_blocks = ocfs2_inode_sector_count(alloc_inode);
 
 	status = 0;
+
+	/* save the new last alloc group so that the caller can cache it. */
+	if (last_alloc_group)
+		*last_alloc_group = ac->ac_last_group;
+
 bail:
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
@@ -535,6 +547,7 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 				       struct ocfs2_alloc_context *ac,
 				       int type,
 				       u32 slot,
+				       u64 *last_alloc_group,
 				       int flags)
 {
 	int status;
@@ -600,7 +613,8 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 		}
 
 		status = ocfs2_block_group_alloc(osb, alloc_inode, bh,
-						 ac->ac_max_block, flags);
+						 ac->ac_max_block,
+						 last_alloc_group, flags);
 		if (status < 0) {
 			if (status != -ENOSPC)
 				mlog_errno(status);
@@ -644,7 +658,7 @@ int ocfs2_reserve_new_metadata_blocks(struct ocfs2_super *osb,
 
 	status = ocfs2_reserve_suballoc_bits(osb, (*ac),
 					     EXTENT_ALLOC_SYSTEM_INODE,
-					     slot, ALLOC_NEW_GROUP);
+					     slot, NULL, ALLOC_NEW_GROUP);
 	if (status < 0) {
 		if (status != -ENOSPC)
 			mlog_errno(status);
@@ -690,7 +704,8 @@ static int ocfs2_steal_inode_from_other_nodes(struct ocfs2_super *osb,
 
 		status = ocfs2_reserve_suballoc_bits(osb, ac,
 						     INODE_ALLOC_SYSTEM_INODE,
-						     slot, NOT_ALLOC_NEW_GROUP);
+						     slot, NULL,
+						     NOT_ALLOC_NEW_GROUP);
 		if (status >= 0) {
 			ocfs2_set_inode_steal_slot(osb, slot);
 			break;
@@ -707,6 +722,7 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
 {
 	int status;
 	s16 slot = ocfs2_get_inode_steal_slot(osb);
+	u64 alloc_group;
 
 	*ac = kzalloc(sizeof(struct ocfs2_alloc_context), GFP_KERNEL);
 	if (!(*ac)) {
@@ -742,14 +758,22 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
 		goto inode_steal;
 
 	atomic_set(&osb->s_num_inodes_stolen, 0);
+	alloc_group = osb->osb_inode_alloc_group;
 	status = ocfs2_reserve_suballoc_bits(osb, *ac,
 					     INODE_ALLOC_SYSTEM_INODE,
 					     osb->slot_num,
+					     &alloc_group,
 					     ALLOC_NEW_GROUP |
 					     ALLOC_GROUPS_FROM_GLOBAL);
 	if (status >= 0) {
 		status = 0;
 
+		spin_lock(&osb->osb_lock);
+		osb->osb_inode_alloc_group = alloc_group;
+		spin_unlock(&osb->osb_lock);
+		mlog(0, "after reservation, new allocation group is "
+		     "%llu\n", (unsigned long long)alloc_group);
+
 		/*
 		 * Some inodes must be freed by us, so try to allocate
 		 * from our own next time.
@@ -796,7 +820,7 @@ int ocfs2_reserve_cluster_bitmap_bits(struct ocfs2_super *osb,
 
 	status = ocfs2_reserve_suballoc_bits(osb, ac,
 					     GLOBAL_BITMAP_SYSTEM_INODE,
-					     OCFS2_INVALID_SLOT,
+					     OCFS2_INVALID_SLOT, NULL,
 					     ALLOC_NEW_GROUP);
 	if (status < 0 && status != -ENOSPC) {
 		mlog_errno(status);
-- 
1.5.5
