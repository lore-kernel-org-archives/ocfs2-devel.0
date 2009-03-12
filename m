From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 12 Mar 2009 02:26:16 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix a bug found by sparse check.
In-Reply-To: <1236810263-19023-1-git-send-email-tao.ma@oracle.com>
References: <1236810263-19023-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090312092616.GB2014@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 12, 2009 at 06:24:23AM +0800, Tao Ma wrote:
> We need to use le32_to_cpu to test rec->e_cpos in
> ocfs2_dinode_insert_check.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
Acked-by: Joel Becker <joel.becker@oracle.com>

> ---
>  fs/ocfs2/alloc.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 3a9e5de..19e3a96 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -176,7 +176,8 @@ static int ocfs2_dinode_insert_check(struct inode *inode,
>  
>  	BUG_ON(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL);
>  	mlog_bug_on_msg(!ocfs2_sparse_alloc(osb) &&
> -			(OCFS2_I(inode)->ip_clusters != rec->e_cpos),
> +			(OCFS2_I(inode)->ip_clusters !=
> +			 le32_to_cpu(rec->e_cpos)),
>  			"Device %s, asking for sparse allocation: inode %llu, "
>  			"cpos %u, clusters %u\n",
>  			osb->dev_str,
> -- 
> 1.6.2.rc2.16.gf474c
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"The doctrine of human equality reposes on this: that there is no
 man really clever who has not found that he is stupid."
	- Gilbert K. Chesterson

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
