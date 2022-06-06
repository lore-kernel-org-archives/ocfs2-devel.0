Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6179CCA482
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 20:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=BvTXGRhRnR/KiBMTentub4xU/joRNqXMGvgN9BDs898=;
 b=1QSfO83lOsHP/U+Hf93Gts9fNNQ97swLjPd2PO9l3TqcIob/m7SPpMrf9LreR445mOK/Pko49cTr
   qm4AXOw3Qc/t7RVZB5DahFHvPKkM0OVJKwyAVyBlN09B9f7/vXBvJgzV0RUKwFzHdG+yRa/pstB0
   th17CZQxqo22adk0Zf73NODzMJUpXROzeC35SI3w2fNW1q+cpHXxumLnfVP5H0lWPMqmCrQ/iiit
   WIc/JdC5ZxEQWct5d+5QlbEN+qMCE5plT9dUzFfsrSV8KNELY3Tfc989LBoVoqOmG8zMzfSy2AoJ
   XuGjyuBdNHziOC+AfS+lnxVyZnqWz5/ca2Ucyg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=BvTXGRhRnR/KiBMTentub4xU/joRNqXMGvgN9BDs898=;
 b=XrhzEjutshG+ChSl0EwkgKoV2Z87Cherdy50gPWsvIrtEW4L+2QNm3YZPNQSlqBE1SmLv0BBv/cy
   NItR3hZpAV1BLBoGlYjIhLlcrbLDVS8PgjPJFIp9bWiw4++miUT/cXvxGPbvw+CN9OlV84K+3AYp
   DSQLgMCkmg8sphqgeaG5+ZvdvLgcrHiMhgvBBeOQZAzC4t3uTs4CTT4Rh3ogBNqwkwloIq9ogbhA
   FqMv8I7RWekH3y7dhebKO4RqjfNsEyQJnno+JZQIJrJkGvUnkTpb760LsLIgMsFdjdF4nq7XzeUz
   bS4CFmEl3rpt4/KUuHkugYq3j1WsYRcH2qkoFg==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD200CXFPH8G830@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 20:41:32 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=UOfFr2kCuNNQQN1tCbzkVZPiRcxwNuFu8WhD+k3kEbk=; b=flnOFKhza3ughv7JVhOQB3UNwt
 unJkK+04gLu6Kap8iSsI5n17Petv8ajZ5SNf2z85X1sGiGV+/O4at1NY6yYUUh9otQThec0pBNhjV
 LQ3DHGqLZ9wgkV10cm5ylDRcJkF7gW/EYNYxjb7tw+PQI0TNbmMp3G6/DdD6j0PLwN6ftaBG2q963
 iSWRXJtFiCQCMPYSwFs/2b4lt4PVrMv5PTRj/Y/MrNjJP6VatH2fdUtSsL6pkkS9nfDYj1sL4QV6Q
 OU3G9rQbdmhP7nl+qK3wD97RWO0r4M2EPPu0kLi/mPzqSB9/WTtKyiKeYoaJfIGkogFD5ZUkn3fsh
 T5XYWXLg==;
To: linux-fsdevel@vger.kernel.org
Date: Mon,  6 Jun 2022 21:40:38 +0100
Message-id: <20220606204050.2625949-9-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220606204050.2625949-1-willy@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 clxscore=165 malwarescore=0 priorityscore=138 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=718 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060082 domainage_hfrom=8378
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 08/20] mm/migrate: Convert migrate_page() to
	migrate_folio()
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
X-Proofpoint-GUID: ZjBTdBBrnHCLqUaviOkivtY0zmqfuKpU
X-Proofpoint-ORIG-GUID: ZjBTdBBrnHCLqUaviOkivtY0zmqfuKpU
Reporting-Meta:
 AAERZj8mkz0aTDXy/y2S56ygoDSx2v72QWWLs4qfubVg/8QbxdpE2CEZ8CtzASYq
 PVKMMdtYJkgm2kasANXiHQ+olhbxt8sqFbNMGVO7fozDm7hUtPbLLvPOI6w9RHp0
 2ROd4x8o9/2SdRCdsAoKjpehhCHhSKitKkwxg4BgTZ2x+e63gWvZKQrjERjScsGG
 lPeWRvzIsFx508L9njKfOgZ2cV7AbYqZXpAmDIlQcTyLyPGMSa5IOhFmpZVvQ2yT
 qXUYwdo1DPQZoEzBiDrZMJJAkkfBmcwtXhZgQkfXCpWAdtUYNI4J2n90KJOpxMwc
 F0e1t8ga2ilbi3VcJSb/gCw7B9sXmMSIrKQF76LzWgKR6pJzlUP7WR/LGExzjGu+
 UwdYCjhtesGUVFF66zYQlqTWxrUXP1TwiCaYIacH2hqCnTC3RWdFOGAbM6Hu01Jm
 AFwcrmw8hOW3NIlOMAUL8aQwiRe9CyfLvzqB/uLY8MBiYWPgttUiJhtYbMLojiiA
 wZv2eE8+TJLa0m1aNTIduLJnfK3f15Dvl2FdtqkZOa40lw==

Convert all callers to pass a folio.  Most have the folio
already available.  Switch all users from aops->migratepage to
aops->migrate_folio.  Also turn the documentation into kerneldoc.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c |  4 +--
 fs/btrfs/disk-io.c                          |  2 +-
 fs/nfs/write.c                              |  2 +-
 include/linux/migrate.h                     |  5 ++-
 mm/migrate.c                                | 37 +++++++++++----------
 mm/migrate_device.c                         |  3 +-
 mm/shmem.c                                  |  2 +-
 mm/swap_state.c                             |  2 +-
 8 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
index 094f06b4ce33..8423df021b71 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
@@ -216,8 +216,8 @@ i915_gem_userptr_put_pages(struct drm_i915_gem_object *obj,
 			 * However...!
 			 *
 			 * The mmu-notifier can be invalidated for a
-			 * migrate_page, that is alreadying holding the lock
-			 * on the page. Such a try_to_unmap() will result
+			 * migrate_folio, that is alreadying holding the lock
+			 * on the folio. Such a try_to_unmap() will result
 			 * in us calling put_pages() and so recursively try
 			 * to lock the page. We avoid that deadlock with
 			 * a trylock_page() and in exchange we risk missing
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9ceb73f683af..8e5f1fa1e972 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -968,7 +968,7 @@ static int btree_migrate_folio(struct address_space *mapping,
 	if (folio_get_private(src) &&
 	    !filemap_release_folio(src, GFP_KERNEL))
 		return -EAGAIN;
-	return migrate_page(mapping, &dst->page, &src->page, mode);
+	return migrate_folio(mapping, dst, src, mode);
 }
 #else
 #define btree_migrate_folio NULL
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 649b9e633459..69569696dde0 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -2139,7 +2139,7 @@ int nfs_migrate_folio(struct address_space *mapping, struct folio *dst,
 		folio_wait_fscache(src);
 	}
 
-	return migrate_page(mapping, &dst->page, &src->page, mode);
+	return migrate_folio(mapping, dst, src, mode);
 }
 #endif
 
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 069a89e847f3..4ef22806cd8e 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -25,9 +25,8 @@ extern const char *migrate_reason_names[MR_TYPES];
 #ifdef CONFIG_MIGRATION
 
 extern void putback_movable_pages(struct list_head *l);
-extern int migrate_page(struct address_space *mapping,
-			struct page *newpage, struct page *page,
-			enum migrate_mode mode);
+int migrate_folio(struct address_space *mapping, struct folio *dst,
+		struct folio *src, enum migrate_mode mode);
 extern int migrate_pages(struct list_head *l, new_page_t new, free_page_t free,
 		unsigned long private, enum migrate_mode mode, int reason,
 		unsigned int *ret_succeeded);
diff --git a/mm/migrate.c b/mm/migrate.c
index e0a593e5b5f9..6232c291fdb9 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -594,34 +594,37 @@ EXPORT_SYMBOL(folio_migrate_copy);
  *                    Migration functions
  ***********************************************************/
 
-/*
- * Common logic to directly migrate a single LRU page suitable for
- * pages that do not use PagePrivate/PagePrivate2.
+/**
+ * migrate_folio() - Simple folio migration.
+ * @mapping: The address_space containing the folio.
+ * @dst: The folio to migrate the data to.
+ * @src: The folio containing the current data.
+ * @mode: How to migrate the page.
  *
- * Pages are locked upon entry and exit.
+ * Common logic to directly migrate a single LRU folio suitable for
+ * folios that do not use PagePrivate/PagePrivate2.
+ *
+ * Folios are locked upon entry and exit.
  */
-int migrate_page(struct address_space *mapping,
-		struct page *newpage, struct page *page,
-		enum migrate_mode mode)
+int migrate_folio(struct address_space *mapping, struct folio *dst,
+		struct folio *src, enum migrate_mode mode)
 {
-	struct folio *newfolio = page_folio(newpage);
-	struct folio *folio = page_folio(page);
 	int rc;
 
-	BUG_ON(folio_test_writeback(folio));	/* Writeback must be complete */
+	BUG_ON(folio_test_writeback(src));	/* Writeback must be complete */
 
-	rc = folio_migrate_mapping(mapping, newfolio, folio, 0);
+	rc = folio_migrate_mapping(mapping, dst, src, 0);
 
 	if (rc != MIGRATEPAGE_SUCCESS)
 		return rc;
 
 	if (mode != MIGRATE_SYNC_NO_COPY)
-		folio_migrate_copy(newfolio, folio);
+		folio_migrate_copy(dst, src);
 	else
-		folio_migrate_flags(newfolio, folio);
+		folio_migrate_flags(dst, src);
 	return MIGRATEPAGE_SUCCESS;
 }
-EXPORT_SYMBOL(migrate_page);
+EXPORT_SYMBOL(migrate_folio);
 
 #ifdef CONFIG_BLOCK
 /* Returns true if all buffers are successfully locked */
@@ -672,7 +675,7 @@ static int __buffer_migrate_folio(struct address_space *mapping,
 
 	head = folio_buffers(src);
 	if (!head)
-		return migrate_page(mapping, &dst->page, &src->page, mode);
+		return migrate_folio(mapping, dst, src, mode);
 
 	/* Check whether page does not have extra refs before we do more work */
 	expected_count = folio_expected_refs(mapping, src);
@@ -849,7 +852,7 @@ static int fallback_migrate_folio(struct address_space *mapping,
 	    !filemap_release_folio(src, GFP_KERNEL))
 		return mode == MIGRATE_SYNC ? -EAGAIN : -EBUSY;
 
-	return migrate_page(mapping, &dst->page, &src->page, mode);
+	return migrate_folio(mapping, dst, src, mode);
 }
 
 /*
@@ -877,7 +880,7 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 
 	if (likely(is_lru)) {
 		if (!mapping)
-			rc = migrate_page(mapping, &dst->page, &src->page, mode);
+			rc = migrate_folio(mapping, dst, src, mode);
 		else if (mapping->a_ops->migrate_folio)
 			/*
 			 * Most folios have a mapping and most filesystems
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 5052093d0262..5dd97c39ca6a 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -718,7 +718,8 @@ void migrate_vma_pages(struct migrate_vma *migrate)
 			continue;
 		}
 
-		r = migrate_page(mapping, newpage, page, MIGRATE_SYNC_NO_COPY);
+		r = migrate_folio(mapping, page_folio(newpage),
+				page_folio(page), MIGRATE_SYNC_NO_COPY);
 		if (r != MIGRATEPAGE_SUCCESS)
 			migrate->src[i] &= ~MIGRATE_PFN_MIGRATE;
 	}
diff --git a/mm/shmem.c b/mm/shmem.c
index 313ae7df59d8..e37ff6a1a6d0 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3801,7 +3801,7 @@ const struct address_space_operations shmem_aops = {
 	.write_end	= shmem_write_end,
 #endif
 #ifdef CONFIG_MIGRATION
-	.migratepage	= migrate_page,
+	.migrate_folio	= migrate_folio,
 #endif
 	.error_remove_page = shmem_error_remove_page,
 };
diff --git a/mm/swap_state.c b/mm/swap_state.c
index f5b6f5638908..0a2021fc55ad 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -33,7 +33,7 @@ static const struct address_space_operations swap_aops = {
 	.writepage	= swap_writepage,
 	.dirty_folio	= noop_dirty_folio,
 #ifdef CONFIG_MIGRATION
-	.migratepage	= migrate_page,
+	.migrate_folio	= migrate_folio,
 #endif
 };
 
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
