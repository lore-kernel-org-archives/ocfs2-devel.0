From: jim owens <jowens@hp.com>
Date: Wed, 06 May 2009 10:24:41 -0400
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
 call.
In-Reply-To: <20090506071531.GB6976@mit.edu>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505080936.GG3209@webber.adilger.int>
	<20090505165628.GC7835@mail.oracle.com>
	<20090505212417.GO3209@webber.adilger.int>
	<20090505213206.GM7835@mail.oracle.com>
	<20090506071531.GB6976@mit.edu>
Message-ID: <4A019DA9.4050700@hp.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, joel.becker@oracle.com
Cc: Andreas Dilger <adilger@sun.com>, Jamie Lokier <jamie@shareable.org>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

So summarizing the main argument of the day,
there are 2 different functions proposed:

1) "snapfile" - Joel's reflink(2) design.

The definition is good.  It makes writable snapshots
possible, and is security safe with CAP_FOWNER added
as a requirement because CAP_CHOWN is very restricted
in the real world.  Only the owner and admin can reflink.
For the admin to use it in backups, it must be a single
call as Joel said, a point in time of data and attributes.

If the name "reflink" is the problem, call it something else.

2) "cowfilecopy" - Ted's/Jamie's kernel cp.

Again, the definition makes sense.  The security model
is simply "current read access to the file", so anyone
who can read it can make almost-zero-space-consumed copy
of a file.

--- analysis ---

You ask why not use a 2-step "cowfilecopy" and "attrfilecopy"
to do "snapfile"... because that is not an atomic snapshot.

The security and "might not know about it" concerns are bogus:
No extra visibility exists to future updates of the original
file that would not exist without either snapfile or cowfilecopy.
That BOTH point at your old data is no different than if root
or raid was copying every disk block to permanent storage. If
you write it, someone can have it later.

So bottom line... I see no reason (except someone has to document)
why we should not have 2 system calls since there are good uses
and good definitions for both and the code is 99% identical.

jim
