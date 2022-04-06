Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86D13C433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XMpTd6EcDFCPHcPN2dAnn5z0caEEhbWe/e4xRY7zZBs=;
 b=dyOK+KkVoEc/XVA/ILZ+kYY1/11GfmcdfHbw+O+z/A6AjELPR1adr82W8j3k7QsKPS8c2B7d459O
   8Sw+o3OFyT1vkhk4O/mN62Lul3lf88NFeZKoWGvEhYlyVT7A4N7M2hDvL19smnTbBKThkweTznXz
   Du3Jz/S3S6qeFhLpgDB69tMPC/A21f/8PRNYc9lOz6jTZtQwxMlaqA04HAfwtP6kwtvb/EjqTydZ
   ohlvrRmp6og05wzYM7smjKZPhjoKOV7q01GIm182XWkBiuTcvr6/1OmB8Jo7LpUpdgvyN5b27PJt
   eJPNzxIIlgmUIDjbEownxldzLFsExg0S+q1O2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XMpTd6EcDFCPHcPN2dAnn5z0caEEhbWe/e4xRY7zZBs=;
 b=QTu0QriTw7xWn7W2oBAEWvfBVcD2VlfieP9My2czlG7VO0Q2oMY2Jtm8fyYyh0d/unHPVLHGtpKu
   ArvS1Rjut8sy3II1h59rto/oOWRWYfP5+232P7bFgbxnfAA6cdeFVOo4btayK7y+XPGnQUI2v1Ys
   jj0kns9DmXTiX+R9Jimgn1sz/GlG5Isrv/CQ0Fh1CT/j+I6DlTfxYPlyiXbdfbMcKcsrZAvyIwOx
   ovEAjF1KmXgMg7ZrDQVKo8BV4r+DTZBr+Sj8GfgEzHG/96LuIYHmJF9Jx7dweeD/VaoTDpQrmiom
   K95hbfBmubszuGI+8Ahjzk2Xsa1Dn76ojML6uQ==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W00HMZMC5EN80@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 06:07:17 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=CCltYPwX8bAZQe3AOk2m+rVDM7liIR3xNyzg1pXv0K0=; b=4TnTrIex1AKKiPJXvaroOl5NsO
 OzcWSzfXydGQ7sMSzqVfjOmk1ov20W68jFz/hoIp8KbrlPpu8lOR0RmwZOsnPUBGCBW4nbEfepwlx
 ixJCSn8kR9jF/OB/YqPXuT/Tf2/M2YFkGZURh32PQbKaAFcnpj0qHFwtp/IhfWUpj2AYdMqL9Ifl+
 fDz79wz6V7QzwBw5LdMYuYetJWMtaHY/wl6mSxp52+xJQuaG7/Bxjmh7/uJ27qQAc+7vRgBb+R4FM
 D+LA3q8ztCpOto8AlmQwIjNAmnOYhlBfzF+75JNxW+D6qQTHDF7hKZpFPjkT6eoCIq5LWTogd+SSJ
 IWO/dQrQ==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:05:09 +0200
Message-id: <20220406060516.409838-21-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220406060516.409838-1-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 clxscore=291 priorityscore=0 mlxlogscore=476 phishscore=0 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060026
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 linux-um@lists.infradead.org, nbd@other.debian.org,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 20/27] block: use bdev_discard_alignment in
	part_discard_alignment_show
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
X-Proofpoint-ORIG-GUID: JirZs7bu47bMgu-5Wz-JbtEtpYFxtg9g
X-Proofpoint-GUID: JirZs7bu47bMgu-5Wz-JbtEtpYFxtg9g
Reporting-Meta:
 AAESXCyu5G+oWT7tOzMMlshTBBBU3IH9TcYRfenjQhh9dLJhrFT36KXfG8cXThvw
 A9z6bY2a7YL+7ykSQU+JJ6eXrqrY4/gSjFLFBzrd2KsnrZIJygJpvvZ1vFWWuVQq
 G3acCvBsAcdB8J2YdNmNf/ymQcx/dsCO5n46YOXx5MPiH6bvvI6O8qg3GYx2m9DU
 EkWqlqhyJqMf9kOYEJvvrBMPxDEXSyRgSS1j8QbxRUzZqy8zNrUg6D3tLC9dcMrH
 CB1IlLWgYCfH0oVGXAzylysH91oePgUTRpuaMSqm2Rcfs8WCbBKJjLd1Gkm/AoEu
 g+hO0h2/QGl+IloIvH6WkmZsBjc7jIz8VOlB7GAMerSNE4q047XvRqJsDsEEmiZl
 V7P9S1J859RRXOHkxXvMeB9/jLZL8XLH6H5V+UUUn2OForaEG7u7z2Zats7V6qh5
 JNib0J6nHCekYf6pNchffsKq7BEl+3wQP10MALG0bWl0HRPUofHRb5+ZPTI1uUpT
 Gb27HLbh5kKb7nTarqjYKdUgw2+wIzTgyMGPB3Y1cA==

Use the bdev based alignment helper instead of open coding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/partitions/core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/block/partitions/core.c b/block/partitions/core.c
index 240b3fff521e4..70dec1c78521d 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -206,11 +206,7 @@ static ssize_t part_alignment_offset_show(struct device *dev,
 static ssize_t part_discard_alignment_show(struct device *dev,
 					   struct device_attribute *attr, char *buf)
 {
-	struct block_device *bdev = dev_to_bdev(dev);
-
-	return sprintf(buf, "%u\n",
-		queue_limit_discard_alignment(&bdev_get_queue(bdev)->limits,
-				bdev->bd_start_sect));
+	return sprintf(buf, "%u\n", bdev_discard_alignment(dev_to_bdev(dev)));
 }
 
 static DEVICE_ATTR(partition, 0444, part_partition_show, NULL);
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
