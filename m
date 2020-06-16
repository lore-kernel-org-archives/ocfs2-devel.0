From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 17 Jun 2020 00:36:13 +0200
Subject: [Ocfs2-devel] [Cluster-devel] [PATCH v11 16/25] fs: Convert
	mpage_readpages to mpage_readahead
In-Reply-To: <20200414150233.24495-17-willy@infradead.org>
References: <20200414150233.24495-1-willy@infradead.org>
	<20200414150233.24495-17-willy@infradead.org>
Message-ID: <CAHc6FU4m1M7Tv4scX0UxSiVBqkL=Vcw_z-R7SufL8k7Bw=qPOw@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-xfs@vger.kernel.org, Junxiao Bi <junxiao.bi@oracle.com>, William Kucharski <william.kucharski@oracle.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, John Hubbard <jhubbard@nvidia.com>, LKML <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, cluster-devel <cluster-devel@redhat.com>, Linux-MM <linux-mm@kvack.org>, ocfs2-devel@oss.oracle.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-erofs@lists.ozlabs.org, Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, Bob Peterson <rpeterso@redhat.com>

Am Mi., 15. Apr. 2020 um 23:39 Uhr schrieb Matthew Wilcox <willy@infradead.org>:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>
> Implement the new readahead aop and convert all callers (block_dev,
> exfat, ext2, fat, gfs2, hpfs, isofs, jfs, nilfs2, ocfs2, omfs, qnx6,
> reiserfs & udf).  The callers are all trivial except for GFS2 & OCFS2.

This patch leads to an ABBA deadlock in xfstest generic/095 on gfs2.

Our lock hierarchy is such that the inode cluster lock ("inode glock")
for an inode needs to be taken before any page locks in that inode's
address space. However, the readahead address space operation is
called with the pages already locked. When we try to grab the inode
glock inside gfs2_readahead, we'll deadlock with processes that are
holding that inode glock and trying to lock one of those same pages.

One possible solution is to use a trylock on the glock in
gfs2_readahead, and to give up the readahead in case of a locking
conflict. I have no idea how this is going to affect performance.

Any other ideas?

Thanks,
Andreas
