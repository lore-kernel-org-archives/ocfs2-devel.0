From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Wed Mar 17 15:42:32 2004
Subject: [Ocfs2-devel] [Build PATCH]Add --enable-lockres-debug
In-Reply-To: <20040317195254.GJ20057@ca-server1.us.oracle.com>
References: <200403171825.i2HIPRIn022075@penguin.co.intel.com>
	<20040317195254.GJ20057@ca-server1.us.oracle.com>
Message-ID: <20040317210207.GA22346@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 17, 2004 at 11:52:54AM -0800, Mark Fasheh wrote:
> Are you actually using this code?
> 	--Mark

yes.  On my 2.6 build there is a crash when I umount if ocfs_put_inode
comes across a non-root inode that still has an oin associated with it.
The problem is that in ocfs_release_cached_oin we try to use oin->lock_res
which was already free'ed in ocfs_hash_destroy, and not set to null.

It's a classical problem of a ref counted object being free'ed and having
another object not realize that it's pointer is now garbage.

Turning on the lock resource debug code allows me to almost see what is
going on.  I say almost because ocfs_hash_destroy just directly calls
ocfs_free_lockres.

The funny thing is that I think the 2.4 code is also using lock resources
after they have been free'ed, but since my 2.4 kernel doesn't have all the
extra kmem_cache_* debug options turned on (do they even exist in 2.4?),
the kernel doesn't burp when we use memory that is in our memory cache 
object (but just not officially available.)  <<== this last part could be
total BS, but my crash on 2.6 seems to go away after I turn off all the kernel
hacks for memory debugging (yet I can still see via all my debug printk's
that I am in fact using lock resources after they have been free'ed.)

You can reproduce this behavior by mounting the file system, creating a new
file, and then unmounting the file system.  When ocfs_file_release call
ocfs_release_cached_oin, the associated dentry still has reference, so we
skip removing the oin.  Eventually ocfs_put_inode will see the root inode and
start dismounting, which will cause ocfs_hash_destory to free all the lock
resources, and then ocfs_inode_hash_prune_all will come across some inodes
that still have a i_count > 2 and therefore call iput on the inode

... which gets us to the ocfs_put_inode with an oin that has a non-null
oin->lock_res, but the lock_res is already gone.

    --rusty

> 
> On Wed, Mar 17, 2004 at 10:25:27AM -0800, Rusty Lynch wrote:
> > The following patch just enables existing lock resource debug code
> > that already exist in ocfs.h.  
> > 
> >     --rusty
> > 
> > Index: configure.in
> > ===================================================================
> > --- configure.in	(revision 781)
> > +++ configure.in	(working copy)
> > @@ -104,6 +104,13 @@
> >  fi
> >  AC_SUBST(OCFS_MEMDEBUG)
> >  
> > +AC_ARG_ENABLE(lockres-debug, [  --enable-lockres-debug=[yes/no]     Turn on lock resource debugging [default=no]],,enable_lockres_debug=no)
> > +OCFS_DBG_LOCKRES=
> > +if test "x$enable_lockres_debug" = "xyes"; then
> > +  OCFS_DBG_LOCKRES=yes
> > +fi
> > +AC_SUBST(OCFS_DBG_LOCKRES)
> > +
> >  AC_ARG_ENABLE(trace, [  --enable-trace=[yes/no]         Turn on tracing [default=yes]],,enable_trace=yes)
> >  OCFS_TRACE=
> >  if test "x$enable_trace" = "xyes"; then
> > Index: Config.make.in
> > ===================================================================
> > --- Config.make.in	(revision 781)
> > +++ Config.make.in	(working copy)
> > @@ -60,6 +60,7 @@
> >  OCFS_LARGEIO = @OCFS_LARGEIO@
> >  OCFS_AIO = @OCFS_AIO@
> >  OCFS_MEMDEBUG = @OCFS_MEMDEBUG@
> > +OCFS_DBG_LOCKRES = @OCFS_DBG_LOCKRES@
> >  OCFS_TRACE = @OCFS_TRACE@
> >  OCFS_PROCESSOR = @OCFS_PROCESSOR@
> >  
> > Index: src/Makefile
> > ===================================================================
> > --- src/Makefile	(revision 781)
> > +++ src/Makefile	(working copy)
> > @@ -33,6 +33,10 @@
> >  GLOBAL_DEFINES += -DOCFS_LINUX_MEM_DEBUG -DDEBUG_SLAB_ALLOCS
> >  endif
> >  
> > +ifdef OCFS_DBG_LOCKRES
> > +GLOBAL_DEFINES += -DOCFS_DBG_LOCKRES
> > +endif
> > +
> >  ifdef OCFS_AIO
> >  GLOBAL_DEFINES += -DAIO_ENABLED
> >  endif
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel@oss.oracle.com
> > http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> --
> Mark Fasheh
> Software Developer, Oracle Corp
> mark.fasheh@oracle.com
