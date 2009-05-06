From: Theodore Tso <tytso@mit.edu>
Date: Wed, 6 May 2009 03:15:31 -0400
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2)
	system	call.
In-Reply-To: <20090505213206.GM7835@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505080936.GG3209@webber.adilger.int>
	<20090505165628.GC7835@mail.oracle.com>
	<20090505212417.GO3209@webber.adilger.int>
	<20090505213206.GM7835@mail.oracle.com>
Message-ID: <20090506071531.GB6976@mit.edu>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Dilger <adilger@sun.com>, Jamie Lokier <jamie@shareable.org>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Tue, May 05, 2009 at 02:32:06PM -0700, Joel Becker wrote:
> 	The same as what?  If you reflink your own file, it preserves
> the security context of the original or it appears with the default
> security context of yourself?  They are not the same.  "Treat it like
> link(2)" argues for the former - which precludes changing ownership.
> That's what reflink is designed to do.  "Treat it like cp" is a
> different behavior.

The reason why I don't like the default to be "preserve the inode
ownership" is because it's *not* just like link(2).  If it were just
like link(2), the inode number would also be preserved.  If the inode
number is changing, then it arguably is ***much*** more like a copy.
And a copy operation also has many useful properties.

      	   	     	      	   - Ted
