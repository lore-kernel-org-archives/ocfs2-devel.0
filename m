Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33EA1CCA48D
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 20:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=j6wu3VmTfbFUImI5xNRw0g6BVbMSTqA3YsH3hMToWsI=;
 b=T4fJakMmzhdirVijnflE7IJbpNNgyEovKF3BRls1AX2cC3MURC2CeDyxIJO4rVbAO2WdZpldNXcX
   2aR9DuPTotR1cDnG504i6Q+O4tf3T7xU/+iRTOaCm0pcJzyp2tdIubUFqH0MFIl12r6g6tHrKraE
   JMuvTyt6SQRiZ7rYoqR7qQK7wFevqr/BR0dpfQ1m4rLnOhS94PXD4GG/txtEwsOCFEiTCQ6kvh8f
   xVP/F/xmlIvDCWUHdwTYmEatcEDRxqBjoGs+/PpVMzdJ3XRe0uPZ/t68YRBLp/Zc+0djbNNFuuB/
   oP0xnqLkZjqXKLPEp//78rhGrLcQgg0oYalK+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=j6wu3VmTfbFUImI5xNRw0g6BVbMSTqA3YsH3hMToWsI=;
 b=k6rUk0A99+7a4MdP5jj5stXDBUSysvpGcKUq5Arz/5RwRCq6mMrzNrp5rOrGFyPlleEVFAp/oDsM
   BgvoCZxAkHINyjd4BBHwnDM4xlkw0ASkj9f2V6gJjPiQExw6iEHbamsZvUmm4ecWgf35buaj/ezC
   i7wwOOkVJ8gmNGUiaCRfAjoe9nkLwce2ENKNbZLaLnoFh9RLUG9H4eAInxLQZUXQQA2CTezz+ITQ
   4TvTVz7pg4caE5Efl34WKhInFAEPRx5IxzhIt/IXwdNZInE8duQMFX6NJEkRgWxAQAAEHKr1aMNA
   fKKpdH3C4GvKlUb3sbeSnc02fdocRXs5LJNYrw==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD200CK0PGWQR60@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 20:41:20 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=dRkMHaR981UE2djNCVPW4MUdY2rPYJAa6UnQ1arpxn4=; b=VhRq5mA6U/Le0FhZhCp9BX9vX0
 eEJWByASrVCSrm9WetxXqV0UXZBjF0SuYe4mFnGXMFsUgOilHz8p+squ/1rM4gM36CwhSe5BBEQp6
 i1dQyrlxzSUP+hK9Ax4brjnRi7zxuvpEv+ymkWeCRkQK8HkgmO0y7Vc+lYVUA7Hlj90Pkf8iPWxqv
 CYXqz3bl8ul96I36GIcF4ldupbg1VWOjM55w+RuDYjPUC/TOKQiKqMH+XKBjwoHp0p03NK+LpBfPw
 iNV++FmUm87jwl9SX46KBPV+Ri5X6qeVBMjICnW8mirhgRNBkbRKdvNkLwdTh42fXKSQ5I7volu41
 cllWb9Yg==;
To: linux-fsdevel@vger.kernel.org
Date: Mon,  6 Jun 2022 21:40:33 +0100
Message-id: <20220606204050.2625949-4-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220606204050.2625949-1-willy@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=164 phishscore=0 adultscore=0
 malwarescore=0 clxscore=159 spamscore=0 mlxlogscore=684 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060082 domainage_hfrom=8378
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 03/20] mm/migrate: Convert writeout() to take	a
 folio
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
X-Proofpoint-ORIG-GUID: hppE_iKBXCfbYMGMJy1XKRd2zRClmOe5
X-Proofpoint-GUID: hppE_iKBXCfbYMGMJy1XKRd2zRClmOe5
Reporting-Meta:
 AAERZj8mkz0aTDXy/y2S56ygoDSx2v72QWWLs4qfubVg/8QbxdpE2CEZ8CtzASYq
 PVKMMdtYJkgm2kasANXFHQ+olhbxt8sqFbPG7fIXDTHoiHLIA2HQrX6m7KikHGqh
 4JCLtsLhx4DHmxU7EgismjAej5LtywwRX7Se1tQvgTw4gl6Hqu1Tnu5e8yl8jClr
 SsKQpTor+jXfGVHg0am2h1NFlgYYvIw8B9xs3exrjlMPKt6oEhlaTZ4dkG7DYusl
 ZPo7ZlLbJUcXTYgCuAzRp6KroaQ0W4HcSvp58/s+FGtjJfzmuiiG64Iu/oXY/E2x
 TSgxUZTXDwNYPn1Z8FsdaFQFyZLiCXpaov0+FRL/caCIizqWtyHbBnx/2HB9vP+P
 Ck/Nhx9VfNLPpBtrsakcxPWxfvwfFq4ww7TfgKSvR3t1V5XxMh1BD7S8fqaQ7HRE
 z1XhOC9j08MmWG2MgIEiOlt7v0gHCfIaQQadUWrvR571OjJVvRyqHLBkLXN+X4U+
 7GN5HR79miZFAuOTu9Jfor6rREC5i7nkkJ52E5bfZAzc

Use a folio throughout this function.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/migrate.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index d772ce63d7e2..f19246c12fe9 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -762,11 +762,10 @@ int buffer_migrate_page_norefs(struct address_space *mapping,
 #endif
 
 /*
- * Writeback a page to clean the dirty state
+ * Writeback a folio to clean the dirty state
  */
-static int writeout(struct address_space *mapping, struct page *page)
+static int writeout(struct address_space *mapping, struct folio *folio)
 {
-	struct folio *folio = page_folio(page);
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_NONE,
 		.nr_to_write = 1,
@@ -780,25 +779,25 @@ static int writeout(struct address_space *mapping, struct page *page)
 		/* No write method for the address space */
 		return -EINVAL;
 
-	if (!clear_page_dirty_for_io(page))
+	if (!folio_clear_dirty_for_io(folio))
 		/* Someone else already triggered a write */
 		return -EAGAIN;
 
 	/*
-	 * A dirty page may imply that the underlying filesystem has
-	 * the page on some queue. So the page must be clean for
-	 * migration. Writeout may mean we loose the lock and the
-	 * page state is no longer what we checked for earlier.
+	 * A dirty folio may imply that the underlying filesystem has
+	 * the folio on some queue. So the folio must be clean for
+	 * migration. Writeout may mean we lose the lock and the
+	 * folio state is no longer what we checked for earlier.
 	 * At this point we know that the migration attempt cannot
 	 * be successful.
 	 */
 	remove_migration_ptes(folio, folio, false);
 
-	rc = mapping->a_ops->writepage(page, &wbc);
+	rc = mapping->a_ops->writepage(&folio->page, &wbc);
 
 	if (rc != AOP_WRITEPAGE_ACTIVATE)
 		/* unlocked. Relock */
-		lock_page(page);
+		folio_lock(folio);
 
 	return (rc < 0) ? -EIO : -EAGAIN;
 }
@@ -818,7 +817,7 @@ static int fallback_migrate_folio(struct address_space *mapping,
 		default:
 			return -EBUSY;
 		}
-		return writeout(mapping, &src->page);
+		return writeout(mapping, src);
 	}
 
 	/*
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
