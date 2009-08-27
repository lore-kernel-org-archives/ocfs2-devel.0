From: Christoph Hellwig <hch@infradead.org>
Date: Thu, 27 Aug 2009 17:35:52 -0000
Subject: [Ocfs2-devel] [PATCH 07/17] vfs: Introduce new helpers for
	syncing after	writing to O_SYNC file or IS_SYNC inode
In-Reply-To: <1250875447-15622-8-git-send-email-jack@suse.cz>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
	<1250875447-15622-8-git-send-email-jack@suse.cz>
Message-ID: <20090827173540.GA19115@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, hch@lst.de, linux-fsdevel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Felix Blyakher <felixb@sgi.com>, xfs@oss.sgi.com, Anton Altaparmakov <aia21@cantab.net>, linux-ntfs-dev@lists.sourceforge.net, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-ext4@vger.kernel.org, tytso@mit.edu

> +int generic_write_sync(struct file *file, loff_t pos, loff_t count)
> +{
> +	if (!(file->f_flags & O_SYNC) && !IS_SYNC(file->f_mapping->host))
> +		return 0;
> +	return generic_sync_file(file, file->f_path.dentry, pos,
> +				 pos + count - 1,
> +				 SYNC_SUBMIT_DATA | SYNC_WAIT_DATA);
> +}
> +EXPORT_SYMBOL(generic_write_sync);

>  
> +/* Flags for generic_sync_file */
> +#define SYNC_INODE		1
> +#define SYNC_SUBMIT_DATA	2
> +#define SYNC_WAIT_DATA		4

When I think about this more I really hate the latter two flags.
There's really no reason to just do only either the submit or wait.
I'd say kill the flags for now and just implement generic_write_sync
as:

int generic_write_sync(struct file *file, loff_t pos, loff_t count)
{
	if (!(file->f_flags & O_SYNC) && !IS_SYNC(file->f_mapping->host))
		return 0;
	return vfs_fsync_range(file, file->f_path.dentry, pos,
			       pos + count - 1, 1);
}

and we can look into replacing the datasync flag with something more
meaningfull later through the whole fsync stack.
