Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E132C46467
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Apr 2022 04:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=aTX7cdVWC6/Q1if+GfE9+DgST+NF0r9K5/TcIxYhVCc=;
 b=EdHZ3IuWOf9fOb1oxduYzPwTP/3GpHK1Q0lz8Dw3hEFEmxrifD3WSdCM4fU6I4kTGyldl5fDE+mH
   nPbpTCU1z/GK7lpamxYejUqPsfby8y0Qi19vdGbDFgCdWy80Te+YAp+XXwJKxnMPFxPHM0VoOlsb
   NLVpjkkp8IS9TyAoI0uOD6Gc8GPNFi642ng7dwuLue0bJOELA0tpkiTuhQUJu56WJLx8jR2NqZ90
   VYnPJsZDFXlWVtxj6gcqCR7+9aWsoc10vntAzS9PWKg5W3IdQLx4Z9OiM0Uhvi2P2SOrPWWqn5bC
   0zv29r0tUIgV0RddFBOpikZkP92ZoWsTYoDtDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=aTX7cdVWC6/Q1if+GfE9+DgST+NF0r9K5/TcIxYhVCc=;
 b=C1PhEfnHEd188QulY87iW7Ii41+gPZa0gHz1H098CHAuqpEp0yH5Ymg+09Hxg5AKMaFqssMT4r/C
   NFY/tL4eU6sSPhscimd2al4DfsXV0Xnqn/Lt2wCZKYia2H7IgjUuOAM9xBW/VQA8cQ7zyGJ7B6O9
   J7qm/gyjPkUWE/rpXwqndnAJjWmb/veRkdA0jWs+3f0mSELTa3JerSCI4RrTc+SNnk0FWFaQSdiW
   HOwXKOi+UKO0znZDlPW/YcfziFYY8pmnKDmdahfXfFoNcLcC1nVthA21PTXU4Xjg8RhC8IdFMdue
   B8gbsa8l8oHikkt7lgQqFN9XDCbJiHxG7xy/rw==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAD00H056YJKTA0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 15 Apr 2022 04:54:19 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:In-Reply-To:References;
 bh=T00AEFQ4LdY1QMdERyaPozZpUOF+QiWNLetpSJJQdDo=; b=4z6KO6NFlCmw6gfLt5PMjkbZbu
 ouT60XDqcfvRhernsRXD0vwaftH4PWGz4g/tfgJxaVQdnBahT9rSu+DPV0LcVWvfqp3gSmaRRdKjo
 LrtjVJU30r+VyvCuJqCpqyJLq+Np0yb+WyGJf7TtEsin5OlECXGHTRm8CUgIrhr286x9pu7HMkFwj
 WRWOTWk+UhMPmcPKIHaMsVI41kiHgzfBLpjBUgT/qUn8kDftheRbfzGB5lKPyfqxPgkVCnkl5qRhd
 TvTcdGJElRmxpcgYx6fNN6THfHB/GfYIgPywakC/rqA7h0nFLzILemkQ8Y3NKIc/JU1eL4CKelMvU
 3Q7Lrsyw==;
To: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Apr 2022 06:52:31 +0200
Message-id: <20220415045258.199825-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10317
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=1 phishscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 clxscore=248 lowpriorityscore=0
 priorityscore=78 mlxscore=1 adultscore=0 mlxlogscore=187 spamscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204150029
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
Subject: [Ocfs2-devel] use block_device based APIs in block layer consumers	v3
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
X-Proofpoint-ORIG-GUID: 8dh8bfBbu3I9gin2gSpG-gD435eFsuPm
X-Proofpoint-GUID: 8dh8bfBbu3I9gin2gSpG-gD435eFsuPm
Reporting-Meta:
 AAEyeEFyuLCl62Mt742PYTS8j297Dg+YFxtjbpYwIS8wegvgn52XDxYIc7e4tfIb
 7QY7q3QrQKCHm8xUz5gjIE3QFGGPZF1IYYNO/IznAK4tmCT5LhzcfFeMCmmVDkda
 8/Vgr1Zq3l732Nj/Kyqi+VjAhJcEIhYt/sMLjF7D/h0B3QfMSCx72YNr1DB1IR04
 Ge7rmofds1hmoKsUEUksOO7oGGyhdgdGDFqCR8mJkkqbi3b+AvGWmTdg9wiGQvr8
 3kLzj45MjEBjz2LEUNvAScB4RmbH3ogmYCbUB8mtIeDtNmhG6BZqsO9gOWxjN9ld
 gZvIZyYFuntLn4xbeu5NdouMv4x5jAi+tFGSLVTtKpRI64jMJxjq06iNl1hpv49d
 VgpwKP6I9GqC0zG9aN/EVecjfsBML3BYdIVhH6o2rzvMNsKse9MHvTzoJ4PvkIlu
 axqtsXqbibWKBAOCWaQNjg8kUxJZcICgGevIKGQ6W17s35E7suaU/9H7tHEZ7H5Y
 E4rFzX/yDOfmNlwUF5Ckyl8tukXpBTuF4SveQlybGKFbQQ==

Hi Jens,

this series cleanups up the block layer API so that APIs consumed
by file systems are (almost) only struct block_devic based, so that
file systems don't have to poke into block layer internals like the
request_queue.

I also found a bunch of existing bugs related to partition offsets
and discard so these are fixed while going along.

Changes since v2:
 - fix an inverted check in btrfs
 - set max_discard_sectors to 0 in all places where the flag was
   previously cleared
 - fix a few sligtly incorrect collected Acks

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
 drivers/block/xen-blkfront.c         |    8 +-
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
 drivers/nvme/host/core.c             |    4 -
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
 89 files changed, 494 insertions(+), 651 deletions(-)

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
