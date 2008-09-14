From: Christoph Hellwig <hch@infradead.org>
Date: Sun, 14 Sep 2008 12:06:35 -0400
Subject: [Ocfs2-devel] [PATCH] jbd2: Create proc entry with
	bdevname+i_ino.
In-Reply-To: <20080914090306.GF30537@mit.edu>
References: <20080908233114.GD20100@mail.oracle.com>
	<20080914084003.GP4563@wotan.suse.de>
	<20080914090306.GF30537@mit.edu>
Message-ID: <20080914160635.GA31958@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@MIT.EDU>
Cc: Mark Fasheh <mfasheh@suse.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, ocfs2-devel@oss.oracle.com, sunil.mushran@oracle.com

On Sun, Sep 14, 2008 at 05:03:06AM -0400, Theodore Tso wrote:
> On Sun, Sep 14, 2008 at 01:40:03AM -0700, Mark Fasheh wrote:
> > On Mon, Sep 08, 2008 at 04:31:14PM -0700, Joel Becker wrote:
> > > jbd2 currently creates statistics files for each loaded journal in
> > > /proc/fs/jbd2/<bdevname>.  ocfs2 loads multiple journals when recovering
> > > other nodes, and the multiple journals on a given bdev collide in the
> > > proc namespace.
> > 
> > Did this patch ever get reviewied? We'd really like it in so that Ocfs2 can
> > use JBD2...
> 
> Thanks for pinging me; it fell through the cracks.  I'll make sure it
> gets put into the queue for merging at the next merge window....

Could you please do it the proper way as describe in my reply to the
thread?
