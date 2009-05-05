From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 5 May 2009 00:16:09 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505010703.GA12731@shareable.org>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
Message-ID: <20090505071608.GB10258@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jamie Lokier <jamie@shareable.org>
Cc: linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Tue, May 05, 2009 at 02:07:03AM +0100, Jamie Lokier wrote:
> Joel Becker wrote:
> > +All file attributes and extended attributes of the new file must
> > +identical to the source file with the following exceptions:
> 
> reflink() sounds useful already, but is there a compelling reason why
> both files must have the same attributes, and changing attributes will
> break the COW?

	Yeah, because without it you can't use it for snapshotting.
That's where the original design came from - inode snapshots.  The big
thing that excited me was that defining reflink() as I did, instead of
a more specific snapshot call, allows all sorts of generic uses (some of
which you outline below).
	If reflink() creates a snapshot, you can then break it to make
things a little different.  But if it changes things, you can never
change them back.

> Being able to have different attributes would allow:
> 
>    - reflink() to be used for fast space-efficient copying, i.e. an
>      optimisation to "cp", "git checkout" and things like that.

	It can right now, just not of other people's files.  Actually,
the only real difficult with doing it to other people's files is quota.
But I can't come up with a way to prevent quota DoS.
	Here's another fun trick.  Overwriting rsync, instead of copying
blocks from the already-existing source could reflink the source to the
.temporary, then only write the changed blocks.  And since you own both
files, it just works.  If you're overwriting someone else's file?  The
old copy behavior is fine.

>    - reflink() to be used for merging files with identical contents
>      (something I find surprisingly often on my disks).
> 
>    - reflink() to be used for merging files from different
>      cgroup-style VMs in particular.

	While it would be great to have a way to do this, reflink() is
not the way.  It's really simple to understand with its link-like
semantic, and I see no point in making it a seven-different-operation
kitchen sink call.

> Requiring all attributes except nlink and ino to be identical makes
> reflink() unsuitable for transparently doing those things, except in
> cases where they happen to have the same attributes anyway.

	We've had a lot of fun thinking up many uses for reflink(), and
almost all of them are within the context of one's own files.

> I'm thinking particularly of file permissions, owner/group and atime.

	People do cp -p all the time.  I don't see how keeping those
things the same will break anything.  It's a new call, not an existing
semantic.

> Since each reflink has its own nlink and ino, I'm wondering why the
> other attributes cannot also be separate.  (I realise extended
> attributes complicate the picture and it's desirable to share them,
> especially if they are large).

	The biggest reason is snapshotting.  The second biggest reason
is a simple to understand call.  "Everything is identical except those
things that *have* to be different".

> But is there an efficient way for reflink-aware applications to detect
> these files have the same contents, other than reading the contents
> twice and comparing?  Occasionally that would be good.  E.g. It would
> be nice if "diff -r" could be patched to do that.

	I would think FIEMAP would tell you what you want to know,
wouldn't it?

> > +- The ctime of the source file only changes if the source's metadata
> > +  must be changed to accommodate the copy-on-write linkage.  The ctime of
> > +  the new file is set to represent its creation.
> 
> What change to the source metadata would require ctime to change?

	ocfs2 flags all extents in the source file with a "this is now
shared, go check the reference count before writing" flag if they don't
have it already.  I'd call that a metadata update.

> > +- The link count of the source file is unchanged, and the link count of
> > +  the new file is one.
> 
> Can you hard link to the source file and the reflink afterwards,
> incrementing the reflink's link count?  (I presume yes).  Can you
> reflink to both of them too?

	Yes, absolutely.  Once reflinked, they look like two separate
POSIX files.

Joel

-- 

"Depend on the rabbit's foot if you will, but remember, it didn't
 help the rabbit."
	- R. E. Shay

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
