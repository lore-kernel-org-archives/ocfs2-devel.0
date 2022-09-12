Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63750ECAAA1
	for <ocfs2-devel@archiver.kernel.org>; Mon, 12 Sep 2022 03:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EdMBGC1GKazenZuHlogP7ox+LCtEmmXYGoPSIiHcxRU=;
 b=vvAyIQzPrRsdAFyGGvBKswL9rVD3Swx/5J2PvEG+igWtyB3ufdR8pO9fRyrekQSwl+YvKxk1fbZS
   sTnbaOvBYnIpV6egvxfqpdJHgo9R0kmA5WCgrzAMpENkXehVwl2CCpMBIuubL7L5N6pNW8t3idkq
   NQSQzipIpr3fOXqGx3hQKr+kOAwNHdEj82/BR31fJX8FIlujQwbyWAdiso30Yy05oVVRfYwyLtuI
   Ij3m2d5vFnlRM23IsQjqhqi9gM4DWPcUP8azbzGHiitInG2bWvP2FUXASvo8n3rsRRXkolDGwxu1
   SEauMpK0vW3zfTWyFtJ0QuxHDpKTJ/1dZN4mig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EdMBGC1GKazenZuHlogP7ox+LCtEmmXYGoPSIiHcxRU=;
 b=MCLQl0ZD2iraky7VcI3OWI0F8dsc2/Bos5ZC9Gl5K5ond9CPOPrb4eG5DQq/5vkMjI5crVpf9B0f
   9zsHzBcRggUDVTkyOiy9tRi1LeG7DH9Qp40rZQdabdCF4EZ+wlkW0RPjYwccYJxzrS8vtevnIaZR
   ZqUoa4gpheUKR1i5RPvyoIu3zezC78Y/u5dLqQEuCYdn4/GoixangakQo8MO5GKlmrD4OsWatjYf
   +evjr0kHhSiGA+noVvOTZKWw8lsEUza0Rpez3BX7DjAMXczRDY+mG63unENXscNL3oGed45/F+jP
   jl4FYG1z1u06FlnjQYsABw+J8UziSRVYG1QqAA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220826 64bit (built Aug 26
 2022))
 with ESMTPS id <0RI200I0NV35GB90@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 12 Sep 2022 03:30:41 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1662953424; bh=GUxneq2NqCjy5lzqZdTNXLDp4toQQO/UnaIbpAm0WFk=;
 h=Date:To:From:Subject:From;
 b=v5SWOr9SZsG+PL35oiYD7TeOEs4y8+NV6i4iDtDThNVFzBF9Q3nRPXR2VsJy6EeX/
 t4ocFAnWe8+8LBcMfFL8NKf45yCEH2u2m7ITvTpOUHtjCZ/xF1D9wklZclTHr2NifU
 9HzYGaQnHXNFYKBs7h3pN4LQPBEdARW8aeDQn5w0=
Date: Sun, 11 Sep 2022 20:30:23 -0700
To: mm-commits@vger.kernel.org, yukuai3@huawei.com, viro@zeniv.linux.org.uk,
 tytso@mit.edu, rpeterso@redhat.com, ocfs2-devel@oss.oracle.com,
 mark@fasheh.com, jack@suse.cz, hch@lst.de, dushistov@mail.ru,
 chengzhihao1@huawei.com, axboe@kernel.dk,
 almaz.alexandrovich@paragon-software.com, agruenba@redhat.com,
 yi.zhang@huawei.com, akpm@linux-foundation.org
Message-id: <20220912033024.9C7BFC433D6@smtp.kernel.org>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10467
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 impostorscore=0 priorityscore=90
 malwarescore=0 adultscore=0 clxscore=245 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209120011
Subject: [Ocfs2-devel] [merged mm-stable]
	fs-buffer-remove-__breadahead_gfp.patch removed from -mm tree
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
From: Andrew Morton via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Andrew Morton <akpm@linux-foundation.org>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: bkkV8twPElCG2Bl9Ck53yxNKb9K7_8j8
X-Proofpoint-ORIG-GUID: bkkV8twPElCG2Bl9Ck53yxNKb9K7_8j8
Reporting-Meta:
 AAEhYN/X2RInAnRJQ/UkGd8plSe4cAmXyTNR0y42zcVTANHchGP3QXhZc3Fl52V2
 bPR/vl8L/TeqZBAsMYYtOqclkKwSua9U464P/r2PkRKeLZGQGwsR07MhQqNFe1Ds
 PWscL+qZraufhyfbbpJ1g+aQWbBngX5d6PRp8YEfcU5TZSSmn0mWOu8xL5lLp1+R
 +VRj0TS8pQTXypFqGzu0YRLF8JsQ3Zlq3Ys4EWO+Yfaumg7dXYpxGhncTcQes4Fh
 qnX+nszCJ4Qgp4H4fZejp5VLGY/m+fpeiGQdtFAAnhDRodA+HFb+gkwNF2ZXKYvW
 Tb0IJJF79KtH7/TBmsvU8Wdrn3n5615GRfoAOKUSBuSuv2XVvDj2dzM4jXSyJz/R
 ouJun7JEIhbHs0CmZeyzr26vmqZCdfeNrsRu5w6f4k0hCmbY1+mMidlZRVcC8oaD
 Dbm9+qNGaKXJv3WTPhToiNEbjRrCEruZ0NJ65s0ib3Rk+hvcos6Mz7txrQoVL3j/
 G1P0HwzYlCHqYqr2qgV/IQu0BR10WxuWx8tXTfbLwJD4


The quilt patch titled
     Subject: fs/buffer: remove __breadahead_gfp()
has been removed from the -mm tree.  Its filename was
     fs-buffer-remove-__breadahead_gfp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhang Yi <yi.zhang@huawei.com>
Subject: fs/buffer: remove __breadahead_gfp()
Date: Thu, 1 Sep 2022 21:34:52 +0800

Patch series "fs/buffer: remove ll_rw_block()", v2.

ll_rw_block() will skip locked buffer before submitting IO, it assumes
that locked buffer means it is under IO.  This assumption is not always
true because we cannot guarantee every buffer lock path would submit IO. 
After commit 88dbcbb3a484 ("blkdev: avoid migration stalls for blkdev
pages"), buffer_migrate_folio_norefs() becomes one exceptional case, and
there may be others.  So ll_rw_block() is not safe on the sync read path,
we could get false positive EIO return value when filesystem reading
metadata.  It seems that it could be only used on the readahead path.

Unfortunately, many filesystem misuse the ll_rw_block() on the sync read
path.  This patch set just remove ll_rw_block() and add new friendly
helpers, which could prevent false positive EIO on the read metadata path.
Thanks for the suggestion from Jan, the original discussion is at [1].

 patch 1: remove unused helpers in fs/buffer.c
 patch 2: add new bh_read_[*] helpers
 patch 3-11: remove all ll_rw_block() calls in filesystems
 patch 12-14: do some leftover cleanups.

[1]. https://lore.kernel.org/linux-mm/20220825080146.2021641-1-chengzhihao1@huawei.com/


This patch (of 14):

No one use __breadahead_gfp() and sb_breadahead_unmovable() any more,
remove them.

Link: https://lkml.kernel.org/r/20220901133505.2510834-1-yi.zhang@huawei.com
Link: https://lkml.kernel.org/r/20220901133505.2510834-2-yi.zhang@huawei.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Heming Zhao <ocfs2-devel@oss.oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   11 -----------
 include/linux/buffer_head.h |    8 --------
 2 files changed, 19 deletions(-)

--- a/fs/buffer.c~fs-buffer-remove-__breadahead_gfp
+++ a/fs/buffer.c
@@ -1348,17 +1348,6 @@ void __breadahead(struct block_device *b
 }
 EXPORT_SYMBOL(__breadahead);
 
-void __breadahead_gfp(struct block_device *bdev, sector_t block, unsigned size,
-		      gfp_t gfp)
-{
-	struct buffer_head *bh = __getblk_gfp(bdev, block, size, gfp);
-	if (likely(bh)) {
-		ll_rw_block(REQ_OP_READ | REQ_RAHEAD, 1, &bh);
-		brelse(bh);
-	}
-}
-EXPORT_SYMBOL(__breadahead_gfp);
-
 /**
  *  __bread_gfp() - reads a specified block and returns the bh
  *  @bdev: the block_device to read from
--- a/include/linux/buffer_head.h~fs-buffer-remove-__breadahead_gfp
+++ a/include/linux/buffer_head.h
@@ -214,8 +214,6 @@ struct buffer_head *__getblk_gfp(struct
 void __brelse(struct buffer_head *);
 void __bforget(struct buffer_head *);
 void __breadahead(struct block_device *, sector_t block, unsigned int size);
-void __breadahead_gfp(struct block_device *, sector_t block, unsigned int size,
-		  gfp_t gfp);
 struct buffer_head *__bread_gfp(struct block_device *,
 				sector_t block, unsigned size, gfp_t gfp);
 void invalidate_bh_lrus(void);
@@ -340,12 +338,6 @@ sb_breadahead(struct super_block *sb, se
 	__breadahead(sb->s_bdev, block, sb->s_blocksize);
 }
 
-static inline void
-sb_breadahead_unmovable(struct super_block *sb, sector_t block)
-{
-	__breadahead_gfp(sb->s_bdev, block, sb->s_blocksize, 0);
-}
-
 static inline struct buffer_head *
 sb_getblk(struct super_block *sb, sector_t block)
 {
_

Patches currently in -mm which might be from yi.zhang@huawei.com are



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
