From: Jeff Liu <jeff.liu@oracle.com>
Date: Wed, 19 Jun 2013 18:53:43 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: need rollback when journal_access
 failed in ocfs2_orphan_add()
In-Reply-To: <51C17263.5020601@huawei.com>
References: <51C17263.5020601@huawei.com>
Message-ID: <51C18DB7.4090003@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hey Younger,

On 06/19/2013 04:57 PM, Younger Liu wrote:

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

Yes, and this has been introduced by commits 3939fda4.
Please see my comments below.

> 
> Signed-off-by: Younger Liu <younger.liu@huawei.com>
> ---
>  fs/ocfs2/namei.c |   38 ++++++++++++++++++++++----------------
>  1 file changed, 22 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index f53471d..f2da854 100644
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
> @@ -2057,6 +2057,12 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
>  	trace_ocfs2_orphan_add_end((unsigned long long)OCFS2_I(inode)->ip_blkno,
>  				   osb->slot_num);
>  
> +rollback:
> +	if (status < 0 && S_ISDIR(inode->i_mode)) {

	              ^^^^ <-- But that might not be a directory, right? :-P
How about the following?

	if (status < 0) {
		if (S_ISDIR(inode->i_mode))
			ocfs2_add_links_count(orphan_fe, -1);
		set_nlink(orphan_dir_inode, ocfs2_read_links_count(orphan_fe));
	}

> +			ocfs2_add_links_count(orphan_fe, -1);
> +		set_nlink(orphan_dir_inode, ocfs2_read_links_count(orphan_fe));
> +	}
> +
>  leave:
>  	brelse(orphan_dir_bh);
>  
> -- 1.7.9.7 


Thanks,
-Jeff
