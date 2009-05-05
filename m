From: Jamie Lokier <jamie@shareable.org>
Date: Tue, 5 May 2009 23:36:00 +0100
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505172949.GG17486@mit.edu>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505130114.GD17486@mit.edu>
	<20090505170058.GD7835@mail.oracle.com>
	<20090505172949.GG17486@mit.edu>
Message-ID: <20090505223600.GG7574@shareable.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

Theodore Tso wrote:
 But in that case, if in every user-visible sense of the
> word, it's equivalent to a file copy --- which is to say, it gets a
> new inode number, and, then why not make it work *exactly* like a file
> copy, which is to say make the ownership be the user who asked for the
> reflink to be created?  That way /bin/cp could potentially use
> reflinks, and aside from the fact that a cp -r of an existing
> directory hierarchy takes no extra disk space and runs *much* faster,
> a reflink acts exactly like a file copy.  The semantics are easy to
> describe, we don't need CAP_FOWNER nonsense, it becomes much easier to
> deal with the semantics vis-a-vis quota, etc.

reflink() seems to be designed to copy a file _and_ clone the file's
attributes exactly, and to do it all atomically.

So how about relaxing a bit and, since reflinkat() takes flags, giving
it a flag to make cloning the attributes optional.

I imagine there's little implementation difference between cloning the
attributes and giving it new file attributes, and both behaviours are
useful for different things.

-- Jamie
