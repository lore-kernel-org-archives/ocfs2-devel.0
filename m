Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D61DC4167E
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Apr 2022 04:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=xlOfcISDke35kXuvjN215OekYYnLf8/4EheyuHhyrpM=;
 b=c/W1KhikCkSS8NJdjmVHjDuiPpI7zQZOFGIVkdh/mYVwJDlcJMITjMTWQKCQKStG+86z/+ib9+X8
   vyGhYEFMDz9IZLkRlcW/WUoU6M2uMt8gAxP8wGszqkOn8J6htScjWG39CiRxezc4Ru35HTrJI7PW
   1UkqIT3AEQCt34Xq8nPqPhcCrpAzj5uXB9wDcNrVMQV14MHQCPD4xWLSfcdHeUBQpFgWQudJ+RTv
   qg8BcZXdZSl9EgLYO+1C3+2q0d8zvcblCteJtq0TRpOHlX9qDhEVJHmY97iw6scNVv7ttpG433kS
   bsy58mR6JU+u0EBgMBIiBbfSeizDSrXgfKeu4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=xlOfcISDke35kXuvjN215OekYYnLf8/4EheyuHhyrpM=;
 b=tiva1WMFVLCY0X8LAgqQul4JeilbHbgLKR+Xs8iag9cqhlhUFv1ZhrBk+PJSjMSz8KhXz0Py6qex
   Vmp9d124Hn12yuTkTCOVKzSYA6c9WUsz/siUMHHB/W56fjkQMwTLhB5Mr4n7aMIVdR50iVZ/UaB1
   7+CBFimEdrW5RBELpB0aEJ7nw58ITXnucsthLWWHXBpPXd/Q1wxDK7z9DCvLJGkQcUH49IfKXn5Y
   wZbTUcOb8FbBpu73QlFvQ425VzGliYA/1nS3CSBW+oKlhiEYh/jTLaBTwNyetylIq15q//3eZf+d
   Bj6KWcJyMEDHuHJDHG1Q/k9BK42sudZEtGAmvg==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA20053C2U4X5C0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 09 Apr 2022 04:51:40 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:In-Reply-To:References;
 bh=xqCE7mrNhx9Kh54A8pTQxucRKOOrbbHmaHFew3/JwbI=; b=eautlETAmAcOF4Rx+ajcsxqxAt
 K/gc85CxDlYY+s5RX+TP4qAcopFOJMKyRoUbJGCZqLzThYN44a81gHztvDtTQOXXVmstC/BiZza91
 +tK8A4YQHg+wud7jKaqcpT5eZw97ewGrhmTU8yf0v/D+yZnMWYW/4nRrMz5fe0RjHIwwo6UCcWnmG
 q/WhOest1iceY98x52QbO+Ryd19aUS/0aFt0A0VdCFkKu7+7IrcjV/rCpnun6L4B6SbhX7D4hKxqE
 vkbaC7lWGA+28JjJD9laatsN4l8Gz9BZIOD3BKi8HF53h/Wb9nBnpD0TIdhkMhGAybm9Za6sdmIlK
 tpLM1eWg==;
To: Jens Axboe <axboe@kernel.dk>
Date: Sat,  9 Apr 2022 06:50:16 +0200
Message-id: <20220409045043.23593-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10311
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=22 spamscore=22
 bulkscore=0 malwarescore=0 priorityscore=48 adultscore=0 clxscore=242
 impostorscore=0 phishscore=0 mlxscore=22 suspectscore=0 mlxlogscore=56
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204090027
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 linux-um@lists.infradead.org, nbd@other.debian.org,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] use block_device based APIs in block layer consumers	v2
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christoph Hellwig <hch@lst.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-ServerName: bombadil.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: qSe8A4DcO9_7OkU4SvpyzMTMiO7gQ3Zd
X-Proofpoint-GUID: qSe8A4DcO9_7OkU4SvpyzMTMiO7gQ3Zd
Reporting-Meta:
 AAELgnk+1MgACV6vYrs58RPsgpmA71XHUI8oWlaheA3mt0h/AI10YBLzEOgrmtbl
 KmEffYJRDvrYY3Pv3jrQK7WVDXAUJ2jlzgo8avv4Ppw5dYeo4aUSOrzrAsPe3+7o
 gwm8PKaM3tCp2+rWc9H/jLK1tmAjs8EAdkVdRmoiTD+66pmlplJm0xbxEtLifMe+
 gVBMLY0ZEaWMpbKHXuwkrejEOXBEK3M9lGGxIZkixUbbdmJJg87llssZodjUwT9e
 wSKC6Gg86VozIxUDtokH3+RTjbkjHIjnHddj03dduBBlUlL0Lm9K2MVyXcG7mp2v
 O+asa/YQp2BHtZhmHyPdCHF5mulFcjseWhxjbwZqNYNuwWpbVinnIVjdrO1AckRP
 aUFAjpyGqzjBQe7X3RbM2UXNInvV+n+5d8hrieWqpvhtGKy9jZztD/ZFDiL9RRjM
 xuwG6BsNfVrPr5SDCBBgtY6+fzJaodIVs9xHlY+6gNnWpL3Uyl5Ex0qNbEb4npeH
 JNFsbv2av7e06g/ZMIIAwroXlMLOaacHMC57fvezEH4T

Hi Jens,

this series cleanups up the block layer API so that APIs consumed
by file systems are (almost) only struct block_devic based, so that
file systems don't have to poke into block layer internals like the
request_queue.

I also found a bunch of existing bugs related to partition offsets
and discard so these are fixed while going along.


Changes since v1:
 - fix a bisection hazard
 - minor spelling fixes
 - reorder hunks between two patches to make the changes more obvious
 - reorder a patch to be earlier in the series to ease backporting


Diffstat:
 arch/um/drivers/ubd_kern.c           |    2 
 block/blk-core.c                     |    4 -
 block/blk-lib.c                      |  124 ++++++++++++++++++++---------------
 block/blk-mq-debugfs.c               |    2 
 block/blk-settings.c                 |   74 ++++++++++++++++++++
 block/blk.h                          |   14 ---
 block/fops.c                         |    2 
 block/genhd.c                        |    4 -
 block/ioctl.c                        |   48 ++++++++++---
 block/partitions/core.c              |   12 ---
 drivers/block/drbd/drbd_main.c       |   51 ++++++--------
 drivers/block/drbd/drbd_nl.c         |   94 +++++++++++---------------
 drivers/block/drbd/drbd_receiver.c   |   13 +--
 drivers/block/loop.c                 |   15 +---
 drivers/block/nbd.c                  |    5 -
 drivers/block/null_blk/main.c        |    1 
 drivers/block/rbd.c                  |    1 
 drivers/block/rnbd/rnbd-clt.c        |    6 -
 drivers/block/rnbd/rnbd-srv-dev.h    |    8 --
 drivers/block/rnbd/rnbd-srv.c        |    5 -
 drivers/block/virtio_blk.c           |    2 
 drivers/block/xen-blkback/blkback.c  |   15 ++--
 drivers/block/xen-blkback/xenbus.c   |    9 --
 drivers/block/xen-blkfront.c         |    7 -
 drivers/block/zram/zram_drv.c        |    1 
 drivers/md/bcache/alloc.c            |    2 
 drivers/md/bcache/request.c          |    4 -
 drivers/md/bcache/super.c            |    3 
 drivers/md/bcache/sysfs.c            |    2 
 drivers/md/dm-cache-target.c         |    9 --
 drivers/md/dm-clone-target.c         |    9 --
 drivers/md/dm-io.c                   |    2 
 drivers/md/dm-log-writes.c           |    3 
 drivers/md/dm-raid.c                 |    9 --
 drivers/md/dm-table.c                |   25 +------
 drivers/md/dm-thin.c                 |   15 ----
 drivers/md/dm.c                      |    3 
 drivers/md/md-linear.c               |   11 ---
 drivers/md/md.c                      |    5 -
 drivers/md/raid0.c                   |    7 -
 drivers/md/raid1.c                   |   18 -----
 drivers/md/raid10.c                  |   20 -----
 drivers/md/raid5-cache.c             |    8 +-
 drivers/md/raid5.c                   |   14 +--
 drivers/mmc/core/queue.c             |    3 
 drivers/mtd/mtd_blkdevs.c            |    1 
 drivers/nvme/host/core.c             |    6 -
 drivers/nvme/target/io-cmd-bdev.c    |    2 
 drivers/nvme/target/zns.c            |    3 
 drivers/s390/block/dasd_fba.c        |    1 
 drivers/scsi/sd.c                    |    2 
 drivers/target/target_core_device.c  |   20 ++---
 drivers/target/target_core_file.c    |   10 +-
 drivers/target/target_core_iblock.c  |   17 +---
 fs/btrfs/disk-io.c                   |    3 
 fs/btrfs/extent-tree.c               |    8 +-
 fs/btrfs/ioctl.c                     |   12 +--
 fs/btrfs/volumes.c                   |    4 -
 fs/btrfs/zoned.c                     |    3 
 fs/direct-io.c                       |   32 +--------
 fs/exfat/file.c                      |    5 -
 fs/exfat/super.c                     |   10 --
 fs/ext4/ioctl.c                      |   10 --
 fs/ext4/mballoc.c                    |   10 +-
 fs/ext4/super.c                      |   10 --
 fs/f2fs/f2fs.h                       |    3 
 fs/f2fs/file.c                       |   19 ++---
 fs/f2fs/segment.c                    |    8 --
 fs/fat/file.c                        |    5 -
 fs/fat/inode.c                       |   10 --
 fs/gfs2/rgrp.c                       |    7 -
 fs/iomap/direct-io.c                 |    3 
 fs/jbd2/journal.c                    |    9 --
 fs/jfs/ioctl.c                       |    5 -
 fs/jfs/super.c                       |    8 --
 fs/nilfs2/ioctl.c                    |    6 -
 fs/nilfs2/sufile.c                   |    4 -
 fs/nilfs2/the_nilfs.c                |    4 -
 fs/ntfs3/file.c                      |    6 -
 fs/ntfs3/super.c                     |   10 +-
 fs/ocfs2/ioctl.c                     |    5 -
 fs/super.c                           |    2 
 fs/xfs/xfs_discard.c                 |    8 +-
 fs/xfs/xfs_log_cil.c                 |    2 
 fs/xfs/xfs_super.c                   |   12 +--
 fs/zonefs/super.c                    |    3 
 include/linux/blkdev.h               |  112 +++++++++++--------------------
 include/target/target_core_backend.h |    4 -
 mm/swapfile.c                        |   31 ++------
 89 files changed, 493 insertions(+), 653 deletions(-)

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
