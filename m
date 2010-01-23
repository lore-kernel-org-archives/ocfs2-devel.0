From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 22 Jan 2010 16:13:22 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: add extent block stealing for
	ocfs2 v4
In-Reply-To: <1264147166-9097-1-git-send-email-tiger.yang@oracle.com>
References: <>
 <1264147166-9097-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <20100123001322.GA8165@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 22, 2010 at 03:59:26PM +0800, Tiger Yang wrote:
> +void ocfs2_init_steal_slot(struct ocfs2_super *osb)
> +{
> +	ocfs2_init_inode_steal_slot(osb);
> +	ocfs2_init_meta_steal_slot(osb);
> +}

	This should be ocfs2_init_steal_slots().  'slots', not 'slot',
because it is plural.

>  int ocfs2_reserve_new_metadata_blocks(struct ocfs2_super *osb,
>  				      int blocks,
>  				      struct ocfs2_alloc_context **ac)
>  {
>  	int status;
> -	u32 slot;
> +	int slot = ocfs2_get_meta_steal_slot(osb);
>  
>  	*ac = kzalloc(sizeof(struct ocfs2_alloc_context), GFP_KERNEL);
>  	if (!(*ac)) {
> @@ -653,12 +754,34 @@ int ocfs2_reserve_new_metadata_blocks(struct ocfs2_super *osb,
>  
>  	(*ac)->ac_bits_wanted = blocks;
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

	The int-vs-u32 casting is weird.  Note sure what to make of it.
Why does ocfs2_reserve_suballoc_bits() take a u32 instead of an int?

Joel

-- 

"Against stupidity the Gods themselves contend in vain."
	- Friedrich von Schiller

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
