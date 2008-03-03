From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Mon Mar  3 18:25:34 2008
Subject: [Ocfs2-devel] [PATCH 3/3] Add inode stealing
	for	ocfs2_reserve_new_inode.V3
In-Reply-To: <20080303091251.GA18140@tma-pc1.cn.oracle.com>
References: <20080303091251.GA18140@tma-pc1.cn.oracle.com>
Message-ID: <47CCB2F8.3040702@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tao Ma wrote:
> +static inline void ocfs2_set_inode_steal_slot(struct ocfs2_super *osb,
> +					      u16 slot)
> +{
> +	spin_lock(&osb->osb_lock);
> +	osb->s_inode_steal_slot = slot;
> +	spin_unlock(&osb->osb_lock);
> +}

Shouldn't slot be s16 and not u16.

>  
> +static int ocfs2_steal_inode_from_other_nodes(struct ocfs2_super *osb,
> +					      struct ocfs2_alloc_context *ac)
> +{
> +	int status = -ENOSPC, i;
> +	s16 slot = ocfs2_get_inode_steal_slot(osb);
> +
> +	/*
> +	 * This is the first time we try to steal inodes, so begin
> +	 * with the node next to us first.
> +	 */

Change comment to:
/* Start to steal inodes from the first slot after ours. */

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
> +						     INODE_ALLOC_SYSTEM_INODE,
> +						     slot, NOT_ALLOC_NEW_GROUP);
> +		if (status >= 0) {
> +			ocfs2_set_inode_steal_slot(osb, slot);
> +			break;
> +		}
> +
> +		ocfs2_free_ac_resource(ac);
> +	}
> +
> +	return status;
> +}
> +
if (slot == OCFS2_INVALID_SLOT)
slot = (osb->slot_num + 1 == osb->max_slots) ? 0 : osb->slot_num + 1;

while (slot != osb->slot_num) {
status = ocfs2_reserve_suballoc_bits(osb, ....);
...
ocfs2_free_ac_resource(ac);
slot = (slot + 1 == osb->max_slots) ? 0 : slot + 1;
}

Not that your code is incorrect. Other option is to not use "i"
and replace continue with a break.

>  int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
>  			    struct ocfs2_alloc_context **ac)
>  {
>  	int status;
> +	s16 slot = ocfs2_get_inode_steal_slot(osb);
> +#define OCFS2_INODE_STEAL_TIMES 10
> +	static atomic_t inode_steal_times = ATOMIC_INIT(0);

Can you rename inode_steal_times to num_inodes_stolen. BTW, this
will be for all mounts which is not what we want. Why don't you
add this to ocfs2_super? s_num_inodes_stolen. In that case, protect
it using osb_lock.

>  
>  	*ac = kzalloc(sizeof(struct ocfs2_alloc_context), GFP_KERNEL);
>  	if (!(*ac)) {
> @@ -539,9 +584,43 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
>  
>  	(*ac)->ac_group_search = ocfs2_block_group_search;
>  
> +	/*
> +	 * slot is set when we successfully steal inode from other nodes.
> +	 * It is reset in 3 places:
> +	 * 1. when we flush the turncate log

spelling... truncate

> +	 * 2. when we complete local alloc recovery.
> +	 * 3. when we successfully allocate from our own slot.
> +	 * After it is set, we will go on stealing inodes until we find the
> +	 * need to check our slots to see wether there is some space for us.
> +	 */

spelling... whether

> +	if (slot != OCFS2_INVALID_SLOT &&
> +	    atomic_read(&inode_steal_times) < OCFS2_INODE_STEAL_TIMES)
> +		goto inode_steal;
> +
> +	atomic_set(&inode_steal_times, 0);
>  	status = ocfs2_reserve_suballoc_bits(osb, *ac,
>  					     INODE_ALLOC_SYSTEM_INODE,
>  					     osb->slot_num, ALLOC_NEW_GROUP);
> +	if (status >= 0) {
> +		status = 0;
> +
> +		/*
> +		 * Some inodes must be freed by us, so try to allocate
> +		 * from our own next time.
> +		 */
> +		if (slot != OCFS2_INVALID_SLOT)
> +			ocfs2_init_inode_steal_slot(osb);
> +		goto bail;
> +	} else if (status < 0 && status != -ENOSPC) {
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +
> +	ocfs2_free_ac_resource(*ac);
> +
> +inode_steal:
> +	status = ocfs2_steal_inode_from_other_nodes(osb, *ac);
> +	atomic_inc(&inode_steal_times);
>  	if (status < 0) {
>  		if (status != -ENOSPC)
>  			mlog_errno(status);
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index bec75af..c4e82c7 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -1193,6 +1193,7 @@ static int ocfs2_mount_volume(struct super_block *sb)
>  		mlog_errno(status);
>  		goto leave;
>  	}
> +	ocfs2_init_inode_steal_slot(osb);
>  
>  	/* load all node-local system inodes */
>  	status = ocfs2_init_local_system_inodes(osb);
