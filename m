Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C96BC43334
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NKSCM2LfjJ/yopq4s8N1Z7tJbrMEPDsJ+WlIgHQ3UHA=;
 b=QChwHFtz6IdOKnKn0kDqjdt5LEz8NvDrDdhC92FYiblKX7lQwH5MDLNXkSgL+e3mq4Ju+8bQwQtK
   mLB0wZUdZpW9UX0SJ+mbRhzEeMH2Ii3a9JwnzaDc/NrgxuqVquQCv9PAetrIFGJXtE5J44S2MhX4
   BLOQXuHwAHQHpRg2EBtkGvYPuO0ZgG+3nQB+DGTeuMCmFC9ChARoKZyAgGAQNfSmtBBRAIDWWF9j
   oHut4W7XGT5ddMXEiizAB/huKPpDFtVULHIorM+DekYwVe+plVDL/6jiQLmbI2d0ze6y38jkJhCU
   Mnx4WUUq8ahVoNYzVnqYAYUwZ9yarFgqbTBrkA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NKSCM2LfjJ/yopq4s8N1Z7tJbrMEPDsJ+WlIgHQ3UHA=;
 b=XGRdBeWKnFiOwVFMSbbbjkPlWvpItvR3yHE/xpGkrmDlBviPzYiAAJTfA5o8PhBy7EFetQZwImcM
   xNlxDtjzWkTQeXKksQ5hcL4xCRJrNfKi0KWLAqH1krXB4KhgLvAvWzcu9tp30f7K3DTM3xdOkIid
   Jjeg2OPbJQSQOrpn+xZqDdUkA0I5up3pT/BtHulTmpYDrK45xbkkeRcAksO4tTddzErkzETkG21F
   SAgNcfxn1DPyt9ufroXt5qvJDoGTaAo7521XWcX/wSqfSBnZOKiYjoHV4Q664wWKELYqJN2ZIKLP
   9og1deJH2J5ir8GmAUKDDPHXZD1e61gRGwRyAw==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500O3RZ6ER820@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 15:03:52 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=jUHtPvxpwYn/CbCKtCO4gIDrDPVTvyaQoVGtIQShqV8=; b=F0wkIwdh5JarabWL7s440hCeed
 JG7M+RAPNvEs0qtJ0odlvedPM5u6UNyXbTmEBm4Hx35BoOjFV1oKCmRWs7a2p1I7DWzzzvlvH7zxb
 NwAy72/kutKMINfwHD8wNSSOmlkp/ZbcRgANHqqHoyDCAzRFMPKBCLvDG/+pf/SqWyA6xVonIuvPK
 3Vo2mRZDOuHUiWFb793CtPIl0KBu+BtlMkUJpzHLOBoi3MTThxjS7QgPBZ4bWXFBqmBv38WY81zoI
 IOHo+aIWKHbzH55lED0UDiMkvsiu5YHhPck8zRT5hnVZDoeLyNfO5FO+6YtWEQzYK/lnegSOXMkks
 Gp33NrTQ==;
To: linux-fsdevel@vger.kernel.org
Date: Wed,  8 Jun 2022 16:02:43 +0100
Message-id: <20220608150249.3033815-14-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220608150249.3033815-1-willy@infradead.org>
References: <20220608150249.3033815-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=467 suspectscore=0 mlxscore=0
 phishscore=0 priorityscore=250 bulkscore=0 clxscore=162 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080064 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v2 13/19] ubifs: Convert to
	filemap_migrate_folio()
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
X-Proofpoint-GUID: WYoKppD3O_0ccoHbuun0yiAKADJasnFC
X-Proofpoint-ORIG-GUID: WYoKppD3O_0ccoHbuun0yiAKADJasnFC
Reporting-Meta:
 AAHdFjvZ2UAU4jtEv8mfsplmCvB07bBUbgcoGtaC/fNzQpuxNSBp110ZRqhSbQdv
 MHHU3nER/3rcQtyefITKXqV4IGoIQp3Mq1flKjC0DXulF5nzfltrwrcaHAjU0gnp
 VPHxLvDxUI290qtoaIzusGzybHqv2bPb95MRssIFg/TBEzJBfDetazd9PBI+C17X
 oMgtuFSyMfMKRROc29e1MCV6RaWzO1coJIVWI3Yg2RL2hyjqwcttZTBdu3x4FVht
 j/jKyl5BjFxTzMLBRJbZCo2i/3DpnDXtGyN3tGE4CqzwEeuu22GV6K6EXr2uwX3q
 IO/Jiqmf11wyiyYIHY897mDUE73aR6Na1z+S5/Xc/FLs4OOuIgRyXMPvrcphTorD
 iT+guok4PR46Te/oFRhKwYFzCuFCOgLRDfDVFzuYil9DdDFoJCkcPjAZp2GYDazx
 2UslooF1Qavfh8I+gfH+nX5LfazhMImvuWKKPLsccsTLXFfBcC/rjcCD6PC4QY7E
 ngkZLPf5PRR+eCQTq9zc41+55u7cLm/US/auGayGNK5J

filemap_migrate_folio() is a little more general than ubifs really needs,
but it's better to share the code.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ubifs/file.c | 29 ++---------------------------
 1 file changed, 2 insertions(+), 27 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 04ced154960f..f2353dd676ef 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1461,29 +1461,6 @@ static bool ubifs_dirty_folio(struct address_space *mapping,
 	return ret;
 }
 
-#ifdef CONFIG_MIGRATION
-static int ubifs_migrate_page(struct address_space *mapping,
-		struct page *newpage, struct page *page, enum migrate_mode mode)
-{
-	int rc;
-
-	rc = migrate_page_move_mapping(mapping, newpage, page, 0);
-	if (rc != MIGRATEPAGE_SUCCESS)
-		return rc;
-
-	if (PagePrivate(page)) {
-		detach_page_private(page);
-		attach_page_private(newpage, (void *)1);
-	}
-
-	if (mode != MIGRATE_SYNC_NO_COPY)
-		migrate_page_copy(newpage, page);
-	else
-		migrate_page_states(newpage, page);
-	return MIGRATEPAGE_SUCCESS;
-}
-#endif
-
 static bool ubifs_release_folio(struct folio *folio, gfp_t unused_gfp_flags)
 {
 	struct inode *inode = folio->mapping->host;
@@ -1649,10 +1626,8 @@ const struct address_space_operations ubifs_file_address_operations = {
 	.write_end      = ubifs_write_end,
 	.invalidate_folio = ubifs_invalidate_folio,
 	.dirty_folio	= ubifs_dirty_folio,
-#ifdef CONFIG_MIGRATION
-	.migratepage	= ubifs_migrate_page,
-#endif
-	.release_folio    = ubifs_release_folio,
+	.migrate_folio	= filemap_migrate_folio,
+	.release_folio	= ubifs_release_folio,
 };
 
 const struct inode_operations ubifs_file_inode_operations = {
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
