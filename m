From: Joel Becker <jlbec@evilplan.org>
Date: Thu, 28 Jul 2011 03:10:43 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] Disable index if indexed directory
	find fails
In-Reply-To: <BANLkTikTBRxEhUb8OkwegPp1nSecxRixhA@mail.gmail.com>
References: <BANLkTikTBRxEhUb8OkwegPp1nSecxRixhA@mail.gmail.com>
Message-ID: <20110728101043.GE9495@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 15, 2011 at 10:58:25AM -0500, Goldwyn Rodrigues wrote:
> Disable directory indexing during a dirent search operation. In order to
> disable, the inode's buffer_head has to be passed through.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
> ---
>  fs/ocfs2/dir.c          |   30 ++++++++++++++++++++----------
>  fs/ocfs2/dir.h          |   10 +++++-----
>  fs/ocfs2/export.c       |    2 +-
>  fs/ocfs2/ioctl.c        |    3 ++-
>  fs/ocfs2/move_extents.c |    2 +-
>  fs/ocfs2/namei.c        |   33 +++++++++++++++++----------------
>  fs/ocfs2/sysfile.c      |    2 +-
>  7 files changed, 47 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 3a6f6e4..b6cf5d2 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -1113,13 +1113,22 @@ static void ocfs2_dx_disable(struct inode
> *dir, struct buffer_head *di_bh)
>   * in the indexed directory case, multiple buffers are involved.
>   */
>  int ocfs2_find_entry(const char *name, int namelen,
> -		     struct inode *dir, struct ocfs2_dir_lookup_result *lookup)
> +		     struct inode *dir, struct buffer_head *di_bh,
> +		     struct ocfs2_dir_lookup_result *lookup)

	I really don't like the churn in all these prototypes.  I
understand that the bh is necessary for your ocfs2_dx_disable()
function, but the fact that you have so many calls of the lookup code
with NULL bh says that this can't really be the right approach.
	In fact, how do you even know that journal_access was called on
the inodes you are updating.  I wish I hadn't missed that in the first
patch.
	What if, instead of clearing the inode right then, you just
disabled the feature on the oi->ip_dyn_features.  All the lookup code
will ignore it from then on.
	When it comes to updating the dinode, the important thing is
that the bit is cleared before the directory is modified.  You can only
do that when you have a write lock, and you only need to do it during
insert, rename, or unlink.  So in ocfs2_prepare_dir_for_insert() and
ocfs2_delete_entry(), when ocfs2_indexed_dir(dir) == 0 but
ocfs2_supports_indexed_dirs(osb) == 1, make sure to wipe the index off
of the dinode.  This should, I think, cover insert, unlink, and rename.

Joel

-- 

"People with narrow minds usually have broad tongues."

			http://www.jlbec.org/
			jlbec at evilplan.org
