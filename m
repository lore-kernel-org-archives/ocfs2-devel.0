From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Dec 10 14:33:46 2007
Subject: [Ocfs2-devel] [PATCH 2/7] ocfs2: Wrap all other access to
	ocfs2_slot_info.
In-Reply-To: <1197004787-15344-3-git-send-email-joel.becker@oracle.com>
References: <1197004787-15344-1-git-send-email-joel.becker@oracle.com>
	<1197004787-15344-3-git-send-email-joel.becker@oracle.com>
Message-ID: <20071210223324.GW28607@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 06, 2007 at 09:19:42PM -0800, Joel Becker wrote:
> diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
> index f5727b8..a4f2c02 100644
> --- a/fs/ocfs2/slot_map.c
> +++ b/fs/ocfs2/slot_map.c
> @@ -42,14 +42,30 @@
>  
>  #include "buffer_head_io.h"
>  
> -static s16 __ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
> +struct ocfs2_slot_info_real {
> +	spinlock_t si_lock;
> +
> +	struct inode *si_inode;
> +	struct buffer_head *si_bh;
> +	unsigned int si_num_slots;
> +	unsigned int si_size;
> +	s16 si_global_node_nums[OCFS2_MAX_SLOTS];
> +};
> +
> +static inline struct ocfs2_slot_info_real *to_slot_info(struct ocfs2_super *osb)
> +{
> +	return (struct ocfs2_slot_info_real *)osb->slot_info;
> +}
> +

...

> diff --git a/fs/ocfs2/slot_map.h b/fs/ocfs2/slot_map.h
> index b029ffd..14b065b 100644
> --- a/fs/ocfs2/slot_map.h
> +++ b/fs/ocfs2/slot_map.h
> @@ -29,12 +29,6 @@
>  
>  struct ocfs2_slot_info {
>  	spinlock_t si_lock;
> -
> -	struct inode *si_inode;
> -	struct buffer_head *si_bh;
> -	unsigned int si_num_slots;
> -	unsigned int si_size;
> -	s16 si_global_node_nums[OCFS2_MAX_SLOTS];
>  };

Ok, so we need to either use 'osb->osb_lock' for slot info locking and drop
ocfs2_slot_info from slot_map.h completely, or just leave the definition in
slot_map.h. As it stands in this patch, if we add anything to 'struct
ocfs2_slot_info' or move 'si_lock' around in 'struct ocfs2_slot_info_real'
things will blow up :(
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
