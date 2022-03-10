Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BA19C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 10 Mar 2022 08:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rT8JVO3hQrXw7ig6TWC+Ci/q/CtKwLRvv+T4vfmq0AY=;
 b=QZHSvdnnSKrW7Jddh5u2sspxkY6CsC8LXOqjAXdwhJEHBRapQCgfQc2ZPhiCbrchGH78kpPJop5V
   b5U5FrTtnbrfJ2bXtSQeTyawSJ/qlB5rUL/4caknLp+4pWz4DlKiSjdr5ZzBtMZzQVtxqXFifIvA
   JnTxHjk3yEa1/hyPzQhbERgC6chMW3hb1YzE8RjfPNtzy4MOD3DnB+TvKK5fifASRC3CY6XY7zfh
   lmmYvjbfEmhDqkKdyplgwr0CSfyVm5365nH9f9OGNPORHe31x8sNCEORsUMUzNwYz3A3n/LYlRkl
   mtoWla/EnV9PeWPe9lSOq9jPs52Z84DctCfBtQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rT8JVO3hQrXw7ig6TWC+Ci/q/CtKwLRvv+T4vfmq0AY=;
 b=Cg5lj8+Q7abMBLFqK9qj2lpyNIQSYuzCKWsur1/zJAU074UsVX7whdc+qpwOgCLB42FEo+XxQsk8
   Qns+HVA+ymFUzOZYTbE22vsvhUu1NdT0x14sLHO5gsLL75Z4NBQpY4KEpfjQJ3ZyQr8f4TLDtsLk
   c9wGHAUkAn3vb0gEfJOWQ5o7dJD/mKgYkwdR2cjkCuF5uOf0kgu7b2WkZrXys0j+exUYbEtRF6o1
   ISEYIeD0a0ZiB9+Ea9QbTOkWefGkK5gEfXCGZNblT00bh8R339cB+29aBbQJLslSVkmx+otc9kXx
   +y1rXJOaXv3eH8i9hk17a88kh8N0GclXyO4Ygg==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R8I004GESH14C50@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 10 Mar 2022 08:19:49 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
To: Gang He <ghe@suse.com>, Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 10 Mar 2022 16:19:30 +0800
Message-id: <20220310081930.86305-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-version: 1.0
X-Source-IP: 115.124.30.56
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281
 signatures=692062
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=203
 lowpriorityscore=0 malwarescore=0 priorityscore=111 mlxlogscore=999
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203100043 domainage_hfrom=8365
Cc: ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix crash when initialize filecheck	kobj
 fails
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
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R881e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04395;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0V6nmjfK_1646900370;
X-ServerName: out30-56.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: kOSx8G9BDQhxIYBpcGVDCeytvSqtMxtz
X-Proofpoint-ORIG-GUID: kOSx8G9BDQhxIYBpcGVDCeytvSqtMxtz
Reporting-Meta:
 AAEMvFzsLPBkPgNudAqrwHhKzthQhPfAoqV7LOkp/jBowGRfN760D9sEuQQyTJ3c
 t4AYYRR6bMkEx9qYLdy+4kFdWoEeoR1TzM/2DSUUYGE8DtijcTnxE54N7NeUkaeZ
 BlOi09R4X8G9n3bEaDDg2N02lNB4zxFnqQMDG9K7c78Nir1rEgNPa0urmfdQsN82
 Sgyn68B+70gPnaeMwCLVWabN+Krr+4j2nCVqp8wzDdNGyVbjs0mj4patdHFWfmNA
 MPpxPyc8d8xfR1OkDYfCN4UTLteQGx53yQX3ICOih7GmBS9xdK5s56cRkfDdCALc
 FqHsE71f+0xWrJuLBmGJW+pMu+0fi6M7HPMyGHsdgmRz77paaHulVH7qcrOW5m6s
 mJBfgcwodgdEn/C0OnQwjeERXuux2lgji/v/9aa1HbMNYSGaU1l9EyW4GvzpmGGi
 kNgQ2sFrEu6yxQi5s9oFdh70lQxUAokZQrgxWB8/UIPt8KUafct1YKM+MePcUlzU
 heV/B6m/c6fBIl6CpHMcMSxlceInkIu7DZuzV8kaiaOWFQ==

Once s_root is set, genric_shutdown_super() will be called if
fill_super() fails. That means, we will call ocfs2_dismount_volume()
twice in such case, which can lead to kernel crash.
Fix this issue by initializing filecheck kobj before setting s_root.

Fixes: 5f483c4abb50 ("ocfs2: add kobject for online file check")
Cc: <stable@vger.kernel.org>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/super.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 2772dec9dcea..8bde30fa5387 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1105,17 +1105,6 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 		goto read_super_error;
 	}
 
-	root = d_make_root(inode);
-	if (!root) {
-		status = -ENOMEM;
-		mlog_errno(status);
-		goto read_super_error;
-	}
-
-	sb->s_root = root;
-
-	ocfs2_complete_mount_recovery(osb);
-
 	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
 						&ocfs2_kset->kobj);
 	if (!osb->osb_dev_kset) {
@@ -1133,6 +1122,17 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 		goto read_super_error;
 	}
 
+	root = d_make_root(inode);
+	if (!root) {
+		status = -ENOMEM;
+		mlog_errno(status);
+		goto read_super_error;
+	}
+
+	sb->s_root = root;
+
+	ocfs2_complete_mount_recovery(osb);
+
 	if (ocfs2_mount_local(osb))
 		snprintf(nodestr, sizeof(nodestr), "local");
 	else
-- 
2.19.1.6.gb485710b


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
