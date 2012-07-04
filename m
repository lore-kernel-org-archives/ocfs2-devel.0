From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 4 Jul 2012 00:34:15 -0700
Subject: [Ocfs2-devel] [PATCH v4 2/2] ocfs2: clear unaligned io flag
 when dio fails
In-Reply-To: <1340788195-20623-3-git-send-email-junxiao.bi@oracle.com>
References: <1340788195-20623-1-git-send-email-junxiao.bi@oracle.com>
	<1340788195-20623-3-git-send-email-junxiao.bi@oracle.com>
Message-ID: <20120704073415.GF9863@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, mfasheh@suse.com, joe.jin@oracle.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, akpm@linux-foundation.org

On Wed, Jun 27, 2012 at 05:09:55PM +0800, Junxiao Bi wrote:
> The unaligned io flag is set in the kiocb when an unaligned
> dio is issued, it should be cleared even when the dio fails,
> or it may affect the following io which are using the same
> kiocb.
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: stable at vger.kernel.org

This patch is now part of the 'fixes' branch of ocfs2.git.

Joel

> ---
>  fs/ocfs2/file.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 061591a..98513c8 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2422,8 +2422,10 @@ out_dio:
>  		unaligned_dio = 0;
>  	}
>  
> -	if (unaligned_dio)
> +	if (unaligned_dio) {
> +		ocfs2_iocb_clear_unaligned_aio(iocb);
>  		atomic_dec(&OCFS2_I(inode)->ip_unaligned_aio);
> +	}
>  
>  out:
>  	if (rw_level != -1)
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"Up and down that road in our worn out shoes,
 Talking bout good things and singing the blues."

			http://www.jlbec.org/
			jlbec at evilplan.org
