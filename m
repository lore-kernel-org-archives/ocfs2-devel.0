From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Thu, 13 Feb 2014 16:20:06 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: improve fsync efficiency and fix
 deadlock between aio_write and sync_file
In-Reply-To: <20140213213345.GB5716@wotan.suse.de>
References: <20140130034848.GE8798@birch.djwong.org>
	<20140212225818.GX24361@wotan.suse.de>
	<20140213015343.GC30642@birch.djwong.org>
	<20140213213345.GB5716@wotan.suse.de>
Message-ID: <20140214002006.GA21609@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 13, 2014 at 01:33:45PM -0800, Mark Fasheh wrote:
> On Wed, Feb 12, 2014 at 05:53:43PM -0800, Darrick J. Wong wrote:
> > On Wed, Feb 12, 2014 at 02:58:18PM -0800, Mark Fasheh wrote:
> > > On Wed, Jan 29, 2014 at 07:48:48PM -0800, Darrick J. Wong wrote:
> > > > Currently, ocfs2_sync_file grabs i_mutex and forces the current
> > > > journal transaction to complete.  This isn't terribly efficient, since
> > > > sync_file really only needs to wait for the last transaction involving
> > > > that inode to complete, and this doesn't require i_mutex.
> > > > 
> > > > Therefore, implement the necessary bits to track the newest tid
> > > > associated with an inode, and teach sync_file to wait for that instead
> > > > of waiting for everything in the journal to commit.  Furthermore, only
> > > > issue the flush request to the drive if jbd2 hasn't already done so.
> > > > 
> > > > This also eliminates the deadlock between ocfs2_file_aio_write() and
> > > > ocfs2_sync_file().  aio_write takes i_mutex then calls
> > > > ocfs2_aiodio_wait() to wait for unaligned dio writes to finish.
> > > > However, if that dio completion involves calling fsync, then we can
> > > > get into trouble when some ocfs2_sync_file tries to take i_mutex.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Ok, I can see what the patch is doing, but I have a silly question - where
> > > exactly are we marking the latest transaction id during a write system call?
> > 
> > The patch should update those tids every time anything touches the inode --
> > block allocations, truncates, attribute/timestamp updates, etc.  For rewriting
> > a disk block without touching the inode, ocfs2_sync_file will either wait for
> > the last transaction involving the inode to commit + flush, or if the
> > transaction has long since been committed, it will issue the flush directly
> > without needing a recent tid.
> 
> Ok, I think I understand - If we're doing a block rewrite and say the inode
> hasn't been otherwise touched, we'll get into ocfs2_sync_file(). Once in
> ocfs2_sync_file(), the call to jbd2_trans_will_send_data_barrier() will
> return 0, forcing us to issue the flush. Is that correct?

Yes.

> > Does that help?  I /think/ I covered all the cases where I need to update the
> > tid.
> 
> Yeah that helps a lot, thanks. If you don't mind checking my logic above that would be
> great :)
> 
> We update mtime in ocfs2_write_end() - I don't believe your patch catches
> that in the case that we're doing a non-allocating write.

Ahh, you're right, the mtime update would not necessarily be forced out at sync
time.  I'll send out a corrected patch.

--D
> 
> Thanks Darrick!
> 	--Mark
> 
> --
> Mark Fasheh
