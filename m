From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 14 Sep 2015 15:13:13 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fill-in the unused portion of the
 block with zeros by dio_zero_block()
In-Reply-To: <55EF9184.5090007@huawei.com>
References: <55EF9184.5090007@huawei.com>
Message-ID: <20150914151313.76ca8bedd5c5ffa859eff4ad@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 9 Sep 2015 09:55:16 +0800 jiangyiwen <jiangyiwen@huawei.com> wrote:

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
> ...
>
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -581,6 +581,7 @@ static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
>  			ret = -EIO;
>  			goto bail;
>  		}
> +		set_buffer_new(bh_result);
>  	}
> 

You're working against an old kernel.  I did this:

--- a/fs/ocfs2/aops.c~ocfs2-fill-in-the-unused-portion-of-the-block-with-zeros-by-dio_zero_block
+++ a/fs/ocfs2/aops.c
@@ -589,6 +589,7 @@ static int ocfs2_direct_IO_get_blocks(st
 			ret = -EIO;
 			goto bail;
 		}
+		set_buffer_new(bh_result);
 		up_write(&OCFS2_I(inode)->ip_alloc_sem);
 	}
 

Probably we could run set_buffer_new() after the up_write(), which
would decrease lok hold times a little bit.
