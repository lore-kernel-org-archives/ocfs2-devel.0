From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 7 Aug 2009 17:10:05 -0700
Subject: [Ocfs2-devel] New update for sync in reflink. [Re: some
 thoughts about data integrity test for reflink.]
In-Reply-To: <4A7C4708.9030303@oracle.com>
References: <4A1B8E15.20005@oracle.com>
	<1243322353.6616.18.camel@tristan-laptop.cn.oracle.com>
	<4A1C8708.8050704@oracle.com>
	<1243389610.6616.30.camel@tristan-laptop.cn.oracle.com>
	<4A1DDFCF.4060203@oracle.com> <4A1E3B9A.7000807@oracle.com>
	<20090528171406.GA315@mail.oracle.com>
	<4A7C4708.9030303@oracle.com>
Message-ID: <20090808001005.GE30923@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

[I've added ocfs2-devel to the Cc list.  Please copy the list, otherwise
  we can't get Mark's thoughts, and he knows some of the code better
  than I do. ]

On Fri, Aug 07, 2009 at 11:23:52PM +0800, Tao Ma wrote:
> Joel Becker wrote:
> >>I called ocfs2_sync_inode before reflink to flush the page
> >>cache.  So I  think we should get all B's and C's are missed.
> >>The reason I call ocfs2_sync_inode is the following test case:
> >>1. Write a file with all A's.
> >>2. reflink A to B.
> >>3. read B.
> >>If the page cache of A isn't synced to the disk, we may get the
> >>garbage  from reading of B.
> >
> >	We won't get garbage.  We get 'A's, which is a valid state of
> >the file.  Whether it's valid in the face of relink is what we're trying
> >to decide here.
> We don't get 'A' here actually and we would get garbage. Strange,
> uh? I just added some printk and it seems that while reading file B,
> the buffer_head is created
> and read from the disk. I used to think that while we write file A,
> we will create buffer_head. And reading file B will use this
> buffer_head.
> But that is not the case actually. The only right sequence is that
> we add a sync between step 1 and 2.

	Um, what?
	Oh, we do the check for PageDirty() in CoW, but not in straight
read...

> >	Now, whether we want a reflink to force a sync or not in the
> >writeback case...on the one hand, people will probably expect write();
> >reflink(); read() to work.  On the other hand, they really should
> >write(); fsync(); reflink(); if they care.  We're already dealing
> >with this regarding rename(), and its ugly.  Force the fsync() for them,
> >and we help the naive caller but penalize (performance-wise) the
> >intelligent caller.
> I have checked my mount mode, it is data=ordered, so we also meet
> with this issue in ordered mode.

	Yes, the original discussion was concerning the page cache
contents during CoW.  You've coded that up correctly.  Here we're
talking about simple read.

> >	I really lean towards just requiring the caller to deal with it.
> >It's what unix-like systems do for all other operations.  I poked Chris,
> >and he agrees.  So a caller if they knew they had such a situation, does
> >'fsync(); reflink();'.
> So a user always need to do fsync before he do reflink. Is it OK? If
> yes, I will ask tristan to update his test case.

	Well... I would normally say yes, because stale vs not-stale is
one thing.  But complete garbage from before the first write is not OK.

> >>I think it is OK if I call ocfs2_sync_inode before reflink?(See
> >>my git  tree for details).
> >
> >	Calling it unconditionally is just a performance disaster
> >waiting to happen.  Even if we want to require reflink() to happen with
> >data flushed, you don't want to call ocfs2_sync_inode() in the ordered
> >case.  You want the ordered journal to handle it.
> Since it doesn't work in order mode which is more common for ocfs2
> usage, do you change your mind here?

	I do not.  Having to call ocfs2_sync_inode() for every reflink
is a disaster.  We need to think about this.  Basically, how can the
reflink target notice it has to either sync the source or perhaps copy
the data over?

Joel

-- 

Life's Little Instruction Book #43

	"Never give up on somebody.  Miracles happen every day."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
