From: Christoph Hellwig <hch@lst.de>
Date: Tue, 2 Jun 2020 07:51:52 +0200
Subject: [Ocfs2-devel] [PATCH v2] blkdev: Replace blksize_bits() with
	ilog2()
In-Reply-To: <20200601084426.GB1667318@kroah.com>
References: <20200529141100.37519-1-pilgrimtao@gmail.com>
	<c8412d98-0328-0976-e5f9-5beddc148a35@kernel.dk>
	<CAAWJmAZOQQQeNiTr48OSRRdO2pG+q4c=6gjT55CkWC5FN=HXmA@mail.gmail.com>
	<20200601084426.GB1667318@kroah.com>
Message-ID: <20200602055152.GA11620@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tao pilgrim <pilgrimtao@gmail.com>, Jens Axboe <axboe@kernel.dk>, hch@lst.de, sth@linux.ibm.com, viro@zeniv.linux.org.uk, clm@fb.com, jaegeuk@kernel.org, hch@infradead.org, Mark Fasheh <mark@fasheh.com>, dhowells@redhat.com, balbi@kernel.org, damien.lemoal@wdc.com, bvanassche@acm.org, ming.lei@redhat.com, martin.petersen@oracle.com, satyat@google.com, chaitanya.kulkarni@wdc.com, houtao1@huawei.com, asml.silence@gmail.com, ajay.joshi@wdc.com, linux-kernel@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, hoeppner@linux.ibm.com, heiko.carstens@de.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com, linux-s390@vger.kernel.org, sagi@grimberg.me, linux-nvme@lists.infradead.org, linux-usb@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, dsterba@suse.com, linux-btrfs@vger.kernel.org, chao@kernel.org, linux-f2fs-devel@lists.sourceforge.net, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, ocfs2-devel@oss.oracle.com, deepa.kernel@gmail.com

On Mon, Jun 01, 2020 at 10:44:26AM +0200, Greg KH wrote:
> But does this code path actually show up anywhere that is actually
> measurable as mattering?
> 
> If so, please show that benchmark results.

I think the requests are starting to be a bit unreasonable.  Tao is
replacing a reimplementation of a standard function with that standard
function / compiler builtin.  We don't put such a high burden on that.

And once the proper existing fields are used where possible as shown
in my reply just replacing the rest seems totally obvious - quite
contrary I think keeping a reimplementation would need a high bar.
