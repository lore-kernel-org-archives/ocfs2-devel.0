From: Christoph Hellwig <hch@lst.de>
Date: Mon, 21 Sep 2020 09:19:44 +0200
Subject: [Ocfs2-devel] remove blkdev_get as a public API v2
Message-ID: <20200921071958.307589-1-hch@lst.de>
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

Changes since v1:
 - fix a mismerged that left a stray bdget_disk around
 - factour the partition scan at registration time code into a new
   helper.

Diffstat:
 block/genhd.c                   |   35 ++++++---------
 block/ioctl.c                   |   13 ++---
 drivers/block/nbd.c             |    8 +--
 drivers/block/pktcdvd.c         |   92 +++++-----------------------------------
 drivers/block/zram/zram_drv.c   |    7 +--
 drivers/char/raw.c              |   51 ++++++++--------------
 drivers/ide/ide-gd.c            |    2 
 drivers/s390/block/dasd_genhd.c |   15 +-----
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
 18 files changed, 130 insertions(+), 239 deletions(-)
