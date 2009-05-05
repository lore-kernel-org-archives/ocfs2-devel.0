From: Andreas Dilger <adilger@sun.com>
Date: Tue, 05 May 2009 02:09:36 -0600
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505071608.GB10258@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
Message-ID: <20090505080936.GG3209@webber.adilger.int>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jamie Lokier <jamie@shareable.org>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On May 05, 2009  00:16 -0700, Joel Becker wrote:
> On Tue, May 05, 2009 at 02:07:03AM +0100, Jamie Lokier wrote:
> > Being able to have different attributes would allow:
> > 
> >    - reflink() to be used for fast space-efficient copying, i.e. an
> >      optimisation to "cp", "git checkout" and things like that.
> 
> 	It can right now, just not of other people's files.  Actually,
> the only real difficult with doing it to other people's files is quota.
> But I can't come up with a way to prevent quota DoS.

If the reflink caller is always charged for the full space used (as if
it were a real copy) by virtue of the user doing the reflink() owning the
new inode.  Doing anything else seems broken.  If the owner of the file
wasn't charged for the reflink's quota then if the reflink inode was
chowned the new owner would be charged for the new file, but the quota
code would have to special case the decrement of EACH of the reflink's
blocks because otherwise the original owner might "release" quota that
it was never originally charged.

> 	Here's another fun trick.  Overwriting rsync, instead of copying
> blocks from the already-existing source could reflink the source to the
> .temporary, then only write the changed blocks.  And since you own both
> files, it just works.  If you're overwriting someone else's file?  The
> old copy behavior is fine.

Well, "fine" as in it works, but if there are only a few changed blocks,
and the old copy is now part of a snapshot (so it won't be released when
rsync is finished) the space consumption has doubled instead of just
using a few extra blocks.

> > Requiring all attributes except nlink and ino to be identical makes
> > reflink() unsuitable for transparently doing those things, except in
> > cases where they happen to have the same attributes anyway.
>
>        We've had a lot of fun thinking up many uses for reflink(), and
>	almost all of them are within the context of one's own files.

Is there anything about changing the owner/group of the new inode during
reflink that makes the implementation more complex?  If the process doing
the reflink is the same as the file owner then the semantics are unchanged
from what you have proposed.

> > I'm thinking particularly of file permissions, owner/group and atime.
> 
> 	People do cp -p all the time.  I don't see how keeping those
> things the same will break anything.  It's a new call, not an existing
> semantic.

Though "cp -p" doesn't keep the owner/group of the original file if you
are not root.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
