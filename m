From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 5 May 2009 09:56:28 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505080936.GG3209@webber.adilger.int>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505080936.GG3209@webber.adilger.int>
Message-ID: <20090505165628.GC7835@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andreas Dilger <adilger@sun.com>
Cc: linux-fsdevel@vger.kernel.org, Jamie Lokier <jamie@shareable.org>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Tue, May 05, 2009 at 02:09:36AM -0600, Andreas Dilger wrote:
> On May 05, 2009  00:16 -0700, Joel Becker wrote:
> > On Tue, May 05, 2009 at 02:07:03AM +0100, Jamie Lokier wrote:
> > > Being able to have different attributes would allow:
> > > 
> > >    - reflink() to be used for fast space-efficient copying, i.e. an
> > >      optimisation to "cp", "git checkout" and things like that.
> > 
> > 	It can right now, just not of other people's files.  Actually,
> > the only real difficult with doing it to other people's files is quota.
> > But I can't come up with a way to prevent quota DoS.
> 
> If the reflink caller is always charged for the full space used (as if
> it were a real copy) by virtue of the user doing the reflink() owning the
> new inode.  Doing anything else seems broken.  If the owner of the file
> wasn't charged for the reflink's quota then if the reflink inode was
> chowned the new owner would be charged for the new file, but the quota
> code would have to special case the decrement of EACH of the reflink's
> blocks because otherwise the original owner might "release" quota that
> it was never originally charged.

	If the caller is creating an inode in someone else's name, then
who do you charge for the quota?  If you charge the caller, how do you
know to decrement the caller's quota when the actual owner does
truncate, given that the inode has no knowledge of the caller anymore.
	You've hit the nail on the head - without backrefs for each
refcounted hunk, you can't figure out who it owns it from a quota
perspective.  And that's just a non-starter to try and maintain.

> > 	Here's another fun trick.  Overwriting rsync, instead of copying
> > blocks from the already-existing source could reflink the source to the
> > .temporary, then only write the changed blocks.  And since you own both
> > files, it just works.  If you're overwriting someone else's file?  The
> > old copy behavior is fine.
> 
> Well, "fine" as in it works, but if there are only a few changed blocks,
> and the old copy is now part of a snapshot (so it won't be released when
> rsync is finished) the space consumption has doubled instead of just
> using a few extra blocks.

	No, because the last thing rsync will do is rename(.temporary,
source).  All the references from the source will be decremented, and
any blocks only owned by the source will be freed.  Space usage is
identical before and after, like a copying rsync, but there is less
space used and less I/O done during the rsync process.

> Is there anything about changing the owner/group of the new inode during
> reflink that makes the implementation more complex?  If the process doing
> the reflink is the same as the file owner then the semantics are unchanged
> from what you have proposed.

	If you define that 'reflink sets the attributes as if it was a
new file', then you should be creating the file with a new security
context, not with the security context from the existing inode.  And
then you can't really snapshot.
	A mixed behavior, like "if you own it, I'll preserve the entire
security context, but if not I will treat it with a new context" is
confusing at best.

> > > I'm thinking particularly of file permissions, owner/group and atime.
> > 
> > 	People do cp -p all the time.  I don't see how keeping those
> > things the same will break anything.  It's a new call, not an existing
> > semantic.
> 
> Though "cp -p" doesn't keep the owner/group of the original file if you
> are not root.

	Sure, my argument wasn't that we should be exactly like cp -p,
it was that the results of cp -p are understood, so if we look like them
it won't break anything.
	I actually discussed the "cp -p" issue elsewhere.  Yes, we all
understand the caveats of "cp -p".  But it's a actually a combination of
many simple operations.  reflink() is one operation, and trying to give
it confusing and varied semantics seems to clutter it up for no good
reason.

Joel

-- 

"Baby, even the losers
 Get luck sometimes.
 Even the losers
 Keep a little bit of pride."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
