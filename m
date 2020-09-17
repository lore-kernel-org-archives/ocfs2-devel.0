From: Christoph Hellwig <hch@lst.de>
Date: Thu, 17 Sep 2020 18:57:06 +0200
Subject: [Ocfs2-devel] remove blkdev_get as a public API
Message-ID: <20200917165720.3285256-1-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>, Minchan Kim <minchan@kernel.org>, Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org

Hi Jens,

this series removes blkdev_get as a public API, leaving it as just an
implementation detail of blkdev_get_by_path and blkdev_get_by_dev.  The
reason for that is that blkdev_get is a very confusing API that requires
a struct block_device to be fed in, but then actually consumes the
reference.  And it turns out just using the two above mentioned APIs
actually significantly simplifies the code as well.

Diffstat:
 block/genhd.c                   |   11 ++--
 block/ioctl.c                   |   13 ++---
 drivers/block/nbd.c             |    8 +--
 drivers/block/pktcdvd.c         |   92 +++++-----------------------------------
 drivers/block/zram/zram_drv.c   |    7 +--
 drivers/char/raw.c              |   51 ++++++++--------------
 drivers/ide/ide-gd.c            |    2 
 drivers/s390/block/dasd_genhd.c |   13 +----
 fs/block_dev.c                  |   12 ++---
 fs/ocfs2/cluster/heartbeat.c    |   28 ++++--------
 include/linux/blk_types.h       |    4 -
 include/linux/blkdev.h          |    1 
 include/linux/genhd.h           |    2 
 include/linux/suspend.h         |    4 -
 include/linux/swap.h            |    3 -
 kernel/power/swap.c             |   21 +++------
 kernel/power/user.c             |   26 +++--------
 mm/swapfile.c                   |   45 ++++++++++---------
 18 files changed, 119 insertions(+), 224 deletions(-)
