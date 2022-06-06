Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20F33CCA488
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 20:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hWGVZX9ItxUtVxHFxLTz/ebp/MB2xIP06CylR8zzBNw=;
 b=BCtmm69iuTclR7aPQpeVu/dZ/vU5D4nXE1zOs+mmGgZ1pg9BiGl6QAoRMukpHDcmJcZZMQemxpuq
   7dQjxSn53XZKtIFaVdh/9doohCpCt9E6D3OBqoL744jPblyfUb2xq4HftZZh4Uk/uWiNpWu9p4Kk
   UUqTW8YsAVNcskXXE1KnrhGcBFYlm2UWrCX/aK/t0mGi5A7pBR6dXgP5z5QVpweWpSLyjVju0EAa
   5KG+hXJS9QPJD4Nlo2uaG9Ld+erpfzyYj3hS/yWB55/m96tQk5i5VK91RgjXLjhoNbgM0iR2t+Y2
   6DCqyTzxbT4EatCDWB78DRMs1Xc9S94zhB5fpw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hWGVZX9ItxUtVxHFxLTz/ebp/MB2xIP06CylR8zzBNw=;
 b=Dn8IvgxbGJadVD5XSXsYav6hvcToWjZZmPyLAOS1qE17Xub8akIuqTYhcP6bUyin9J14EGNKgGSp
   07XzHSE/EqkFXLpIdfQVFVH7QiJ1gAdy7cMs0UKF7PU2+W9jtFMPd3fk7TE7pEgzLAICGGHNwogt
   8vSzkFIdXExqHdSCxA04BoW5Ycyqn67ZUHghk4XNouy1evev9upZYOO2wVSynRdauLHyOcs7+wk/
   LgxcQYuDe7sRtzZtIBj6K2yEV+yc9uJCjkqj1AFBRED/ID+5k4ZnPx3kkXH7OnPeLhvJppvgKdYt
   sWb+7X6o5ExaUC+qyLqu2grdqOT5MxEeOslW5w==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD200CJ9PGVQR60@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 20:41:19 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=2zqEa9EzjfvcCB/R36xszZ4AMZtdcV59XiMVDc9jTyM=; b=U+BqaoSQWdsShi/y8CPTtTig63
 HCMa7+gIZx7Yyb6cusLNuXKWsG06WN8xz/erKBPWuYizRThCX0iiljqhNcZd2weflUVCtiqE770D/
 Vb15aA5PxUQlAGcLo3M0XEH41Q/fMFbQWUysBrY6PEG35YJKOueNndbkU/J8qu3X5pGzhsOP7ol4W
 F3RaDu2I/zP67juMsLCzxygZBIwXjKCl86d9jfX6rvdn+U142VP0hON97WCqvsixaBkAVbsODa0Rm
 STrW9jc4kjH9X53B35Fdz629pIYD4+nkkWKOdWUlig7kbghCKRcjBc7pf8npYNE/LtOnrV8sVT0Vs
 SEGqa5Hg==;
To: linux-fsdevel@vger.kernel.org
Date: Mon,  6 Jun 2022 21:40:43 +0100
Message-id: <20220606204050.2625949-14-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220606204050.2625949-1-willy@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 mlxlogscore=467 spamscore=0 impostorscore=0 suspectscore=0 clxscore=165
 malwarescore=0 lowpriorityscore=0 priorityscore=108 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060082 domainage_hfrom=8378
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 13/20] aio: Convert to migrate_folio
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
X-Proofpoint-ORIG-GUID: vL4nFRRaMU5IvLmMgRjnYN3W8DhX3_Sm
X-Proofpoint-GUID: vL4nFRRaMU5IvLmMgRjnYN3W8DhX3_Sm
Reporting-Meta:
 AAEgkSS9QP2YsXqix6eEe/7MLsZzWCOonWlJ9vFpKwY+GnFzG9+JMu/PTDS+yZwk
 aX99cUSaLdyt9E4xKcdBmZhAXnud0pOW37k2BazGmCShWgzFeC2zsiIMkGijXZ3e
 Gz0BQOv7F9D5yW0waKK4/POTxNSkP4nmacSAu7J6gqkMZat+AxpVWuVk/qchz4Lt
 R1PldaiJyB6PcmeqMsgigobVNoucdVYy5Mf1j7gqCOQ/m4PYvut3hI5VJn/Nf+Av
 GK8yGerPPkTrf5ot/jrfDI68z215EqCoqJefjUdxAxTD+LXXJ8Vqxgf8GaDdVxC2
 7utGeb2jCt1HHrNNaHVKcdzZAETlqWkPo2v6Qn8BiMz6IZheXJhP8AG6muJ+z7iN
 ceXbWS8hdwcuPRPKvVZ0LcrtAFHeFYDuDU/yqV2EHu+9JzY+5reY0PH7jOMHh4W9
 Hb+VCAACvgOM60z02/GpH9ebw78ROZ6wzRYkTK6q0aHcJM+iQadM+NydsPMkyMDy
 BC8e7Di7DP8c+rFn/XjrcqYVtnEHPJeOPrEG/aIAjGo8

Use a folio throughout this function.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
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
