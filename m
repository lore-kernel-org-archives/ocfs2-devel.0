Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F810CCA48E
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 20:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=biioD3r8xoOjpaGul/VIbmJ4EUj5EXXIVmipjMZu/cs=;
 b=iRAhIVrRDb0snUcm/UFmhErNIE5azD1DFsTkVLBumS4iBQ/nEom42QKBZVTFtAzctfLW9MNmVCJ3
   EyC0vxXF3gjpxDSuupDtWNwLvtgtgi+vc48GblN5HHfOgav7TcYTLLWtVor1wyyaID/jrjSqWkJn
   FsecsDqmPGWKr35nZzYqVpRgyY02jy6fc66RC1A045kVYiEVvvyVesgasFc3h45USgcyGz9+FEjt
   0Fq/8kYRFaQGftAa+Nq8nBYQN7rYrHHDAqvljHtHuRG4evomQqhZ2Qzl3XQReIp75PeSdNMBxYDO
   P9J6LRg4xyh6R+BDxFo1o07oGmQZ3RoeCsBLjA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=biioD3r8xoOjpaGul/VIbmJ4EUj5EXXIVmipjMZu/cs=;
 b=cZJwVK9n3pHjpy9+jrU0FGHUxF1XDLPZjlrpaYgxVRS159cn2ORvyQwmAeBm2FH4SwaUUhdyCi6f
   6Ts8Y5pxT+ZfYmXr2zhlcn81Kn+y6Byi84/U4gAA3xwjso3Mf0qpsd0MGqWuoPhkTTRfNFfHty0B
   HVk2xqOcczieZ0+PT4yQ4lsCaqKMWEN85PZKBR2AKvP66z53puZ5xtwHAIV+NcjaE7yyLej3LZc7
   T8a0w0wOPzzpOVXOtZ0XRaEeaLIwuMVkzHZkuOxGMFRBoj1neJH6rpycXPx+IYEzzsaESUqFsNOi
   q53bd1tead1TgkCZEvgd+AmmTIHNLQOEZUZ/GQ==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD200M91PGW5EE0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 20:41:20 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=NFScYX57GEbw0yH/d1QXpe8YFpfaQsvuaQCT3ii6ess=; b=mDp4J3wn+JfgTBMvZgEUqjDjOc
 MdvHmectsbLkZvfTk8nG6ytXS1+4dBHiC4pMAhcy3dH+w+BngrUwTH364Opf+ULDH9RffR6xS8W1s
 NvNCsPvgWsTpdK5si++BB7gskVwFgeJKaRz9oSkBMT/tvUH1htLz8dXlAm4tajf1oQVpZT/iQpp3Z
 3qvjBqAGoN/HgsaNXSczCYJXunICX2cMGKbV8nqWYAZ1dFtuqgFYtfMpTC7xMxk50hUBGd3mZWqxV
 6hlTudv8DYvIDVhKEtAVCLpJUOSZgQOHlnJd6eZoWquUE4SD1aKFk5s64qg6Qy5XVFt9b2QyPeQP8
 VdadEfOg==;
To: linux-fsdevel@vger.kernel.org
Date: Mon,  6 Jun 2022 21:40:48 +0100
Message-id: <20220606204050.2625949-19-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220606204050.2625949-1-willy@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 bulkscore=0 spamscore=0 clxscore=159 mlxscore=0 lowpriorityscore=0
 priorityscore=164 phishscore=0 suspectscore=0 impostorscore=0 mlxlogscore=668
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060082 domainage_hfrom=8378
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 18/20] zsmalloc: Convert to migrate_folio
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
X-Proofpoint-GUID: 7-lD1oDmqA0xZLeE94WLbZNh8Lxi5cIb
X-Proofpoint-ORIG-GUID: 7-lD1oDmqA0xZLeE94WLbZNh8Lxi5cIb
Reporting-Meta:
 AAF+vZBWuqLKC6usvZHinyb0SmD4DKO0jDi7uG/wvmazqRqZXze/vVflvuW+2aQ5
 h5WPpgSaHOzsalLcvu/5B+tsgjdKmVxIhES5+7356aURXIBb99urw8MvDjmlvUCC
 lANQzEX6d/JmXz6ULL8OIzWhJpJuSL3925klBskWBOYK7DM3hhEAZWp709Mqd8L3
 tZfJZM22tLth5gLR9Cy4qALeFJjkKXFynqnaQi+Qla7L5dr9W0gBsLOIHVgzwg4M
 cYz0ZncfXPuj6qGtCzWh7UFthmuIeRN1rcHDbxZHpS9WMbAgNk6V/p5LgfTFg80S
 xzyGZ7SFM+RwbGrtbT+vaN6xIcK7aB9aQeLydQiaNGkRuE0lhYcuY/Tgt1l7tZH0
 CfcvqIgn36D4S+R6qfdqrubzgB+2AAJZvRrwB3rCoWnckxicUMMNpqjDuKNr1/Qh
 xaEHWcJASm/6OcG1PxvBUr34Ddeu6aFQYBZvOMiWdFwY/ZLMQRDx1MOhWfg1oeSm
 acR9Yfmtv9xtsS72bZnrmWC1Xet354T5oOMxAuBWLv/j

zsmalloc doesn't really use folios, but it needs to be called like this
in order to migrate an individual page.  Convert from a folio back to
a page until we decide how to handle migration better for zsmalloc.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/zsmalloc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 5d5fc04385b8..8ed79121195a 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1865,9 +1865,11 @@ static bool zs_page_isolate(struct page *page, isolate_mode_t mode)
 	return true;
 }
 
-static int zs_page_migrate(struct address_space *mapping, struct page *newpage,
-		struct page *page, enum migrate_mode mode)
+static int zs_migrate_folio(struct address_space *mapping,
+		struct folio *dst, struct folio *src, enum migrate_mode mode)
 {
+	struct page *newpage = &dst->page;
+	struct page *page = &src->page;
 	struct zs_pool *pool;
 	struct size_class *class;
 	struct zspage *zspage;
@@ -1966,7 +1968,7 @@ static void zs_page_putback(struct page *page)
 
 static const struct address_space_operations zsmalloc_aops = {
 	.isolate_page = zs_page_isolate,
-	.migratepage = zs_page_migrate,
+	.migrate_folio = zs_migrate_folio,
 	.putback_page = zs_page_putback,
 };
 
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
