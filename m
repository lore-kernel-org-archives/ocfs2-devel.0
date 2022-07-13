Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34426C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Jul 2022 15:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2lGNmgXz+F4/9HJC70DGg4P4Fq/gvFTwB9pF5ni9YJ4=;
 b=ZZrfekP8nhyyQKD9qIv8mwwmqjMV5b+WmqTlDdnLjm7tJ+LaPqJhDHHl2Vc3YJ+W9mGiBS7Kim6H
   cR27d4La3avvoBc31YSc8MG0LAf4c3S1tq1NWpzEkXJ+B/Lu+7qd4EHeQh6UN0of9zgEsAQ6IhEM
   lQehM/S0Dy8Pts0iuIuq4tD9XRIsfXezXn3xGJPajo7s1qhz/E8hjGHEa9f94/By4hTMDp0UmOA8
   Z29nyHwmq2zXEOrhgf1H33LjnRh4AsuCzQBH/++0ByCfM6Sn6iN6D07lDv8Rfd1ulpCGBI0Pt3KR
   sffeL0WacKK72uqXAvun3yxN+UsjQtVGBnrnXg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2lGNmgXz+F4/9HJC70DGg4P4Fq/gvFTwB9pF5ni9YJ4=;
 b=j+Tq0GbAHd8OSHPzSHYiPcWTdQuASi0kGh3sptQWQF0QJHvdEKwKJ6RMYXAmpRgNfHqmpxinWNLZ
   2vkyx7meOyjvMO4tCelIQwORxi5RvExowPXdzPStcP1tAfcSI6WoA6ZFM56O+wH1dTsRTEsgzKd2
   wuayw/odUzUch9j0Dldk6QeeRkBp8eZt0HkNXkyNLbMLaRQ+sXqRHDUOICsPCwns+2oU1xYttD88
   Zl0yMkeRH8uQAfc1nndKElYUBLoEvwSP0Kq64wB/ek0vFFd5P4y1k/LjK1UFVh2GgJer6ImGb/Y8
   c1qi7LhgFV9TPD5eaOzqctnytrVogT7kwUFCIA==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220603 64bit (built Jun  3
 2022))
 with ESMTPS id <0REY00CBDSYPLUE0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 13 Jul 2022 15:13:37 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=oVF8muBFUtxIxMWHnxdNoSfRx8q8DedDPDTnq4wy7CA=; b=MdHLRRAgbOCH6r9SSIyh7sgJY5
 T1Gfr+3Gk0ySNEQiUYRfL3WBQhq6b31TOb9e9r39b90ECAT0QBlJKrsFL/omMn+LQXbfMfT4ZL8/H
 V65/qxfGC1sfiJndzayottsrq2w/DI4ZOHR3UjTWv7gEHh7+ZSqVe7TytGhqbRaStUZC9ZYlALqx7
 lVXL8jVVEqleTBzMql1idapQKcnqGoRwgDKZI+aV1ztO2bJXl/4I28HNmt9JW1JAUcheWocyYstB/
 nz6ClRZuxPpErxcz3ntiP4NR0F+596gfewyQFWirqW7bk5tF4k37QcqwhAWli8lJB4A4ksPftKtko
 WsPXawgA==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 13 Jul 2022 07:53:13 +0200
Message-id: <20220713055317.1888500-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220713055317.1888500-1-hch@lst.de>
References: <20220713055317.1888500-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10406
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 mlxlogscore=789 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 priorityscore=48 clxscore=262 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130024
Cc: linux-block@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>, linux-ext4@vger.kernel.org,
 Jack Wang <jinpu.wang@ionos.com>, ocfs2-devel@oss.oracle.com,
 drbd-dev@lists.linbit.com
Subject: [Ocfs2-devel] [PATCH 5/9] pktcdvd: stop using bdevname in	pkt_new_dev
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
X-Proofpoint-GUID: fB6EXy8MM5IOOlc1Qsn2hMAv6KtRzp76
X-Proofpoint-ORIG-GUID: fB6EXy8MM5IOOlc1Qsn2hMAv6KtRzp76
Reporting-Meta:
 AAFSUxiObS6g5VnzfhDeQ/Z6XVJulv+2q1i5iWn/roOpvgehYRWUbd46307KouAe
 32iGLqaNAqxnaCWgtnbXRcXzINeN9dCvfMrFxGS3deRiglTMhgSBKquzDMj7oHyo
 Vrg1yAQsCuOwj2UF6vZl/meN+GsUAmUyLk63+7FZjlONYA2cuO5voSnpkZO9cWgv
 37LbL8aeMM9Oqzn0pKT+EhQoL/nu5GieunDkUdnRTcFEYkyX+L9hgLeGMR9auuvo
 D24yNOPnW7isPkw08deIVpUx78jyAk5dIPCloZHWa8vREF33tk16ZMb7Qdwk1YM+
 jNqBD9xKrnZM7uRbUxe2N58OKH/5HCL4F0DfHvP4SDo+LfxCQa0CebodXn6am9bO
 4xY78RSHOdmFcjtujkCoYjYHXNh+LlLCEhqlhLHttk7hCO5KIQNSGPhAR5y2lk7S
 E4ARaF2/XZ/+Ng4CWzMCCHzHo3OjueLgqw0SfDlU5QW1vJ9lfNbEIhPVr4FRhqCJ
 HViPfq64clF1jUhq6+FAQJd+F6lGav4nzZVOkI/WZQ==

Just use the %pg format specifier instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/pktcdvd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index a7016ffce9a43..01a15dbd9cde2 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2519,7 +2519,6 @@ static int pkt_seq_show(struct seq_file *m, void *p)
 static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 {
 	int i;
-	char b[BDEVNAME_SIZE];
 	struct block_device *bdev;
 	struct scsi_device *sdev;
 
@@ -2532,8 +2531,7 @@ static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 		if (!pd2)
 			continue;
 		if (pd2->bdev->bd_dev == dev) {
-			pkt_err(pd, "%s already setup\n",
-				bdevname(pd2->bdev, b));
+			pkt_err(pd, "%pg already setup\n", pd2->bdev);
 			return -EBUSY;
 		}
 		if (pd2->pkt_dev == dev) {
@@ -2568,7 +2566,7 @@ static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 	}
 
 	proc_create_single_data(pd->name, 0, pkt_proc, pkt_seq_show, pd);
-	pkt_dbg(1, pd, "writer mapped to %s\n", bdevname(bdev, b));
+	pkt_dbg(1, pd, "writer mapped to %pg\n", bdev);
 	return 0;
 
 out_mem:
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
