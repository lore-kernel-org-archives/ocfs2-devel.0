From: Christoph Hellwig <hch@lst.de>
Date: Sat, 19 Sep 2020 07:15:20 +0200
Subject: [Ocfs2-devel] [PATCH 02/14] block: switch register_disk to use
 blkdev_get_by_dev
In-Reply-To: <091931b1-eb9c-e45e-c9e8-501554618508@gmail.com>
References: <20200917165720.3285256-1-hch@lst.de>
	<20200917165720.3285256-3-hch@lst.de>
	<091931b1-eb9c-e45e-c9e8-501554618508@gmail.com>
Message-ID: <20200919051520.GA7070@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Minchan Kim <minchan@kernel.org>, Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-pm@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org

On Fri, Sep 18, 2020 at 11:52:39AM +0300, Sergei Shtylyov wrote:
> Hello!
>
> On 17.09.2020 19:57, Christoph Hellwig wrote:
>
>> Use blkdev_get_by_dev instead of open coding it using bdget_disk +
>> blkdev_get.
>
>    I don't see where you are removing bdget_disk() call (situated just before
> the below code?)...

Indeed.  That's what you get for a messy last minute rebase.. :(
