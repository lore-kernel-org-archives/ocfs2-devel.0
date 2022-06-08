Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59FF9CCA47E
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=quMQ7htgVVUx9ypB9cF/18E3/YY16A5f6qK0JYTL+Cw=;
 b=Fd+VHSCdqJ1dpJ0MmCFoEiNpo7I+Fw6rhRP0/6ShM2k+kS9w08Af7CgV8wawc8BX54PSu8KIoCdw
   fAGMhUcYozJ22EtjhKYGBgn71pBqY3ljxlVPpBMaTPr4IR7AvKedcS3t5kUhjXeR9Zf1JvCo617z
   YJj/DsORXdq+mCzxDz3rv7V6CxRPp5ihxzPqS4tIm9QWZRF5/g7Qu1uOHK+PdPV66Bglig6IZeUY
   b2AhShXPNK4RYjiB1Rg+kZ0Hba2q9r0IJRWWtC1PXHm0pkjkp4+Owo7IWrVnWafFs1Heq989A/Yb
   kZLrCQQ8bft1FfDAzkLZwPV5xYgXSNBs8Ugl1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=quMQ7htgVVUx9ypB9cF/18E3/YY16A5f6qK0JYTL+Cw=;
 b=QbLTObVRo4ral4Ni9sZ1LnDhLzPLQ858WnuDczpgI0lJSi9CGkgfFQFojWOUr/QJvwWsUhpjYwx+
   YchOG8r5mmE6ZfdLnKqErCEP6NZ0KgZXirXLGFKeF7CK77IUXAfnj0JG+EV7o+c3LXlmpMhFgqxt
   p5OUjp+ThAr6Q1PavWP+e1PKpstWlGJYTYoF6AztqSmoHoKp/7YV66UBcqu+KWzrPA8DvpRlM612
   yi2jqLj5bxO/3FNO+ZT4VmhhJC2xfxysmI0broOStneQitKkDHnX3j3rBgw4UTkRSIs32PO7qqYn
   gwx3fj3/LLEHhTKztXSqEvGA+Fr4LJXBRqiwpA==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500KFPZ69P340@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 15:03:45 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=L/W62gIhDvny0+evT6hKu8mfiF8YLXl9JHSXNMT2CL8=; b=E/cR7+jnh4MZjUekK6MX3paPTV
 rpyCm/XiDAOZDdkAxiR6ENBOGDspVwZofRubYVUCyfBG/q0G2P76APSKvJQYDoJJHnpbIZIfvndzv
 b2tINK8pbPtEv8uVgJlVmXLf0Zb7aTLK/Av4cH/ZFWlwIwtyIRzsKjAlUgHGt/pj4W+imiRHLVDU6
 HWs4rwESaohScBPmkWkya7wcDDvYQG1mSEtqOj+cki1hdMlVwH8fFsV0sNL2uKq8yjL+T8WmSb+iF
 zAP5EwizELetbeBerNs7aFo2HX55u2FQyB9sVWH9wzoFE+fXlWb8vKSJpwwQJNZs4KPFu+kaJl/nK
 iSwBCYeA==;
To: linux-fsdevel@vger.kernel.org
Date: Wed,  8 Jun 2022 16:02:37 +0100
Message-id: <20220608150249.3033815-8-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220608150249.3033815-1-willy@infradead.org>
References: <20220608150249.3033815-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 mlxlogscore=564 spamscore=0 adultscore=0 clxscore=163
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 priorityscore=250
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080064 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v2 07/19] mm/migrate: Convert
	expected_page_refs() to folio_expected_refs()
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
X-Proofpoint-ORIG-GUID: WnEi6POlNgoevmwMQbjuKlTRWjQd5ViL
X-Proofpoint-GUID: WnEi6POlNgoevmwMQbjuKlTRWjQd5ViL
Reporting-Meta:
 AAEOVeCPB1T7ZqplPs7gTF4dfQgJ3YBHjOmfDQ+f88xsStV81sMPKEwjjHiWEUmo
 aEo6L+Z6rUQ8N/y29my+NdYBabv5w2qYVsWQ5AB39LjeKSZ72upne7CKiEUc7lFC
 h/yl24QRzdedXKeeOw4vdi61+4VUXk9b+fqfZaejSqj+fumiF/h5Zm1rlZV3V6s8
 ww+vTx/l53lBoyLe/Q/9Cxq2t4aUkekH8D6dm0rx6Y+aqf9CowTV5+Q5Gus3DuJP
 NrGUaKja8B5D+tITnj0hY5mjq8ewYeutlkj/nijqJbeWp9ADX00JD5jWKzorfRBT
 4GkZzKevTjlqCafcilbo7oOdhrMPdHMc3BknJtXNcDtzNVb9UTyGIN75FfAsdG0T
 eKamTknBiALMrDnQz4MKxNHKIxDPv+dSZQR3Ux5DHni912rwOZFdtrxpfqYWCB92
 XSD3NIe8vlxyGdfZeQmu2zYIpfycq2zwBkgVRJip6Av5PeOztkgTKHqD8MwTccbk
 LhA5KFhF52F/9H1lOGFqLwxg4iutcGYN5zE33Jgo+V1Y

Now that both callers have a folio, convert this function to
take a folio & rename it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mm/migrate.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 2975f0c4d7cf..2e2f41572066 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -336,13 +336,18 @@ void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd)
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
+	return refs;
 }
 
 /*
@@ -359,7 +364,7 @@ int folio_migrate_mapping(struct address_space *mapping,
 	XA_STATE(xas, &mapping->i_pages, folio_index(folio));
 	struct zone *oldzone, *newzone;
 	int dirty;
-	int expected_count = expected_page_refs(mapping, &folio->page) + extra_count;
+	int expected_count = folio_expected_refs(mapping, folio) + extra_count;
 	long nr = folio_nr_pages(folio);
 
 	if (!mapping) {
@@ -669,7 +674,7 @@ static int __buffer_migrate_folio(struct address_space *mapping,
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
