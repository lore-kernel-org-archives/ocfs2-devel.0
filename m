From: Mike Christie <michaelc@cs.wisc.edu>
Date: Sat, 09 Jan 2016 18:43:32 -0600
Subject: [Ocfs2-devel] [PATCH 01/35] block/fs/drivers: remove rw
	argument from submit_bio
In-Reply-To: <20160109133409.GA26660@infradead.org>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
	<1452027218-32303-2-git-send-email-mchristi@redhat.com>
	<20160109133409.GA26660@infradead.org>
Message-ID: <5691A934.8020000@cs.wisc.edu>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>, mchristi@redhat.com
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com

On 01/09/2016 07:34 AM, Christoph Hellwig wrote:
>>  				count);
>> > diff --git a/block/blk-flush.c b/block/blk-flush.c
>> > index 9c423e5..e092e13 100644
>> > --- a/block/blk-flush.c
>> > +++ b/block/blk-flush.c
>> > @@ -484,8 +484,9 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
>> >  
>> >  	bio = bio_alloc(gfp_mask, 0);
>> >  	bio->bi_bdev = bdev;
>> > +	bio->bi_rw |= WRITE_FLUSH;
> Shouldn't the |= be a = here and in many other places?

Yeah, I was trying to merge bi_rw and bio_flags. I am not going to send
that. I will fix up the patchset.
