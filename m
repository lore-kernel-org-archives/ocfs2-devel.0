From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 8 Sep 2010 17:49:59 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Re-access the journal after
	ocfs2_insert_extent() in dxdir codes.
In-Reply-To: <1283937158-4763-1-git-send-email-tristan.ye@oracle.com>
References: <1283937158-4763-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100909004959.GF4364@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Sep 08, 2010 at 05:12:38PM +0800, Tristan Ye wrote:
> In ocfs2_dx_dir_rebalance(), we need to rejournal_acess the blocks after
> calling ocfs2_insert_extent() since growing an extent tree may trigger
> ocfs2_extend_trans(), which makes previous journal_access meaningless.
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
> ---
>  fs/ocfs2/dir.c |   24 ++++++++++++++++--------
>  1 files changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index f04ebcf..c49f6de 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -3931,6 +3931,15 @@ static int ocfs2_dx_dir_rebalance(struct ocfs2_super *osb, struct inode *dir,
>  		goto out_commit;
>  	}
>  
> +	cpos = split_hash;
> +	ret = ocfs2_dx_dir_new_cluster(dir, &et, cpos, handle,
> +				       data_ac, meta_ac, new_dx_leaves,
> +				       num_dx_leaves);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out_commit;
> +	}
> +
>  	for (i = 0; i < num_dx_leaves; i++) {
>  		ret = ocfs2_journal_access_dl(handle, INODE_CACHE(dir),
>  					      orig_dx_leaves[i],

Ok, I see what you're going for here. Don't we still need to add a
journal_access_dl call against new_dx_leaves[i] in the for loop though? They
will be dirtied again in ocfs2_dx_dir_transfer_leaf.
	--Mark

--
Mark Fasheh
