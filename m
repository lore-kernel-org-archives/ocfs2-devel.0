From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 24 Jun 2008 14:34:39 -0700
Subject: [Ocfs2-devel] configfs: Q: item leak in a failing
	configfs_attach_group()?
In-Reply-To: <20080624180456.GA32036@hawkmoon.kerlabs.com>
References: <20080624141649.GH7621@hawkmoon.kerlabs.com>
	<20080624171051.GD4184@ca-server1.us.oracle.com>
	<20080624180456.GA32036@hawkmoon.kerlabs.com>
Message-ID: <20080624213439.GB2785@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, Jun 24, 2008 at 08:04:56PM +0200, Louis Rilling wrote:
> On Tue, Jun 24, 2008 at 10:10:51AM -0700, Joel Becker wrote:
> > On Tue, Jun 24, 2008 at 04:16:49PM +0200, Louis Rilling wrote:
> > > Hi,
> > > 
> > > I'd like an opinion on the following scenario:
> > > 
> > > process 1: 					process 2:
> > > configfs_mkdir("A")
> > >   attach_group("A")
> > >     attach_item("A")
> > >       d_instantiate("A")
> > >     populate_groups("A")
> > >       mutex_lock("A")
> > >       attach_group("A/B")
> > >         attach_item("A")
> > >           d_instantiate("A/B")
> > > 						mkdir("A/B/C")
> > > 						  do_path_lookup("A/B/C", LOOKUP_PARENT)
> > 
> > 					This has to sleep until
> > 					configfs_mkdir("A") finishes.
> > 					It's waiting on A->d_parent's
> > 					i_mutex, which is held by
> > 					sys_mkdirat().
> 
> Can you be more precise? I don't see where do_path_lookup() locks an inode

	It doesn't.  It's in lookup_create(), which takes the mutex on the
parent of 'A'.  Note that the end of sys_mkdirat() explicitly drops that
mutex - it couldn't do so if it hadn't been taken :-)

Joel

-- 

"You cannot bring about prosperity by discouraging thrift. You cannot
 strengthen the weak by weakening the strong. You cannot help the wage
 earner by pulling down the wage payer. You cannot further the
 brotherhood of man by encouraging class hatred. You cannot help the
 poor by destroying the rich. You cannot build character and courage by
 taking away a man's initiative and independence. You cannot help men
 permanently by doing for them what they could and should do for
 themselves."
	- Abraham Lincoln 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
