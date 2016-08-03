From: Mike Christie <mchristi@redhat.com>
Date: Wed, 3 Aug 2016 18:47:47 -0500
Subject: [Ocfs2-devel] [PATCH 37/45] drivers: use req op accessor
In-Reply-To: <CAOxpaSUMsgfTYsL0bL6VCnwxz7bpgpKO-ZfC5J8dFG9PN-hzvg@mail.gmail.com>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
	<1465155145-10812-38-git-send-email-mchristi@redhat.com>
	<CAOxpaSUMsgfTYsL0bL6VCnwxz7bpgpKO-ZfC5J8dFG9PN-hzvg@mail.gmail.com>
Message-ID: <87fbe31f-27b3-ff7a-e381-34fc1aad337e@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ross Zwisler <zwisler@gmail.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Chinner <david@fromorbit.com>, axboe@fb.com
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, XFS Developers <xfs@oss.sgi.com>, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, LKML <linux-kernel@vger.kernel.org>, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lars.ellenberg@linbit.com, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com

On 08/03/2016 05:33 PM, Ross Zwisler wrote:
> On Sun, Jun 5, 2016 at 1:32 PM,  <mchristi@redhat.com> wrote:
>> From: Mike Christie <mchristi@redhat.com>
>>
>> The req operation REQ_OP is separated from the rq_flag_bits
>> definition. This converts the block layer drivers to
>> use req_op to get the op from the request struct.
>>
>> Signed-off-by: Mike Christie <mchristi@redhat.com>
>> ---
>>  drivers/block/loop.c              |  6 +++---
>>  drivers/block/mtip32xx/mtip32xx.c |  2 +-
>>  drivers/block/nbd.c               |  2 +-
>>  drivers/block/rbd.c               |  4 ++--
>>  drivers/block/xen-blkfront.c      |  8 +++++---
>>  drivers/ide/ide-floppy.c          |  2 +-
>>  drivers/md/dm.c                   |  2 +-
>>  drivers/mmc/card/block.c          |  7 +++----
>>  drivers/mmc/card/queue.c          |  6 ++----
> 
> Dave Chinner reported a deadlock with XFS + DAX, which I reproduced
> and bisected to this commit:
> 
> commit c2df40dfb8c015211ec55f4b1dd0587f875c7b34
> Author: Mike Christie <mchristi@redhat.com>
> Date:   Sun Jun 5 14:32:17 2016 -0500
> drivers: use req op accessor
> 
> Here are the steps to reproduce the deadlock with a BRD ramdisk:
> 
> mkfs.xfs -f /dev/ram0
> mount -o dax /dev/ram0 /mnt/scratch

When using ramdisks, we need the attached patch like in your other bug
report. I think it will fix some hangs people are seeing.

I do not think that it should cause the failure to run issue you saw
when doing generic/008 and ext2.

-------------- next part --------------
A non-text attachment was scrubbed...
Name: convert-rw_page.patch
Type: text/x-patch
Size: 12108 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160803/d47ebf6f/attachment.bin 
