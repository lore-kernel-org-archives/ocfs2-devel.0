From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 29 May 2020 08:13:34 -0600
Subject: [Ocfs2-devel] [PATCH v2] blkdev: Replace blksize_bits() with
	ilog2()
In-Reply-To: <20200529141100.37519-1-pilgrimtao@gmail.com>
References: <20200529141100.37519-1-pilgrimtao@gmail.com>
Message-ID: <c8412d98-0328-0976-e5f9-5beddc148a35@kernel.dk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kaitao Cheng <pilgrimtao@gmail.com>, hch@lst.de, sth@linux.ibm.com, viro@zeniv.linux.org.uk, clm@fb.com, jaegeuk@kernel.org, hch@infradead.org, mark@fasheh.com, dhowells@redhat.com, balbi@kernel.org
Cc: damien.lemoal@wdc.com, bvanassche@acm.org, ming.lei@redhat.com, martin.petersen@oracle.com, satyat@google.com, chaitanya.kulkarni@wdc.com, houtao1@huawei.com, asml.silence@gmail.com, ajay.joshi@wdc.com, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, hoeppner@linux.ibm.com, heiko.carstens@de.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com, linux-s390@vger.kernel.org, sagi@grimberg.me, linux-nvme@lists.infradead.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, josef@toxicpanda.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, chao@kernel.org, linux-f2fs-devel@lists.sourceforge.net, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, ocfs2-devel@oss.oracle.com, deepa.kernel@gmail.com

On 5/29/20 8:11 AM, Kaitao Cheng wrote:
> There is a function named ilog2() exist which can replace blksize.
> The generated code will be shorter and more efficient on some
> architecture, such as arm64. And ilog2() can be optimized according
> to different architecture.

When you posted this last time, I said:

"I like the simplification, but do you have any results to back up
 that claim? Is the generated code shorter? Runs faster?"

which you handily ignored, yet sending out a new version. I'm not
going to apply this without justification, your commit message is
handwavy at best.

-- 
Jens Axboe
