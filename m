From: Jan Kara <jack@suse.cz>
Date: Mon, 27 Jun 2011 12:47:46 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Avoid livelock in ocfs2_readpage()
In-Reply-To: <20110626072643.GB15623@noexit.corp.google.com>
References: <1308862307-15626-1-git-send-email-jack@suse.cz>
	<20110626072643.GB15623@noexit.corp.google.com>
Message-ID: <20110627104746.GD5597@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun 26-06-11 00:26:44, Joel Becker wrote:
> On Thu, Jun 23, 2011 at 10:51:47PM +0200, Jan Kara wrote:
> > When someone writes to an inode, readers accessing the same inode via
> > ocfs2_readpage() just busyloop trying to get ip_alloc_sem because
> > do_generic_file_read() looks up the page again and retries ->readpage()
> > when previous attempt failed with AOP_TRUNCATED_PAGE. When there are enough
> > readers, they can occupy all CPUs and in non-preempt kernel the system is
> > deadlocked because writer holding ip_alloc_sem is never run to release the
> > semaphore. Fix the problem by making reader block on ip_alloc_sem to break
> > the busy loop.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ocfs2/aops.c |    8 ++++++++
> >  1 files changed, 8 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> > index ac97bca..0919e8f 100644
> > --- a/fs/ocfs2/aops.c
> > +++ b/fs/ocfs2/aops.c
> > @@ -290,7 +290,15 @@ static int ocfs2_readpage(struct file *file, struct page *page)
> >  	}
> >  
> >  	if (down_read_trylock(&oi->ip_alloc_sem) == 0) {
> > +		/*
> > +		 * Unlock the page and cycle ip_alloc_sem so that we don't
> > +		 * busyloop waiting for ip_alloc_sem to unlock
> > +		 */
> >  		ret = AOP_TRUNCATED_PAGE;
> > +		unlock_page(page);
> > +		unlock = 0;
> > +		down_read(&oi->ip_alloc_sem);
> > +		up_read(&oi->ip_alloc_sem);
> >  		goto out_inode_unlock;
> >  	}
> 
> 	Question: First, is it safe to drop the page lock here?
> Can all callers of readpage (not just g_f_a_r()) handle that?
  We do exactly the same thing in ocfs2_inode_lock_with_page() so we
definitely don't introduce a new problem. And every caller of readpage() is
*supposed* to handle AOP_TRUNCATED_PAGE return value (because page reading
can race with truncate) in which case page must be returned unlocked. So it
should be safe. Admittedly I did not bother to check the call sites.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
