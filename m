From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Sun Jan  6 22:00:36 2008
Subject: [Ocfs2-devel] [PATCH 2/2] Enable cross extent block merge.V1
In-Reply-To: <20080104084619.GA1955@tma-pc1.cn.oracle.com>
References: <20080104083214.GA1584@tma-pc1.cn.oracle.com>
	<20080104084619.GA1955@tma-pc1.cn.oracle.com>
Message-ID: <20080107055855.GU23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 04, 2008 at 04:46:19PM +0800, tao.ma wrote:
>  static enum ocfs2_contig_type
> -ocfs2_figure_merge_contig_type(struct inode *inode,
> +ocfs2_figure_merge_contig_type(struct inode *inode, struct ocfs2_path *path,
>  			       struct ocfs2_extent_list *el, int index,
>  			       struct ocfs2_extent_rec *split_rec)
>  {
> -	struct ocfs2_extent_rec *rec;
> +	int status;
> +	struct ocfs2_extent_rec *rec = NULL;
>  	enum ocfs2_contig_type ret = CONTIG_NONE;
> +	u32 left_cpos, right_cpos;
> +	struct ocfs2_extent_list *new_el;
> +	struct ocfs2_path *left_path = NULL, *right_path = NULL;
> +
> +	if (index > 0) {
> +		rec = &el->l_recs[index - 1];
> +	} else if (path->p_tree_depth > 0) {
> +		status = ocfs2_find_cpos_for_left_leaf(inode->i_sb,
> +						       path, &left_cpos);
> +		if (status)
> +			goto out;
> +
> +		if (left_cpos != 0) {
> +			left_path = ocfs2_new_path(path_root_bh(path),
> +						   path_root_el(path));
> +			if (!left_path)
> +				goto out;
> +
> +			status = ocfs2_find_path(inode, left_path, left_cpos);
> +			if (status)
> +				goto out;
> +
> +			new_el = path_leaf_el(left_path);
> +
> +			BUG_ON(le16_to_cpu(new_el->l_next_free_rec) !=
> +			       le16_to_cpu(new_el->l_count));

Since we haven't seen this extent block before, this error condition should
make the file system go read-only, not BUG()


> +			rec = &new_el->l_recs[le16_to_cpu(new_el->l_count) - 1];

Use l_next_free_rec in the array here please.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
