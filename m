From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 31 Mar 2010 20:34:06 -0700
Subject: [Ocfs2-devel] [PATCH 12/15] ocfs2: Some tiny bug fixes for
 discontiguous block allocation.
In-Reply-To: <1270090752-18935-12-git-send-email-tao.ma@oracle.com>
References: <4BB40AB4.8040205@oracle.com>
	<1270090752-18935-12-git-send-email-tao.ma@oracle.com>
Message-ID: <20100401033406.GI28680@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 01, 2010 at 10:59:09AM +0800, Tao Ma wrote:
> -static inline int ocfs2_supports_discontig_bh(struct ocfs2_super *osb)
> +static inline int ocfs2_supports_discontig_bg(struct ocfs2_super *osb)

	D'oh!

> -	rec->e_blkno = p_blkno;
> +	rec->e_blkno = cpu_to_le64(p_blkno);

	D'oh!!

> +	le16_add_cpu(&bg->bg_free_bits_count,
> +		     clusters * le16_to_cpu(cl->cl_bpc));

	D'oh!!!
> @@ -511,8 +513,8 @@ static int ocfs2_block_group_grow_discontig(handle_t *handle,
>  	struct ocfs2_super *osb = OCFS2_SB(alloc_inode->i_sb);
>  	struct ocfs2_group_desc *bg =
>  		(struct ocfs2_group_desc *)bg_bh->b_data;
> -	unsigned int needed =
> -		ocfs2_bits_per_group(cl) - le16_to_cpu(bg->bg_bits);
> +	unsigned int needed = le16_to_cpu(cl->cl_cpg) -
> +			 le16_to_cpu(bg->bg_bits) / le16_to_cpu(cl->cl_bpc);

	Ouch!  But can you put parens around the divide?  Make the
intention clear.

> @@ -733,18 +734,20 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
>  		goto bail;
>  	}
>  
> -	le32_add_cpu(&cl->cl_recs[bg->bg_chain].c_free,
> +	alloc_rec = le16_to_cpu(bg->bg_chain);
> +	le32_add_cpu(&cl->cl_recs[alloc_rec].c_free,
>  		     le16_to_cpu(bg->bg_free_bits_count));

	D'oh!!!!

> -	le32_add_cpu(&cl->cl_recs[bg->bg_chain].c_total,
> +	le32_add_cpu(&cl->cl_recs[alloc_rec].c_total,
>  		     le16_to_cpu(bg->bg_bits));
> -	cl->cl_recs[bg->bg_chain].c_blkno  = cpu_to_le64(bg_blkno);
> +	cl->cl_recs[alloc_rec].c_blkno  = cpu_to_le64(bg->bg_blkno);
>  	if (le16_to_cpu(cl->cl_next_free_rec) < le16_to_cpu(cl->cl_count))
>  		le16_add_cpu(&cl->cl_next_free_rec, 1);
>  
>  	le32_add_cpu(&fe->id1.bitmap1.i_used, le16_to_cpu(bg->bg_bits) -
>  					le16_to_cpu(bg->bg_free_bits_count));
>  	le32_add_cpu(&fe->id1.bitmap1.i_total, le16_to_cpu(bg->bg_bits));
> -	le32_add_cpu(&fe->i_clusters, le16_to_cpu(cl->cl_cpg));
> +	le32_add_cpu(&fe->i_clusters,
> +		     le16_to_cpu(bg->bg_bits) / le16_to_cpu(cl->cl_bpc));

	You don't need to change this.  Either we've allocated cpg or
we've failed out.

Joel

-- 

"There is shadow under this red rock.
 (Come in under the shadow of this red rock)
 And I will show you something different from either
 Your shadow at morning striding behind you
 Or your shadow at evening rising to meet you.
 I will show you fear in a handful of dust."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
