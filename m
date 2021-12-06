Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7852CC433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Dec 2021 06:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XIfPa+izWixCOabdNFsGkqCjrOKExxli4CS16PPaxz0=;
 b=bLNOdE5LQQtAII8i+GJvrDItKfuxag2pM8ScvE1AarfNKsbG0cGBklHRf9MztcdevnpWVkORuy5o
   JEe36wCUm8dQkf9QdKezNItzTlU/fzVdVeEOYm+hjI6KK9dfnVazhQctLaxQ+KtBJVrL+2e4dfdS
   6QUO+G5PZs0Y04C6jYXuKEZJt790fIZymO7jLqFvWBu7hfXm8F+Lw5jaVmygshGUGyarY5vdWEBr
   jN5byP9ABDbukgsbwliA+5DJs6rGTqSptXq/CRDG0EBAX4ndxbQgAEYykWmVvWapLCLGdjCjux2+
   L67NLvlJTofciM1CNr8t8RwgFFE3sdytcYtz4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XIfPa+izWixCOabdNFsGkqCjrOKExxli4CS16PPaxz0=;
 b=Lbm9nyUb+uv2FYVVBfielp3x7LrERxm3w22yY79JJVDYMok5qxKkbCYZBcqDA7OBwPu4Oa9mOfCj
   G3lKk1Tz8n59KDOCOLrFncNOqcAuM5Ay5MSA48Uhq4f70PYRjMoqczr1xFFk7Oc23ZROgww0yX7p
   0DQnqJpoPwq6l5hWNG7Mq0byomOwfHtYB7pMbdpln8h9A7y/TSpvqawJfN3mFDwfe8/LKJZh4/JY
   Im4xiqbOW6g14jMYZavuXOuBzNlSIdsjnzoe0Hfu+yxUucgVeeljlE7ryVuu91O4jL6p0l3XVjJN
   K9WPigSdeRQLrZWGcatFfrGj1+wgZdp6v/wBWA==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20211123 64bit (built Nov 23
 2021))
 with ESMTP id <0R3O00DCFL1QZ3D0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Dec 2021 06:37:02 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
To: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon,  6 Dec 2021 14:36:42 +0800
Message-id: <20211206063642.35411-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-version: 1.0
X-Source-IP: 115.124.30.57
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10189
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=241
 priorityscore=111 adultscore=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112060040 domainage_hfrom=8271
Cc: ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: clearly handle
	ocfs2_grab_pages_for_write() return value
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R151e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0UzX-fIQ_1638772602;
X-ServerName: out30-57.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: CSgDylKwbxeXXYttS9wjy-OHKXFBTIFB
X-Proofpoint-GUID: CSgDylKwbxeXXYttS9wjy-OHKXFBTIFB
Reporting-Meta:
 AAFL4/Yz6c2vVgsGtF36tf4xl8D7aOc7Oya+XfnzIrmLbCelWz9GkF+J/AXzhDlY
 9q8hBa6ImD7nE8f/UHqODt7SKa9NGSOBfoweVfOqnyL1D4eD0qXJKbNuzerS0ZUn
 gfkYvzdw2NpOuIvXXgs5gV5WHGI+Mis79KUfAAzVuv5jGE7G6J0Ar0bhJT6LcglH
 RQXtHasasmkunIZvrux3qSc26HBT/kQ2OLT1X1ML4dWDgB+Lnm8bTtR52fcKCYkm
 SsjstFE8odtwHjRfpqnvwUZsWBfWfoyXdcKuXsnblgqMfzuuNQMWBByXtZMwAnWi
 bS/XnV1KbGT/jlr476Ms65ZsXmzo0cQnYIP8wH/mnIf1OFf8vgwJ1KsWtRyp5AES
 Y70xTo5EB8EqvrfbiALuGDggfYVEr3nJKdr9XW1CJXTj9Mp3k8upGphtzWSnIK+R
 g2HkX5xeQf1lWjoxVaWTulK3jFiXUgPPvojiXvzW1CjDlXUqyFL/0BCJRjZVsjdQ
 +sucX/Bgw08x3hXvqxGfxg6OzjSpYVFzyD1j7GM9Wy4=

ocfs2_grab_pages_for_write() may return -EAGAIN if write context type is
mmap and it could not lock the target page. In this case, we exit with
no error and no target page. And then trigger the caller page_mkwrite()
to retry.
Since there are other caller types, e.g. buffer and direct io, so make
the return value handling more clearly.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/aops.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 68d11c295dd3..f983f982b321 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1799,22 +1799,23 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 	 */
 	ret = ocfs2_grab_pages_for_write(mapping, wc, wc->w_cpos, pos, len,
 					 cluster_of_pages, mmap_page);
-	if (ret && ret != -EAGAIN) {
+	if (ret) {
+		/*
+		 * ocfs2_grab_pages_for_write() returns -EAGAIN if it could not lock
+		 * the target page. In this case, we exit with no error and no target
+		 * page. This will trigger the caller, page_mkwrite(), to re-try
+		 * the operation.
+		 */
+		if (type == OCFS2_WRITE_MMAP && ret == -EAGAIN) {
+			BUG_ON(wc->w_target_page);
+			ret = 0;
+			goto out_quota;
+		}
+
 		mlog_errno(ret);
 		goto out_quota;
 	}
 
-	/*
-	 * ocfs2_grab_pages_for_write() returns -EAGAIN if it could not lock
-	 * the target page. In this case, we exit with no error and no target
-	 * page. This will trigger the caller, page_mkwrite(), to re-try
-	 * the operation.
-	 */
-	if (ret == -EAGAIN) {
-		BUG_ON(wc->w_target_page);
-		ret = 0;
-		goto out_quota;
-	}
 
 	ret = ocfs2_write_cluster_by_desc(mapping, data_ac, meta_ac, wc, pos,
 					  len);
-- 
2.19.1.6.gb485710b


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
