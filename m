Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 603B7C433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 20:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Kxgu6g1TnkTai+uKn5mOtQ9n/11rQyh5xMyHBuPeEZ0=;
 b=diTabPtWwUBTBIvHfOwRPFbSmXKt70Olg2sBkrVwHQgrgKuLXIIHNcjPx2kejpyUVjzANNZtWF9i
   vmjhXwyKEvG1ZDh1YrIdSjlcCNKq/cJgFS+g1g3kq16q7ujh+lWln7EtFVO8EfNd0Zs+C4Y1cAWH
   WiZsWcCy8tHCd/feoIf9tbfjLReN3+/Ek8xNJKJ246hbNnshoNxPAOuplu9nz/tZc6miCXhRUGHG
   Qxwwlvbu+cHSb9k/+qwtj5Ac4lsbMtKAlGcR+HOPv99xIchdt3gNQxTMgpTX/1WJWriJLLu60yT2
   3zvNPDstX34OD0w8USp7AVC+Cq0k9/irjGzm6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Kxgu6g1TnkTai+uKn5mOtQ9n/11rQyh5xMyHBuPeEZ0=;
 b=WVxXQOa6+v9PggeQ1SPvbMpRnDBXSxSWuh4eTKfmqM/Om61+Sm+xIALF8CNmD9synC/2/8SsdzP7
   2EyeqdmCGNNjdkUUUZ/pUG5EQsQh3+rVhb4vY6fPpDjKaSzKIecdVIq6WydypTEvt2hUw3o6I/zc
   wtvfes/28/1Bd82Jo0qAKkQBwtfLbO1ujVDoR7T2n3tBcRzOtWZsFLJOjv4l09Yve4MRBIrIIj8U
   LIt34E8Kjyp8VjkdfD+Y1Ns+wT8IjF3/RpfxcR/AKnrBmxMVn1JBZCpOrSguo36sAzdEZYddWQDd
   PciJc660iZ6gF5AQVHkUqcg+9I+JPFXneh5XfQ==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD200047PHK9NF0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 20:41:44 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:In-Reply-To:References;
 bh=52TXjMDH2lUY3R09liZNjO+IjMsaCFATm2t/b+KQCF8=; b=SZdEFZWXMJtFPOJuECFsGH4n90
 q7ier+E1yPXVQU4Nd1lYIGA05aBdagpFc4iTt8PjgeKc8E++hHnQYInhlsw3wbFpf5nxp3H2fcfme
 0Xx+q8n2owHljzIVuJKc0MDo+cUizE5viLTjZLfP5xwl/nmCSSlMfDWIQiYSrFSnV+41z2epAxAgz
 c5hI+6eJnPB8FSW9f2DBRPcvqpAvUVkxshVm7oCqFdrliaskJ+h+S7JjdTqvzkHPpD7vXrhjHIlQV
 QHRESAfyNVHF1VHQMM7Gir9jrNAHNPAhLTN9Pq43f+cwmm1aYDR8JwDm6N7iYlMQcSUd+o2cWsMba
 zygq/t9A==;
To: linux-fsdevel@vger.kernel.org
Date: Mon,  6 Jun 2022 21:40:30 +0100
Message-id: <20220606204050.2625949-1-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=159 mlxlogscore=371
 mlxscore=0 bulkscore=0 priorityscore=164 phishscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060082 domainage_hfrom=8378
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 00/20] Convert aops->migratepage to
	aops->migrate_folio
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
From: "Matthew Wilcox \(Oracle\) via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "Matthew Wilcox \(Oracle\)" <willy@infradead.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: casper.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: oiLF6c3d7B4jj1wVgMN1leiQyLSPHReh
X-Proofpoint-ORIG-GUID: oiLF6c3d7B4jj1wVgMN1leiQyLSPHReh
Reporting-Meta:
 AAFXxtGUMj8J54SMEkWTY2mXve4ghjX3ept6G3BdyTI5w+lj4lvMemYXvSdaXSM1
 vsLZRT+ifd8a9byx+Fyg0NMj47QHHSfjYYnrjxDWjWR7WzkMs0N6NlT+cgOUG0np
 3bIZYtDPG6uyQRBI/TrTvD25bxtsKQv47+RB2UIewpVPmwPnIFl56PUjydA4N6/x
 PBMirAHjQvdpGcEy8zvGE/4ipnfcKNC5mzAMVp5JZJhPXo2cL3YNTejy6IfA5U3W
 Xil9yb0s/WskTl1DK/6823Xaei8vc1JLR4W8pKB0WieBLaLAPgmrNsQsxgBLKQjV
 IzcmnKxBJe1fy0iDWqv9a1tbQ0UNpc5YaTgrTI9GGuHFjeJPl5KFp4F+ZtvIgpYO
 /9IYxpS3XUWa5yDVr4WjPRaHYb2DN87MjkUQetGkUxOtjM+mQW02UL2DtQO5SLF8
 vz5ERttYR97BwuqGNo+3arQUiGY+m4slIwg0eZpMLKxnJvDcb3uj/ERovIZEKkv9
 IKi19kpg3TPPnJCqZUAZQPo6EWUKVt3JsUrTad6yuq8I

I plan to submit these patches through my pagecache tree in the upcoming
merge window.  I'm pretty happy that most filesystems are now using
common code for ->migrate_folio; it's not something that most filesystem
people want to care about.  I'm running xfstests using xfs against it now,
but it's little more than compile tested for other filesystems.

Matthew Wilcox (Oracle) (20):
  fs: Add aops->migrate_folio
  mm/migrate: Convert fallback_migrate_page() to
    fallback_migrate_folio()
  mm/migrate: Convert writeout() to take a folio
  mm/migrate: Convert buffer_migrate_page() to buffer_migrate_folio()
  mm/migrate: Convert expected_page_refs() to folio_expected_refs()
  btrfs: Convert btree_migratepage to migrate_folio
  nfs: Convert to migrate_folio
  mm/migrate: Convert migrate_page() to migrate_folio()
  mm/migrate: Add filemap_migrate_folio()
  btrfs: Convert btrfs_migratepage to migrate_folio
  ubifs: Convert to filemap_migrate_folio()
  f2fs: Convert to filemap_migrate_folio()
  aio: Convert to migrate_folio
  hugetlb: Convert to migrate_folio
  balloon: Convert to migrate_folio
  secretmem: Convert to migrate_folio
  z3fold: Convert to migrate_folio
  zsmalloc: Convert to migrate_folio
  fs: Remove aops->migratepage()
  mm/folio-compat: Remove migration compatibility functions

 Documentation/filesystems/locking.rst       |   5 +-
 Documentation/filesystems/vfs.rst           |  13 +-
 Documentation/vm/page_migration.rst         |  33 +--
 block/fops.c                                |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c |   4 +-
 fs/aio.c                                    |  36 ++--
 fs/btrfs/disk-io.c                          |  22 +-
 fs/btrfs/inode.c                            |  26 +--
 fs/ext2/inode.c                             |   4 +-
 fs/ext4/inode.c                             |   4 +-
 fs/f2fs/checkpoint.c                        |   4 +-
 fs/f2fs/data.c                              |  40 +---
 fs/f2fs/f2fs.h                              |   4 -
 fs/f2fs/node.c                              |   4 +-
 fs/gfs2/aops.c                              |   2 +-
 fs/hugetlbfs/inode.c                        |  19 +-
 fs/iomap/buffered-io.c                      |  25 ---
 fs/nfs/file.c                               |   4 +-
 fs/nfs/internal.h                           |   6 +-
 fs/nfs/write.c                              |  16 +-
 fs/ntfs/aops.c                              |   6 +-
 fs/ocfs2/aops.c                             |   2 +-
 fs/ubifs/file.c                             |  29 +--
 fs/xfs/xfs_aops.c                           |   2 +-
 fs/zonefs/super.c                           |   2 +-
 include/linux/buffer_head.h                 |  10 +
 include/linux/fs.h                          |  18 +-
 include/linux/iomap.h                       |   6 -
 include/linux/migrate.h                     |  22 +-
 include/linux/pagemap.h                     |   6 +
 mm/balloon_compaction.c                     |  15 +-
 mm/compaction.c                             |   5 +-
 mm/folio-compat.c                           |  22 --
 mm/ksm.c                                    |   2 +-
 mm/migrate.c                                | 217 ++++++++++++--------
 mm/migrate_device.c                         |   3 +-
 mm/secretmem.c                              |   6 +-
 mm/shmem.c                                  |   2 +-
 mm/swap_state.c                             |   2 +-
 mm/z3fold.c                                 |   8 +-
 mm/zsmalloc.c                               |   8 +-
 41 files changed, 287 insertions(+), 379 deletions(-)

-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
