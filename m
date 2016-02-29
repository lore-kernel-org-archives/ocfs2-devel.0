From: Mike Christie <michaelc@cs.wisc.edu>
Date: Mon, 29 Feb 2016 11:30:22 -0600
Subject: [Ocfs2-devel] [PATCH 00/35 v4] separate operations from flags
 in the bio/request structs
In-Reply-To: <20160229171339.GA17755@infradead.org>
References: <1456343292-14535-1-git-send-email-mchristi@redhat.com>
	<20160229171339.GA17755@infradead.org>
Message-ID: <56D4802E.3090507@cs.wisc.edu>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>, mchristi@redhat.com
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com

On 02/29/2016 11:13 AM, Christoph Hellwig wrote:
> Any reason you've dropped my ACK for the previous version?

Sorry. I think I accidentally dropped it when I rebased back over to
linux-next. It looks like it only got stuck on the first patch. I will
fix that up on the resend for those kbuild errors.
