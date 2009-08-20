From: Jan Kara <jack@suse.cz>
Date: Thu, 20 Aug 2009 15:52:45 +0200
Subject: [Ocfs2-devel] [PATCH 02/17] vfs: Export
	__generic_file_aio_write() and add	some comments
In-Reply-To: <20090820133028.GA28420@ioremap.net>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
	<1250697884-22288-3-git-send-email-jack@suse.cz>
	<20090819202208.GA14113@ioremap.net>
	<20090820123137.GE16486@duck.novell.com>
	<20090820133028.GA28420@ioremap.net>
Message-ID: <20090820135245.GG16486@duck.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, hch@infradead.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

On Thu 20-08-09 17:30:28, Evgeniy Polyakov wrote:
> On Thu, Aug 20, 2009 at 02:31:37PM +0200, Jan Kara (jack at suse.cz) wrote:
> >   Thanks for the review. BTW: I've CCed you mainly due to pohmelfs changes.
> > Will you have time to look at them?
> 
> The one where you replaced one name with another? :)
> Yes, I did.
  Well, there were two patches. Both were similarly simple but there could
be some subtleties I've missed :). So can I add your Acked-by also to those
two pohmelfs patches?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
