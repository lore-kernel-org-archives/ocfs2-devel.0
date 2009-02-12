From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Feb 2009 11:23:42 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: add IO error check in
 ocfs2_get_sector() -v2
In-Reply-To: <200902120748.n1C7mVqx020705@acsinet13.oracle.com>
References: <200902120748.n1C7mVqx020705@acsinet13.oracle.com>
Message-ID: <4994773E.6020609@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The matching brelse() is in ocfs2_fill_super(). So you shouldn't
need it. Cross check though please.

Secondly, when you make a patch, please make it against mainline.
ocfs2 1.4 pulls in patches from mainline.

Sunil

wengang wang wrote:
> checks IO error in ocfs2_get_sector().
>
> this patch is based on 1.4 git.
>
> Signed-off-by: Wengang wang <wen.gang.wang@oracle.com>
> --
> Index: fs/ocfs2/super.c
> ===================================================================
> --- fs/ocfs2/super.c	(revision 128)
> +++ fs/ocfs2/super.c	(working copy)
> @@ -1203,6 +1203,12 @@ static int ocfs2_get_sector(struct super
>  	unlock_buffer(*bh);
>  	ll_rw_block(READ, 1, bh);
>  	wait_on_buffer(*bh);
> +	if (!buffer_uptodate(*bh)) {
> +		mlog_errno(-EIO);
> +		brelse(*bh);
> +		return -EIO;
> +	}
> +
>  	return 0;
>  }
>  
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>   
