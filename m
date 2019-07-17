From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Wed, 17 Jul 2019 08:46:35 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove set but not used variable
	'last_hash'
In-Reply-To: <20190716132110.34836-1-yuehaibing@huawei.com>
References: <20190716132110.34836-1-yuehaibing@huawei.com>
Message-ID: <5dc2a052-4d30-b047-2c4d-9131ac4f6485@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: YueHaibing <yuehaibing@huawei.com>, mark@fasheh.com, jlbec@evilplan.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com



On 19/7/16 21:21, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> fs/ocfs2/xattr.c: In function ocfs2_xattr_bucket_find:
> fs/ocfs2/xattr.c:3828:6: warning: variable last_hash set but not used [-Wunused-but-set-variable]
> 
> It's never used and can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/xattr.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 385f3aa..90c830e3 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -3825,7 +3825,6 @@ static int ocfs2_xattr_bucket_find(struct inode *inode,
>  	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
>  	int low_bucket = 0, bucket, high_bucket;
>  	struct ocfs2_xattr_bucket *search;
> -	u32 last_hash;
>  	u64 blkno, lower_blkno = 0;
>  
>  	search = ocfs2_xattr_bucket_new(inode);
> @@ -3869,8 +3868,6 @@ static int ocfs2_xattr_bucket_find(struct inode *inode,
>  		if (xh->xh_count)
>  			xe = &xh->xh_entries[le16_to_cpu(xh->xh_count) - 1];
>  
> -		last_hash = le32_to_cpu(xe->xe_name_hash);
> -
>  		/* record lower_blkno which may be the insert place. */
>  		lower_blkno = blkno;
>  
> 
