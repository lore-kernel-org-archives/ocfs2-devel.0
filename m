From: Josef Bacik <jbacik@fusionio.com>
Date: Thu, 20 Jun 2013 17:26:14 -0000
Subject: [Ocfs2-devel] [PATCH] fs/jbd2: t_updates should increase when
 start_this_handle() failed in jbd2__journal_restart()
In-Reply-To: <20130620155555.GE28309@thunk.org>
References: <51C1381A.2@huawei.com>
 <20130620155555.GE28309@thunk.org>
Message-ID: <20130620172609.GC4288@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>
Cc: Younger Liu <younger.liu@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Ocfs2-Devel <ocfs2-devel@oss.oracle.com>, Li Zefan <lizefan@huawei.com>, jack@suse.cz

On Thu, Jun 20, 2013 at 11:55:55AM -0400, Theodore Ts'o wrote:
> [ LKML and linux-fsdevel BCC'ed ]
> 
> On Wed, Jun 19, 2013 at 12:48:26PM +0800, Younger Liu wrote:
> > jbd2_journal_restart() would restart a handle. In this function, it
> > calls start_this_handle(). Before calling start_this_handle()?subtract
> > 1 from transaction->t_updates.
> > If start_this_handle() succeeds, transaction->t_updates increases by 1
> > in it. But if start_this_handle() fails, transaction->t_updates does
> > not increase.
> > So, when commit the handle's transaction in jbd2_journal_stop(), the
> > assertion is false, and then trigger a bug.
> > The assertion is as follows:
> > J_ASSERT(atomic_read(&transaction->t_updates) > 0) 
> > 
> > Signed-off-by: Younger Liu <younger.liu@huawei.com>
> 
> Thanks for pointing out this potential problem.  Your fix isn't quite
> the right one, however.
> 
> The problem is once we get to this point, the transaction pointer may
> no longer be valid, since once we decrement t_updates, the transaction
> could start commiting, and so we should not actually dereference the
> transaction pointer after we unlock transaction->t_handle_lock.  (We
> are referencing t_tid two lines later, and technically that's a bug.
> We've just been getting lucky.)
> 
> The real issue is that by the time we call start_this_handle() in
> jbd2__journal_restart, the handle is not attached to any transaction.
> So if jbd2_journal_restart() fails, the handle has to be considered
> invalid, and the calling code should not try to use the handle at all,
> including calling jbd2_journal_stop().
> 
> Jan Kara is I believe currently on vacation but I'd really like him to
> chime in with his opinion about the best way to fix this, since he's
> also quite familiar with the jbd2 code.
> 
> Also, Jan has recently submitted changes to implement reserved handles
> (to be submitted in the next merge window), and in these new
> functions, if start_this_handle() fails when called from
> jbd2_journal_start_reserved(), the handle is left invalidated, and the
> caller of jbd2_journal_start_reserved() must not touch the handle
> again, including calling jbd2_journal_stop() --- in fact, because
> jbd2_journal_start_reserved() clears current->journal_info on failure,
> an attempt to call jbd2_journal_stop() will result in the kernel oops
> due to an assertion failure.
> 
> My inclination is to fix this in the same way, but it will require
> changing the current code paths that use jbd2_journal_restart(), and
> in some cases passing back the state that the handle is now invalid
> and should not be released via jbd2_journal_stop() is going to be
> tricky indeed.
> 
> 
> Another possible fix is to set the handle to be aborted, via
> jbd2_journal_abort_handle().  This function isn't used at all at the
> moment, but from what I can tell this should do the right thing.  The
> one unfortunate thing about this is that when jbd2_journal_stop() gets
> called, it will return EROFS, which is a misleading error code.  I'm
> guessing you're seeing this because start_this_handle() returned
> ENOMEM, correct?  We could hack around this by stashing the real error
> in the handle, and then change jbd2_journal_stop() to return that
> error instead of EROFS if it is set.
> 
> This second solution is hacky all-around, and it's also inconsistent
> with how we are doing things with jbd2_journal_start_reserved().  So
> I'm not so happy with this solution.  But it would require a lot less
> work because the fix would be isolated in the jbd2 layer.  OTOH, right
> now if the code calls jbd2_journal_stop() on the handle after a
> failure in jbd2_journal_start_reserved(), they are crashing anyway, so
> changing the code so it changes with an assertion failure doesn't make
> things any worse, and then we fix things in ext4 and ocfs2 without any
> patch interdependencies --- and this is a problem which appears to
> happen very rarely in practice.
> 

I realize it's been a little bit since I've looked at jbd but I'll offer my
opinion.  Callers of jbd2_journal_restart() may not be the ones who originated
the handle, so doing what Jan has done with jbd2_journal_start_reserved() isn't
going to work because all the guy at the top is going to see is an error and
have no way to tell if his handle is invalid or not.

What I would suggest is getting a unified way to mark that the handle has
already been cleaned up and can just be free'd.  Then fix
jbd2_journal_start_reserved() and jbd2_journal_restart() to set that in the
handle and make jbd2_journal_stop() just free up the handle and reset
current->journal_info but not return an error.  It's important to not return an
error from jbd2_journal_stop() so that it doesn't invoke the ext4 error handling
stuff and you get a read only file system when the error may not be read only
file system worthy.

This way you have a nice clean way of dealing with handle errors that allow you
to pass back a real error to the caller and the caller can just do its normal
jbd2_journal_stop() and cleanup and do its own error handling the way it feels.
This keeps the yucky details of no longer valid handles all internal to jbd2 and
ext4/ocfs2 don't have to worry about it.  Thanks,

Josef
