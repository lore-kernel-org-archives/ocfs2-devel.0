Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E381CCA483
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lFcMbQLwixDaYOzMp4ZkyuNjs+JPj9QybfT+mmbTy5Y=;
 b=d6ZMGKCXmYGGxMXYg/njj+dslEn905MT7TRVpVWGe1BJVett8x/VnSHmjwoM5jSl+CSNEPYi9HIC
   9FSJoMGOdzreVMe5r9ZfbNPm8J+RLb6/GvUsj4oo92Cls/adgtRZy77z8joomUNVtSM9Wf4LtZKf
   9mFbOcslXJMT9URUf+eD4SqH+IPgDEK8oSi2a0mYbRe6dvYgfkdEL5+xyKv9iUpRoObbe64eqw/5
   GzdXUTsD+MkSvA1sXxNhpSlo4yPq+JQbGAb4sCs6XZWkte0z5Dlshrb8TOUMrm2CBeADRn3a5ly7
   txuCKZMzWgWUFZTzpSOZs86rqVHVCMYAuNA2fQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lFcMbQLwixDaYOzMp4ZkyuNjs+JPj9QybfT+mmbTy5Y=;
 b=nFPwFin9qydB9knyIgBx7jUAQ0BVNHP9z4k6tynOqrfZGfMgoc1cR9WHdhGKmzi0R8xcc8OvS04s
   NEUJIjiQDqENYrgaBvfMeG7aJJwGNk7z7jltv1p191YRaKju6gKUBLVYxx85l8ogE7HThr3xhtJs
   KgLgZBKDD8fnRF9KH0H8cnp1Y7ug/TBRl93YqQnhd9nNXx7eQTSzLvalvnOj9X6idFKg8Xg2Vl6J
   xJh1br+mu2G/+47ieSTQXUecDd8jWn56WDrCZwpvdH6Oxg5p81a/u0rQKrOnesN7I5kKdjzMpnVP
   DdP0a++zSmU261gG79Eak/vv+vjco8LEqqQBAw==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500KD0Z5SP340@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 15:03:28 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=XbVWo4LFIMnpLypeZ+7Lc5B8E1XEHzk5ILd65hxC3ZM=; b=NdMPDH68J2UntWT2CatI4mBj+0
 WmU0rqH6YyAV2qlrdwTwgBUvHs23NAZmInZhSoAzKtjAx2G4LR86kpeFHLg2R0f8iITJC4IW4d0IV
 nMraWxOZsnDFbAdH+CZYuDntfePjrjjYdJzQQC5BomNQzwZG3vV9uXB3SWcE1T0mwxn42nELfnU2q
 km/Wgs5QrN3MqSSciW6iq7ETu4aafphheUQ3l02GYajiFIOJ+YY9b38OdAal5HbvjQ5GQGGxQpqMi
 WDh0VRzObxYpHPkclxhBbU4g0EOxGkpjYCUVS4+uTDXh6Jon3TmdObYpoIF+RRW/j01trKDPqhghi
 T3F+tdlg==;
To: linux-fsdevel@vger.kernel.org
Date: Wed,  8 Jun 2022 16:02:41 +0100
Message-id: <20220608150249.3033815-12-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220608150249.3033815-1-willy@infradead.org>
References: <20220608150249.3033815-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=163
 priorityscore=220 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=434
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080064 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v2 11/19] mm/migrate: Add	filemap_migrate_folio()
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
X-Proofpoint-GUID: CCnMyPiMFE38WXr3-DPcZFrQfWlAsTTd
X-Proofpoint-ORIG-GUID: CCnMyPiMFE38WXr3-DPcZFrQfWlAsTTd
Reporting-Meta:
 AAGjXyIb6458fDRJDI1QKr+JDVffK0FVnidx1fuGaDsir/6rgxwcfheqlLMrIXrN
 KzScUox46Wlj2eSyX87NqIWl5Byu2TGBwDOUKmqlUzc/OSXgigBeVHtSIrubTEAW
 gIg+MZ97t9iuavP9czZ6lcoqBmuOLMkezowQbJPhJEMhouxK5Twg50T+UXsOlDJm
 UHl87dUzv79dg52Bigyt+pCZWwm9nAlQYKjFUqB/6z5TJ7FZtn8knFy6JA7aRQXq
 khiI8W9qu/FbOuFbXq/OepX8scSS5UBKPDi/LuYLacqucNj0jUf0ySTL0Zk34lhF
 l+5k/I1H9HqL4m//JT/+gcZZcKEt4nSc0xbhAPevq7VHUXhPUuLZZgHgtoToWUgb
 c/e+1fUH49DMK8S0BVPGOQSj8h9KnAKv3EdHDz3sr6aamwPVNd07DkB2BoQ3OnKg
 UIzTJbIoiXpiL9S7xdIVzPwkCG5/7s7iBm47voXUO6HyJ8UUfcMcJ1ofwKCmi38t
 Uh/6eK++KQTp9eT9oQLnuaW2xttC4G7kfYV834hqhigX

There is nothing iomap-specific about iomap_migratepage(), and it fits
a pattern used by several other filesystems, so move it to mm/migrate.c,
convert it to be filemap_migrate_folio() and convert the iomap filesystems
to use it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/gfs2/aops.c          |  2 +-
 fs/iomap/buffered-io.c  | 25 -------------------------
 fs/xfs/xfs_aops.c       |  2 +-
 fs/zonefs/super.c       |  2 +-
 include/linux/iomap.h   |  6 ------
 include/linux/pagemap.h |  6 ++++++
 mm/migrate.c            | 20 ++++++++++++++++++++
 7 files changed, 29 insertions(+), 34 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 106e90a36583..57ff883d432c 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -774,7 +774,7 @@ static const struct address_space_operations gfs2_aops = {
 	.invalidate_folio = iomap_invalidate_folio,
 	.bmap = gfs2_bmap,
 	.direct_IO = noop_direct_IO,
-	.migratepage = iomap_migrate_page,
+	.migrate_folio = filemap_migrate_folio,
 	.is_partially_uptodate = iomap_is_partially_uptodate,
 	.error_remove_page = generic_error_remove_page,
 };
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 66278a14bfa7..5a91aa1db945 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -489,31 +489,6 @@ void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len)
 }
 EXPORT_SYMBOL_GPL(iomap_invalidate_folio);
 
-#ifdef CONFIG_MIGRATION
-int
-iomap_migrate_page(struct address_space *mapping, struct page *newpage,
-		struct page *page, enum migrate_mode mode)
-{
-	struct folio *folio = page_folio(page);
-	struct folio *newfolio = page_folio(newpage);
-	int ret;
-
-	ret = folio_migrate_mapping(mapping, newfolio, folio, 0);
-	if (ret != MIGRATEPAGE_SUCCESS)
-		return ret;
-
-	if (folio_test_private(folio))
-		folio_attach_private(newfolio, folio_detach_private(folio));
-
-	if (mode != MIGRATE_SYNC_NO_COPY)
-		folio_migrate_copy(newfolio, folio);
-	else
-		folio_migrate_flags(newfolio, folio);
-	return MIGRATEPAGE_SUCCESS;
-}
-EXPORT_SYMBOL_GPL(iomap_migrate_page);
-#endif /* CONFIG_MIGRATION */
-
 static void
 iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
 {
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 8ec38b25187b..5d1a995b15f8 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -570,7 +570,7 @@ const struct address_space_operations xfs_address_space_operations = {
 	.invalidate_folio	= iomap_invalidate_folio,
 	.bmap			= xfs_vm_bmap,
 	.direct_IO		= noop_direct_IO,
-	.migratepage		= iomap_migrate_page,
+	.migrate_folio		= filemap_migrate_folio,
 	.is_partially_uptodate  = iomap_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
 	.swap_activate		= xfs_iomap_swapfile_activate,
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index bcb21aea990a..d4c3f28f34ee 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -237,7 +237,7 @@ static const struct address_space_operations zonefs_file_aops = {
 	.dirty_folio		= filemap_dirty_folio,
 	.release_folio		= iomap_release_folio,
 	.invalidate_folio	= iomap_invalidate_folio,
-	.migratepage		= iomap_migrate_page,
+	.migrate_folio		= filemap_migrate_folio,
 	.is_partially_uptodate	= iomap_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
 	.direct_IO		= noop_direct_IO,
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index e552097c67e0..758a1125e72f 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -231,12 +231,6 @@ void iomap_readahead(struct readahead_control *, const struct iomap_ops *ops);
 bool iomap_is_partially_uptodate(struct folio *, size_t from, size_t count);
 bool iomap_release_folio(struct folio *folio, gfp_t gfp_flags);
 void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len);
-#ifdef CONFIG_MIGRATION
-int iomap_migrate_page(struct address_space *mapping, struct page *newpage,
-		struct page *page, enum migrate_mode mode);
-#else
-#define iomap_migrate_page NULL
-#endif
 int iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 		const struct iomap_ops *ops);
 int iomap_zero_range(struct inode *inode, loff_t pos, loff_t len,
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 1caccb9f99aa..2a67c0ad7348 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1078,6 +1078,12 @@ static inline int __must_check write_one_page(struct page *page)
 int __set_page_dirty_nobuffers(struct page *page);
 bool noop_dirty_folio(struct address_space *mapping, struct folio *folio);
 
+#ifdef CONFIG_MIGRATION
+int filemap_migrate_folio(struct address_space *mapping, struct folio *dst,
+		struct folio *src, enum migrate_mode mode);
+#else
+#define filemap_migrate_folio NULL
+#endif
 void page_endio(struct page *page, bool is_write, int err);
 
 void folio_end_private_2(struct folio *folio);
diff --git a/mm/migrate.c b/mm/migrate.c
index 785e32d0cf1b..4d8115ca93bb 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -784,6 +784,26 @@ int buffer_migrate_folio_norefs(struct address_space *mapping,
 }
 #endif
 
+int filemap_migrate_folio(struct address_space *mapping,
+		struct folio *dst, struct folio *src, enum migrate_mode mode)
+{
+	int ret;
+
+	ret = folio_migrate_mapping(mapping, dst, src, 0);
+	if (ret != MIGRATEPAGE_SUCCESS)
+		return ret;
+
+	if (folio_get_private(src))
+		folio_attach_private(dst, folio_detach_private(src));
+
+	if (mode != MIGRATE_SYNC_NO_COPY)
+		folio_migrate_copy(dst, src);
+	else
+		folio_migrate_flags(dst, src);
+	return MIGRATEPAGE_SUCCESS;
+}
+EXPORT_SYMBOL_GPL(filemap_migrate_folio);
+
 /*
  * Writeback a folio to clean the dirty state
  */
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
