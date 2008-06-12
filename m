From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 12 Jun 2008 12:13:48 -0700
Subject: [Ocfs2-devel] [PATCH 1/3][BUGFIX] configfs: Introduce
	configfs_dirent_lock
In-Reply-To: <20080612134203.763166823@kerlabs.com>
References: <20080612133126.335618468@kerlabs.com>
	<20080612134203.763166823@kerlabs.com>
Message-ID: <20080612191348.GE5377@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Thu, Jun 12, 2008 at 03:31:27PM +0200, Louis Rilling wrote:
> This patch introduces configfs_dirent_lock spinlock to protect configfs_dirent
> traversals against linkage mutations (add/del/move). This will allow
> configfs_detach_prep() to avoid locking i_mutexes. 

	I like that you expanded the scope to cover all configfs_dirent
linkages.  These are all protected by i_mutex in the current code, but
your rename fix removes that protection.

> Locking rules for configfs_dirent linkage mutations are the same plus the
> requirement of taking configfs_dirent_lock. For configfs_dirent walking, one can
> either take appropriate i_mutex as before, or take configfs_dirent_lock.

	Nope, you *must* take configfs_dirent_lock now.  You've removed
i_mutex protection in the last patch.


> The spinlock could actually be a mutex, but the critical sections are either
> O(1) or should not be too long (default groups walking in last patch).

	I'm wary of someone's reasonably deep groups.  Discussing it
yesterday I'd been convinced that a mutex was good to start with.  But
given your increased scope of the lock, let's try the spinlock and see
what happens.

> +extern spinlock_t configfs_dirent_lock;

	Boy I wish this could be static to one file :-(

> @@ -79,7 +84,9 @@ static struct configfs_dirent *configfs_
>  	atomic_set(&sd->s_count, 1);
>  	INIT_LIST_HEAD(&sd->s_links);
>  	INIT_LIST_HEAD(&sd->s_children);
> +	spin_lock(&configfs_dirent_lock);
>  	list_add(&sd->s_sibling, &parent_sd->s_children);
> +	spin_unlock(&configfs_dirent_lock);
>  	sd->s_element = element;

	You need to set s_element either under the lock or before taking
the lock.  Once you've dropped the lock, someone can reach this dirent
from the parent, and should see s_element.

> @@ -173,7 +180,9 @@ static int create_dir(struct config_item
>  		} else {
>  			struct configfs_dirent *sd = d->d_fsdata;
>  			if (sd) {
> +				spin_lock(&configfs_dirent_lock);
>  				list_del_init(&sd->s_sibling);
> +				spin_unlock(&configfs_dirent_lock);
>  				configfs_put(sd);
>  			}
>  		}
> @@ -224,7 +233,9 @@ int configfs_create_link(struct configfs
>  		else {
>  			struct configfs_dirent *sd = dentry->d_fsdata;
>  			if (sd) {
> +				spin_lock(&configfs_dirent_lock);
>  				list_del_init(&sd->s_sibling);
> +				spin_unlock(&configfs_dirent_lock);
>  				configfs_put(sd);
>  			}
>  		}

	These strike me as wrong - I would think that one should either
see the old configfs_dirent tree or the new one.  That is, one would
take the dirent lock at the beginning of configfs_mkdir() and release it
at the end - so any other code that looks at the dirent tree will see an
atomic change.  Here, some other path could see the new dirent after
configfs_make_dirent() but then it disappears when configfs_create()
fails.
	If you did that, though, it'd have to be a mutex.
	Now, the only thing that sees this intermediate condition is
configfs itself.  Everyone else is protected by i_mutex.  I guess it's
OK - but can you comment that fact?  i_mutex does *not* protect
traversal of the configfs_dirent tree, but it does prevent the outside
world from seeing the intermediate states.

> @@ -238,7 +249,9 @@ static void remove_dir(struct dentry * d
>  	struct configfs_dirent * sd;
>  
>  	sd = d->d_fsdata;
> +	spin_lock(&configfs_dirent_lock);
>  	list_del_init(&sd->s_sibling);
> +	spin_unlock(&configfs_dirent_lock);
>  	configfs_put(sd);
>  	if (d->d_inode)
>  		simple_rmdir(parent->d_inode,d);
> @@ -410,7 +423,9 @@ static void detach_attrs(struct config_i
>  	list_for_each_entry_safe(sd, tmp, &parent_sd->s_children, s_sibling) {
>  		if (!sd->s_element || !(sd->s_type & CONFIGFS_NOT_PINNED))
>  			continue;
> +		spin_lock(&configfs_dirent_lock);
>  		list_del_init(&sd->s_sibling);
> +		spin_unlock(&configfs_dirent_lock);
>  		configfs_drop_dentry(sd, dentry);
>  		configfs_put(sd);
>  	}
> @@ -1268,7 +1283,9 @@ static int configfs_dir_close(struct ino
>  	struct configfs_dirent * cursor = file->private_data;
>  
>  	mutex_lock(&dentry->d_inode->i_mutex);
> +	spin_lock(&configfs_dirent_lock);
>  	list_del_init(&cursor->s_sibling);
> +	spin_unlock(&configfs_dirent_lock);
>  	mutex_unlock(&dentry->d_inode->i_mutex);
>  
>  	release_configfs_dirent(cursor);
> @@ -1362,7 +1383,9 @@ static loff_t configfs_dir_lseek(struct 
>  			struct list_head *p;
>  			loff_t n = file->f_pos - 2;
>  
> +			spin_lock(&configfs_dirent_lock);
>  			list_del(&cursor->s_sibling);
> +			spin_unlock(&configfs_dirent_lock);
>  			p = sd->s_children.next;
>  			while (n && p != &sd->s_children) {
>  				struct configfs_dirent *next;
> @@ -1372,7 +1395,9 @@ static loff_t configfs_dir_lseek(struct 
>  					n--;
>  				p = p->next;
>  			}
> +			spin_lock(&configfs_dirent_lock);
>  			list_add_tail(&cursor->s_sibling, p);
> +			spin_unlock(&configfs_dirent_lock);
>  		}
>  	}
>  	mutex_unlock(&dentry->d_inode->i_mutex);
> Index: b/fs/configfs/inode.c
> ===================================================================
> --- a/fs/configfs/inode.c	2008-06-12 13:44:27.000000000 +0200
> +++ b/fs/configfs/inode.c	2008-06-12 13:44:34.000000000 +0200
> @@ -247,7 +247,9 @@ void configfs_hash_and_remove(struct den
>  		if (!sd->s_element)
>  			continue;
>  		if (!strcmp(configfs_get_name(sd), name)) {
> +			spin_lock(&configfs_dirent_lock);
>  			list_del_init(&sd->s_sibling);
> +			spin_unlock(&configfs_dirent_lock);
>  			configfs_drop_dentry(sd, dir);
>  			configfs_put(sd);
>  			break;
> Index: b/fs/configfs/symlink.c
> ===================================================================
> --- a/fs/configfs/symlink.c	2008-06-12 13:44:27.000000000 +0200
> +++ b/fs/configfs/symlink.c	2008-06-12 13:44:34.000000000 +0200
> @@ -169,7 +169,9 @@ int configfs_unlink(struct inode *dir, s
>  	parent_item = configfs_get_config_item(dentry->d_parent);
>  	type = parent_item->ci_type;
>  
> +	spin_lock(&configfs_dirent_lock);
>  	list_del_init(&sd->s_sibling);
> +	spin_unlock(&configfs_dirent_lock);
>  	configfs_drop_dentry(sd, dentry->d_parent);
>  	dput(dentry);
>  	configfs_put(sd);

	You do the lock,del(sibling),unlock so often, maybe it should be
a helper.  Then you can make configfs_dirent_lock static to dir.c.
Well, you use dirent_lock in your s_links patch, so maybe not static.

Joel

-- 

"Copy from one, it's plagiarism; copy from two, it's research."
        - Wilson Mizner

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
