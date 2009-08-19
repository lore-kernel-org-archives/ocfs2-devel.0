From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 19 Aug 2009 12:11:45 -0400
Subject: [Ocfs2-devel] [PATCH 02/17] vfs: Export
	__generic_file_aio_write() and add	some comments
In-Reply-To: <1250697884-22288-3-git-send-email-jack@suse.cz>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
	<1250697884-22288-3-git-send-email-jack@suse.cz>
Message-ID: <20090819161145.GB6150@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, hch@infradead.org, Evgeniy Polyakov <zbr@ioremap.net>, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

On Wed, Aug 19, 2009 at 06:04:29PM +0200, Jan Kara wrote:
> Rename __generic_file_aio_write_nolock() to __generic_file_aio_write(), add
> comments to write helpers explaining how they should be used and export
> __generic_file_aio_write() since it will be used by some filesystems.

The renaming and commenting looks good to me, and the export is fine
with me given that we'll actually use it later one.


Reviewed-by: Christoph Hellwig <hch@lst.de>

Can we maybe get rid of generic_file_aio_write_nolock after you patch
series?
