From: Jamie Lokier <jamie@shareable.org>
Date: Tue, 12 May 2009 20:30:37 +0100
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <4A01CDD0.6090102@hp.com>
References: <20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505080936.GG3209@webber.adilger.int>
	<20090505165628.GC7835@mail.oracle.com>
	<20090505212417.GO3209@webber.adilger.int>
	<20090505213206.GM7835@mail.oracle.com>
	<20090506071531.GB6976@mit.edu> <4A019DA9.4050700@hp.com>
	<4A019F21.2020907@hp.com> <4A01CDD0.6090102@hp.com>
Message-ID: <20090512193037.GC10436@shareable.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jim owens <jowens@hp.com>
Cc: Theodore Tso <tytso@mit.edu>, joel.becker@oracle.com, Andreas Dilger <adilger@sun.com>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

jim owens wrote:
> du rules

In general, hard :-)

See the difficulties reporting process memory usage given shared
libraries for how tricky it gets.

Imho, the simplest is for du to report how much space it would take if
all the files were fully unCOWed, either by being modified or copied
to another filesystem.  In other words, just return the data blocks
assigned to a file as usual; the COW difference is the same block can
be assigned to more than one file.  Sometimes knowing the unCOWed
space would even be useful.

Of course knowing the COWed space is also useful.  (Both together
would give you a nice feel for how much space COW is saving.)  I
suspect that would need changes to du to give useful answers (and
similar changes to "Disk Usage Analyzer" if you like that tool).

du detects hard links by i_nlink!=1 and inode number, and merges the
accounting.  For partially shared files, I'm not sure how best to get
the right information out.  FIEMAP is inherently a lot slower than
stat() because it can do much more disk access, and it might not
always work (depending on how data is represented on disk), and it
might not always be permitted.  Worse, there's no i_nlink!=1
equivalent to decide when FIEMAP does not need to be called.

-- Jamie
