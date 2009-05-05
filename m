From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 5 May 2009 10:05:34 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505131907.GF25328@shareable.org>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<1241331303-23753-2-git-send-email-joel.becker@oracle.com>
	<20090505010703.GA12731@shareable.org>
	<20090505071608.GB10258@mail.oracle.com>
	<20090505130114.GD17486@mit.edu>
	<20090505131907.GF25328@shareable.org>
Message-ID: <20090505170533.GE7835@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jamie Lokier <jamie@shareable.org>
Cc: linux-fsdevel@vger.kernel.org, Theodore Tso <tytso@mit.edu>, jmorris@namei.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Tue, May 05, 2009 at 02:19:07PM +0100, Jamie Lokier wrote:
> There was an attempt at something like that for ext3 a year or two ago.
> Search for "cowlink" if you're interested.

	Yeah, I discussed those with J?rn Engel after my talk at LSF - I
hadn't heard of them before.  cowlinks actually changed the semantic of
link(2).  This does not do that.

> Instead of a circular list, a proposed implementation was to create a
> separate "host" inode on the first reflink, converting the source
> inode to a reflink inode and moving the data block references to the
> new host inode.  Each reflink was simply a reference to the host
> inode, much like your design, and the host inode was only to hold the
> data blocks, with it's i_nlink counting the number of reflinks
> pointing to it.

	Reflinks are not cowlinks.  reflinks are new files (new inodes
in most implementations I expect) that only share the *data extents* in
a CoW fashion.
	Maybe reading the wiki details of the ocfs2 implementation and
so on would be helpful?

[Overview]
http://wiki.us.oracle.com/calpg/OCFS2Reflink
[ocfs2 Implementation]
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/RefcountTrees
[reflink() Itself]
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/ReflinkOperation
[Use Cases]
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/ReflinkUses

Joel

-- 

"Every day I get up and look through the Forbes list of the richest
 people in America. If I'm not there, I go to work."
        - Robert Orben

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
