Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C108C433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Dec 2021 06:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pSZgM3//W3nZCGUYcOptxj1ELhABMxaDb8wkcJqemjo=;
 b=Do3BTKcFaaCJf++eVO0NDZPOJg8Ns84UwuHo3rMeCs4He7dPUS6Uwb5mag53IQyUXUaiiFMunuTl
   f76o2R1DYMjCagCfMklm4+cNCGnNlE7pDIBcGKWNIBDS1tpMZzezURtHQ9NLIsnl3dPxt/eXfJkF
   0+ubctqRkp6uNypPLrmyn+JevGyQSaOp1jCvcYkPj1AfGEFQGDOHLzvM3DXXQbYtZXj+OYCC7jDG
   Kh6YsRDoiUrUeFPFqW850c9rNW1lWaz8O44OmpS0+CWaB3qvcoCQMENmkqkiuf0ash302HG2CSh9
   95I8zVUjlbHoQEKy42ozCG0VC/LzN7dI8X44yw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pSZgM3//W3nZCGUYcOptxj1ELhABMxaDb8wkcJqemjo=;
 b=KyKJXq+W9Xw+O2PVzD5vf7POcNrykkrLhAHpYhMFlwUVg+A7iMkpItXwu3NO7XggNNkAvO3fxdbe
   QvUzqm6djX+WHkNEq6g+IxE2EOdBpH5ckyKr6ShJ0V3TY0t6p0FAyfx3qv7/jRCKH53nLa2HB1ft
   YAH/TY6GWkiagLkiF1Kxomq2vtA0B3Grx8EK2gHq/y3P10DFSewBghFOJ9CWRAW5NQSM3Kx/4MFI
   Ins4iiaEOCMH2eX0jnr73uQD96b14jM/sDYaXsFlGe0Z8DcU+cG9kXdDFAUoAuxoLzX5a6CfBX+4
   mzXCXcyVQ2BOpg69HpmzxjW773r54p2wYEwk3w==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20211123 64bit (built Nov 23
 2021))
 with ESMTP id <0R3O002ODLPJWNA0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Dec 2021 06:51:19 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
To: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon,  6 Dec 2021 14:50:51 +0800
Message-id: <20211206065051.103353-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-version: 1.0
X-Source-IP: 115.124.30.43
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10189
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 priorityscore=174 adultscore=0 phishscore=0 bulkscore=0 clxscore=283
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112060041 domainage_hfrom=8271
Cc: ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: clearly handle
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R721e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0UzXObZr_1638773451;
X-ServerName: out30-43.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: QI4HkMrv0_pirL1nzVh3Kwu8GcmApQup
X-Proofpoint-ORIG-GUID: QI4HkMrv0_pirL1nzVh3Kwu8GcmApQup
Reporting-Meta:
 AAHRXMyikLJngzRsNeYJI+20s32qpyOY/EZlr7IOZc1LpiuzFhvo1a89dl2o3aZT
 Ez/6axuKxo55arkMNGvgk5C74wAIziWvgdWgPW4wuvS5BnUJ9NtBZjR3DIiPbbRf
 JYWopNSs451icz5xK5dPquBpttAN28/KiQ/irREpfOZr4mi4ofczdmNdXwdHAFVM
 ErrCJ+6Ec3BbPpB/KA3WjUNzKfYfr87FWdw61BSKixDBHCfdgWmpMq2Q+v5WwYsl
 Ql5wmndAbJflQ2xlKR1yzT49pk6rsJiJcDpgdMd3h/c4R1wbfewIiEpjoAfNGJwr
 kEmBOfNxvAKwosyEb4F2pJiQmPZqgRqT6a71VQXdJskn0Ea80e3t+UWfMwTfhEhI
 2zxP9FaldcJz0o4AArSWSEYNnRzoRLGlvA1zbXm+RXueGz91MQuD1FEPxcMOCiIa
 StyfHDQ99peIMIVzLyy5BqXWGMICQlLlwGcnNGgu/IfbgzEQLb6eoafIpW4cdIUe
 H81HpY7Hq1m9+PatrAkFkRbwS/O8ZY6vMpIAztQGXR8=

ocfs2_grab_pages_for_write() may return -EAGAIN if write context type is
mmap and it could not lock the target page. In this case, we exit with
no error and no target page. And then trigger the caller page_mkwrite()
to retry.
Since there are other caller types, e.g. buffer and direct io, so make
the return value handling more clearly.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
v2: remove redundant blank line

 fs/ocfs2/aops.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 68d11c295dd3..498da317580a 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1799,20 +1799,20 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 	 */
 	ret = ocfs2_grab_pages_for_write(mapping, wc, wc->w_cpos, pos, len,
 					 cluster_of_pages, mmap_page);
-	if (ret && ret != -EAGAIN) {
-		mlog_errno(ret);
-		goto out_quota;
-	}
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
 
-	/*
-	 * ocfs2_grab_pages_for_write() returns -EAGAIN if it could not lock
-	 * the target page. In this case, we exit with no error and no target
-	 * page. This will trigger the caller, page_mkwrite(), to re-try
-	 * the operation.
-	 */
-	if (ret == -EAGAIN) {
-		BUG_ON(wc->w_target_page);
-		ret = 0;
+		mlog_errno(ret);
 		goto out_quota;
 	}
 
-- 
2.19.1.6.gb485710b


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
