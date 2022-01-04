Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61E48C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue,  4 Jan 2022 11:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=29ew91xSvPvsTLrApUaYK2AmnXfVuhiU7Cpfk7icSd0=;
 b=yyxRaXrqzz/TlJuaDWuxeuAj0qT8wlt3RBr4lfd4UeG0q16Of3yk5KiZZufYSxaO6APdmsira5zS
   PslfLtj4YpkLEuUI3R7owuqlUMzPIIXZ8srPGjf5B6NTYkVgkyv8o5FZlyvGaY9yBGjS5VBnQ5EI
   JrAiYVJzwqECwlmDlej6qx6TAed8rlVjJw6YlDOi3QQLA6ZPQesgv/eoNLS4s/7pxe0gMqI+Rae3
   CARf7qxU56UXcmcL3tPDfvrS9CJOxdiysqM+iCDT8lLSvQ2kV1IleVFqX0eMIBZL5IHRn5bkJBFx
   mIJ/5JC7TU59G5O1XtASRTE2XiiSGJ99ESHpMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=29ew91xSvPvsTLrApUaYK2AmnXfVuhiU7Cpfk7icSd0=;
 b=GI9phGz/EtPTLCi9UZ8CJK21KIE7Ud0hSOCccBnTh7wACEQcaCyi2//5QWLwYmY5uld2Nqbu2FFJ
   e0XCqT+iM5/yXNMDgnsvmvwyr/j+8BQuhn07ytdTHd0gU6LV928ZkRR1taSVHTF5yfInOeTJx4z4
   6HOkaPCYz9OkUR4ysL9hvj3Go7ug03jqvjtdwuqI3cv+A+LStuMbolfGf1no3+F4EtLS6o5youFL
   jiu3YSkj+HDmleh1+pKhWxsEKgbpMyekpIw3zR8WuhimcjBx77RO90t9jmAzq4yiegr9KYHqWZcf
   Yqgu4IELwt2/Gtgtn5PfFQNueY9fZg35rzdUhQ==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20211209 64bit (built Dec  9
 2021))
 with ESMTP id <0R5600ISSNNPQ520@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 04 Jan 2022 11:23:49 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=cgel.zte@gmail.com; dkim=pass header.s=20210112
 header.d=gmail.com; dmarc=pass header.from=gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=from:to:cc:subject:date:message-id:mime-version :content-transfer-encoding;
 bh=/XPM4xmzU6z/jmJWUGiGhcxMGP7e6gFgpuiXCvJPjYE=;
 b=p/LvLWyL2DBc1SegCv5ozxuEqK3rvj4jmQUj9R72gQJcXVQEXIGTraaXZ6fgR2GSWx
 qBGfdFFDnvjZzhFiW0BD+BP/kkc1BLf9f6OzOJK918bmr1X4SyE089UFMVdr6eX3dSON
 GWPk6x6xNvwmYhYBxGApTjl76UbeeaVRo5VGqw6Z/AmSTWANLEiXApzj7HY+dAlDS4cH
 hbEWebpaC/CLpF2l9w8iD8iuru9AcXcn8HvOqsUlVxIltXUQN/i9iQbvQ6KD+1qpvqUr
 7mQWo5mLLDMt6cAz57w/79juoZjKrCNfjNOx2WHruSaerNAtKKsZPMMWhkTbjRihe9qP +1tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding; bh=/XPM4xmzU6z/jmJWUGiGhcxMGP7e6gFgpuiXCvJPjYE=;
 b=mm9qyXF/gDseYYuQLCOkyE0x6X1JtupCY6ZnuIALqM8q4kr44E4UG8jYvkGT+UOd83
 V16xJdAiI3333erTOnkwy7u6Z3+Cs1i5zYejxIXZz4YLU+CW4wAC1+BF7MVl7bp1NNLW
 XU90OwgPZvUAtMwN3meM1bhljObdq8LiD4F9XSCvqGaz8ITh1Z2mpl5S+GkK+zwG3K/b
 MYlpL6o9YaCo1mgg0E2ALWgIrL4qtSvKC8B85VLUHuNm71N8oVrI6HqEPWRnoqROYQLv
 atSY3BFQ4Gvq/poS54Hg2xr+L/+7bFP654FPQ/gq9AM/vUb6nocHA0KjNJqo0rDd2h1y l1BA==
X-Gm-Message-State: AOAM530OzxhfMERVtlJhbOg6+e/9dhJnx87nzdEdtRZMKpZd0lINplw7
 78WENznm2lTNs9vDmduhiZE=
X-Received: by 2002:a17:90b:e87:: with SMTP id
 fv7mr59799149pjb.9.1641295417412; Tue, 04 Jan 2022 03:23:37 -0800 (PST)
To: mark@fasheh.com
Date: Tue,  4 Jan 2022 11:23:32 +0000
Message-id: <20220104112332.601834-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-version: 1.0
X-Source-IP: 209.85.214.173
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10216
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=342
 priorityscore=469 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=765 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201040076 domainage_hfrom=9641
Cc: CGEL ZTE <cgel.zte@gmail.com>, Zeal Robot <zealci@zte.com.cn>,
 linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] fs/ocfs2: remove redundant ret variable
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
From: "cgel.zte--- via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: cgel.zte@gmail.com
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 ABdhPJyRyPSmlDEHc/qWh50TRLHwgXRWbiCGC0JNXQusFRlL3WLDtgvzki2Cm8AOYDr8PDPY33bplA==
X-Google-Original-From: chi.minghao@zte.com.cn
X-ServerName: mail-pl1-f173.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-GUID: UcjuhZvaCn4I46RCAmtXAbmFM9UPll4O
X-Proofpoint-ORIG-GUID: UcjuhZvaCn4I46RCAmtXAbmFM9UPll4O
Reporting-Meta:
 AAGl5D6o02cj/beBl5vGbKbZIcBOfKWIgwS/by6f/RlvjictMIa3U15hCEr8n0BV
 TfkTTz1m3ipTm6SUPoCuIEyHZbU3ctWeYt6EI5kY3HRo5j021cnk1owJ/Ia510NJ
 bGNSoy0OgJWcVrR3QLteh/nc/XNLVlklUv0UD0dFQI42BInMEXQ6rQEbyWeCrYc3
 lb4uIuzi8urLP6reGbyQldfP53LU4f275Hc8pnj0uS871cGvsigrP+WezDvwQMWo
 BdoNWALogiZkeozQRBSJYnFRQtopYPiVbAQrAZIo1Xe7+pWaXnZqAJzTgXY+YO0S
 XGRMTEZnqwKaSrW5nzBGj7hADbbcqjlbH9NRbgW70tlPTSGKim5CWznwK+ca2UPm
 TYw5yXyKo5c8Lxo6EjynJRSgvc5WU62ubIc/8IYdd9sK0nHEZ+hrqzPC9OnIZ5Gv
 +Ds4v/EwV8w0l8T81idSVTzIoYtt/mAMx8aChL37ooPjHcb9LA414q37bvShXfTa
 eRGnQBHzHI1axbqdv/xo1+q00s7FL+eeJOuFeOayyPEe

From: Minghao Chi <chi.minghao@zte.com.cn>

Return value from dlm_lock() directly instead
of taking this in another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
---
 fs/ocfs2/stack_user.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 85a47621e0c0..3027a6a05668 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -683,28 +683,23 @@ static int user_dlm_lock(struct ocfs2_cluster_connection *conn,
 			 void *name,
 			 unsigned int namelen)
 {
-	int ret;
-
 	if (!lksb->lksb_fsdlm.sb_lvbptr)
 		lksb->lksb_fsdlm.sb_lvbptr = (char *)lksb +
 					     sizeof(struct dlm_lksb);
 
-	ret = dlm_lock(conn->cc_lockspace, mode, &lksb->lksb_fsdlm,
+	return dlm_lock(conn->cc_lockspace, mode, &lksb->lksb_fsdlm,
 		       flags|DLM_LKF_NODLCKWT, name, namelen, 0,
 		       fsdlm_lock_ast_wrapper, lksb,
 		       fsdlm_blocking_ast_wrapper);
-	return ret;
 }
 
 static int user_dlm_unlock(struct ocfs2_cluster_connection *conn,
 			   struct ocfs2_dlm_lksb *lksb,
 			   u32 flags)
 {
-	int ret;
 
-	ret = dlm_unlock(conn->cc_lockspace, lksb->lksb_fsdlm.sb_lkid,
+	return dlm_unlock(conn->cc_lockspace, lksb->lksb_fsdlm.sb_lkid,
 			 flags, &lksb->lksb_fsdlm, lksb);
-	return ret;
 }
 
 static int user_dlm_lock_status(struct ocfs2_dlm_lksb *lksb)
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
