Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F096C0502C
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 13:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4OrNcWlsxYANafIEeCZveKQuj0/uSOzs1nxT23ieFfk=;
 b=HHtbgFoJj6NSivRhfj7oNsjOcvwz7888mVh98lJmHDAiuRGjPyO9dQeW+w1fHWAejFSFMjwb+Tvy
   pntx/HPSoNrGUnLEqwoEXyiWOkIoZLn6dvyZR2Y3dFghsC2fw2ANKF1ZDnN6yPII0I/9dCkzUB3J
   I48Va5O/z31w55uxzSIezBdKH9Mm2iog3vc9+bp1PlnqscqSZGON5xe383wY0pvEHfWPlVyDa1r/
   xZW7ERSWwVCsCR56TSs1qkLZX06s6rIy6k6vdEniEq6ND3V94IliUAtjVHYhbIiZ3glmEgGkdSwS
   kxRJzHQ2OLSPBbm897AGtMFUIiDuMN8S2v8Vcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4OrNcWlsxYANafIEeCZveKQuj0/uSOzs1nxT23ieFfk=;
 b=cilmLdv80/ZTm49FLnhCH22w6Et8ejxyMuAzFatQHcBVt1AVZ0oQaLstyWBe4CO524q7M4JQUDcM
   3ZRnggGNZxdSVjk4eIPgaMNIVJ46InkFrCsl2P48bb6JvN0LIDZySlHkI/AFEyn/HuVQyyr2JdR1
   QXyu+6HzbStadJqwsLrKuICoK1vFdM/cvmVTXc1DAzScyeK9G0k8a7YDiMdSFqnRQunh5DLHMFOL
   b+f9VyBbRgMUpDhcyBUmSRsm3P+2krooG2ZPBWBYKyoewB2Mk7ZtVze39avlldsOSzlpXmiWWxVG
   dMzr7bHbBCPvdm1WwpTeBGUMKLD3QwMyY3LYPw==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ00AKZ98LN6C0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 13:24:21 +0000 (GMT)
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <cluster-devel@redhat.com>,
 <ntfs3@lists.linux.dev>, <ocfs2-devel@oss.oracle.com>,
 <reiserfs-devel@vger.kernel.org>, <jack@suse.cz>
Date: Thu, 1 Sep 2022 21:34:55 +0800
Message-id: <20220901133505.2510834-5-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220901133505.2510834-1-yi.zhang@huawei.com>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.127.227]
X-Source-IP: 45.249.212.188
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=137
 bulkscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=244
 impostorscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=961
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010060 domainage_hfrom=8269
Cc: axboe@kernel.dk, hch@infradead.org, tytso@mit.edu, agruenba@redhat.com,
 yi.zhang@huawei.com, almaz.alexandrovich@paragon-software.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, rpeterso@redhat.com,
 dushistov@mail.ru, chengzhihao1@huawei.com
Subject: [Ocfs2-devel] [PATCH v2 04/14] gfs2: replace ll_rw_block()
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
X-Proofpoint-ORIG-GUID: wQtFhPLHEn05jvm0ZdJB79DMm2X9V3HE
X-Proofpoint-GUID: wQtFhPLHEn05jvm0ZdJB79DMm2X9V3HE
Reporting-Meta:
 AAGNOSAbBHZAfrdVvHQmh19FHgXLyXfOQazCGCzNZCDQwDECEq8NvBJCnWnhi7ZS
 GToP8AVllXFQbklZ3JkQ6+PIAzCDrERl/cyP7oceslkS/O/qckn82R2/rbv3WVcw
 itloj5YGItKqvv3ORURKH7YtVQKXXBprGDoMWfX/A0Wc2ezINqKJa/W+GKe0J+wk
 NBRNUe0w0/TlvcieNx3aXG59HD6L8KTHA3y1LpkoSWdIt/QHeEoJ4l4Pezzeg6nh
 8mdxYJu5D5m2LlAAf1ItvbPEWUs7TJVfTS/SatvtFtfzEeExmu9wY4Z2YbBgyDeN
 F1zY79O+0Sd/puLbQGxGeUwUYtrt09FPxtAmpqlkVCwh6i9ivPfE62N6ON96tmpP
 tYaFjhLzZVvxXghl7ONd6RyHFyWea0yr1Z2cCBAQ1j4e5TCdseqvMu2pE22pHDMS
 9I/oRnoFPrRAgthqLpbNFVMhBSZAzqxdl5TsmYoHaOzImlsOIsmLy7DfJVH5NldX
 r+JYswYQaeby2IOYUepsuQlks0jE2JxZGaom4z/ZTow=

ll_rw_block() is not safe for the sync read path because it cannot
guarantee that always submitting read IO if the buffer has been locked,
so stop using it. We also switch to new bh_readahead() helper for the
readahead path.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/gfs2/meta_io.c | 7 ++-----
 fs/gfs2/quota.c   | 8 ++------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 7e70e0ba5a6c..6ed728aae9a5 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -525,8 +525,7 @@ struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen)
 
 	if (buffer_uptodate(first_bh))
 		goto out;
-	if (!buffer_locked(first_bh))
-		ll_rw_block(REQ_OP_READ | REQ_META | REQ_PRIO, 1, &first_bh);
+	bh_read_nowait(first_bh, REQ_META | REQ_PRIO);
 
 	dblock++;
 	extlen--;
@@ -534,9 +533,7 @@ struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen)
 	while (extlen) {
 		bh = gfs2_getbuf(gl, dblock, CREATE);
 
-		if (!buffer_uptodate(bh) && !buffer_locked(bh))
-			ll_rw_block(REQ_OP_READ | REQ_RAHEAD | REQ_META |
-				    REQ_PRIO, 1, &bh);
+		bh_readahead(bh, REQ_RAHEAD | REQ_META | REQ_PRIO);
 		brelse(bh);
 		dblock++;
 		extlen--;
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index f201eaf59d0d..1ed17226d9ed 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -745,12 +745,8 @@ static int gfs2_write_buf_to_page(struct gfs2_inode *ip, unsigned long index,
 		}
 		if (PageUptodate(page))
 			set_buffer_uptodate(bh);
-		if (!buffer_uptodate(bh)) {
-			ll_rw_block(REQ_OP_READ | REQ_META | REQ_PRIO, 1, &bh);
-			wait_on_buffer(bh);
-			if (!buffer_uptodate(bh))
-				goto unlock_out;
-		}
+		if (bh_read(bh, REQ_META | REQ_PRIO) < 0)
+			goto unlock_out;
 		if (gfs2_is_jdata(ip))
 			gfs2_trans_add_data(ip->i_gl, bh);
 		else
-- 
2.31.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
