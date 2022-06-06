Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADC7FC433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 20:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=HXq6q/Z4naTWQ+0j7SPlFiRsk6Zdnn6dw4lyAyAHgc4=;
 b=MTC/5woFr1+2W5sPIHifwli68zqe50SS5xnrBlNzeu2lo9IykGETFkcVPBiLvKkljoBnenn52nY/
   M2g9++zQKG2ynnWldTQhDxslhP0XfIx5o9pgDse5V+gf88P62jUtMGT1mJhqDzUxfKjIA/UfzwwY
   ducSvUvvPuk606neG/cqO2JqWPCOf53GLkURy38gT3X5hU0OIx34ri4pnGG/ef/Ek+I74Htty4sm
   99/qUOSsL0NcJlU/MLQIsC69jbZai9MQoZxdq9WmB62WLepemkVOW2laTjo9lGa3XUwfp9Kvr8Sf
   UpJo6TQD/sX3Ekdg7vQt0e4jIN3KF+mTVnhqGg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=HXq6q/Z4naTWQ+0j7SPlFiRsk6Zdnn6dw4lyAyAHgc4=;
 b=iTj5txKkJyIbGKM58Q0iI0BYTnpTKFCuU5HBI45JDn+0iEkGMgrVStHRjLqEyP5VSM7SGbHOyifU
   cTVwu8MaiBw5yZdVLwJJH8EgY6RL95rlzHGJbBHByDDAhaMfbBdjdE0FF+4JxU57+rlHLMu4hWBM
   pzYvizSjoM3xb96SZqq84wizTxAhaiLKWs+4MtLU95s6xcRmI86OSFHLuh6RD6aerjW+sMBNXIbW
   G1kXQfzS6SRRuEGQWPwEhjWEi9pl5BRxzKOlY0p8XPnJHNDRoS7DnSaMprROF1KkSv5janJhs83x
   +SImbonoop0JkmwKueiAe6mvzpB3tnbKjt4NMg==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD200CQJPHMQR60@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 20:41:46 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=PTb1fSw49y2qxNUUq4k5t2uIOYf1rKQU0qM36b/uqdM=; b=moAsLc7xAe9cCO2yLS/2VDmHEw
 YBwWTVJr9kJRjwoeFhsNnd8JLuuJjbq0xBtc3hJNd0koz0AzNRiu2y+N5Os1g1/u53LaRvxXW4rdM
 tHwy5XlETEs430Lov51yIttD+nu/AmMuCt1+6O5d08aKIMBYPTBY0Yt54xqFYELLNo0/O6twSwDnU
 wa3c1U/y/ETekmwC5gKHpa1nMck5VNxLTjucI7KCgMp9l5cOztmW0nCXmpkBfBeAli7aijjbj7GhC
 zHPVo0ax+4QE/HagbZZ6pGGOB2yVWmyQYd5p+40+xWsAl8Ab1eGJlEDyjqzfn+/+j35DgUlM4Y7a4
 FS4d0iCw==;
To: linux-fsdevel@vger.kernel.org
Date: Mon,  6 Jun 2022 21:40:35 +0100
Message-id: <20220606204050.2625949-6-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220606204050.2625949-1-willy@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=260 phishscore=0 adultscore=0
 malwarescore=0 clxscore=159 spamscore=0 mlxlogscore=539 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060082 domainage_hfrom=8378
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 05/20] mm/migrate: Convert	expected_page_refs()
 to folio_expected_refs()
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
X-Proofpoint-GUID: X3pBUipsu6b78NjHw_P8-aM5jONIQBN3
X-Proofpoint-ORIG-GUID: X3pBUipsu6b78NjHw_P8-aM5jONIQBN3
Reporting-Meta:
 AAERZj8mkz0aTDXy/y2S56ygoDSx2v72QWWLs4qfubVg/8QbxdpE2CEZ8CtzASYq
 PVKMMdtYJkgm2kasANVEHg+olhbxt8sqFbNyQkan9zMv8Z8tbYvT6/5R/DLBYxAk
 sKLUSfcvP5mIiokd/N0kDA4GbiaIvFDVOJkxKQ513G+LNFJ5nUGgSuFEEX1QGSzw
 bt0Sb30e3aSazbWsimkxEX6LdsC9dOUTZP06IS1IyVqIMQcNvbwtxmowNktOpZEE
 UAKpkiV4x2fiHhTuP+HQEIRB2TXtklHiJPvOLSeQzHihKo88erihnwEmCiQH28oh
 0sFToLEOsrPImMIicATukqBiwMANLpUoxrIEwpsviSUwbocRdkW0KiBIqYaS6gP1
 K8AZi29Of4Kw0CDVRCLaAsz4fxQ/WzkMXBGxFotnDj+g0bfkdSTx/CrKVds+2WuU
 ad9IHMlMkV3da/mUyMnvonAqVPDNsiYRFPUOBAh9owHDPqrswZleWctGGXCs8Nfa
 c8ylO6yylB3cskV/Vryr7jYvBVP1XV8ipyMUBVhzb1yx

Now that both callers have a folio, convert this function to
take a folio & rename it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/migrate.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 77b8c662c9ca..e0a593e5b5f9 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -337,13 +337,18 @@ void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd)
 }
 #endif
 
-static int expected_page_refs(struct address_space *mapping, struct page *page)
+static int folio_expected_refs(struct address_space *mapping,
+		struct folio *folio)
 {
-	int expected_count = 1;
+	int refs = 1;
+	if (!mapping)
+		return refs;
 
-	if (mapping)
-		expected_count += compound_nr(page) + page_has_private(page);
-	return expected_count;
+	refs += folio_nr_pages(folio);
+	if (folio_get_private(folio))
+		refs++;
+
+	return refs;;
 }
 
 /*
@@ -360,7 +365,7 @@ int folio_migrate_mapping(struct address_space *mapping,
 	XA_STATE(xas, &mapping->i_pages, folio_index(folio));
 	struct zone *oldzone, *newzone;
 	int dirty;
-	int expected_count = expected_page_refs(mapping, &folio->page) + extra_count;
+	int expected_count = folio_expected_refs(mapping, folio) + extra_count;
 	long nr = folio_nr_pages(folio);
 
 	if (!mapping) {
@@ -670,7 +675,7 @@ static int __buffer_migrate_folio(struct address_space *mapping,
 		return migrate_page(mapping, &dst->page, &src->page, mode);
 
 	/* Check whether page does not have extra refs before we do more work */
-	expected_count = expected_page_refs(mapping, &src->page);
+	expected_count = folio_expected_refs(mapping, src);
 	if (folio_ref_count(src) != expected_count)
 		return -EAGAIN;
 
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
