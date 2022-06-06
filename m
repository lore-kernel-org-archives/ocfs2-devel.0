Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90D15C43334
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 20:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=J3atSQveN5+wM19EZ8UpT4/lIUfCt7W+39dhKSs+8H8=;
 b=J2Xp2A7voG5s0MUs8QxgQPP5e4015aza0ZAoJ1wenEi4ehyORgPW9wApzsxVq0ypDwm27mOnycbb
   LCxI0BUvDX/eCwBTVVQcBF431dQdcH94OB0H66KIvIOANu31zfGDWxs29OHlNY/caQZl6hLHEMgt
   ttcWMsefzfZ4SL6pRfrUKKL4HPDdCcHeDuTMIYergd4v3hnFLpNK0BX2n/596pi0jDpMru2cBxd3
   vEM1wWx82L6paqabcOzppwsmiZ7fjthCUJPkAtgRs+jMkRnijZtXBHlkZkwO65ZJ2CaqEM63zDGE
   sMJ/XjTkE5Gia+ccbcvqSwbzVSFCSM20hlzdGg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=J3atSQveN5+wM19EZ8UpT4/lIUfCt7W+39dhKSs+8H8=;
 b=f2kfooRJ90w6v0GXg44M/+lh+DniVDoTW2hjKw/QYbPBVO3iqreY3GAILtyKTEp/R3ySl3sN7VmT
   AKcEDKO1jQzvNpVhmhKbcC0bGcWnbUW2+3Rkey+XK1spGdZ86PeAOALSenFP2BxY60+ZzdwjE/Js
   E8gr4dGB0V5Lb+sk8sxM/5E0P47sGwnY8AusYrxEK523okaQ3lj96fG+ylCIsUT8m9oglkNrTw0+
   7Jn94dsmW1IiMnTt6TUAnurTC3o4D9hbrDTphdlOLiyX1bu1WxUVepP2FZ7BNR7NFGyTm4qXraOg
   BA2liDquElg8GUz15l4pXK2Pf6IbejFOJUEWWQ==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD200CPZPHLQR60@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 20:41:45 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=pP2rySBonQba80aJJurpf3Ufu7YzAk6PE/UfFF5JjqU=; b=CVvFIaE3DO4F579aJn2Gv8sjJ1
 3s4aun59FYY8/cIm392ktBNn3Yfrt/zZI2FAKlmO4E3xMwJb3V8p0zjyiYNlXYHugx4ESqJjlHfb1
 QG1qZiDzGvDgU/60lg9IfnGfI2mfaTj+stxEAcrFL6CEOIqb5GzPU9vw1qrk6uFLJAOZ3IkEmbCQE
 LzelMikinFLOzolvWeyxZFad1TDhzqH1x/JkOTw+Xol4LnPrnKqEGccXqc7eFHbh9ziaHCXeJ+DmM
 rrw8vPHosmQOe6zaJs4TsqpU+ayfdzgl+HFiB3jtxCoXtL62mYflqoIljhWxTii99IWQIy6G281e+
 VVfyP2fw==;
To: linux-fsdevel@vger.kernel.org
Date: Mon,  6 Jun 2022 21:40:37 +0100
Message-id: <20220606204050.2625949-8-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220606204050.2625949-1-willy@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=165 mlxlogscore=570
 mlxscore=0 bulkscore=0 priorityscore=108 phishscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060082 domainage_hfrom=8378
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 07/20] nfs: Convert to migrate_folio
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
X-Proofpoint-GUID: iwgZZ0aOQOHNbJFY5IZBOH4Z7HJ815ae
X-Proofpoint-ORIG-GUID: iwgZZ0aOQOHNbJFY5IZBOH4Z7HJ815ae
Reporting-Meta:
 AAEg6SygxaT/zHvhQ6guxcm+F+gSufxaLlNvNM97o+Rp/s1cZtlPLRko2w//jpYM
 nFX6H1i0KaOyZCqB5MJpK2EC4UiWfa5GXi5JBpDDdIWUZictQHN9Hav1y8S456Yk
 O+VZumnRcC/v2YZCHQjhjdqwLJQ4xY+mOUBPvfX/706RCQch8p7Jc3oYeZpT5m3U
 C1wkw1+l363s+EC3HY8gqkYFY2isxOeVGAJPOK0VTptQmdrMd2rjzY7P1ZvrNUM0
 xgczL9RkdgKs0SaTB9AgIrO4JXeJW7iOoLBesDSQgWUxfrQN9qkHZfqBmJZG4F42
 way9Q1j2u7qBAVUaB6osaOEeIEgEzXZOWAgnhOtlMMiPesHM9lYNOtRBjzIqO+y6
 EE5OYW0CI10KuF81q1fOsgX9+TgbufbA8ULG2mG4BfDyKfr+684Fir67OzPSP4g0
 RbUDDRn2mlEudX8m0AkveT0pP4PPGcqKwk5lBOiXMLTZSBTBIptsHbZH8FqcUIqZ
 pFzyireyBksUoBNzhpIRPPR4si7KrmKjqoHymbIh3+JG

Use a folio throughout this function.  migrate_page() will be converted
later.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/nfs/file.c     |  4 +---
 fs/nfs/internal.h |  6 ++++--
 fs/nfs/write.c    | 16 ++++++++--------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 2d72b1b7ed74..549baed76351 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -533,9 +533,7 @@ const struct address_space_operations nfs_file_aops = {
 	.write_end = nfs_write_end,
 	.invalidate_folio = nfs_invalidate_folio,
 	.release_folio = nfs_release_folio,
-#ifdef CONFIG_MIGRATION
-	.migratepage = nfs_migrate_page,
-#endif
+	.migrate_folio = nfs_migrate_folio,
 	.launder_folio = nfs_launder_folio,
 	.is_dirty_writeback = nfs_check_dirty_writeback,
 	.error_remove_page = generic_error_remove_page,
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 8f8cd6e2d4db..437ebe544aaf 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -578,8 +578,10 @@ void nfs_clear_pnfs_ds_commit_verifiers(struct pnfs_ds_commit_info *cinfo)
 #endif
 
 #ifdef CONFIG_MIGRATION
-extern int nfs_migrate_page(struct address_space *,
-		struct page *, struct page *, enum migrate_mode);
+int nfs_migrate_folio(struct address_space *, struct folio *dst,
+		struct folio *src, enum migrate_mode);
+#else
+#define nfs_migrate_folio NULL
 #endif
 
 static inline int
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 1c706465d090..649b9e633459 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -2119,27 +2119,27 @@ int nfs_wb_page(struct inode *inode, struct page *page)
 }
 
 #ifdef CONFIG_MIGRATION
-int nfs_migrate_page(struct address_space *mapping, struct page *newpage,
-		struct page *page, enum migrate_mode mode)
+int nfs_migrate_folio(struct address_space *mapping, struct folio *dst,
+		struct folio *src, enum migrate_mode mode)
 {
 	/*
-	 * If PagePrivate is set, then the page is currently associated with
+	 * If the private flag is set, the folio is currently associated with
 	 * an in-progress read or write request. Don't try to migrate it.
 	 *
 	 * FIXME: we could do this in principle, but we'll need a way to ensure
 	 *        that we can safely release the inode reference while holding
-	 *        the page lock.
+	 *        the folio lock.
 	 */
-	if (PagePrivate(page))
+	if (folio_test_private(src))
 		return -EBUSY;
 
-	if (PageFsCache(page)) {
+	if (folio_test_fscache(src)) {
 		if (mode == MIGRATE_ASYNC)
 			return -EBUSY;
-		wait_on_page_fscache(page);
+		folio_wait_fscache(src);
 	}
 
-	return migrate_page(mapping, newpage, page, mode);
+	return migrate_page(mapping, &dst->page, &src->page, mode);
 }
 #endif
 
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
