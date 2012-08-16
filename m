From: Jan Kara <jack@suse.cz>
Date: Thu, 16 Aug 2012 23:57:54 +0200
Subject: [Ocfs2-devel] a bug about deadlock when enable quota on ocfs2
In-Reply-To: <502D2E7C.6090508@oracle.com>
References: <4FFCF397.20108@oracle.com> <20120713220907.GB12532@quack.suse.cz>
	<5004A623.5000909@oracle.com>
	<20120815221226.GF29223@quack.suse.cz>
	<502D2E7C.6090508@oracle.com>
Message-ID: <20120816215754.GB22160@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  Hello Srini,

On Thu 16-08-12 10:31:40, srinivas eeda wrote:
> If we do not offload work to ocfs2_wq then the unlink steps on other
> nodes are synchronous because ocfs2_delete_inode on other nodes will
> be called by the down covert thread. This will/should clear the
> inodes from other nodes if not in use. By the time the node that
> issued unlink calls ocfs2_delete_inode the inodes on other nodes
> should already be cleared and hence they gets cleared from orphan
> directory.
  I see but it's really rather fragile for inode deletion to depend on
the way how downconvert threads are called, isn't it? The fact that you
need to call d_drop() from ocfs2_dentry_convert_worker() to invalidate the
dentry and force inode reference to be dropped only proves my point. And I
see no reason why even d_drop() is enough because someone else could be
holding a reference to the dentry which further delays destruction of it
to the time that reference is dropped (which need not be from a downconvert
thread).

So although I believe you your patch makes customer workload work, I don't
think it's the right way of fixing the problem. Rather we should make it
safe for ocfs2_evict_inode() to be run in parallel on two nodes. And as I
wrote in my previous email it doesn't seem to require much - just dropping
of exclusive inode lock has to happen *after* we drop open lock. Not
before.

								Honza

PS: I've added ocfs2-devel list back to CC since I think it's good to have
this discussion archived for future reference and also so that other
ocfs2 developers can read it and offer their ideas.
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
