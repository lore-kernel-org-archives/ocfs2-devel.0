Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAE31ECAAD3
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 13:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ddz0UmqMESkJLPVy3XJ+Im5L/sUFKtn+KiweUl3b3Dc=;
 b=1rpeox+um+vM1WiLTo0HL8dgp8WsZ0B2jpmPUkoxr0LViJEkPJyT1GU1L6mzVKfBb7qWYomut8Qg
   JDi+lB4QlH41h29WJn2V1GhfoNJZQij9wdKoq0dC1GuweMlzFCZUkhHiqWJZsFIeev2O65alQJAK
   F9gPttxB4xaVUR76G/b/cIgpeQLcOJtkHwoCE2POVCh/IFOxW2zc9xN29MEl0gnR2qgXhD/4/j7v
   jMuD2DyFeihfFkJhr/Re931jUFXe7sY2/0ffG8nkmkJaihVjsmYztaJTENqJmbcZSlbpv/Kq+Rad
   p/lCMQ7c8WbCGTEipXzoGyRymWeZeqYmIJsVfg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ddz0UmqMESkJLPVy3XJ+Im5L/sUFKtn+KiweUl3b3Dc=;
 b=e4hrjjGyLX5qGBklsf8dd5aejCX6XRx5fOM8+3Fr8BVHTjhYsyPQYDoexdqCyb9k+GjhNDm6cr6P
   wyhURs5WUTadjf+ZmnKJxsAcLk6eUY9MrHYOQY04mj1ZBgo2Ue1wJkaPJqHFYJoqaIzMP0MuCSU1
   M2PE/2sSGwzlWXJsLA9FfCbsrarLuHiy3UzLCmHamFCvg6jk0oWtCkGJFsoTckU68EOkVvvu5W6b
   /1Wz5vm4QZUmEN9WxvQdj0sSD2w+G/KdnMqU+P2GNN+1xlsQ2BFXcbFG4aADxQ87T/BNLO0vtsn8
   IxzfT1oHs7YdfbFIW7B2t/mjg85Gjk1PCB3CXA==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ00L2Z98K6S90@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 13:24:20 +0000 (GMT)
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <cluster-devel@redhat.com>,
 <ntfs3@lists.linux.dev>, <ocfs2-devel@oss.oracle.com>,
 <reiserfs-devel@vger.kernel.org>, <jack@suse.cz>
Date: Thu, 1 Sep 2022 21:34:54 +0800
Message-id: <20220901133505.2510834-4-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220901133505.2510834-1-yi.zhang@huawei.com>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.127.227]
X-Source-IP: 45.249.212.188
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 priorityscore=207 phishscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 adultscore=0 clxscore=123
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010060 domainage_hfrom=8269
Cc: axboe@kernel.dk, hch@infradead.org, tytso@mit.edu, agruenba@redhat.com,
 yi.zhang@huawei.com, almaz.alexandrovich@paragon-software.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, rpeterso@redhat.com,
 dushistov@mail.ru, chengzhihao1@huawei.com
Subject: [Ocfs2-devel] [PATCH v2 03/14] fs/buffer: replace ll_rw_block()
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
From: Zhang Yi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Zhang Yi <yi.zhang@huawei.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
X-ServerName: szxga02-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: DRZYMPa5B7fhwEp21EGCY5rvTkv38s5d
X-Proofpoint-GUID: DRZYMPa5B7fhwEp21EGCY5rvTkv38s5d
Reporting-Meta:
 AAGJMB0kxE5tPjUshQcwVapkM6uX6X841baEh8Qht4rsUlFIp2cmwa3AmWbO13k1
 2eMvuM17ffTZGFql+u8FkKNU4/bFBPl5HDK3ckRK3qrGUcD+RS5ZERgkDNOGqNko
 y2b/vrPziiRCWicxWHf9cC3f3Xl9SW+NlmLat/B94s2V2Er4cLlnr3Uf1PrZpMhc
 4U33p3CSyeS3Bo6NFI69g95DYCRwjfzpebzqIUO7o/V/+12Om6wsqZZcNVC2i+D/
 QI0Aolnxng1mOBJiBqzc2sbqSdJ3Qal7/K0Z2B+9tfpos0d8Gesdd+x/A7rD1pW2
 UM0uT6y26fmH3zmpz+SIdvg+V2mYvYnLEBwqKPla9CyJryNzTJmQXzQxEaw8460Z
 jQyhBVknq88we2wCTVESKsfwqrjkoiirWm1uqNU7hHliQdc60c++zEIFowUXi9CG
 xJVSvtv001Dq+be/FBhAXmcGugMK99zgmnEMDRhHSSp5smwgxJ93zydI32nY27Mn
 Op+zisHVnFAbNRzqu7VB6Yx8tP9nllI9Nm7tvYg9bo35

ll_rw_block() is not safe for the sync IO path because it skip buffers
which has been locked by others, it could lead to false positive EIO
when submitting read IO. So stop using ll_rw_block(), switch to use new
helpers which could guarantee buffer locked and submit IO if needed.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/buffer.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index a6bc769e665d..aec568b3ae52 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -562,7 +562,7 @@ void write_boundary_block(struct block_device *bdev,
 	struct buffer_head *bh = __find_get_block(bdev, bblock + 1, blocksize);
 	if (bh) {
 		if (buffer_dirty(bh))
-			ll_rw_block(REQ_OP_WRITE, 1, &bh);
+			write_dirty_buffer(bh, 0);
 		put_bh(bh);
 	}
 }
@@ -1342,7 +1342,7 @@ void __breadahead(struct block_device *bdev, sector_t block, unsigned size)
 {
 	struct buffer_head *bh = __getblk(bdev, block, size);
 	if (likely(bh)) {
-		ll_rw_block(REQ_OP_READ | REQ_RAHEAD, 1, &bh);
+		bh_readahead(bh, REQ_RAHEAD);
 		brelse(bh);
 	}
 }
@@ -2022,7 +2022,7 @@ int __block_write_begin_int(struct folio *folio, loff_t pos, unsigned len,
 		if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
 		    !buffer_unwritten(bh) &&
 		     (block_start < from || block_end > to)) {
-			ll_rw_block(REQ_OP_READ, 1, &bh);
+			bh_read_nowait(bh, 0);
 			*wait_bh++=bh;
 		}
 	}
@@ -2582,11 +2582,9 @@ int block_truncate_page(struct address_space *mapping,
 		set_buffer_uptodate(bh);
 
 	if (!buffer_uptodate(bh) && !buffer_delay(bh) && !buffer_unwritten(bh)) {
-		err = -EIO;
-		ll_rw_block(REQ_OP_READ, 1, &bh);
-		wait_on_buffer(bh);
+		err = bh_read(bh, 0);
 		/* Uhhuh. Read error. Complain and punt. */
-		if (!buffer_uptodate(bh))
+		if (err < 0)
 			goto unlock;
 	}
 
-- 
2.31.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
