From: Andreas Dilger <adilger@sun.com>
Date: Tue, 05 May 2009 15:24:17 -0600
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505165628.GC7835@mail.oracle.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505080936.GG3209@webber.adilger.int>
	<20090505165628.GC7835@mail.oracle.com>
Message-ID: <20090505212417.GO3209@webber.adilger.int>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jamie Lokier <jamie@shareable.org>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On May 05, 2009  09:56 -0700, Joel Becker wrote:
> On Tue, May 05, 2009 at 02:09:36AM -0600, Andreas Dilger wrote:
> > If the reflink caller is always charged for the full space used (as if
> > it were a real copy) by virtue of the user doing the reflink() owning the
> > new inode.  Doing anything else seems broken.  If the owner of the file
> > wasn't charged for the reflink's quota then if the reflink inode was
> > chowned the new owner would be charged for the new file, but the quota
> > code would have to special case the decrement of EACH of the reflink's
> > blocks because otherwise the original owner might "release" quota that
> > it was never originally charged.
> 
>  If the caller is creating an inode in someone else's name, then
> who do you charge for the quota?

IMHO, it shouldn't be possible to create an inode in someone else's
name (CAP_* excluded), just like it isn't possible to create a new
file in someone elses name.  The caller of reflink() should be the
one creating the file, hence the owner of the file, and the owner of
the quota.

> If you charge the caller, how do you know to decrement the caller's
> quota when the actual owner does truncate, given that the inode has
> no knowledge of the caller anymore.

No, if the owner of the inode (== caller) is charged the quota then
when the inode is truncated (regardless of who does the truncate)
the quota will just work correctly.

> 	You've hit the nail on the head - without backrefs for each
> refcounted hunk, you can't figure out who it owns it from a quota
> perspective.  And that's just a non-starter to try and maintain.

No, I don't think my proposal is _more_ complex than the original.
It is actually _less_ complex, because the fact that this is a reflink
and not a complete file copy is a purely internal detail of the filesystem
and is not exposed outside the filesystem.  The fact that a reflink
consumes less space and is faster than a real copy is an implementation
detail, not really any different than if the file were compressed by
the filesystem internally.

> > > 	Here's another fun trick.  Overwriting rsync, instead of copying
> > > blocks from the already-existing source could reflink the source to the
> > > .temporary, then only write the changed blocks.  And since you own both
> > > files, it just works.  If you're overwriting someone else's file?  The
> > > old copy behavior is fine.
> > 
> > Well, "fine" as in it works, but if there are only a few changed blocks,
> > and the old copy is now part of a snapshot (so it won't be released when
> > rsync is finished) the space consumption has doubled instead of just
> > using a few extra blocks.
> 
> 	No, because the last thing rsync will do is rename(.temporary,
> source).  All the references from the source will be decremented, and
> any blocks only owned by the source will be freed.  Space usage is
> identical before and after, like a copying rsync, but there is less
> space used and less I/O done during the rsync process.

What I was objecting to is "when overwriting someone elses file, the old
copy behaviour is fine".  If we are implementing a copy-on-write API,
why hamstring it to not work in the expected manner by a normal "cp"?

> > Is there anything about changing the owner/group of the new inode during
> > reflink that makes the implementation more complex?  If the process doing
> > the reflink is the same as the file owner then the semantics are unchanged
> > from what you have proposed.
> 
> 	If you define that 'reflink sets the attributes as if it was a
> new file', then you should be creating the file with a new security
> context, not with the security context from the existing inode.  And
> then you can't really snapshot.
> 	A mixed behavior, like "if you own it, I'll preserve the entire
> security context, but if not I will treat it with a new context" is
> confusing at best.

I don't find it confusing.  The security context would be inherited from
the creating process, just like creating a new file would.  If it is the
same user as the file owner then the security context will be the same.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
