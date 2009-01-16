From: Jan Kara <jack@suse.cz>
Date: Fri, 16 Jan 2009 17:18:30 +0100
Subject: [Ocfs2-devel] Bug in inode deletion code leading to stale	inodes
In-Reply-To: <20090115015922.GZ17410@wotan.suse.de>
References: <20090112220635.GD31811@duck.suse.cz>
	<20090115015922.GZ17410@wotan.suse.de>
Message-ID: <20090116161830.GD10617@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed 14-01-09 17:59:22, Mark Fasheh wrote:
> On Mon, Jan 12, 2009 at 11:06:35PM +0100, Jan Kara wrote:
> >   I've hit a bug in OCFS2 delete code which results in inodes being left on
> > disk without any links to them. The workload triggering this creates
> > directories on one node and deletes them on another node in the cluster.
> > The inode is not deleted because both nodes bail out from
> > ocfs2_delete_inode() with:
> > Skipping delete of 100405 because it is in use on other nodes
> > 
> >   The scenario which I think is happening is as follows:
> > 
> >   node1					node2
> > 					rmdir("d");
> > 					  ocfs2_remote_dentry_delete()
> >   ocfs2_dentry_convert_worker()
> > 					  finishes ocfs2_unlink()
> > 					  eventually enters ocfs2_delete_inode()
> > 					    ocfs2_inode_lock()
> > 					    ocfs2_query_inode_wipe() -> fail
> > 					    ocfs2_inode_unlock()
> >   ocfs2_dentry_post_unlock()
> >     ocfs2_drop_dentry_lock()
> >       iput()
> >        ocfs2_delete_inode()
> >          ocfs2_inode_lock()
> > 	 ocfs2_query_inode_wipe() -> fail
> > 	 ocfs2_inode_unlock()
> >          clear_inode()
> > 					    clear_inode()
> 
> FWIW, your analysis looks correct to me.
> 
> 
> >   The question is how to avoid this. It seems to me that we have to really
> > do open_lock() and not just trylock to avoid the race. Is there any reason
> > why we cannot move the open_lock() before inode_lock() in
> > ocfs2_delete_inode()?
> 
> We can't do that because open_lock() will deadlock with nodes still using
> the inode.
  Yes, true.

> The way the open lock works is that each node takes a RO on it when the
> inode is instantiated. That PR is dropped in ocfs2_clear_inode(). If a node
> wants to delete an inode, it will trylock at EX to see if any other nodes
> have an active lock.
  Hmm, I was so concentrated on the case when both nodes are dropping the
lock that I forgot about the obvious case when one node is still using the
inode :).

> I think we have to look at how the downconvert thread deals with these
> locks. Either we push some parts to a work queue, or we figure out how to
> reorder some of the operations.
> 
> The problem with pushing off to a work queue, is we run the risk of slowing
> down unlink related ops. Pushing the dentry downconvert away will result in
> high unlink() latency, while pushing the final iput() away runs the risk of
> bouncing the orphan dir lock (if the iput() comes after the deleting nodes
> query in ->delete_inode())
> 
> Do you think there's a way we could just reverse the order - iput the inode,
> BEFORE downconverting the dentry lock?
  Definitely not easily - dentry_convert_worker() heavily uses the inode
pointer (it actually alters the inode) and we cannot do this when we've
already iput() the inode.
  We could maybe solve the problem by only releasing open_lock under
inode_lock (which we acquire in ocfs2_delete_inode() anyway). That would
synchronize releasing of open_lock and ocfs2_query_inode_wipe() on another
node and thus solve the race.
  There are just two issues:
    1) Whether we can afford to release open lock already earlier
(principially I see no reason why it should be a problem)
    2) Whether it is guaranteed that unlocks of inode_lock and open_lock
cannot be reordered (either by DLM or by networking).

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
