Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E059CCA47B
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=LOKt3+cQNixaX8205NBHspZYyxrdXBbSN89YKIljoQI=;
 b=kdq4xhrAN/dcYkCDJ9EZ6rP3p6GfhdiefiItn8ydrmXQ5w4fKTH568sp4KWkAHZb/98b4T6E1iAq
   iFQezN4MPhomwZnt2d4HBRBY38NDRGDRwBTZFDXXqtqqkkZoD9g1LUgD07JqmRdTZF/ARVG41flr
   0F9EkkjzTVNt1gm1wIEt1gBaGGee2957VdSJvJZjwHkI3ZCun8ufBZqW/9ldwR/Nr00yXj8IArm3
   ZdZ3AVWd/ClLyd4gBZDc/F/UBlfJ1pFFfcJfzk+vx3bOppTKm+4cgmomGDrHKah3AuO3LoodjwC8
   +0t0J7ybhwgaSaLWog8oG98VCs2Wbf15cLfs9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=LOKt3+cQNixaX8205NBHspZYyxrdXBbSN89YKIljoQI=;
 b=K0/bRIlfHAB67fh2b+1Q5dYIxvMfnaGPUpIuU8T064fItGvj6+hiw/AR/8UHAIU4YsXF7L4mFkhy
   xbIM5bLBf7arcqm2sDEtaNTjkQzHIgb+jOtTBog0+mq8a20WsRjPsL5w81PiVZprl7RVeXDmwT7u
   jROo4XbRWMBEP9eDWcFk8t+z9Zy1N9/hxEfkrhgUaAtzxOjI2ZVW6tqvpA2OR4PXwgWlkjk+aniI
   5MztsVEjCu6goKj5s3KbdpS6ASK/GrVnPKzAiyKFO/XzMTNo2OwtLEQf2GYoJ0a+mTGG3GPAQq/P
   SRDnaGzhgZ3TZKRObDheR7/cKqULJFcuGw8Dtw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500H19Z5WNJ70@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 15:03:32 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=QtCpoMtKxHZJjZ0zPsproZBlL3YauaUrqZHnxvuWLJc=; b=h1JJSDwi8sTy0t0Nv3IdyI/SSp
 jIF5pVOj06evVaP6sUZABnjlIHzpvlc6aJOURe5UCkHnW3iI3QP4xuoymAKnzwHaD8MtjzeYqIepM
 2Ts3fRtS1qfeNFFYMc3nNHdcseIK1Vy47ZmaV51+uXh6fNAnQeRAvvdhoGqHWjTFkPzF0v9O7acf2
 xq4M713rzitxm3iOxcMIjCepwumvPeE3Jns/IcE3r6mlBV3OO8XJT8WSjSePKvPOSJ3+fKFPOWi4P
 sRSqkPvbSbV6mgnrsExhzcPOl2ztfXK38fZitzA3s6knKBMiAmpJwGCXnWQovlCajyK2bKysaYFsQ
 IcGOq5Vg==;
To: linux-fsdevel@vger.kernel.org
Date: Wed,  8 Jun 2022 16:02:48 +0100
Message-id: <20220608150249.3033815-19-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220608150249.3033815-1-willy@infradead.org>
References: <20220608150249.3033815-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=397 suspectscore=0 mlxscore=0
 phishscore=0 priorityscore=253 bulkscore=0 clxscore=167 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080064 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v2 18/19] fs: Remove aops->migratepage()
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
X-Proofpoint-GUID: 0NGTw7Igg538G6OlJXQM5tg-BWDoKUDE
X-Proofpoint-ORIG-GUID: 0NGTw7Igg538G6OlJXQM5tg-BWDoKUDE
Reporting-Meta:
 AAF1tUdJEGNt6jAZk02PuY0lmzyiDbNTHDyyl4PejXkB/GRlnwIHpa/qwhaIA6bD
 kQkPIAX+J/YIampU3iUjcBUr3uTlqLOF3oFOwASOc3OpV6dz/wqV39aF0pQrXy1u
 aHrt0adq9FASff0N+8I54BIjtHYtBq85HaDbVmP6L16CZsbHpAhHuBVzcNrADrJg
 UBK8MSQmGaYqSRqyW4LVtpApOwB3pwKDvrbaju6yrvtbN64yRjfLivXDe4zor0lZ
 T2D2bdCuXr/n5bmuIVvGbqVzXLoVB3fiuMAtXWyra8jVAYiB0iii2ay6bv7ddvux
 Gra2D3bMu2hgf0HIvjxUnmATHZ/3dOOJ0csfWFB0tOTwsoD9apwg41L+YUM2cbXW
 zxbqxq4wb13oe8X3/7heHHffyUCPYeibH+au8RwcSrudurf2neaq/lzkyaRAj5Mh
 U/bpwMykwd6fSuFht93IU9rpe0TC0HDOo7C4SirzZUztr8bEkrrO08Bioj2OZBks
 d5KDihm3kXB+lKhLWUd1zlHQGGykS/hX6Hgn62Tl65JP

With all users converted to migrate_folio(), remove this operation.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/fs.h | 2 --
 mm/compaction.c    | 5 ++---
 mm/migrate.c       | 3 ---
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9e6b17da4e11..7e06919b8f60 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -367,8 +367,6 @@ struct address_space_operations {
 	 */
 	int (*migrate_folio)(struct address_space *, struct folio *dst,
 			struct folio *src, enum migrate_mode);
-	int (*migratepage) (struct address_space *,
-			struct page *, struct page *, enum migrate_mode);
 	int (*launder_folio)(struct folio *);
 	bool (*is_partially_uptodate) (struct folio *, size_t from,
 			size_t count);
diff --git a/mm/compaction.c b/mm/compaction.c
index 458f49f9ab09..a2c53fcf933e 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1031,7 +1031,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 
 			/*
 			 * Only pages without mappings or that have a
-			 * ->migratepage callback are possible to migrate
+			 * ->migrate_folio callback are possible to migrate
 			 * without blocking. However, we can be racing with
 			 * truncation so it's necessary to lock the page
 			 * to stabilise the mapping as truncation holds
@@ -1043,8 +1043,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 
 			mapping = page_mapping(page);
 			migrate_dirty = !mapping ||
-					mapping->a_ops->migrate_folio ||
-					mapping->a_ops->migratepage;
+					mapping->a_ops->migrate_folio;
 			unlock_page(page);
 			if (!migrate_dirty)
 				goto isolate_fail_put;
diff --git a/mm/migrate.c b/mm/migrate.c
index bed0de86f3ae..767e41800d15 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -909,9 +909,6 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 			 */
 			rc = mapping->a_ops->migrate_folio(mapping, dst, src,
 								mode);
-		else if (mapping->a_ops->migratepage)
-			rc = mapping->a_ops->migratepage(mapping, &dst->page,
-							&src->page, mode);
 		else
 			rc = fallback_migrate_folio(mapping, dst, src, mode);
 	} else {
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
