From: Jan Kara <jack@suse.cz>
Date: Thu, 20 Aug 2009 14:04:36 +0200
Subject: [Ocfs2-devel] [PATCH 02/17] vfs: Export
	__generic_file_aio_write() and add	some comments
In-Reply-To: <20090819161145.GB6150@infradead.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
	<1250697884-22288-3-git-send-email-jack@suse.cz>
	<20090819161145.GB6150@infradead.org>
Message-ID: <20090820120436.GB16486@duck.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, Evgeniy Polyakov <zbr@ioremap.net>, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

On Wed 19-08-09 12:11:45, Christoph Hellwig wrote:
> On Wed, Aug 19, 2009 at 06:04:29PM +0200, Jan Kara wrote:
> > Rename __generic_file_aio_write_nolock() to __generic_file_aio_write(), add
> > comments to write helpers explaining how they should be used and export
> > __generic_file_aio_write() since it will be used by some filesystems.
> 
> The renaming and commenting looks good to me, and the export is fine
> with me given that we'll actually use it later one.
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Can we maybe get rid of generic_file_aio_write_nolock after you patch
> series?
  In principle we could. It's just that block devices don't need i_mutex
for serializing writes so I found it dumb to serialize writes to the block
device needlessly. But we could move generic_file_aio_write_nolock to
blockdev.c and name it like blockdev_aio_write() since noone else uses
it after my series. I guess I'll do that.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
