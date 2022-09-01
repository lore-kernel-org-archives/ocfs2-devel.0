Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 010B6ECAAD1
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 19:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FYU77VmnbL6nRbxgNH/Y3LOIoPDaZR795g3+IeDkZls=;
 b=sZFCQxFahpgGG2XAq1iTDJVbbod9g4Osf9EXOBxkmq1AJ90AgkKIABaMYn3eskWv/vVMetZK2UPb
   vz/w4YUIp+h28Id4YvPCTJxXA9b6IaxJkjv0TmuirZulZZ6jZynC7ck+nUpF3Cyw9GPo6FEkFxBe
   7/Dlx3YNBgSIHQEkTJIA3z8PJsz6mWuByfpgWD91BlVWfx2UE33kgLw6DoANQka6I4aSG1cazROQ
   vM/TjmkNrRF690A7PHSgy4NrOHxjuRlF3MLjiJ+P/MGLXPLaEmS2gZBHnkaOhpJuWKLuX8w95/at
   B1Y7N9C+EyJLDKDjUJ1iW1kUG1qZQVrgWQ7yXg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FYU77VmnbL6nRbxgNH/Y3LOIoPDaZR795g3+IeDkZls=;
 b=S0U6QTZxEN4rbnJTQUuQyJXdreXzgz99YHLpKofYXMaDv60krv+j48FiLJV+iKOp29Dnr3O1s3zK
   W34m+OihKQbMgyTzRC8+lZOAV1XE+9ClSK3dh6rFY5kplTUHEv2uwFta1GxGRBHh2ASlapK8b7ZM
   Lln1H4iqCMHe583OZhayzVgjyLnm4GjwfwqmNWfJgIJupp0eUIXRSlJlnTrWcGyVc5n2l99d8TCl
   /gxUiAR7jpHuxj9k9Ol4lzyTMgDfWoF17nJnSMEbbaGApkwJ8kLmeHZF5Tf+V5cjJZBOfC3RAXiQ
   DLaYe5+5MQrXZBThpYqHKXcKe4Wkqtft+iXGPw==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ006VLP3DALA0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 19:06:49 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1662059193; bh=jLsR0gVffekc5zyoaOCJ8zt6mbwl9WlIOG+HoD7ddyE=;
 h=Date:To:From:Subject:From;
 b=H7nEkIdrnJ5gmwfJgeTuyhxi2ZUTwxF4xon1fRq40GAlfKXB/Qtla2gKSJsRM44+E
 lrCNRmbQM5Q8V+w8KlGAhl8tZXCwx20v7TcWFh1mMsmNv6zdEJYzXi8g0l1uLdmChu
 BcAwR/qkYmQeQhEh9xOVPncqvZRRe/LF1sn3/LPM=
Date: Thu, 01 Sep 2022 12:06:32 -0700
To: mm-commits@vger.kernel.org, yukuai3@huawei.com, viro@zeniv.linux.org.uk,
 tytso@mit.edu, rpeterso@redhat.com, ocfs2-devel@oss.oracle.com,
 mark@fasheh.com, jack@suse.cz, hch@infradead.org, dushistov@mail.ru,
 chengzhihao1@huawei.com, axboe@kernel.dk,
 almaz.alexandrovich@paragon-software.com, agruenba@redhat.com,
 yi.zhang@huawei.com, akpm@linux-foundation.org
Message-id: <20220901190632.E40C1C433D6@smtp.kernel.org>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999
 spamscore=0 clxscore=224 mlxscore=0 priorityscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010082
Subject: [Ocfs2-devel] + fs-buffer-remove-__breadahead_gfp.patch added to
	mm-unstable branch
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
X-Proofpoint-GUID: F2pMAdbpOJ7mGaT2R6OzKb8qOIg4Ik-p
X-Proofpoint-ORIG-GUID: F2pMAdbpOJ7mGaT2R6OzKb8qOIg4Ik-p
Reporting-Meta:
 AAGQck1dSvgGil4LAhqtcj2Hy+5Br1LgJrdv5GHsgHLXoFpI9PWWxCEDx6QX8zOv
 FOL+MoFWBW9MwyIQVmuOylpoWf0p9D5T6DZNdEaUUR7QqYXuNA5qzt3ydBcammbq
 m7mt/1Hqo8wFMVsWOn4m0r7DKdicmGuDTvqnq94kEZkiPca9lHT8ZKML5FPQs4sD
 HP03yi6Hap6BZ3FgRECXJmxd98rApauBNp2pY8+PP5dD0nkPnxn9WqR56X8GJxD3
 JPLnYt8NWwpDCxi+d2dcLpCmR4JNOAeqTWnrZi09cbu5v/C9k9WDdVSHtNIUf1Q9
 iKiMZic0x7YA6NGN6badHqD37zB1RK/LJOVTs2SXqf77WApubGxt6pMoCuXE8835
 kDy8p/zwYCeg0HDeD9QGHvHuLZ3g9d1ee7tLi0LalaUMbLq4H5c0hakA6WsEBqX5
 8tHhyMh9uZ+gA9QieF3ApERV38rifqgOoAcMJc2JuvopbxqKvn/EhCACS2M0h+OY
 G4jqj9GAue+p/sPSlr0x7SSjFtmU33Jkm4asTQojd3LI


The patch titled
     Subject: fs/buffer: remove __breadahead_gfp()
has been added to the -mm mm-unstable branch.  Its filename is
     fs-buffer-remove-__breadahead_gfp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-buffer-remove-__breadahead_gfp.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
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

fs-buffer-remove-__breadahead_gfp.patch
fs-buffer-add-some-new-buffer-read-helpers.patch
fs-buffer-replace-ll_rw_block.patch
gfs2-replace-ll_rw_block.patch
isofs-replace-ll_rw_block.patch
jbd2-replace-ll_rw_block.patch
ntfs3-replace-ll_rw_block.patch
ocfs2-replace-ll_rw_block.patch
reiserfs-replace-ll_rw_block.patch
udf-replace-ll_rw_block.patch
ufs-replace-ll_rw_block.patch
fs-buffer-remove-ll_rw_block-helper.patch
ext2-replace-bh_submit_read-helper-with-bh_read_locked.patch
fs-buffer-remove-bh_submit_read-helper.patch


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
