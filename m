From: Jan Kara <jack@suse.cz>
Date: Sat, 25 Oct 2008 00:48:39 +0200
Subject: [Ocfs2-devel] Bug in OCFS2 umount code
In-Reply-To: <20081024224025.GF9302@mail.oracle.com>
References: <20081024215702.GA10038@duck.suse.cz>
	<20081024224025.GF9302@mail.oracle.com>
Message-ID: <20081024224839.GA10359@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri 24-10-08 15:40:25, Joel Becker wrote:
> On Fri, Oct 24, 2008 at 11:57:02PM +0200, Jan Kara wrote:
> >   while playing with quota support I found two bugs in OCFS2 mount/umount
> > code. The first problem is, that if mount fails, we call
> > ocfs2_dismount_volume(). That is fine but after fill_super() returns an
> > error, VFS calls sync_fs() and ocfs2_put_super() again - not a good idea.
> > We usually oops...
> 
> 	I was trying to figure out why this happens, given that we've
> never seen it before and we test failed mounts all the time (no cluster
> stack, bad mount argument, bad features...).
> 	The vfs only calls ->sync_fs() and ->put_super() if sb->s_root
> exists.  So we cannot fail a mount after we've set sb->s_root.  If you
> check ocfs2_fill_super(), you'll see that after we sb->s_root, we will
> continue on to success (we return 'status', but status will be 0).
> 	After we've set s_root, we must complete our mount tasks in
> fill_super().  If you want to fail after that, you need to complete the
> mount tasks but return non-zero status.  Then the VFS code will follow
> to ->put_super() like you say and ocfs2_dismount_volume() will only be
> called once.
> 	So I don't see a bug in the code as I have it here in my tree.
> I'm going to go check your quota patches to see if perhaps you jump to
> read_super_error after s_root is set.  If so, we can just reorganize
> that.  If not, we'll have to figure out what particular mount failure is
> causing your problem, so we can see what's happening.
  Ah, OK. I've noticed that when quota failed to turn on for some reason.
So you are probably right, that I've added an error path which was not
there. Just when I was looking at the mount code I didn't notice that
I'm doing something different from the rest of the function :) Sorry for
the noise.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
