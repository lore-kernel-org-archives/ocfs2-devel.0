From: Pavel Machek <pavel@ucw.cz>
Date: Sat, 19 Sep 2020 11:06:58 +0200
Subject: [Ocfs2-devel] [PATCH 13/14] PM: mm: cleanup swsusp_swap_check
In-Reply-To: <20200917165720.3285256-14-hch@lst.de>
References: <20200917165720.3285256-1-hch@lst.de>
	<20200917165720.3285256-14-hch@lst.de>
Message-ID: <20200919090658.GB12294@duo.ucw.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Minchan Kim <minchan@kernel.org>, Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org

On Thu 2020-09-17 18:57:19, Christoph Hellwig wrote:
> Use blkdev_get_by_dev instead of bdget + blkdev_get.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 195 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20200919/22f0fcf2/attachment.bin 
