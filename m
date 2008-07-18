From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 17 Jul 2008 17:47:15 -0700
Subject: [Ocfs2-devel] [PATCH 12/15] Add xattr find process for xattr
	index btree.v2
In-Reply-To: <4877FDEA.4090801@oracle.com>
References: <48648B3E.6050808@oracle.com>
	<20080627070235.GA20375@tma-pc2.cn.oracle.com>
	<20080711235914.GD9557@wotan.suse.de> <4877FDEA.4090801@oracle.com>
Message-ID: <20080718004715.GO28014@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Jul 12, 2008 at 08:42:18AM +0800, Tao Ma wrote:
> >This function looks like it's doing a lot of random I/O. What about sucking
> >up some large numbers of (contiguous) blocks with a readahead request 
> >before
> >going into this function? The beauty of how our readhead works is that you
> >wouldn't have to change a single line of code here..
> Do you mean add OCFS2_BH_READAHEAD in read_block flag?

Yes. You can pass that flag to ocfs2_read_block and it will submit the read
request without waiting on it to return. In fact, you can even drop your
reference to the bh and read it in again later via a non-readahead
ocfs2_read_block() call and the code will do the right thing.

An example of this is ocfs2_dir_foreach_blk_el() - it's doing directory
readahead, though it's a bit obscured by the ocfs2_bread() call. I don't
think you need ocfs2_bread() though, but underneath it's just
ocfs2_read_block() + OCFS2_BH_READAHEAD.


> Not sure whether readahead can help us much. We normally only read the 
> header of a bucket, as for bs=1K, we only read 1 block for every 4 
> blocks, so most of readahead is useless. And even worse, with binary 
> search, we really don't know which block we will read before the search. 
> So can readahead help us in this issue? I am not familiar with IO 
> readahead, so please be patient and explain it to you if you have time. ;)

What I'm trying to do is take the multiple single-block reads that you're
doing and turn them into a fewer number of larger, streaming reads.

This will improve performance because the block layer below us will be
better able to merge the multiple requests into a larger one, thus requiring
fewer seeks (or fewer requests).

What works in our favor is that we're limiting the size of leaves, as I
discussed earlier.

You're correct by the way, in that we might not touch some of the blocks
that we've read. I think that's ok though - the point is that the ones we
*do* touch will hopefully be there at the same time as all the rest.


By the way, regarding the binary search, I find myself wondering if it's
worth the effort, or whether we should just start with a linear search of
the leaf. Do you have any opinions on this?
	--Mark

--
Mark Fasheh
