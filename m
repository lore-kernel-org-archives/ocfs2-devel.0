From: Hannes Reinecke <hare@suse.de>
Date: Mon, 6 Jun 2016 08:51:40 +0200
Subject: [Ocfs2-devel] [PATCH 41/45] block, drivers,
	fs: shrink bi_rw from long to int
In-Reply-To: <1465155145-10812-42-git-send-email-mchristi@redhat.com>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
	<1465155145-10812-42-git-send-email-mchristi@redhat.com>
Message-ID: <57551D7C.8000004@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mchristi@redhat.com, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On 06/05/2016 09:32 PM, mchristi at redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> 
> We don't need bi_rw to be so large on 64 bit archs, so
> reduce it to unsigned int.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  block/blk-core.c           | 2 +-
>  drivers/md/dm-flakey.c     | 2 +-
>  drivers/md/raid5.c         | 6 +++---
>  fs/btrfs/check-integrity.c | 4 ++--
>  fs/btrfs/inode.c           | 2 +-
>  include/linux/blk_types.h  | 2 +-
>  6 files changed, 9 insertions(+), 9 deletions(-)
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
