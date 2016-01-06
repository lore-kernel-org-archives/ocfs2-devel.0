From: Bart Van Assche <bart.vanassche@sandisk.com>
Date: Wed, 6 Jan 2016 16:59:26 +0100
Subject: [Ocfs2-devel] [dm-devel] [PATCH 01/35] block/fs/drivers: remove
 rw argument from submit_bio
In-Reply-To: <1452027218-32303-2-git-send-email-mchristi@redhat.com>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
	<1452027218-32303-2-git-send-email-mchristi@redhat.com>
Message-ID: <568D39DE.2060709@sandisk.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: device-mapper development <dm-devel@redhat.com>, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Cc: Mike Christie <mchristi@redhat.com>

On 01/05/2016 09:53 PM, mchristi at redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
>
> This has callers of submit_bio/submit_bio_wait set the bio->bi_rw
> instead of passing it in. This makes that use the same as
> generic_make_request and how we set the other bio fields.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
