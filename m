From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 20 Jan 2010 14:43:19 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: add extent block stealing for
	ocfs2
In-Reply-To: <4B542738.90003@oracle.com>
References: <> <1263635115-4930-1-git-send-email-tiger.yang@oracle.com>
	<4B542738.90003@oracle.com>
Message-ID: <20100120224319.GC4333@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jan 18, 2010 at 05:17:44PM +0800, Tiger Yang wrote:
> @@ -756,28 +758,50 @@ static inline unsigned int ocfs2_megabytes_to_clusters(struct super_block *sb,
>  	return megs << (20 - OCFS2_SB(sb)->s_clustersize_bits);
>  }
>  
> -static inline void ocfs2_init_inode_steal_slot(struct ocfs2_super *osb)
> +static inline void ocfs2_init_all_steal_slot(struct ocfs2_super *osb)
>  {
>  	spin_lock(&osb->osb_lock);
>  	osb->s_inode_steal_slot = OCFS2_INVALID_SLOT;
> +	osb->s_extent_steal_slot = OCFS2_INVALID_SLOT;
>  	spin_unlock(&osb->osb_lock);
>  	atomic_set(&osb->s_num_inodes_stolen, 0);
> +	atomic_set(&osb->s_num_extents_stolen, 0);
>  }

	Call this ocfs2_init_steal_slots().  The 'all' is redundant.

> -static inline void ocfs2_set_inode_steal_slot(struct ocfs2_super *osb,
> -					      s16 slot)
> +static inline void ocfs2_init_steal_slot(struct ocfs2_super *osb, int type)
>  {
>  	spin_lock(&osb->osb_lock);
> -	osb->s_inode_steal_slot = slot;
> +	if (type == INODE_ALLOC_SYSTEM_INODE)
> +		osb->s_inode_steal_slot = OCFS2_INVALID_SLOT;
> +	else if (type == EXTENT_ALLOC_SYSTEM_INODE)
> +		osb->s_extent_steal_slot = OCFS2_INVALID_SLOT;
>  	spin_unlock(&osb->osb_lock);
> +	if (type == INODE_ALLOC_SYSTEM_INODE)
> +		atomic_set(&osb->s_num_inodes_stolen, 0);
> +	else if (type == EXTENT_ALLOC_SYSTEM_INODE)
> +		atomic_set(&osb->s_num_extents_stolen, 0);
>  }

	Don't pass in 'type' to steal slot functions.  Instead, call
them by name.  ocfs2_get_inode_steal_slot(),
ocfs2_get_meta_steal_slot(), etc.  You can, of course, wrap a common
function.  But the actual users are much more readable with good names:

    ocfs2_get_meta_steal_slot(osb);

vs

    ocfs2_get_steal_slot(osb, INODE_ALLOC_SYSTEM_INODE);

There's no need for the callers to have to know the type enum.

> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index c30b644..a3b9997 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -52,6 +52,7 @@
>  #define ALLOC_GROUPS_FROM_GLOBAL	0x2
>  
>  #define OCFS2_MAX_INODES_TO_STEAL	1024
> +#define OCFS2_MAX_EXTENTS_TO_STEAL	1024

	Since this is the same number, just have one stealing constant.
Maybe OCFS2_MAX_TO_STEAL?

> +static int ocfs2_steal_from_other_nodes(struct ocfs2_super *osb,
> +					struct ocfs2_alloc_context *ac,
> +					int type)

	Again, have to functions for stealing: ocfs2_steal_inode() and
ocfs2_steal_meta().  You can have them call this version with a type
field, but that should be hidden from the call sites.  You don't need
"_from_other_nodes" in the name.

Joel

-- 

"Nearly all men can stand adversity, but if you really want to
 test a man's character, give him power."
	- Abraham Lincoln

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
