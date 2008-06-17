From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 17 Jun 2008 15:17:13 -0700
Subject: [Ocfs2-devel] [BUGFIX][PATCH 1/3] configfs: Fix symlink() to a
	removing item
In-Reply-To: <1213724243-29183-2-git-send-email-louis.rilling@kerlabs.com>
References: <1213724243-29183-1-git-send-email-louis.rilling@kerlabs.com>
	<1213724243-29183-2-git-send-email-louis.rilling@kerlabs.com>
Message-ID: <20080617221713.GB29091@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, Jun 17, 2008 at 07:37:21PM +0200, Louis Rilling wrote:
> This patch makes configfs_symlink() fail whenever the target is being removed,
> using the CONFIGFS_USET_DROPPING flag set by configfs_detach_prep() and
> protected by configfs_dirent_lock.
> diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
> index faeb441..58722a9 100644
> --- a/fs/configfs/symlink.c
> +++ b/fs/configfs/symlink.c
> @@ -78,6 +78,12 @@ static int create_link(struct config_item *parent_item,
>  	if (sl) {
>  		sl->sl_target = config_item_get(item);
>  		spin_lock(&configfs_dirent_lock);
> +		if (target_sd->s_type & CONFIGFS_USET_DROPPING) {
> +			spin_unlock(&configfs_dirent_lock);
> +			config_item_put(item);
> +			kfree(sl);
> +			return -EPERM;

	This needs to be -ENOENT.  If rmdir set DROPPING and then
released dirent_lock, it's going to remove the target.  That's ENOENT.

Joel

-- 

"Sometimes when reading Goethe I have the paralyzing suspicion
 that he is trying to be funny."
         - Guy Davenport

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
