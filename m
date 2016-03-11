From: Doug Ledford <dledford@redhat.com>
Date: Fri, 11 Mar 2016 02:19:08 -0000
Subject: [Ocfs2-devel] [PATCH] configfs: switch ->default groups to a
	linked list
In-Reply-To: <1456615342.1750.49.camel@haakon3.risingtidesystems.com>
References: <1456490031-7132-1-git-send-email-hch@lst.de>
	<1456615342.1750.49.camel@haakon3.risingtidesystems.com>
Message-ID: <56E22B15.1030000@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>
Cc: jlbec@evilplan.org, balbi@kernel.org, laurent.pinchart@ideasonboard.com, target-devel@vger.kernel.org, linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On 02/27/2016 06:22 PM, Nicholas A. Bellinger wrote:
> On Fri, 2016-02-26 at 13:33 +0100, Christoph Hellwig wrote:
>> Replace the current NULL-terminated array of default groups with a linked
>> list.  This gets rid of lots of nasty code to size and/or dynamically
>> allocate the array.
>>
>> While we're at it also provide a conveniant helper to remove the default
>> groups.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>>  Documentation/filesystems/configfs/configfs.txt |  11 +-
>>  drivers/infiniband/core/cma_configfs.c          |  31 ++--
>>  drivers/target/iscsi/iscsi_target_configfs.c    |  75 +++------
>>  drivers/target/target_core_configfs.c           | 203 +++++-------------------
>>  drivers/target/target_core_fabric_configfs.c    | 194 ++++++----------------
>>  drivers/target/target_core_internal.h           |   1 -
>>  drivers/target/target_core_stat.c               |  41 ++---
>>  drivers/usb/gadget/configfs.c                   |  36 ++---
>>  drivers/usb/gadget/function/f_mass_storage.c    |   6 +-
>>  drivers/usb/gadget/function/f_rndis.c           |   1 -
>>  drivers/usb/gadget/function/uvc_configfs.c      | 198 +++++++++--------------
>>  fs/configfs/dir.c                               |  44 +++--
>>  fs/configfs/item.c                              |   1 +
>>  fs/dlm/config.c                                 |  38 +----
>>  fs/ocfs2/cluster/nodemanager.c                  |  22 +--
>>  include/linux/configfs.h                        |  11 +-
>>  include/target/target_core_base.h               |   3 -
>>  17 files changed, 284 insertions(+), 632 deletions(-)
>>
> 
> This is a very nice simplification to drop the long-standing fixed size
> ->default_groups[] usage tree-wide for configfs consumers.
> 
> For the target parts:
> 
> Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>

For the (minor) RDMA parts:

Acked-by: Doug Ledford <dledford@redhat.com>

> Also, this applies cleanly to target-pending/for-next, so I don't see a
> problem merging it up via your new configfs tree.
> 
> Otherwise let me know, and I'll be happy to merge via target-pending.

Given that it touches target more than anything else, I'm happy to see
it merged through your tree.


-- 
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD


-------------- next part --------------
A non-text attachment was scrubbed...
Name: signature.asc
Type: application/pgp-signature
Size: 884 bytes
Desc: OpenPGP digital signature
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20160311/f588aa7e/attachment.bin 
