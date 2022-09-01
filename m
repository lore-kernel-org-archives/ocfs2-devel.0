Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDC77C67868
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 13:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sVDY+Vx/Ikd6g06gydbDCurhGwPJjk8SpcaiuVHLYRI=;
 b=rrGZhg9CtG2RcYcEcW2UAuWIbOG0DMTnrEA2FH+soAgIaOfZdNOK3+MFXhgDclKwXIR90mSTU+6k
   xUBTp6zFJHBa04m4/IPxVrD6QKGILXv7EwV7ZJxXcsSch7CroP4k6s4XvheuhIixpBu7RzqTeD42
   4//S/KB/ND+q6coHPr/37U7hRyysSkyK47mpcMXPJYmy6bTJ2Qs36xwH9NGl0x67i/aPvWqTWbod
   K/Xqd4imorvB2XiQwxaw/EPHmxrvl9snkYl4C2xCSKMZm2Ry66OgE+XtlYyyQdmyqLaxHjw74QrE
   1coGD7TYgcW25xBpo86nyjHq8rZALFOPF4uUkA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sVDY+Vx/Ikd6g06gydbDCurhGwPJjk8SpcaiuVHLYRI=;
 b=Nb6+crV4sONEceZ+gJ4q8C0PjjWuIN8hU4ErJczFQh1qRnN/HB9ykJIzizewnpX1UtIf+dZflfPd
   wwmG3LTYlB6ZbcikmygYhXkJQsABKf2/te9IKD4PsF3MfTw5JYghubNwZylCLXhwkw52DaIfVS2Q
   i5TsCeg8CZ866Oof2ywhBWZxhd9kPQPhP8skaDVcbEaEEiXZgZiLqrtjieMoftpYIII5nbQWMiVv
   0n4OsRQlJDTd9AqSwVPvOGxtHy7bYSXmYxBDdn7jKM2VLJHPyojbeyfKUORC0sRowsxbmx1galiG
   wb7g8xa2j/WLKSaNec/bxzbTH4Sv9z329UIvfg==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ00KT298MOB90@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 13:24:22 +0000 (GMT)
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <cluster-devel@redhat.com>,
 <ntfs3@lists.linux.dev>, <ocfs2-devel@oss.oracle.com>,
 <reiserfs-devel@vger.kernel.org>, <jack@suse.cz>
Date: Thu, 1 Sep 2022 21:35:02 +0800
Message-id: <20220901133505.2510834-12-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220901133505.2510834-1-yi.zhang@huawei.com>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.127.227]
X-Source-IP: 45.249.212.187
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 mlxlogscore=904
 spamscore=0 clxscore=138 mlxscore=0 priorityscore=244 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010060 domainage_hfrom=8269
Cc: axboe@kernel.dk, hch@infradead.org, tytso@mit.edu, agruenba@redhat.com,
 yi.zhang@huawei.com, almaz.alexandrovich@paragon-software.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, rpeterso@redhat.com,
 dushistov@mail.ru, chengzhihao1@huawei.com
Subject: [Ocfs2-devel] [PATCH v2 11/14] ufs: replace ll_rw_block()
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
X-Proofpoint-ORIG-GUID: _ni-NyigUww1Q9IASoPRPT733NgpzSPq
X-Proofpoint-GUID: _ni-NyigUww1Q9IASoPRPT733NgpzSPq
Reporting-Meta:
 AAEvsXxrkCYpKGbRnx3zhEdDS91cssipNXFIGGd1HXl6fVd1DyjQSXTlMaaN51aK
 onUneFj1a5RWMIkFwivfnLKRJwJCCAoXtkCSmPTG8A2GCnkwc9Ej7H6MUa88fpeG
 O4DaRVbGKFsMkXAO/aQYuWFkduwl3N9SiYluMxtQcV0QP/KRiJ/6l/tppGZcPLfq
 TWziE1+zbMq+Pb+qK0f6z9q9AdUo4D4wzd1DynbTxCITVr19fsh47L6Sth2U/pR+
 ZAmX+7P4L6xZGYmh/s4npwxKUbRKArjPIJBLicVJ1eCV2x37OHRw0WprYEMXUD/D
 AGxPLSxUwLBV0zuy3uqsnSRUF4x3MFxIDf/J9JG2G82Ajq/84boe4jmwi3tfi+CE
 75S2DpoG+J+ULLC9L6iz5nDQiZPRHb0NJC72BQDHB/opoE+615LQPjuzY9wDaJfq
 TzMMA9LvOWa0uq75kxxE+a1Mtk2Nr7cPI4/K5+MF0xaL/assRePCBXD/UnH1e03W
 LOvpPr+9/xZOUY1cG8fTmqCs4Lw9gf1QODp2xBFqX38t

ll_rw_block() is not safe for the sync read path because it cannot
guarantee that submitting read IO if the buffer has been locked. We
could get false positive EIO after wait_on_buffer() if the buffer has
been locked by others. So stop using ll_rw_block() in ufs.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ufs/balloc.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index bd810d8239f2..2436e3f82147 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -295,14 +295,10 @@ static void ufs_change_blocknr(struct inode *inode, sector_t beg,
 
 			if (!buffer_mapped(bh))
 					map_bh(bh, inode->i_sb, oldb + pos);
-			if (!buffer_uptodate(bh)) {
-				ll_rw_block(REQ_OP_READ, 1, &bh);
-				wait_on_buffer(bh);
-				if (!buffer_uptodate(bh)) {
-					ufs_error(inode->i_sb, __func__,
-						  "read of block failed\n");
-					break;
-				}
+			if (bh_read(bh, 0) < 0) {
+				ufs_error(inode->i_sb, __func__,
+					  "read of block failed\n");
+				break;
 			}
 
 			UFSD(" change from %llu to %llu, pos %u\n",
-- 
2.31.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
