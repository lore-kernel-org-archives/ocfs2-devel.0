From: Jan Kara <jack@suse.cz>
Date: Thu, 16 Aug 2012 00:12:26 +0200
Subject: [Ocfs2-devel] a bug about deadlock when enable quota on ocfs2
In-Reply-To: <5004A623.5000909@oracle.com>
References: <4FFCF397.20108@oracle.com> <20120713220907.GB12532@quack.suse.cz>
	<5004A623.5000909@oracle.com>
Message-ID: <20120815221226.GF29223@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hi,

  I'm back from vacation:
On Mon 16-07-12 16:39:15, Srinivas Eeda wrote:
> Jan Kara wrote:
> >  Hello,
> >>his comments:
> >>@ With those patches in, all other nodes will now queue downgrade of dentry
> >>@ locks to ocfs2_wq thread. Then Node 1 gets a lock is in use when it calls
> >>@ ocfs2_try_open_lock and so does other nodes and hence orphans lie
> >>around. Now
> >>@ orphans will keep growing and only gets cleared when all nodes umount the
> >>@ volume. This causes a different problems 1)space is not cleared 2)
> >>as orphans
> >>@ keep growing, orphan thread takes long time to scan all orphans(but still
> >>@ fails to clear oprhans because of open lock still around) and hence will
> >>@ block new unlinks for that duration because it gets a EX on orphan
> >>scan lock.
> >  I think the analysis is not completely correct (or I misunderstood it).
> >We defer only putting of inode reference to workqueue (lockres is freed
> >already in ocfs2_drop_dentry_lock()). However it is correct that the queue
> >of inodes to put can get long and the system gets into trouble.
> Sorry for not being clear. This is an issue when thread running
> unlink and ocfs2_wq on other node end up running ocfs2_delete_inode
> at the same time. They both call ocfs2_try_open_lock during query
> wipe inode and get EAGAIN. So they both defer the actual clean up.
> 
> This will become a problem if a user deletes tons of files at the
> same time. Lot of  orphans gets queued and it becomes a problem when
> user continues to delete.
  I see. But then I see nothing ocfs2_wq specific in this race. It just
seems the race is always there because the open lock logic is racy.
ocfs2_wq might make it more likely to hit the race but I don't see why it
would create it. Look, the sequence in ocfs2_evict_inode() essentially is:
  ocfs2_inode_lock()
  ocfs2_try_open_lock() [tries to get open lock in ex mode]
  ocfs2_inode_unlock()
  ocfs2_open_unlock()   [drops shared open lock we hold]

  Now if two nodes happen to execute ocfs2_evict_inode() in parallel and
ocfs2_try_open_lock() happens on both nodes before ocfs2_open_unlock() is
called on any of them, ocfs2_try_open_lock() fails for both nodes... So I
don't see why removing my patch offloading inode removal to ocfs2_wq should
help anything.

  I would think that the code should be reorganized so that shared open
lock is dropped before we drop inode lock. Then the race could not happen.
But I'm not sure if something else would not break.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
