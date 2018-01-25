From: piaojun <piaojun@huawei.com>
Date: Thu, 25 Jan 2018 20:49:09 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: unlock bh_state if bg check fails
In-Reply-To: <1516843095-23680-1-git-send-email-ge.changwei@h3c.com>
References: <1516843095-23680-1-git-send-email-ge.changwei@h3c.com>
Message-ID: <5A69D245.2050307@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

LGTM

On 2018/1/25 9:18, Changwei Ge wrote:
> We should unlock bh_stat if bg->bg_free_bits_count > bg->bg_bits
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
> ---
>  fs/ocfs2/suballoc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 71f22c8..6fee797 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -2441,6 +2441,8 @@ static int ocfs2_block_group_clear_bits(handle_t *handle,
>  	}
>  	le16_add_cpu(&bg->bg_free_bits_count, num_bits);
>  	if (le16_to_cpu(bg->bg_free_bits_count) > le16_to_cpu(bg->bg_bits)) {
> +		if (undo_fn)
> +			jbd_unlock_bh_state(group_bh);
>  		return ocfs2_error(alloc_inode->i_sb, "Group descriptor # %llu has bit count %u but claims %u are freed. num_bits %d\n",
>  				   (unsigned long long)le64_to_cpu(bg->bg_blkno),
>  				   le16_to_cpu(bg->bg_bits),
> 
