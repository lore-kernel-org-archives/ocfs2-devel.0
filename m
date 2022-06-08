Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0589CCA48D
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=BpypHyc673DnTFLmzWkVkHrsmovtEOH03tekLChDBHY=;
 b=LOxBq53eQidszo4e5Kb1i7DBecOohT6Iy4NhSw/oheXJaawsZQZCyCuluedAt41hfRbL2w4y1JdX
   yWv/6sL//niyGvAFsLKdDTtJ/X3o6SD/fAWiph0ceHVaZplKTDzTB73w8fAkfzeFNXZJWW0zuvXK
   dKLS2YvlxQIqrTSpK5s4Sv0awTl/zOp/q0HHRNsSi/o0kw0ZIGWS16goR/BgJdPKklpvJmObbLgg
   h9CIlBWPz6e1PWFCHrbKMe2ob3ts7gDglkKNx8lQ/5eoSnnsngh82/OQ7YJ+SXkF3yokh/bvodWU
   90UIBZHeqyNd8hXCoJcxz2hkWyUcPPKIoBTNHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=BpypHyc673DnTFLmzWkVkHrsmovtEOH03tekLChDBHY=;
 b=fwqAR+Rb98JytUKMRC/wuT7ipT0AUaSkDi80OEZ6C/BgTUvvJ+3EbNKQZ0RjdHsfjJWsDZWmIbfg
   fOtBRJ1P+t+A3cvb/7ysnEvGgZewfjWY+51chuaPKLJKg1Uc0r+EQPuvWlhNwrlzAn+YIu70waE0
   g4aEWAlCYfl8kP3fEbw5oaD4mvRm0x+hYknyOliZ3iQLexiXjNTGchFJYR530DUImgnL4rP6usdF
   N7U+njExjqJJvTtsxAPTipB30Go4T/x8YeTSyJfpHgg1J5F0C6aAxyWrDR74JsxBtm9Loh1bThnE
   XvkUAuILCBGUAd+DBQssJ8O5cqvONDws3QJSkQ==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500747Z6AOGF0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 15:03:46 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=5npsXdc68IkdHS9QQplhoGS3mgY+20vmpxeIh5k5guo=; b=rXc5AtDvvG/hpa8vIqf6R/xPw6
 UrL+UsKwmXkyxMDVbzTujwyYLJghxfRH0Y7eFEuTzXeh86YeTZSNKnJAoOk2pT9ySfX0BDNY0qoWf
 c4S41cnxl9Vs1Uv12emgfIP+2QwFm7qe5ajKnz2gRn0OZ8/pvGgtsH2hFBxivh+TWayhD2uWm91po
 r5gpL3IQVa82F0QOi8df2oIU4B0IbUcBa/7kE5VbK1SmP360/uLbJZMvBxXy81emTvrRMM8EsTr5I
 AIcJ+wWTSDwunW6H2g3K8ov7+QfKhotHG6sv9TDj0IMbxfaYaI+1wzgwFqX5SjiNRGBVEYir/fv6U
 eTdszuHg==;
To: linux-fsdevel@vger.kernel.org
Date: Wed,  8 Jun 2022 16:02:49 +0100
Message-id: <20220608150249.3033815-20-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220608150249.3033815-1-willy@infradead.org>
References: <20220608150249.3033815-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=503 suspectscore=0 mlxscore=0
 phishscore=0 priorityscore=220 bulkscore=0 clxscore=163 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080064 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v2 19/19] mm/folio-compat: Remove migration
	compatibility functions
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
X-Proofpoint-ORIG-GUID: 7C7mHaGyc1Ig2qQCucdVWDqc1WVMxiKa
X-Proofpoint-GUID: 7C7mHaGyc1Ig2qQCucdVWDqc1WVMxiKa
Reporting-Meta:
 AAHJO9aEsJOTJwAsJu37n/pbcHb37DX0hLGjbNmU78lmr8/QNzH19izNQ2HZfEz0
 rKzfV6cnkaBWzlDfdb6Ykr0VlmaS56suk5SuqPT1Y0qcIYpiICXSHiq9jWgQkhim
 Xxn4xBbJxiQJSbjZYKPHEKO1Sa43rkzouBBTX0KQ5Z2+A9Y8WzXHBQOC9UEU3x3M
 UMLAB3RqfA/mr/Wt7SOUG1brcPIBGy47GhaNrHogTgl9uoiQXgc4ZPoHwUmiaNa3
 JfMT053vfdQdhKhvJvKISPWp+Y9iSKbdF9NnB6i/NLYHF1YGDluLgXf9vEhGdfzA
 PSuzwLtzvexwKkkvf2IJr/5fujz8A3AaNyaaHB41yQgsScd+yoSTsakB8Rl98SGl
 UzShzYABoOZoisuG8f4cR59ISBmoQW+6ylIZvX11qM3XFfS3PUYzouVYmVp+EWv9
 HKKGfc0G+wQD7nRZXFidDbIC0Cyq0FthV0hNTGkBwODeMXfQQfx6dR2vHYlgfqRn
 mgGSo5+VoP8Mn7BpiXel+ioOkWL2O69K9GmRYQNl7AU=

migrate_page_move_mapping(), migrate_page_copy() and migrate_page_states()
are all now unused after converting all the filesystems from
aops->migratepage() to aops->migrate_folio().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/migrate.h | 11 -----------
 mm/folio-compat.c       | 22 ----------------------
 mm/ksm.c                |  2 +-
 3 files changed, 1 insertion(+), 34 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 59d64a1e6b4b..3e18c7048506 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -40,12 +40,8 @@ extern int migrate_pages(struct list_head *l, new_page_t new, free_page_t free,
 extern struct page *alloc_migration_target(struct page *page, unsigned long private);
 extern int isolate_movable_page(struct page *page, isolate_mode_t mode);
 
-extern void migrate_page_states(struct page *newpage, struct page *page);
-extern void migrate_page_copy(struct page *newpage, struct page *page);
 int migrate_huge_page_move_mapping(struct address_space *mapping,
 		struct folio *dst, struct folio *src);
-extern int migrate_page_move_mapping(struct address_space *mapping,
-		struct page *newpage, struct page *page, int extra_count);
 void migration_entry_wait_on_locked(swp_entry_t entry, pte_t *ptep,
 				spinlock_t *ptl);
 void folio_migrate_flags(struct folio *newfolio, struct folio *folio);
@@ -66,13 +62,6 @@ static inline struct page *alloc_migration_target(struct page *page,
 static inline int isolate_movable_page(struct page *page, isolate_mode_t mode)
 	{ return -EBUSY; }
 
-static inline void migrate_page_states(struct page *newpage, struct page *page)
-{
-}
-
-static inline void migrate_page_copy(struct page *newpage,
-				     struct page *page) {}
-
 static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
 				  struct folio *dst, struct folio *src)
 {
diff --git a/mm/folio-compat.c b/mm/folio-compat.c
index 20bc15b57d93..458618c7302c 100644
--- a/mm/folio-compat.c
+++ b/mm/folio-compat.c
@@ -51,28 +51,6 @@ void mark_page_accessed(struct page *page)
 }
 EXPORT_SYMBOL(mark_page_accessed);
 
-#ifdef CONFIG_MIGRATION
-int migrate_page_move_mapping(struct address_space *mapping,
-		struct page *newpage, struct page *page, int extra_count)
-{
-	return folio_migrate_mapping(mapping, page_folio(newpage),
-					page_folio(page), extra_count);
-}
-EXPORT_SYMBOL(migrate_page_move_mapping);
-
-void migrate_page_states(struct page *newpage, struct page *page)
-{
-	folio_migrate_flags(page_folio(newpage), page_folio(page));
-}
-EXPORT_SYMBOL(migrate_page_states);
-
-void migrate_page_copy(struct page *newpage, struct page *page)
-{
-	folio_migrate_copy(page_folio(newpage), page_folio(page));
-}
-EXPORT_SYMBOL(migrate_page_copy);
-#endif
-
 bool set_page_writeback(struct page *page)
 {
 	return folio_start_writeback(page_folio(page));
diff --git a/mm/ksm.c b/mm/ksm.c
index 54f78c9eecae..e8f8c1a2bb39 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -712,7 +712,7 @@ static struct page *get_ksm_page(struct stable_node *stable_node,
 	 * however, it might mean that the page is under page_ref_freeze().
 	 * The __remove_mapping() case is easy, again the node is now stale;
 	 * the same is in reuse_ksm_page() case; but if page is swapcache
-	 * in migrate_page_move_mapping(), it might still be our page,
+	 * in folio_migrate_mapping(), it might still be our page,
 	 * in which case it's essential to keep the node.
 	 */
 	while (!get_page_unless_zero(page)) {
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
