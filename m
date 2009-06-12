From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 12 Jun 2009 14:56:04 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Adjust rightmost path in
	ocfs2_add_branch.
In-Reply-To: <1244787516-13475-2-git-send-email-tao.ma@oracle.com>
References: <4A326E26.4080002@oracle.com>
	<1244787516-13475-2-git-send-email-tao.ma@oracle.com>
Message-ID: <20090612215604.GF22662@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 12, 2009 at 02:18:36PM +0800, Tao Ma wrote:
> @@ -998,6 +1052,27 @@ static int ocfs2_add_branch(struct ocfs2_super *osb,
>  
>  	new_blocks = le16_to_cpu(el->l_tree_depth);
>  
> +	eb = (struct ocfs2_extent_block *)(*last_eb_bh)->b_data;
> +	new_cpos = ocfs2_sum_rightmost_rec(&eb->h_list);
> +	root_end = ocfs2_sum_rightmost_rec(et->et_root_el);
> +
> +	/*
> +	 * If there is a gap before the root end and the real end
> +	 * of the righmost leaf block, we need to remove the gap
> +	 * between new_cpos and root_end first so that the tree
> +	 * is consistent after we add a new branch(it will start
> +	 * from new_cpos).
> +	 */
> +	if (root_end > new_cpos) {
> +		mlog(0, "adjust the cluster end from %u to %u\n",
> +		     root_end, new_cpos);
> +		status = ocfs2_adjust_rightmost_branch(handle, inode, et);
> +		if (status) {
> +			mlog_errno(status);
> +			goto bail;
> +		}
> +	}
> +
>  	/* allocate the number of new eb blocks we need */
>  	new_eb_bhs = kcalloc(new_blocks, sizeof(struct buffer_head *),
>  			     GFP_KERNEL);

	Yeah, this is nice and clean.

Joel

-- 

"Senator let's be sincere,
 As much as you can."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
