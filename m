From: Dave Chinner <david@fromorbit.com>
Date: Tue, 18 Feb 2020 17:37:32 +1100
Subject: [Ocfs2-devel] [PATCH v6 10/19] fs: Convert mpage_readpages to
	mpage_readahead
In-Reply-To: <20200217184613.19668-18-willy@infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-18-willy@infradead.org>
Message-ID: <20200218063732.GP10776@dread.disaster.area>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org, Junxiao Bi <junxiao.bi@oracle.com>

On Mon, Feb 17, 2020 at 10:45:58AM -0800, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Implement the new readahead aop and convert all callers (block_dev,
> exfat, ext2, fat, gfs2, hpfs, isofs, jfs, nilfs2, ocfs2, omfs, qnx6,
> reiserfs & udf).  The callers are all trivial except for GFS2 & OCFS2.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com> # ocfs2
> ---
>  drivers/staging/exfat/exfat_super.c |  7 +++---
>  fs/block_dev.c                      |  7 +++---
>  fs/ext2/inode.c                     | 10 +++-----
>  fs/fat/inode.c                      |  7 +++---
>  fs/gfs2/aops.c                      | 23 ++++++-----------
>  fs/hpfs/file.c                      |  7 +++---
>  fs/iomap/buffered-io.c              |  2 +-
>  fs/isofs/inode.c                    |  7 +++---
>  fs/jfs/inode.c                      |  7 +++---
>  fs/mpage.c                          | 38 +++++++++--------------------
>  fs/nilfs2/inode.c                   | 15 +++---------
>  fs/ocfs2/aops.c                     | 34 ++++++++++----------------
>  fs/omfs/file.c                      |  7 +++---
>  fs/qnx6/inode.c                     |  7 +++---
>  fs/reiserfs/inode.c                 |  8 +++---
>  fs/udf/inode.c                      |  7 +++---
>  include/linux/mpage.h               |  4 +--
>  mm/migrate.c                        |  2 +-
>  18 files changed, 73 insertions(+), 126 deletions(-)

That's actually pretty simple changeover. Nothing really scary
there. :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david at fromorbit.com
