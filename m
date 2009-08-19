From: Evgeniy Polyakov <zbr@ioremap.net>
Date: Wed, 19 Aug 2009 20:22:13 -0000
Subject: [Ocfs2-devel] [PATCH 02/17] vfs: Export
	__generic_file_aio_write() and add some comments
In-Reply-To: <1250697884-22288-3-git-send-email-jack@suse.cz>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
	<1250697884-22288-3-git-send-email-jack@suse.cz>
Message-ID: <20090819202208.GA14113@ioremap.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, hch@infradead.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

Hi.

On Wed, Aug 19, 2009 at 06:04:29PM +0200, Jan Kara (jack at suse.cz) wrote:
> Rename __generic_file_aio_write_nolock() to __generic_file_aio_write(), add
> comments to write helpers explaining how they should be used and export
> __generic_file_aio_write() since it will be used by some filesystems.

Looks good to me. And comments are definitely good.
Ack.

-- 
	Evgeniy Polyakov
