From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 11 Mar 2013 02:10:28 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Add trace point for
	ocfs2_set_inode_attr()
In-Reply-To: <513D6BB2.60601@oracle.com>
References: <513D6BB2.60601@oracle.com>
Message-ID: <20130311091028.GH7783@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hey Jeff,
	What made you want this trace point?  Did you have a particular
scenario that required it?  Or were you just thinking "it would be nice
to have"?

Joel

On Mon, Mar 11, 2013 at 01:29:22PM +0800, Jeff Liu wrote:
> Add trace point for ocfs2_set_inode_attr().
> 
> # cat /debug/tracing/available_events |grep ocfs2_set_inode_attr
> ocfs2:ocfs2_set_inode_attr
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> ---
>  fs/ocfs2/ioctl.c       |    3 +++
>  fs/ocfs2/ocfs2_trace.h |    6 ++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
> index c739c24..764bf5c 100644
> --- a/fs/ocfs2/ioctl.c
> +++ b/fs/ocfs2/ioctl.c
> @@ -27,6 +27,7 @@
>  #include "buffer_head_io.h"
>  #include "suballoc.h"
>  #include "move_extents.h"
> +#include "ocfs2_trace.h"
>  
>  #define o2info_from_user(a, b)	\
>  		copy_from_user(&(a), (b), sizeof(a))
> @@ -86,6 +87,8 @@ static int ocfs2_set_inode_attr(struct inode *inode, unsigned flags,
>  	unsigned oldflags;
>  	int status;
>  
> +	trace_ocfs2_set_inode_attr(OCFS2_I(inode)->ip_blkno, flags);
> +
>  	mutex_lock(&inode->i_mutex);
>  
>  	status = ocfs2_inode_lock(inode, &bh, 1);
> diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
> index 3b481f4..bcaca11 100644
> --- a/fs/ocfs2/ocfs2_trace.h
> +++ b/fs/ocfs2/ocfs2_trace.h
> @@ -2755,6 +2755,12 @@ DEFINE_OCFS2_ULL_ULL_EVENT(ocfs2_remove_metadata_tree);
>  DEFINE_OCFS2_ULL_ULL_UINT_UINT_EVENT(ocfs2_remove_block_from_cache);
>  
>  /* End of trace events for fs/ocfs2/uptodate.c. */
> +
> +/* Trace events for fs/ocfs2/ioctl.c. */
> +
> +DEFINE_OCFS2_ULL_UINT_EVENT(ocfs2_set_inode_attr);
> +
> +/* End of trace events for fs/ocfs2/ioctl.c. */
>  #endif /* _TRACE_OCFS2_H */
>  
>  /* This part must be outside protection */
> -- 
> 1.7.9.5

-- 

Life's Little Instruction Book #207

	"Swing for the fence."

			http://www.jlbec.org/
			jlbec at evilplan.org
