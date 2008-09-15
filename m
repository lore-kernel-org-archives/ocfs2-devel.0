From: Christoph Hellwig <hch@infradead.org>
Date: Mon, 15 Sep 2008 10:42:30 -0400
Subject: [Ocfs2-devel] [PATCH] jbd2: Create proc entry
	with	bdevname+i_ino.
In-Reply-To: <20080915011042.GA29193@mail.oracle.com>
References: <20080908233114.GD20100@mail.oracle.com>
	<20080914084003.GP4563@wotan.suse.de>
	<20080914090306.GF30537@mit.edu>
	<20080914160635.GA31958@infradead.org>
	<20080915011042.GA29193@mail.oracle.com>
Message-ID: <20080915144230.GA21089@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@MIT.EDU>, Mark Fasheh <mfasheh@suse.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Sun, Sep 14, 2008 at 06:10:42PM -0700, Joel Becker wrote:
> Christoph,
> 	Not sure what you mean here.  Do you mean switching over
> wholesale without the JBD compat config option?  We're currently
> tracking a spinlock deadlock in JBD2, so I don't know if we're ready for
> that.
> 	If you don't get this, I'll try to track you down tomorrow.

Sorry, not related to jbd2 in ocfs2, but the bdevname bits in this
thread.  I saw Ted posted another patch later that basically does the
same for the journal dev as the VFS does for sb->s_id so this is okay.
I still think we should do the / substitution in get_sb_bdev, too and
will send a separate patch for it.
