From: Christoph Hellwig <hch@infradead.org>
Date: Sat, 9 Jan 2016 05:39:18 -0800
Subject: [Ocfs2-devel] [PATCH 26/35] block: set op to REQ_OP
In-Reply-To: <1452027218-32303-27-git-send-email-mchristi@redhat.com>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
	<1452027218-32303-27-git-send-email-mchristi@redhat.com>
Message-ID: <20160109133918.GC26660@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mchristi@redhat.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

> @@ -1149,10 +1151,12 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
>  
>  	blk_rq_init(q, rq);
>  	blk_rq_set_rl(rq, rl);
> -	rq->cmd_flags = rw_flags | REQ_ALLOCED;
> +	/* tmp compat - allow users to check either one for the op */
> +	rq->cmd_flags = op | op_flags | REQ_ALLOCED;

This one is still left after the whole series is applied, seems like
the hunk to remove it again got lost somewhere.
