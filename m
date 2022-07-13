Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F41B9C433EF
	for <ocfs2-devel@archiver.kernel.org>; Sun, 17 Jul 2022 06:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QculGYWjgrA0oD1D86VJ57Tc5VfpO5FG+56h28mys9g=;
 b=h+rfPugmHjguDcSad0qc/dTbn45zPVa1EDYNZ3gJye81n1p536lWVqz3wFbgj3/AUTK+RVTxH0pH
   /5OMK0QyupypLQS9Z4smjPk0vDpKXuYNWIwdwoRSAYMEezIZm/XQQXNNH+PAQZx+kg8SQqVDnJgw
   ylVcaApghXx50wU0sj9kP/rK5chtakfl1yZzshcCSNCOk5aFJPaG1wihVm5FAX4F4GG/5t1uP7UY
   vYxHFyR4yFaRiam25Auj2lEOk/XknaoS4nlBMvhI38ZHeCVWtb7/Q3rwVTZRpELQRYGXGbYAXFDs
   NItem0shlBlMoDWBGoi2JQ0V8eFKrOTiLmvxZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QculGYWjgrA0oD1D86VJ57Tc5VfpO5FG+56h28mys9g=;
 b=RpYfRk63k2wrgqs2d8Bx/uzrWQf7jJ/QDDNdB+mtvsSI58TwZivt+NwqZaBlNpLFWQad1yt7ZneQ
   acp4Ro9YB5fL4OtaAfD86/3gw4WabDfOEQKuFEHZv9tR/gsE++wxM16TmwfXJIQxV1rTUJD1h5f5
   4WqwYzYk1k80lYqB2cRLyhW/qDdO7Kj5KIKDEvAmZf3g6d0Ky35PyIthFGnayeDeEZvmZ6sCYoUP
   8tjw+Q7G0+MRFb00/ajfnKRQLmibGv2NQ6u0vOLP4fSYMBOiESXxsGmaim8TVuaNL3kKlxP35y9+
   ZbE3pP6Mmzpj4H45cF7QzNkC1R+kQrIYoL6UnA==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220603 64bit (built Jun  3
 2022))
 with ESMTPS id <0RF5008API7JYMD0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 17 Jul 2022 06:04:31 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=Y2m5n2ywVdorzEoaFVlEdw3M6b4Binlg2HpluXfaIZg=; b=aY8PUpMOr3XL4OGdcJC3oZLePj
 U2Fpy5CT1WtNvKl+Uh2jm9+2lBXEu/Jso/1cholqbux8jzHP3uQ/4/wImvAQ3GuR2SrEuZ/gSB7He
 57CgDQLolbdY00Dzuwwr2vNEIgrxp2tIoBknZFSKaduvhaGj1E1fBPc/THzPcVj1eroIl7hMQUprV
 /QynO1qrDenogR8CfOhS4ukxm0TgzTd0/AGa4IQnrUaIWlT77XHIsNONx0aYZP5hsMoueapQNk0Nw
 RtbEUPKVuSWup65o3wgXLZUx7fXmOIh7e5sk0ewAprdrhvV1K3tdjHdt7+zkT4HxaLTkBXvHvlDwz
 OM73TuRg==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 13 Jul 2022 07:53:09 +0200
Message-id: <20220713055317.1888500-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220713055317.1888500-1-hch@lst.de>
References: <20220713055317.1888500-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10406
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=754
 clxscore=261 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130023
Cc: linux-block@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>, linux-ext4@vger.kernel.org,
 Jack Wang <jinpu.wang@ionos.com>, ocfs2-devel@oss.oracle.com,
 drbd-dev@lists.linbit.com
Subject: [Ocfs2-devel] [PATCH 1/9] block: stop using bdevname in
	bdev_write_inode
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
X-Proofpoint-GUID: VMqovft5xalv0vgbpf4Efg3pOaNPr_wI
X-Proofpoint-ORIG-GUID: VMqovft5xalv0vgbpf4Efg3pOaNPr_wI
Reporting-Meta:
 AAHG2OIcrTOvhs1/r4+57cjR35GE1gTzwJgFiLyXAnTpdbkvXd/NO1Yl0PraHipS
 SObDWZQNXgjAOipD8eYl3aIe28fKxa1EqE9K52vSruCqAvhYUqIUBQ00lAcmZHci
 319rtntHFB4tfr7uH2CTsobObC4TE4u3SASYW2b8DWoowXo/OgxsnbDf3hoQsvAs
 uLVdPVKOu9JVZ/p3Q+QAZm1DvhorvS6miFKOKLi422GTSBKqto2tx7BkFcm9gKTN
 U2+9OgTikEIfpr4lWzP3bR8aF6x5g9imt1egJw4Mb5VbyMiAD81/EmJzisRaLlAq
 57OYjw9XYicGmvvdfIKmXupLOkUHFNo+/vkDaNV1hNOSoeTYIov3PPuP73MqHXlW
 XL0UxtfmFbe4EcprGKveVEdgHVvJuMsdcoIyQWy4ZhGW+9O7cLQ8Yz9tyvjG/u9S
 v7EtNJQJN8lkW/Jk/xfik18h6kmc6FBPdyJ59H23yep9cKheoFoYrlXhlRptd18K
 KHPC/k9l6L3tSiV9oRa7jhepvIfvyjW6sv3/sAyNqfzX

Just use the %pg format specifier instead.  Also reformat the
printk statement to be more readable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bdev.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index 5fe06c1f2def4..ce05175e71cea 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -54,12 +54,10 @@ static void bdev_write_inode(struct block_device *bdev)
 	while (inode->i_state & I_DIRTY) {
 		spin_unlock(&inode->i_lock);
 		ret = write_inode_now(inode, true);
-		if (ret) {
-			char name[BDEVNAME_SIZE];
-			pr_warn_ratelimited("VFS: Dirty inode writeback failed "
-					    "for block device %s (err=%d).\n",
-					    bdevname(bdev, name), ret);
-		}
+		if (ret)
+			pr_warn_ratelimited(
+	"VFS: Dirty inode writeback failed for block device %pg (err=%d).\n",
+				bdev, ret);
 		spin_lock(&inode->i_lock);
 	}
 	spin_unlock(&inode->i_lock);
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
