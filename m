From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Tue Feb 24 16:38:57 2004
Subject: [Ocfs2-devel] [PATCH]2.6 fixes in super.c
In-Reply-To: <20040224221212.GL1421@ca-server1.us.oracle.com>
References: <200402180312.i1I3CH7Y015248@penguin.co.intel.com>
	<20040219233755.GA24928@penguin.co.intel.com>
	<20040223233523.GA1421@ca-server1.us.oracle.com>
	<20040224042501.GA20255@penguin.co.intel.com>
	<20040224221212.GL1421@ca-server1.us.oracle.com>
Message-ID: <20040224223848.GA24814@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 24, 2004 at 02:12:12PM -0800, Mark Fasheh wrote:
> On Mon, Feb 23, 2004 at 08:25:01PM -0800, Rusty Lynch wrote:
> > Here is a redone version of the patch that applies cleanly to the current 
> > svn repository.
> > 
> >     --rusty
> <snip>
> 
> > @@ -721,15 +733,27 @@
> >          buf->f_type = OCFS_MAGIC;
> >          buf->f_bsize = sb->s_blocksize;
> >          buf->f_namelen = OCFS_MAX_FILENAME_LENGTH;
> > +        buf->f_bavail = buf->f_bfree;
> > +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
> >          buf->f_blocks =
> > -            (unsigned long) ((unsigned long) (numbits) *
> > -                             (unsigned long) (osb->vol_layout.cluster_size >> 9) -
> > -			     (8 * ONE_MEGA_BYTE / osb->vol_layout.cluster_size)); 
> > +		(unsigned long) ((unsigned long) (numbits) *
> > +				 (unsigned long) (osb->vol_layout.cluster_size >> 9) -
> > +				 (8 * ONE_MEGA_BYTE / osb->vol_layout.cluster_size)); 
> >          buf->f_bfree =
> >              (unsigned long) (freebits * (osb->vol_layout.cluster_size >> 9));
> >          buf->f_bavail = buf->f_bfree;
> >          buf->f_files = (unsigned long) (numbits);
> >          buf->f_ffree = (unsigned long) (numbits) - freebits;
> > +#else
> > +        buf->f_blocks =
> > +		(sector_t) ((unsigned long) (numbits) *
> > +			    (unsigned long) (osb->vol_layout.cluster_size >> 9) -
> > +			    (8 * ONE_MEGA_BYTE / osb->vol_layout.cluster_size)); 
> > +        buf->f_bfree =
> > +            (sector_t) (freebits * (osb->vol_layout.cluster_size >> 9));
> > +        buf->f_files = (sector_t) (numbits);
> > +        buf->f_ffree = (sector_t) (numbits) - freebits;
> > +#endif
> 
> In this preprocessor conditional, don't we mean: 
> #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
> 
> instead of 
> #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
> 
> If so, I'll just change it in my tree and commit that (you should prolly fix
> it in yours too).
> 	--Mark

Yeap, good catch.

    --rusty
