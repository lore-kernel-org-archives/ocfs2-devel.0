From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 12 Feb 2009 11:45:25 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: add IO error check
	in	ocfs2_get_sector() -v2
In-Reply-To: <200902120748.n1C7mVqx020705@acsinet13.oracle.com>
References: <200902120748.n1C7mVqx020705@acsinet13.oracle.com>
Message-ID: <20090212194525.GB14638@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 12, 2009 at 03:47:26PM +0800, wengang wang wrote:
> checks IO error in ocfs2_get_sector().
> 
> this patch is based on 1.4 git.

	This patch is good, but definitely needs to be against mainline.

sobby

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

-- 

The Graham Corollary:

	The longer a socially-moderated news website exists, the
	probability of an old Paul Graham link appearing at the top
	approaches certainty.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
