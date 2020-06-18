From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 18 Jun 2020 14:46:03 +0200
Subject: [Ocfs2-devel] [Cluster-devel] [PATCH v11 16/25] fs: Convert
	mpage_readpages to mpage_readahead
In-Reply-To: <20200617022157.GF8681@bombadil.infradead.org>
References: <20200414150233.24495-1-willy@infradead.org>
	<20200414150233.24495-17-willy@infradead.org>
	<CAHc6FU4m1M7Tv4scX0UxSiVBqkL=Vcw_z-R7SufL8k7Bw=qPOw@mail.gmail.com>
	<20200617003216.GC8681@bombadil.infradead.org>
	<CAHpGcMK6Yu0p-FO8CciiySqh+qcWLG-t3hEaUg-rqJnS=2uhqg@mail.gmail.com>
	<20200617022157.GF8681@bombadil.infradead.org>
Message-ID: <CAHc6FU7NLRHKRJJ6c2kQT0ig8ed1n+3qR-YcSCWzXOeJCUsLbA@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, Junxiao Bi <junxiao.bi@oracle.com>, William Kucharski <william.kucharski@oracle.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, John Hubbard <jhubbard@nvidia.com>, LKML <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, cluster-devel <cluster-devel@redhat.com>, Linux-MM <linux-mm@kvack.org>, ocfs2-devel@oss.oracle.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-erofs@lists.ozlabs.org, Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, Bob Peterson <rpeterso@redhat.com>

On Wed, Jun 17, 2020 at 4:22 AM Matthew Wilcox <willy@infradead.org> wrote:
> On Wed, Jun 17, 2020 at 02:57:14AM +0200, Andreas Gr?nbacher wrote:
> > Am Mi., 17. Juni 2020 um 02:33 Uhr schrieb Matthew Wilcox <willy@infradead.org>:
> > >
> > > On Wed, Jun 17, 2020 at 12:36:13AM +0200, Andreas Gruenbacher wrote:
> > > > Am Mi., 15. Apr. 2020 um 23:39 Uhr schrieb Matthew Wilcox <willy@infradead.org>:
> > > > > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > > > >
> > > > > Implement the new readahead aop and convert all callers (block_dev,
> > > > > exfat, ext2, fat, gfs2, hpfs, isofs, jfs, nilfs2, ocfs2, omfs, qnx6,
> > > > > reiserfs & udf).  The callers are all trivial except for GFS2 & OCFS2.
> > > >
> > > > This patch leads to an ABBA deadlock in xfstest generic/095 on gfs2.
> > > >
> > > > Our lock hierarchy is such that the inode cluster lock ("inode glock")
> > > > for an inode needs to be taken before any page locks in that inode's
> > > > address space.
> > >
> > > How does that work for ...
> > >
> > > writepage:              yes, unlocks (see below)
> > > readpage:               yes, unlocks
> > > invalidatepage:         yes
> > > releasepage:            yes
> > > freepage:               yes
> > > isolate_page:           yes
> > > migratepage:            yes (both)
> > > putback_page:           yes
> > > launder_page:           yes
> > > is_partially_uptodate:  yes
> > > error_remove_page:      yes
> > >
> > > Is there a reason that you don't take the glock in the higher level
> > > ops which are called before readhead gets called?  I'm looking at XFS,
> > > and it takes the xfs_ilock SHARED in xfs_file_buffered_aio_read()
> > > (called from xfs_file_read_iter).
> >
> > Right, the approach from the following thread might fix this:
> >
> > https://urldefense.com/v3/__https://lore.kernel.org/linux-fsdevel/20191122235324.17245-1-agruenba at redhat.com/T/*t__;Iw!!GqivPVa7Brio!IekEw8uQR1N_S3Wqmk3aWZVcgHRjA1cp2KT7CkfJUM5xxPPXx_Jr5Is0-Z3rCNxzU5XYvQ$ 
>
> In general, I think this is a sound approach.
>
> Specifically, I think FAULT_FLAG_CACHED can go away.  map_pages()
> will bring in the pages which are in the page cache, so when we get to
> gfs2_fault(), we know there's a reason to acquire the glock.

We'd still be grabbing a glock while holding a dependent page lock.
Another process could be holding the glock and could try to grab the
same page lock (i.e., a concurrent writer), leading to the same kind
of deadlock.

Andreas
