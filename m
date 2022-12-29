Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79861C5479D
	for <ocfs2-devel@archiver.kernel.org>; Thu, 29 Dec 2022 16:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=W0Z672HmWyexyAJDpYlpLojrS36XIebTzIVLTMA0ZEE=;
 b=ZeAZlthLjWVJpdvl9MOTRt81Gvdj6H959EViQaagkWVPNoxIHm7ps6dpCWGw5/7xOfYgMoHVMdoZ
   w56FPoMIu1Y8UlLd96s0uitKqH9jFhDX55jikYnyXYTpb2xPIZyVXdUIOielfjHk6XZfIx9JweEh
   XU50X9H2rnSplKt29Se4b7nQDrXIjtYKv8zQ4l87Wu9wTAJOtOrRNxIN9pmsotD32ZL0DTpkxnzX
   EuNB4QAtZ4fptxWgYqRJKRhXlV8Dc+Bf859YqLT3kOCSaP7THPleXLjbLPSOFF+Ws9t2ef7MG/4x
   cUxCbp2HL2Wc/Y+x7HhaDOBnN7Yn3aPJidvm3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=W0Z672HmWyexyAJDpYlpLojrS36XIebTzIVLTMA0ZEE=;
 b=qRzqGkY1kU7/URRdB0HauneT04n3Eyr3iR60wm79CoUITIFxpTRJPQL6uRzs5f25/gZ4i/m/V7v1
   BjN97Wp4svB57uY2mqxteEE5H1ZwVsKz2THUUVor6sp8Yas5YjxzPxZupP3RQGFHVt33GpBukWSq
   Vtr3JTwugGc8onEgfqAl2IZRHTjPOclj4DZG4aeu33jqcrNjNduv4LgL5NTcnI2SM+2gM9uj9+Kl
   hZak19+dRZ09EmvpTotQ0Q7OScnocFlZN49bC/pM+dzUNwwVQ/4OYicHU34QZrfZ7JsH//HKJrEB
   i+k4tS23pjbpDzjDQXKe27Zt/66tE1UIwZzC8g==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RNN008MHUAWGW90@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 29 Dec 2022 16:11:20 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=eT+sezI7d2puBXhZ4YXeV63r+1dsBpxvT2Biv2ttQVQ=; b=CjvMuzxosYlfRlZyUreZne6XPB
 dsdBq4zBXheihbIMeS2ElpPTfep1aHkMTppG3M9VXX4j+hrA3xvtALTE1dKDVbJgRn/XvkK/3Msrn
 eRjanXTfUV2tQLntyRky0Y45cs55uEBTGho1aZPsQTGJpBqr2gp8OczZvzIPd7cAKsgsAgklZY9FQ
 FEEuCyiJxEnEmUr/V2rgzMmvgzew8LKBMJNo7Oyt/vdAD0gMTeR9itSequwor3zkWmBFvviZhw2/L
 3RcxZFmAbPj3p5oC0BZZeevS6/3SpWkUk7D8U9SkyP0scecn/DuasxSAYYvxJaL3SKNKWGwJwUZD5
 VE++S3Bg==;
To: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>,
 Jan Kara <jack@suse.com>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Thu, 29 Dec 2022 06:10:28 -1000
Message-id: <20221229161031.391878-4-hch@lst.de>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20221229161031.391878-1-hch@lst.de>
References: <20221229161031.391878-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10575
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 impostorscore=0 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0
 suspectscore=0 phishscore=0 clxscore=287 priorityscore=0 mlxlogscore=773
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212290134
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, ntfs3@lists.linux.dev
Subject: [Ocfs2-devel] [PATCH 3/6] ntfs3: remove ->writepage
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
X-Proofpoint-GUID: xM5o69Jl2lwEJpO1Lip0AT_PGOEfY9f0
X-Proofpoint-ORIG-GUID: xM5o69Jl2lwEJpO1Lip0AT_PGOEfY9f0
Reporting-Meta:
 AAEPLI6k0WmaiCZeUqwudezYIhQVmH5X1uJFY2ZxEWu81blP1FJ48SvXcjhVQrKv
 wtJQjFnGG4zDaT+PSrxPTZoHVaNXTm58OOdep/lVZ+2nyN1WNHiQEf7PkmfE5aQD
 Vbjl3jwrDchCiR3kfT+vGRg9wgrZXOO8uzeBMRrJ/P9d/EIqOjikhTyOP+8mWtqO
 UICLDTmuR8K9P89oXuug3w/tNsbYrcWZ9HPGToUa87ZNm9iEnRbXhER54VW2q/Zw
 eay6aTelVXcPaFYgUeOwOr/nIXOJnWgVRTJMmK6M8Hpy51AbcJqYnv0lrLi7NcxU
 m3WhFbHhTjYz7wSTXTuMmq9OLLOugIIFo9fV65UEjppiVkaXyVyjNTWIwENrH1R8
 X6aMLnNhNhW48IAP75WGoV0l/ZTzvniw7zbjHh4Ao2nCfelbJ+cr8FYTA+xPz5g4
 LeR5JJiQYpl1iiQks2nbXkidEdunm38d7VXyKp75FG0vKAXDIY7lQczRnH3qX6K+
 LxvU2g7txtJzsh43g5BKQdJ5ZMCeI++nZrHR3mjX+bKv

->writepage is a very inefficient method to write back data, and only
 used through write_cache_pages or a a fallback when no ->migrate_folio
method is present.

Set ->migrate_folio to the generic buffer_head based helper, and remove
the ->writepage implementation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ntfs3/inode.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index b6dad2da59501b..6b50b6e3237876 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -832,26 +832,6 @@ int ntfs_set_size(struct inode *inode, u64 new_size)
 	return err;
 }
 
-static int ntfs_writepage(struct page *page, struct writeback_control *wbc)
-{
-	struct address_space *mapping = page->mapping;
-	struct inode *inode = mapping->host;
-	struct ntfs_inode *ni = ntfs_i(inode);
-	int err;
-
-	if (is_resident(ni)) {
-		ni_lock(ni);
-		err = attr_data_write_resident(ni, page);
-		ni_unlock(ni);
-		if (err != E_NTFS_NONRESIDENT) {
-			unlock_page(page);
-			return err;
-		}
-	}
-
-	return block_write_full_page(page, ntfs_get_block, wbc);
-}
-
 static int ntfs_resident_writepage(struct page *page,
 		struct writeback_control *wbc, void *data)
 {
@@ -2083,13 +2063,13 @@ const struct inode_operations ntfs_link_inode_operations = {
 const struct address_space_operations ntfs_aops = {
 	.read_folio	= ntfs_read_folio,
 	.readahead	= ntfs_readahead,
-	.writepage	= ntfs_writepage,
 	.writepages	= ntfs_writepages,
 	.write_begin	= ntfs_write_begin,
 	.write_end	= ntfs_write_end,
 	.direct_IO	= ntfs_direct_IO,
 	.bmap		= ntfs_bmap,
 	.dirty_folio	= block_dirty_folio,
+	.migrate_folio	= buffer_migrate_folio,
 	.invalidate_folio = block_invalidate_folio,
 };
 
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
