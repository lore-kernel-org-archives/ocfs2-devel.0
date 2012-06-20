From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 20 Jun 2012 15:42:52 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix NULL pointer dereferrence in
 __ocfs2_change_file_space
In-Reply-To: <1340231684-1667-1-git-send-email-luis.henriques@canonical.com>
References: <20120620145659.a5fff5f6.akpm@linux-foundation.org>
	<1340231684-1667-1-git-send-email-luis.henriques@canonical.com>
Message-ID: <20120620154252.7dc7a817.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Bret Towe <magnade@gmail.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, mfasheh@suse.com, jlbec@evilplan.org, sunil.mushran@oracle.com

On Wed, 20 Jun 2012 23:34:44 +0100
Luis Henriques <luis.henriques@canonical.com> wrote:

> As ocfs2_fallocate() will invoke __ocfs2_change_file_space() with a NULL
> as the first parameter (file), it may trigger a NULL pointer dereferrence
> due to a missing check.  See http://bugs.launchpad.net/bugs/1006012.
> 
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> ---
>  fs/ocfs2/file.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 6e39668..84822a4 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1950,7 +1950,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  	if (ret < 0)
>  		mlog_errno(ret);
>  
> -	if (file->f_flags & O_SYNC)
> +	if (file && (file->f_flags & O_SYNC))
>  		handle->h_sync = 1;
>  
>  	ocfs2_commit_trans(osb, handle);

OK, at least it can't hurt ;)  I tagged it for -stable backporting.

Please don't forget the cc's and Tested-by:s.  There are quite a lot of
people involved in that launchpad report and they may like to know
what's going on, and can perhaps provide useful testing and review
input.  But I don't have their email addresses.
