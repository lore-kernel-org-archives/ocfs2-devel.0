From: Joel Becker <Joel.Becker@oracle.com>
Date: Sun, 14 Sep 2008 18:10:42 -0700
Subject: [Ocfs2-devel] [PATCH] jbd2: Create proc entry
	with	bdevname+i_ino.
In-Reply-To: <20080914160635.GA31958@infradead.org>
References: <20080908233114.GD20100@mail.oracle.com>
	<20080914084003.GP4563@wotan.suse.de>
	<20080914090306.GF30537@mit.edu>
	<20080914160635.GA31958@infradead.org>
Message-ID: <20080915011042.GA29193@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: Mark Fasheh <mfasheh@suse.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@MIT.EDU>, ocfs2-devel@oss.oracle.com

On Sun, Sep 14, 2008 at 12:06:35PM -0400, Christoph Hellwig wrote:
> On Sun, Sep 14, 2008 at 05:03:06AM -0400, Theodore Tso wrote:
> > On Sun, Sep 14, 2008 at 01:40:03AM -0700, Mark Fasheh wrote:
> > > On Mon, Sep 08, 2008 at 04:31:14PM -0700, Joel Becker wrote:
> > > > jbd2 currently creates statistics files for each loaded journal in
> > > > /proc/fs/jbd2/<bdevname>.  ocfs2 loads multiple journals when recovering
> > > > other nodes, and the multiple journals on a given bdev collide in the
> > > > proc namespace.
> > > 
> > > Did this patch ever get reviewied? We'd really like it in so that Ocfs2 can
> > > use JBD2...
> > 
> > Thanks for pinging me; it fell through the cracks.  I'll make sure it
> > gets put into the queue for merging at the next merge window....
> 
> Could you please do it the proper way as describe in my reply to the
> thread?

Christoph,
	Not sure what you mean here.  Do you mean switching over
wholesale without the JBD compat config option?  We're currently
tracking a spinlock deadlock in JBD2, so I don't know if we're ready for
that.
	If you don't get this, I'll try to track you down tomorrow.

Joel

-- 

"You look in her eyes, the music begins to play.
 Hopeless romantics, here we go again."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
