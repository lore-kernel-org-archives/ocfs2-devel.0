From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Mar  4 16:48:01 2008
Subject: [Ocfs2-devel] [PATCH 3/3] Add inode stealing for
	ocfs2_reserve_new_inode.V4
In-Reply-To: <20080304085525.GA22501@tma-pc1.cn.oracle.com>
References: <47CCB2F8.3040702@oracle.com>
	<20080304085525.GA22501@tma-pc1.cn.oracle.com>
Message-ID: <20080305004412.GO9349@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 04, 2008 at 04:55:25PM +0800, tao.ma wrote:
> Modified as Sunil suggested.
> 
> 2 new variables are added. They are:
> 1) ocfs2_super->s_inode_steal_slot. It is initalized as invalid and only
>    set valid when we steal inode from other slots successfully. When we
>    flush the truncate log, complete local alloc recovery or allocate
>    from our own slot successfully, it will be reset to invalid.
> 2) ocfs2_super->s_num_inodes_stolen. It is used to record the times we try
>    to steal inode from other nodes. And it is increased no matter whether
>    our steal succeed or not. It is reset to zero when we try to allocate
>    from our own slot or reset the s_inode_steal_slot.
> 
> So with this 2 new variables, now the whole inode allocation process is:
> 1. Check whether the s_inode_steal_slot is valid. If it is invalid, goto
>    step 2, that is to try to allocate from our own. If it is valid, then
>    we must have stealed inode successfully just now, so verify whether we
>    have steal "s_num_inodes_stolen". If yes, goto step 2 since now we need
>    to try own slot in case there is some space for us. If not, goto step 3
>    and steal from other nodes directly.
> 2. Allocate from its own inode_alloc:000X and zero s_num_inodes_stolen.
>    1) If we can reserve, OK.
>    2) If fails, try to allocate a large chunk and reserve once again.
>    3) If OK, clear s_inode_steal_slot and exit directly.
> 3. Try to allocate from other nodes.
>    1) If s_inode_steal_slot is valid, start from that node, otherwise
>       start from the node next to us. This time, Just try to reserve in
>       inode_alloc, we don't go for global_bitmap if this node also can't
>       allocate the inode.
>    3) Try the node next to it until we reach the first steal slot again.
>    4) If we succeed in one node's inode_alloc, set s_inode_steal_slot to it.
>    5) increase s_num_inodes_stolen.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

Ok, this is all in ocfs2.git now. I made the following changes though, so
please verify.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index e9ad7f9..0273a55 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -178,8 +178,6 @@ enum ocfs2_mount_options
 #define OCFS2_OSB_ERROR_FS	0x0004
 #define OCFS2_DEFAULT_ATIME_QUANTUM	60
 
-#define OCFS2_NUM_INODES_STOLEN 10
-
 struct ocfs2_journal;
 struct ocfs2_super
 {
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 2fcefab..2a61875 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -49,6 +49,8 @@
 #define NOT_ALLOC_NEW_GROUP		0
 #define ALLOC_NEW_GROUP			1
 
+#define OCFS2_MAX_INODES_TO_STEAL	1024
+
 static inline void ocfs2_debug_bg(struct ocfs2_group_desc *bg);
 static inline void ocfs2_debug_suballoc_inode(struct ocfs2_dinode *fe);
 static inline u16 ocfs2_find_victim_chain(struct ocfs2_chain_list *cl);
@@ -591,7 +593,7 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
 	 * need to check our slots to see whether there is some space for us.
 	 */
 	if (slot != OCFS2_INVALID_SLOT &&
-	    atomic_read(&osb->s_num_inodes_stolen) < OCFS2_NUM_INODES_STOLEN)
+	    atomic_read(&osb->s_num_inodes_stolen) < OCFS2_MAX_INODES_TO_STEAL)
 		goto inode_steal;
 
 	atomic_set(&osb->s_num_inodes_stolen, 0);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index c4e82c7..c4e7c97 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1405,6 +1405,8 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	osb->local_alloc_state = OCFS2_LA_UNUSED;
 	osb->local_alloc_bh = NULL;
 
+	osb->s_num_inodes_stolen = ATOMIC_INIT(0);
+
 	ocfs2_setup_hb_callbacks(osb);
 
 	init_waitqueue_head(&osb->osb_mount_event);
