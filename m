Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E63C3C54EE9
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 13:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=zzI0gP26ea96Q5IJDXOrP0UxV/GWQmexJipTYVd2zcI=;
 b=EBUx16h+f6UnGen5RPBsykJhRtXGi+TlfuC4RAZXIvLl3UlyLTEVH2y/JUzru0DSjrW8Cy8ty5Gf
   /pKMpqiY4af+Q7yq4GVbWNHb6yyxqIK0246LjaZtomfA6cc0gAWDDgUUm/ScUVDk4A03LMuYyNh0
   tG3BaT8w9d4wieVcBf8QRCZXJXRHIa10fP38adeyu600GFQWJn8QPyIeafQea4OgVzvi4+wdiNcm
   9GF+lrgSr4yHmOlkU2wwYcKx7tQHP6eg9UE4C+pbOm0SiOAgnP/TzrNOIfNoop+MLBUDjIF/OrC3
   R1d/+0LdlQxK2O06yV27RDUvdzf8RBr5oTjlKw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=zzI0gP26ea96Q5IJDXOrP0UxV/GWQmexJipTYVd2zcI=;
 b=TVYJazN4b78S+be4gCZWC9UuHpBPjzzAIVSidJL+YJCzLlMI+4KKQzZHZYeYO80N2TGInDQKN4VP
   Y03y8/m5pLqXPvEvumAy9fDu5dpYvWfQDLoxrOYRy9w1cC6/APWAk7zR8w1gGMjKSEDKPrrLuxS0
   0qEDtT0JYHlnrQO3Y92xe+Pbx3NwiqSJ3QwHV+sxwHMr+p4Pgsza21LsP/S1tjSpxrxRIIJaufAg
   4C0XV/n5r4gRfBB0wz6KJGeHTYywHgnut1dqp8BkTqnIy98/GLP2maz4AyXx50GlyR/H4EDXbt2O
   DP031lidnOqCKGAXHCwfy011NkHOFtLRkxE2kA==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ00CB198MZX90@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 13:24:22 +0000 (GMT)
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <cluster-devel@redhat.com>,
 <ntfs3@lists.linux.dev>, <ocfs2-devel@oss.oracle.com>,
 <reiserfs-devel@vger.kernel.org>, <jack@suse.cz>
Date: Thu, 1 Sep 2022 21:34:59 +0800
Message-id: <20220901133505.2510834-9-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220901133505.2510834-1-yi.zhang@huawei.com>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.127.227]
X-Source-IP: 45.249.212.188
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 impostorscore=0 suspectscore=0 clxscore=115 priorityscore=207
 lowpriorityscore=0 mlxlogscore=733 bulkscore=0 mlxscore=0 phishscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010060 domainage_hfrom=8269
Cc: axboe@kernel.dk, hch@infradead.org, tytso@mit.edu, agruenba@redhat.com,
 yi.zhang@huawei.com, almaz.alexandrovich@paragon-software.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, rpeterso@redhat.com,
 dushistov@mail.ru, chengzhihao1@huawei.com
Subject: [Ocfs2-devel] [PATCH v2 08/14] ocfs2: replace ll_rw_block()
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
X-Proofpoint-GUID: BwtjV5nO64YBLtIACXsrRXVaVjPfGm_d
X-Proofpoint-ORIG-GUID: BwtjV5nO64YBLtIACXsrRXVaVjPfGm_d
Reporting-Meta:
 AAH2QI4RcI5b9Z4mlTCy5jQDN4kdQjOWzHu6hIm5fv8MbG8HD4XbQHhKGac7vKdv
 uHhWjPJ3bq9u0mZVCF7dVq7aNWZgefRogcJ/EVmhJAh6S+jO/+vTGXedBcZaQK5s
 Dcr5mrNJ2Vg1OhqSt5GBNYebipoWnhlmQHJv6re9gtdjDWmWfnF18O558bKwhXQ+
 sDXXNyPpJukb36bkKMz3qrp+jMLQFoQeSBGbKPWiu3caVSRXKY0LvJSQnAFCMbB2
 cIjDhk2h0+mSWhYKNR1Dd5UL487WwVM6n1pcjaU9DzUO4QZDS8in8nFIr3xp0SD0
 WAULHHryAWbFbLwUfJoobGCv90+rjpMIWlPaSXdB4OijcBJbq5LHZ0te+Tz0MbWz
 IbX+26X9QRhhET1teKVTG+t4LVE6+et53htbqNifqYoZJzcJ8qjhPSr1hWA2nYsl
 9aWtK0g+9EN2m1MVvWVcHHuN9kX8k+Jnf9ZQoG9Efw/qgxFf/bYJq42ergKRlHvV
 AobYJpUyeIKrvFAw7Xu9imGf8MpQPliVOZtzFGaNVgSL

ll_rw_block() is not safe for the sync read path because it cannot
guarantee that submitting read IO if the buffer has been locked. We
could get false positive EIO after wait_on_buffer() if the buffer has
been locked by others. So stop using ll_rw_block() in ocfs2.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ocfs2/aops.c  | 2 +-
 fs/ocfs2/super.c | 4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index af4157f61927..1d65f6ef00ca 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -636,7 +636,7 @@ int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
 			   !buffer_new(bh) &&
 			   ocfs2_should_read_blk(inode, page, block_start) &&
 			   (block_start < from || block_end > to)) {
-			ll_rw_block(REQ_OP_READ, 1, &bh);
+			bh_read_nowait(bh, 0);
 			*wait_bh++=bh;
 		}
 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index e2cc9eec287c..26b4c2bfee49 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1764,9 +1764,7 @@ static int ocfs2_get_sector(struct super_block *sb,
 	if (!buffer_dirty(*bh))
 		clear_buffer_uptodate(*bh);
 	unlock_buffer(*bh);
-	ll_rw_block(REQ_OP_READ, 1, bh);
-	wait_on_buffer(*bh);
-	if (!buffer_uptodate(*bh)) {
+	if (bh_read(*bh, 0) < 0) {
 		mlog_errno(-EIO);
 		brelse(*bh);
 		*bh = NULL;
-- 
2.31.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
