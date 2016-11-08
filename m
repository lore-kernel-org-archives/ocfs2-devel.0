From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Tue, 8 Nov 2016 11:47:48 -0800
Subject: [Ocfs2-devel] Announcing btrfs-dedupe
In-Reply-To: <CAGe7X7m-rPmGxk3DXuo6Vo5qAQwRhNFEKyRZzYxP2iyy1mGrSw@mail.gmail.com>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
	<20161107140200.GM12522@suse.cz>
	<CAGe7X7n=xkveD4TS2cyfXx5-hydOCHTh=tjDK54h8HWpnK5NqQ@mail.gmail.com>
	<20161107205409.GA20325@angband.pl>
	<20161108021722.GA16801@birch.djwong.org>
	<CAGe7X7m-rPmGxk3DXuo6Vo5qAQwRhNFEKyRZzYxP2iyy1mGrSw@mail.gmail.com>
Message-ID: <20161108194748.GC16801@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark@fasheh.com>
Cc: Adam Borowski <kilobyte@angband.pl>, dsterba@suse.cz, James Pharaoh <james@wellbehavedsoftware.com>, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, Nov 08, 2016 at 10:59:56AM -0800, Mark Fasheh wrote:
> On Mon, Nov 7, 2016 at 6:17 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > On Mon, Nov 07, 2016 at 09:54:09PM +0100, Adam Borowski wrote:
> >> Mark has already included XFS in documentation of duperemove, all that looks
> >> amiss is btrfs-extent-same having an obsolete name.  But then, I never did
> >> any non-superficial tests on XFS, beyond "seems to work".
> 
> I'd actually be ok dropping btrfs-extent-same completely at this point
> but I'm concerned that it would leave some users behind.
> 
> 
> > /me wonders if ocfs2 will ever catch up to the reflink/dedupe party. ;)
> 
> Hey, Ocfs2 started the reflink party! But yeah it's fallen behind
> since then with respect to cow and dedupe. More importantly though I'd
> like to see some extra extent tracking in there like XFS did with the
> reflink b+tree.

Perhaps this should move to the ocfs2 list, but...

...as I understand ocfs2, each inode can point to the head of a refcount
tree that maintains refcounts for all the physical blocks that are
mapped by any of the files that share that refcount tree.  It wouldn't
be difficult to hook up this existing refcount structure to the reflink
and dedupe vfs ioctls, with the huge caveat that both inodes will end up
belonging to the same refcount tree (or the call fails).  This might not
be such a huge issue for reflink since we're generally only using it
during a file copy anyway, but for dedupe this could have disastrous
consequences if someone does an fs-wide dedupe and every file in the fs
ends up with the same refcount tree.

So I guess you could give each block group its own refcount tree or
something so that all the writes in the fs don't end up contending for a
single data structure.

--D

>    --Mark
> 
> -- 
> "When the going gets weird, the weird turn pro."
> Hunter S. Thompson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
