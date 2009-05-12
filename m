From: Jamie Lokier <jamie@shareable.org>
Date: Tue, 12 May 2009 21:11:12 +0100
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <4A09CFFF.20707@hp.com>
References: <20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505080936.GG3209@webber.adilger.int>
	<20090505165628.GC7835@mail.oracle.com>
	<20090505212417.GO3209@webber.adilger.int>
	<20090505213206.GM7835@mail.oracle.com>
	<20090506071531.GB6976@mit.edu> <4A019DA9.4050700@hp.com>
	<20090512191129.GA10436@shareable.org> <4A09CFFF.20707@hp.com>
Message-ID: <20090512201112.GE10436@shareable.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jim owens <jowens@hp.com>
Cc: Theodore Tso <tytso@mit.edu>, joel.becker@oracle.com, Andreas Dilger <adilger@sun.com>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

jim owens wrote:
> >One last annoyance.  If you're making a new file, then like open() you
> >need another argument, which is the new file's mode which is combined
> >with umask.
> 
> But that only works for minimal traditional permissions.  If you
> want to adjust ACL or MAC, you need to do something else anyway,
> so is it really worth having the old-style mode parameter?

You have a point, and mode+umask is sort of ugly, but:

ACLs and MACs have are intentionally designed so that in 99.9% of
cases, there is no need to do anything else after open(), even in
programs that use different mode arguments for security and don't know
anything about non-traditional permissions.  So very few apps need to
do anything else afterwards.  The ACL/MAC defaults have been carefully
designed to have the right security properties, and people writing
security policies understand how that works.

The most often used mode parameters are almost certainly 0666 meaning
"use what umask says", and 0600 meaning "most restricted useful
permissions" for a new file.

If you want to create a file with restricted permissions without
altering umask, which isn't safe in a threaded program, you must _not_
use 0666 _and then_ narrow the permissions - it's important that the
initial permissions are <= the final ones that you need.

So without the parameter, what's the sane default?

For typical cowlink uses it should be equivalent to open(...,0666) as
you don't want to umask+chmod afterwards.  I wouldn't be surprised if
umask+chmod afterwards gave different ACL/MAC results.

But if you need restricted permission on the file afterwards, since
it's not safe to start wide and then narrow, 0666 is not a suitable
default.

You could say "just change the umask!" but that is bad in a threaded
program, unfortunately.  (Imho they should have made umask
thread-specific; oh well.  In fact you emulate per-thread umask by
adjusting the mode argument in some environments :-)

The mode argument, though ugly, is@least well understood and
security policies (inside apps and outside) do the right thing with it.

-- Jamie
