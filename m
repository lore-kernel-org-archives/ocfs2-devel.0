Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A14A4ECAAD3
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Sep 2022 13:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=tcJVcqexIZzCWdE36q125JxESm575mrJsDGQZ7GzZZ8=;
 b=PFBAu/QuZkEtjBgoUkSoT3iHkPQJh9wBgesK1xbqJRYurm6ibnX9S+eVRgGcLpt7PeMEYxWeo69k
   dr/znZt9humwZv/xs/ItmF42ua/IukN+9Baem0x1A0pm9ld5YHjmMI0t56D5HBycLKOa3H82TSiV
   idiuWc5DVUdrVwYk4GSc2JCFkElxRKeP14egR5bwM7l6HoEHjngmDdwE705YTHKD737MWeRwh4b2
   HSD/QnuNvo9a9VmOnGIz77/gQ42bqpQdzMtnbQM8q9wpYlF799GL3DqoNvJdeLUGYyCmh0IMhE+n
   zovh/oogCpBw6d3dvW70j0l879Lz7+xnWKwQbA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=tcJVcqexIZzCWdE36q125JxESm575mrJsDGQZ7GzZZ8=;
 b=PTDOqnavFMjV5aNXRH2hHTIcMHoyR8qcQzM+oTE/LQ7SZeDJSeKD1RV27AyD13cH7G1zb5RxIX89
   LJN1fmnBOONkvfmFyJniu7DL5t6SdhB5xWOT3NyZDg2Exmm47Y3K1wS5Zs/aA8afgr/pf25++7rE
   H2Aq0NEzMOFHUK8/5nEPfMUHyjLPg9ku5yGPhG9q4w3rNLqBbYJtfSHIVLHtJh0BBEkAldxFXqxe
   A89ord15EOZxp4n5ibccU4uEy9fsJXUfrpSMfSeFq+P6v1N6xRBGHaJVilJqAuizvTY8zzecfgrv
   kXV3RnTtKfusgAXyvn/qzS+u2fGZK2oowLxWDQ==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHJ00O0C98WJP10@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Sep 2022 13:24:33 +0000 (GMT)
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <cluster-devel@redhat.com>,
 <ntfs3@lists.linux.dev>, <ocfs2-devel@oss.oracle.com>,
 <reiserfs-devel@vger.kernel.org>, <jack@suse.cz>
Date: Thu, 1 Sep 2022 21:34:56 +0800
Message-id: <20220901133505.2510834-6-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220901133505.2510834-1-yi.zhang@huawei.com>
References: <20220901133505.2510834-1-yi.zhang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.127.227]
X-Source-IP: 45.249.212.188
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10457
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 adultscore=0 priorityscore=207 mlxlogscore=817
 clxscore=119 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010060 domainage_hfrom=8269
Cc: axboe@kernel.dk, hch@infradead.org, tytso@mit.edu, agruenba@redhat.com,
 yi.zhang@huawei.com, almaz.alexandrovich@paragon-software.com,
 viro@zeniv.linux.org.uk, yukuai3@huawei.com, rpeterso@redhat.com,
 dushistov@mail.ru, chengzhihao1@huawei.com
Subject: [Ocfs2-devel] [PATCH v2 05/14] isofs: replace ll_rw_block()
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
X-Proofpoint-ORIG-GUID: UVenWuULLmmDmmqCfUo8lPD14fcsyLGJ
X-Proofpoint-GUID: UVenWuULLmmDmmqCfUo8lPD14fcsyLGJ
Reporting-Meta:
 AAGw5akX3++AC8S/4x4G4JFq52NkczWkyM2QN5lIGaIce9rHt67ivD6eUaZ/FnhU
 VRzPISvzrlKP5eVShon9boQPmgEV8LTdGAtIsEYLRWFYjLZoVzH9OYE3LJU4LYmt
 DNt+LGVhR21XkNX+sLYJJvXOO3chiCYn7N8ar/8DVPofroRpW7WJIdmk6PRdmIt3
 HIrP6ol3m2bXcOoUiy/eIdGyfwJ7jzWyzrj+O38sQ1Ob8G1wSK09BdJJ72qa+8Jd
 juY8dAIaP3tsETljmH31LwlX0IoKc8nVewa7Ubh+9JJvgu9K792m8LLnNC0v/72C
 yLxO2uL7XVDmBzun4NTY0XeoJfcNiAFQtRs+N0cYa4eOmkGmrQfnxsj6CXv3FxgK
 sQcoO90CMmvGbE48bGm5syojpasjVl+LhycslXAzlBqYSxIeSwHdrfDrvvOvEnpC
 TY+WcLc7OMo4zX9gqQ0lFhPQwv6/HQZs+Z/XD+CwMUuCXOOxc95X9J5r/wNv+21I
 C/XgpcGLUuTVB0TV4Mo4SNraPT9uSQZjC51CJLxUCa3h

ll_rw_block() is not safe for the sync read path because it cannot
guarantee that submitting read IO if the buffer has been locked. We
could get false positive EIO return from zisofs_uncompress_block() if
he buffer has been locked by others. So stop using ll_rw_block(),
switch to sync helper instead.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/isofs/compress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/isofs/compress.c b/fs/isofs/compress.c
index b466172eec25..59b03d74ecbe 100644
--- a/fs/isofs/compress.c
+++ b/fs/isofs/compress.c
@@ -82,7 +82,7 @@ static loff_t zisofs_uncompress_block(struct inode *inode, loff_t block_start,
 		return 0;
 	}
 	haveblocks = isofs_get_blocks(inode, blocknum, bhs, needblocks);
-	ll_rw_block(REQ_OP_READ, haveblocks, bhs);
+	bh_read_batch(haveblocks, bhs);
 
 	curbh = 0;
 	curpage = 0;
-- 
2.31.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
