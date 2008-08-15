From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 14 Aug 2008 20:09:35 -0700
Subject: [Ocfs2-devel] [PATCH] Refactor ocfs2_insert_extent for
	not-merging. Revised
In-Reply-To: <1218730944-23484-1-git-send-email-tao.ma@oracle.com>
References: <20080814020422.GE21187@wotan.suse.de>
	<1218730944-23484-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20080815030935.GT21187@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Aug 15, 2008 at 12:22:24AM +0800, Tao Ma wrote:
> Hi Mark,
> 	Your explanation is clear enough. So here is the revised one. Thanks.

Great, thanks Tao.


> @@ -4134,6 +4139,20 @@ static void ocfs2_figure_contig_type(struct inode *inode,
>  		}
>  	}
>  	insert->ins_contig = contig_type;
> +
> +	if (insert->ins_contig != CONTIG_NONE) {
> +		struct ocfs2_extent_rec *rec =
> +				&el->l_recs[insert->ins_contig_index];
> +		unsigned int len = le16_to_cpu(rec->e_leaf_clusters) +
> +				   le16_to_cpu(insert_rec->e_leaf_clusters);
> +
> +		/*
> +		 * Caller might want us to limit the size of extents, don't
> +		 * calculate contiguousness if we might exceed that limit.
> + 		 */
> +		if (et->max_leaf_clusters && len > et->max_leaf_clusters)
> +		        insert->ins_contig = CONTIG_NONE;
> +	}

I would have just compared len and max_leaf_clusters at the top of the
function, but either way works for me. The rest of the patch looks great.


Do we have to do anything similar for when you remove clusters from the ea
index tree?
	--Mark

--
Mark Fasheh
