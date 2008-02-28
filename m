From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Feb 28 15:08:33 2008
Subject: [Ocfs2-devel] [PATCH 2/3] Add ac_alloc_slot in
	ocfs2_alloc_context.V2
In-Reply-To: <20080228065948.GA29321@tma-pc1.cn.oracle.com>
References: <20080228063438.GA27318@tma-pc1.cn.oracle.com>
	<20080228065948.GA29321@tma-pc1.cn.oracle.com>
Message-ID: <20080228230757.GV27865@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 28, 2008 at 02:59:48PM +0800, tao.ma wrote:
> In inode stealing, we no longer restrict the allocation to
> happen in the local node. So it is neccessary for us to add
> a new member in ocfs2_alloc_context to indicate which slot
> we are using for allocation. We also modify the process of
> local alloc so that this member can be used there also.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/localalloc.c |    1 +
>  fs/ocfs2/suballoc.c   |    1 +
>  fs/ocfs2/suballoc.h   |    1 +
>  3 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index add1ffd..250b4bc 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -526,6 +526,7 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
>  	}
>  
>  	ac->ac_inode = local_alloc_inode;
> +	ac->ac_alloc_slot = osb->slot_num;

Put a comment above this line:

	/* We should never use localalloc from another slot */

I don't want someone to accidentally change that in the future.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
