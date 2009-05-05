From: jim owens <jowens@hp.com>
Date: Tue, 05 May 2009 19:08:07 -0400
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505223016.GF7574@shareable.org>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505130114.GD17486@mit.edu>
	<20090505170058.GD7835@mail.oracle.com>
	<20090505223016.GF7574@shareable.org>
Message-ID: <4A00C6D7.9040308@hp.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jamie Lokier <jamie@shareable.org>, joel.becker@oracle.com
Cc: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

Jamie Lokier wrote:
> But assuming it stays shared until you modify the actual data, could
> the documentation make this important fact a bit more prominent:

>     Opening a file, reading it, read-only or private mappings, and
>     simple attribute updates (chown, chmod, futimes, as well as
>     automatic atime updates) will not trigger copy-on-write and will
>     not return ENOSPC errors.

almost... more like:

     automatic atime updates) will not trigger file data copy-on-write
     and will not return ENOSPC errors unless the filesytem would have
     returned ENOSPC if the file had no reflink.

filesystems such as btrfs that COW metadata changes can
generate ENOSPC on any attribute update!

jim
