Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1719FCCA47B
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1wJq11yPB1RSTBd4Lmpot3IFqVhfz6VXFUoleD/d+vs=;
 b=NYNxT7pzTgKXsMMNm162cLAzdxqiu2haFV63nILUjJP+VrFBRf9ZPfCCiD7rppLk50QnzdjEbYyw
   2YiD18eYOo6nwDR2OVbMMf0uRjS/I7ao7rHwJbi/OZMiRCnudHnQyhn1X0uDAxDCO5XJLMFkYUJd
   l/9WmYBThivowhRC1OJf9b7d5nmWWILULF9fH73Rg9r+O+nxsuaOYvetKhfv4qpPlBPLSbUMYfLE
   l6YNqMlTqDcM5rJDoz0MyjZHNygQxm4jkbSGhZD4EJ79odM/qX3e9X7SAoP4pGFES32BXl0kwwEP
   1l90WPGFA0FR6rQPqdpZyST4TDW8fR5uijgrvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1wJq11yPB1RSTBd4Lmpot3IFqVhfz6VXFUoleD/d+vs=;
 b=JqzwZaQxRBbXyhbvk7q8G5JmppG9jugCaInGSHKyudYAD5kmfBsFPVVuxegTUhFutIEcv8yisLt+
   FT87+7dMxTpcpLuBPlXPdDmYSAyA1rW0+kb9KismnqT4yf+NvV4h1cNVAGGi/En9zrK6P6Jhil7e
   JwlLLn0jBEMr/5wkra4YLXhvVlEoVf6y5diSs96QEhYlWjqegcD9rPdkE5pJABcTTB9Xz42CQZ6e
   ZhE8EN0akXzLJMoAO/6iwk8Im1RYRRo81jknQT9fY8FFXA5YdNuAYL4CIeMFIfrfszeMe0zhWKBH
   kD3z9jscDvxcaLxaz2WfMQV10jL8KIXC6bmZOQ==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500OYKZ5UR810@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 15:03:30 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=WUpG8Ni861ynrjDUWCnLTkzTIfxUJKXosLuHAm7Cnl4=; b=TZRY1wF8ksrrIs1o9KbjlHWauY
 4i3hvUjlM2cIjRUnhetVv8G6jMyi14dv6mXReUhlvxDOk++478UFLwnOTQRcW2OAzYRGsNtgSvdbm
 rzbNL4L83yv6t9VuZB7jb2fZTbAOWlo5a8uudsYH/7aOxtrNzw8CLlAmsabS+HdXV4gWCKA8QRNjP
 TEB2Mf9KWDrGrK8TMAo35J12l2+xg69zacyrBtimmMBqI0hEgYTGk5qIEXSbuwxPZt8S1FzoWckM/
 zJjg6W8idqpi/4VI0InsOV4Q7s8MeTv9rUBHDNK/kOpKOuF3YHJ2V9jmVvRttDYxzg4YE4S5tdNTF
 ViZ46uBg==;
To: linux-fsdevel@vger.kernel.org
Date: Wed,  8 Jun 2022 16:02:45 +0100
Message-id: <20220608150249.3033815-16-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220608150249.3033815-1-willy@infradead.org>
References: <20220608150249.3033815-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 mlxlogscore=490 spamscore=0 adultscore=0 clxscore=167
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 priorityscore=253
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080064 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v2 15/19] aio: Convert to migrate_folio
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
X-Proofpoint-GUID: qZik5j4el3SoEC8SSOW4W3a9Mu1a0-tt
X-Proofpoint-ORIG-GUID: qZik5j4el3SoEC8SSOW4W3a9Mu1a0-tt
Reporting-Meta:
 AAFwhruWf3FhMQmnlLB/bfTMuIoBmkeoCOQSJmGteCs1B4JCiGJzmHFdEa5o4e3Q
 9V9NV6L0LPCyxI6dfVExphU81tNnFBw+lmjyqhMZiSrjQ7MurSMWCDpEI5uOVnNu
 +h7aKsVgJ1CINgtGApwAoe4Z0n5xwv+fX00eVRI2c7g/KWtUR99W8Yye5BAHPMTV
 0Ubcl+yynW4BY4OzsnUph0aH86cHw6azkCD1wVRsnccPGgp1rS22r8HJq47JqXDU
 h7aa9aUsAeinNFEkrFB4D9mUMe6KqRhueU/fHw9S4NNX7si6v4+1Sfw3kwDdXI2N
 +ATScdVInD1XQUjjBywAsO+f3kmeyPxgNs0Wy75iMyGxmxFFK/t9Crf38pBBuCQn
 NV1w+LOvfKVhIjgBWTIZbtzEOGwlO55fXZyL4K+yWEVcvubkl7+NLCsqOhjJk8iL
 BrGNnk4FNJJg4oeCdL4xMdt8AHH755Uu296tGoQhEXyfXLqtTfh+/mEoDNqMUSuT
 ig6Q3r5Q7/goHWLYHxnSQhsg8YtkeWQHJXnll29QALqh

Use a folio throughout this function.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/aio.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 3c249b938632..a1911e86859c 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -400,8 +400,8 @@ static const struct file_operations aio_ring_fops = {
 };
 
 #if IS_ENABLED(CONFIG_MIGRATION)
-static int aio_migratepage(struct address_space *mapping, struct page *new,
-			struct page *old, enum migrate_mode mode)
+static int aio_migrate_folio(struct address_space *mapping, struct folio *dst,
+			struct folio *src, enum migrate_mode mode)
 {
 	struct kioctx *ctx;
 	unsigned long flags;
@@ -435,10 +435,10 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
 		goto out;
 	}
 
-	idx = old->index;
+	idx = src->index;
 	if (idx < (pgoff_t)ctx->nr_pages) {
-		/* Make sure the old page hasn't already been changed */
-		if (ctx->ring_pages[idx] != old)
+		/* Make sure the old folio hasn't already been changed */
+		if (ctx->ring_pages[idx] != &src->page)
 			rc = -EAGAIN;
 	} else
 		rc = -EINVAL;
@@ -447,27 +447,27 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
 		goto out_unlock;
 
 	/* Writeback must be complete */
-	BUG_ON(PageWriteback(old));
-	get_page(new);
+	BUG_ON(folio_test_writeback(src));
+	folio_get(dst);
 
-	rc = migrate_page_move_mapping(mapping, new, old, 1);
+	rc = folio_migrate_mapping(mapping, dst, src, 1);
 	if (rc != MIGRATEPAGE_SUCCESS) {
-		put_page(new);
+		folio_put(dst);
 		goto out_unlock;
 	}
 
 	/* Take completion_lock to prevent other writes to the ring buffer
-	 * while the old page is copied to the new.  This prevents new
+	 * while the old folio is copied to the new.  This prevents new
 	 * events from being lost.
 	 */
 	spin_lock_irqsave(&ctx->completion_lock, flags);
-	migrate_page_copy(new, old);
-	BUG_ON(ctx->ring_pages[idx] != old);
-	ctx->ring_pages[idx] = new;
+	folio_migrate_copy(dst, src);
+	BUG_ON(ctx->ring_pages[idx] != &src->page);
+	ctx->ring_pages[idx] = &dst->page;
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
-	/* The old page is no longer accessible. */
-	put_page(old);
+	/* The old folio is no longer accessible. */
+	folio_put(src);
 
 out_unlock:
 	mutex_unlock(&ctx->ring_lock);
@@ -475,13 +475,13 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
 	spin_unlock(&mapping->private_lock);
 	return rc;
 }
+#else
+#define aio_migrate_folio NULL
 #endif
 
 static const struct address_space_operations aio_ctx_aops = {
 	.dirty_folio	= noop_dirty_folio,
-#if IS_ENABLED(CONFIG_MIGRATION)
-	.migratepage	= aio_migratepage,
-#endif
+	.migrate_folio	= aio_migrate_folio,
 };
 
 static int aio_setup_ring(struct kioctx *ctx, unsigned int nr_events)
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
