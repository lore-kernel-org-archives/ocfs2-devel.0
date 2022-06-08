Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58ABFC43334
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=6YasDYXH3Z9C43N04iPYdSvIj9IYDpSIA023FT7+Y0A=;
 b=lPS50kkVZdIERO81So6DbBWQcPGOjFG/lb2BR0aQnSKbSX5s/+m2v/RcSe9UzB7tZg3UVxUUDAUx
   Ajb8n2xGAbzIDxlmJZDqbVrIFXxAS4uhS7YJ+shdbjPueEN79FeLaSo9b0DIeMXXcRhBy3jiVzjM
   piSP5sYjiv/TU+PbWX43VRjfsIi0VjxiaX83Dfb2HfPSQaVQcT/z/PzREV6JXQj2y/Jw3s42RLS5
   LT4cMtc65lcAXAsOGYMOQiryeI60vFFKxbn3aW4MIrM5yWWOExfkTj2D0IwRF/QxHwJSpeCXN//I
   z0tiTQxr/aeJ5e5QHLfpWBprigRhu/S/ZX7E2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=6YasDYXH3Z9C43N04iPYdSvIj9IYDpSIA023FT7+Y0A=;
 b=KQrguXpE+ti9Qos49W/iVDe0fHHvQq2r7Kw1cSfAGlW4fwUMLmVIWX7yOxGlGRAJwf0t9XpNGUI2
   6Q3m54OMq6NeVxQy+Dj4THcgA+xGAO5E0hGBwzwf/qRb+mEOL761h9Rwt9eBqQT2nKGZ4HZVI5vV
   3Ch/UkvNACcn31cmzF63eC+/pTb59ubBWA2q/vPtprnQ9m8Hj7qKgtEeWWTusq98Id/jC3T+mKQl
   3379fFC/kPu0k/XAzN57rfXGYBLEXQbDc1KHOikOp8O+40hKhly6uoDE924/2VkPPU9BgJAfXH2Q
   Nw/GF9+xw1mOyXam/piLdHerHp45Xb53QRwl3w==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD50008VZ6DPW20@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 15:03:49 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=XR+RIMaPRstxhE5d9sK6W/lLAxJj8y6CMlZq/dw3i2g=; b=PinZio6D0unRMLA2LkVJ0ptTFG
 VrnAnp0fToz0SSUq+txImmnD3LXbPrTgnBlZV++pGdop4Cn2WGlRLHpKuS+kybl2tUCz9v7CkzcI7
 M7dlh9co51ybg0sfqiCvyfJ+qCDVgLM04IACEtw5v5qim5kAOU7n37rbZwVisvIb02sc/ZVnklOXA
 Z5Yog62jbLrAe6tbGbP1arO8LqW6WhxyWv31XFNHQTwJmoW7cJQZQo66HOCZ0qKa0oTcQqQUR6I7N
 YxEdTY90TszBiIe5Yx9ka66db2HDnsKgnuyFmp91lyFFjiAr/Y42M1z5fpXGH6DEdv5iEQaT18DjE
 zFSSPGRQ==;
To: linux-fsdevel@vger.kernel.org
Date: Wed,  8 Jun 2022 16:02:39 +0100
Message-id: <20220608150249.3033815-10-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220608150249.3033815-1-willy@infradead.org>
References: <20220608150249.3033815-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=655 suspectscore=0 mlxscore=0
 phishscore=0 priorityscore=220 bulkscore=0 clxscore=163 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080064 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 Anna Schumaker <Anna.Schumaker@Netapp.com>, linux-ext4@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v2 09/19] nfs: Convert to migrate_folio
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
X-Proofpoint-GUID: XgyJmVEVXa_Pj7AAuao3iBe0ckK1UqrE
X-Proofpoint-ORIG-GUID: XgyJmVEVXa_Pj7AAuao3iBe0ckK1UqrE
Reporting-Meta:
 AAEHkQJBVa9ng1n/BE0ijrlu0KI25LhFBZLcaabhqtzlA2pAQITAYR+wb2IaUIvK
 hGlj0n3LaKwHbwu7w/XILNvZigwyxPj8Npl1sbfN4fOUVMdiZwoM82MIuF5RIp8c
 yQnvnggz4iLtUSXMc7QfkwrzBIKJYRx9JWh4TjNTcZQJACYQGc+eCYwmJG+Fbhkd
 sYBiSaMShF5/9bTOTdIQ6StgRvdDh8jy6l2hRPfz2SoOSCx39GaevoKBX+RgAw06
 RE6a7GaiC1JJpyiV5LryKU0xZ0jwNfA2CTcFF55XBK9pnxTiD8OzwjWGEsn2B8A7
 W9zXz3+87X7/MTfYUdCuJiEw/Vzfyfx9ks8ZTNYHfIFMup49BBuv4wk/lScSM6b8
 nUqwze0kfLHSnHR/QYaNgk8M7gIA23bc3mimgBpyylo6kY2XdJuoU3rC1rCeTgTA
 yGBJHivXp1Qdj1jP+F0D7QNciFgPJJJsN8TVob2VFFAD1YMp2ZyESpHfnJ49f9Qk
 p/rHAwrhL3EaeBemn9Lf/3w2uTYcUfHLyHNGiS+ZpKGE

Use a folio throughout this function.  migrate_page() will be converted
later.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
