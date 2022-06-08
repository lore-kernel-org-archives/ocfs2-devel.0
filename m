Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A28A2CCA487
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Z6qv6nQajL5LYz119/Y+gW9X+p5b+/Nez+TXuqLVFgM=;
 b=i8hOlktWqKnReQLjq2HQiHl7mRhtmI5HixRFNlabpRbO/2y2LTjiYzh+wQObXBUJ7I24sKQAw3r5
   5qEA9Q3bA0QcPylAY+G4oOhBFc6G94xPqaX6jl0/v0/LgU+h3wjfymUkqzRXnUkA5+GB1Ce1Bumq
   TTr/8HwHiI/VYdOSmWPBVD2pd/ZLx4WX5FdSLvdvZqvlTMcSulJTSKRk2RZo5zcVLgBj4m3M2Ik3
   P0ulnfxZ9V4jMxpzgscdrZzozmVy/N1Rfe/5clXjmb69QiFzkbuIzZp83c57fTqJ77aUq3b96Rbn
   aPADjw8Tp8M0h8x2e3a4G0DeKgCYWOb+d71qCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Z6qv6nQajL5LYz119/Y+gW9X+p5b+/Nez+TXuqLVFgM=;
 b=EeDQKTtbO89wGSBY70kxD6+RiT8whl/jzCrbzhIJcfQFWn7AVUXQbHWHCkWWxCTF8mPvvNg4k68E
   VVUasNWVwlZU7rTFMx1nLz39YRWBCh+TNBqAdsO/WOJlFAyPoOKAA3iuHvgkMcMC2lZq5v8m3Tvu
   Bj/zG4W5fqSn92dIcOhPEBHGizG22DIhbW7mHKnhkuzuAyzQ3IMo5wkJz8kis+bomc6Ix+Qx4A4W
   35xCbmNDuiWm3aXZtAdfD5JBsAxBpBIIaQDzCfWOs0sNeIPVZNpT+GEnvHhsS1oW0GEWztOC8tcZ
   bnQHzfHZpAd3Z0mAK0GMn2XDqhpIMrJmJg/DnA==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500N26Z6BHBF0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 15:03:47 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=3fQqNRsX2k9U5g+9eAzNLqy1rB1a5hC9OuR/TIVAv1c=; b=BzgCA3dtIfrrNOFOqZw+rQudkD
 nQHTv0fThp0cTrpRot0mmwRsAJIVnWEYdCMHR9+BI2vGiioilWMA0f5/jrc3m/9O4FeZRtFwrPPEc
 CRfaG1TVqvJZrjE8U7i8Qn0EyWZ+Huymk4p+kP5MwP0AvEE0aparXlmBO+8OO8YLNJ/O8TNmYzM1V
 BXTwncOLifnP30UapOFmT9Bg5IFrHfXxgFF0f3vKoRKkVZZE0LLbqRMWs/kl31OrOiRyD/mlQMkWG
 nU/8onyZGsVXhJq4qZ+wDdd8mdRf0/qTyqE2iJ8XwE6Cg7sqF/OMB+hYJd6qhVzvrxdp3ZngOZ9qD
 bKJsjzIg==;
To: linux-fsdevel@vger.kernel.org
Date: Wed,  8 Jun 2022 16:02:35 +0100
Message-id: <20220608150249.3033815-6-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220608150249.3033815-1-willy@infradead.org>
References: <20220608150249.3033815-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=709 suspectscore=0 mlxscore=0
 phishscore=0 priorityscore=304 bulkscore=0 clxscore=163 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080064 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v2 05/19] mm/migrate: Convert writeout() to	take
 a folio
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
X-Proofpoint-GUID: eNUONIFDYJCnPifd0X6xOGep11cBdwwb
X-Proofpoint-ORIG-GUID: eNUONIFDYJCnPifd0X6xOGep11cBdwwb
Reporting-Meta:
 AAHT2JNrCQ6PRioUc+pdmwRKrlltHZ8hL+X+sgdTRbmey/IQcDuchq6AnIe12S/3
 p0ivMYmeIuEil9GzMfSPEuz+BOSJT5/KdcI0qMj3CCrWjw7/USw1AsviA+hmy3i3
 iLapXcPHVUgiyNabjm28hF7AYGqeGS2G9070HpHkfYYeFyLXm9FcXCUJCELZPwE9
 HZhLKDKo/y0WkvRIia7wtsbOK/tF3SKr4Qk4xKiHc70MezqErkEJiUwcAHCmTI4E
 Yunz390TiKOCkxin+BEFuV44iWMff31Dq5Si4PFMXFDhRFZgQ/E7GjV2Scdpc/YD
 KhI3EuNLjK1pq/Mf/fD/ONAJL42aWMLQCxpM96R97+s/q1elY8rcTuTdNMmJOrt3
 gHGd9L/WlEXRLCL2xCxP0277VCnQ6ZCJJ0+0kmR21yXjntWBcAJYrW0uTLfg04l2
 E2uWbxbGvjyHhMgbYxY6IixRAOAg6SZ7IcGg1l5xPjYkjrkOByGDyCSAU3Es6Lws
 N6ehlUdKS1PaiKP9yLtPA6Uf2BQHHIkRwps/I/w6rT8=

Use a folio throughout this function.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mm/migrate.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 1878de817a01..6b6fec26f4d0 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -761,11 +761,10 @@ int buffer_migrate_page_norefs(struct address_space *mapping,
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
@@ -779,25 +778,25 @@ static int writeout(struct address_space *mapping, struct page *page)
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
@@ -817,7 +816,7 @@ static int fallback_migrate_folio(struct address_space *mapping,
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
