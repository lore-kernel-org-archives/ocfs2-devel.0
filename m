From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 13 Jul 2009 11:01:07 -0700
Subject: [Ocfs2-devel] Initialize count in aio_write before
	generic_write_checks
In-Reply-To: <20090711155727.GA11989@baloo.cartoons>
References: <20090711155727.GA11989@baloo.cartoons>
Message-ID: <4A5B7663.6020006@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Goldwyn Rodrigues wrote:
> generic_write_checks() expects count to be initialized to the size of
> the write.
> Writes to files open with O_DIRECT|O_LARGEFILE write 0 bytes because
> count in uninitialized.
>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
>   

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>



> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index a5887df..5b9c8af 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1841,6 +1841,7 @@ relock:
>  		if (ret)
>  			goto out_dio;
>  
> +		count = ocount;
>  		ret = generic_write_checks(file, ppos, &count,
>  					   S_ISBLK(inode->i_mode));
>  		if (ret)
>
>   
