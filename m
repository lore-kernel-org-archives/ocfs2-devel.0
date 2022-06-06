Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 526D5CCA486
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 20:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=j9oIlB2zpOVUvxG7czgZCBdrSOn/dyS3rp4c+8XX6xc=;
 b=FWnNBoeldp5I7x5eACrMRmCw9BT2oO7fZZxCd15rIsxJC1AIULJvQVsRwrjcEVQg5rqIFMjQAoK+
   UWWXOi1LA7zODSeo83e/MgFwHP5YNi9fewIfLT+TWbJSjZcslvnWrDx6iq/gGQXLa4IRsVQqBzW2
   urmjwTSc2pHsJSwFgo0IKEQfZJmCyBmiofgX0xTsezt10nB/AIietfwDE+DRBnKAaCigQDocjuK9
   i0Nh6nz1F85BnA5da/0QbwQlRgGQyA1EGypAnijTSPk2/OBC6zl7wFWLQdbM8Cs/hrAwyNTJnw5g
   LupGgV29Y3kiPlMcVK69L12TjYJ/wNQ8N8qlEg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=j9oIlB2zpOVUvxG7czgZCBdrSOn/dyS3rp4c+8XX6xc=;
 b=S3gco9PHhIlBPzMqThZCLO3u6FUfJ9Mol7QbZf4RGRtjAuNkTfGX8urOMAqaCBpYza9D2bUp81Nt
   Zq9NFBAY/3C/kBSR0lWVh/3679bIv38CiiYqANCsRyFe0m7x1yYs7lnXjwoT9qXKnrj8SaqpkEs9
   pQvOYhXPUAdI+YH82MPWadbfIIAMDF1f6JYM5ci7LVeDBTE+1GJx/eQKNK47qbSQPp2VcSdGaofL
   +BiVg5eyHDrXcsQqONqhTitPkEzS34vGhiV4z7qqvOSWbSfT7n0M6Idphb+jAshcaZpzqno90NQJ
   jwdZL9ZZYvm9Upj9VQWj8WTefQLnURN+3+MwlQ==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD2002KJPHEOU30@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 20:41:38 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=xi6bfdZ9kew/Ht/n6wJe844q1fNiFHAUuQwBybhvWV8=; b=SPlA9TQH81xoMoIY10n2YxKfFT
 FsYePoVkMqprqpv6ZpSb8LgcBJlPTx6ZiQnv9+DpcX1C8BhCoh731GzGv3vwXqOhVgpjWqAcZ9x5Q
 yXSG40C4z1zTwsHq25TqavEFM/aIkrZ74keXov/lJSFAeAlVFO92OjNCITHAZeey74UYtElj1IkQ9
 igzOLTZbXbr/H/xrC6wuD1gd2dEhozUsRpbKST11t4x3padiQWXP0MH6RjFWVF6lx2GnIIN77FMNF
 eqfhiP3IbavqdfjHnrPmIl/jNgL2ME2jYU2bFfEUdA0P2115AUzGiBLzXrUZQ116ZbPHL/l6z5/G3
 D9YuFHRg==;
To: linux-fsdevel@vger.kernel.org
Date: Mon,  6 Jun 2022 21:40:45 +0100
Message-id: <20220606204050.2625949-16-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220606204050.2625949-1-willy@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 clxscore=159 malwarescore=0 priorityscore=164 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=675 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060082 domainage_hfrom=8378
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 15/20] balloon: Convert to migrate_folio
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
X-Proofpoint-GUID: 1zX6lc62PuACt5tnD3dktslE7eifBdt8
X-Proofpoint-ORIG-GUID: 1zX6lc62PuACt5tnD3dktslE7eifBdt8
Reporting-Meta:
 AAFCp4idPUo21eGRRaEq8/7nxXPHS7UPiqYODDrwqZV6YFcqpaepzGao1zDNO1gO
 ZW1ir5bQijuBylALth2jsMGuClFzxmrexoUodPt+TKgU/EFk1WH8aye5Do/DJAxm
 k9JP7qQppQZ1zbBUaBdJGZ2nvgxsbFWKn+rvRkGRyp/YJZkmwOKvWHq55jZ25c3w
 rSjdbCGFohma9my1wg04qficUv09gnKS6mn/XaO8bKBLCtXTE/tit5O/Y3MlUhkF
 nmRpjZkg2Nohp6sobCCzP42Sc5+a5w78Jkz/OuLouse1C7rFxgQmV27Db8oAko2U
 WNZ31CraeIMB07UTlIYB2Xlx0N5j6MbwYKkf3uxcwjEXrXRDviG11mn6diDmQOL/
 kZkrOtbjFDGTAXe2IpGI3DClhSyc8/TbsMFav/ZuH7UvnQct5uzLDMLWExDKqE2A
 QB16JuGzolo8q+LkTH7bywzgwq4JVzgNCl4jK5EeoAKtLyEJF8AXU2hU8GtndtiQ
 6nbK6GiFup8jaNwZFTWdBCQmn0MLh+b4R5hkmCIek9MM4Q==

This is little more than changing the types over; there's no real work
being done in this function.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/balloon_compaction.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index 4b8eab4b3f45..3f75b876ad76 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -230,11 +230,10 @@ static void balloon_page_putback(struct page *page)
 
 
 /* move_to_new_page() counterpart for a ballooned page */
-static int balloon_page_migrate(struct address_space *mapping,
-		struct page *newpage, struct page *page,
-		enum migrate_mode mode)
+static int balloon_migrate_folio(struct address_space *mapping,
+		struct folio *dst, struct folio *src, enum migrate_mode mode)
 {
-	struct balloon_dev_info *balloon = balloon_page_device(page);
+	struct balloon_dev_info *balloon = balloon_page_device(&src->page);
 
 	/*
 	 * We can not easily support the no copy case here so ignore it as it
@@ -244,14 +243,14 @@ static int balloon_page_migrate(struct address_space *mapping,
 	if (mode == MIGRATE_SYNC_NO_COPY)
 		return -EINVAL;
 
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
+	VM_BUG_ON_FOLIO(!folio_test_locked(src), src);
+	VM_BUG_ON_FOLIO(!folio_test_locked(dst), dst);
 
-	return balloon->migratepage(balloon, newpage, page, mode);
+	return balloon->migratepage(balloon, &dst->page, &src->page, mode);
 }
 
 const struct address_space_operations balloon_aops = {
-	.migratepage = balloon_page_migrate,
+	.migrate_folio = balloon_migrate_folio,
 	.isolate_page = balloon_page_isolate,
 	.putback_page = balloon_page_putback,
 };
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
