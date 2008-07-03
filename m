From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 3 Jul 2008 15:08:05 -0700
Subject: [Ocfs2-devel] [BUGFIX][PATCH] configfs: Fix open directory
	making rmdir()	fail
In-Reply-To: <1214565025-2646-1-git-send-email-louis.rilling@kerlabs.com>
References: <1214565025-2646-1-git-send-email-louis.rilling@kerlabs.com>
Message-ID: <20080703220805.GI1502@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri, Jun 27, 2008 at 01:10:25PM +0200, Louis Rilling wrote:
> When checking for user-created elements under an item to be removed by rmdir(),
> configfs_detach_prep() counts fake configfs_dirents created by dir_open() as
> user-created and fails when finding one. It is however perfectly valid to remove
> a directory that is open.
> 
> Simply make configfs_detach_prep() skip fake configfs_dirent, like it already
> does for attributes, and like detach_groups() does.

	This looks good.

> Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
> ---
>  fs/configfs/dir.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
> index 2c873fd..e721fd5 100644
> --- a/fs/configfs/dir.c
> +++ b/fs/configfs/dir.c
> @@ -379,7 +379,8 @@ static int configfs_detach_prep(struct dentry *dentry, struct mutex **wait_mutex
>  
>  	ret = 0;
>  	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
> -		if (sd->s_type & CONFIGFS_NOT_PINNED)
> +		if (!sd->s_element ||
> +		    (sd->s_type & CONFIGFS_NOT_PINNED))
>  			continue;
>  		if (sd->s_type & CONFIGFS_USET_DEFAULT) {
>  			/* Abort if racing with mkdir() */
> -- 
> 1.5.5.3
> 

-- 

"You can get more with a kind word and a gun than you can with
 a kind word alone."
         - Al Capone

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
