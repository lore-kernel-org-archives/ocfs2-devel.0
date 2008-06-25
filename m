From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 25 Jun 2008 13:20:58 -0700
Subject: [Ocfs2-devel] configfs: Q: item leak in a failing
	configfs_attach_group()?
In-Reply-To: <20080625095527.GB32036@hawkmoon.kerlabs.com>
References: <20080624141649.GH7621@hawkmoon.kerlabs.com>
	<20080624171051.GD4184@ca-server1.us.oracle.com>
	<20080624180456.GA32036@hawkmoon.kerlabs.com>
	<20080624213439.GB2785@mail.oracle.com>
	<20080625095527.GB32036@hawkmoon.kerlabs.com>
Message-ID: <20080625202058.GC14049@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Wed, Jun 25, 2008 at 11:55:27AM +0200, Louis Rilling wrote:
> On Tue, Jun 24, 2008 at 02:34:39PM -0700, Joel Becker wrote:
> > On Tue, Jun 24, 2008 at 08:04:56PM +0200, Louis Rilling wrote:
> > > On Tue, Jun 24, 2008 at 10:10:51AM -0700, Joel Becker wrote:
> > > > On Tue, Jun 24, 2008 at 04:16:49PM +0200, Louis Rilling wrote:
> > > > > Hi,
> > > > > 
> > > > > I'd like an opinion on the following scenario:
> > > > > 
> > > > > process 1: 					process 2:
> > > > > configfs_mkdir("A")
> > > > >   attach_group("A")
> > > > >     attach_item("A")
> > > > >       d_instantiate("A")
> > > > >     populate_groups("A")
> > > > >       mutex_lock("A")
> > > > >       attach_group("A/B")
> > > > >         attach_item("A")
> > > > >           d_instantiate("A/B")
> > > > > 						mkdir("A/B/C")
> > > > > 						  do_path_lookup("A/B/C", LOOKUP_PARENT)
> > > > 
> > > > 					This has to sleep until
> > > > 					configfs_mkdir("A") finishes.
> > > > 					It's waiting on A->d_parent's
> > > > 					i_mutex, which is held by
> > > > 					sys_mkdirat().
> > > 
> > > Can you be more precise? I don't see where do_path_lookup() locks an inode
> > 
> > 	It doesn't.  It's in lookup_create(), which takes the mutex on the
> > parent of 'A'.  Note that the end of sys_mkdirat() explicitly drops that
> > mutex - it couldn't do so if it hadn't been taken :-)
> 
> So, my scenario is realistic. Process 2 only locks "B"'s inode in
> lookup_create() ("B" is the parent of the new directory "C"), and never has to
> lock "A" or "A"'s parent. IOW, process 2 does not have to wait on any i_mutex
> locked by process 1.

	Um, 'A' hasn't appeared yet.  I don't see how it looks up 'A'
until we're done.

Joel

-- 

"When ideas fail, words come in very handy." 
         - Goethe

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
