From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 12 Jun 2008 13:59:14 -0700
Subject: [Ocfs2-devel] [PATCH 4/8] Make extend allocation generic.v1
In-Reply-To: <20080605073309.GA19782@tma-pc2.cn.oracle.com>
References: <484792D1.3080802@oracle.com>
	<20080605073309.GA19782@tma-pc2.cn.oracle.com>
Message-ID: <20080612205914.GP28100@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jun 05, 2008 at 03:33:09PM +0800, Tao Ma wrote:
> The old ocfs2_do_extend_allocation is restrictly to be used in file
> extension. Now a new function named ocfs2_do_cluster_allocation will
> handle the issue of generic extend allocation and it is created in
> suballoc.c.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/file.c     |   94 +++-------------------------------------------
>  fs/ocfs2/file.h     |    6 +--
>  fs/ocfs2/suballoc.c |  103 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ocfs2/suballoc.h |   18 +++++++++
>  4 files changed, 128 insertions(+), 93 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index cc292ee..69ef6ba 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -508,96 +508,14 @@ int ocfs2_do_extend_allocation(struct ocfs2_super *osb,
>  			       struct ocfs2_alloc_context *meta_ac,
>  			       enum ocfs2_alloc_restarted *reason_ret)

I think you should rename ocfs2_do_extend_allocation to something more
direct since it's used only for traditional inode data btrees. Maybe
ocfs2_add_inode_data() ?


> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 1992a6a..c953796 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -1973,3 +1973,106 @@ out:
>  
>  	return ret;
>  }
> +
> +int ocfs2_do_cluster_allocation(struct ocfs2_super *osb,

Likewise, this name doesn't tell me much about the function. Also, a
comment describing it's expected usage would be nice ;)


> +				struct inode *inode,
> +				u32 *logical_offset,
> +				u32 *clusters_to_add,

This changed to a "u32 *" but you gave no explanation of why.

We have a ton of arguments to this function. I can not at the moment offer
you a better way to structure it though.
	--Mark

--
Mark Fasheh
