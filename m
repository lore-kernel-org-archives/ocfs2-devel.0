From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Feb 24 15:44:43 2004
Subject: [Ocfs2-devel] Re: [PATCH]2.6 fixes in file.c
In-Reply-To: <20040224030843.GA18881@penguin.co.intel.com>
References: <200402200413.i1K4DFoW004249@penguin.co.intel.com>
	<20040224015742.GI1421@ca-server1.us.oracle.com>
	<20040224030843.GA18881@penguin.co.intel.com>
Message-ID: <20040224214438.GK1421@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 23, 2004 at 07:08:43PM -0800, Rusty Lynch wrote:
> On Mon, Feb 23, 2004 at 05:57:42PM -0800, Mark Fasheh wrote:
> > On Thu, Feb 19, 2004 at 08:13:15PM -0800, Rusty Lynch wrote:
> > > The following is a patch to file.c and proto.h that fixes some
> > > errors that happen when building with a 2.6 kernel.
> > > 
> > > * proper use of timespec time in various places
> > > * adds a new ocfs_sync_inode() function that for syncing inodes
> > >   in a 2.4 and 2.6 friendly way
> > > * removes more kdev references from the 2.6 code sections
> > > 
> > >     --rusty
> > 
> > This patch doesn't apply against current svn, would you mind regenerating it?
> 
> Here is a patch that depends on my last patch (for the LINUX_2_5 cleanup).
> 
> > > +static int ocfs_sync_inode(struct inode *inode)
> > Could we also add a prototype to the top of the file. That way we can keep
> > it consistent with the rest of the code.
> 
> got it
> 
> > >  int ocfs_empty (struct dentry *dentry);
> > > +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
> > > +int ocfs_dentry_revalidate (struct dentry *dentry, struct nameidata *nd);
> > > +#else
> > >  int ocfs_dentry_revalidate (struct dentry *dentry, int flags);
> > > +#endif
> > Why is this here? Shouldn't this update be in the dcache patch? 
> 
> yeap, a little blood from the dcache patch.  It's still needed, so I still
> have it in this patch.
What worries me is that I don't see any similar changes to the function
declaration (and the function itself) in dcache.c... Is this a "coming soon"
or did you forget to send that patch? Since it doesn't affect the 2.4
version, I can commit it anyway but I just wanna make sure we're on the same
page.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
