From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon Dec 24 13:58:25 2007
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: cluster aware flock()
In-Reply-To: <20071221005548.GL13821@ca-server1.us.oracle.com>
References: <20071221005548.GL13821@ca-server1.us.oracle.com>
Message-ID: <20071224215806.GJ7242@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 20, 2007 at 04:55:48PM -0800, Mark Fasheh wrote:
> Hook up ocfs2_flock(), using the new flock lock type in dlmglue.c. A new
> mount option, "localflocks" is added so that users can revert to old
> functionality as need be.
> 
> Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

Signed-off-by: Joel Becker <joel.becker@oracle.com>

> ---
>  Documentation/filesystems/ocfs2.txt |    1 +
>  fs/ocfs2/Makefile                   |    1 +
>  fs/ocfs2/file.c                     |   60 ++++++++++++++++-
>  fs/ocfs2/locks.c                    |  125 +++++++++++++++++++++++++++++++++++
>  fs/ocfs2/locks.h                    |   31 +++++++++
>  fs/ocfs2/ocfs2.h                    |    1 +
>  fs/ocfs2/super.c                    |   19 +++++
>  7 files changed, 237 insertions(+), 1 deletions(-)
>  create mode 100644 fs/ocfs2/locks.c
>  create mode 100644 fs/ocfs2/locks.h
> 
> diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
> index ed55238..81007e8 100644
> --- a/Documentation/filesystems/ocfs2.txt
> +++ b/Documentation/filesystems/ocfs2.txt
> @@ -62,3 +62,4 @@ data=writeback		Data ordering is not preserved, data may be written
>  preferred_slot=0(*)	During mount, try to use this filesystem slot first. If
>  			it is in use by another node, the first empty one found
>  			will be chosen. Invalid values will be ignored.
> +localflocks		This disables cluster aware flock.
> diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
> index 9fb8132..c268c91 100644
> --- a/fs/ocfs2/Makefile
> +++ b/fs/ocfs2/Makefile
> @@ -19,6 +19,7 @@ ocfs2-objs := \
>  	ioctl.o 		\
>  	journal.o 		\
>  	localalloc.o 		\
> +	locks.o			\
>  	mmap.o 			\
>  	namei.o 		\
>  	slot_map.o 		\
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index b75b2e1..67a7cfc 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -51,6 +51,7 @@
>  #include "inode.h"
>  #include "ioctl.h"
>  #include "journal.h"
> +#include "locks.h"
>  #include "mmap.h"
>  #include "suballoc.h"
>  #include "super.h"
> @@ -63,6 +64,35 @@ static int ocfs2_sync_inode(struct inode *inode)
>  	return sync_mapping_buffers(inode->i_mapping);
>  }
>  
> +static int ocfs2_init_file_private(struct inode *inode, struct file *file)
> +{
> +	struct ocfs2_file_private *fp;
> +
> +	fp = kzalloc(sizeof(struct ocfs2_file_private), GFP_KERNEL);
> +	if (!fp)
> +		return -ENOMEM;
> +
> +	fp->fp_file = file;
> +	mutex_init(&fp->fp_mutex);
> +	ocfs2_file_lock_res_init(&fp->fp_flock, fp);
> +	file->private_data = fp;
> +
> +	return 0;
> +}
> +
> +static void ocfs2_free_file_private(struct inode *inode, struct file *file)
> +{
> +	struct ocfs2_file_private *fp = file->private_data;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +
> +	if (fp) {
> +		ocfs2_simple_drop_lockres(osb, &fp->fp_flock);
> +		ocfs2_lock_res_free(&fp->fp_flock);
> +		kfree(fp);
> +		file->private_data = NULL;
> +	}
> +}
> +
>  static int ocfs2_file_open(struct inode *inode, struct file *file)
>  {
>  	int status;
> @@ -89,7 +119,18 @@ static int ocfs2_file_open(struct inode *inode, struct file *file)
>  
>  	oi->ip_open_count++;
>  	spin_unlock(&oi->ip_lock);
> -	status = 0;
> +
> +	status = ocfs2_init_file_private(inode, file);
> +	if (status) {
> +		/*
> +		 * We want to set open count back if we're failing the
> +		 * open.
> +		 */
> +		spin_lock(&oi->ip_lock);
> +		oi->ip_open_count--;
> +		spin_unlock(&oi->ip_lock);
> +	}
> +
>  leave:
>  	mlog_exit(status);
>  	return status;
> @@ -108,11 +149,24 @@ static int ocfs2_file_release(struct inode *inode, struct file *file)
>  		oi->ip_flags &= ~OCFS2_INODE_OPEN_DIRECT;
>  	spin_unlock(&oi->ip_lock);
>  
> +	ocfs2_free_file_private(inode, file);
> +
>  	mlog_exit(0);
>  
>  	return 0;
>  }
>  
> +static int ocfs2_dir_open(struct inode *inode, struct file *file)
> +{
> +	return ocfs2_init_file_private(inode, file);
> +}
> +
> +static int ocfs2_dir_release(struct inode *inode, struct file *file)
> +{
> +	ocfs2_free_file_private(inode, file);
> +	return 0;
> +}
> +
>  static int ocfs2_sync_file(struct file *file,
>  			   struct dentry *dentry,
>  			   int datasync)
> @@ -2216,6 +2270,7 @@ const struct file_operations ocfs2_fops = {
>  #ifdef CONFIG_COMPAT
>  	.compat_ioctl   = ocfs2_compat_ioctl,
>  #endif
> +	.flock		= ocfs2_flock,
>  	.splice_read	= ocfs2_file_splice_read,
>  	.splice_write	= ocfs2_file_splice_write,
>  };
> @@ -2224,8 +2279,11 @@ const struct file_operations ocfs2_dops = {
>  	.read		= generic_read_dir,
>  	.readdir	= ocfs2_readdir,
>  	.fsync		= ocfs2_sync_file,
> +	.release	= ocfs2_dir_release,
> +	.open		= ocfs2_dir_open,
>  	.ioctl		= ocfs2_ioctl,
>  #ifdef CONFIG_COMPAT
>  	.compat_ioctl   = ocfs2_compat_ioctl,
>  #endif
> +	.flock		= ocfs2_flock,
>  };
> diff --git a/fs/ocfs2/locks.c b/fs/ocfs2/locks.c
> new file mode 100644
> index 0000000..203f871
> --- /dev/null
> +++ b/fs/ocfs2/locks.c
> @@ -0,0 +1,125 @@
> +/* -*- mode: c; c-basic-offset: 8; -*-
> + * vim: noexpandtab sw=8 ts=8 sts=0:
> + *
> + * locks.c
> + *
> + * Userspace file locking support
> + *
> + * Copyright (C) 2007 Oracle.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License as published by the Free Software Foundation; either
> + * version 2 of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.
> + */
> +
> +#include <linux/fs.h>
> +
> +#define MLOG_MASK_PREFIX ML_INODE
> +#include <cluster/masklog.h>
> +
> +#include "ocfs2.h"
> +
> +#include "dlmglue.h"
> +#include "file.h"
> +#include "locks.h"
> +
> +static int ocfs2_do_flock(struct file *file, struct inode *inode,
> +			  int cmd, struct file_lock *fl)
> +{
> +	int ret = 0, level = 0, trylock = 0;
> +	struct ocfs2_file_private *fp = file->private_data;
> +	struct ocfs2_lock_res *lockres = &fp->fp_flock;
> +
> +	if (fl->fl_type == F_WRLCK)
> +		level = 1;
> +	if (!IS_SETLKW(cmd))
> +		trylock = 1;
> +
> +	mutex_lock(&fp->fp_mutex);
> +
> +	if (lockres->l_flags & OCFS2_LOCK_ATTACHED &&
> +	    lockres->l_level > LKM_NLMODE) {
> +		int old_level = 0;
> +
> +		if (lockres->l_level == LKM_EXMODE)
> +			old_level = 1;
> +
> +		if (level == old_level)
> +			goto out;
> +
> +		/*
> +		 * Converting an existing lock is not guaranteed to be
> +		 * atomic, so we can get away with simply unlocking
> +		 * here and allowing the lock code to try at the new
> +		 * level.
> +		 */
> +
> +		flock_lock_file_wait(file,
> +				     &(struct file_lock){.fl_type = F_UNLCK});
> +
> +		ocfs2_file_unlock(file);
> +	}
> +
> +	ret = ocfs2_file_lock(file, level, trylock);
> +	if (ret) {
> +		if (ret == -EAGAIN && trylock)
> +			ret = -EWOULDBLOCK;
> +		else
> +			mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	ret = flock_lock_file_wait(file, fl);
> +
> +out:
> +	mutex_unlock(&fp->fp_mutex);
> +
> +	return ret;
> +}
> +
> +static int ocfs2_do_funlock(struct file *file, int cmd, struct file_lock *fl)
> +{
> +	int ret;
> +	struct ocfs2_file_private *fp = file->private_data;
> +
> +	mutex_lock(&fp->fp_mutex);
> +	ocfs2_file_unlock(file);
> +	ret = flock_lock_file_wait(file, fl);
> +	mutex_unlock(&fp->fp_mutex);
> +
> +	return ret;
> +}
> +
> +/*
> + * Overall flow of ocfs2_flock() was influenced by gfs2_flock().
> + */
> +int ocfs2_flock(struct file *file, int cmd, struct file_lock *fl)
> +{
> +	struct inode *inode = file->f_mapping->host;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +
> +	if (!(fl->fl_flags & FL_FLOCK))
> +		return -ENOLCK;
> +	if (__mandatory_lock(inode))
> +		return -ENOLCK;
> +
> +	if ((osb->s_mount_opt & OCFS2_MOUNT_LOCALFLOCKS) ||
> +	    ocfs2_mount_local(osb))
> +		return flock_lock_file_wait(file, fl);
> +
> +	if (fl->fl_type == F_UNLCK)
> +		return ocfs2_do_funlock(file, cmd, fl);
> +	else
> +		return ocfs2_do_flock(file, inode, cmd, fl);
> +}
> diff --git a/fs/ocfs2/locks.h b/fs/ocfs2/locks.h
> new file mode 100644
> index 0000000..9743ef2
> --- /dev/null
> +++ b/fs/ocfs2/locks.h
> @@ -0,0 +1,31 @@
> +/* -*- mode: c; c-basic-offset: 8; -*-
> + * vim: noexpandtab sw=8 ts=8 sts=0:
> + *
> + * locks.h
> + *
> + * Function prototypes for Userspace file locking support
> + *
> + * Copyright (C) 2002, 2004 Oracle.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License as published by the Free Software Foundation; either
> + * version 2 of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.
> + */
> +
> +#ifndef OCFS2_LOCKS_H
> +#define OCFS2_LOCKS_H
> +
> +int ocfs2_flock(struct file *file, int cmd, struct file_lock *fl);
> +
> +#endif /* OCFS2_LOCKS_H */
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 9c34b83..f653995 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -171,6 +171,7 @@ enum ocfs2_mount_options
>  	OCFS2_MOUNT_NOINTR  = 1 << 2,   /* Don't catch signals */
>  	OCFS2_MOUNT_ERRORS_PANIC = 1 << 3, /* Panic on errors */
>  	OCFS2_MOUNT_DATA_WRITEBACK = 1 << 4, /* No data ordering */
> +	OCFS2_MOUNT_LOCALFLOCKS = 1 << 5, /* No cluster aware user file locks */
>  };
>  
>  #define OCFS2_OSB_SOFT_RO	0x0001
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 5ee7754..edb1241 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -150,6 +150,7 @@ enum {
>  	Opt_data_writeback,
>  	Opt_atime_quantum,
>  	Opt_slot,
> +	Opt_localflocks,
>  	Opt_err,
>  };
>  
> @@ -165,6 +166,7 @@ static match_table_t tokens = {
>  	{Opt_data_writeback, "data=writeback"},
>  	{Opt_atime_quantum, "atime_quantum=%u"},
>  	{Opt_slot, "preferred_slot=%u"},
> +	{Opt_localflocks, "localflocks"},
>  	{Opt_err, NULL}
>  };
>  
> @@ -816,6 +818,20 @@ static int ocfs2_parse_options(struct super_block *sb,
>  			if (option)
>  				mopt->slot = (s16)option;
>  			break;
> +		case Opt_localflocks:
> +			/*
> +			 * Changing this during remount could race
> +			 * flock() requests, or "unbalance" existing
> +			 * ones (e.g., a lock is taken in one mode but
> +			 * dropped in the other). If users care enough
> +			 * to flip locking modes during remount, we
> +			 * could add a "local" flag to individual
> +			 * flock structures for proper tracking of
> +			 * state.
> +			 */
> +			if (!is_remount)
> +				mopt->mount_opt |= OCFS2_MOUNT_LOCALFLOCKS;
> +			break;
>  		default:
>  			mlog(ML_ERROR,
>  			     "Unrecognized mount option \"%s\" "
> @@ -864,6 +880,9 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
>  	if (osb->s_atime_quantum != OCFS2_DEFAULT_ATIME_QUANTUM)
>  		seq_printf(s, ",atime_quantum=%u", osb->s_atime_quantum);
>  
> +	if (opts & OCFS2_MOUNT_LOCALFLOCKS)
> +		seq_printf(s, ",localflocks,");
> +
>  	return 0;
>  }
>  
> -- 
> 1.5.3.6
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

Life's Little Instruction Book #198

	"Feed a stranger's expired parking meter."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
