From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 12 Jun 2009 14:42:52 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: return EROFS instead of BUG
	in	ocfs2_insert_at_leaf.
In-Reply-To: <1244787516-13475-1-git-send-email-tao.ma@oracle.com>
References: <4A326E26.4080002@oracle.com>
	<1244787516-13475-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090612214252.GE22662@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 12, 2009 at 02:18:35PM +0800, Tao Ma wrote:
> As Mark's suggestion, change BUG to EROFS in ocfs2_insert_at_leaf.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

	I see that Mark is rethinking this, and I'll wait on that.  But
I do have one comment.

> @@ -3703,23 +3703,28 @@ static void ocfs2_insert_at_leaf(struct ocfs2_extent_rec *insert_rec,
>  			+ le16_to_cpu(rec->e_leaf_clusters);
>  		BUG_ON(le32_to_cpu(insert_rec->e_cpos) < range);
>  
> -		mlog_bug_on_msg(le16_to_cpu(el->l_next_free_rec) >=
> -				le16_to_cpu(el->l_count),
> -				"inode %lu, depth %u, count %u, next free %u, "
> -				"rec.cpos %u, rec.clusters %u, "
> -				"insert.cpos %u, insert.clusters %u\n",
> -				inode->i_ino,
> -				le16_to_cpu(el->l_tree_depth),
> -				le16_to_cpu(el->l_count),
> -				le16_to_cpu(el->l_next_free_rec),
> -				le32_to_cpu(el->l_recs[i].e_cpos),
> -				le16_to_cpu(el->l_recs[i].e_leaf_clusters),
> -				le32_to_cpu(insert_rec->e_cpos),
> -				le16_to_cpu(insert_rec->e_leaf_clusters));
> +		if (le16_to_cpu(el->l_next_free_rec) >=
> +		    le16_to_cpu(el->l_count)) {
> +			mlog(ML_ERROR, "l_next_free_rec > l_count, "
> +			     "inode %lu, depth %u, count %u, next free %u, "
> +			     "rec.cpos %u, rec.clusters %u, "
> +			     "insert.cpos %u, insert.clusters %u\n",
> +			     inode->i_ino,
> +			     le16_to_cpu(el->l_tree_depth),
> +			     le16_to_cpu(el->l_count),
> +			     le16_to_cpu(el->l_next_free_rec),
> +			     le32_to_cpu(el->l_recs[i].e_cpos),
> +			     le16_to_cpu(el->l_recs[i].e_leaf_clusters),
> +			     le32_to_cpu(insert_rec->e_cpos),
> +			     le16_to_cpu(insert_rec->e_leaf_clusters));
> +			ret = -EROFS;
> +			goto out;
> +		}

	Shouldn't this be ocfs2_error() instead of ML_ERROR?  If we're
returning EROFS, we should actually be setting the fs readonly.

Joel

-- 

 "I'm living so far beyond my income that we may almost be said
 to be living apart."
         - e e cummings

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
