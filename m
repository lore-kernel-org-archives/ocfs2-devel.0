Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 450B3ECAAD1
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 13:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hyDlGBdRidwf+m/lNOr+vaBoawrzDx3ENhg0E+Lc4Iw=;
 b=KDEIy3O3Vykg8+8WBZP5E5TMx4m0q0cWH6XuoVIcgqNfk1Q3C7H0q3VIB6mpeaabCAwEfl9yP5No
   1k4rQjgixM1At0Kx/55baQZxd9NGy+waQ3jhiNduKl1Zt10p7TuTxEIvjnm8rBwldOrDtVLtv0y2
   s1vcyK+7erK4uw17dsadmM/RDZ8wWSeV06ZQkHBiJs5SMTg2hOru70TTXFtTKLvIWLyN6cAHc8cs
   U9bt6ZivoIozth30N59ShRosnGmyqFMdtrwSFn/UpZk3zsrQc4cE9djFQBZIEk2Hbz0F/MbKnAGZ
   7mcoG+eV83WWvKXlp1xunopqLiaJhSoavK2HKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hyDlGBdRidwf+m/lNOr+vaBoawrzDx3ENhg0E+Lc4Iw=;
 b=mrdlpVXL3TFoxwmp570GARoKaSOs5l7Mt3NqBfSpnLR7w1bSl6tJqQNZfK915YTdTe27CC6uVPQ2
   HQypC3SM5LNHXAlbOr6fTGZW0EXTCBj3LfyzXXvEsBZ6gvE4zKacC+pDdYtnaf4KQdKYUxGZ7KqL
   mKJruGgj5S0GRmGh2UxC6w/PLCWkr+R+Hq9p4BnjO0lxLo0678l+1SpbEMIp9dmwfGaottIEh2Ww
   N9J3x1lW/jW2yJ6VImzQ3IpJ84dwMJgBJqjefpUSQ10TzqMlIXUFA6TN/h7me81NZE7yHCB8IYcL
   moaCvWXVjYdtEtKvhjCcNBtgOsf3TCxx7R8CwA==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ006SZ98WTG00@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 13:24:32 +0000 (GMT)
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <cluster-devel@redhat.com>,
 <ntfs3@lists.linux.dev>, <ocfs2-devel@oss.oracle.com>,
 <reiserfs-devel@vger.kernel.org>, <jack@suse.cz>
Date: Thu, 1 Sep 2022 21:35:04 +0800
Message-id: <20220901133505.2510834-14-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220901133505.2510834-1-yi.zhang@huawei.com>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.127.227]
X-Source-IP: 45.249.212.189
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=138
 bulkscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=244
 impostorscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=914
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010060 domainage_hfrom=8269
Cc: axboe@kernel.dk, hch@infradead.org, tytso@mit.edu, agruenba@redhat.com,
 yi.zhang@huawei.com, almaz.alexandrovich@paragon-software.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, rpeterso@redhat.com,
 dushistov@mail.ru, chengzhihao1@huawei.com
Subject: [Ocfs2-devel] [PATCH v2 13/14] ext2: replace bh_submit_read()	helper
 with bh_read_locked()
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
X-ServerName: szxga03-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: Y74eo9SaY-RSeDkhma3wokN_x37HANHS
X-Proofpoint-GUID: Y74eo9SaY-RSeDkhma3wokN_x37HANHS
Reporting-Meta:
 AAGsrZJKzDFQ9B9qbMleSJLV4kL2+Qe2JkqimM4H46YGgyoIoZ1RosoSOqKKgS2H
 Wy/wZuv0iy2H71roir5aPUDG87NpZ8mgyWe90AL5VwOi8ihXIdfGdQiEZbtZ6oE1
 OG33BKSFjDBMx1TzaHWoFAX139Vm93Y0Wp4SzYDgva149OEOWvkNgyKAuJffN0gV
 hMTARm7O5yVMy7qz02gHlT0op83lWQ9B+mer8ec315sDObBcIjiIpTDtr/uIMob7
 hy7u69MheFwSjpCo0LcIP4sw42i+NwcLDvTl5Nn6cT8kIQhE0j+ncZRd6P6co3zB
 SnIZSsU4sOfACuid9fCPB2M7315TwJ9QTxbWusp7+eVnv9wmyktQsacZ/1ABdhlJ
 rw/yjVcnarWBOrfuBC7pKXVQPkuZHW1bB064sf3Az34B9Ckv9wg4QMdfUs2Lcy3d
 3YOJZwHnZVkAGJpnlzMWziemJ89AFoqDTlSaXHdB9q4Aaa5sMDGjwFJnwA3kRSn2
 toAe1ZsBnfiZAnxEGEL30DvMkTxfC1JIh2eV7lwaK9xn

bh_submit_read() and the uptodate check logic in bh_uptodate_or_lock()
has been integrated in bh_read() helper, so switch to use it directly.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext2/balloc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index c17ccc19b938..5dc0a31f4a08 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -126,6 +126,7 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 	struct ext2_group_desc * desc;
 	struct buffer_head * bh = NULL;
 	ext2_fsblk_t bitmap_blk;
+	int ret;
 
 	desc = ext2_get_group_desc(sb, block_group, NULL);
 	if (!desc)
@@ -139,10 +140,10 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
 		return NULL;
 	}
-	if (likely(bh_uptodate_or_lock(bh)))
+	ret = bh_read(bh, 0);
+	if (ret > 0)
 		return bh;
-
-	if (bh_submit_read(bh) < 0) {
+	if (ret < 0) {
 		brelse(bh);
 		ext2_error(sb, __func__,
 			    "Cannot read block bitmap - "
-- 
2.31.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
