From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 21 Oct 2008 13:39:45 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Let inode be really deleted
	when	ocfs2_mknod_locked() fails
In-Reply-To: <1224523443843-git-send-email-jack@suse.cz>
References: <1224523443843-git-send-email-jack@suse.cz>
Message-ID: <20081021203945.GF2871@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Oct 20, 2008 at 07:23:54PM +0200, Jan Kara wrote:
> We forgot to set i_nlink to 0 when returning due to error from ocfs2_mknod_locked()
> and thus inode was not properly released via ocfs2_delete_inode() (e.g. claimed
> space was not released). Fix it.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Joel Becker <joel.becker@oracle.com>

For upstream too.

> ---
>  fs/ocfs2/namei.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 0372ef0..ff1a56d 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -495,8 +495,10 @@ leave:
>  			brelse(*new_fe_bh);
>  			*new_fe_bh = NULL;
>  		}
> -		if (inode)
> +		if (inode) {
> +			clear_nlink(inode);
>  			iput(inode);
> +		}
>  	}
>  
>  	mlog_exit(status);
> -- 
> 1.5.2.4
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

Life's Little Instruction Book #335

	"Every so often, push your luck."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
