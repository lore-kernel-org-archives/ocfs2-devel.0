From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 12 Jun 2009 09:13:02 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Adjust rightmost path in
	ocfs2_add_branch.
In-Reply-To: <1244787516-13475-2-git-send-email-tao.ma@oracle.com>
References: <4A326E26.4080002@oracle.com>
	<1244787516-13475-2-git-send-email-tao.ma@oracle.com>
Message-ID: <20090612161302.GL10980@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 12, 2009 at 02:18:36PM +0800, Tao Ma wrote:
> In ocfs2_add_branch, we use the rightmost rec of the leaf extent block
> to generate the e_cpos for the new added branch. In the most case, it
> is OK but if there is a gap between the the root(or branch) 's rightmost
> rec and the leaf, it will cause kernel panic if we insert some clusters
> in it. The message is something like:
> (7445,1):ocfs2_insert_at_leaf:3775 ERROR: bug expression:
> le16_to_cpu(el->l_next_free_rec) >= le16_to_cpu(el->l_count)
> (7445,1):ocfs2_insert_at_leaf:3775 ERROR: inode 66053, depth 0, count 28,
> next free 28, rec.cpos 270, rec.clusters 1, insert.cpos 275, insert.clusters 1
>  [<fa7ad565>] ? ocfs2_do_insert_extent+0xb58/0xda0 [ocfs2]
>  [<fa7b08f2>] ? ocfs2_insert_extent+0x5bd/0x6ba [ocfs2]
>  [<fa7b1b8b>] ? ocfs2_add_clusters_in_btree+0x37f/0x564 [ocfs2]
> ...
> 
> The panic can be easily reproduced by the following small test case
> (with bs=512, cs=4K, and I remove all the error handling so that it looks
> clear enough for reading).
> 
> int main(int argc, char **argv)
> {
> 	int fd, i;
> 	char buf[5] = "test";
> 
> 	fd = open(argv[1], O_RDWR|O_CREAT);
> 
> 	for (i = 0; i < 30; i++) {
> 		lseek(fd, 40960 * i, SEEK_SET);
> 		write(fd, buf, 5);
> 	}
> 
> 	ftruncate(fd, 1146880);
> 
> 	lseek(fd, 1126400, SEEK_SET);
> 	write(fd, buf, 5);
> 
> 	close(fd);
> 
> 	return 0;
> }
> 
> The reason of the panic is that:
> the 30 writes and the ftruncate makes the file's extent list looks like:
> 
> 	Tree Depth: 1   Count: 19   Next Free Rec: 1
> 	## Offset        Clusters       Block#
> 	0  0             280            86183
> 	SubAlloc Bit: 7   SubAlloc Slot: 0
> 	Blknum: 86183   Next Leaf: 0
> 	CRC32: 00000000   ECC: 0000
> 	Tree Depth: 0   Count: 28   Next Free Rec: 28
> 	## Offset        Clusters       Block#          Flags
> 	0  0             1              143368          0x0
> 	1  10            1              143376          0x0
> 	...
> 	26 260           1              143576          0x0
> 	27 270           1              143584          0x0
> 
> Now another write at 1126400(275 cluster) whiich will write at the gap
> between 271 and 280 will trigger ocfs2_add_branch, but the result after
> the function looks like:
> 	Tree Depth: 1   Count: 19   Next Free Rec: 1
> 	## Offset        Clusters       Block#
> 	0  0             280            86183
> 	0  271           0             143592
> So the extent record is intersected and make the following operation bug out.
> 
> This patch just try to remove the gap before we add the new branch, so that
> the root(branch) rightmost rec will cover the same right position. So in the
> above case, before adding branch the tree will be changed to
> 	Tree Depth: 1   Count: 19   Next Free Rec: 1
> 	## Offset        Clusters       Block#
> 	0  0             271            86183
> 	SubAlloc Bit: 7   SubAlloc Slot: 0
> 	Blknum: 86183   Next Leaf: 0
> 	CRC32: 00000000   ECC: 0000
> 	Tree Depth: 0   Count: 28   Next Free Rec: 28
> 	## Offset        Clusters       Block#          Flags
> 	0  0             1              143368          0x0
> 	1  10            1              143376          0x0
> 	...
> 	26 260           1              143576          0x0
> 	27 270           1              143584          0x0
> And after branch add, the tree looks like
> 	Tree Depth: 1   Count: 19   Next Free Rec: 1
> 	## Offset        Clusters       Block#
> 	0  0             271            86183
> 	0  271           0             143592
> 
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
Acked-by: Mark Fasheh <mfasheh@suse.com>


--
Mark Fasheh
