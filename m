Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DEC6C43334
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8Gi9TqMkfQeIeerSlkL4PpBAcB8KtuwTI40duo1HRfM=;
 b=GBn75Zjhdt7TrFSRrGo5GUIgfNeNAJO6ANQBYhUD1I6j+ogR8EFrPxAZl1oo/vCKKu5IRyZQtvsN
   vsl7vhiOZkvm2KVA1PH+xiFSA39jsZ1PEEz6yxNbA3kKtcIrfgvqY5CryHYY/nViY2wRIksx8vLG
   KtqO2wIichdAXR2wLEMnE56bGy+d1uDF3cDDdpPzmiB/gmUC21yTvS/OC0yRbNxpHQ2A40Qfw8Ri
   VJijXPg0wQ6qKvtEhSWVy81mGy0Cbo4HiDue446oeptE3wDg9yrniMk7JA2J7D0HYoUx6Z1KZCDX
   KGP+oZwTyy3oUq1YI7ami6oRbb61JR00dGlkLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8Gi9TqMkfQeIeerSlkL4PpBAcB8KtuwTI40duo1HRfM=;
 b=DNosxbylGNGZhRfSts4uOrM4enE4mWJ8JRHyPZfZnlEswnDn1kNXecB1Ml8R6OydG9oZIcH0SftV
   KmufsfW27qKFc7fVkbJSvUogiScn6sV+3W6YKte28l/goJq1rSeJilI3nm8nOzzc7lZpRAz+82mJ
   W1Jvid7h8POqkhVvxwgRDyEqvesMBzfk4C3j5Ngek2fyrHLpGTkLVdcqQ1Vw0fGrYFkbYSsL7lGv
   jIVbGwhZKHH/2Zj9c6YNlGnQQ6Vo/iTtZHzc78urZoxnLurnxY2MQrHz6jrpxmpBnXUPkzNiJGHd
   0epVqfVJomWNquPC4H2e0S2vwXyAF0xoLBFIvA==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500KCJZ5RP340@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 15:03:27 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=qsTlykJAxZx6jtmG/jT7izH1Dcr5N8n7lryLshNhvTE=; b=e95BlphxpHWFSbkgwIGOMjMcix
 42VFX0xG4pEx4PwDpChY3whbyyU4o7EK6xkxLTB7EAAS0XLLMepgIrkSq9ulWSTEgJHOyeO16jR8H
 KAURiWU1kAGlq5hK6BiRWShPtV19XNzbPScqKcrTKHHOWYXu5HitZoKOBr6oo3ZWM4ay3E9eOvYd5
 Db/0v/dwiBpuKJEL4joGM6o051xOrfUlxR1BNJZpHqRV1evyQNWBqyD72dbNPCEfe3acj84hFUfnR
 TlPkAsw1Taua7T0IisbUN8NeCFSG6wCgm3FxiXOVnvLaNoSCYbESH0E45kZ7WOpT/2BLqigho9EnP
 b+FXacVQ==;
To: linux-fsdevel@vger.kernel.org
Date: Wed,  8 Jun 2022 16:02:34 +0100
Message-id: <20220608150249.3033815-5-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220608150249.3033815-1-willy@infradead.org>
References: <20220608150249.3033815-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=167
 priorityscore=253 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=593
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080064 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v2 04/19] mm/migrate: Convert
	fallback_migrate_page() to fallback_migrate_folio()
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
X-Proofpoint-GUID: 517f06uV3CkTIdC0gwNSTD6ZYngQxRMJ
X-Proofpoint-ORIG-GUID: 517f06uV3CkTIdC0gwNSTD6ZYngQxRMJ
Reporting-Meta:
 AAGv9v0YWXXb+XCjIPEMYR47MlkWjLoysqg+C/zHhUflGnCy6djdx8hqeptQNqCC
 fFuFoV4oEJiCDYuOQ5Ce47R/o4oAQfPbVHJ182CI7nFntTRqBCLppIUTnKIzZNP/
 5MBtOV7LXT9zJpSYoVzIuZHUrgtoC7787VW8CpQh9YWlVYCCatCOcWozXSwsayCi
 r4FikyIq2TlDKdxjTp2fWVMsVoMVRz2iND+bKlCngnl0pzermjliqbZ9CqkFaj7E
 I5CxRQxMxNuL6tZGafSbnLQ9TMQ+RiEhBnHLUN4sHnXB0sikPFT1GFGmMiKxVlNT
 UO0f2Wh27qs+v0pnHNS7joxAgYF9v5h3Vsi4RnsRf1kV8VlLuJcoJxtUtFJjhZEj
 BuRjaEULArG8dOdWIywboDF+liSXKoMUuD+jGxBCCh/Au9VOf3O6D1adWbHXdeNy
 bxtPlGGgb0IocZyEmCO+zfCZ4hJ5a4kN5dYP3bVa7sdvBqKZsDZd3eCubFTBVGsZ
 wPzwAJFXCrwK/n5Gx8tJ2+CFekPQZj/9NsIlh1pWaU4=

Use a folio throughout.  migrate_page() will be converted to
migrate_folio() later.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mm/migrate.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index e064b998ead0..1878de817a01 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -805,11 +805,11 @@ static int writeout(struct address_space *mapping, struct page *page)
 /*
  * Default handling if a filesystem does not provide a migration function.
  */
-static int fallback_migrate_page(struct address_space *mapping,
-	struct page *newpage, struct page *page, enum migrate_mode mode)
+static int fallback_migrate_folio(struct address_space *mapping,
+		struct folio *dst, struct folio *src, enum migrate_mode mode)
 {
-	if (PageDirty(page)) {
-		/* Only writeback pages in full synchronous migration */
+	if (folio_test_dirty(src)) {
+		/* Only writeback folios in full synchronous migration */
 		switch (mode) {
 		case MIGRATE_SYNC:
 		case MIGRATE_SYNC_NO_COPY:
@@ -817,18 +817,18 @@ static int fallback_migrate_page(struct address_space *mapping,
 		default:
 			return -EBUSY;
 		}
-		return writeout(mapping, page);
+		return writeout(mapping, &src->page);
 	}
 
 	/*
 	 * Buffers may be managed in a filesystem specific way.
 	 * We must have no buffers or drop them.
 	 */
-	if (page_has_private(page) &&
-	    !try_to_release_page(page, GFP_KERNEL))
+	if (folio_test_private(src) &&
+	    !filemap_release_folio(src, GFP_KERNEL))
 		return mode == MIGRATE_SYNC ? -EAGAIN : -EBUSY;
 
-	return migrate_page(mapping, newpage, page, mode);
+	return migrate_page(mapping, &dst->page, &src->page, mode);
 }
 
 /*
@@ -870,8 +870,7 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 			rc = mapping->a_ops->migratepage(mapping, &dst->page,
 							&src->page, mode);
 		else
-			rc = fallback_migrate_page(mapping, &dst->page,
-							&src->page, mode);
+			rc = fallback_migrate_folio(mapping, dst, src, mode);
 	} else {
 		const struct movable_operations *mops;
 
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
