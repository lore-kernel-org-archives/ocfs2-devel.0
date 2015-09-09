From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 9 Sep 2015 10:13:01 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fill-in the unused portion of the
 block with zeros by dio_zero_block()
In-Reply-To: <55EF9184.5090007@huawei.com>
References: <55EF9184.5090007@huawei.com>
Message-ID: <55EF95AD.7060109@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2015/9/9 9:55, jiangyiwen wrote:
> A simplified test case is (this case from Ryan):
> 1) dd if=/dev/zero of=/mnt/hello bs=512 count=1 oflag=direct;
> 2) truncate /mnt/hello -s 2097152
> file 'hello' is not exist before test. After this command,
> file 'hello' should be all zero. But 512~4096 is some random data.
> 
> Setting bh state to new when get a new block, if so,
> direct_io_worker()->dio_zero_block() will fill-in the unused portion
> of the block with zero.
> 
> Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
> ---
>  fs/ocfs2/aops.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 1a35c61..bd106b9 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -581,6 +581,7 @@ static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
>  			ret = -EIO;
>  			goto bail;
>  		}
> +		set_buffer_new(bh_result);
>  	}
> 
>  	/*
> 
