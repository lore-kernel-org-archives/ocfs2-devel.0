From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 4 May 2009 23:55:57 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2)
	system	call.
In-Reply-To: <20090504222327.GH6766@mit.edu>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090503234518.GB17044@mit.edu> <49FE4880.3010208@oracle.com>
	<20090504182552.GF31249@mail.oracle.com>
	<20090504211854.GC25313@mail.oracle.com>
	<20090504222327.GH6766@mit.edu>
Message-ID: <20090505065556.GA10258@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>
Cc: Tao Ma <tao.ma@oracle.com>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Mon, May 04, 2009 at 06:23:27PM -0400, Theodore Tso wrote:
> On Mon, May 04, 2009 at 02:18:54PM -0700, Joel Becker wrote:
> > 	More thinking.  It looks like we'll restrict reflink() to owners
> > or people with CAP_FCHOWN.  This prevents some quota DoS behavior.
> > 	We need to pre-charge all quota.  That means a reflink must be
> > charged the entire size of the file.  So, if I do:
> > 
> >   # dd if=/dev/zero bs=1M count=1 of=foo
> >   # reflink foo bar
> > 
> > I am now charged 2MB of quota, even though foo and bar share the same
> > 1MB of space.
> 
> Yep; but as long as you do this, why do you need CAP_FCHOWN?  

	Because the ownership doesn't change, and thus the person doing
the reflink is effectively setting ownership.

> Suppose Alice has a 1MB file, and Bob creates a reflink to it.  The
> reflink would be owned by Bob, and Bob would be charged the 1MB quota.
> This mirrors exactly what happens if Bob were to make a copy of the
> file, and we want to make the creation of reflink mirror a copy, right?

	It's more a link(2).  The ownership, permissions, and attributes
are identical to the original.

-- 

"Always give your best, never get discouraged, never be petty; always
 remember, others may hate you.  Those who hate you don't win unless
 you hate them.  And then you destroy yourself."
	- Richard M. Nixon

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
