From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Feb 23 19:57:46 2004
Subject: [Ocfs2-devel] Re: [PATCH]2.6 fixes in file.c
In-Reply-To: <200402200413.i1K4DFoW004249@penguin.co.intel.com>
References: <200402200413.i1K4DFoW004249@penguin.co.intel.com>
Message-ID: <20040224015742.GI1421@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 19, 2004 at 08:13:15PM -0800, Rusty Lynch wrote:
> The following is a patch to file.c and proto.h that fixes some
> errors that happen when building with a 2.6 kernel.
> 
> * proper use of timespec time in various places
> * adds a new ocfs_sync_inode() function that for syncing inodes
>   in a 2.4 and 2.6 friendly way
> * removes more kdev references from the 2.6 code sections
> 
>     --rusty

This patch doesn't apply against current svn, would you mind regenerating it?

> Index: src/file.c
> ===================================================================
> --- src/file.c	(revision 32)
> +++ src/file.c	(working copy)
> @@ -30,6 +30,7 @@

<snip>

> +static int ocfs_sync_inode(struct inode *inode)
> +{
> +	int status;
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
> +	status = sync_mapping_buffers(inode->i_mapping);
> +#else
> +	status = fsync_inode_buffers(inode);
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,18)
> +	if (!status)	       
> +		status = fsync_inode_data_buffers(inode);
> +#endif
> +#endif
> +	return status;
> +}
Could we also add a prototype to the top of the file. That way we can keep
it consistent with the rest of the code.

<snip>

> @@ -455,10 +478,13 @@
>  	int err = 0;
>  	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, %d, '%*s')\n", file, dentry, datasync,
>                          dentry->d_name.len, dentry->d_name.name);
> -#if LINUX_VERSION_CODE >= LinuxVersionCode(2,4,18)
> -	fsync_inode_data_buffers(file->f_dentry->d_inode);
> -#endif
> -	err = fsync_inode_buffers(dentry->d_inode);
> +
> +	err = ocfs_sync_inode(dentry->d_inode);
> +
> +	/*
> +	 * Shouldn't we be commiting journal entries here?
> +	 */
> +
Ahh, I missed this case when updating the journalling code. We should be
calling journal_force_commit here. I'll check this out and fix things up in
a bit.

<snip>

>  int ocfs_empty (struct dentry *dentry);
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
> +int ocfs_dentry_revalidate (struct dentry *dentry, struct nameidata *nd);
> +#else
>  int ocfs_dentry_revalidate (struct dentry *dentry, int flags);
> +#endif
Why is this here? Shouldn't this update be in the dcache patch? 
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
