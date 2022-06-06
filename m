Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 582C1CCA488
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 20:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=bdoFGINg5KKPhjyP+gx0jyxSoykH9Ddufl/XeRvyOeo=;
 b=lF4J/gUuTiWPba76z/SG2L6MmrW+B1MV8Ozb7Lp6LnuEEl98Hl4vnoAGxDZLtaPi4Q/Hdzf4wXp+
   UifidAeMDVs7oo27rdZ/OSuEEKxKxMdlEk6YBk1dt91huVIhbGRdf/8zUjTS7E11T8WK1GWxJCue
   f7rF8LWIL7QszBQpBao35yTFnreUNBeTn/6jvN3kCrvMtVIDGBNLtCi1jXqDBSNNCqbYI2j8+w++
   y3nRWvlfmsoqAYqQR1n//qznmeNFZvTGHBUDe4o0FnSoZYgrMqnqYdS6IXOZ2KY/JDU7ql453KaW
   G/H2xLb6G9ROVjiplkhfdrqioWuAoBmJd9/e+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=bdoFGINg5KKPhjyP+gx0jyxSoykH9Ddufl/XeRvyOeo=;
 b=FJvDvMONx7H1SCfmWTtGVPncVgo2SZaDHOEyCfSZOALJnCbec21cou6BA3RYkcEQ3tkEa+VCHpQP
   ADM2iY0tUIGnoTh6uBDjBEgWDPNvV7gETiu+T5UJAn6DxGyvIicrt3vHiCRdpGHx6WqYtuYODDiH
   qRlltffy3QPDHCQe5krSp5HJT90SaB0mDxr+sdfH0xNoR67bQdum49hBWOQ1Z0NV/G13baiNwF49
   z2l2dCO0M6DMHuA8FTg4hOX9G11JOf5Qje6ZvcauV6H9N4VdtHI0hJ/nxwEAgtC/7h7XD28DwtPg
   EanGBELDUQIcwN5DO/uQbcO2uiKy5sCgLuBicg==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD200CYCPHAG830@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 20:41:34 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=qQEq4mdildUXXhXlw26OgbbgbPBpQ0UP7iPop0FGmsk=; b=smk5cZ9QlxWeUzBKWfo86nVrRn
 486Q4WmG9O8N7FW33RHEsLn1KdnhRCjpYsCnh2VTGHbxlEbEoaGncZWPwo88zaujLhSpvhlFYqZjF
 rT/pg4CkWWNMdWfegFLoYHJvmoFIm1xAxZgu4kmCe6BWjH2QkN1GsU7kYe50wZfva3uEoQHLUVRRU
 edvLwLiCnvO9Xryb+ZR231DA0eGBN7CXz/fAN+xjcrsnTNRjReFVIp2BGCweM6NJZGbCkhTvenoYZ
 cQCh2ENLaKQwbX+uc1wEhsR2j84htsXjEviyNnafZBo9+lFBva15d5sRZGRRozu2cOzqXNQM+sbim
 Zzrgg9gg==;
To: linux-fsdevel@vger.kernel.org
Date: Mon,  6 Jun 2022 21:40:36 +0100
Message-id: <20220606204050.2625949-7-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220606204050.2625949-1-willy@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 bulkscore=0 spamscore=0 clxscore=165 mlxscore=0 lowpriorityscore=0
 priorityscore=108 phishscore=0 suspectscore=0 impostorscore=0 mlxlogscore=650
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060082 domainage_hfrom=8378
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 06/20] btrfs: Convert btree_migratepage to
	migrate_folio
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
X-Proofpoint-GUID: 9N_QoBn3NIsul_Wr6psFgjXTrnFrwqfd
X-Proofpoint-ORIG-GUID: 9N_QoBn3NIsul_Wr6psFgjXTrnFrwqfd
Reporting-Meta:
 AAEg6SygxaT/zHvhQ6guxcm+F+gSufxaLlNvNM97o+Rp/s1cZtlPLRko2w//jpYM
 nFX6H1i0KaOyZCqB5MJTK2EC4UiWfa5GXi4I42j04PwAz/zhwYRQifpL+1Ff2Qgm
 ULzuVVyYRhce9nsu2/HMWkaZyQwMkylUxYEbjW6V9AHsLQZxuURqF2yOa3OEmLcZ
 lkk4xBTnIzG48+T9g8ttd/J8IKxrejm9tAfmHsLwwGAnH8LPRqXiOxA1eGQzSlSC
 1ArpiOm4rvBdKbBO3aGfLz8W1+pnQ+9uWer9KocozpmS1ovxgjUFZLXVJrSadNnZ
 AHQUUh9sQ8C82XX7EgyskW9z/ZdOvmoMfxap1Wb1MYHyqeQPIrqEkpB3qstZXy5T
 dZAcfj5EnTGVSSqcWphuyB36C11v5d1605IW0+Mokrm+/7cjFNDhPse8obtFrG4h
 Zb9WztRLbDAebTi8O7mRpkbQUS36c3hDUCShM91YP5MFOSfN7Hrf4PQra86MZeJ8
 TDwQLf8V0VsH3XbH8rUwT/C1uASb1qbIemgqYaY1okotYg==

Use a folio throughout this function.  migrate_page() will be converted
later.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/btrfs/disk-io.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 12b11e645c14..9ceb73f683af 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -952,28 +952,28 @@ void btrfs_submit_metadata_bio(struct inode *inode, struct bio *bio, int mirror_
 }
 
 #ifdef CONFIG_MIGRATION
-static int btree_migratepage(struct address_space *mapping,
-			struct page *newpage, struct page *page,
-			enum migrate_mode mode)
+static int btree_migrate_folio(struct address_space *mapping,
+		struct folio *dst, struct folio *src, enum migrate_mode mode)
 {
 	/*
 	 * we can't safely write a btree page from here,
 	 * we haven't done the locking hook
 	 */
-	if (PageDirty(page))
+	if (folio_test_dirty(src))
 		return -EAGAIN;
 	/*
 	 * Buffers may be managed in a filesystem specific way.
 	 * We must have no buffers or drop them.
 	 */
-	if (page_has_private(page) &&
-	    !try_to_release_page(page, GFP_KERNEL))
+	if (folio_get_private(src) &&
+	    !filemap_release_folio(src, GFP_KERNEL))
 		return -EAGAIN;
-	return migrate_page(mapping, newpage, page, mode);
+	return migrate_page(mapping, &dst->page, &src->page, mode);
 }
+#else
+#define btree_migrate_folio NULL
 #endif
 
-
 static int btree_writepages(struct address_space *mapping,
 			    struct writeback_control *wbc)
 {
@@ -1073,10 +1073,8 @@ static const struct address_space_operations btree_aops = {
 	.writepages	= btree_writepages,
 	.release_folio	= btree_release_folio,
 	.invalidate_folio = btree_invalidate_folio,
-#ifdef CONFIG_MIGRATION
-	.migratepage	= btree_migratepage,
-#endif
-	.dirty_folio = btree_dirty_folio,
+	.migrate_folio	= btree_migrate_folio,
+	.dirty_folio	= btree_dirty_folio,
 };
 
 struct extent_buffer *btrfs_find_create_tree_block(
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
