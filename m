From: Wim Coekaerts <wim.coekaerts@oracle.com>
Date: Wed Mar 24 03:40:52 2004
Subject: [Ocfs2-devel] [PATCH]Enable 2.6 file data flushing
In-Reply-To: <20040324055857.GA14337@penguin.co.intel.com>
References: <200403240411.i2O4BrRr014124@penguin.co.intel.com>
	<20040324042306.GE1516@ca-server1.us.oracle.com>
	<20040324055857.GA14337@penguin.co.intel.com>
Message-ID: <20040324094047.GC4512@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

slick, yeah when I saw your patch I checked in 2.4 and saw it existed as
that, totally makes sense, we should put it in our ocfs1 tree also, I
think that wills olve some of the weirdness we have seen

cool stuff Rusty :)

On Tue, Mar 23, 2004 at 09:58:57PM -0800, Rusty Lynch wrote:
> On Tue, Mar 23, 2004 at 08:23:06PM -0800, Wim Coekaerts wrote:
> > hmm now I wonder if we dont' also need that in 2.4...
> > 
> > 
> > On Tue, Mar 23, 2004 at 08:11:53PM -0800, Rusty Lynch wrote:
> > > The following small patch makes a 2.6 built kernel flush it's 
> > > data buffers to disk on ocfs_sync_inode, fixing bug #46
> > > 
> > > http://oss.oracle.com/bugzilla/show_bug.cgi?id=46
> > > 
> > >     --rusty
> > > 
> 
> the equivilant call in 2.4 would be filemap_fdatasync().  I gave it a 
> try and it does fix the mmap issue talked about in bug #50.
> 
> Here is a patch
> 
> 
> Index: src/file.c
> ===================================================================
> --- src/file.c	(revision 807)
> +++ src/file.c	(working copy)
> @@ -68,8 +68,10 @@
>  {
>  	int status;
>  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
> +	filemap_fdatawrite(inode->i_mapping);
>  	status = sync_mapping_buffers(inode->i_mapping);
>  #else
> +	filemap_fdatasync(inode->i_mapping);
>  	status = fsync_inode_buffers(inode);
>  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,18)
>  	if (!status)	       
