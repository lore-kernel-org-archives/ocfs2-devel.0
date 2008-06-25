From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Wed, 25 Jun 2008 11:55:27 +0200
Subject: [Ocfs2-devel] configfs: Q: item leak in a failing
	configfs_attach_group()?
In-Reply-To: <20080624213439.GB2785@mail.oracle.com>
References: <20080624141649.GH7621@hawkmoon.kerlabs.com>
	<20080624171051.GD4184@ca-server1.us.oracle.com>
	<20080624180456.GA32036@hawkmoon.kerlabs.com>
	<20080624213439.GB2785@mail.oracle.com>
Message-ID: <20080625095527.GB32036@hawkmoon.kerlabs.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Tue, Jun 24, 2008 at 02:34:39PM -0700, Joel Becker wrote:
> On Tue, Jun 24, 2008 at 08:04:56PM +0200, Louis Rilling wrote:
> > On Tue, Jun 24, 2008 at 10:10:51AM -0700, Joel Becker wrote:
> > > On Tue, Jun 24, 2008 at 04:16:49PM +0200, Louis Rilling wrote:
> > > > Hi,
> > > > 
> > > > I'd like an opinion on the following scenario:
> > > > 
> > > > process 1: 					process 2:
> > > > configfs_mkdir("A")
> > > >   attach_group("A")
> > > >     attach_item("A")
> > > >       d_instantiate("A")
> > > >     populate_groups("A")
> > > >       mutex_lock("A")
> > > >       attach_group("A/B")
> > > >         attach_item("A")
> > > >           d_instantiate("A/B")
> > > > 						mkdir("A/B/C")
> > > > 						  do_path_lookup("A/B/C", LOOKUP_PARENT)
> > > 
> > > 					This has to sleep until
> > > 					configfs_mkdir("A") finishes.
> > > 					It's waiting on A->d_parent's
> > > 					i_mutex, which is held by
> > > 					sys_mkdirat().
> > 
> > Can you be more precise? I don't see where do_path_lookup() locks an inode
> 
> 	It doesn't.  It's in lookup_create(), which takes the mutex on the
> parent of 'A'.  Note that the end of sys_mkdirat() explicitly drops that
> mutex - it couldn't do so if it hadn't been taken :-)

So, my scenario is realistic. Process 2 only locks "B"'s inode in
lookup_create() ("B" is the parent of the new directory "C"), and never has to
lock "A" or "A"'s parent. IOW, process 2 does not have to wait on any i_mutex
locked by process 1.

Back to the two solutions that I've suggested (copy-pasted below), which one
would you prefer?

If I'm right, two kinds of solutions for issue 1 (new item created while
attaching a default group hierarchy):
i/ tag new directories with CONFIGFS_USET_NEW before calling d_instantiate, and
validate the whole group+default groups hierarchy in a second pass by clearing
CONFIGFS_USET_NEW

ii/ do not call d_instantiate() immediately in configfs_create() if called from
configfs_create_dir(), and d_instantitate() the group+default groups hierarchy
in a second pass. Problem: is it correct to add children to a dentry which is
not yet instantiated?

For issue 2/ (detach_item() called without locking the detached item's inode),
locking the inode before calling detach_item() (as is done from
configfs_rmdir()), plus a solution for 1/ should be sufficient.

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
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080625/e8bb7b8d/attachment.bin 
