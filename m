From: Joel Becker <jlbec@evilplan.org>
Date: Sat, 19 Feb 2011 23:09:54 -0800
Subject: [Ocfs2-devel] [PATCH] Treat writes as new when holes span
 across page boundaries
In-Reply-To: <AANLkTi=pEu5y4=kjG1YoLR+YCd7Ak21QaFQz=AR3dffX@mail.gmail.com>
References: <AANLkTi=pEu5y4=kjG1YoLR+YCd7Ak21QaFQz=AR3dffX@mail.gmail.com>
Message-ID: <20110220070953.GC17784@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 17, 2011 at 09:44:40AM -0600, Goldwyn Rodrigues wrote:
> When a hole spans across page boundaries, the next write forces
> a read of the block. This could end up reading existing garbage
> data from the disk in ocfs2_map_page_blocks. This leads to
> non-zero holes. In order to avoid this, mark the writes as new
> when the holes span across page boundaries.

	Is this a new approach to your earlier patch, or an additional
change?

> ---
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 1fbb0e2..4be220d 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -1026,6 +1026,12 @@ static int ocfs2_prepare_page_for_write(struct
> inode *inode, u64 *p_blkno,
>  	ocfs2_figure_cluster_boundaries(OCFS2_SB(inode->i_sb), cpos,
>  					&cluster_start, &cluster_end);
> 
> +	/* treat the write as new if the a hole/lseek spanned across
> +	 * the page boundary.
> +	 */
> +	new = new | ((i_size_read(inode) <= page_offset(page)) &&
> +			(page_offset(page) <= user_pos));

	There are two problems here.  First, It's not safe to claim
existing data is 'new'.  Imagine you have a 4K page and a 512B
blocksize.  The first 2 blocks of the page have data in them, but your
code change will cause them to be set_uptodate() even if we haven't read
them in yet.
	Secondly, ocfs2_should_read_blk() already checks for blocks past
i_size and skips reading them.  So if you are trying to avoid reading
them, it is already handled.

Joel

-- 

Life's Little Instruction Book #511

	"Call your mother."

			http://www.jlbec.org/
			jlbec@evilplan.org
