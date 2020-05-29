From: Matthew Wilcox <willy@infradead.org>
Date: Fri, 29 May 2020 13:27:13 -0700
Subject: [Ocfs2-devel] [PATCH v2] blkdev: Replace blksize_bits() with
	ilog2()
In-Reply-To: <20200529141100.37519-1-pilgrimtao@gmail.com>
References: <20200529141100.37519-1-pilgrimtao@gmail.com>
Message-ID: <20200529202713.GC19604@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kaitao Cheng <pilgrimtao@gmail.com>
Cc: axboe@kernel.dk, hch@lst.de, sth@linux.ibm.com, viro@zeniv.linux.org.uk, clm@fb.com, jaegeuk@kernel.org, hch@infradead.org, mark@fasheh.com, dhowells@redhat.com, balbi@kernel.org, damien.lemoal@wdc.com, bvanassche@acm.org, ming.lei@redhat.com, martin.petersen@oracle.com, satyat@google.com, chaitanya.kulkarni@wdc.com, houtao1@huawei.com, asml.silence@gmail.com, ajay.joshi@wdc.com, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, hoeppner@linux.ibm.com, heiko.carstens@de.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com, linux-s390@vger.kernel.org, sagi@grimberg.me, linux-nvme@lists.infradead.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, josef@toxicpanda.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, chao@kernel.org, linux-f2fs-devel@lists.sourceforge.net, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, ocfs2-devel@oss.oracle.com, deepa.kernel@gmail.com

On Fri, May 29, 2020 at 10:11:00PM +0800, Kaitao Cheng wrote:
> There is a function named ilog2() exist which can replace blksize.
> The generated code will be shorter and more efficient on some
> architecture, such as arm64. And ilog2() can be optimized according
> to different architecture.

We'd get the same benefit from a smaller patch with just:

--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1502,15 +1502,9 @@ static inline int blk_rq_aligned(struct request_queue *q, unsigned long addr,
 	return !(addr & alignment) && !(len & alignment);
 }
 
-/* assumes size > 256 */
 static inline unsigned int blksize_bits(unsigned int size)
 {
-	unsigned int bits = 8;
-	do {
-		bits++;
-		size >>= 1;
-	} while (size > 256);
-	return bits;
+	return ilog2(size);
 }
 
 static inline unsigned int block_size(struct block_device *bdev)
