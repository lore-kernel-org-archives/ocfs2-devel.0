From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Wed Feb 18 19:17:28 2004
Subject: [Ocfs2-devel] Re: [PATCH]2.6 friendly access to bh devices
Message-ID: <50D19C3AC815734C9E19FE4C4F6128A602A56916@orsmsx403.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Do you know when these commits will get pushed out to the external
repository?

John



> -----Original Message-----
> From: ocfs2-devel-bounces@oss.oracle.com 
> [mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Mark Fasheh
> Sent: Tuesday, February 17, 2004 7:28 PM
> To: Rusty Lynch
> Cc: ocfs2-devel@oss.oracle.com
> Subject: [Ocfs2-devel] Re: [PATCH]2.6 friendly access to bh devices
> 
> 
> Cool, this one's been committed too. I added an extra set of 
> parens around
> the _b in _hashfn.
> 	--Mark
> 
> On Tue, Feb 17, 2004 at 02:53:11PM -0800, Rusty Lynch wrote:
> > The new buffer_head struct references a block_device which points
> > to a specific device instead of directly pointing to a device.
> > 
> > This patch adds a new BH_GET_DEVICE(bh) macro which will expand
> > correctly across 2.4 and 2.6 builds.
> > 
> >     --rusty
> > 
> > Index: src/hash.c
> > ===================================================================
> > --- src/hash.c	(revision 31)
> > +++ src/hash.c	(working copy)
> > @@ -685,7 +685,7 @@
> >  		(((block)<<(ocfs_bh_hash_shift - 6)) ^ ((block) 
> >> 13) ^ \
> >  		((block) << (ocfs_bh_hash_shift - 12))))
> >  #define ocfs_bh_sem_hash_fn(_b)   \
> > -	(_hashfn((unsigned int)((_b)->b_dev), (_b)->b_blocknr) 
> & ocfs_bh_hash_shift)
> > +	(_hashfn((unsigned int)BH_GET_DEVICE(_b), 
> (_b)->b_blocknr) & ocfs_bh_hash_shift)
> >  
> >  int ocfs_bh_sem_hash_init()
> >  {
> > @@ -748,7 +748,7 @@
> >  		}
> >  		sem = list_entry (iter, ocfs_bh_sem, s_list);
> >  		if (sem->s_blocknr == bh->b_blocknr &&
> > -		    sem->s_dev == bh->b_dev) {
> > +		    sem->s_dev == BH_GET_DEVICE(bh)) {
> >  			if (atomic_read(&sem->s_refcnt)==0) {
> >  				if (sem->s_bh) {
> >  					LOG_ERROR_STR("refcount 
> was zero but s_bh not NULL!");
> > @@ -800,7 +800,7 @@
> >  			newsem->s_bh = NULL;
> >  			atomic_set(&newsem->s_refcnt, 0);
> >  			newsem->s_blocknr = bh->b_blocknr;
> > -			newsem->s_dev = bh->b_dev;
> > +			newsem->s_dev = BH_GET_DEVICE(bh);
> >  			init_MUTEX (&newsem->s_sem);
> >  			init_waitqueue_head(&newsem->s_wait);
> >  			newsem->s_pid = 0;
> > Index: src/inc/io.h
> > ===================================================================
> > --- src/inc/io.h	(revision 31)
> > +++ src/inc/io.h	(working copy)
> > @@ -166,8 +166,12 @@
> >  }
> >  #endif
> >  
> > +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
> > +#define BH_GET_DEVICE(bh) ((bh->b_bdev)->bd_dev)
> > +#else
> > +#define BH_GET_DEVICE(bh) (bh->b_dev)
> > +#endif
> >  
> > -
> >  static inline void OCFS_BH_PUT_DATA(struct buffer_head *bh)
> >  {
> >  	kunmap((bh)->b_page);
> --
> Mark Fasheh
> Software Developer, Oracle Corp
> mark.fasheh@oracle.com
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
