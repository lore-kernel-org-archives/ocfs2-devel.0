From: Chris Mason <mason@suse.com>
Date: Thu Mar 31 07:44:33 2005
Subject: [Ocfs2-devel] xattr/acl support
In-Reply-To: <20050329193913.GA28010@ca-server1.us.oracle.com>
References: <200503290904.18742.mason@suse.com>
	<200503291219.20281.mason@suse.com>
	<20050329193913.GA28010@ca-server1.us.oracle.com>
Message-ID: <200503310844.30032.mason@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tuesday 29 March 2005 14:39, Joel Becker wrote:
> On Tue, Mar 29, 2005 at 12:19:19PM -0500, Chris Mason wrote:
> > ;) Does the disk format already have all the slots reserved for such a
> > thing? It looks like you've probably got some extra room on the end of
> > the inode, I'm hoping for something that can pack in tiny files directly
> > and perhaps store small acls/xattrs in there.
>
> 	We've not agreed yet on how we want to implement them.  We go
> back and forth.  Could be internal to the inode reserved space for a few
> small xattrs, expanding to a whole cluster for larger ones.  Or it could
> be block-based, copying the code directly from ext3.  We just haven't
> decided yet.

There's a real performance hit moving the common xattrs (especially acls) 
outside the inode.  I'd suggest storing at least some of them internally.

> 	Note that there is no extra room at the "end" of the inode, as
> the extent list fills to the end.  The extra room is in the reserved
> fields.

Ok, thanks.

-chris
