From: Christoph Hellwig <hch@lst.de>
Date: Mon, 21 Sep 2020 09:19:57 +0200
Subject: [Ocfs2-devel] [PATCH 13/14] PM: mm: cleanup swsusp_swap_check
In-Reply-To: <20200921071958.307589-1-hch@lst.de>
References: <20200921071958.307589-1-hch@lst.de>
Message-ID: <20200921071958.307589-14-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>, Minchan Kim <minchan@kernel.org>, Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>

Use blkdev_get_by_dev instead of bdget + blkdev_get.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 kernel/power/swap.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 9d3ffbfe08dbf6..71385bedcc3a49 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -343,12 +343,10 @@ static int swsusp_swap_check(void)
 		return res;
 	root_swap = res;
 
-	hib_resume_bdev = bdget(swsusp_resume_device);
-	if (!hib_resume_bdev)
-		return -ENOMEM;
-	res = blkdev_get(hib_resume_bdev, FMODE_WRITE, NULL);
-	if (res)
-		return res;
+	hib_resume_bdev = blkdev_get_by_dev(swsusp_resume_device, FMODE_WRITE,
+			NULL);
+	if (IS_ERR(hib_resume_bdev))
+		return PTR_ERR(hib_resume_bdev);
 
 	res = set_blocksize(hib_resume_bdev, PAGE_SIZE);
 	if (res < 0)
-- 
2.28.0
