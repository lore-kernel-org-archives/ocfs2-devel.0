From: tristan <tristan.ye@oracle.com>
Date: Thu, 04 Nov 2010 15:05:14 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Add a new code
 'OCFS2_INFO_FREEFRAG' for o2info ioctl.
In-Reply-To: <20101104063221.GC22663@mail.oracle.com>
References: <1288782126-13007-1-git-send-email-tristan.ye@oracle.com>
	<1288782126-13007-2-git-send-email-tristan.ye@oracle.com>
	<20101104012949.GB14640@mail.oracle.com>
	<4CD220C9.20907@oracle.com>
	<20101104063221.GC22663@mail.oracle.com>
Message-ID: <4CD25B2A.7040909@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Thu, Nov 04, 2010 at 10:56:09AM +0800, tristan wrote:
>> While the user-specified chunksize is brand-new concept here;), it 
>> splits the whole bitmap from chunk to chunk sequentially.
>> and then to see how many of this sequential/fixed-size chunks are free. 
>> it sounds like the concept of page frame for main memory.
>> When a user is doing I/Os in a very size-fixed fashion, they may be 
>> happy to see how many chunks were fully free there.
>
> 	Let me see if I understand this.  If the user specified a
> chunksize of 64M and you find a free extent of 640M, your free list will
> say, "I've got one free extent of more than 128M," while your chunksize
> logic also reports, "I've got ten 64M chunks?"  Is that right?
Hmmm...

    Not exactly, while your first guess is right, my free list do says: 
"I've got
one free extent of more than 128M", while chunksize logic may not report 
10 free
chunks in this case, 10 free chunks will only be reported when the start 
of this
640M extent was fully 64M aligned. otherwise, 9 free chunks get reported.

So the essence of 'user-specified-chunksize' logic is splitting the 
whole bitmap
into chunks with fixed size. then check if these chunks are fully free 
from chunk to
chunk sequentially, a counter called 'free_chunks' will only be 
increased when all
clusters in this chunk were free. it sounds like a situation when we 
specify the
pagesize for a page frame, then counting the free pages in the physical 
memory.
it's all about aligned/fixed-size/sequential things.

While another counter called 'real_free_chunks' is dedicated to counting 
the number
of all free chunks we detected when scaning the whole bitmap from 
cluster to cluster.

Take following figure as example, say user specified the chunksize as 4 
clusters, and
the total size of global bitmap is 16 clusters. '0' denotes free 
cluster, while '1'
stands for used one.

#1 chunk   #2 chunk   #3 chunk    #4 chunk
1100       0010       0000        1100

 From above case, we found 3 real free chunks, they are:

1st free_chunk_size = 4

2nd free_chunk_size = 5

3rd free_chunk_size = 2

Therefore, real_free_chunks = 3

While for the 'user-specified-chunksize' logic, we have 4 
chunks(chunksize = 4), and only
one(#3 chunk) was free.

Does it make sense?

>
>>>> +		status = ocfs2_read_inode_block(gb_inode, &bh);
>>>> +		if (status < 0) {
>>>> +			mlog_errno(status);
>>>> +			goto bail;
>>>> +		}
>>>> +	}
>>> 	Same thoughts about ocfs2_ilookup() here.
>> Why we need to think about ocfs2_ilookup? since we're just trying to get 
>> a inode block here, not a cached VFS inode.
>
> 	If you already have the blkno, you're not igetting, and that's
> fine.  My bad.
>
> Joel
>
