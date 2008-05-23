From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Fri, 23 May 2008 18:44:58 +0200
Subject: [Ocfs2-devel] [RFC][PATCH 4/4] configfs: Make multiple
 default_group destructions lockdep friendly
In-Reply-To: <20080522114947.927196541@kerlabs.com>
References: <20080522114048.265996107@kerlabs.com>
	<20080522114947.927196541@kerlabs.com>
Message-ID: <4836F48A.70008@kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Louis Rilling a ?crit :
> When destroying a config_group having multiple (nested or not) default groups,
> lockdep raises a warning because multiple locks of class I_MUTEX_NORMAL are
> taken in configfs_detach_prep().
> 
> This patch makes such default group destructions lockdep-friendly by increasing
> the i_mutex sub-class from I_MUTEX_CHILD + 1 onwards for each default group
> locked under a being-destroyed config_group.

I discovered two bugs, as described below, and fixed in the attached
version of the patch. Sorry for the noise.

[...]
> 
> Index: b/fs/configfs/dir.c
> ===================================================================
> --- a/fs/configfs/dir.c	2008-05-22 12:38:02.000000000 +0200
> +++ b/fs/configfs/dir.c	2008-05-22 12:49:08.000000000 +0200
[...]
> @@ -383,7 +395,15 @@ static int configfs_detach_prep(struct d
>  		if (sd->s_type & CONFIGFS_NOT_PINNED)
>  			continue;
>  		if (sd->s_type & CONFIGFS_USET_DEFAULT) {
> -			mutex_lock(&sd->s_dentry->d_inode->i_mutex);
> +			lock_level = set_dirent_lock_level(parent_sd, sd);
> +			if (lock_level < 0) {
> +				/* Bad bad bad! We cannot remove a directory
> +				 * that we let be created! */
> +				ret = -ELOOP;
> +				break;
> +			}
> +			mutex_lock_nested(&sd->s_dentry->d_inode->i_mutex,
> +					  I_MUTEX_CHILD + lock_level);
>  			/* Mark that we've taken i_mutex */
>  			sd->s_type |= CONFIGFS_USET_DROPPING;
>  

Here setting lock_level before acquiring the mutex may race with mkdir
(and thus configfs_attach_group()) in the default group. A corrected
version of the patch is attached.

[...]
> @@ -1206,7 +1230,11 @@ static int configfs_rmdir(struct inode *
>  		return -EINVAL;
>  	}
>  
> +	/* The inode of the config_item being removed is already locked by
> +	 * vfs_rmdir() with subclass I_MUTEX_CHILD. Account for it. */
> +	set_dirent_lock_level(parent_item->ci_dentry->d_fsdata, sd);
>  	ret = configfs_detach_prep(dentry);
> +	reset_dirent_lock_level(sd);
>  	if (ret) {
>  		configfs_detach_rollback(dentry);
>  		config_item_put(parent_item);

lock_level should be reset on rollback, since mkdir may be called again
after a failure of rmdir. Again, fixed in the new version of the patch
in attachment.

Louis

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
-------------- next part --------------
A non-text attachment was scrubbed...
Name: configfs-make-default-group-destruction-lockdep-friendly-2.patch
Type: text/x-diff
Size: 7137 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080523/53738fb6/attachment.bin 
