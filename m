Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09ECAC7EE23
	for <ocfs2-devel@archiver.kernel.org>; Sun, 28 May 2023 13:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=6v+fOaGCeEMJj+2/RfPPZj2QMfHoCc6+HqMTPK+AoWI=;
 b=y2OxZYVLI18RPalGAToYvuD/VZJqVboINubx1scqzQMc7QhB0nsvSPqgo+n6eaaoPTQme/X6Nb+T
   uCjVw7nIZt2xJvEtiqRTm9fdfTmkgSVbvH0q6zyTKIbPhyODBfOJnxIQqI3nY2QdH5y6Hg9GIC+Q
   k95Niov0IGNH1++/+SyP7hl6BukM72YTydzEk968tyUFbl09E/U0Ywd8wc2pRz12CcyB7NuoaQc6
   C3foP7LgSCIGFcGsP/O0B4w9siP7iPKNPXKybFkVjfsqWKp9hbO9h96gbXRiMVvdufzJVN3Y2qgD
   6Soq8HZm1rRbhhg8ITpPOaqWPhhXM55OeU+OoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=6v+fOaGCeEMJj+2/RfPPZj2QMfHoCc6+HqMTPK+AoWI=;
 b=GYsBmFcdSQaGMgXKjvmKp3/96bgUF+cDAaNOgWUu4386tQbGbcudQSYOCpWjAG2K+myhU1GJyQuC
   k8ZGjBsN1Bnojb6u/P+esWV0kyfCWEX//iV157ZSuC3sc2qlNHrPXw55XIZW6xkUx5+UaH/Vupud
   G+X3J9vl+G//8G+Ek8/4e2USOMx2zElx0G8U5xGVeqlX4ZiQX62pMGrD97BeJZAY6tmlmPMAVOcW
   Dv/oRPQ94qj+HuyVTdLVJWJo1Mhmn8nsDT7MCQE/XpSfRP/XUzx2xr1U6HmwtWxhEjQo94RgsCMV
   EPWe0S94FBHqAcG5ZshA9W+5BLbmfe5v8lP9rQ==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230522 64bit (built May 22
 2023))
 with ESMTPS id <0RVD003NEEFEYQ30@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 28 May 2023 13:21:14 +0000 (GMT)
To: Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 28 May 2023 21:20:33 +0800
Message-id: <20230528132033.217664-2-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-reply-to: <20230528132033.217664-1-joseph.qi@linux.alibaba.com>
References: <20230528132033.217664-1-joseph.qi@linux.alibaba.com>
MIME-version: 1.0
X-Source-IP: 115.124.30.131
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10724
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 priorityscore=48 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 clxscore=161 mlxscore=0 mlxlogscore=945 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305280115 domainage_hfrom=8809
Cc: ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: cleanup trace events
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R411e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046051;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0Vjcsm9c_1685280034;
X-ServerName: out30-131.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: fJoJixwIH1cUWRmEi72YBYiWlyenLc4R
X-Proofpoint-ORIG-GUID: fJoJixwIH1cUWRmEi72YBYiWlyenLc4R
Reporting-Meta:
 AAH7lsFk1No9yG92xLTcJOcIF3Fskgz3gzoNtISUzHPyV7AHCsjsv7iMd4wdXcQV
 OgVDcJvDy03g5KDPxDyG+o+LOM3oMvuJz1K2K8pyUqMMRZtMm+STFt/OXqrgBuxd
 ml3t1eJdSmjXOOw1JSkhZtWuRR+DKVoYeJ0qMPLvZw5AvWiTGL1eoMpP6E/x5LTv
 SrnYMv9fDfnNxchS0omgTyvp1aJ77aR321FWtpFBCrBNpphxvTVqvtKqnWTbHNE8
 fiBmt2691bS4eYJOKArJvF584/fm6bid+iAm4zns0ybdqHYUR6jQ8KsqPgnCv8fg
 QEkBz25X5M7JQTj4bDp4cnzZaDucHYV2mG2mvQH1oY6lBfIembH2Z1OmaERyG+A0
 PwGt5jV1mEaeQfUo0aZvHlhJm1wSU3E9eZSrtmeC/8gPhw2GHjXOzAiwV+NqM9GO
 3+So72lEDNPWTH3bVCTX7fwrzja39110MPSeppzNGdvymQGk93aPjfwnVW1u0mmp
 vJ+2D6R9Rf6vzADx71EKJEbENeW6McvKwnxBtJVxTTOJ

After commit 6dc8bc0fb300, ocfs2 has switches from
ocfs2_file_splice_write() to iter_file_splice_write(), so cleanup the
corresponding trace event as well.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/ocfs2_trace.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index dc4bce1649c1..26effa583be0 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -1315,8 +1315,6 @@ DEFINE_OCFS2_FILE_OPS(ocfs2_sync_file);
 
 DEFINE_OCFS2_FILE_OPS(ocfs2_file_write_iter);
 
-DEFINE_OCFS2_FILE_OPS(ocfs2_file_splice_write);
-
 DEFINE_OCFS2_FILE_OPS(ocfs2_file_read_iter);
 
 DEFINE_OCFS2_ULL_ULL_ULL_EVENT(ocfs2_truncate_file);
-- 
2.24.4


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
