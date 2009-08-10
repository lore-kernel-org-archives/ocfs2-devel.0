From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 10 Aug 2009 11:59:34 -0700
Subject: [Ocfs2-devel] New update for sync in reflink. [Re: some
 thoughts about data integrity test for reflink.]
In-Reply-To: <4A7D8B92.5090906@oracle.com>
References: <4A1B8E15.20005@oracle.com>
	<1243322353.6616.18.camel@tristan-laptop.cn.oracle.com>
	<4A1C8708.8050704@oracle.com>
	<1243389610.6616.30.camel@tristan-laptop.cn.oracle.com>
	<4A1DDFCF.4060203@oracle.com> <4A1E3B9A.7000807@oracle.com>
	<20090528171406.GA315@mail.oracle.com>
	<4A7C4708.9030303@oracle.com>
	<20090808001005.GE30923@mail.oracle.com>
	<4A7D8B92.5090906@oracle.com>
Message-ID: <20090810185934.GB31168@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Aug 08, 2009 at 10:28:34PM +0800, Tao Ma wrote:
> > 	I do not.  Having to call ocfs2_sync_inode() for every reflink
> > is a disaster.  We need to think about this.  Basically, how can the
> > reflink target notice it has to either sync the source or perhaps copy
> > the data over?
> >   
> OK, I agree with you for ocfs2_sync_inode part. I am just a little 
> worried about the above case I mentioned, so if we can
> resolve it gracefully, I would be very glad about it.

	Well, I can't find a good solution.  But we're not going to use
ocfs2_sync_inode(), as that syncs metadata, which is pointless for
reflink.  Also, we need to code up waiting on the sync
(ocfs2_sync_inode() starts the sync, but does not wait on it).  We need
to start the sync as early as possible.
	As an aside, ocfs2_sync_inode() is a completely useless
function.  filemap_fdatawrite() is called by the vfs fsync code, and we
don't use the mapping buffers so sync_mapping_buffers() is a noop.  A
future patch should just remove ocfs2_sync_inode().
	So, here's what needs to happen.  At the very top of
__ocfs2_reflink(), right after you have ip_alloc_sem and have locked out
concurrent writers, you need to call filemap_fdatawrite().  This will
start the writeback in the background while you go on to building the
refcount trees.  At the very bottom of __ocfs2_reflink(), before you
drop the locks on the new_inode, you then filemap_fdatawait().
	I think that this means we can drop ocfs2_cow_sync_writeback()
because the data must have been up to date before the reflink could have
been CoWd.  We can also drop the filemap_fdatawrite_range() in
ocfs2_refcount_cow().  In ocfs2_duplicate_clusters() PageDirty() is now
a BUG_ON().  Right?

Joel

-- 

"If the human brain were so simple we could understand it, we would
 be so simple that we could not."
	- W. A. Clouston

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
