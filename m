From: Joel Becker <Joel.Becker@oracle.com>
Date: Sun, 4 Jan 2009 23:51:39 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Access the right buffer_head
	in	ocfs2_merge_rec_left.
In-Reply-To: <1231137924-4779-1-git-send-email-tao.ma@oracle.com>
References: <1231137924-4779-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090105075139.GA30226@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jan 05, 2009 at 02:45:24PM +0800, Tao Ma wrote:
> In commit "ocfs2: Use metadata-specific ocfs2_journal_access_*()
> functions", the wrong buffer_head is accessed. So change it
> to the right buffer_head.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

Good catch!

Acked-by: Joel Becker <joel.becker@oracle.com>

> ---
>  fs/ocfs2/alloc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 874c0bd..54ff4c7 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -3402,8 +3402,8 @@ static int ocfs2_merge_rec_left(struct inode *inode,
>  			has_empty_extent = 1;
>  	}
>  
> -	ret = ocfs2_path_bh_journal_access(handle, inode, left_path,
> -					   path_num_items(left_path) - 1);
> +	ret = ocfs2_path_bh_journal_access(handle, inode, right_path,
> +					   path_num_items(right_path) - 1);
>  	if (ret) {
>  		mlog_errno(ret);
>  		goto out;
> -- 
> 1.5.5
> 

-- 

Life's Little Instruction Book #197

	"Don't forget, a person's greatest emotional need is to 
	 feel appreciated."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
