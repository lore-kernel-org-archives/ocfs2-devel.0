From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 5 May 2009 15:21:31 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] fs: Document the reflink(2) system
	call.
In-Reply-To: <20090505221236.GE7574@shareable.org>
References: <20090505130114.GD17486@mit.edu>
	<20090505131907.GF25328@shareable.org>
	<1241530798.7244.65.camel@think.oraclecorp.com>
	<20090505153629.GB31100@shareable.org>
	<1241538102.7244.72.camel@think.oraclecorp.com>
	<20090505160313.GF31100@shareable.org>
	<4A00A634.4020008@hp.com> <20090505215711.GA7574@shareable.org>
	<20090505220459.GN7835@mail.oracle.com>
	<20090505221236.GE7574@shareable.org>
Message-ID: <20090505222131.GO7835@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jamie Lokier <jamie@shareable.org>
Cc: Theodore Tso <tytso@mit.edu>, jmorris@namei.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, jim owens <jowens@hp.com>, Chris Mason <chris.mason@oracle.com>, viro@zeniv.linux.org.uk

On Tue, May 05, 2009 at 11:12:36PM +0100, Jamie Lokier wrote:
> Joel Becker wrote:
> > 	The point-in-time of the snapshot is what's important here.
> 
> Don't we have a slight problem that useful point-in-time snapshots
> really need to snapshot whole directory trees?  Otherwise you get the
> same inter-file inconsistency issues that you get intra-file from old
> fashioned copying.

	Snapshotting whole trees is already doable from things like
btrfs and from whole volumes on your storage.  This is a different
beast.
	Inter-file is a lot easier to handle than intra-file, because
you have control over that part of the process.
	And if your file is actually a disk image, you get snapping of
disks for free :-)

Joel

-- 

"We'd better get back, `cause it'll be dark soon,
 and they mostly come at night.  Mostly."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
