From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 19 Mar 2010 15:01:16 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Clear undo bits when local alloc
	is freed
In-Reply-To: <20100318215314.GA8122@mail.oracle.com>
References: <20100312023109.GS11402@wotan.suse.de>
	<20100318215314.GA8122@mail.oracle.com>
Message-ID: <20100319220116.GH11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 18, 2010 at 02:53:15PM -0700, Joel Becker wrote:
> On Thu, Mar 11, 2010 at 06:31:09PM -0800, Mark Fasheh wrote:
> > When the local alloc file changes windows, unused bits are freed back to the
> > global bitmap. By defnition, those bits can not be in use by any file. Also,
> > the local alloc will never have been able to allocate those bits if they
> > were part of a previous truncate. Therefore it makes sense that we should
> > clear unused local alloc bits in the undo buffer so that they can be used
> > immediatly.
> > 
> > Signed-off-by: Mark Fasheh <mfasheh@suse.com>
> > ---
> >  fs/ocfs2/alloc.c        |    4 ++--
> >  fs/ocfs2/dir.c          |    2 +-
> >  fs/ocfs2/localalloc.c   |    2 +-
> >  fs/ocfs2/refcounttree.c |    2 +-
> >  fs/ocfs2/suballoc.c     |   44 ++++++++++++++++++++++++++++----------------
> >  fs/ocfs2/suballoc.h     |    5 +++--
> >  fs/ocfs2/xattr.c        |    2 +-
> >  7 files changed, 37 insertions(+), 24 deletions(-)
> > 
> > diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> > index d17bdc7..c9608a5 100644
> > --- a/fs/ocfs2/alloc.c
> > +++ b/fs/ocfs2/alloc.c
> > @@ -5921,7 +5921,7 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
> >  
> >  			status = ocfs2_free_clusters(handle, data_alloc_inode,
> >  						     data_alloc_bh, start_blk,
> > -						     num_clusters);
> > +						     num_clusters, 0);
> 
> 	Seeing all these ', 0' arguments appear, I was confused until I
> saw the actual ocfs2_free_clusters change later in the patch.  That made
> me worry I would be re-confused coming back to this code six months from
> now.
> 	Here's my shot at leaving ocfs2_free_clusters() and
> ocfs2_free_suballoc_bits() intact while providing the same
> functionality.

Yeah, that patch looks better. Thanks for the cleanup.

Acked-by: Mark Fasheh <mfasheh@suse.com>


--
Mark Fasheh
