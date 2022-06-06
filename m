Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 146B1CCA47F
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 20:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=xVM7UO5fDs0HX8yTI+kIO0QlrweIp4ctSVjaQallcPg=;
 b=vU/tOMeLB8VGxOvxiLlfohvBTS/Rh4GGXtHRbcQbBQzt0nXyL/pLKV7ceg8dNHPmYfubOI9FXNKJ
   xP4evdsL9aAKMzVHtu1DbjfBwbAJRNF7O9D/4pzFMKHRkbjNXX2ImgV3tgQtMJv+GGwj/y27U3eh
   JTDAHEnupP+aikUEI0ChTRzeGxf9EvWSgCcGPITqMxxajh/roHNrm5xDyC5uHpyZX8pYObJfS/FQ
   iKSm/WygbqneXcUQGyOPOHlqsRlfubI4tlzQc81oDJrZTlNnpsdFa4PnmfR+36bQ8/gITnfyBMx0
   oU8aXwjyQ4/AGLMutTwdXiF2LpuqAG8XPLJNcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=xVM7UO5fDs0HX8yTI+kIO0QlrweIp4ctSVjaQallcPg=;
 b=TrLJd0/0fyOmMvR5wHpKejrzQ4SngYTAQXZ9S9nV1gatizZUB+2Z54jp2fwrRlBkxGHlhZaWCNc4
   T7qYGIxxuaG4R5+o0rwQDm85rTHH6qWTx5iujOV8Yu6sGSgNGeD5GJQ5YKhYPk1KQUD2AzmTjNlG
   lQIBnGwNB+Sui4aZv4q/Smi3HPhutxvHZt/btz4rp2+ioEkhOf51P+Nv2laqzyKEqvE5hXxVNQgd
   WioKzkBkEv1OsSPL/95ubEQka+glajH9c3s48ZxZibwD1Y4RFYx+GcPHhzdb7gNMbxZUKAq6hbS+
   bgxJs9RrQKTbccEzFnVyw5q75cKf8oZhrqH1hQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD200CT2PGVG830@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 20:41:19 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=jShwzeL+5O6p6+KB8AXJd8QTjTM3rLlLO0YNnyhkzoU=; b=j8WB6rbesWftHu8QIJhuNjLLRv
 8UGF1DKSTdZLPDZ0Kov24duPgp8KMpi6m8VEsqm5e1sZdIO0hAb54JNjAbS00XQgXdsCx8+PvicwO
 rYdGhK7Gy6I6AX03/exLoIxL+gMZQDduaqInpnkGl13x/6LHcmOMXo+u8SO/crNY4L5fIgFOEe3TY
 clMZRMy11m0K44+Yi9a6EjLXZgw7NLEoTTdV/oEJbaeKVMorPM13Ba1mk7M/T/X6/bkJL+qWpRRnS
 1wANzqWwYhqp/CK739JNy4OmGeFkTAhy3sEt9IXLj+oIA+NjHnNm9hNBqc/doCVMUizMtdR2GOaOc
 gaaqEAJA==;
To: linux-fsdevel@vger.kernel.org
Date: Mon,  6 Jun 2022 21:40:49 +0100
Message-id: <20220606204050.2625949-20-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220606204050.2625949-1-willy@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 clxscore=165 malwarescore=0 priorityscore=108 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=259 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060082 domainage_hfrom=8378
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 19/20] fs: Remove aops->migratepage()
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
X-Proofpoint-ORIG-GUID: rAbmb_lw_pHy4fLOVKao6BO_Jv3bR7Jz
X-Proofpoint-GUID: rAbmb_lw_pHy4fLOVKao6BO_Jv3bR7Jz
Reporting-Meta:
 AAF+vZBWuqLKC6usvZHinyb0SmD4DKO0jDi7uG/wvmazqRqZXze/vVflvuW+2aQ5
 h5WPpgSaHOzsalLcvu/uB+tsgjdKmVxIhETsUtUjyTFE4cJXxgTho9LMSLx1+s8R
 HMrm5C1+Fo1TyJ3lQjv7kbB+Jq5x+Jspfs5GGnc1UXLJ5EFQhTImfWEgS6j6ynlH
 nhhL6S6wzcffgfB162XnLV1ITxYnJ6ZKBOVivJ8tujnA5r0mZtnOdux0MetqdxnH
 co4AP61hYbmGqz6/Vv5zYzm8GucXbyRcDV3meG55VOYDC9Nvg5rA1bPwae2PO/zQ
 h2i+60Dnmj6+mYSzRTpc2+h/jKZkzSAGTYOYbplPUJ/YSv3kME2kRk/1DMNec7bN
 /6ParZxckGQk92LcXmNEyDrgkQ2tafeN4h2A+lVSEnK/2LIrRs7k6veVRf1C5TaD
 qomNzirLUHaA3Zh3t3LD8F+rFUx/Sj6Ks1zVclIEuMFyZ9iU7dV4+r6TxQzDYX9f
 XoL2NPrA5/IM1Kmb1kJ/+ZzLE1LZrxu25FlTGZjwbsat

With all users converted to migrate_folio(), remove this operation.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/fs.h |  2 --
 mm/compaction.c    |  5 ++---
 mm/migrate.c       | 10 +---------
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5737c92ed286..95347cc035ae 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -367,8 +367,6 @@ struct address_space_operations {
 	 */
 	int (*migrate_folio)(struct address_space *, struct folio *dst,
 			struct folio *src, enum migrate_mode);
-	int (*migratepage) (struct address_space *,
-			struct page *, struct page *, enum migrate_mode);
 	bool (*isolate_page)(struct page *, isolate_mode_t);
 	void (*putback_page)(struct page *);
 	int (*launder_folio)(struct folio *);
diff --git a/mm/compaction.c b/mm/compaction.c
index db34b459e5d9..f0dc62159c0e 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1034,7 +1034,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 
 			/*
 			 * Only pages without mappings or that have a
-			 * ->migratepage callback are possible to migrate
+			 * ->migrate_folio callback are possible to migrate
 			 * without blocking. However, we can be racing with
 			 * truncation so it's necessary to lock the page
 			 * to stabilise the mapping as truncation holds
@@ -1046,8 +1046,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 
 			mapping = page_mapping(page);
 			migrate_dirty = !mapping ||
-					mapping->a_ops->migrate_folio ||
-					mapping->a_ops->migratepage;
+					mapping->a_ops->migrate_folio;
 			unlock_page(page);
 			if (!migrate_dirty)
 				goto isolate_fail_put;
diff --git a/mm/migrate.c b/mm/migrate.c
index a8edd226c72d..c5560430dce4 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -911,9 +911,6 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 			 */
 			rc = mapping->a_ops->migrate_folio(mapping, dst, src,
 								mode);
-		else if (mapping->a_ops->migratepage)
-			rc = mapping->a_ops->migratepage(mapping, &dst->page,
-							&src->page, mode);
 		else
 			rc = fallback_migrate_folio(mapping, dst, src, mode);
 	} else {
@@ -928,12 +925,7 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 			goto out;
 		}
 
-		if (mapping->a_ops->migrate_folio)
-			rc = mapping->a_ops->migrate_folio(mapping, dst, src,
-								mode);
-		else
-			rc = mapping->a_ops->migratepage(mapping, &dst->page,
-							&src->page, mode);
+		rc = mapping->a_ops->migrate_folio(mapping, dst, src, mode);
 		WARN_ON_ONCE(rc == MIGRATEPAGE_SUCCESS &&
 				!folio_test_isolated(src));
 	}
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
