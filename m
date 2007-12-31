From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Dec 31 17:16:05 2007
Subject: [Ocfs2-devel] [PATCH 7/7] ocfs2: New slot map format
In-Reply-To: <1197004787-15344-8-git-send-email-joel.becker@oracle.com>
References: <1197004787-15344-1-git-send-email-joel.becker@oracle.com>
	<1197004787-15344-8-git-send-email-joel.becker@oracle.com>
Message-ID: <20080101011422.GD23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 06, 2007 at 09:19:47PM -0800, Joel Becker wrote:
> diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
> index a458d08..005a7dc 100644
> --- a/fs/ocfs2/slot_map.c
> +++ b/fs/ocfs2/slot_map.c
> @@ -51,6 +51,8 @@ struct ocfs2_slot {
>  struct ocfs2_slot_info_real {
>  	spinlock_t si_lock;
>  
> +	int si_extended;
> +	int si_slots_per_block;
>  	struct inode *si_inode;
>  	unsigned int si_blocks;
>  	struct buffer_head **si_bh;
> @@ -85,15 +87,33 @@ static void ocfs2_set_slot(struct ocfs2_slot_info_real *si,
>  	si->si_slots[slot_num].sl_node_num = node_num;
>  }
>  
> +/* This version is for the extended slot map */
> +static void ocfs2_update_slot_info_extended(struct ocfs2_slot_info_real *si)
> +{
> +	int b, i, slotno;
> +	struct ocfs2_slot_map_extended *se;
> +
> +	slotno = 0;
> +	for (b = 0; b < si->si_blocks; b++) {
> +		se = (struct ocfs2_slot_map_extended *)si->si_bh[b]->b_data;
> +		for (i = 0;
> +		     (i < si->si_slots_per_block) && (slotno < si->si_num_slots);
> +		     i++, slotno++) {
> +			if (se->se_slots[i].es_valid)
> +				ocfs2_set_slot(si, slotno,
> +					       le32_to_cpu(se->se_slots[i].es_node_num));
> +			else
> +				ocfs2_invalidate_slot(si, slotno);
> +		}
> +	}
> +}
> +
>  /* post the slot information on disk into our slot_info struct. */
> -static void ocfs2_update_slot_info(struct ocfs2_slot_info_real *si)
> +static void ocfs2_update_slot_info_old(struct ocfs2_slot_info_real *si)
>  {
>  	int i;
>  	struct ocfs2_slot_map *sm;
>  
> -	/* we don't read the slot block here as ocfs2_super_lock
> -	 * should've made sure we have the most recent copy. */
> -	spin_lock(&si->si_lock);
>  	sm = (struct ocfs2_slot_map *)si->si_bh[0]->b_data;
>  
>  	for (i = 0; i < si->si_num_slots; i++) {
> @@ -102,7 +122,17 @@ static void ocfs2_update_slot_info(struct ocfs2_slot_info_real *si)
>  		else
>  			ocfs2_set_slot(si, i, le16_to_cpu(sm->sm_slots[i]));
>  	}
> +}
>  
> +static void ocfs2_update_slot_info(struct ocfs2_slot_info_real *si)
> +{
> +	/* we don't read the slot block here as ocfs2_super_lock
> +	 * should've made sure we have the most recent copy. */

Should probably update the comment while you're moving it.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
