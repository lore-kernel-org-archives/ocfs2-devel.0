From: Andrzej Hajda <a.hajda@samsung.com>
Date: Wed, 16 Sep 2015 12:04:31 +0200
Subject: [Ocfs2-devel] [PATCH 23/31] fs/ocfs2: use kmemdup rather than
 duplicating its implementation
In-Reply-To: <1438934377-4922-24-git-send-email-a.hajda@samsung.com>
References: <1438934377-4922-1-git-send-email-a.hajda@samsung.com>
	<1438934377-4922-24-git-send-email-a.hajda@samsung.com>
Message-ID: <55F93EAF.4080704@samsung.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Ping.

Regards
Andrzej

On 08/07/2015 09:59 AM, Andrzej Hajda wrote:
> The patch was generated using fixed coccinelle semantic patch
> scripts/coccinelle/api/memdup.cocci [1].
>
> [1]: http://permalink.gmane.org/gmane.linux.kernel/2014320
>
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
>  fs/ocfs2/localalloc.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index 0a4457f..194d6d6 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -434,12 +434,11 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
>  	bh = osb->local_alloc_bh;
>  	alloc = (struct ocfs2_dinode *) bh->b_data;
>  
> -	alloc_copy = kmalloc(bh->b_size, GFP_NOFS);
> +	alloc_copy = kmemdup(alloc, bh->b_size, GFP_NOFS);
>  	if (!alloc_copy) {
>  		status = -ENOMEM;
>  		goto out_commit;
>  	}
> -	memcpy(alloc_copy, alloc, bh->b_size);
>  
>  	status = ocfs2_journal_access_di(handle, INODE_CACHE(local_alloc_inode),
>  					 bh, OCFS2_JOURNAL_ACCESS_WRITE);
> @@ -1285,13 +1284,12 @@ static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
>  	 * local alloc shutdown won't try to double free main bitmap
>  	 * bits. Make a copy so the sync function knows which bits to
>  	 * free. */
> -	alloc_copy = kmalloc(osb->local_alloc_bh->b_size, GFP_NOFS);
> +	alloc_copy = kmemdup(alloc, osb->local_alloc_bh->b_size, GFP_NOFS);
>  	if (!alloc_copy) {
>  		status = -ENOMEM;
>  		mlog_errno(status);
>  		goto bail;
>  	}
> -	memcpy(alloc_copy, alloc, osb->local_alloc_bh->b_size);
>  
>  	status = ocfs2_journal_access_di(handle,
>  					 INODE_CACHE(local_alloc_inode),
