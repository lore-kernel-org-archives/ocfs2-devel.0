Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 969ABCCA489
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4ofoXbHW0z4UcDjUp7YwjEy71Q9+PCbdl//EViLNB9E=;
 b=Sx/aYo1FgU/rqairpbdqnSyhrxkYm31qX9PurDSo6Vs9uRjgVxDIwXgzTEJZ3nwKKix2qSHLhqt4
   wXpMX0Evuss6rWGjwQrIHX+v8jCxYRQSOOpiUZjOs7tz7gc5uyIm0jMvmO9a9gjWg5A1GXoj8nI0
   0T8IvCyKnqK7J/yM/ye+ipDdTREnUI7SC5CV+/tK8HO9MXxFZ2GZ5eJMrdwC1qrJ8xUVszv3zcBM
   HXmhv37Tt7Dhj1KwghrTokVb33aRN0wrONUUTOcJEMyeoCDtYJkVVRhzLwi365esb2BmvT1jpGd2
   23Lcmc40ftMB6pCSE21927cE3yQw2P6vAqFatw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4ofoXbHW0z4UcDjUp7YwjEy71Q9+PCbdl//EViLNB9E=;
 b=kYVTSkJF/UyoiQ40C1F3BWIUx/TKw9sRwbIuA1v22Ww/3yYLBeq7JHWoFlU+oYjvEs0Yz2iB/MU1
   GkUL6mrLnNnG8Y8rAG/YVeD3M4/cmp//Va/EG9xYtbO3qWOve1K6EBT1P5EEnsjn5O6iU6MBHALE
   M7ZQAlGb9BhYRP6euU6KRcoigpc0//HjMm9I0DtNbXEJ6OgTUe8oWwxVZqgveAOpTH/5MttGxQrl
   qc5qG0NkeXMQtbZPEVN0TgN4blE0QvhHfR6TWZXb5ChMZ7ZMc/Lq3KnjEonfN5mOuYOs8SBH+xOy
   r7HC2lYBbp8+zz0SB7floxuyc207FC2goZsdCQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500H36Z6ANJ70@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 15:03:46 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:In-Reply-To:References;
 bh=C8q0R+e/rBy0+WV0269yeWJ3JYLa6mvxcMU049tzAMQ=; b=CS/ArOOFgUazhgBuVIhXoz92Iz
 tLP1+UzjBKtIQ7Dy/5NVLgAnvWWvYfAukTChPBXBJHel7m/rRcIG1jTO3m2SVgS4dQ2RCnrpnI/2B
 9iKrigIdgG1UysTmv8VlwqX324N8NrztRT9jaBzDbk+mLDdYbNW5pr4mZOlj2VneHAgPoio17IYwj
 m/4vzv2MBPDQc303p8MvgJU+5ViW9y/S2mis6sPjvcMV3XgTzYLKOwdVsPPuf7dw1p/zkAkFsZwEO
 lx/oyhsuVa0FzBkMKs3shdhPr6iBtAans8vQe+2EUQiQ7GyfqEuQkKrwSdQNjedKZMBZwIoJM8JrF
 UgeRmSEA==;
To: linux-fsdevel@vger.kernel.org
Date: Wed,  8 Jun 2022 16:02:30 +0100
Message-id: <20220608150249.3033815-1-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=637 suspectscore=0 mlxscore=0
 phishscore=0 priorityscore=253 bulkscore=0 clxscore=167 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080064 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v2 00/19] Convert aops->migratepage to
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
X-Proofpoint-GUID: E136sSuj1EAVrzFJqieTDJdtTMlaG3ft
X-Proofpoint-ORIG-GUID: E136sSuj1EAVrzFJqieTDJdtTMlaG3ft
Reporting-Meta:
 AAFJzvlLp2cCln5Z2EBafUJcGjnSyo0kDHDiYqsEI1wWnln643FNd2lsQDC2hyrM
 UXQL+J+TY/2cjcwqyRYfzZGn8YsyY/5i/UJaV+/V0xihfU9eh1WUTpKBuKR9DSgR
 iEAW4T45VK2nfFPozGPJcWwMKWKpSC0akpV3CQlzTFO7DifKE04+8ROjppNvkm0F
 KFSJHcXqd8Rxt8ZsEwgvJmo+Hropi6nNj+K2YJmjOxf+GTaTxraDIxkRNT9cAL2d
 B2gZMJ0IzWHjALoAy4d1qz9l0wcq0XlLdGsmS1K9sBpfFQ+J/OfnFQfbEBdVbH+j
 DZaM8KMWs0E55dVfRvKdZlcUzawdU5fYSe+QS/MFjF3rkjwjvcglCo3SNTSHiSz5
 Ix34gltig4O7PhDGdYFdgJ7yzrbYGbKhph2kk/EgplMvlS5HOQSS1PqZJW8pu6aN
 8HXCUMFs/QJ8yHg4lU3I+Pjl5Ya++KYW/evM2Py4dY2YltVdftkg0JVZjOvgLrT8
 J7oa6+H0EmVHAFygY1f84XpMZCwY+8Z5jYWUUFE0krY=

We're getting to the last aops that take a struct page.  The only
remaining ones are ->writepage, ->write_begin, ->write_end and
->error_remove_page.

Changes from v1:
 - Remove ->isolate_page from secretmem
 - Split the movable_operations from address_space_operations
 - Drop the conversions of balloon, zsmalloc and z3fold
 - Fix the build errors with hugetlbfs
 - Fix the kerneldoc errors
 - Fix the ;; typo

Matthew Wilcox (Oracle) (19):
  secretmem: Remove isolate_page
  mm: Convert all PageMovable users to movable_operations
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
  secretmem: Convert to migrate_folio
  fs: Remove aops->migratepage()
  mm/folio-compat: Remove migration compatibility functions

 Documentation/filesystems/locking.rst       |   5 +-
 Documentation/filesystems/vfs.rst           |  13 +-
 Documentation/vm/page_migration.rst         |  33 +--
 arch/powerpc/platforms/pseries/cmm.c        |  60 +----
 block/fops.c                                |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c |   4 +-
 drivers/misc/vmw_balloon.c                  |  61 +----
 drivers/virtio/virtio_balloon.c             |  47 +---
 fs/aio.c                                    |  36 +--
 fs/btrfs/disk-io.c                          |  22 +-
 fs/btrfs/inode.c                            |  26 +--
 fs/ext2/inode.c                             |   4 +-
 fs/ext4/inode.c                             |   4 +-
 fs/f2fs/checkpoint.c                        |   4 +-
 fs/f2fs/data.c                              |  40 +---
 fs/f2fs/f2fs.h                              |   4 -
 fs/f2fs/node.c                              |   4 +-
 fs/gfs2/aops.c                              |   2 +-
 fs/hugetlbfs/inode.c                        |  23 +-
 fs/iomap/buffered-io.c                      |  25 --
 fs/nfs/file.c                               |   4 +-
 fs/nfs/internal.h                           |   6 +-
 fs/nfs/write.c                              |  16 +-
 fs/ntfs/aops.c                              |   6 +-
 fs/ocfs2/aops.c                             |   2 +-
 fs/ubifs/file.c                             |  29 +--
 fs/xfs/xfs_aops.c                           |   2 +-
 fs/zonefs/super.c                           |   2 +-
 include/linux/balloon_compaction.h          |   6 +-
 include/linux/buffer_head.h                 |  10 +
 include/linux/fs.h                          |  20 +-
 include/linux/iomap.h                       |   6 -
 include/linux/migrate.h                     |  48 ++--
 include/linux/page-flags.h                  |   2 +-
 include/linux/pagemap.h                     |   6 +
 include/uapi/linux/magic.h                  |   4 -
 mm/balloon_compaction.c                     |  10 +-
 mm/compaction.c                             |  34 ++-
 mm/folio-compat.c                           |  22 --
 mm/ksm.c                                    |   2 +-
 mm/migrate.c                                | 238 ++++++++++++--------
 mm/migrate_device.c                         |   3 +-
 mm/secretmem.c                              |  13 +-
 mm/shmem.c                                  |   2 +-
 mm/swap_state.c                             |   2 +-
 mm/util.c                                   |   4 +-
 mm/z3fold.c                                 |  82 +------
 mm/zsmalloc.c                               | 102 ++-------
 48 files changed, 367 insertions(+), 735 deletions(-)

-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
