From: Jamie Lokier <jamie@shareable.org>
Date: Tue, 5 May 2009 22:57:11 +0100
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <4A00A634.4020008@hp.com>
References: <1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505130114.GD17486@mit.edu>
	<20090505131907.GF25328@shareable.org>
	<1241530798.7244.65.camel@think.oraclecorp.com>
	<20090505153629.GB31100@shareable.org>
	<1241538102.7244.72.camel@think.oraclecorp.com>
	<20090505160313.GF31100@shareable.org> <4A00A634.4020008@hp.com>
Message-ID: <20090505215711.GA7574@shareable.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jim owens <jowens@hp.com>
Cc: joel.becker@oracle.com, Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

Joel Becker wrote:
>> > >     If you define that 'reflink sets the attributes as if it was a
>> > > new file', then you should be creating the file with a new security
>> > > context, not with the security context from the existing inode.  And
>> > > then you can't really snapshot.
>> > >     A mixed behavior, like "if you own it, I'll preserve the entire
>> > > security context, but if not I will treat it with a new context" is
>> > > confusing at best.
>> >
>> > I don't find it confusing.  The security context would be inherited from
>> > the creating process, just like creating a new file would.  If it is the
>> > same user as the file owner then the security context will be the same.
>> 
>>         The same as what?  If you reflink your own file, it preserves
>> the security context of the original or it appears with the default
>> security context of yourself?  They are not the same.  "Treat it like
>> link(2)" argues for the former - which precludes changing ownership.
>> That's what reflink is designed to do.  "Treat it like cp" is a
>> different behavior.

jim owens wrote:
> 1) is only for filesystems with COW operation,
>    if the fs does not support COW it returns ENOSYS.
> 
>    the rational is that while we could allow it to
>    be a copyfile, it would not save space so "cp -a".

As Joel explains above, reflink has user-visible semantics that are
different from "cp -a" quite aside from the COW efficiency which can
be seen as an internal fs-dependent speed/space optimisation.

That means you cannot fall back to "cp -a": reflink has semantics
behaviour which "cp -a" cannot always mimic, and won't always mimic
correctly when it tries.

Imho that's because reflink is overcomplicated and tries to do
multiple jobs at once ;-)

> 2) is only for regular files, all others return EPERM
> 
>    *note* as-coded the patch only traps S_ISDIR, but
>    other file types could be a problem on some fs and
>    I don't see any value in supporting more than regular
>    files unless we support directory COW and then we are
>    really jumping into the swamp.

I agree.

> 3) the granularity of the COW (1-byte write may cause
>    1-block up through whole file copy) is fs-dependent.

And yet ENOSYS if the fs cannot implement any COW, and it isn't
possible for userspace to duplicate the semantics by explicit copying?

> 4) post-reflink changes done to data or attributes
>    in either the original or new file are independent.

Hopefully :-)

Do we say anything about attribute changes triggering COW or not, or
leave it fs-dependent?  Given 3) fs-dependent makes sense, but it's
nice to know in advance if { reflink -R old_tree saved_tree; chmod -R
a-w saved_tree } will be as expensive as copying or as cheap as linking.

> next rules if we assume reflink(2) matches Joel's
> manpage and call arguments and any other features are
> a different api definition:
> 
> 5) you must be the file owner or have CAP_FCHOWN
> 
>    because...
> 
> 6) all non-time file attributes (owner, security, etc),
>    atime, and mtime match the original file.  ctime is
>    when the reflink was created.
> 
> but the hard part is the quota accounting rule:
> 
> 7) pre-charge all quotas so a reflink double-counts inodes
>    and blocks against the original owner/group
> 
>    pro - easiest, does not allow owner to bypass limits,
>          quota utilities just work
> 
>    con - admin snapshot can trip user quota-limit failures,
>          du/df will wildly disagree on space used

Another con - reflink is potentially a useful way to save space,
multiple-charging prevents their use when tight on quota.

If a user is tight on their quota and they need lots of snapshots of
their files, e.g. snapshots of work in progress, why should they have
to use hard links with its associated problems (i.e. cannot be
trusted) for their snapshots, instead of reflinks which are ideal?

-- Jamie
