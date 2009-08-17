From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 17 Aug 2009 12:53:31 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: release the buffer head in
	ocfs2_do_truncate.
In-Reply-To: <1250059367-14040-1-git-send-email-tao.ma@oracle.com>
References: <1250059367-14040-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090817195331.GA29615@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 12, 2009 at 02:42:47PM +0800, Tao Ma wrote:
> In ocfs2_do_truncate, we forget to release last_eb_bh which
> will cause memleak. So call brelse in the end.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

This is now in the fixes branch of ocfs2.git

Joel

> ---
>  fs/ocfs2/alloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index f9a3e89..ab513dd 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -6851,7 +6851,7 @@ static int ocfs2_do_truncate(struct ocfs2_super *osb,
>  	}
>  	status = 0;
>  bail:
> -
> +	brelse(last_eb_bh);
>  	mlog_exit(status);
>  	return status;
>  }
> -- 
> 1.5.5
> 

-- 

Life's Little Instruction Book #182

	"Be romantic."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
