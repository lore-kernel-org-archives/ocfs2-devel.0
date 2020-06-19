From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 19 Jun 2020 11:39:14 +0200
Subject: [Ocfs2-devel] [RFC PATCH 0/2] gfs2 readahead regression in v5.8-rc1
Message-ID: <20200619093916.1081129-1-agruenba@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, Junxiao Bi <junxiao.bi@oracle.com>, William Kucharski <william.kucharski@oracle.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, John Hubbard <jhubbard@nvidia.com>, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mm@kvack.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org

Hello,

can the two patches in this set still be considered for v5.8?

Commit d4388340ae0b ("fs: convert mpage_readpages to mpage_readahead")
which converts gfs2 and other filesystems to use the new ->readahead
address space operation is leading to deadlocks between the inode glocks
and page locks: ->readahead is called with the pages to readahead
already locked.  When gfs2_readahead then tries to lock the associated
inode glock, another process already holding the inode glock may be
trying to lock the same pages.

We could work around this in gfs by using a LM_FLAG_TRY lock in
->readahead for now.  The real reason for this deadlock is that gfs2
shouldn't be taking the inode glock in ->readahead in the first place
though, so I'd prefer to fix this "properly" instead.  Unfortunately,
this depends on a new IOCB_CACHED flag for generic_file_read_iter.

A previous version was posted in November:

https://urldefense.com/v3/__https://lore.kernel.org/linux-fsdevel/20191122235324.17245-1-agruenba at redhat.com/__;!!GqivPVa7Brio!LmBheYse5B61aDX8Kb1YDtzeYu4oO-pGUU7yz2_cnE43PjIYJo_ZBkyKls4_93eUXhkSBQ$ 

Thanks,
Andreas

Andreas Gruenbacher (2):
  fs: Add IOCB_CACHED flag for generic_file_read_iter
  gfs2: Rework read and page fault locking

 fs/gfs2/aops.c     | 27 ++------------------
 fs/gfs2/file.c     | 61 ++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/fs.h |  1 +
 mm/filemap.c       | 16 ++++++++++--
 4 files changed, 76 insertions(+), 29 deletions(-)


base-commit: af42d3466bdc8f39806b26f593604fdc54140bcb
-- 
2.26.2
