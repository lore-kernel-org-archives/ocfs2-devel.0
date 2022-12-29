Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36EA5C4332F
	for <ocfs2-devel@archiver.kernel.org>; Thu, 29 Dec 2022 16:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=GeQfdYvozUDNS9fH+EZ2NRwPS1wBjbBUQnlHHBUQClo=;
 b=Oq4EsCY7coaxR7jpcWQj5eGJW7wNsyDobF9W4FuHkEv7Wax5bMOjGaLAHbh0+HygPC/Cp8kVK9W8
   RYPvuGWWHHuKuieqBumLJRfL5x2MyXLjC4WhyASUBSxxVOZ+WrP80s+E5hIC3nerOADDWU5+ikUD
   75/Qqb4CZqyhfDIhMGCn7oLAXf+zBFfo4UllQQvuwrpZRYH7qsEPGF6Axf0FRfk4l0ASdsHbSVZW
   PWEcCw0Y/mw31hbgixnxrj4jPJbEWXkCipHfb9fYJtlVot45ApuSUSTj6z8kB3G0JYmvTbhZIDK7
   b7+cW10mtzs+t82JbVOcvEgt9ReRNbYq1HeBgg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=GeQfdYvozUDNS9fH+EZ2NRwPS1wBjbBUQnlHHBUQClo=;
 b=ZGsmZNYYVkv86IGMKKBvWwYD4GLTBz1PY+ur9F/i8ncC01J9wg3COgxG8Tra7mILxyGS/nO9UAzx
   qrcoazLLVxuCYkmWLrjJYzBk2DXDcH5VmsRXZDj37UDl6PZbpQTCCoZibhQGC9Qm/IOCh5T+R4xJ
   PsK+nd7dxtih47YEnGaeNyZzym9FelW3lG7pMWeHC7mQc1cBv7tTqY46GhmmvAoLYXfGUamId1N8
   WF7TfMzPAIhoNypVvY5P8sJJtXOmO2izGLEDcFQ+z8M5DguWnnpfZNSg9+WGXd/twFknoBsaixR1
   EBV/ziFHm6uFYTuQXBdqNGbZ8uMm3CfWfRdV/Q==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RNN009PCUHVRCA0@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 29 Dec 2022 16:15:31 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=x4y/4KuqfNuPAflIAi82X++2iXzPIgIv4Sol4IXfpIE=; b=hCkiJn6NwipyF95xZ/GfQjLDmb
 Si4sdlVrqYhOzIyOHDvE4X1IaWOLKGwwB/WyfjcmVjqFBn391Tx3NsE4ImwHez5KUQC/YOtFnd3mB
 r0I/7KTgno8i5rUd8vWxs5M/4cUs5R7OBibrzqx9/lV/aVXxlt4uKk9q1q5ScZ1TEx6FqrKHPk9Ow
 3MypnruGXVZJgQEhTyB8WJmJjakTwGYd+3QT1gdqttF5scQ2eSbdXz50yJDorlrrXTwZmCZInLwjR
 YllxS++9Um0yVvQk5aqOUb7TRQl9yf2UWXnv73HmIV5RLJGI6TFAVilzX/ndLItpgvO2wMHJZDKsO
 xGCE/zIA==;
To: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>,
 Jan Kara <jack@suse.com>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Thu, 29 Dec 2022 06:10:31 -1000
Message-id: <20221229161031.391878-7-hch@lst.de>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20221229161031.391878-1-hch@lst.de>
References: <20221229161031.391878-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10575
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 bulkscore=0 mlxlogscore=458
 adultscore=0 spamscore=0 priorityscore=0 phishscore=0 clxscore=287 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212290134
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, ntfs3@lists.linux.dev
Subject: [Ocfs2-devel] [PATCH 6/6] mm: remove generic_writepages
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
From: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christoph Hellwig <hch@lst.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-ServerName: bombadil.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: 1bwq1rXQ67y7GPdl7CUjASVZ_KUt-Q0D
X-Proofpoint-ORIG-GUID: 1bwq1rXQ67y7GPdl7CUjASVZ_KUt-Q0D
Reporting-Meta:
 AAEPLI6k0WmaiCZeUqwudezYIhQVmH5X1uJFY2ZxEWu81blP1FJ48SvXcjhVQrKv
 wtJQjFnGG4zDaT+PSrw5TpoHVaNXTm58OOczKbkXpUBolg68GHV7nRtLmbyZWXC6
 8gf31ZX4xFRMLY1aVfJ4sc2PGb4sYMdKnFVVs8vvkgg9oJs6ID6JteHuIwMtUeTL
 RQ74t88Rw2nY7OyK2vsGoOUqis6RzWaZhzjweFOnYJo/x3re2SzQFc9t8Y8lOToz
 mpV4EZ08Op8TgoVU+CytyZe+tuLxWjLbNXT9A8eZjWhweTEUWRAo7fujmkdyjKLC
 vXDEO5NBl0mkWNQfEZKbT4jRSCPk3bDapNfScD6dKbk1DEE86A11yyVsq/cip2aO
 sqvA/v6qCPsaCFV6DV/erk28hf9GUkYOlo0yFDuLdktN1VMW9rmQQ3tgFdWRyQVk
 Ndpq/aXHJ3n/8gGRtyvsXDuojiF02LBGNb00yIYvEysNOeiTIfm8QiUQdAQljVQ2
 NNRCoVMhh8dYxXIdqNCN6/7BXKWc/5AGIMxoNPKrEQ==

Now that all external callers are gone, just fold it into do_writepages.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/writeback.h |  2 --
 mm/page-writeback.c       | 53 +++++++++++----------------------------
 2 files changed, 15 insertions(+), 40 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 06f9291b6fd512..2554b71765e9d0 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -369,8 +369,6 @@ bool wb_over_bg_thresh(struct bdi_writeback *wb);
 typedef int (*writepage_t)(struct page *page, struct writeback_control *wbc,
 				void *data);
 
-int generic_writepages(struct address_space *mapping,
-		       struct writeback_control *wbc);
 void tag_pages_for_writeback(struct address_space *mapping,
 			     pgoff_t start, pgoff_t end);
 int write_cache_pages(struct address_space *mapping,
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index ad608ef2a24365..dfeeceebba0ae0 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2526,12 +2526,8 @@ int write_cache_pages(struct address_space *mapping,
 }
 EXPORT_SYMBOL(write_cache_pages);
 
-/*
- * Function used by generic_writepages to call the real writepage
- * function and set the mapping flags on error
- */
-static int __writepage(struct page *page, struct writeback_control *wbc,
-		       void *data)
+static int writepage_cb(struct page *page, struct writeback_control *wbc,
+		void *data)
 {
 	struct address_space *mapping = data;
 	int ret = mapping->a_ops->writepage(page, wbc);
@@ -2539,34 +2535,6 @@ static int __writepage(struct page *page, struct writeback_control *wbc,
 	return ret;
 }
 
-/**
- * generic_writepages - walk the list of dirty pages of the given address space and writepage() all of them.
- * @mapping: address space structure to write
- * @wbc: subtract the number of written pages from *@wbc->nr_to_write
- *
- * This is a library function, which implements the writepages()
- * address_space_operation.
- *
- * Return: %0 on success, negative error code otherwise
- */
-int generic_writepages(struct address_space *mapping,
-		       struct writeback_control *wbc)
-{
-	struct blk_plug plug;
-	int ret;
-
-	/* deal with chardevs and other special file */
-	if (!mapping->a_ops->writepage)
-		return 0;
-
-	blk_start_plug(&plug);
-	ret = write_cache_pages(mapping, wbc, __writepage, mapping);
-	blk_finish_plug(&plug);
-	return ret;
-}
-
-EXPORT_SYMBOL(generic_writepages);
-
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	int ret;
@@ -2577,11 +2545,20 @@ int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 	wb = inode_to_wb_wbc(mapping->host, wbc);
 	wb_bandwidth_estimate_start(wb);
 	while (1) {
-		if (mapping->a_ops->writepages)
+		if (mapping->a_ops->writepages) {
 			ret = mapping->a_ops->writepages(mapping, wbc);
-		else
-			ret = generic_writepages(mapping, wbc);
-		if ((ret != -ENOMEM) || (wbc->sync_mode != WB_SYNC_ALL))
+		} else if (mapping->a_ops->writepage) {
+			struct blk_plug plug;
+
+			blk_start_plug(&plug);
+			ret = write_cache_pages(mapping, wbc, writepage_cb,
+						mapping);
+			blk_finish_plug(&plug);
+		} else {
+			/* deal with chardevs and other special files */
+			ret = 0;
+		}
+		if (ret != -ENOMEM || wbc->sync_mode != WB_SYNC_ALL)
 			break;
 
 		/*
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
