From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Feb 27 20:28:01 2004
Subject: [Ocfs2-devel] Re: [PATCH]2.6 fixes in file.c
In-Reply-To: <20040224215021.GA24689@penguin.co.intel.com>
References: <200402200413.i1K4DFoW004249@penguin.co.intel.com>
	<20040224015742.GI1421@ca-server1.us.oracle.com>
	<20040224030843.GA18881@penguin.co.intel.com>
	<20040224214438.GK1421@ca-server1.us.oracle.com>
	<20040224215021.GA24689@penguin.co.intel.com>
Message-ID: <20040228022756.GQ1421@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This has been committed.
	--Mark

On Tue, Feb 24, 2004 at 01:50:21PM -0800, Rusty Lynch wrote:
> On Tue, Feb 24, 2004 at 01:44:38PM -0800, Mark Fasheh wrote:
> <snip>
> > > > >  int ocfs_empty (struct dentry *dentry);
> > > > > +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
> > > > > +int ocfs_dentry_revalidate (struct dentry *dentry, struct nameidata *nd);
> > > > > +#else
> > > > >  int ocfs_dentry_revalidate (struct dentry *dentry, int flags);
> > > > > +#endif
> > > > Why is this here? Shouldn't this update be in the dcache patch? 
> > > 
> > > yeap, a little blood from the dcache patch.  It's still needed, so I still
> > > have it in this patch.
> > What worries me is that I don't see any similar changes to the function
> > declaration (and the function itself) in dcache.c... Is this a "coming soon"
> > or did you forget to send that patch? Since it doesn't affect the 2.4
> > version, I can commit it anyway but I just wanna make sure we're on the same
> > page.
> 
> oops... I didn't realize I dropped it.
> 
>     --rusty
--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
