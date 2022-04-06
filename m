Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1493AC433FE
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=L89RZimcUSFAFpjZRW6MixF13hbbMD+UMu/K21dBXks=;
 b=rLKjt67j5CjNZH1qkgKuK4cpRCFAOQkF5NYK6wFbL0tL9VpcQ1jmhjdDebljaYL9/1Vjm9LnK8ha
   sTmqazsZ4oVM8Uk5UA8LbAyPPcEs/z0W+IGbK/C+6WWT55rJjD0bbfinh3HBHla+bW+eh2We2L1/
   Vqs+af+N1I+bC+Fc5QIRVwoo3yQHuHasRWQuf5n3MYDntlPvRAFHWxk/S+kBpPjkv54ntqORXHq3
   E1adRRjyQ7sIM6nQPenYGzUxMzMBK/unktEimjoW/Jw3JH+1tXEJL1ZuK/j/IPKDiONCT5J49rEu
   +R6vfJW+o00DCdkk9XfRBRyTJJKRLOODLFAa2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=L89RZimcUSFAFpjZRW6MixF13hbbMD+UMu/K21dBXks=;
 b=PZNakk2OfJse+08wyiXmNdsVKpxcsBy4DJ/NJamkmvyEyo/NlegYNO4sGf0EqgdMWpgGFoC8iuxg
   KO+b50Zj0jGms/3vr8mj4wzWZUnu0j2ucx5DDMyatYGCucp12mnd/fGNa0CoBir6dIJIgzoB14Mt
   B2vcBB+L++gnLEr1QOAPLdR6CTDkwsxgXfallsnBPi/SQuopwRozL49idma33N0iGTdnhawXSyI7
   yiowJl+HCkgf0y41e0gKqioIRYAKDtiMXGqr6tA3eNXAip0xUdmsIEzmAvabEnQSUZzxYvrRy/yj
   uGV1EGzxplLnNB5GmUM77DXZL4u1+dv64EjSlQ==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W00HI1MAHU4C0@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 06:06:17 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=tRabeefOvFWuX0UGmN5W80/SEitu80or+ujXPxbBifU=; b=AOm4sjiAlP6tD5BDPG+nlvSOnr
 a+eqmQqJ44Gu3hNVff0rp/i9EstWS6YUe61HZmqK+NgAP9RCVrUroq8zVL8cKV3zpQ5XL0vyJlmRK
 NzewYB+71v3WGLpgxvDoCFkqDQNPtIyV060z8fdSvtAa8bXvOhTJAGc1uVeds1Z8SanWEw05KGQ3W
 UFB/Fg7NmKib5Uv9tykTUx2ZTObJAhnLIWQguQ08ldvRIaVpq8BqAf/QlCjLYPeugVNgGqcQ31x4x
 JN/Z3K777fE2OazN7ZPpQSN18xdxSBZinMwtnPgc6nyTQwlijNE+ESpNHGBXjEkXAjangL33mjfc5
 dZArx7ow==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:04:57 +0200
Message-id: <20220406060516.409838-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220406060516.409838-1-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=730
 malwarescore=0 impostorscore=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 priorityscore=30 clxscore=269 lowpriorityscore=0 mlxscore=0
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
Subject: [Ocfs2-devel] [PATCH 08/27] ntfs3: use bdev_logical_block_size	instead
 of open coding it
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
X-Proofpoint-GUID: njGFAlASArgdExSdhuoTDMIyK4thrci2
X-Proofpoint-ORIG-GUID: njGFAlASArgdExSdhuoTDMIyK4thrci2
Reporting-Meta:
 AAEUoxke5xKA2NCJdENT1I1WTAsKhuKnuXeW/o1L/u/UCqtvijQwCGIoX+vhpM2D
 63yyI4vZJVMHWQ09tjLatOhEX6Q24rRIyD+SEOxi2ihNO9uqVf/mzMOtV5t8desa
 iSEaTM4MNfdBw9y8+2gaFzqDOecH9lsdxdDFd1m+rFhOCFj1TfGEG1THT5c2ptSr
 ICV/NaFSaIX9+MLrCl2UtODYVDpNCfc6WEkXRUh5pkmoFTKiR0jZyuIsSnjVWy6M
 Aj/1ZmWr0WIVQKpBajZUhZunZsLbkHCzdLlzwL1Sm7u6iLGsVJLKwRnP8CRw92DP
 k5xBmxJUQvY7vtZOcE5gqLjFxN373UeC1gF7XRWo0oauKWnr3VlFJqDarE5SdPva
 TusSE/x+Z1A3aUsLjRdHVVJxhhfmOTz5uyWMZkVN3knNrLz/gi+s9G1O92Y8y3wA
 6EXjIuLFekNepQsgIi8aBwQqzfkHWfsKmt0lRmRQw8HbxwZESgOYCXMS9lkiHZSv
 hZHlzoL14FiNlAcLtUkvLKJaea2V/CHhgyV+3nN5BVg=

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ntfs3/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 278dcf5024102..cd30e81abbce0 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -920,7 +920,7 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	}
 
 	/* Parse boot. */
-	err = ntfs_init_from_boot(sb, rq ? queue_logical_block_size(rq) : 512,
+	err = ntfs_init_from_boot(sb, bdev_logical_block_size(bdev),
 				  bdev_nr_bytes(bdev));
 	if (err)
 		goto out;
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
