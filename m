From: Joel Becker <jlbec@evilplan.org>
Date: Fri, 27 Sep 2013 12:06:28 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: do not call brelse() if
 group_bh is not initialized in ocfs2_group_add()
In-Reply-To: <523ECBD4.1000403@huawei.com>
References: <523ECBD4.1000403@huawei.com>
Message-ID: <20130927190628.GI26517@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Acked-by: Joel Becker <jlbec@evilplan.org>

On Sun, Sep 22, 2013 at 06:52:04PM +0800, Younger Liu wrote:
> If group_bh is not initialized, there is no need to release.
> This problem does not cause anything wrong, but the patch 
> would make the code more logical.
> 
> Signed-off-by: Younger Liu <younger.liu@huawei.com>
> ---
>  fs/ocfs2/resize.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
> index 376750f..822ebc1 100644
> --- a/fs/ocfs2/resize.c
> +++ b/fs/ocfs2/resize.c
> @@ -514,7 +514,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
>  	ret = ocfs2_verify_group_and_input(main_bm_inode, fe, input, group_bh);
>  	if (ret) {
>  		mlog_errno(ret);
> -		goto out_unlock;
> +		goto out_free_group_bh;
>  	}
>  
>  	trace_ocfs2_group_add((unsigned long long)input->group,
> @@ -524,7 +524,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
>  	if (IS_ERR(handle)) {
>  		mlog_errno(PTR_ERR(handle));
>  		ret = -EINVAL;
> -		goto out_unlock;
> +		goto out_free_group_bh;
>  	}
>  
>  	cl_bpc = le16_to_cpu(fe->id2.i_chain.cl_bpc);
> @@ -577,8 +577,11 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
>  
>  out_commit:
>  	ocfs2_commit_trans(osb, handle);
> -out_unlock:
> +
> +out_free_group_bh:
>  	brelse(group_bh);
> +
> +out_unlock:
>  	brelse(main_bm_bh);
>  
>  	ocfs2_inode_unlock(main_bm_inode, 1);
> -- 
> 1.7.9.7
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"The first thing we do, let's kill all the lawyers."
                                        -Henry VI, IV:ii

			http://www.jlbec.org/
			jlbec at evilplan.org
