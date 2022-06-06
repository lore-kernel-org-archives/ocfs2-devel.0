Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C8A0CCA486
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 20:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=o5nLBirGmYOJb2lrxEGaJvMPJTV0xcLQYA32yNnDwkk=;
 b=JNg1evALYqkYyhjVqmiFAsMAFMGQUyHcwZHf5NE4D5da4jo9Uyg2PziB/OVqfD58S894gMU+xWrd
   XcoOGUBKqR03qu8o1nHjWUDGFHjL24cpc2n8Qyn65encC0DQxDl007NneUgW2hx1VfXvClb2F+8L
   ONuAafC6ohmw57eVs4TzJr0iv2ddYcRO8o/Sam1aU6ikLaZoVA3IOzYjN9ocUtoN8SAH6QVIE9Mk
   XSbQUQV704OjjAfSc8MwQMUq74VGbJWe7wbY9KD75HvXyhlVRyqMw1bQSUzfqUEID2AVJZa0azT+
   sStOwZNGLkTINMPy5/CaBU4EVw5rXNgyON/k/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=o5nLBirGmYOJb2lrxEGaJvMPJTV0xcLQYA32yNnDwkk=;
 b=Zq2YiKw8O60XFmx2iTtccre0bKaMThWKdMIxIlAvFIIzjS87XfqgH7cF+HSVJyqVz0DhtW2FUTs7
   B5JMq60IgGv04lo6++n5sEEeQrna8ISfjj3o3yXHZW8idlKLkhLjyStqv7ZxndeHnBrtt220dmEV
   JIdaodhU81IkWuaPagm/F44C5i5Y9jRfq2P1e9BxsFna1lzY5Ik24DUXOIv1y1nQPuzY4hXJE9a+
   92xJKZ5o9OXFacNtx47IHJaM33lH2fPTZQymsSY2zLU0fg2p9Pex1uByy3/zhvhRJQ91bqxIXdyU
   znVuJctajA9ywiEVm+PQPv1Su2yGzEdRddmyEA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD200CJ0PGVLS30@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 20:41:19 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=Nbr9wUy4GZu/A9I5fNiEUH8YjHUTRzvYZO3QnrtHfqs=; b=Gd3hSiL+/E0dfHLBarUzOacZ5+
 RgLt/HR3/LRhEZeLymFVkZyeDV4o45ibioJi0eraHf6ehCGQbtosb1TjID04N286tCzWwDmpddr27
 H3ByN9G6hK5riWHYLqRkTy3GsEZUgLnYhezqas1+XNq5pmGlpRnM2NevyEDgUXJ8ZYsVlaLiCT3RO
 8Ehpw8He8k5yQNPfIvPT9F5a/3yz8jOKKKyGe7pM1yVoqkDKz2YPmFcUn0VPuUW3SPY9tPOvKaZJU
 1Vf1NH8uVC9GEQzwQCTJYo35GSSSaLqMV3XH1X1fzAEkojyoaH3wkOkh+Z2rcUydL6L7kLEvUr3mZ
 LKB+9tpQ==;
To: linux-fsdevel@vger.kernel.org
Date: Mon,  6 Jun 2022 21:40:47 +0100
Message-id: <20220606204050.2625949-18-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220606204050.2625949-1-willy@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 mlxlogscore=656 mlxscore=0
 spamscore=0 suspectscore=0 priorityscore=108 phishscore=0 clxscore=163
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060082 domainage_hfrom=8378
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 17/20] z3fold: Convert to migrate_folio
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
X-Proofpoint-ORIG-GUID: akP4faCjPKCNeCZ4DQQs3K7vssJ9Eqx9
X-Proofpoint-GUID: akP4faCjPKCNeCZ4DQQs3K7vssJ9Eqx9
Reporting-Meta:
 AAHQEyQGSzSJQNGu8bPCUMoAs4dNlMrHzztuJWhktkafkkoBvrE1ujnh/k4YV8eR
 7ywSA1cPhApfMmn2clb34DSVj51jM5oSm2Kbh4GnFAqoqOVpcn5229uedWlp1/eC
 o85QGlKeysem8xfbMT7ysnj36O3qdaWxyIre1tPbc6HF4wj8XH/WAUyAVLKoF9YH
 /i59xIXO3W6myJ6SiNb2arPs2nOP2X5aPKlWkErpwwNxeS0qBwR7HRYj4yMBxH1v
 8i4mEsg5JqUWDFvnfyicrnQ4/RqLihEu2Nl2wMr7yuNDWa5YqfAyNgwSwu/rHOZf
 nWV6bPa/wCvoyAuv0ZrAD4lcufWKeESNeLuuvEHrn1GENVpXoH5UzUx1PBZ3BPG9
 7JHHlMh3iX4tQ2u7y8xMVurE3u+0ayVF2hgSe5K1JGBc4956yt0A3Kjj/mBBO7GI
 HbtN/G5hLAZcfY/qMGtn+l/XmytiqMhNFw61jhLXjXIuXNyJ5HphygGouzE9g0za
 21nwOp7y2YjwdDbF14pWzQpGCV7k3/vrkzecpRrN0jN2

z3fold doesn't really use folios, but it needs to be called like this
in order to migrate an individual page.  Convert from a folio back to
a page until we decide how to handle migration better for z3fold.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/z3fold.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/z3fold.c b/mm/z3fold.c
index f41f8b0d9e9a..5d091c41fb35 100644
--- a/mm/z3fold.c
+++ b/mm/z3fold.c
@@ -1554,9 +1554,11 @@ static bool z3fold_page_isolate(struct page *page, isolate_mode_t mode)
 	return false;
 }
 
-static int z3fold_page_migrate(struct address_space *mapping, struct page *newpage,
-			       struct page *page, enum migrate_mode mode)
+static int z3fold_migrate_folio(struct address_space *mapping,
+		struct folio *dst, struct folio *src, enum migrate_mode mode)
 {
+	struct page *newpage = &dst->page;
+	struct page *page = &src->page;
 	struct z3fold_header *zhdr, *new_zhdr;
 	struct z3fold_pool *pool;
 	struct address_space *new_mapping;
@@ -1644,7 +1646,7 @@ static void z3fold_page_putback(struct page *page)
 
 static const struct address_space_operations z3fold_aops = {
 	.isolate_page = z3fold_page_isolate,
-	.migratepage = z3fold_page_migrate,
+	.migrate_folio = z3fold_migrate_folio,
 	.putback_page = z3fold_page_putback,
 };
 
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
