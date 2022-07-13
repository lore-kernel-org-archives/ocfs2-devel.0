Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48C49C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Jul 2022 17:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cR/a5UzeZDIatNLV/t+yebmFHXMM38TJpdYix15vBbE=;
 b=qG5f+IVzhpJ4h7HfQJNpKP+g1uRD7lHJp/4x0HZJyURvrQBvxYdD9onygfOlfkaMPyiu+LsK0EET
   Qp/mJxCNQt/GNPxKJfiS07rHlj0GLIiEDvDPlkokJpaokottL4xVsppHh9gWtCzApnRS1oK1avRF
   +8BDNbQ6gXlPxdHrHCJsRdmD52mQT/B+va9cWKP+Mnd7i6wFG0St7K6dA5a+h1WXqF90G7c0Rno/
   CLLgpirmI6td9YtnBKXFwuYeRO11oYQA33UI4/BrrAvclLYT1+ISsRmHz1PXFS/VkiE+vZB5lcdA
   PldapTG5dzLbAanHhWPMygD5ANTMfsQneYfkhw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cR/a5UzeZDIatNLV/t+yebmFHXMM38TJpdYix15vBbE=;
 b=VX2REjMj6ff1cmm+PlHv8HlHXjzgga2jheK72oUceARfhRt2z88EgudCuwrB5LmuLCE3ShL3HsT+
   6n8OYAUMKkiXj8eWUNWiVHm099RKJsIfCzAQw/P5Gy8rhcS3HqsT6U+VCmBj4FuIKaYs/mc5++Ym
   1kZeYLvameyPK/rU+bI58aGWtykgxUvDU0xJdunCeRPo06+ES5Ueff9o/VucjxNdVUeIcRVCSLJF
   zgw3HeIpT50qR+Xxiznxt8Qdynd5UNlIyi0QFcFx5+ktzKYrIe/Y7f+WWO5lmSn3C/O6sFC+xMZJ
   cEYaOdB686LiaiuP40ylTiRY8+2hxTOtMGtizw==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220603 64bit (built Jun  3
 2022))
 with ESMTPS id <0REY00F39Y13Q7E0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 13 Jul 2022 17:03:03 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=20fYCpa6V6Ap10mEOQh3cL90/z7nSmsIewaP84vytaE=; b=qh0sF5wn2Ta7HQYLFlY/P/Q9Wi
 DS2ijefXpSBdkMRpGE9Xk4pb6JYtV2a3YEQtifKPjKehtbR6ZvnECB9ae8ReP2XIadd8BoIMUsgwv
 8yjoGchrDeEgcwI9LNlYEKD1U6bj16k1Ha8HxlK5UrRBqbSo7xJEYeen35qZ9zzFDFe/jv2yZwMtS
 hI1ykmF+ndaa1FvAd0SZcSbb7CcwoVicWCK915yEKaJFEgPS7XM+KzrdcPqjCz9HPCJi3u8Hj+RAr
 M5AVOo+lJIjwhmLkaBi87rz7EH6i8wgeIjc+GTplUECFn0Diq3CizjrqPhTdnsXn1/eCIGeNWVM4u
 iXwU2e5Q==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 13 Jul 2022 07:53:11 +0200
Message-id: <20220713055317.1888500-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220713055317.1888500-1-hch@lst.de>
References: <20220713055317.1888500-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10406
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=669
 clxscore=256 lowpriorityscore=0 suspectscore=0 spamscore=0 phishscore=0
 malwarescore=0 priorityscore=0 adultscore=0 mlxscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130023
Cc: linux-block@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>, linux-ext4@vger.kernel.org,
 Jack Wang <jinpu.wang@ionos.com>, ocfs2-devel@oss.oracle.com,
 drbd-dev@lists.linbit.com
Subject: [Ocfs2-devel] [PATCH 3/9] drbd: stop using bdevname in
	drbd_report_io_error
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
X-Proofpoint-GUID: ce3xlWezBfoPkZAY0czvoczFa44nk9ks
X-Proofpoint-ORIG-GUID: ce3xlWezBfoPkZAY0czvoczFa44nk9ks
Reporting-Meta:
 AAFi3VJI9wI72GOSjmUPwJoFdwdV3ps2EUHTyB9mo5BXfV1Td52x7NnPSjQojmKc
 agnqmx3KHgIYczBJra2ui2xBHlGE5hzPgD4mi5zQqRRFJncEgSIpRJ1ldq8agghE
 HB7dkN9Bus60N9EFbYohdZasvDMCfIVwaAd7HQpeRINHfkf+TQlvNw80KLTbi+wR
 0xFVLfXu+nz6vys8l6CumkpenM0BgBd6SZAqRslqRf+JItPug9PgNjMHbmeGfIn8
 DAMJ36ACG5mRNshbAYHxAJpfqoxy7CJAhnyGq/ODKPFFX/y+HtPSf/GoZuDRMGbV
 67FJ0c881bCUenWgibsnfx/QTLe24ko73majjKSNQ9/+hCJdmK8SOyC5DXO/G+7x
 UOR1kun5b6WwpZapM/HdTBJqHa0GB2mqwa4SWtrXAZmcsm8Cgy+ous4wGRNPc73/
 ysls25sUx6X3LtIby5gL0JXP9TjfqkkCyJDu/73u+TdZeNbqRugzGQI2fbk6JnzY
 5StrEXDuTtQ+3crh/hqBsEsAAAYYHS9tWYzXI28Mb5A=

Just use the %pg format specifier instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_req.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index e64bcfba30ef3..6d8dd14458c69 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -523,16 +523,14 @@ static void mod_rq_state(struct drbd_request *req, struct bio_and_error *m,
 
 static void drbd_report_io_error(struct drbd_device *device, struct drbd_request *req)
 {
-        char b[BDEVNAME_SIZE];
-
 	if (!__ratelimit(&drbd_ratelimit_state))
 		return;
 
-	drbd_warn(device, "local %s IO error sector %llu+%u on %s\n",
+	drbd_warn(device, "local %s IO error sector %llu+%u on %pg\n",
 			(req->rq_state & RQ_WRITE) ? "WRITE" : "READ",
 			(unsigned long long)req->i.sector,
 			req->i.size >> 9,
-			bdevname(device->ldev->backing_bdev, b));
+			device->ldev->backing_bdev);
 }
 
 /* Helper for HANDED_OVER_TO_NETWORK.
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
