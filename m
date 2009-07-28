From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 28 Jul 2009 14:47:44 -0700
Subject: [Ocfs2-devel] [PATCH 2/8] Provide
	ocfs2_cached_inode_extend_allocation()
In-Reply-To: <1248717216-26617-3-git-send-email-jack@suse.cz>
References: <1248717216-26617-1-git-send-email-jack@suse.cz>
	<1248717216-26617-3-git-send-email-jack@suse.cz>
Message-ID: <20090728214744.GE8420@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jul 27, 2009 at 07:53:30PM +0200, Jan Kara wrote:
> So far we had only ocfs2_extend_allocation() which read the inode from
> disk. Provide also the cached variant.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  include/ocfs2/ocfs2.h  |    2 +
>  libocfs2/extend_file.c |   51 ++++++++++++++++++++++++++---------------------
>  2 files changed, 30 insertions(+), 23 deletions(-)
> 
> diff --git a/include/ocfs2/ocfs2.h b/include/ocfs2/ocfs2.h
> index 4dbbf43..ac16823 100644
> --- a/include/ocfs2/ocfs2.h
> +++ b/include/ocfs2/ocfs2.h
> @@ -505,6 +505,8 @@ errcode_t ocfs2_delete_extent_block(ocfs2_filesys *fs, uint64_t blkno);
>   */
>  errcode_t ocfs2_extend_allocation(ocfs2_filesys *fs, uint64_t ino,
>  				  uint32_t new_clusters);
> +/* Ditto for cached inode */
> +errcode_t ocfs2_cached_inode_extend_allocation(ocfs2_cached_inode *ci, uint32_t new_clusters);

	Break the long line, but otherwise this patch looks good.  I'm
assuming you want to work on cached inodes later.

Joel

-- 

Life's Little Instruction Book #313

	"Never underestimate the power of love."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
