Return-Path: <SRS0=LbgC=OD=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91862C433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Sep 2021 14:28:53 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1C62260F58
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Sep 2021 14:28:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1C62260F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=fudan.edu.cn
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DEFfw2008836;
	Mon, 13 Sep 2021 14:28:52 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3b1k9rtt1x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Sep 2021 14:28:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18DEDNWx034817;
	Mon, 13 Sep 2021 14:28:51 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3b167qh6w0-1;
	Mon, 13 Sep 2021 14:28:51 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mPmx0-0004iA-0S; Mon, 13 Sep 2021 07:28:50 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <cymi20@fudan.edu.cn>) id 1mNr2R-0005ps-Gp
	for ocfs2-devel@oss.oracle.com; Tue, 07 Sep 2021 23:26:27 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1886ADpX120250
	for <ocfs2-devel@oss.oracle.com>; Wed, 8 Sep 2021 06:26:27 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 3axcpn9gba-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 08 Sep 2021 06:26:21 +0000
Received: from pps.filterd (m0246575.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	187MgANw015672
	for <ocfs2-devel@oss.oracle.com>; Wed, 8 Sep 2021 06:26:20 GMT
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net
	(zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
	by mx0b-00069f01.pphosted.com with ESMTP id 3axcm8q8jx-1
	for <ocfs2-devel@oss.oracle.com>; Wed, 08 Sep 2021 06:26:18 +0000
Received: from t640 (unknown [10.176.36.8])
	by app1 (Coremail) with SMTP id XAUFCgBHTV2CVzhhbJA1AA--.12868S3;
	Wed, 08 Sep 2021 14:26:10 +0800 (CST)
From: Chenyuan Mi <cymi20@fudan.edu.cn>
To: 
Date: Wed,  8 Sep 2021 14:26:03 +0800
Message-Id: <20210908062603.6723-1-cymi20@fudan.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: XAUFCgBHTV2CVzhhbJA1AA--.12868S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uF17JF1xGrW8KrykGrW7Jwb_yoW8GFW7p3
	y7Kw43Kr4rKa4UA3W8J34vgF1S9ayDKF9rur40ywnrZFs8tw13AryIq34agayrA34rArW7
	XFyakr4Fg3Z8Ca7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9j14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl
	6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
	64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
	Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
	YxC7MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s
	026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_
	Jw0_GFylx4CE04Ijxs4lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1l
	IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvf
	C2KfnxnUUI43ZEXa7sREo7KUUUUUU==
X-CM-SenderInfo: isqsiiisuqikmt6i3vldqovvfxof0/
X-Source-IP: 165.227.154.27
X-ServerName: zg8tmty1ljiyny4xntqumjca.icoremail.net
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:202.120.224.0/24 ip4:61.129.42.0/24
	ip6:2001:da8:8001::/48
	include:spf.icoremail.net include:spf.mail.qq.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10100
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
	spamscore=0 clxscore=330
	malwarescore=0 phishscore=0 suspectscore=0 mlxlogscore=761 bulkscore=0
	impostorscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=48
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109030001 definitions=main-2109080040
X-Spam: Clean
X-Mailman-Approved-At: Mon, 13 Sep 2021 07:28:45 -0700
Cc: Chenyuan Mi <cymi20@fudan.edu.cn>, Xin Tan <tanxin.ctf@gmail.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>, yuanxzhang@fudan.edu.cn,
        linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix handle refcount leak in two
	exception handling paths
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10105 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109130095
X-Proofpoint-ORIG-GUID: U_PiJ85KO4gOLT3drdPAIFG3R7XID2yr
X-Proofpoint-GUID: U_PiJ85KO4gOLT3drdPAIFG3R7XID2yr

The reference counting issue happens in two exception handling 
paths of ocfs2_replay_truncate_records(). When executing these 
two exception handling paths, the function forgets to decrease 
the refcount of handle increased by ocfs2_start_trans(), causing 
a refcount leak.

Fix this issue by using ocfs2_commit_trans() to decrease the 
refcount of handle in two handling paths.

Signed-off-by: Chenyuan Mi <cymi20@fudan.edu.cn>
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>

---
 fs/ocfs2/alloc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index f1cc8258d34a..b87960cdda0d 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5941,7 +5941,7 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
 						 OCFS2_JOURNAL_ACCESS_WRITE);
 		if (status < 0) {
 			mlog_errno(status);
-			goto bail;
+			goto bail_commit;
 		}
 
 		tl->tl_used = cpu_to_le16(i);
@@ -5965,7 +5965,7 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
 						     num_clusters);
 			if (status < 0) {
 				mlog_errno(status);
-				goto bail;
+				goto bail_commit;
 			}
 		}
 
@@ -5975,6 +5975,8 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
 
 	osb->truncated_clusters = 0;
 
+bail_commit:
+	ocfs2_commit_trans(osb, handle);
 bail:
 	return status;
 }
-- 
2.17.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
