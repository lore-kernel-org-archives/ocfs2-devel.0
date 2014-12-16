From: Xue jiufei <xuejiufei@huawei.com>
Date: Tue, 16 Dec 2014 09:37:37 +0800
Subject: [Ocfs2-devel] [patch 02/15] ocfs2: free inode when i_count
	becomes zero
In-Reply-To: <548f65ce.ZbhXsSTn9X8vwoWR%akpm@linux-foundation.org>
References: <548f65ce.ZbhXsSTn9X8vwoWR%akpm@linux-foundation.org>
Message-ID: <548F8CE1.7030202@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, Andrew,
This patch may lead to data loss so please remove it from mm tree please.
Here is the situation: 
When i_count becomes zero but there still exists dirty pages in i_mapping,
the dirty pages would be freed without flushing the data.

To avoid this problem, we should flush dirty page before dropping
the inode, but I don't think it it a good idea to flush page in
function ocfs2_drop_inode().

So now there is no better way to solve this problem.

Thanks,
Xuejiufei

On 2014/12/16 6:50, akpm at linux-foundation.org wrote:
> From: Xue jiufei <xuejiufei@huawei.com>
> Subject: ocfs2: free inode when i_count becomes zero
> 
> Disk inode deletion may be heavily delayed when one node unlink a file
> after the same dentry is freed on another node(say N1) because of memory
> shrink but inode is left in memory.  This inode can only be freed while N1
> doing the orphan scan work.
> 
> However, N1 may skip orphan scan for several times because other nodes may
> do the work earlier.  In our tests, it may take 1 hour on 4 nodes cluster
> and this will cause bad user experience.  So we think the inode should be
> freed when i_count becomes zero to avoid such circumstances.
> 
> [akpm at linux-foundation.org: coding-style fixes]
> Signed-off-by: joyce.xue <xuejiufei@huawei.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ocfs2/inode.c |   10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff -puN fs/ocfs2/inode.c~ocfs2-free-inode-when-i_count-becomes-zero fs/ocfs2/inode.c
> --- a/fs/ocfs2/inode.c~ocfs2-free-inode-when-i_count-becomes-zero
> +++ a/fs/ocfs2/inode.c
> @@ -1191,17 +1191,9 @@ void ocfs2_evict_inode(struct inode *ino
>  int ocfs2_drop_inode(struct inode *inode)
>  {
>  	struct ocfs2_inode_info *oi = OCFS2_I(inode);
> -	int res;
> -
>  	trace_ocfs2_drop_inode((unsigned long long)oi->ip_blkno,
>  				inode->i_nlink, oi->ip_flags);
> -
> -	if (oi->ip_flags & OCFS2_INODE_MAYBE_ORPHANED)
> -		res = 1;
> -	else
> -		res = generic_drop_inode(inode);
> -
> -	return res;
> +	return 1;
>  }
>  
>  /*
> _
> .
> 
