From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Tue, 24 Jun 2008 20:04:56 +0200
Subject: [Ocfs2-devel] configfs: Q: item leak in a failing
	configfs_attach_group()?
In-Reply-To: <20080624171051.GD4184@ca-server1.us.oracle.com>
References: <20080624141649.GH7621@hawkmoon.kerlabs.com>
	<20080624171051.GD4184@ca-server1.us.oracle.com>
Message-ID: <20080624180456.GA32036@hawkmoon.kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, Jun 24, 2008 at 10:10:51AM -0700, Joel Becker wrote:
> On Tue, Jun 24, 2008 at 04:16:49PM +0200, Louis Rilling wrote:
> > Hi,
> > 
> > I'd like an opinion on the following scenario:
> > 
> > process 1: 					process 2:
> > configfs_mkdir("A")
> >   attach_group("A")
> >     attach_item("A")
> >       d_instantiate("A")
> >     populate_groups("A")
> >       mutex_lock("A")
> >       attach_group("A/B")
> >         attach_item("A")
> >           d_instantiate("A/B")
> > 						mkdir("A/B/C")
> > 						  do_path_lookup("A/B/C", LOOKUP_PARENT)
> 
> 					This has to sleep until
> 					configfs_mkdir("A") finishes.
> 					It's waiting on A->d_parent's
> 					i_mutex, which is held by
> 					sys_mkdirat().

Can you be more precise? I don't see where do_path_lookup() locks an inode
outside of real_lookup(), and what I understand is that real_lookup() is neither
called for "A", nor called for "A/B" because __d_lookup() will find positive
dentries (they were d_instantiated). Since do_path_lookup() is called with
LOOKUP_PARENT, it stops here. Then lookup_create() locks "A/B"'s inode, without
waiting, and calls lookup_hash("A/B", "C"), which ends calling
configfs_lookup("A/B", "C") because "A/B" has no child "C" in the dcache.

What am I missing?

Thanks,

Louis

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 189 bytes
Desc: Digital signature
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080624/7bbab0e1/attachment.bin 
