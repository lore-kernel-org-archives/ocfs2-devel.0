From: Jeff Liu <jeff.liu@oracle.com>
Date: Wed, 03 Jul 2013 12:48:05 +0800
Subject: [Ocfs2-devel] [PATCH V3] ocfs2: need rollback when
 journal_access failed in ocfs2_orphan_add()
In-Reply-To: <20130702142607.5ef730318a395483520f438b@linux-foundation.org>
References: <51CD3253.3020200@huawei.com>
	<20130702142607.5ef730318a395483520f438b@linux-foundation.org>
Message-ID: <51D3AD05.8000906@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 07/03/2013 05:26 AM, Andrew Morton wrote:

> On Fri, 28 Jun 2013 14:50:59 +0800 Younger Liu <younger.liu@huawei.com> wrote:
> 
>> While adding a file into orphan dir in ocfs2_orphan_add(),
>> it calls __ocfs2_add_entry() before ocfs2_journal_access_di(). 
>> If ocfs2_journal_access_di() failed, the file is added into 
>> orphan dir, and orphan dir dinode updated, but file dinode 
>> has not been updated.
>> Accordingly, the data is not consistent between file dinode 
>> and orphan dir.
>>
>> So, need to call ocfs2_journal_access_di() before __ocfs2_add_entry(),
>> and if ocfs2_journal_access_di() failed, orphan_fe and 
>> orphan_dir_inode->i_nlink need rollback. 
>>
>> This bug is introduced by commits 3939fda4.
>>
>> Compared with the PATCH V2, this patch cleans up mlog_errno(status) 
>> which was called two times for the same error.
>>
> 
> Folks, could we please get this one reviewed?

At least, this fix looks good to me.

Thanks,
-Jeff

> 
> From: Younger Liu <younger.liu@huawei.com>
> Subject: ocfs2: need rollback when journal_access failed in ocfs2_orphan_add()
> 
> While adding a file into orphan dir in ocfs2_orphan_add(), it calls
> __ocfs2_add_entry() before ocfs2_journal_access_di().  If
> ocfs2_journal_access_di() failed, the file is added into orphan dir, and
> orphan dir dinode updated, but file dinode has not been updated. 
> Accordingly, the data is not consistent between file dinode and orphan
> dir.
> 
> So, need to call ocfs2_journal_access_di() before __ocfs2_add_entry(), and
> if ocfs2_journal_access_di() failed, orphan_fe and
> orphan_dir_inode->i_nlink need rollback.
> 
> This bug was added by 3939fda4 ("Ocfs2: Journaling i_flags and
> i_orphaned_slot when adding inode to orphan dir.").
> 
> Signed-off-by: Younger Liu <younger.liu@huawei.com>
> Cc: Jie Liu <jeff.liu@oracle.com>
> Cc: Sunil Mushran <sunil.mushran@gmail.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ocfs2/namei.c |   41 +++++++++++++++++++++++------------------
>  1 file changed, 23 insertions(+), 18 deletions(-)
> 
> diff -puN fs/ocfs2/namei.c~ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add fs/ocfs2/namei.c
> --- a/fs/ocfs2/namei.c~ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add
> +++ a/fs/ocfs2/namei.c
> @@ -2012,6 +2012,21 @@ static int ocfs2_orphan_add(struct ocfs2
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
> @@ -2026,22 +2041,7 @@ static int ocfs2_orphan_add(struct ocfs2
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
> @@ -2057,11 +2057,16 @@ static int ocfs2_orphan_add(struct ocfs2
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
> -	if (status)
> -		mlog_errno(status);
>  	return status;
>  }
>  
> _
> 
