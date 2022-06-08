Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75806C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4JhSYjf1dgBbWB45UE9jB6sphF+BLoRqcHVzwFqLiJY=;
 b=ryC/fl0qRNORYb5Di+MZH4Yu9EMPWgCp+5xx8ViukkIusYlqGcdDh/2JPNw92V535ANAi1eo+r3q
   KRAEJeswaGJy+Q9wWdmN/u8wW9PM11NCrDvQeX9AEtwOZjEf/C7+OMbWZsviA0pHFAAOjURvZT+h
   6MxaAZ2e2qWKiiT3eYcDjBEIrqTWshFnTSbCmOfzkdjoxkZYqKyJMildvjbdKZ7bNsLQWGSNaQLL
   BwGBmdFrdbqHlrZ8zvLC1yRUNuoESbAYqNQJ63Wpiz9s9O6odfFV23jNle/LJdhi8+6SUVICCDwd
   +hUeGOyGp6H547pHpJc8jpmcU/mxCP7SQ47fzQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4JhSYjf1dgBbWB45UE9jB6sphF+BLoRqcHVzwFqLiJY=;
 b=MAWSLHIzJtn7snPnQnUSawk9qTkzyGrdfoRniBUrffMvqRA6sn8s4QRxSphVDabum1dH96YVdbtd
   FIN1ksu/0rV0kqkNFZT4Jm0b4KYqUsgeysnMCVFYX5MInJSW8aeOuLi4M77NQ1FhBMo4zXSprAeB
   4bvwwZdw83e6MG2ZXRge5qDjgKiEBNw5tBEp3BXeReHWhrs681f7R8+c08qQCpb1nMhYvXXH1+8D
   RiAyWSJvRmiTYUI0+zw6z2tH7dzn/PtyV1vpi6upbaD2K/YQXIIt+jMP0SUNGk3CxLCHcR+OY2X1
   fnnyxvZ4pqbROsqBfCQNXIN7D9vno3Sb2LwpZw==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500O6LZ6PR820@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 15:04:01 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=GbYk6WOt1dmTqgVV6yE5r+zIsB4v0sAfl69wEExYZVA=; b=Avm4ohsfCHV3ITlqMqf2jpVpw0
 IMOZj7fyZbC5iV7nTa3UiJKE6MY3T5i/uCrkDUsFF4AHwZozCQI/jezfAirc4Rt7lV10DpHdXgpVv
 HwvO3PQ82Ljpfj+bVRM9nX+FqP5at4G8638Lf/Y23JZBOfbCSUVhSfGzlTCXeJ412NWBXtTRK4tPV
 l5nw5SoD+S2LeVACUshYo3NXuTXLJgcnVCt8pC7bTFlOs1hz2JEx+tlk60ClyMU/daGv1TEYDSIYc
 3CGKxaOONIbpGJeCBheEf/lTy+OxqCrdvV8s5fcYLlnAxJzahzGG9Rz01UBxjf+ktT1m08pyVoDQI
 fQR1vsVA==;
To: linux-fsdevel@vger.kernel.org
Date: Wed,  8 Jun 2022 16:02:46 +0100
Message-id: <20220608150249.3033815-17-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220608150249.3033815-1-willy@infradead.org>
References: <20220608150249.3033815-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=163
 priorityscore=220 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=356
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080064 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v2 16/19] hugetlb: Convert to migrate_folio
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
X-Proofpoint-GUID: 1aTUr0V7AZUWnKSZgY7TwqwD9m1CVfoA
X-Proofpoint-ORIG-GUID: 1aTUr0V7AZUWnKSZgY7TwqwD9m1CVfoA
Reporting-Meta:
 AAHXFMjpHRo8apVCeyjvy/+AV2JBGr+Mrvr17w0VdYg9drH4z0G3Eu+T2t8pHD2q
 IGE9SKmlGKVoRzyz2JuSGyrZJfx0QYl0+s8VByNLVZ953/qP7C+HQEwO65rzsrLv
 hOOUkALBC+iD+37lwJun4alStNj4xG+VvvYKgEb4YOuTBdwSwUx7MukpuR1nsnPx
 TIdXwAowFLQSeNG/ZscVRdtCwiW/ytLrKQYTc04Fw6EFGi8FKOK0qsgx2h+HWQqT
 YeuOY/Q8woOSDuGb7Kk5jt19SYiwsTmMjpp+3mzQpLB6qE8OThK4z4gUMUM7rdqV
 +9hjVx3JHoSLJwiwZvgsWNXcHfxYJrQ5Q45i5lEcph5wFv11X5ZrqdPThXK3yw2y
 6HajutaBW6Ybvvaauey2378Mgrt5EKrMike/HHShRoZhqVOQAlAyhLHM35NSLDfP
 ze4HNCzpyTy3OgpQQLoDkpD7Y1ekYwcWcTQrGp2mNr5FMulJ7v18tBPhMrIyoQ9q
 ckdx2r/ttzB8slVSBEpLsb1StMyzwhnZ8s5UpKdr7TV1

This involves converting migrate_huge_page_move_mapping().  We also need a
folio variant of hugetlb_set_page_subpool(), but that's for a later patch.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/hugetlbfs/inode.c    | 23 ++++++++++++++---------
 include/linux/migrate.h |  6 +++---
 mm/migrate.c            | 18 +++++++++---------
 3 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 14d33f725e05..eca1d0fabd7e 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -954,28 +954,33 @@ static int hugetlbfs_symlink(struct user_namespace *mnt_userns,
 	return error;
 }
 
-static int hugetlbfs_migrate_page(struct address_space *mapping,
-				struct page *newpage, struct page *page,
+#ifdef CONFIG_MIGRATION
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
+#else
+#define hugetlbfs_migrate_folio NULL
+#endif
 
 static int hugetlbfs_error_remove_page(struct address_space *mapping,
 				struct page *page)
@@ -1142,7 +1147,7 @@ static const struct address_space_operations hugetlbfs_aops = {
 	.write_begin	= hugetlbfs_write_begin,
 	.write_end	= hugetlbfs_write_end,
 	.dirty_folio	= noop_dirty_folio,
-	.migratepage    = hugetlbfs_migrate_page,
+	.migrate_folio  = hugetlbfs_migrate_folio,
 	.error_remove_page	= hugetlbfs_error_remove_page,
 };
 
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 82f00ad69a54..59d64a1e6b4b 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -42,8 +42,8 @@ extern int isolate_movable_page(struct page *page, isolate_mode_t mode);
 
 extern void migrate_page_states(struct page *newpage, struct page *page);
 extern void migrate_page_copy(struct page *newpage, struct page *page);
-extern int migrate_huge_page_move_mapping(struct address_space *mapping,
-				  struct page *newpage, struct page *page);
+int migrate_huge_page_move_mapping(struct address_space *mapping,
+		struct folio *dst, struct folio *src);
 extern int migrate_page_move_mapping(struct address_space *mapping,
 		struct page *newpage, struct page *page, int extra_count);
 void migration_entry_wait_on_locked(swp_entry_t entry, pte_t *ptep,
@@ -74,7 +74,7 @@ static inline void migrate_page_copy(struct page *newpage,
 				     struct page *page) {}
 
 static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
-				  struct page *newpage, struct page *page)
+				  struct folio *dst, struct folio *src)
 {
 	return -ENOSYS;
 }
diff --git a/mm/migrate.c b/mm/migrate.c
index 4d8115ca93bb..bed0de86f3ae 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -474,26 +474,26 @@ EXPORT_SYMBOL(folio_migrate_mapping);
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
