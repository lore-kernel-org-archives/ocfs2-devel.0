From: Li Dongyang <lidongyang@novell.com>
Date: Thu, 22 Apr 2010 22:13:51 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid direct write if we fall back
	to buffered
In-Reply-To: <20100414192011.GA29831@mail.oracle.com>
References: <4BC0B776020000460001DCCA@novprvlin0050.provo.novell.com>
	<201004141358.20777.lidongyang@novell.com>
	<20100414192011.GA29831@mail.oracle.com>
Message-ID: <201004222213.51266.lidongyang@novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thursday 15 April 2010 03:20:11 Joel Becker wrote:
> On Wed, Apr 14, 2010 at 01:58:20PM +0800, Li Dongyang wrote:
> > On Wednesday 14 April 2010 07:54:35 Joel Becker wrote:
> > > 	I think Sunil and I have found the real culprit.
> > > 	If a file is opened for O_DIRECT, and there are no holes,
> > > refcounts or anything, we are doing direct I/O.  ocfs2_file_aio_write()
> > > (o_f_a_w() from now on) locks things down like so:  lock(i_mutex),
> > > down_read(ip_alloc_sem), PR(rw_lock).  We have ip_alloc_sem preventing
> > > size changes on the local node and rw_lock preventing size changes on
> > > other nodes.  We call generic_file_direct_write() ourselves.
> > > 	If a file is not opened with O_DIRECT, we are doing regular
> > > buffered writes.  o_f_a_w() locks like so: lock(i_mutex),
> > > EX(rw_lock).  It is protecting against other nodes, but it does not
> > > touch ip_alloc_sem.  Why?  Because we call __generic_file_aio_write(),
> > > which will call ->write_begin().  ip_alloc_sem will be taken inside
> > > ->write_begin().  That's where we protect against other local
> > > processes. You may already see where I'm going with this.  If we are
> > > open with O_DIRECT, but we have to fall back to buffered, we will do
> > > this locking:  lock(i_mutex), down_read(ip_alloc_sem), PR(rw_lock),
> > > NL(rw_lock), up_read(ip_alloc_sem), EX(rw_lock).  That is, we start
> > > with the direct I/O locking, then back off and do the buffered locking.
> > >  But when we get into __g_f_a_w(), it will try the direct I/O again. 
> > > If the leading portion of the I/O is capable of direct I/O, it will go
> > > into direct mode *without ever taking ip_alloc_sem*.  Once it gets to
> > > the portion of the I/O that cannot be done direct, it will fall back to
> > > buffered for the rest of the I/O and will call ->write_begin() as
> > > expected.
> > > 	So this I/O that extends i_size to the end of the allocation
> > > will proceed as a direct I/O but will not have ip_alloc_sem.  Thus
> > > truncate (and any other allocation change) can race on the local
> > > machine.
> > > 	I think some form of Dong Yang's patch is going to be necessary.
> >
> > Thanks for the great explanation and analysis, but I only see we down
> > write the OCFS2_I(inode)->ip_alloc_sem in ->write_begin() and we are
> > taking inode->i_alloc_sem in o_f_a_w() when we try to do a direct write,
> > not the ip_alloc_sem. Am I missing something?
> 
> 	You're right, we use i_alloc_sem in the direct case and
> ip_alloc_sem in the buffered case.  It is, however, for the same reason.
> i_alloc_sem is about competing with the VFS (eg, vs vfs_truncate()).
> ip_alloc_sem is about competing with ourselves (ocfs2_truncate(),
> ocfs2_readpage(), etc).
> 	While I should be saying i_alloc_sem above for the direct I/O
> case, the rest of the analysis is still correct.  We need to be holding
> i_alloc_sem if we're going to be issuing direct I/Os, and we are not
> holding it in the fallback to buffered case.
> 
> Joel
> 
another question: why do we only take PR on the rw_lock and do not allow a 
direct write extending the i_size?
Br
Li Dongyang
