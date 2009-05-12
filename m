From: jim owens <jowens@hp.com>
Date: Tue, 12 May 2009 15:37:35 -0400
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
 call.
In-Reply-To: <20090512191129.GA10436@shareable.org>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505080936.GG3209@webber.adilger.int>
	<20090505165628.GC7835@mail.oracle.com>
	<20090505212417.GO3209@webber.adilger.int>
	<20090505213206.GM7835@mail.oracle.com>
	<20090506071531.GB6976@mit.edu> <4A019DA9.4050700@hp.com>
	<20090512191129.GA10436@shareable.org>
Message-ID: <4A09CFFF.20707@hp.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jamie Lokier <jamie@shareable.org>
Cc: Theodore Tso <tytso@mit.edu>, joel.becker@oracle.com, Andreas Dilger <adilger@sun.com>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

I don't write applications so I won't argue when
what they want does not make sense to me :)

Jamie Lokier wrote:
> 
> One last annoyance.  If you're making a new file, then like open() you
> need another argument, which is the new file's mode which is combined
> with umask.

But that only works for minimal traditional permissions.  If you
want to adjust ACL or MAC, you need to do something else anyway,
so is it really worth having the old-style mode parameter?

jim
