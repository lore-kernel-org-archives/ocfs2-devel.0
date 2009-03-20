From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 19 Mar 2009 17:30:22 -0700
Subject: [Ocfs2-devel] [RFC] metadata alloc fix in machines which has
	PAGE_SIZE > CLUSTER_SIZE
In-Reply-To: <49C0FDDC.2030704@oracle.com>
References: <49C0FDDC.2030704@oracle.com>
Message-ID: <20090320003022.GC13065@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 18, 2009 at 09:57:48PM +0800, Tao Ma wrote:
> Hi Mark/Joel,
> 	I meet with some meta allocation bugs when I implement reflink these 
> days. And after some investigation, I think we should have the same 
> problem when we have PAGE_SIZE > CLUSTER_SIZE. So I create a scenario 
> today in one ppc box and try. the box panic as I expected. ;)
> 
> The scenario is that: Create a file with the disk layout like this(with
> bs=512, and cs=4K).
> 
> debugfs: stat 15151
> 	Inode: 66072   Mode: 0644   Generation: 59969160 (0x3930e88)
> <snip>
> 	Tree Depth: 1   Count: 19   Next Free Rec: 2
> 	## Offset        Clusters       Block#
> 	0  0             258            86365
> 	1  258           66             86367
> 	SubAlloc Bit: 21   SubAlloc Slot: 0
> 	Blknum: 86365   Next Leaf: 86367
> 	CRC32: N/A   ECC: N/A
> 	Tree Depth: 0   Count: 28   Next Free Rec: 28
> 	## Offset        Clusters       Block#          Flags
> 	0  0             1              116696          0x0
> <snip>
> 	25 25            1              117096          0x0
> 	26 256           1              117112          0x1
> 	27 257           1              117120          0x0
> 	SubAlloc Bit: 23   SubAlloc Slot: 0
> 	Blknum: 86367   Next Leaf: 0
> 	CRC32: N/A   ECC: N/A
> 	Tree Depth: 0   Count: 28   Next Free Rec: 2
> 	## Offset        Clusters       Block#          Flags
> 	0  258           2              117128          0x1
> 	1  260           64             117176          0x1
> 
> Please note the extent record from "26" to "0" of the next block are
> contiguous allocated with unwritten and then divide it by write to the
> 256 with 1 cluster.
> 
> Now if we try to write 40960 bytes at offset 256. We will panic. Why?
> The reason is that:
> 1. with ppc box, we have page_size=64K. So in one
> ocfs2_write_begin_no_lock we will try to handle 40960 bytes together.
> 2. in ocfs2_lock_allocators we will get that no metadata is need since
> the 2nd extent block has so many empty extent recs.

So, the core problem then is that ocfs2_lock_allocators is not doing as good
a job calculating the meta data allocation this write needs.


> 3. then write begin one cluster by one in ocfs2_write_cluster.
>   1) The 1st cluster(256) nothing special.
>   2) the 2nd (257), it will be merged with 256.
>   3) the 3rd (258), be merged with 256.
>   4) the 4th (259), be merged. Now 256-259 will be merged into 1 extent
> rec, so the 2nd extent block will be removed. and we will get.
> 	26 256           4              117112          0x0
> 	27 260           64             117176          0x1
>   5) Now comes the 260, we need to split and call ocfs2_add_branch to
> allocate a new block. But wait, we have no metadata reserved. So we
> panic here.

Right, ok.


> So my thought is that can we reuse the freed extent block? I guess we 
> can. We just need to store the pointer of ocfs2_cached_dealloc_ctxt in 
> ocfs2_alloc_context. So whenever we allocate a new metadata, we try to 
> search ocfs2_cached_dealloc_ctxt first, if there is some, we use it 
> directly and delete it from ocfs2_cached_dealloc_ctxt. The same can go 
> for cluster allocation I guess although I don't know whether we have 
> such case for clusters.
> 
> make sense?

Yes, but I think a better approach is to fix the core problem, instead of
working around it. What we want to do then is make ocfs2_lock_allocators
smart enough to catch this case so that it can reserve the proper amount of
meta data. The good news is that we already do a scan of the writeable area
in ocfs2_populate_write_desc(). It seems to me that scan is a good place
where we could store some information about contiguous extents which will be
merged. The only thing that'd be left for ocfs2_lock_allocators to do is
look at the remaining extent block counts.
	--Mark

--
Mark Fasheh
