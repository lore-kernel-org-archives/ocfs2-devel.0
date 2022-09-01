Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A37BC64991
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 13:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qVpoeu/Rtni6Kk7BYlQj/KCbh2ncdGOujq9oJOtxFrY=;
 b=eiXTfEiAgxVoZ8NekbqvF+E5usW2rIGq8QkQPLnH3Q3jiAE4n6uwYzWFp+qiXnblbmOR61EEoekZ
   m+NDAd3YAoN15on16Sjw10uzbYK3GZdIf5c5JYkOP0Xu8tfxnwNli09rcPmR91aG34rs699O21JQ
   29lZH85hDQhR/1VqUiHQO+xMMwLiwyX2zwNh4XhnpoQIZCzImsfpmyDNITS5Ipjiyj0FZgJBD/tx
   droD4jZfBckArwD1IC1oUsqf2t6kyMqPd+NJ5fXcbiyIGihkVCyCW4x+aR8z+KzeNmzeC1l+t5SN
   jNohnlVtZDqJYluXZ/TTZOEEseIaJGwC7J5WvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qVpoeu/Rtni6Kk7BYlQj/KCbh2ncdGOujq9oJOtxFrY=;
 b=AsYocTJMX3HY4xVRr+UpzbN3YW0M2y7uHCxea99gR7g4HbysYC+wdIG8SSGOSIrRCyD+/cZRrrD1
   6RxXomirOly26a4tH2BTTOEIuJz/LRkh8eYmUszts8yFFc2RmQwN5vCuizyQQmgAyy2bSpstqVl+
   sy650cTJtjtyJn18geOcbu3djTftcdFmmcCOOwaTYPgkfM/9h+gZmhnxsEs587gl9ty09kJP2B3n
   ZG/Qyr+VIP2sLmDTYUvYKC6Gj9PSzz/0U566qZZFLMmunGbwuevV0+oYjo8/PlohjTO42AYKWy4A
   MQqE2VI8FpbHxICJ9vBeqQ1VpmcW6j8qlkJbRQ==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ00L8298X6S90@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 13:24:33 +0000 (GMT)
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <cluster-devel@redhat.com>,
 <ntfs3@lists.linux.dev>, <ocfs2-devel@oss.oracle.com>,
 <reiserfs-devel@vger.kernel.org>, <jack@suse.cz>
Date: Thu, 1 Sep 2022 21:35:01 +0800
Message-id: <20220901133505.2510834-11-yi.zhang@huawei.com>
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
 impostorscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=689
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010060 domainage_hfrom=8269
Cc: axboe@kernel.dk, hch@infradead.org, tytso@mit.edu, agruenba@redhat.com,
 yi.zhang@huawei.com, almaz.alexandrovich@paragon-software.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, rpeterso@redhat.com,
 dushistov@mail.ru, chengzhihao1@huawei.com
Subject: [Ocfs2-devel] [PATCH v2 10/14] udf: replace ll_rw_block()
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
X-Proofpoint-GUID: xUel3bQJhXb2U6Vxe1e6jzBGB-X_dxWe
X-Proofpoint-ORIG-GUID: xUel3bQJhXb2U6Vxe1e6jzBGB-X_dxWe
Reporting-Meta:
 AAFdaXJug+1dphSKhMOHk4yHkC2XCuok5IGn10hvwPVAu7k3Fjitu6OvNzq95dzS
 sRH5H6PXi3O39XnADUKdprNY2px9cni64OeT97hC9Gu6haEIa87YuRoGg46T7MFC
 Tw5BTSLjgowzy90bnUsncfGNVmYTsgDg/JfgkJMPYpOedqejVYmDrAVg3gk7CnAf
 ldDvpHeFTsH+iKThhANmQmYETa5c6crcvGSjiUv5VaVVTWBe/tF9ZDZ1xeGn9WOn
 OS12wGeWB+d5JRVPyKuaWBp+9vx8H9hgsx/1he28ENx2+kIZ/emtfXdCk+AERZLs
 C8yDyUH4zFSGXmmGmE5dZYZ3NL8HHyCtnnp2dZF+0MtqV4hw/OmHIcQsbFjpoOEh
 6Hi7U547A7NKkOYeYkxKdf7uXkOS43HEQR9FCwgkfJLvHnmYyPoRlbtvRjLqAruw
 z4QtPnsqK4ta48knMelRPQKQVpBrlJRDdtuIXKGGwDJ47C3f2+V5iShqYVlYQj/B
 uBqPB68VAK7J9B93mpzfOOLFsJgwSaRji2OgqToiOQ9V

ll_rw_block() is not safe for the sync read path because it cannot
guarantee that submitting read IO if the buffer has been locked. We
could get false positive EIO after wait_on_buffer() if the buffer has
been locked by others. So stop using ll_rw_block(). We also switch to
new bh_readahead_batch() helper for the buffer array readahead path.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/udf/dir.c       | 2 +-
 fs/udf/directory.c | 2 +-
 fs/udf/inode.c     | 8 +-------
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index cad3772f9dbe..be640f4b2f2c 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -130,7 +130,7 @@ static int udf_readdir(struct file *file, struct dir_context *ctx)
 					brelse(tmp);
 			}
 			if (num) {
-				ll_rw_block(REQ_OP_READ | REQ_RAHEAD, num, bha);
+				bh_readahead_batch(num, bha, REQ_RAHEAD);
 				for (i = 0; i < num; i++)
 					brelse(bha[i]);
 			}
diff --git a/fs/udf/directory.c b/fs/udf/directory.c
index a2adf6293093..16bcf2c6b8b3 100644
--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -89,7 +89,7 @@ struct fileIdentDesc *udf_fileident_read(struct inode *dir, loff_t *nf_pos,
 					brelse(tmp);
 			}
 			if (num) {
-				ll_rw_block(REQ_OP_READ | REQ_RAHEAD, num, bha);
+				bh_readahead_batch(num, bha, REQ_RAHEAD);
 				for (i = 0; i < num; i++)
 					brelse(bha[i]);
 			}
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 8d06daed549f..dce6ae9ae306 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1211,13 +1211,7 @@ struct buffer_head *udf_bread(struct inode *inode, udf_pblk_t block,
 	if (!bh)
 		return NULL;
 
-	if (buffer_uptodate(bh))
-		return bh;
-
-	ll_rw_block(REQ_OP_READ, 1, &bh);
-
-	wait_on_buffer(bh);
-	if (buffer_uptodate(bh))
+	if (bh_read(bh, 0) >= 0)
 		return bh;
 
 	brelse(bh);
-- 
2.31.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
