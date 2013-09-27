From: Joel Becker <jlbec@evilplan.org>
Date: Fri, 27 Sep 2013 12:05:29 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: rollback transaction in
 ocfs2_group_add()
In-Reply-To: <523ECBCB.6070800@huawei.com>
References: <523ECBCB.6070800@huawei.com>
Message-ID: <20130927190528.GH26517@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Acked-by: Joel Becker <jlbec@evilplan.org>

On Sun, Sep 22, 2013 at 06:51:55PM +0800, Younger Liu wrote:
> If ocfs2_journal_access_di fails, group->bg_next_group should rollback.
> Otherwise, there would be a inconsistency between group_bh and main_bm_bh.
> 
> Signed-off-by: Younger Liu <younger.liu@huawei.com>
> ---
>  fs/ocfs2/resize.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
> index ec55add..376750f 100644
> --- a/fs/ocfs2/resize.c
> +++ b/fs/ocfs2/resize.c
> @@ -469,6 +469,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
>  	struct ocfs2_chain_list *cl;
>  	struct ocfs2_chain_rec *cr;
>  	u16 cl_bpc;
> +	u64 bg_ptr;
>  
>  	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
>  		return -EROFS;
> @@ -538,12 +539,14 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
>  	}
>  
>  	group = (struct ocfs2_group_desc *)group_bh->b_data;
> +	bg_ptr = le64_to_cpu(group->bg_next_group);
>  	group->bg_next_group = cr->c_blkno;
>  	ocfs2_journal_dirty(handle, group_bh);
>  
>  	ret = ocfs2_journal_access_di(handle, INODE_CACHE(main_bm_inode),
>  				      main_bm_bh, OCFS2_JOURNAL_ACCESS_WRITE);
>  	if (ret < 0) {
> +		group->bg_next_group = cpu_to_le64(bg_ptr);
>  		mlog_errno(ret);
>  		goto out_commit;
>  	}
> -- 
> 1.7.9.7
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

 Joel's Second Law:

	If a code change requires additional user setup, it is wrong.

			http://www.jlbec.org/
			jlbec at evilplan.org
