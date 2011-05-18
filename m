From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 18 May 2011 11:36:59 -0700
Subject: [Ocfs2-devel] [Ocfs2-users] ocfs or configfs bug ?
In-Reply-To: <20110518111223.GB7330@noexit.corp.google.com>
References: <4DADA228.5050209@bull.net> <20110419194840.GA27826@noexit>
	<4DAE26BA.3010203@oracle.com> <4DC9E889.3080008@oracle.com>
	<20110518104955.GA7330@noexit.corp.google.com>
	<20110518111223.GB7330@noexit.corp.google.com>
Message-ID: <4DD411CB.4090308@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 05/18/2011 04:12 AM, Joel Becker wrote:
> On Wed, May 18, 2011 at 03:49:56AM -0700, Joel Becker wrote:
>> 	sysfs_mutex is peppered everywhere.  It's rather ugly, I think.
>> I am thinking about how the code reads.  I admit I also don't like that
>> sysfs_mutex serializes all accesses to the sysfs directory tree, but I'd
>> be OK with that as a stopgap solution if the code only read better.
> 	Can you test this?
>
> Joel


So it did run for far longer. But then hit the following.

http://oss.oracle.com/~smushran/configfs_oops_20110518.txt

BTW, this is not new. I was running into it earlier too. Albeit
less frequently than readdir.


>  From 24307aa1e707b31613be92deaba7990e16bc1aec Mon Sep 17 00:00:00 2001
> From: Joel Becker<jlbec@evilplan.org>
> Date: Wed, 18 May 2011 04:08:16 -0700
> Subject: [PATCH] configfs: Fix race between configfs_readdir() and configfs_d_iput()
>
> configfs_readdir() will use the existing inode numbers of inodes in the
> dcache, but it makes them up for attribute files that aren't currently
> instantiated.  There is a race where a closing attribute file can be
> tearing down at the same time as configfs_readdir() is trying to get its
> inode number.
>
> We want to get the inode number of open attribute files, because they
> should match while instantiated.  We can't lock down the transition
> where dentry->d_inode is set to NULL, so we just check for NULL there.
> We can, however, ensure that an inode we find isn't iput() in
> configfs_d_iput() until after we've accessed it.
>
> Signed-off-by: Joel Becker<jlbec@evilplan.org>
> ---
>   fs/configfs/dir.c |   33 ++++++++++++++++++++++++++++-----
>   1 files changed, 28 insertions(+), 5 deletions(-)
>
> diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
> index b11d734..9a37a9b 100644
> --- a/fs/configfs/dir.c
> +++ b/fs/configfs/dir.c
> @@ -53,11 +53,14 @@ DEFINE_SPINLOCK(configfs_dirent_lock);
>   static void configfs_d_iput(struct dentry * dentry,
>   			    struct inode * inode)
>   {
> -	struct configfs_dirent * sd = dentry->d_fsdata;
> +	struct configfs_dirent *sd = dentry->d_fsdata;
>
>   	if (sd) {
>   		BUG_ON(sd->s_dentry != dentry);
> +		/* Coordinate with configfs_readdir */
> +		spin_lock(&configfs_dirent_lock);
>   		sd->s_dentry = NULL;
> +		spin_unlock(&configfs_dirent_lock);
>   		configfs_put(sd);
>   	}
>   	iput(inode);
> @@ -1546,7 +1549,7 @@ static int configfs_readdir(struct file * filp, void * dirent, filldir_t filldir
>   	struct configfs_dirent * parent_sd = dentry->d_fsdata;
>   	struct configfs_dirent *cursor = filp->private_data;
>   	struct list_head *p, *q =&cursor->s_sibling;
> -	ino_t ino;
> +	ino_t ino = 0;
>   	int i = filp->f_pos;
>
>   	switch (i) {
> @@ -1574,6 +1577,7 @@ static int configfs_readdir(struct file * filp, void * dirent, filldir_t filldir
>   				struct configfs_dirent *next;
>   				const char * name;
>   				int len;
> +				struct inode *inode = NULL;
>
>   				next = list_entry(p, struct configfs_dirent,
>   						   s_sibling);
> @@ -1582,9 +1586,28 @@ static int configfs_readdir(struct file * filp, void * dirent, filldir_t filldir
>
>   				name = configfs_get_name(next);
>   				len = strlen(name);
> -				if (next->s_dentry)
> -					ino = next->s_dentry->d_inode->i_ino;
> -				else
> +
> +				/*
> +				 * We'll have a dentry and an inode for
> +				 * PINNED items and for open attribute
> +				 * files.  We lock here to prevent a race
> +				 * with configfs_d_iput() clearing
> +				 * s_dentry before calling iput().
> +				 *
> +				 * Why do we go to the trouble?  If
> +				 * someone has an attribute file open,
> +				 * the inode number should match until
> +				 * they close it.  Beyond that, we don't
> +				 * care.
> +				 */
> +				spin_lock(&configfs_dirent_lock);
> +				dentry = next->s_dentry;
> +				if (dentry)
> +					inode = dentry->d_inode;
> +				if (inode)
> +					ino = inode->i_ino;
> +				spin_unlock(&configfs_dirent_lock);
> +				if (!inode)
>   					ino = iunique(configfs_sb, 2);
>
>   				if (filldir(dirent, name, len, filp->f_pos, ino,
