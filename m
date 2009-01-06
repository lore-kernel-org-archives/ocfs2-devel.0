From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 6 Jan 2009 11:47:31 -0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Allocate inode groups from
	global_bitmap.
In-Reply-To: <1227826725-13107-2-git-send-email-tao.ma@oracle.com>
References: <492F946F.1060409@oracle.com>
	<1227826725-13107-2-git-send-email-tao.ma@oracle.com>
Message-ID: <20090106194731.GR17410@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Nov 28, 2008 at 06:58:44AM +0800, Tao Ma wrote:
> Inode groups used to be allocated from local alloc file, but since
> we want all inodes to be contiguous enough, we will try to allocate
> them directly from global_bitmap.
> 
> Add a new flag named "ALLOC_NEW_GROUP_FROM_GLOBAL", if we pass this
> flag into allocation, don't try local alloc.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/suballoc.c |   33 +++++++++++++++++++++------------
>  1 files changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index f75782f..98e32b2 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -47,7 +47,8 @@
>  #include "buffer_head_io.h"
>  
>  #define NOT_ALLOC_NEW_GROUP		0
> -#define ALLOC_NEW_GROUP			1
> +#define ALLOC_NEW_GROUP			0x1
> +#define ALLOC_NEW_GROUP_FROM_GLOBAL	0x2

How about "ALLOC_GROUPS_FROM_GLOBAL"? That makes it clear we're only
modifying *where* new groups come from.


>  #define OCFS2_MAX_INODES_TO_STEAL	1024
>  
> @@ -63,7 +64,8 @@ static int ocfs2_block_group_fill(handle_t *handle,
>  static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
>  				   struct inode *alloc_inode,
>  				   struct buffer_head *bh,
> -				   u64 max_block);
> +				   u64 max_block,
> +				   int flags);
>  
>  static int ocfs2_cluster_group_search(struct inode *inode,
>  				      struct buffer_head *group_bh,
> @@ -115,7 +117,8 @@ static inline void ocfs2_block_to_cluster_group(struct inode *inode,
>  						u16 *bg_bit_off);
>  static int ocfs2_reserve_clusters_with_limit(struct ocfs2_super *osb,
>  					     u32 bits_wanted, u64 max_block,
> -					     struct ocfs2_alloc_context **ac);
> +					     struct ocfs2_alloc_context **ac,
> +					     int flags);

Can you put the 'int flags' before the **ac return value here please?


I'm saddened that we're adding a flags field to so many functions, but after
looking through the code, I can't really come up with a better solution.
	--Mark

--
Mark Fasheh
