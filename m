Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E752BCCA489
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 20:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=V+9CehEAPPuI3fNIUY2ajjDOqqoujhvpYab3d8y00Lw=;
 b=2kTIN65DkNByLxb8Sd8SWW3jGJlyGjvE3Daednvt7NKsv9CP/mw7AN7jbneJ6Nyfw/OzkpQ+IdEZ
   zDXzaQUZzExjVdV5GDZJvDXfRipxWKwJ3lPvLfq/QEOEXIGuhfozLCDF+lVWqVBP9j4tDQciG+x4
   92SAokLnqrfJkRL0vRpZjqOXOGLqc526u0E/1UGwuwiPZQpWvujcb5am46piQnxSfI16drgFZ9Eg
   y2jfxaLspzHPLq+e/guwdfg1osKb7q2es/Pi+FKOtzzhFm9TSp6WMtDB8Jlti2VbWlszQP99GCkW
   7yLPTb01w6wQcVYTGjYXdJyAo0JeZmFMvfcWwQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=V+9CehEAPPuI3fNIUY2ajjDOqqoujhvpYab3d8y00Lw=;
 b=kK/HTbD00hD5muIhMO2PaRqIxEauUFb4B8CBh2CRxEMS0oJ8rKcFUsYz5fp2EkN7OlQ3chod2HBE
   6d7fYKmR5ap7xWVr9xNkPd75NTK3hnkVXW4XrMyaFlBJahfW7DRhQA9f12z5WHG3wchKPugzsUjP
   IlW1Flc34KDvV8z6Xk+VGXb50fHJl/kFI/CAx7rjkGo94AEGii8GSibITdIg/kM1CpN8RCrUBTTx
   7zPEfcaVdNEwGxzN1YVOFkqxhTxPl6bHQv4swMQI4oF8XdMz61GtxMlOe5UWu5IURD7be/InmJ1x
   AqrSUE6fqwVs6yS4IXK5tFjWLQSnBrFyVXOyuQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD200CP6PHBLS30@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 20:41:35 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=quK8OUavZ3OQPvhjOxFusobdtZi/WBT8qXGvQ++yDug=; b=tGIvKVNaAMu+xJKfT56my7OcDx
 h9X6EZkV+3b6YmzNyoYE3J6PNxC8ld3BfaS12Hr37OHw34qvlxQU6NGjNQ/dhsoPlowRv53o4VZC8
 91hwnrb/Zx7IV1o0tPxKat0n3HHdibhLf1anGJsS6EN4ly8FblGaD7fyrz5/ADem0hQXlXK2IoJvA
 sPpCKXuC4FxWa83HkItcygw65l/Lm7ADmBY+uIWsBaElOylJp/RskeiJHQuGZ0eifLCpWGHHcEWMR
 60Qcs3Ka1CFA2jYOxR4TNlZ/5Tzf5uG0HfDIKzfTaxNpzixl4yt2Na7VkKuOo78WUgHz+NeXqWgXa
 nGtfT5aA==;
To: linux-fsdevel@vger.kernel.org
Date: Mon,  6 Jun 2022 21:40:50 +0100
Message-id: <20220606204050.2625949-21-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220606204050.2625949-1-willy@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=165 mlxlogscore=479
 mlxscore=0 bulkscore=0 priorityscore=108 phishscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060082 domainage_hfrom=8378
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 20/20] mm/folio-compat: Remove migration
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
X-Proofpoint-GUID: plaom_dgnwYDorRDDhFeZFJzj9Gxok7B
X-Proofpoint-ORIG-GUID: plaom_dgnwYDorRDDhFeZFJzj9Gxok7B
Reporting-Meta:
 AAF+vZBWuqLKC6usvZHinyb0SmD4DKO0jDi7uG/wvmazqRqZXze/vVflvuW+2aQ5
 h5WPpgSaHOzsalLcvu9gCOtsgjdKmVxIhET3yaxlxFLF3/iHivjZdA6H9NA0fD7Y
 EY0uwtgvb4osqwc48Zp3ct+kchHNGcb/rrRJo2U6dHBpYkQ2D06MVFQjk2iHgQSp
 FZi6//ZHVihmAHl7nMdviYTMMHZ36f2XJU9EqpaaKtvxui/xlZgaxzhilyzLCvAl
 IezB+/yGFavMdLfBLj2D6FhhvE8Rc2kucrvfWK3n/09FUR88eQ5JmhUsl3ef1x35
 TOo6INhmJsAn5WtTwOhwHuaCdWTNj0tVvQlaPkh17VrzRpaICRnl78XRQoDov2/J
 kQgMoFSmLzr0avjpxmtuNc5LSENaXkRyvvZvtXDdGscErm+BFjbZ3nTdNDjccn3h
 aAiyc/l3oMk1Y87F2I8X9UAC+NqTRTTxanpAUNbTB2SrRGzX1uMZaogbcf8Ckscj
 AliA11ys4hKVG0bg7/xfZMtPL1kXtypCtFFzVGrq6dJGwQ==

migrate_page_move_mapping(), migrate_page_copy() and migrate_page_states()
are all now unused after converting all the filesystems from
aops->migratepage() to aops->migrate_folio().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/migrate.h | 11 -----------
 mm/folio-compat.c       | 22 ----------------------
 mm/ksm.c                |  2 +-
 3 files changed, 1 insertion(+), 34 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 088749471485..4670f3aec232 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -33,12 +33,8 @@ extern int migrate_pages(struct list_head *l, new_page_t new, free_page_t free,
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
@@ -59,13 +55,6 @@ static inline struct page *alloc_migration_target(struct page *page,
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
