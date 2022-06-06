Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CCC7CCA484
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 20:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uVi3BViGwHVh3aaNhUTxQdtzqwE40surl5+dWdUrG2c=;
 b=y+XioO3xGaaXjhGqeIMyS2O+UG5j/F9BICkX8UAzKNgqt8fu74O7ohrv+YJ2Iu1PyGUz9UdUPaph
   Gr5vaP6eUxA8NhfNKrWt5d8cD4IMCH0FRGxEvB8Fj6Ui6tgFWaA4SL+IZGfVdc9QLExDuP6/st7B
   /k6OLWwhvV1jN0ggSaJO5GySWAPDPHkmGiKWxeKBQy9hk0KJulCk00DeMnHJ/4guCK1IgUVW68BU
   wCxv7iKyhBUVyu08RW+AtVjDMt4vIrpl7bheXs8KMgTZlaNqvQLtODbfpRm1088B/cBuIaoDRTFW
   WrGztP9PBTpB5JoGIa2hvEr5nXdLeylPWWrGTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=uVi3BViGwHVh3aaNhUTxQdtzqwE40surl5+dWdUrG2c=;
 b=hwxAempgrCzEfGBk6TD+ruFo2ug+7K+s73G0bcZA25G1/gO+QJl9kFZVkUGpqHQ+Ai/E4duxjc9a
   DEtx/b7HFmW9HE7EbKVbb7shXQMh6aL3bFvSsUGi8DOElwn0KoSg3wTYzeGBN91D4GwtL0Zftf5J
   lkQaBi/RVy9xsuo06eE9vfBgMLCX+DmvTNrmgXulZ+bdk6r+6Z3dd5KuWHgOx82j0I02AY747v09
   /LuaEcvL8GZYKlpm7Tbhzpd97yI0agmjpNwa9G5ZEuQGIyoMR3kcCuyUvYY7PBBWUAtv8U+d+gRe
   x6dSg/klqtlbyy6Qf3LyD9IAQjfvx7abOY7Mog==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD200CWQPH6G830@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 20:41:30 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=MljmBGg5QLNrlXQo2zoqyO/w7uyNryh0JirP0K7S3ag=; b=crx1P1AOzfaVjsIjKFsnW/dRPz
 BXw2ENLZjBS3Tf/K4vlxUvTW65vSWeLe4SK5T0Xn+T+dHDiJg0i+lSt2MU+wL0lJZ5+okWaxAgbc0
 Z/vst7YgLlz94wNZjneO8OUXYrNEJKVSQQicN17cN1YoPQTICS4bXGxyDlnzy9O5ahmISSxp7vpN/
 Hwqq/epOdfS0GN2mfRLkGMDSNsHzoUSO3A1kzb8obP6+oMgROyOVolsUsjhQaeGAY7SVGoFC37P39
 vXEmqMt5KDLiFuVK/vK6EVvywxX227bt9H9wiRu2WVwsFGhB7SVM3X8Mlqtvyz7jItHArnFsZxYgX
 ssmeGojg==;
To: linux-fsdevel@vger.kernel.org
Date: Mon,  6 Jun 2022 21:40:40 +0100
Message-id: <20220606204050.2625949-11-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220606204050.2625949-1-willy@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 mlxlogscore=619 mlxscore=0
 spamscore=0 suspectscore=0 priorityscore=115 phishscore=0 clxscore=126
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060082 domainage_hfrom=8378
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 10/20] btrfs: Convert btrfs_migratepage to
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
X-Proofpoint-GUID: IgUYTdOJ0eLN-ZPTzuGT7EiDkO3eYKDa
X-Proofpoint-ORIG-GUID: IgUYTdOJ0eLN-ZPTzuGT7EiDkO3eYKDa
Reporting-Meta:
 AAERZj8mkz0aTDXy/y2S56ygoDSx2v72QWWLs4qfubVg/8QbxdpE2CEZ8CtzASYq
 PVKMMdtYJkgm2kasANXYHQ+olhbxt8sqFbNzkkdQIWGdmO3qcApppYWrfSRb+bnh
 zf0mKY8ago3PldxArik5wUYGm63ddsyRMc63aprDawLCbIZ+t+rDHWmchZ4OmZAm
 PORkzOAm/6tMSuIeIyT5JxbVi9sfDQj+Da9LFHV840hCKBWXOx36H9TU0xD3yLmD
 faIPX9ijEM8yGnSWIkkGv+r4WZffwvF2XxL4DdEhePgo34JagRYmYFI4eSUtchgw
 UF7MfymTtGyYgvRgWHNljEJNKXh0DRYCcfgLEzZrEbysvlH89WIGucmUS3rN9bNT
 rHc39XDVpN7uDNj/defdINZGiAAvrezh5STL4izvvIheTFLNZi5m1gVmzPzIZHTG
 HKJ3nJP1QnAxrdk9XMPAdJD/nAbOAdELfrz6ThHMi9Kve29eb5oZIiJYk0ZGNuEz
 qvBNkKhfpoX+yDtzq7ZulY+eSOI7sfAA8cavgYb95U0EqA==

Use filemap_migrate_folio() to do the bulk of the work, and then copy
the ordered flag across if needed.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
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
