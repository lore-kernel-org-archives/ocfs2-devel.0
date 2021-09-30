Return-Path: <SRS0=Bxih=O4=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9625C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri,  8 Oct 2021 15:30:31 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 59E4B60F6F
	for <ocfs2-devel@archiver.kernel.org>; Fri,  8 Oct 2021 15:30:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 59E4B60F6F
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 198FJ15Y023217;
	Fri, 8 Oct 2021 15:30:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : cc : subject : list-id : list-unsubscribe : list-archive :
 list-post : list-help : list-subscribe : mime-version : content-type :
 content-transfer-encoding : sender; s=corp-2021-07-09;
 bh=xZpdignSLS9S1KQg9jBuzvqAlDZQBDt81LktEfelfBk=;
 b=jS5WHntn5lIEAoOR8NjFjgjM6GzQ+7/xapG3DLlIuVrKeKUOX85g8cjmLUJGfzTlhnD+
 E4bKkdb52+JFUqK2XqcZUNrl0rtEA4yuBWwy5d2+Z7TljXedQ3EimnlZYbJ+g6HEjtU6
 uKyhB6BlewSPZlNgBOPiw+4Iq/YP8mfRgQR+q+Yo77ggHmMMPloLobiLyugel0i2m0/3
 UV3N5b/vc+H7DMxEwl7bWAkU4PM15m76Wjemk6G8HmViuDtlsclvdhQuKHKQ2daZuHTE
 3mWpScPrQvDBfsWx2+I1unn0XhCkgBz2Qqkc29I4S0/nNoMvxfWTOxLr13nQ+q2gcZvj tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bj02jrfqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Oct 2021 15:30:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 198F4s8w172318;
	Fri, 8 Oct 2021 15:30:12 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bf16yjmp2-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 08 Oct 2021 15:30:11 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mYrp4-00019I-EZ; Fri, 08 Oct 2021 08:30:10 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <gautham.ananthakrishna@oracle.com>)
	id 1mVq1G-00065f-Ep
	for ocfs2-devel@oss.oracle.com; Wed, 29 Sep 2021 23:58:14 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	18U6tl9F193953; Thu, 30 Sep 2021 06:58:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by aserp3020.oracle.com with ESMTP id 3bceu6kgfu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Sep 2021 06:58:12 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 18U6vo0t004188;
	Thu, 30 Sep 2021 06:58:12 GMT
Received: from gmananth-linux.oraclecorp.com
	(dhcp-10-166-180-49.vpn.oracle.com [10.166.180.49])
	by aserp3020.oracle.com with ESMTP id 3bceu6kgf1-1;
	Thu, 30 Sep 2021 06:58:12 +0000
From: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
To: ocfs2-devel@oss.oracle.com
Date: Thu, 30 Sep 2021 12:27:39 +0530
Message-Id: <1632985059-11984-1-git-send-email-gautham.ananthakrishna@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Mailman-Approved-At: Fri, 08 Oct 2021 08:30:09 -0700
Cc: rajesh.sivaramasubramaniom@oracle.com
Subject: [Ocfs2-devel] [PATCH RFC 1/1] ocfs2: race between searching chunks
	and release journal_head from buffer_head
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10131 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110080090
X-Proofpoint-ORIG-GUID: C0vSBdbVgbrPbODMM7D2BUNd6L9H26_A
X-Proofpoint-GUID: C0vSBdbVgbrPbODMM7D2BUNd6L9H26_A

Encountered a race between ocfs2_test_bg_bit_allocatable() and
jbd2_journal_put_journal_head() due to which ocfs2_test_bg_bit_allocatable()
dereferenced NULL pointer. When ocfs2_test_bg_bit_allocatable() called bh2jh(bg_bh),
the bg_bh->b_private was NULL as jbd2_journal_put_journal_head() raced and released
the journal_head from the buffer head. Needed to take bit lock for the bit
'BH_JournalHead' to fix this race.

Signed-off-by: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
---
 fs/ocfs2/suballoc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 8521942..0e4e11b 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1256,8 +1256,11 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
 	if (ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap))
 		return 0;
 
-	if (!buffer_jbd(bg_bh))
+	jbd_lock_bh_journal_head(bg_bh);
+	if (!buffer_jbd(bg_bh)){
+		jbd_unlock_bh_journal_head(bg_bh);
 		return 1;
+	}
 
 	jh = bh2jh(bg_bh);
 	spin_lock(&jh->b_state_lock);
@@ -1267,6 +1270,7 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
 	else
 		ret = 1;
 	spin_unlock(&jh->b_state_lock);
+	jbd_unlock_bh_journal_head(bg_bh);
 
 	return ret;
 }
-- 
1.8.3.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
