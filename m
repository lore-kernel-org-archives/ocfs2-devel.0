From: Gang He <ghe@suse.com>
Date: Thu, 25 Jan 2018 01:03:08 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: unlock bh_state if bg check fails
In-Reply-To: <1516843095-23680-1-git-send-email-ge.changwei@h3c.com>
References: <1516843095-23680-1-git-send-email-ge.changwei@h3c.com>
Message-ID: <5A69FFBC020000F9000A632F@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Reviewed-by: Gang He <ghe@suse.com>

Thanks
Gang


>>> 
> We should unlock bh_stat if bg->bg_free_bits_count > bg->bg_bits
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
> ---
>  fs/ocfs2/suballoc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 71f22c8..6fee797 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -2441,6 +2441,8 @@ static int ocfs2_block_group_clear_bits(handle_t 
> *handle,
>  	}
>  	le16_add_cpu(&bg->bg_free_bits_count, num_bits);
>  	if (le16_to_cpu(bg->bg_free_bits_count) > le16_to_cpu(bg->bg_bits)) {
> +		if (undo_fn)
> +			jbd_unlock_bh_state(group_bh);
>  		return ocfs2_error(alloc_inode->i_sb, "Group descriptor # %llu has bit count 
> %u but claims %u are freed. num_bits %d\n",
>  				   (unsigned long long)le64_to_cpu(bg->bg_blkno),
>  				   le16_to_cpu(bg->bg_bits),
> -- 
> 2.7.4
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com 
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
