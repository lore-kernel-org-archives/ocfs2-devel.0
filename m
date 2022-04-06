Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B14EC433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cAQhCwe0Q6aZjCbLkzU2pFyGPGbbjfTzDU/vwx3kJlw=;
 b=sbMp371CLgM/vVhnBy328BzimUrJuUJ+uJySXcAm/WTU4cyPaluFB2jgglSu7OBanWM3gWlVuNJI
   vw7IHKSFrZVPIYSjthi4fdFXHvzQXavuxU+sOZZNm6FzeBBCgbSfmzv4qKwer5rdOSAbg9qpyGmk
   qCzB0Ayiw/q7CR74jdWFeYzX7QVfa9lI9aVZQoI5uwbRk7PdwBrvHEMl2PhGI8exdxKjKsgBYE23
   5xy4YA0OtdwRvaXFoCvjvDb1A27NRZj5hVOaBfEw6MhCeOxFEIo6VbD/4oRgKscz2E0pdY/m/ROI
   MGcF92i8iy3QqFJXqs2LqEZS2gmYNybsqN7fHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cAQhCwe0Q6aZjCbLkzU2pFyGPGbbjfTzDU/vwx3kJlw=;
 b=I4TWvC18LMwQIs/dMGs9+sVx0Oc5/47h+EgCL7ur8Wl+a66g5bugkrggekO1/ISexO7c1sL8iSia
   bcbyZe5hoMkYSbzsE+PSaPY+NtayTYx/Iaq3vvp/kqEc82YWkZXgaimT35OSPCTDqGgiwsi7l2si
   /92cYhuCqRdQt22zJkq/6xheukCFVIAIlAk5CsYXEIMmDrggCSXQc5+QyCQ3mkryXYnEQ5EVEG7R
   behp7D1KT+W5mWgGVO2nX78KdrzLYCACFXLSLzXKF6M/H3Tza5L9ynsqkBC6dhjI8avBrmp2+iY1
   U7YcnCxg5jn2WGm9tO4D0zMQgTslp8qTE8kQfw==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W00IOTMB82A30@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 06:06:44 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=Z466ZFUUKBaH6hbYD0HK+8FHR1O7bsGB8sNIWBFJhOk=; b=nZyFe69pq6eqf1/kF5nMPTOAne
 TDtMwcoIcF1YVH8vK4pZn8SWXmvAy4dj0YLO+u7/f/B2HIjYkBtn4UJ8NiskaBRp3fwS47roOcVRe
 vLIrpgEvmwBi0TgLuCY4ho1EAziykjm9zmNebUkK6neSzMI32Ao85X2VP0v0J3+9ko5w3milUn2Og
 nHnr9afoa38HHNP14nGQNi1dlupB12CTU0omTrFBjKA0bBmskFyATPVPaofHC89rc0iWDgo4hGjmw
 mUDsTYktHm80+vK4Z5OqBaEmEbibKoSEKtnP9u44j73GVKdSFe+O7hLNHxfOqHQlf6RzKBjJvj/fx
 be/fnxdQ==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:05:04 +0200
Message-id: <20220406060516.409838-16-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220406060516.409838-1-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 priorityscore=78 clxscore=265 impostorscore=0 malwarescore=0 mlxlogscore=705
 spamscore=0 phishscore=0 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: [Ocfs2-devel] [PATCH 15/27] block: use bdev_alignment_offset in
	part_alignment_offset_show
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
X-Proofpoint-ORIG-GUID: S9nGgChww_-cwywcbUT7qUny0LCeCjos
X-Proofpoint-GUID: S9nGgChww_-cwywcbUT7qUny0LCeCjos
Reporting-Meta:
 AAEMiZQyB2nmggqKM8GFO9IC6N6vCzuxVeXaLDwvm2qtOCZ1r+FNJg+nOGCORhzu
 nQ/DuXoia206T2kmjM0Ahh0aw5qV4JysrWsaUXuZGSELU6s740bAYIhU4vvJQaG5
 pjhgimNoXlXroErMUco/7BfSEoxv6FCwnY5AYKRtz02BeXTOpofleFzqN+ybHtCm
 HlqxmIuA4if/C3dXBQ10Tp/Os9NJSNg/z9+ThSrEmbJbpiMG81YF38dSfzfIecIa
 NIr8yCdiDyTsJXRW4omn3B9dhPCyS9zBj7j/gaI4Pdg4sRyUVaPdSWbBLtJqIadD
 Z/YGx0BrrQKpJ5NarEa3yPCrGE6gvBiBT/TLGIX8GADL2ZZQIDgHoZAcbWKEmXAn
 dsGoRSJ7oo/Msd+hKvJo1NTICQtOAiT/MFm98i9iiUbUqV2d31OQXo3ZwSUH4XR9
 j5CowDv7PAsAq+g5G5iBsJTY0Jd2lrS4/3NzQD6GAX6m1gQQmCWeSohSqcrVlLkX
 4TEka/NG42MPlEB8eojTrafpUnISg1mEqf2b1WsMNerO

Replace the open coded offset calculation with the proper helper.
This is an ABI change in that the -1 for a misaligned partition is
properly propagated, which can be considered a bug fix and maches
what is done on the whole device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/partitions/core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/block/partitions/core.c b/block/partitions/core.c
index 2ef8dfa1e5c85..240b3fff521e4 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -200,11 +200,7 @@ static ssize_t part_ro_show(struct device *dev,
 static ssize_t part_alignment_offset_show(struct device *dev,
 					  struct device_attribute *attr, char *buf)
 {
-	struct block_device *bdev = dev_to_bdev(dev);
-
-	return sprintf(buf, "%u\n",
-		queue_limit_alignment_offset(&bdev_get_queue(bdev)->limits,
-				bdev->bd_start_sect));
+	return sprintf(buf, "%u\n", bdev_alignment_offset(dev_to_bdev(dev)));
 }
 
 static ssize_t part_discard_alignment_show(struct device *dev,
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
