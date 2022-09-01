Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3839EECAAD1
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 13:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=b2D7/vIYyzBkrDaKF/hyCf2eaehFqzPv1OPbcMWE1h8=;
 b=VPlN256ESWRZjgyaaGtMsERsGNirNlbk4BbjkYbXCD3jiNBpp4Izthwdpi/QWB2euWK9f3xDWbxI
   VO6no6JTtPyo56Y86qDIe4PGlTmTtwAYrxsL8MLjXCFvDOa1aLBvR5EMDU/g41clOOI55NhLhazh
   PYcBM1d7F2S3DpGoGbH5KCaXx/W6prOXvAFs1V5bJNhz87+7QM++eoGumP4mS5eDmOfj9eq6sLsP
   hByWxNWeDek8rywIr7Tt3qLYS5Wq7beSTbsAwxH+74FXQTfNEEmrJQHOxX3zbresVHHwl5UGRxw1
   M1YP0iqJ6Qa1Vk1mi3047EaPMp3yxWiPPWs2YA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=b2D7/vIYyzBkrDaKF/hyCf2eaehFqzPv1OPbcMWE1h8=;
 b=dT/+VNKLAQ0z/m6iqwVbPMBm1sJGlG9d92hDPymoDsUU/RVCz9Mor726lRGqklLWz0lnkO9uYD4P
   0vrwjUivi2RP9S1w42gHXs3tzQ/RzWIcuIolyRn2I8WDJHWGryjDbvOj2+JZ+TvTG7NUgv/eAYHB
   DnTttiVwgFZipnDoohEef+6IArADelcUGrqrr/l27djdo9NB8GFM6RSv6o+AqXyWi4JI58KUWbyl
   m8ufECli3oXFcK/WCVhhCQqmxFoQqu92TaFaChkLQt65jn0FFfUOpK4PWhwXZwSlD1IKwb8JP8gI
   OuGyGi7NoTmq9H7lgVVnxDPCoFdJMZ+bKtcs+g==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ006RF98STG00@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 13:24:28 +0000 (GMT)
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <cluster-devel@redhat.com>,
 <ntfs3@lists.linux.dev>, <ocfs2-devel@oss.oracle.com>,
 <reiserfs-devel@vger.kernel.org>, <jack@suse.cz>
Date: Thu, 1 Sep 2022 21:35:05 +0800
Message-id: <20220901133505.2510834-15-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220901133505.2510834-1-yi.zhang@huawei.com>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.127.227]
X-Source-IP: 45.249.212.187
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 impostorscore=0 suspectscore=0 clxscore=123 priorityscore=207
 lowpriorityscore=0 mlxlogscore=820 bulkscore=0 mlxscore=0 phishscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010060 domainage_hfrom=8269
Cc: axboe@kernel.dk, hch@infradead.org, tytso@mit.edu, agruenba@redhat.com,
 yi.zhang@huawei.com, almaz.alexandrovich@paragon-software.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, rpeterso@redhat.com,
 dushistov@mail.ru, chengzhihao1@huawei.com
Subject: [Ocfs2-devel] [PATCH v2 14/14] fs/buffer: remove bh_submit_read()
	helper
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
X-ServerName: szxga01-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: pITi41pZmmBjVeoYWtnu7u8OnGBKZ6O6
X-Proofpoint-GUID: pITi41pZmmBjVeoYWtnu7u8OnGBKZ6O6
Reporting-Meta:
 AAGQck1dSvgGil4LAhqtcj2Hy+5Br1LgJrdv5GHsgHLXoFpI9PWWxCEDx6QX8zOv
 FOL+MoFWBW9MwyIQVmvdoFpoWf0p9D5T6DYsB+O/hQqxEvOOirDuI74Q/40uIcf6
 RxKut3LXUwHIABY/kuztVtCmGQYYBrtubsVfAU0KmaiYk+HZ56iX1CI44DVrUNzx
 O+TcMx0YSV6VyCeiOBLxMt0b/MnbuVSiWw8UjJfawYktaatgxvu8+bBogfDiKRY0
 7KL/noEwDYQsis5uRDIEZXiUvGwttoZDdT4KHU05yvQbuVmt6ji1dc3HlJ7anctf
 IcNkM5eUYWFKa2/NwGoNrFeTOM8xUVehvPvY3bZwoIEjfjt/oZvoWU28seTZlSvA
 kH5Qfg1iXG1AokY0/7xsTfvaizS358EFg/3kYpL0aJKyWrBbs3e95Le66l6hcqtS
 eHsnKXyBCaa2KkMyXvAnq7C+imLXKJn1/nCnVjByXDFw/r7wHxvCvZZeR/OHGdtA
 QC5BSE64UraiLZrZ4dcqfx/ysFR6o5/RjxdFWD5Ep06N

bh_submit_read() has no user anymore, just remove it.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 25 -------------------------
 include/linux/buffer_head.h |  1 -
 2 files changed, 26 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 2cccc7586b99..b4c9fff3ab6c 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3025,31 +3025,6 @@ void __bh_read_batch(int nr, struct buffer_head *bhs[],
 }
 EXPORT_SYMBOL(__bh_read_batch);
 
-/**
- * bh_submit_read - Submit a locked buffer for reading
- * @bh: struct buffer_head
- *
- * Returns zero on success and -EIO on error.
- */
-int bh_submit_read(struct buffer_head *bh)
-{
-	BUG_ON(!buffer_locked(bh));
-
-	if (buffer_uptodate(bh)) {
-		unlock_buffer(bh);
-		return 0;
-	}
-
-	get_bh(bh);
-	bh->b_end_io = end_buffer_read_sync;
-	submit_bh(REQ_OP_READ, bh);
-	wait_on_buffer(bh);
-	if (buffer_uptodate(bh))
-		return 0;
-	return -EIO;
-}
-EXPORT_SYMBOL(bh_submit_read);
-
 void __init buffer_init(void)
 {
 	unsigned long nrpages;
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index b415d8bc2a09..9b6556d3f110 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -230,7 +230,6 @@ int submit_bh(blk_opf_t, struct buffer_head *);
 void write_boundary_block(struct block_device *bdev,
 			sector_t bblock, unsigned blocksize);
 int bh_uptodate_or_lock(struct buffer_head *bh);
-int bh_submit_read(struct buffer_head *bh);
 int __bh_read(struct buffer_head *bh, blk_opf_t op_flags, bool wait);
 void __bh_read_batch(int nr, struct buffer_head *bhs[],
 		     blk_opf_t op_flags, bool force_lock);
-- 
2.31.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
