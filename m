From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 5 May 2009 10:09:56 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505130136.GE25328@shareable.org>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505130136.GE25328@shareable.org>
Message-ID: <20090505170956.GF7835@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jamie Lokier <jamie@shareable.org>
Cc: linux-fsdevel@vger.kernel.org, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Tue, May 05, 2009 at 02:01:36PM +0100, Jamie Lokier wrote:
> Joel Becker wrote:
> > 	Here's another fun trick.  Overwriting rsync, instead of copying
> > blocks from the already-existing source could reflink the source to the
> > .temporary, then only write the changed blocks.  And since you own both
> > files, it just works.  If you're overwriting someone else's file?  The
> > old copy behavior is fine.
> 
> The moment rsync overwrites a single block, the whole reflink file
> will be copied by the filesystem, and then rsync will overwrite other
> blocks in the copy.

	This is not cowlink.  It's not a "CoW the whole thing when I
touch one block".  It's a new file (new inode for most implementations)
that just shares the data extents.  So if I write to one block, I only
need to CoW that one block.
	See my other email with the wiki pages.

Joel

-- 

"Maybe the time has drawn the faces I recall.
 But things in this life change very slowly,
 If they ever change at all."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
