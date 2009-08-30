From: Christoph Hellwig <hch@lst.de>
Date: Sun, 30 Aug 2009 16:40:03 -0000
Subject: [Ocfs2-devel] [PATCH 07/17] vfs: Introduce new helpers for
	syncing after writing to O_SYNC file or IS_SYNC inode
In-Reply-To: <20090830163551.GA7129@shareable.org>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
	<1250875447-15622-8-git-send-email-jack@suse.cz>
	<20090827173540.GA19115@infradead.org>
	<20090830163551.GA7129@shareable.org>
Message-ID: <20090830163917.GA23955@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jamie Lokier <jamie@shareable.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, hch@lst.de, linux-fsdevel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Felix Blyakher <felixb@sgi.com>, xfs@oss.sgi.com, Anton Altaparmakov <aia21@cantab.net>, linux-ntfs-dev@lists.sourceforge.net, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-ext4@vger.kernel.org, tytso@mit.edu

On Sun, Aug 30, 2009 at 05:35:51PM +0100, Jamie Lokier wrote:
> I like that.  It looks really clear and self-documenting, if
> vfs_fsync_range does what it sounds like, which is a nice change.
> 
> If I've guessed right what that code does, proper O_RSYNC will be easy:
> 
> int generic_sync_before_read(struct file *file, loff_t pos, loff_t count)
> {
> 	int is_sync = ((file->f_flags & O_SYNC)
> 		       || IS_SYNC(file->f_mapping->host));
> 	int is_dsync = is_sync || (file->f_flags & O_DSYNC);
> 
> 	if (!is_dsync || !(file->f_flags & O_RSYNC))
> 		return 0;
> 	return vfs_fsync_range(file, file->f_ath.denty, pos,
> 			       pos + count - 1, is_sync);
> }

Yes. something like this.

> (By the way, did I mention Irix has range-fsync and range-fdatasync
> system calls too :-) (actually fcntls))

Linux has sync_file_range which currently is a perfect way to lose your
synced' data, but with two more flags and calls to ->fsync we could
turn it into range-fsync/fdatasync.  I'm not sure if that's a good
idea or if we should just add a sys_fdatasync_rage systems call.

I don't quite see the point of a range-fsync, but it could be easily
implemented as a flag.
