From: Pavel Machek <pavel@ucw.cz>
Date: Mon, 21 Sep 2020 23:46:32 +0200
Subject: [Ocfs2-devel] [PATCH 11/14] PM: rewrite is_hibernate_resume_dev
 to not require an inode
In-Reply-To: <20200921071958.307589-12-hch@lst.de>
References: <20200921071958.307589-1-hch@lst.de>
	<20200921071958.307589-12-hch@lst.de>
Message-ID: <20200921214632.GA11006@amd>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Minchan Kim <minchan@kernel.org>, Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>

On Mon 2020-09-21 09:19:55, Christoph Hellwig wrote:
> Just check the dev_t to help simplifying the code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 181 bytes
Desc: Digital signature
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20200921/584178b1/attachment.bin 
