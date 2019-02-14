From: piaojun <piaojun@huawei.com>
Date: Thu, 14 Feb 2019 16:24:11 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: checkpoint appending truncate log
 transaction before flushing
In-Reply-To: <1550116993-17084-1-git-send-email-ge.changwei@h3c.com>
References: <1550116993-17084-1-git-send-email-ge.changwei@h3c.com>
Message-ID: <5C6525AB.2020603@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

On 2019/2/14 12:03, Changwei Ge wrote:
> Appending truncate log(TA) and and flushing truncate log(TF) are
> two separated transactions. They can be both committed but not
> checkpointed. If crash occurs then, both two transaction will be
> replayed with several already released to global bitmap clusters.

Do you mean that both the two transactions will release cluster to
global bitmap? But I think the TA won't give back clusters to global
bitmap.

> Then truncate log will be replayed resulting in cluster double free.

Does this problem only cause some error log? As below:

ocfs2_replay_truncate_records
  ocfs2_free_clusters
    _ocfs2_free_clusters
      _ocfs2_free_suballoc_bits
        ocfs2_block_group_clear_bits
          "Trying to clear %u bits at offset %u in group descriptor"

Thanks,
Jun

> 
> To reproduce this issue, just crash the host while punching hole to files.
> 
> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
> ---
>  fs/ocfs2/alloc.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index d1cbb27..29bc777 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -6007,6 +6007,7 @@ int __ocfs2_flush_truncate_log(struct ocfs2_super *osb)
>  	struct buffer_head *data_alloc_bh = NULL;
>  	struct ocfs2_dinode *di;
>  	struct ocfs2_truncate_log *tl;
> +	struct ocfs2_journal *journal = osb->journal;
>  
>  	BUG_ON(inode_trylock(tl_inode));
>  
> @@ -6027,6 +6028,20 @@ int __ocfs2_flush_truncate_log(struct ocfs2_super *osb)
>  		goto out;
>  	}
>  
> +	/* Appending truncate log(TA) and and flushing truncate log(TF) are
> +	 * two separated transactions. They can be both committed but not
> +	 * checkpointed. If crash occurs then, both two transaction will be
> +	 * replayed with several already released to global bitmap clusters.
> +	 * Then truncate log will be replayed resulting in cluster double free.
> +	 */
> +	jbd2_journal_lock_updates(journal->j_journal);
> +	status = jbd2_journal_flush(journal->j_journal);
> +	jbd2_journal_unlock_updates(journal->j_journal);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto out;
> +	}
> +
>  	data_alloc_inode = ocfs2_get_system_file_inode(osb,
>  						       GLOBAL_BITMAP_SYSTEM_INODE,
>  						       OCFS2_INVALID_SLOT);
> 
