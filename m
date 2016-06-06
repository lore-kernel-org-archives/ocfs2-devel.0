From: Hannes Reinecke <hare@suse.de>
Date: Mon, 6 Jun 2016 08:50:19 +0200
Subject: [Ocfs2-devel] [PATCH 37/45] drivers: use req op accessor
In-Reply-To: <1465155145-10812-38-git-send-email-mchristi@redhat.com>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
	<1465155145-10812-38-git-send-email-mchristi@redhat.com>
Message-ID: <57551D2B.1090707@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mchristi@redhat.com, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On 06/05/2016 09:32 PM, mchristi at redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> 
> The req operation REQ_OP is separated from the rq_flag_bits
> definition. This converts the block layer drivers to
> use req_op to get the op from the request struct.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/block/loop.c              |  6 +++---
>  drivers/block/mtip32xx/mtip32xx.c |  2 +-
>  drivers/block/nbd.c               |  2 +-
>  drivers/block/rbd.c               |  4 ++--
>  drivers/block/xen-blkfront.c      |  8 +++++---
>  drivers/ide/ide-floppy.c          |  2 +-
>  drivers/md/dm.c                   |  2 +-
>  drivers/mmc/card/block.c          |  7 +++----
>  drivers/mmc/card/queue.c          |  6 ++----
>  drivers/mmc/card/queue.h          |  5 ++++-
>  drivers/mtd/mtd_blkdevs.c         |  2 +-
>  drivers/nvme/host/core.c          |  2 +-
>  drivers/nvme/host/nvme.h          |  4 ++--
>  drivers/scsi/sd.c                 | 25 ++++++++++++++++---------
>  14 files changed, 43 insertions(+), 34 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare at suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N?rnberg
GF: F. Imend?rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N?rnberg)
