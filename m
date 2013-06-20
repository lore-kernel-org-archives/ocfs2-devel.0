From: Younger Liu <younger.liu@huawei.com>
Date: Thu, 20 Jun 2013 16:46:16 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: need rollback when
 journal_access failed in ocfs2_orphan_add()
In-Reply-To: <51C2B662.2000206@huawei.com>
References: <51C2B662.2000206@huawei.com>
Message-ID: <51C2C158.1050305@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013/6/20 15:59, Younger Liu wrote:
> While adding a file into orphan dir in ocfs2_orphan_add(),
> it calls __ocfs2_add_entry() before ocfs2_journal_access_di(). 
> If ocfs2_journal_access_di() failed, the file is added into 
> orphan dir, and orphan dir dinode updated, but file dinode 
> has not been updated.
> Accordingly, the data is not consistent between file dinode 
> and orphan dir.
> 
> So, need to call ocfs2_journal_access_di() before __ocfs2_add_entry(),
> and if ocfs2_journal_access_di() failed, orphan_fe and 
> orphan_dir_inode->i_nlink need rollback. 
> 

This bug is introduced by commits 3939fda4.

> Signed-off-by: Younger Liu <younger.liu@huawei.com>
> Cc: Jie Liu <jeff.liu@oracle.com>
> ---
>  fs/ocfs2/namei.c |   39 +++++++++++++++++++++++----------------
>  1 file changed, 23 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index f53471d..087c58b 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -2012,6 +2012,21 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
>  		goto leave;
>  	}
>  
> +	/*
> +	 * We're going to journal the change of i_flags and i_orphaned_slot.
> +	 * It's safe anyway, though some callers may duplicate the journaling.
> +	 * Journaling within the func just make the logic look more
> +	 * straightforward.
> +	 */
> +	status = ocfs2_journal_access_di(handle,
> +					 INODE_CACHE(inode),
> +					 fe_bh,
> +					 OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto leave;
> +	}
> +
>  	/* we're a cluster, and nlink can change on disk from
>  	 * underneath us... */
>  	orphan_fe = (struct ocfs2_dinode *) orphan_dir_bh->b_data;
> @@ -2026,22 +2041,7 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
>  				   orphan_dir_bh, lookup);
>  	if (status < 0) {
>  		mlog_errno(status);
> -		goto leave;
> -	}
> -
> -	/*
> -	 * We're going to journal the change of i_flags and i_orphaned_slot.
> -	 * It's safe anyway, though some callers may duplicate the journaling.
> -	 * Journaling within the func just make the logic look more
> -	 * straightforward.
> -	 */
> -	status = ocfs2_journal_access_di(handle,
> -					 INODE_CACHE(inode),
> -					 fe_bh,
> -					 OCFS2_JOURNAL_ACCESS_WRITE);
> -	if (status < 0) {
> -		mlog_errno(status);
> -		goto leave;
> +		goto rollback;
>  	}
>  
>  	fe->i_flags |= cpu_to_le32(OCFS2_ORPHANED_FL);
> @@ -2057,6 +2057,13 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
>  	trace_ocfs2_orphan_add_end((unsigned long long)OCFS2_I(inode)->ip_blkno,
>  				   osb->slot_num);
>  
> +rollback:
> +	if (status < 0) {
> +		if (S_ISDIR(inode->i_mode))
> +			ocfs2_add_links_count(orphan_fe, -1);
> +		set_nlink(orphan_dir_inode, ocfs2_read_links_count(orphan_fe));
> +	}
> +
>  leave:
>  	brelse(orphan_dir_bh);
>  
> 
