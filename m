From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 30 Apr 2009 16:35:59 -0700
Subject: [Ocfs2-devel] [PATCH 05/39] ocfs2: hook remove refcount
	tree	into truncate.
In-Reply-To: <1241045931-24607-5-git-send-email-tao.ma@oracle.com>
References: <49F95A79.6040806@oracle.com>
	<1241045931-24607-5-git-send-email-tao.ma@oracle.com>
Message-ID: <20090430233559.GK2762@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 30, 2009 at 06:58:17AM +0800, Tao Ma wrote:
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/alloc.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 6f20f30..0c96b27 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -51,6 +51,7 @@
>  #include "xattr.h"
>  
>  #include "buffer_head_io.h"
> +#include "refcounttree.h"
>  
>  
>  /*
> @@ -7305,6 +7306,10 @@ start:
>  	goto start;
>  
>  bail:
> +	if (!status && OCFS2_I(inode)->ip_clusters == 0) {
> +		/* remove the refcount tree. */
> +		status = ocfs2_remove_refcount_tree(inode, fe_bh);
> +	}

	Locking and xattr clusters need to be accounted for.  I'm
assuming they come later, but I'm noting it down for later reference.

Joel

-- 

"Against stupidity the Gods themselves contend in vain."
	- Friedrich von Schiller

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
