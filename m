Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72D7EEB64D7
	for <ocfs2-devel@archiver.kernel.org>; Tue, 20 Jun 2023 14:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=B3LZYuDAggCmeuAe5G+a/SF1hQe99A7odhSFx/mKTws=;
 b=RgXouyNDK5H42rVfftXicFKgkjwPfSBIpH8qUfg/yNjsv1KthXbRlTD00s5OHiB3/JiW6wNYVurC
   SbfAnvC0sk/JfVc1raZGv1Nifob+3EtYX2Jxnzt0dfdCYhcOBwxj9hlYaH5Tlr64oqvrRPNTc1os
   2iDn0gh2H9gxM58qpDGXbLDrGKP7lHHrfFUVzk7ss/6qEMNr+6JSsrtDma45EoFDORXkDT9qp+j4
   02Lbo30HI9yxNQxke1AUcq6uap34SgiQnOVRrd5BGvns5YRiE0/joiNejaxxbyh8ZtwEyd1wT98P
   7Xdj6MJdTiHnkrtvRUTtavFcTg1Qxvzu38I+nA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=B3LZYuDAggCmeuAe5G+a/SF1hQe99A7odhSFx/mKTws=;
 b=bQ6oVcFi1X73tFdXfVCdXP/FyKx+2csO+jVGlCkkCXcWjdDcgBPKqPKu7qxTv8cwECpbpyhCsKSq
   vStTME1y/v2xFJfsgrOHicRd1BJfJFZGT08vuX0Y/MjvMAcS0iJ13zKfQbae+nmM1kfZBdmHCwZp
   NxfM9X0jTbHFR9j+uw8l/BIkiYc2rGj/XefdXrxesGvxWRTQtkRYufv/nM6XN+Ht2F3pJtMjkEOn
   LEK+Na1+XXqH1kMAxqidi2m0OCA19PXVBwNwSwWmROgwKUu4r8705gBMvR215yEx4ebkVyyC3K9R
   QD/kZPsQwSoOsEYoKM4U9PAmAM/f97+OOd0JMA==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWK00L7G45YR5B0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 20 Jun 2023 14:56:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; t=1687123984; cv=none; d=strato.com;
 s=strato-dkim-0002;
 b=nWSvTOOnO8ugSK6+/H307s3L5N4uQG5KOysBX2IgampHzUt/e1M7vWIgYdM3yVn8L6
 mF36Wi9H8fUj11MVYKe9B3JL/hDoWwgnzOa3dvcISkQQDSb2WEO0SpuCxbpl9ulC48VA
 6OTnqS/TmHNy3oQ4R2DtbjIhU7Nohg+aSNxXIW/hxT2ZMWnTYP5q+8lRRwhkjZdu7w8l
 M4LdL+lzkB6WNMIUSREXZKPuCvrGYQZzoo743PqH5qMBYNux3lLCwnXbWxglyfCgKp9d
 JjMRY3fdgtxXhCanLp8cu/y+YDIQJYd/ZKZOPMXDY0KPjjpxCPe64ikJHtlBMzm9mmqZ c3oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1687123984;
 s=strato-dkim-0002; d=strato.com;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=FiS5DxAChRRX4k3Ho2cvADBUbEW2Co/dwGRsyJUkQbY=;
 b=F1UqAkcdL/glDaJ1655WMMKUY52RDJgVOqcvh+cD7JNw7DLTJekAmQP9YVLy8YWOBF
 guSVfoSeB8n1uU731qyZ+2YC7+WmUd1aoBptm75em2DG7A0I9YV9NJuGRMXnCNnXU294
 CmwqbHfbRSHFnlCjWqWsUA4Re7ELTkbddNyG3e3F5zHhnCOKvViEuF728C4h3kfIP49z
 ceyU8ATRHqXtto6Jx7yx/Q4/a+0El45664DLB5wW80ELr1N0KPFG7lCoJLDTbf+1GuWJ
 bW5Tks8uPB7H4X+tPVl3XNjIVDIDbVkrwfOqq5JPKciLf00llz8zYQ8HIq0h2A0FypH/ mlmA==
ARC-Authentication-results: i=1; strato.com;    arc=none;    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1687123984;
 s=strato-dkim-0002; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=FiS5DxAChRRX4k3Ho2cvADBUbEW2Co/dwGRsyJUkQbY=;
 b=PRWXw8CAKoV3Zc0FbJ0k+sd2UEx2mwQS5sPlJ1IMvyUGGrk2/AECJxgw8T9H60V+iT
 kf2EVFWyYPiH5njS6Yr90PInkPm3bbiSsQOqbEO3o/gQzIMpb4DzqVJRw1SE5b/I2uAx
 GSla28BN0VEmJRltrEOtfGQvTP6/b2mojhwgA0OmUOhsbDzMpCc4A+/k5f6NOjxIhOLF
 Yi7snDkMa2CTQrMtS6p8Q0vIAV7Bp+2QT1be6BQJY8RJX9ie+m1vSjmzrnqH2QF5a1vo
 KuOIRvcXk1STDH86GatVeyNvviTymJ46nAkmGMH1fwNUrLcbDWtT2GXSU5bV+yN964xt 5s8w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1687123984;
 s=strato-dkim-0003; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=FiS5DxAChRRX4k3Ho2cvADBUbEW2Co/dwGRsyJUkQbY=;
 b=t62gJy/K2AlLeFVlbN8g/Eh1wVR4obWhlmtyT/E4D34lZw5GOWaD5/PPUg52sfahSL
 IphcxhR520CJ6vjmIdAw==
To: viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 jack@suse.cz, jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Date: Sun, 18 Jun 2023 23:32:46 +0200
Message-id: <20230618213250.694110-2-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20230618213250.694110-1-beanhuo@iokpp.de>
References: <20230618213250.694110-1-beanhuo@iokpp.de>
MIME-version: 1.0
X-Source-IP: 81.169.146.171
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10745
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 adultscore=0 priorityscore=0 unknownsenderscore=20 bulkscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 mlxlogscore=582 impostorscore=0
 clxscore=175 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306180205
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, beanhuo@micron.com
Subject: [Ocfs2-devel] [PATCH v1 1/5] fs/buffer: clean up block_commit_write
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
From: Bean Huo via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Bean Huo <beanhuo@iokpp.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-RZG-CLASS-ID: mo02
X-RZG-AUTH:
 ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD1EQ33bneoxgmq5ARfEwes1hW/CxwfjqKzP/cKnUXGNs35zouFQhI="
X-ServerName: mo4-p02-ob.smtp.rzone.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: EquwXx_iTqlDTpSv_--WLlanpb00bIfT
X-Proofpoint-ORIG-GUID: EquwXx_iTqlDTpSv_--WLlanpb00bIfT
X-Mailman-Approved-At: Tue, 20 Jun 2023 14:56:20 +0000
Reporting-Meta:
 AAHDpdNKOgkuHhNYCU9GXcgZqYaqQXb4j39wnmc4ygVI7iTIW1VXDRMuwKPYHo5u
 fH08IaJLIZSN350VnoZQyat9BZhVhfu+TeKfO8uwKstjboxTxP4WGALMig6ciPyt
 wnRZl/JAAhPJS4297KMd8CFdKOvnqaHZMD3bMOAs34FRGxxZHBdka+uYbgDOQtWR
 kg1bO1zASSEkZxBhp4Rh9lZaieEk20i9szXtTcMij+R4f01Q2noBZahOfqwQLI7d
 YTMBK8ODxbUGfy+97tWXfRO60bKR0eNem9bL+k9d9Vk6avv8E+HdEWyv3bjgZE5r
 0n4Z2V8GqLw9P3ZNt7GxBQ5zCfnp0DLaBcLFi5owlOCN8JbM6sj1dctYn0+zDrq6
 f993v/LhPRJWl5cjy8K0u+K588ybECVjLU0H3TShyRtqDjdJE5BSfFDOzK3RFV+9
 E+IqgK+2TOaEOOZ9KvtSBpDdaKygLcTthQT6PQOR7c8IWU50brFk9oRJvdsgwrEU
 5Sh0dFJ5zFwRrJKIFFe1C8m9BZnxq4e8LjQj/EvanTg=

From: Bean Huo <beanhuo@micron.com>

Originally inode is used to get blksize, after commit 45bce8f3e343
("fs/buffer.c: make block-size be per-page and protected by the page lock"),
__block_commit_write no longer uses this parameter inode, this patch is to
remove inode and clean up block_commit_write.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 fs/buffer.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index a7fc561758b1..b88bb7ec38be 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2116,8 +2116,7 @@ int __block_write_begin(struct page *page, loff_t pos, unsigned len,
 }
 EXPORT_SYMBOL(__block_write_begin);
 
-static int __block_commit_write(struct inode *inode, struct page *page,
-		unsigned from, unsigned to)
+int block_commit_write(struct page *page, unsigned int from, unsigned int to)
 {
 	unsigned block_start, block_end;
 	int partial = 0;
@@ -2154,6 +2153,7 @@ static int __block_commit_write(struct inode *inode, struct page *page,
 		SetPageUptodate(page);
 	return 0;
 }
+EXPORT_SYMBOL(block_commit_write);
 
 /*
  * block_write_begin takes care of the basic task of block allocation and
@@ -2188,7 +2188,6 @@ int block_write_end(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned copied,
 			struct page *page, void *fsdata)
 {
-	struct inode *inode = mapping->host;
 	unsigned start;
 
 	start = pos & (PAGE_SIZE - 1);
@@ -2214,7 +2213,7 @@ int block_write_end(struct file *file, struct address_space *mapping,
 	flush_dcache_page(page);
 
 	/* This could be a short (even 0-length) commit */
-	__block_commit_write(inode, page, start, start+copied);
+	block_commit_write(page, start, start+copied);
 
 	return copied;
 }
@@ -2535,14 +2534,6 @@ int cont_write_begin(struct file *file, struct address_space *mapping,
 }
 EXPORT_SYMBOL(cont_write_begin);
 
-int block_commit_write(struct page *page, unsigned from, unsigned to)
-{
-	struct inode *inode = page->mapping->host;
-	__block_commit_write(inode,page,from,to);
-	return 0;
-}
-EXPORT_SYMBOL(block_commit_write);
-
 /*
  * block_page_mkwrite() is not allowed to change the file size as it gets
  * called from a page fault handler when a page is first dirtied. Hence we must
-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
