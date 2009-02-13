From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Feb 2009 21:04:29 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: add IO error check in
	ocfs2_get_sector() -v3
In-Reply-To: <200902130212.n1D2CplR018913@acsinet13.oracle.com>
References: <200902130212.n1D2CplR018913@acsinet13.oracle.com>
Message-ID: <C4AC49D3-BAEC-476F-97A6-5ADD205E58B6@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>


On Feb 12, 2009, at 6:11 PM, wengang wang <wen.gang.wang@oracle.com>  
wrote:

> checks IO error in ocfs2_get_sector().
>
> this patch is based on Linus' git.
>
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> --
> diff -up ./fs/ocfs2/super.c.orig ./fs/ocfs2/super.c
> --- ./fs/ocfs2/super.c.orig    2009-02-12 18:05:19.023685000 -0800
> +++ ./fs/ocfs2/super.c    2009-02-12 18:07:13.995623000 -0800
> @@ -1537,6 +1537,13 @@ static int ocfs2_get_sector(struct super
>    unlock_buffer(*bh);
>    ll_rw_block(READ, 1, bh);
>    wait_on_buffer(*bh);
> +    if (!buffer_uptodate(*bh)) {
> +        mlog_errno(-EIO);
> +        brelse(*bh);
> +        *bh = NULL;
> +        return -EIO;
> +    }
> +
>    return 0;
> }
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
