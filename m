Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97295CCA481
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QPMZb55mirTf8q/RHI4eTTQDdOSeiLiAL5rypCO2zh4=;
 b=QFKn6kO0/TAbrSnNTteEqsWckDqbUlU/9htaOoc5zYsBBm9xnN7H/e38YUurSp6en95P1jW7gkdE
   +TKXOUn2XXu83COijVbDGyYfeTAnYf1lphfoVHH+x+1W+FXuhT+Q6d88Oc0ddnM7aqG/zgsy7kxe
   jAj4rHS2aeIdvin9qybc03clOALlttVYwcfGkbfh4K/AbOGOxX1j+ONdv9i1CBcCmgDHBmhLtKQA
   4nPu9Uo2UzNJzGRySklynz8DOMclOMv9DSwqu6zE+EMxWewo8N5M6AG/rvRn7BScfuG7iRgOxcIk
   wSh9VOI/xmEUhZSgZ7LyLxF8VTQsqbcfDuDFGg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QPMZb55mirTf8q/RHI4eTTQDdOSeiLiAL5rypCO2zh4=;
 b=WAGab4srfXTgBMDctNlWE3i5aP5PgDSRPoxcUGk0Q1HZxqRGXEJjpQrNcBJXiGiKJF2eDLaKk2u+
   RXumeO5cjKmBo4y51WJq58VunUySPr2e+ZeYa9ldjqT4mRqk4U38i17nvM9I9JYIDK983qorBIZb
   zoFej7FKuNWI7QS/CKgQlqkSV+DTaAzmjw9LXp2U9Neipt05yNpQx4boleZdH1m8rXcLxOarfcIF
   V3iOJEMSC46DYDpAPG5O+5CfgzvajJtHOqU7oWjbFjEMfgP3IMPiHvsuyyLgHeCVFVF7XRFcUrFs
   v35MfbeHGfnSs8DsHUpp/nChGsTwglws+dWSWA==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500KBXZ5RP340@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 15:03:27 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=q19bl1GOrWdHTjgYDxhLJRg+W/+5czLjAL7VLyDzJ34=; b=mOBypxFOwS2n9s6NktrO3VOYBD
 likaXqlN3jNEex1YWhAf5cX91oZKdOnyG+duJz3qLtijE+NyRnwVurkL0T91QfLi8D9sSQy09sG5r
 Ym9AVhk5LO+yyQVj2g07a7Bn//PUeUxTNML3BWHOIRvkm7UttV7M2QnXImNESMTelDpw59g/UCbxW
 24KiC0/3GOAODjYTTCyQ55cdTz2s29QYwsetmbpkcxS+y/86CU7jaFgS33h8YpDJnfq8G/cz6blQc
 9oooMmL5H8ST+2VshTWzwRHw6FgNxJ66MFOCbzmtWOHkd7ciMFL1qsVw/5+BYRyJohk4ptXPd6+0k
 krKUX0Hw==;
To: linux-fsdevel@vger.kernel.org
Date: Wed,  8 Jun 2022 16:02:42 +0100
Message-id: <20220608150249.3033815-13-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220608150249.3033815-1-willy@infradead.org>
References: <20220608150249.3033815-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 mlxlogscore=682 spamscore=0 adultscore=0 clxscore=154
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 priorityscore=115
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080064 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v2 12/19] btrfs: Convert btrfs_migratepage to
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
X-Proofpoint-GUID: Lz3WfrEGNmiwDthChvgG-NHbvohkiqPS
X-Proofpoint-ORIG-GUID: Lz3WfrEGNmiwDthChvgG-NHbvohkiqPS
Reporting-Meta:
 AAGv9v0YWXXb+XCjIPEMYR47MlkWjLoysqg+C/zHhUflGnCy6djdx8hqeptQNqCC
 fFuFoV4oEJiCDYuOQ5CU47R/o4oAQfPbVHLOW/7M3jX+l3Lz6uMiVNVFRFGHGW1A
 4FhZoDTOCzlgm3ys4ME6W68T/KPa7YqfkuHg3iMG26N+17LQhDO4LHVD62pFL2uN
 27p4lG+oLtfolNVE2ebTAJF22Hpmic53Z2g1iFx6amucULugGktNv8HNbu9AQb1v
 UmreK9COR84H47N9jMM4JBjJxw5DXu7tTNFzd2Iw9CSBR+QkgX7AhLwSnGPV2lBH
 NnVSii9B2vFfySB7CNb+7vsBx66oXS0zdLp2mEWEoMljoliXlupQvXMnYrP6vUWY
 OeRPtA6TC52VhpdXGSkPHeGlaTopvOG4mxS9jgio6/qI9Z8zxVwD3+XydmdTcP50
 EGbWCL3KW7KeG+fD2belJv83UJL8k+2QZreyahbD0gRenG/9bUDzGn/ppARFVAmm
 c72nVgEeWpZyBLmCKiZJCdp6Z57NRM0i9QPmE0CmE/A=

Use filemap_migrate_folio() to do the bulk of the work, and then copy
the ordered flag across if needed.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/inode.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 81737eff92f3..5f41d869c648 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8255,30 +8255,24 @@ static bool btrfs_release_folio(struct folio *folio, gfp_t gfp_flags)
 }
 
 #ifdef CONFIG_MIGRATION
-static int btrfs_migratepage(struct address_space *mapping,
-			     struct page *newpage, struct page *page,
+static int btrfs_migrate_folio(struct address_space *mapping,
+			     struct folio *dst, struct folio *src,
 			     enum migrate_mode mode)
 {
-	int ret;
+	int ret = filemap_migrate_folio(mapping, dst, src, mode);
 
-	ret = migrate_page_move_mapping(mapping, newpage, page, 0);
 	if (ret != MIGRATEPAGE_SUCCESS)
 		return ret;
 
-	if (page_has_private(page))
-		attach_page_private(newpage, detach_page_private(page));
-
-	if (PageOrdered(page)) {
-		ClearPageOrdered(page);
-		SetPageOrdered(newpage);
+	if (folio_test_ordered(src)) {
+		folio_clear_ordered(src);
+		folio_set_ordered(dst);
 	}
 
-	if (mode != MIGRATE_SYNC_NO_COPY)
-		migrate_page_copy(newpage, page);
-	else
-		migrate_page_states(newpage, page);
 	return MIGRATEPAGE_SUCCESS;
 }
+#else
+#define btrfs_migrate_folio NULL
 #endif
 
 static void btrfs_invalidate_folio(struct folio *folio, size_t offset,
@@ -11422,9 +11416,7 @@ static const struct address_space_operations btrfs_aops = {
 	.direct_IO	= noop_direct_IO,
 	.invalidate_folio = btrfs_invalidate_folio,
 	.release_folio	= btrfs_release_folio,
-#ifdef CONFIG_MIGRATION
-	.migratepage	= btrfs_migratepage,
-#endif
+	.migrate_folio	= btrfs_migrate_folio,
 	.dirty_folio	= filemap_dirty_folio,
 	.error_remove_page = generic_error_remove_page,
 	.swap_activate	= btrfs_swap_activate,
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
