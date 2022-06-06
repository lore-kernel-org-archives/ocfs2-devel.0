Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEED5CCA486
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 20:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FLIzUST5KX4p3KOY4fGikfLNYjEWWodx/Z7goA4LYPE=;
 b=WAnXdHmpMaN/9rt7pCTd6LKNZgDaHeFGrzmDuZljg/MYENV/acN487P/9ajzPYdRDrBsWi8rXMZX
   QyRYPbFaL8dwZq+Iu5fGX3muhkBEvF62w5aUi1fFICk3qti14FyBgH1IEVLBzyFgwmYwjRACygJr
   hDC9EMABcJOenejT1MnCXWEi846+vjB9olH2Zrg7r/i/1+6jxr4yFfLf0mQ3hAa++1mPnMQ+kkSM
   ihlnM6BN+2KviDJJpiF3t7U2oM6TjJD47XkZNtxZG0G+XzIZu+UHDj9p/LF1Rqe0sjuIkBUjaEmf
   Zpj/G6ejnlQMS4VML+Ky5uU9EcmkcyrHEIITAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FLIzUST5KX4p3KOY4fGikfLNYjEWWodx/Z7goA4LYPE=;
 b=Ntx0yClme1umHsKYSRt9EJnOQeupymouQSFrBG5T4YZCKewnag0GG1yAMmzyXBf9w7yL/6dWM/T0
   rRADPexWkEtb5ERpKY7/JAXAip+l8Eyy+o3Cp/ZomkZwmFvN80DgGqGCwtrvjlQn3+OT64gsQysf
   0HK0fhCSLeRXncqBALEq58XYajQN823w5f783LvprKvFJlSe4uVNit/j+8pZsEEaPYxmQ0I4RAyP
   /cbgrGeH/uG6XGL6BxluLudL5AUGg7hg17Jx0fP0TJUqK18aAPvlM1SQj+T5MQyFOJsH8fcJju+7
   XGFMa7eJe9UDOOhwjSp3uL2r7HZvXn2bl6jiQA==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD200CW7PH2G830@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 20:41:26 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=mh8Dq/H+EOoK+/6ImN6CHd/++DWMbIlB07P33o4BRwg=; b=kTMy4T7HlsUwOQX8f4QQV+5GP0
 d2BPsYV05ijHNUiGSBK/JJIvv3xLKspkoGfdX+PMam1j5Xg9jzguWsSeUNE35UNwheoWchJtICWKd
 v6bX2YXq8GSXTqi1MGo6L/yfFvOIttBKUu1LImX/eWRZ4ENj5Ta17pHs4l9ec5jgZR1Xjda2ExWS+
 yNjb7Y47V7B9Yo7pPITZdYU0NXdb8X5TcQTDL57j2z8HCFFsG3/TQ9RZNnnIOmkvMRexAJki1GE57
 L3C0azwbeRNYpI/2G26pxpropqDN9TfoMXJHf/DLJLI/bI6XNuSxoFpAHcfTC/sJz6vMnR2IhRaTR
 Nsw3A0UA==;
To: linux-fsdevel@vger.kernel.org
Date: Mon,  6 Jun 2022 21:40:32 +0100
Message-id: <20220606204050.2625949-3-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220606204050.2625949-1-willy@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 mlxlogscore=577 spamscore=0 impostorscore=0 suspectscore=0 clxscore=159
 malwarescore=0 lowpriorityscore=0 priorityscore=164 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060082 domainage_hfrom=8378
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 02/20] mm/migrate: Convert
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
X-Proofpoint-GUID: huV7q-gXLQE6_5dvM9h64anxuIthWr4p
X-Proofpoint-ORIG-GUID: huV7q-gXLQE6_5dvM9h64anxuIthWr4p
Reporting-Meta:
 AAGfzOchwV5bbnOwDUAD38+wjW613YqGEUhTlRyOkjGlfuvn+XjZ/gDHETjh2sA8
 jp/WtU/yE33znsnDRiy45S6e+hB6Ipx+TnVV+EZJX+ItJVa+vPsN+ERLUgy11yO/
 B/xhRckL1vSkgolcHw2W5dBJinoQrvBteBhyCQeRLP1u88+pzZiF48XWm4WughyA
 bAlW2uXMKEFnpSfCa5AqHiDRW5OBtsAsfDicx80ftNLuCA45kkKFgI4x9SsHiGR1
 c8UsRPfJ+ZWxSB4DV7cC/wU3tUpodw/wNs2sZb9bAqn+kg778TJlhynv0kC/g2oX
 v6jG3pyljguIHtub5UYTZXII4NQW05tkVt4cOUMjv228NVWU8Ng3zQpxdPiZLU6S
 G5O+RArRrOKd571LzieFamyTO4q/G9HKHobPy0Bks8CD89lx7uXxMrVi+Ctu8iIk
 3Fi2mpwst6m1yprY4WZL/f3sEY+qX3qF/iKSJKll/X3W5LMprYlC/OTl7AdEaZLW
 YYA0+Vap4+1mJSYr6PPixBGPF/C3NgBQWL1bcmhECIxb

Use a folio throughout.  migrate_page() will be converted to
migrate_folio() later.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/migrate.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 75cb6aa38988..d772ce63d7e2 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -806,11 +806,11 @@ static int writeout(struct address_space *mapping, struct page *page)
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
@@ -818,18 +818,18 @@ static int fallback_migrate_page(struct address_space *mapping,
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
@@ -872,8 +872,7 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 			rc = mapping->a_ops->migratepage(mapping, &dst->page,
 							&src->page, mode);
 		else
-			rc = fallback_migrate_page(mapping, &dst->page,
-							&src->page, mode);
+			rc = fallback_migrate_folio(mapping, dst, src, mode);
 	} else {
 		/*
 		 * In case of non-lru page, it could be released after
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
