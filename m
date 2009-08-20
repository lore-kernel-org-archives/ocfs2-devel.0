From: Evgeniy Polyakov <zbr@ioremap.net>
Date: Thu, 20 Aug 2009 13:58:22 -0000
Subject: [Ocfs2-devel] [PATCH 02/17] vfs: Export
	__generic_file_aio_write() and add some comments
In-Reply-To: <20090820135245.GG16486@duck.novell.com>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
	<1250697884-22288-3-git-send-email-jack@suse.cz>
	<20090819202208.GA14113@ioremap.net>
	<20090820123137.GE16486@duck.novell.com>
	<20090820133028.GA28420@ioremap.net>
	<20090820135245.GG16486@duck.novell.com>
Message-ID: <20090820135818.GA29564@ioremap.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, hch@infradead.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

On Thu, Aug 20, 2009 at 03:52:45PM +0200, Jan Kara (jack at suse.cz) wrote:
>   Well, there were two patches. Both were similarly simple but there could

As of sync behaviour - pohmelfs will follow the usual VFS behaviour, so
if you managed to break this, we still will follow the mainstream :)

> be some subtleties I've missed :). So can I add your Acked-by also to those
> two pohmelfs patches?

Sure.

-- 
	Evgeniy Polyakov
