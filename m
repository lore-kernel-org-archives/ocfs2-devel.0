From: Jamie Lokier <jamie@shareable.org>
Date: Tue, 5 May 2009 16:32:17 +0100
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505142102.GE17486@mit.edu>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505130114.GD17486@mit.edu>
	<20090505131907.GF25328@shareable.org>
	<20090505142102.GE17486@mit.edu>
Message-ID: <20090505153217.GA31100@shareable.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

Theodore Tso wrote:
> 1) If someone other than the owner of a file uses reflink to "make a
> copy" of the file, is it new inode, with the new inode number, owned
> by the original owner (making it look more like a link), or owned by
> the person creating the reflink (making it look more like a copy).
> 
> 2) Does changing the metadata --- atime, user/group ownership, ctime,
> etc., break the COW link and cause a copy?
> 
> (2) could be a per-filesystem implementation detail, but (1) goes to
> the semantics of the how the reflink() system call will work, so I
> think we need to have a common answer which is the same across all
> filesystems.  

I agree on both.

user/group ownership seems to raise the most questions.

Can we settle the hopefully simpler question of ctime, atime, mode changes?

-- Jamie
