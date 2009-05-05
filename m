From: jim owens <jowens@hp.com>
Date: Tue, 05 May 2009 16:48:52 -0400
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505160313.GF31100@shareable.org>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505130114.GD17486@mit.edu>
	<20090505131907.GF25328@shareable.org>
	<1241530798.7244.65.camel@think.oraclecorp.com>
	<20090505153629.GB31100@shareable.org>
	<1241538102.7244.72.camel@think.oraclecorp.com>
	<20090505160313.GF31100@shareable.org>
Message-ID: <4A00A634.4020008@hp.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: joel.becker@oracle.com
Cc: Jamie Lokier <jamie@shareable.org>, Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

Not surprising that the discussion is all over the place
as far as what this should do.  Whether is is better to
implement one do many things syscall or several different
syscalls for different features can be debated after we
set some rules.  Going back to Joel's patch, I think the
first rules we need agreement on are:

1) is only for filesystems with COW operation,
    if the fs does not support COW it returns ENOSYS.

    the rational is that while we could allow it to
    be a copyfile, it would not save space so "cp -a".

2) is only for regular files, all others return EPERM

    *note* as-coded the patch only traps S_ISDIR, but
    other file types could be a problem on some fs and
    I don't see any value in supporting more than regular
    files unless we support directory COW and then we are
    really jumping into the swamp.

3) the granularity of the COW (1-byte write may cause
    1-block up through whole file copy) is fs-dependent.

4) post-reflink changes done to data or attributes
    in either the original or new file are independent.

next rules if we assume reflink(2) matches Joel's
manpage and call arguments and any other features are
a different api definition:

5) you must be the file owner or have CAP_FCHOWN

    because...

6) all non-time file attributes (owner, security, etc),
    atime, and mtime match the original file.  ctime is
    when the reflink was created.

but the hard part is the quota accounting rule:

7) pre-charge all quotas so a reflink double-counts inodes
    and blocks against the original owner/group

    pro - easiest, does not allow owner to bypass limits,
          quota utilities just work

    con - admin snapshot can trip user quota-limit failures,
          du/df will wildly disagree on space used

so is that what we want or do we want to just say the
behavior is fs-specific with respect to quotas.

jim
