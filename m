From: Joel Becker <jlbec@evilplan.org>
Date: Sun, 26 Jun 2011 00:26:44 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Avoid livelock in ocfs2_readpage()
In-Reply-To: <1308862307-15626-1-git-send-email-jack@suse.cz>
References: <1308862307-15626-1-git-send-email-jack@suse.cz>
Message-ID: <20110626072643.GB15623@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jun 23, 2011 at 10:51:47PM +0200, Jan Kara wrote:
> When someone writes to an inode, readers accessing the same inode via
> ocfs2_readpage() just busyloop trying to get ip_alloc_sem because
> do_generic_file_read() looks up the page again and retries ->readpage()
> when previous attempt failed with AOP_TRUNCATED_PAGE. When there are enough
> readers, they can occupy all CPUs and in non-preempt kernel the system is
> deadlocked because writer holding ip_alloc_sem is never run to release the
> semaphore. Fix the problem by making reader block on ip_alloc_sem to break
> the busy loop.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ocfs2/aops.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index ac97bca..0919e8f 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -290,7 +290,15 @@ static int ocfs2_readpage(struct file *file, struct page *page)
>  	}
>  
>  	if (down_read_trylock(&oi->ip_alloc_sem) == 0) {
> +		/*
> +		 * Unlock the page and cycle ip_alloc_sem so that we don't
> +		 * busyloop waiting for ip_alloc_sem to unlock
> +		 */
>  		ret = AOP_TRUNCATED_PAGE;
> +		unlock_page(page);
> +		unlock = 0;
> +		down_read(&oi->ip_alloc_sem);
> +		up_read(&oi->ip_alloc_sem);
>  		goto out_inode_unlock;
>  	}

	Question: First, is it safe to drop the page lock here?
Can all callers of readpage (not just g_f_a_r()) handle that?>  

-- 

"But all my words come back to me
 In shades of mediocrity.
 Like emptiness in harmony
 I need someone to comfort me."

			http://www.jlbec.org/
			jlbec at evilplan.org
