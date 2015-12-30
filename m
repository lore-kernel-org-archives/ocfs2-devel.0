From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 30 Dec 2015 15:10:30 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: access orphan dinode before delete
 entry in ocfs2_orphan_del
In-Reply-To: <567BA725.8080607@huawei.com>
References: <567BA725.8080607@huawei.com>
Message-ID: <56838366.6090503@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 12/24/2015 04:04 PM, Joseph Qi wrote:
> In ocfs2_orphan_del, currently it finds and deletes entry first, and
> then access orphan dir dinode. This will have a problem once
> ocfs2_journal_access_di fails. In this case, entry will be removed from
> orphan dir, but in deed the inode hasn't been deleted successfully. In
> other words, the file is missing but not actually deleted.
> So we should access orphan dinode first like unlink and rename.
> 
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
> Reviewed-by: Jiufei Xue <xuejiufei@huawei.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>  fs/ocfs2/namei.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 922eae9..816c667 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -2371,6 +2371,15 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
>  	     (unsigned long long)OCFS2_I(orphan_dir_inode)->ip_blkno,
>  	     name, strlen(name));
> 
> +	status = ocfs2_journal_access_di(handle,
> +					 INODE_CACHE(orphan_dir_inode),
> +					 orphan_dir_bh,
> +					 OCFS2_JOURNAL_ACCESS_WRITE);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto leave;
> +	}
> +
>  	/* find it's spot in the orphan directory */
>  	status = ocfs2_find_entry(name, strlen(name), orphan_dir_inode,
>  				  &lookup);
> @@ -2386,15 +2395,6 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
>  		goto leave;
>  	}
> 
> -	status = ocfs2_journal_access_di(handle,
> -					 INODE_CACHE(orphan_dir_inode),
> -					 orphan_dir_bh,
> -					 OCFS2_JOURNAL_ACCESS_WRITE);
> -	if (status < 0) {
> -		mlog_errno(status);
> -		goto leave;
> -	}
> -
>  	/* do the i_nlink dance! :) */
>  	orphan_fe = (struct ocfs2_dinode *) orphan_dir_bh->b_data;
>  	if (S_ISDIR(inode->i_mode))
> 
