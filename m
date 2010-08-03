From: Ted Ts'o <tytso@mit.edu>
Date: Tue, 3 Aug 2010 18:57:47 -0400
Subject: [Ocfs2-devel] [PATCH, RFC 0/3] *** SUBJECT HERE ***
In-Reply-To: <20100803211916.GB15416@mail.oracle.com>
References: <1280851315-9167-1-git-send-email-tytso@mit.edu>
	<20100803190703.GA15416@mail.oracle.com>
	<20100803200755.GD9453@thunk.org>
	<20100803211916.GB15416@mail.oracle.com>
Message-ID: <20100803225747.GG9453@thunk.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Keith Maanthey <kmannth@us.ibm.com>, John Stultz <johnstul@us.ibm.com>, Eric Whitney <eric.whitney@hp.com>

On Tue, Aug 03, 2010 at 02:19:16PM -0700, Joel Becker wrote:
> On Tue, Aug 03, 2010 at 04:07:55PM -0400, Ted Ts'o wrote:
> > If you are set up to do some performance measurements on OCFS2, I'd
> > appreciate if you could give it a try and let me know how the patches
> > fare on OCFS2.
> 
> 	We're lining up a 16-way box here.  Do you have a happy dbench
> command line or similar that you would like to see run?

The problem with dbench is that the core VFS can end up being the
bottleneck.  OTOH, it's very easy to run.  What would be great if you
could try using the Flexible File System Benchmark (FFSB), which is
what Eric and Steve used:

     http://free.linux.hp.com/~enw/ext4/2.6.34/
     http://btrfs.boxacle.net/

It's a bit more work to set it up, though.

							- Ted
