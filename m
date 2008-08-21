From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 21 Aug 2008 16:29:20 -0700
Subject: [Ocfs2-devel] [PATCH 07/10] ocfs2: Determine an extent
	tree's	max_leaf_clusters in an et_op.
In-Reply-To: <20080821222504.GR4563@wotan.suse.de>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
	<1219286905-28104-8-git-send-email-joel.becker@oracle.com>
	<20080821222504.GR4563@wotan.suse.de>
Message-ID: <20080821232920.GM14096@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 21, 2008 at 03:25:04PM -0700, Mark Fasheh wrote:
> On Wed, Aug 20, 2008 at 07:48:22PM -0700, Joel Becker wrote:
> > --- a/fs/ocfs2/alloc.c
> > +++ b/fs/ocfs2/alloc.c
> > @@ -76,6 +76,8 @@ struct ocfs2_extent_tree_operations {
> >  	/* These are internal to ocfs2_extent_tree and don't have
> >  	 * accessor functions */
> >  	void (*eo_fill_root_el)(struct ocfs2_extent_tree *et);
> 
> A comment here, noting that it's optional and what the expected behavior is
> if it isn't set would be nice. Otherwise, this patch looks great.

	eo_fill_root_el() is required, but really I think the entire set
of ops should be commented.  I only didn't because the initial set
wasn't.  I was wrong, and probably should have even specified the
comments in the original review of Tao's patches.

Joel

-- 

"I'm drifting and drifting
 Just like a ship out on the sea.
 Cause I ain't got nobody, baby,
 In this world to care for me."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
