Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 894C4C43334
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Sk5fyuoKy0N4BT6wYGCzexvAcKZM76uiIrwEQ9Uxrvs=;
 b=rukhjbKuXWql8oDkwsJdMV7Td2ZjJ3hc6f2LLT8y7GnAsXoq5NKwa3XZbKYJiq53VaATw2wE21CA
   r6CbNUrkugBkR3KemsX1wstQEJkb4euBkoVQokMGU7FWwBt46mWBslj9MaE5Na26K7WVqCEcYTeo
   tyRt2kYzNIgYCbDPJiLWLzcUDOUgkpCVx8vUgpD/LhMeVf+O2ADFXAXCXVgaCW2p1hq2r5FWzQBu
   ro2A15u2q4ZneGER20eGsIJxK2xnR0gDSz4k1iLpckFNnuc8A0RTLmM9TfuMau5MGocj7rdQfSem
   /aj4klQrdApgGmpIMqMIaNQ5lvyac3aFI89TKw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Sk5fyuoKy0N4BT6wYGCzexvAcKZM76uiIrwEQ9Uxrvs=;
 b=W/aRRWsM/3PXRhNDk2fh/uZvbRWcjwSvJU7HY8iJnW1KeJVMO7x4/FPGpig4s6066J1sh+AoTdp4
   WXuvaLxNFHeeXyDadyj9wM/pRl7OhHxr6WIsXF3biW+tLC8dHtKGonZ8oJ/9DNGL/FYiasJzm22K
   KjLK8xxODgluIkKdRGvPa6FN0M94dwTA4djDnwKUyTsXrIGYu6Q4IUzT5yq28dPdYWPKM+DSi4Ic
   HcsJUE3l+rIN3oZrddsT1W1RTq/4lPuxSxF0qpdyp3+jGNxdGz6Z4bLi5pe+OsxsMQ/PGTQkZefr
   uWeIdvKFZ63CGKA9SY/AQETKxf0W19LudLu0kA==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD5009NSZ6MRUE0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 15:03:58 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=ncg84OMjo+AvVLmZPKmxXncRAMSRMDL0v/ScNwY3xFo=; b=ZH1jj5JLt5Huo0hFneWdzgOddm
 tf5K8ofhIHTgnH+k78szErcZy1qjS4hpsIPzVbNLfB5AIeGJmWMbZktwyBE6yJjNN24hOFdbIWYps
 0k5T7kH1RFNzHhpJsupjLqgjCdLqwuWzSZgNhY2n52oP0kMd87dkVgBHfSoFTVS8nt6uZvyuZE06K
 gHrqY4UgBaz7xm0r/3v2l0jjzdslv1KD0nkS+J0Cbg4WA6mbH+6xsumitM+mTT5Vcrrl3/x0lv80/
 61+K0Wy9nZhpfjr/5EC2MG8rMJ90zjUNQarBbpaXsRYondC+xNRnTEkCIjXwjmRbYvVaaccl1uAzH
 CsHsOp5g==;
To: linux-fsdevel@vger.kernel.org
Date: Wed,  8 Jun 2022 16:02:38 +0100
Message-id: <20220608150249.3033815-9-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220608150249.3033815-1-willy@infradead.org>
References: <20220608150249.3033815-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=163
 priorityscore=331 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=673
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080064 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v2 08/19] btrfs: Convert btree_migratepage to
	migrate_folio
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
X-Proofpoint-ORIG-GUID: T43kdfUyMxYA6I704jky5jvy57Zjb0Pg
X-Proofpoint-GUID: T43kdfUyMxYA6I704jky5jvy57Zjb0Pg
Reporting-Meta:
 AAF044B5/gaedbb/CNyr+tCIjXbfwK837Kd/qZVAnM+sBrzMmgkiDk4U3bZJSyVC
 kwXVNq2UZSp6U98gaMl75CILThcsAsCmCuQXF0yKzVq2dL4uNw4zWTlL+ADjkTLq
 hCjZAnRhxyGXOhN83P6DupJHKWg9Kmg/gatoz7r6lGQj52IfffRSIBpk12XmSNHM
 3WrxqKOB4NdKu2nmQtZgNnsOOie1lkuV2enI3Kjk0Vd0EjrhHqCG6t7aRX+nHrCR
 LJdskfYzJUllJT/TizptoRu2rpkbsTO2fcOZMDgMZnUtVBG/W254YzfN1MTg5hSf
 8S8d+Ce8nhv1LEyKJicoTBvJMFgsgHXKX1GFITz1GxYZNQqjnq3Xd8iT5slW7Gwv
 xa1rtHqSQwU2lKSzKvLUYp1kmOojVkO2clKLpUUV3gIYs5JexRugbF7e3XhTv16O
 KZw7b/LIN0yv/vbXr23CBTNVi7ha6Cf6kMYiXcVMlDVEn+4VqTnmfrC8SNONmEas
 NbMGyXoqxK1MXrN6r+3Jk8ydMv8p37SZ3Z6e9SN2S63k

Use a folio throughout this function.  migrate_page() will be converted
later.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/disk-io.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 12b11e645c14..9ceb73f683af 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -952,28 +952,28 @@ void btrfs_submit_metadata_bio(struct inode *inode, struct bio *bio, int mirror_
 }
 
 #ifdef CONFIG_MIGRATION
-static int btree_migratepage(struct address_space *mapping,
-			struct page *newpage, struct page *page,
-			enum migrate_mode mode)
+static int btree_migrate_folio(struct address_space *mapping,
+		struct folio *dst, struct folio *src, enum migrate_mode mode)
 {
 	/*
 	 * we can't safely write a btree page from here,
 	 * we haven't done the locking hook
 	 */
-	if (PageDirty(page))
+	if (folio_test_dirty(src))
 		return -EAGAIN;
 	/*
 	 * Buffers may be managed in a filesystem specific way.
 	 * We must have no buffers or drop them.
 	 */
-	if (page_has_private(page) &&
-	    !try_to_release_page(page, GFP_KERNEL))
+	if (folio_get_private(src) &&
+	    !filemap_release_folio(src, GFP_KERNEL))
 		return -EAGAIN;
-	return migrate_page(mapping, newpage, page, mode);
+	return migrate_page(mapping, &dst->page, &src->page, mode);
 }
+#else
+#define btree_migrate_folio NULL
 #endif
 
-
 static int btree_writepages(struct address_space *mapping,
 			    struct writeback_control *wbc)
 {
@@ -1073,10 +1073,8 @@ static const struct address_space_operations btree_aops = {
 	.writepages	= btree_writepages,
 	.release_folio	= btree_release_folio,
 	.invalidate_folio = btree_invalidate_folio,
-#ifdef CONFIG_MIGRATION
-	.migratepage	= btree_migratepage,
-#endif
-	.dirty_folio = btree_dirty_folio,
+	.migrate_folio	= btree_migrate_folio,
+	.dirty_folio	= btree_dirty_folio,
 };
 
 struct extent_buffer *btrfs_find_create_tree_block(
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
