Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5A81C4332F
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=fe+hvVzCklcthVYoUqiEJl4iMblJmE809JahV6eW+eE=;
 b=exdc91Hw2wksVJeepSrju/abpf/BYKGbmSPqrrz+eUTzTNz+9Unehxtt0t/ach/1VdgWyEZiZSWS
   J4fDNQdlfeitO2Kc6SKMMaFTheieOU+cNlLy9ITYEY4GPi+FUUPxbjejz8iUsvWFTM2re6kRqlS6
   ohrNefUb3mH/kTAOpRnpKS1z+58p21r4L8mpBzhf/b/kcvYhVTFIs73kw5iSNZ+0qXr/pSpNs8aE
   bxVmK0dh780vpNWelkmgWEja/Eb2220a84gtQ/xRhpxRu612x9/ILIDHUE61khofUyv83KGVLYgR
   AFWIXY/BcnS4+FlN5Pe0iiiOMfJHQOPqctL2cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=fe+hvVzCklcthVYoUqiEJl4iMblJmE809JahV6eW+eE=;
 b=AFeryPkDz59pdeiiBuoBevo2dkTzvjO5dHQPtH+iE9P4Qh9fOOAS4PeLSb6IDznmbQDalnzagv/U
   5uBVzDOS8yVdh/2Q8YfyFXDIQCR7llTn1WfkDGoPyx8RgczaJiXuJefQgngopf9es+8hOaQbVgDB
   JTbFzWwsknSAWRyfzgL+oVgLcbA45b9xIdXoZIe5XfkZ1YbqtS7MwAux43KwRaODbc10MxwPZao9
   1+lFqYolyrV04tASj9oFwUUYjMREiQYKo619oDr1P6suMYpw3Ad+ASbtYVjbnYNsvQa3Ju1QJTAT
   wObH1BH7XaGB5luU19cWd0YFDeK0M1/Y1j/R0Q==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W00HEEM9ZU4C0@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 06:05:59 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=sINtR+pRAAWqBCMZRslKVJyakyubEJXVW4tI3wGLsb0=; b=gBrZsvegbTHoIEG5qdijcHzNWW
 PfzclL3zzl2tB5xhm8Sj7w6skVV8SvvJytC4EH0RoMlbB62c3vMVvjooDHTIWQ3smYKaAuMQ4cOli
 spZhkrdfcyNNrOGeIUuTpGtX63bYCgqfiIr52xJMA9AGK42nQUGH/2eHVQ3foGEH/zFa8lWfGs7Pp
 Ay5KyAHLP9DhsOCOpCtbHRVbRjzyQdYUTq4TkVLaYR9+Sga+ljLLLtQo5Hukpu2Q5UAw6RMQTfLQg
 vt8zwwfekDfQOHpKLK7/INfKF40CQ8temfgKOOdrhB506dWycfStoRSbi1wi6owABwmVkNNzYqcsL
 kVwVOMFA==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:04:50 +0200
Message-id: <20220406060516.409838-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220406060516.409838-1-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=825
 malwarescore=0 impostorscore=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 priorityscore=90 clxscore=347 lowpriorityscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: [Ocfs2-devel] [PATCH 01/27] target: remove an incorrect unmap	zeroes
 data deduction
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
X-Proofpoint-GUID: 5xJ_iSnX0z4iuUcBtfqeOelkVqBMkeTn
X-Proofpoint-ORIG-GUID: 5xJ_iSnX0z4iuUcBtfqeOelkVqBMkeTn
Reporting-Meta:
 AAEaKWhG9lXDenwEx7H4q3zjefPW8eX36bLklhMblUJt+nyynfoHQKz7GxJyIeU/
 idSobG+N5R5kBc3YOTaz/4J4PQM+ddEEdueE+FBAiBzYxYHW9VJ3MQ1GX2dxZrZx
 Dmpf7lDxfMzIlfB3uARXwN60F/T5/0t7ekkTMiXMpkGF3O/ywBpeTG46DQ6Ih3dH
 7DVUm+ERMVed2G0ffvEAj+jCTRMPdWS5EmPx2NJUYyj1zVodNaA/7TC6dKHjgbXO
 CVfH4D5UNoV7q3rKpZJNb3ACtK0YDYIwnl7IwzoT3ZZVKQQCQRRbzPbP+1k8p78f
 oGRxd7G7UaE1niY5j02/ok2wjxR3xyL/qDXcgOSbxavoqjG21QG68vFoIKoTF/Q4
 2zFv9IVEC4nYLV2lb1NiQ+NmBgQvN7YSIYNSRFkdmwpqeWtnEUlADZgAzUkX5EUp
 eCwnPmj8n3zSSOAZKahTncjlN/FF+D1TNnwIAp0Ouv9KI3s98XDk82JjXXOL0CSQ
 q/UX8EFc+gd3Vr2HIbdk1eEeQVLSaIsgja91M1EV5SKj

For block devices the target code implements UNMAP as calls to
blkdev_issue_discard, which does not guarantee zeroing just because
Write Zeroes is supported.

Note that this does not affect the file backed path which uses
fallocate to punch holes.

Fixes: 2237498f0b5c ("target/iblock: Convert WRITE_SAME to blkdev_issue_zeroout")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_device.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 44bb380e7390c..fa866acef5bb2 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -850,7 +850,6 @@ bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
 	attrib->unmap_granularity = q->limits.discard_granularity / block_size;
 	attrib->unmap_granularity_alignment = q->limits.discard_alignment /
 								block_size;
-	attrib->unmap_zeroes_data = !!(q->limits.max_write_zeroes_sectors);
 	return true;
 }
 EXPORT_SYMBOL(target_configure_unmap_from_queue);
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
