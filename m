From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 25 Feb 2010 13:58:09 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2-1.4: add extent block stealing
In-Reply-To: <12666493991177-git-send-email-tiger.yang@oracle.com>
References: <12666493991177-git-send-email-tiger.yang@oracle.com>
Message-ID: <4B861171.9030005@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ack.

Tiger Yang wrote:
> This patch add extent block (metadata) stealing mechanism for
> extent allocation. This mechanism is same as the inode stealing.
> if no room in slot specific extent_alloc, we will try to
> allocate extent block from the next slot.
> 
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
> ---
>  fs/ocfs2/alloc.c      |    5 +-
>  fs/ocfs2/localalloc.c |    2 +-
>  fs/ocfs2/ocfs2.h      |   29 +--------
>  fs/ocfs2/suballoc.c   |  171 +++++++++++++++++++++++++++++++++++++------------
>  fs/ocfs2/suballoc.h   |    1 +
>  fs/ocfs2/super.c      |   10 ++-
>  6 files changed, 145 insertions(+), 73 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 1833027..15b3672 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -467,7 +467,8 @@ static int ocfs2_create_new_meta_bhs(struct ocfs2_super *osb,
>  			strcpy(eb->h_signature, OCFS2_EXTENT_BLOCK_SIGNATURE);
>  			eb->h_blkno = cpu_to_le64(first_blkno);
>  			eb->h_fs_generation = cpu_to_le32(osb->fs_generation);
> -			eb->h_suballoc_slot = cpu_to_le16(osb->slot_num);
> +			eb->h_suballoc_slot =
> +				cpu_to_le16(meta_ac->ac_alloc_slot);
>  			eb->h_suballoc_bit = cpu_to_le16(suballoc_bit_start);
>  			eb->h_list.l_count =
>  				cpu_to_le16(ocfs2_extent_recs_per_eb(osb->sb));
> @@ -5249,7 +5250,7 @@ static void ocfs2_truncate_log_worker(kapi_work_struct_t *work)
>  	if (status < 0)
>  		mlog_errno(status);
>  	else
> -		ocfs2_init_inode_steal_slot(osb);
> +		ocfs2_init_steal_slots(osb);
>  
>  	mlog_exit(status);
>  }
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index d4ff66a..fe36983 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -474,7 +474,7 @@ out_mutex:
>  
>  out:
>  	if (!status)
> -		ocfs2_init_inode_steal_slot(osb);
> +		ocfs2_init_steal_slots(osb);
>  	mlog_exit(status);
>  	return status;
>  }
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index a6d2df9..2d44a29 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -251,7 +251,9 @@ struct ocfs2_super
>  	u32 s_next_generation;
>  	unsigned long osb_flags;
>  	s16 s_inode_steal_slot;
> +	s16 s_meta_steal_slot;
>  	atomic_t s_num_inodes_stolen;
> +	atomic_t s_num_meta_stolen;
>  
>  	unsigned long s_mount_opt;
>  	unsigned int s_atime_quantum;
> @@ -588,33 +590,6 @@ static inline unsigned int ocfs2_megabytes_to_clusters(struct super_block *sb,
>  	return megs << (20 - OCFS2_SB(sb)->s_clustersize_bits);
>  }
>  
> -static inline void ocfs2_init_inode_steal_slot(struct ocfs2_super *osb)
> -{
> -	spin_lock(&osb->osb_lock);
> -	osb->s_inode_steal_slot = OCFS2_INVALID_SLOT;
> -	spin_unlock(&osb->osb_lock);
> -	atomic_set(&osb->s_num_inodes_stolen, 0);
> -}
> -
> -static inline void ocfs2_set_inode_steal_slot(struct ocfs2_super *osb,
> -					      s16 slot)
> -{
> -	spin_lock(&osb->osb_lock);
> -	osb->s_inode_steal_slot = slot;
> -	spin_unlock(&osb->osb_lock);
> -}
> -
> -static inline s16 ocfs2_get_inode_steal_slot(struct ocfs2_super *osb)
> -{
> -	s16 slot;
> -
> -	spin_lock(&osb->osb_lock);
> -	slot = osb->s_inode_steal_slot;
> -	spin_unlock(&osb->osb_lock);
> -
> -	return slot;
> -}
> -
>  #define ocfs2_set_bit ext2_set_bit
>  #define ocfs2_clear_bit ext2_clear_bit
>  #define ocfs2_test_bit ext2_test_bit
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index d4858ee..48f0782 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -50,7 +50,7 @@
>  #define ALLOC_NEW_GROUP			0x1
>  #define ALLOC_GROUPS_FROM_GLOBAL	0x2
>  
> -#define OCFS2_MAX_INODES_TO_STEAL	1024
> +#define OCFS2_MAX_TO_STEAL		1024
>  
>  static inline void ocfs2_debug_bg(struct ocfs2_group_desc *bg);
>  static inline void ocfs2_debug_suballoc_inode(struct ocfs2_dinode *fe);
> @@ -510,12 +510,113 @@ bail:
>  	return status;
>  }
>  
> +static void ocfs2_init_inode_steal_slot(struct ocfs2_super *osb)
> +{
> +	spin_lock(&osb->osb_lock);
> +	osb->s_inode_steal_slot = OCFS2_INVALID_SLOT;
> +	spin_unlock(&osb->osb_lock);
> +	atomic_set(&osb->s_num_inodes_stolen, 0);
> +}
> +
> +static void ocfs2_init_meta_steal_slot(struct ocfs2_super *osb)
> +{
> +	spin_lock(&osb->osb_lock);
> +	osb->s_meta_steal_slot = OCFS2_INVALID_SLOT;
> +	spin_unlock(&osb->osb_lock);
> +	atomic_set(&osb->s_num_meta_stolen, 0);
> +}
> +
> +void ocfs2_init_steal_slots(struct ocfs2_super *osb)
> +{
> +	ocfs2_init_inode_steal_slot(osb);
> +	ocfs2_init_meta_steal_slot(osb);
> +}
> +
> +static void __ocfs2_set_steal_slot(struct ocfs2_super *osb, int slot, int type)
> +{
> +	spin_lock(&osb->osb_lock);
> +	if (type == INODE_ALLOC_SYSTEM_INODE)
> +		osb->s_inode_steal_slot = slot;
> +	else if (type == EXTENT_ALLOC_SYSTEM_INODE)
> +		osb->s_meta_steal_slot = slot;
> +	spin_unlock(&osb->osb_lock);
> +}
> +
> +static int __ocfs2_get_steal_slot(struct ocfs2_super *osb, int type)
> +{
> +	int slot = OCFS2_INVALID_SLOT;
> +
> +	spin_lock(&osb->osb_lock);
> +	if (type == INODE_ALLOC_SYSTEM_INODE)
> +		slot = osb->s_inode_steal_slot;
> +	else if (type == EXTENT_ALLOC_SYSTEM_INODE)
> +		slot = osb->s_meta_steal_slot;
> +	spin_unlock(&osb->osb_lock);
> +
> +	return slot;
> +}
> +
> +static int ocfs2_get_inode_steal_slot(struct ocfs2_super *osb)
> +{
> +	return __ocfs2_get_steal_slot(osb, INODE_ALLOC_SYSTEM_INODE);
> +}
> +
> +static int ocfs2_get_meta_steal_slot(struct ocfs2_super *osb)
> +{
> +	return __ocfs2_get_steal_slot(osb, EXTENT_ALLOC_SYSTEM_INODE);
> +}
> +
> +static int ocfs2_steal_resource(struct ocfs2_super *osb,
> +				struct ocfs2_alloc_context *ac,
> +				int type)
> +{
> +	int i, status = -ENOSPC;
> +	int slot = __ocfs2_get_steal_slot(osb, type);
> +
> +	/* Start to steal resource from the first slot after ours. */
> +	if (slot == OCFS2_INVALID_SLOT)
> +		slot = osb->slot_num + 1;
> +
> +	for (i = 0; i < osb->max_slots; i++, slot++) {
> +		if (slot == osb->max_slots)
> +			slot = 0;
> +
> +		if (slot == osb->slot_num)
> +			continue;
> +
> +		status = ocfs2_reserve_suballoc_bits(osb, ac,
> +						     type,
> +						     (u32)slot, NULL,
> +						     NOT_ALLOC_NEW_GROUP);
> +		if (status >= 0) {
> +			__ocfs2_set_steal_slot(osb, slot, type);
> +			break;
> +		}
> +
> +		ocfs2_free_ac_resource(ac);
> +	}
> +
> +	return status;
> +}
> +
> +static int ocfs2_steal_inode(struct ocfs2_super *osb,
> +			     struct ocfs2_alloc_context *ac)
> +{
> +	return ocfs2_steal_resource(osb, ac, INODE_ALLOC_SYSTEM_INODE);
> +}
> +
> +static int ocfs2_steal_meta(struct ocfs2_super *osb,
> +			    struct ocfs2_alloc_context *ac)
> +{
> +	return ocfs2_steal_resource(osb, ac, EXTENT_ALLOC_SYSTEM_INODE);
> +}
> +
>  int ocfs2_reserve_new_metadata(struct ocfs2_super *osb,
>  			       struct ocfs2_dinode *fe,
>  			       struct ocfs2_alloc_context **ac)
>  {
>  	int status;
> -	u32 slot;
> +	int slot = ocfs2_get_meta_steal_slot(osb);
>  
>  	*ac = kzalloc(sizeof(struct ocfs2_alloc_context), GFP_KERNEL);
>  	if (!(*ac)) {
> @@ -526,12 +627,34 @@ int ocfs2_reserve_new_metadata(struct ocfs2_super *osb,
>  
>  	(*ac)->ac_bits_wanted = ocfs2_extend_meta_needed(fe);
>  	(*ac)->ac_which = OCFS2_AC_USE_META;
> -	slot = osb->slot_num;
>  	(*ac)->ac_group_search = ocfs2_block_group_search;
>  
> +	if (slot != OCFS2_INVALID_SLOT &&
> +		atomic_read(&osb->s_num_meta_stolen) < OCFS2_MAX_TO_STEAL)
> +		goto extent_steal;
> +
> +	atomic_set(&osb->s_num_meta_stolen, 0);
>  	status = ocfs2_reserve_suballoc_bits(osb, (*ac),
>  					     EXTENT_ALLOC_SYSTEM_INODE,
> -					     slot, NULL, ALLOC_NEW_GROUP);
> +					     (u32)osb->slot_num, NULL,
> +					     ALLOC_NEW_GROUP);
> +
> +
> +	if (status >= 0) {
> +		status = 0;
> +		if (slot != OCFS2_INVALID_SLOT)
> +			ocfs2_init_meta_steal_slot(osb);
> +		goto bail;
> +	} else if (status < 0 && status != -ENOSPC) {
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +
> +	ocfs2_free_ac_resource(*ac);
> +
> +extent_steal:
> +	status = ocfs2_steal_meta(osb, *ac);
> +	atomic_inc(&osb->s_num_meta_stolen);
>  	if (status < 0) {
>  		if (status != -ENOSPC)
>  			mlog_errno(status);
> @@ -549,43 +672,11 @@ bail:
>  	return status;
>  }
>  
> -static int ocfs2_steal_inode_from_other_nodes(struct ocfs2_super *osb,
> -					      struct ocfs2_alloc_context *ac)
> -{
> -	int i, status = -ENOSPC;
> -	s16 slot = ocfs2_get_inode_steal_slot(osb);
> -
> -	/* Start to steal inodes from the first slot after ours. */
> -	if (slot == OCFS2_INVALID_SLOT)
> -		slot = osb->slot_num + 1;
> -
> -	for (i = 0; i < osb->max_slots; i++, slot++) {
> -		if (slot == osb->max_slots)
> -			slot = 0;
> -
> -		if (slot == osb->slot_num)
> -			continue;
> -
> -		status = ocfs2_reserve_suballoc_bits(osb, ac,
> -						     INODE_ALLOC_SYSTEM_INODE,
> -						     slot, NULL,
> -						     NOT_ALLOC_NEW_GROUP);
> -		if (status >= 0) {
> -			ocfs2_set_inode_steal_slot(osb, slot);
> -			break;
> -		}
> -
> -		ocfs2_free_ac_resource(ac);
> -	}
> -
> -	return status;
> -}
> -
>  int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
>  			    struct ocfs2_alloc_context **ac)
>  {
>  	int status;
> -	s16 slot = ocfs2_get_inode_steal_slot(osb);
> +	int slot = ocfs2_get_inode_steal_slot(osb);
>  	u64 alloc_group;
>  
>  	*ac = kzalloc(sizeof(struct ocfs2_alloc_context), GFP_KERNEL);
> @@ -610,14 +701,14 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
>  	 * need to check our slots to see whether there is some space for us.
>  	 */
>  	if (slot != OCFS2_INVALID_SLOT &&
> -	    atomic_read(&osb->s_num_inodes_stolen) < OCFS2_MAX_INODES_TO_STEAL)
> +	    atomic_read(&osb->s_num_inodes_stolen) < OCFS2_MAX_TO_STEAL)
>  		goto inode_steal;
>  
>  	atomic_set(&osb->s_num_inodes_stolen, 0);
>  	alloc_group = osb->osb_inode_alloc_group;
>  	status = ocfs2_reserve_suballoc_bits(osb, *ac,
>  					     INODE_ALLOC_SYSTEM_INODE,
> -					     osb->slot_num,
> +					     (u32)osb->slot_num,
>  					     &alloc_group,
>  					     ALLOC_NEW_GROUP |
>  					     ALLOC_GROUPS_FROM_GLOBAL);
> @@ -645,7 +736,7 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
>  	ocfs2_free_ac_resource(*ac);
>  
>  inode_steal:
> -	status = ocfs2_steal_inode_from_other_nodes(osb, *ac);
> +	status = ocfs2_steal_inode(osb, *ac);
>  	atomic_inc(&osb->s_num_inodes_stolen);
>  	if (status < 0) {
>  		if (status != -ENOSPC)
> diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
> index 16f9c9c..35e2d69 100644
> --- a/fs/ocfs2/suballoc.h
> +++ b/fs/ocfs2/suballoc.h
> @@ -53,6 +53,7 @@ struct ocfs2_alloc_context {
>  	u64    ac_last_group;
>  };
>  
> +void ocfs2_init_steal_slots(struct ocfs2_super *osb);
>  void ocfs2_free_alloc_context(struct ocfs2_alloc_context *ac);
>  static inline int ocfs2_alloc_context_bits_left(struct ocfs2_alloc_context *ac)
>  {
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index b870a0f..4499b93 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -65,6 +65,7 @@
>  #include "sysfile.h"
>  #include "uptodate.h"
>  #include "ver.h"
> +#include "suballoc.h"
>  
>  #include "buffer_head_io.h"
>  
> @@ -276,9 +277,12 @@ static int ocfs2_osb_dump(struct ocfs2_super *osb, char *buf, int len)
>  
>  	spin_lock(&osb->osb_lock);
>  	out += snprintf(buf + out, len - out,
> -			"%10s => Slot: %d  NumStolen: %d\n", "Steal",
> +			"%10s => InodeSlot: %d  StolenInodes: %d, "
> +			"MetaSlot: %d  StolenMeta: %d\n", "Steal",
>  			osb->s_inode_steal_slot,
> -			atomic_read(&osb->s_num_inodes_stolen));
> +			atomic_read(&osb->s_num_inodes_stolen),
> +			osb->s_meta_steal_slot,
> +			atomic_read(&osb->s_num_meta_stolen));
>  	spin_unlock(&osb->osb_lock);
>  
>  	out += snprintf(buf + out, len - out, "OrphanScan => ");
> @@ -1634,7 +1638,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  	INIT_LIST_HEAD(&osb->blocked_lock_list);
>  	osb->blocked_lock_count = 0;
>  	spin_lock_init(&osb->osb_lock);
> -	ocfs2_init_inode_steal_slot(osb);
> +	ocfs2_init_steal_slots(osb);
>  
>  	atomic_set(&osb->alloc_stats.moves, 0);
>  	atomic_set(&osb->alloc_stats.local_data, 0);
