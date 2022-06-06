Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E876C43334
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 20:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sug3bC8gsEvGc03k5/UPZA624BldfG0gsXUuQm5kn3c=;
 b=uIW6CHKqxSizpK8jd+J7cnXakJiNa5SUCT62iKfers5a8P8I4hsevluylkSV8N04ObERLBe4h9Kc
   7thbH1SOa/j9Y8JZL6k7uyxsbU8/dGD16J/ws3buXKopqY0kjj/6kKObVJ2c0RsArL2b1L0eVEFB
   O7IY69rYYx2ihSc1r2bmxXp/hgMBJalY3nB6HbAbqEmvpj2GmYcIlKvQybiPih49ugmQecVMU+h7
   j+L3PGNW8JpcJrbOfV0TX5c+3nCpUL+EG/ZfuhFJNVmk6i5CmiSv9PHS3HIMfyGMmgDrBt8Nanei
   92XVdTbkaSKAVK2zOvs3FUx2BejrH8DxHyquyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sug3bC8gsEvGc03k5/UPZA624BldfG0gsXUuQm5kn3c=;
 b=twxjUiPv/URY3wgpkzBEY7BS9yeS0uNCfk8B/uepj/QXj068xB2tRaqUXMJOAiZqKeiwR2//6DOR
   1LK78ZdHNcCEO/K89PX/8SiMmUAxLUOGF3q3bqmC1WcRFoy381dkEFMAM+WyTJrXqJZYE3xNP1vg
   VhNdMYBKT4vzg5eng5rw3vdxGpXS5V0PmwHQgPWOKjWWQoEY48cSEAl8LifoBLeGGfB1EbbfxteG
   Dc5YCeWfJOqB6eKvpF5yIQDnvoTIqTRTS8gZywFbCKXjw0vBwGXcuq80Mlad8ucgDm52YnFwo7SU
   XuzNIvp/0CC0ektVqGDle/iBwllmZMxUi4OcYw==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD200MD2PHRI5E0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 20:41:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=o3aaQHfQtp8mApg3jGvaUbMxXMesQjforjwRq7Bq2eU=; b=FEnR7eEx/VqQapCb2J1x1R7fqn
 GHGdnHs4TAUYPhigynTRMZ8qU4EWbsdGE3TfoyFJqfBAgGTtewYKTmiwvMMYa2HzGM87YYHNNNBAf
 25WKlfaBUvQt5+7ogUbK8K0pDyk13POFE1JCVwn42/GfMWEBrYZHN2/3N10M2ljY4Z2NIxy968T1O
 HE7TzEF3cSl9U3cZr+DVtzHy9GRmE/G/dKDgi6vIqQx9YHC1/Rfaz1Ct+G2LHZg/lo5tSznhIMqdV
 W1GO7z8A4xasl5WYZ2TeCzudph+MgQrRtd+cB9PyhUGii++9HtpbBEllVTWL/01DS9ex+eqAgijud
 Ea0r0KAw==;
To: linux-fsdevel@vger.kernel.org
Date: Mon,  6 Jun 2022 21:40:44 +0100
Message-id: <20220606204050.2625949-15-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220606204050.2625949-1-willy@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 clxscore=159 malwarescore=0 priorityscore=164 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=312 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060082 domainage_hfrom=8378
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 14/20] hugetlb: Convert to migrate_folio
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
X-Proofpoint-GUID: hJo-X_1AV9k7o0ft57n4pIJ8V4BQkiu_
X-Proofpoint-ORIG-GUID: hJo-X_1AV9k7o0ft57n4pIJ8V4BQkiu_
Reporting-Meta:
 AAGI4P+5Pc6vSwoYAy3AC6quC2xEsBAf5twOOeg84tkHyK+Yrw30v4F7hc11T6XE
 yfv4UbpObC/Zpepo7kN2Okv+89cPpVp26SGp9B6T8paGQnh0OpBtnAQGrzG+FqpQ
 hnrj4VAPNFBsZQqpm6B75PSiKFNarjskoVcbN4Vx9pNxqlQmUH1WmPpgSuCGE6I4
 wGdp8egmLTyYLfA+L3L6UA+ohrjnpJ0RxMovXMS9iLsFEsU7VJRVpQkSNXEGD1os
 ryL4R8D2C7zCzeKJIfxzAhmA3OsNJygbEqbtu6xfRIv/j35NSrpPquj0NIUiGPN5
 ioCsbyAYSX/7VtlJk3vJGJ+qu1PK8pVU5FX7U14hbGjQ+qL+sUQUmDWyYpSeTluu
 ubRwOoDYSF5Tma19W6eZncI0D2Pi6LCFnMJiBzwKDn7346KBcdsheBzPOLzB0db3
 UKezD9s0gvi8FZp0+ijPPicGlwhK+hInKEFTaujvBeRk90l8lCBkzsatgwz6vZKo
 S2WbhWGcnJZztb5uJ2buvYC/navbQ3zVo6yuVS/p7pU=

This involves converting migrate_huge_page_move_mapping().  We also need a
folio variant of hugetlb_set_page_subpool(), but that's for a later patch.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/hugetlbfs/inode.c    | 19 ++++++++++---------
 include/linux/migrate.h |  6 +++---
 mm/migrate.c            | 18 +++++++++---------
 3 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 14d33f725e05..583ca3f52c04 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -954,25 +954,26 @@ static int hugetlbfs_symlink(struct user_namespace *mnt_userns,
 	return error;
 }
 
-static int hugetlbfs_migrate_page(struct address_space *mapping,
-				struct page *newpage, struct page *page,
+static int hugetlbfs_migrate_folio(struct address_space *mapping,
+				struct folio *dst, struct folio *src,
 				enum migrate_mode mode)
 {
 	int rc;
 
-	rc = migrate_huge_page_move_mapping(mapping, newpage, page);
+	rc = migrate_huge_page_move_mapping(mapping, dst, src);
 	if (rc != MIGRATEPAGE_SUCCESS)
 		return rc;
 
-	if (hugetlb_page_subpool(page)) {
-		hugetlb_set_page_subpool(newpage, hugetlb_page_subpool(page));
-		hugetlb_set_page_subpool(page, NULL);
+	if (hugetlb_page_subpool(&src->page)) {
+		hugetlb_set_page_subpool(&dst->page,
+					hugetlb_page_subpool(&src->page));
+		hugetlb_set_page_subpool(&src->page, NULL);
 	}
 
 	if (mode != MIGRATE_SYNC_NO_COPY)
-		migrate_page_copy(newpage, page);
+		folio_migrate_copy(dst, src);
 	else
-		migrate_page_states(newpage, page);
+		folio_migrate_flags(dst, src);
 
 	return MIGRATEPAGE_SUCCESS;
 }
@@ -1142,7 +1143,7 @@ static const struct address_space_operations hugetlbfs_aops = {
 	.write_begin	= hugetlbfs_write_begin,
 	.write_end	= hugetlbfs_write_end,
 	.dirty_folio	= noop_dirty_folio,
-	.migratepage    = hugetlbfs_migrate_page,
+	.migrate_folio  = hugetlbfs_migrate_folio,
 	.error_remove_page	= hugetlbfs_error_remove_page,
 };
 
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 4ef22806cd8e..088749471485 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -35,8 +35,8 @@ extern int isolate_movable_page(struct page *page, isolate_mode_t mode);
 
 extern void migrate_page_states(struct page *newpage, struct page *page);
 extern void migrate_page_copy(struct page *newpage, struct page *page);
-extern int migrate_huge_page_move_mapping(struct address_space *mapping,
-				  struct page *newpage, struct page *page);
+int migrate_huge_page_move_mapping(struct address_space *mapping,
+		struct folio *dst, struct folio *src);
 extern int migrate_page_move_mapping(struct address_space *mapping,
 		struct page *newpage, struct page *page, int extra_count);
 void migration_entry_wait_on_locked(swp_entry_t entry, pte_t *ptep,
@@ -67,7 +67,7 @@ static inline void migrate_page_copy(struct page *newpage,
 				     struct page *page) {}
 
 static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
-				  struct page *newpage, struct page *page)
+				  struct folio *dst, struct folio *src)
 {
 	return -ENOSYS;
 }
diff --git a/mm/migrate.c b/mm/migrate.c
index 148dd0463dec..a8edd226c72d 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -475,26 +475,26 @@ EXPORT_SYMBOL(folio_migrate_mapping);
  * of folio_migrate_mapping().
  */
 int migrate_huge_page_move_mapping(struct address_space *mapping,
-				   struct page *newpage, struct page *page)
+				   struct folio *dst, struct folio *src)
 {
-	XA_STATE(xas, &mapping->i_pages, page_index(page));
+	XA_STATE(xas, &mapping->i_pages, folio_index(src));
 	int expected_count;
 
 	xas_lock_irq(&xas);
-	expected_count = 2 + page_has_private(page);
-	if (!page_ref_freeze(page, expected_count)) {
+	expected_count = 2 + folio_has_private(src);
+	if (!folio_ref_freeze(src, expected_count)) {
 		xas_unlock_irq(&xas);
 		return -EAGAIN;
 	}
 
-	newpage->index = page->index;
-	newpage->mapping = page->mapping;
+	dst->index = src->index;
+	dst->mapping = src->mapping;
 
-	get_page(newpage);
+	folio_get(dst);
 
-	xas_store(&xas, newpage);
+	xas_store(&xas, dst);
 
-	page_ref_unfreeze(page, expected_count - 1);
+	folio_ref_unfreeze(src, expected_count - 1);
 
 	xas_unlock_irq(&xas);
 
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
