From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Thu, 12 Sep 2019 08:54:41 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix spelling mistake "ambigous" ->
	"ambiguous"
In-Reply-To: <20190911160728.24322-1-colin.king@canonical.com>
References: <20190911160728.24322-1-colin.king@canonical.com>
Message-ID: <831bdff4-064e-038b-f45d-c4d265cbff1e@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Colin King <colin.king@canonical.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org



On 19/9/12 00:07, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a mlog_bug_on_msg message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 7ad9d6590818..7c9dfd50c1c1 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -534,7 +534,7 @@ static int ocfs2_read_locked_inode(struct inode *inode,
>  	 */
>  	mlog_bug_on_msg(!!(fe->i_flags & cpu_to_le32(OCFS2_SYSTEM_FL)) !=
>  			!!(args->fi_flags & OCFS2_FI_FLAG_SYSFILE),
> -			"Inode %llu: system file state is ambigous\n",
> +			"Inode %llu: system file state is ambiguous\n",
>  			(unsigned long long)args->fi_blkno);
>  
>  	if (S_ISCHR(le16_to_cpu(fe->i_mode)) ||
> 
