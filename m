From: Jan Kara <jack@suse.cz>
Date: Thu, 20 Aug 2009 14:31:37 +0200
Subject: [Ocfs2-devel] [PATCH 02/17] vfs: Export
	__generic_file_aio_write() and add	some comments
In-Reply-To: <20090819202208.GA14113@ioremap.net>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
	<1250697884-22288-3-git-send-email-jack@suse.cz>
	<20090819202208.GA14113@ioremap.net>
Message-ID: <20090820123137.GE16486@duck.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, hch@infradead.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

On Thu 20-08-09 00:22:08, Evgeniy Polyakov wrote:
> Hi.
> 
> On Wed, Aug 19, 2009 at 06:04:29PM +0200, Jan Kara (jack at suse.cz) wrote:
> > Rename __generic_file_aio_write_nolock() to __generic_file_aio_write(), add
> > comments to write helpers explaining how they should be used and export
> > __generic_file_aio_write() since it will be used by some filesystems.
> 
> Looks good to me. And comments are definitely good.
> Ack.
  Thanks for the review. BTW: I've CCed you mainly due to pohmelfs changes.
Will you have time to look at them?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
