From: Jonathan Corbet <corbet@lwn.net>
Date: Tue, 19 May 2009 13:41:33 -0600
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4.
In-Reply-To: <20090519193244.GB25521@mail.oracle.com>
References: <20090511204011.GB30293@mail.oracle.com> <4A0B96C6.40702@mit.edu>
	<1242324765.21772.95.camel@localhost.localdomain>
	<20090514220029.GB30410@mail.oracle.com>
	<1242388905.29973.17.camel@localhost.localdomain>
	<20090515152212.GA31454@mail.oracle.com>
	<1242402925.29973.163.camel@localhost.localdomain>
	<20090515164209.GD31454@mail.oracle.com>
	<20090515205335.GB25787@mail.oracle.com>
	<20090519132057.419b9de0@bike.lwn.net>
	<20090519193244.GB25521@mail.oracle.com>
Message-ID: <20090519134133.6012b783@bike.lwn.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Andy Lutomirski <luto@mit.edu>, jim owens <jowens@hp.com>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, mtk.manpages@gm.us.oracle.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, 19 May 2009 12:32:44 -0700
Joel Becker <Joel.Becker@oracle.com> wrote:

> 	I considered that, but really a process specifying
> REFLINK_ATTR_ALL wants a complete snapshot.  So if we add things to our
> inodes later, and then you have an old program asking for "a complete
> snapshot", it won't get it.  It'll get a partial snapshot, missing the
> things we added later.
> 	Conversely, a newer program that knows about the new things will
> get an error on an older kernel when it asks for the complete snapshot.

Yep, that's why I'd suggested carving out a set of bits rather larger
than the ones specified now.  That would allow any future flags to be
included in the REFLINK_ATTR_ALL "space" if that seemed like the right
thing to do.  It would be forward and backward compatible.

Anything added outside that bit range would, presumably, be a more
significant change which should not carry forward or backward
automatically.

> 	You'll note I called this 'preserve', not 'flags'.  It's not a
> set of behavioral flags, it's a mask of attributes to preserve.

Understood, but that may not stop somebody else from trying to extend
the API in different directions in the future.  It seems like a way to
make life easier for that person when the time comes.

Just a thought, anyway; not something I'd make a fuss about.

jon
