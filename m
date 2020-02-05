From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Wed, 5 Feb 2020 16:41:21 +0800
Subject: [Ocfs2-devel] [PATCH] OCFS2: remove useless err
In-Reply-To: <1579577836-251879-1-git-send-email-alex.shi@linux.alibaba.com>
References: <1579577836-251879-1-git-send-email-alex.shi@linux.alibaba.com>
Message-ID: <c8f90c2a-1dab-2052-5662-ef634d8f7ecc@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 20/1/21 11:37, Alex Shi wrote:
> We don't need 'err' in these 2 places, better to remove them.
> 
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Mark Fasheh <mark@fasheh.com> 
> Cc: Joel Becker <jlbec@evilplan.org> 
> Cc: Joseph Qi <joseph.qi@linux.alibaba.com> 
> Cc: Andrew Morton <akpm@linux-foundation.org> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org> 
> Cc: Kate Stewart <kstewart@linuxfoundation.org> 
> Cc: ChenGang <cg.chen@huawei.com> 
> Cc: Richard Fontana <rfontana@redhat.com> 
> Cc: Thomas Gleixner <tglx@linutronix.de> 
> Cc: ocfs2-devel at oss.oracle.com 
> Cc: linux-kernel at vger.kernel.org

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/cluster/tcp.c | 3 +--
>  fs/ocfs2/dir.c         | 4 ++--
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
> index 48a3398f0bf5..9261c1f06a9f 100644
> --- a/fs/ocfs2/cluster/tcp.c
> +++ b/fs/ocfs2/cluster/tcp.c
> @@ -1948,7 +1948,6 @@ static void o2net_accept_many(struct work_struct *work)
>  {
>  	struct socket *sock = o2net_listen_sock;
>  	int	more;
> -	int	err;
>  
>  	/*
>  	 * It is critical to note that due to interrupt moderation
> @@ -1963,7 +1962,7 @@ static void o2net_accept_many(struct work_struct *work)
>  	 */
>  
>  	for (;;) {
> -		err = o2net_accept_one(sock, &more);
> +		o2net_accept_one(sock, &more);
>  		if (!more)
>  			break;
>  		cond_resched();
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index bdef72c0f099..5761060d2ba8 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -676,7 +676,7 @@ static struct buffer_head *ocfs2_find_entry_el(const char *name, int namelen,
>  	int ra_ptr = 0;		/* Current index into readahead
>  				   buffer */
>  	int num = 0;
> -	int nblocks, i, err;
> +	int nblocks, i;
>  
>  	sb = dir->i_sb;
>  
> @@ -708,7 +708,7 @@ static struct buffer_head *ocfs2_find_entry_el(const char *name, int namelen,
>  				num++;
>  
>  				bh = NULL;
> -				err = ocfs2_read_dir_block(dir, b++, &bh,
> +				ocfs2_read_dir_block(dir, b++, &bh,
>  							   OCFS2_BH_READAHEAD);
>  				bh_use[ra_max] = bh;
>  			}
> 
