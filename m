From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 31 May 2011 19:23:41 -0700
Subject: [Ocfs2-devel] [patch] ocfs2: checking the wrong variable in
 ocfs2_move_extent()
In-Reply-To: <20110529195631.GC3099@shale.localdomain>
References: <20110529195631.GC3099@shale.localdomain>
Message-ID: <20110601022341.GB29741@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, May 29, 2011 at 10:56:31PM +0300, Dan Carpenter wrote:
> "new_phys_cpos" is always a valid pointer here.
> ocfs2_probe_alloc_group() allocates "*new_phys_cpos".
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

This patch is now in the 'fixes' branch of ocfs2.git.

Joel

> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index 4c54884..f3eb060 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -747,7 +747,7 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>  	 */
>  	ocfs2_probe_alloc_group(inode, gd_bh, &goal_bit, len, move_max_hop,
>  				new_phys_cpos);
> -	if (!new_phys_cpos) {
> +	if (!*new_phys_cpos) {
>  		ret = -ENOSPC;
>  		goto out_commit;
>  	}

-- 

"If the human brain were so simple we could understand it, we would
 be so simple that we could not."
	- W. A. Clouston

			http://www.jlbec.org/
			jlbec at evilplan.org
