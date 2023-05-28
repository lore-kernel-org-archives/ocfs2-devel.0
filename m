Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AFCCC77B7C
	for <ocfs2-devel@archiver.kernel.org>; Sun, 28 May 2023 13:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3+ypgPLUdyAZ+2Nxy+z14NNnwY1vhdh8slCxGepCPbg=;
 b=SOghAHVnmu5UGmzEiAIBU+TqEQruBYxR3+TCwo0G+yLBd8r8HxgEOzimo+CaTEwcyeia7f+kLygn
   EXn+lsQv7OqbBhDn1eauvnDH+PGfiMLIL371eq4iOl32VuOO+I3TeCsJ2rhrFUkr0eM3PJVn+YVD
   HS9/91hXAHHUfkUS31vWj5bm56yVWgp9AHq/gcrrHnO4iUt1bWZXSsSsvG7QvMolVPIvNTnuEzzW
   2k4YN4wSx+ErHRb77qngNgR4MKcVz63zHgYMlllTeNi3xMP9cPEn3QxYlEuGXDXelrTIBrClTtE+
   gW33K8eiEyuz8AL5IqktSrXev7hamXPCLxTgyg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3+ypgPLUdyAZ+2Nxy+z14NNnwY1vhdh8slCxGepCPbg=;
 b=BckBlDUxFOcM/AsWiuVAtiZ6fSDBAjrROUqatF5e15BvX+4onibwn4SZY8Du6TPMMco7Y+fe45tk
   2Uv4E2cYtlLUdmp9oVRHtfpWJ6lGsVItsGsd28K/uHISQLFr/5MNs6eAMFv9BoSKlsqTdDN9C3oR
   9lpShUC1tgHBt2cE9LlMHxG/rY4qakrJaASZ26PncXzUdZJ14JiH7soOux6fFOYQEFlfFoCq8JQq
   nq+W+FwG8Xy1IWGdnBMH4/Kk3gBXUOK3QVKnhWIb4LTGz0CfafxGrNNG4EgwPN6VXFQ3PpEg8+VG
   my7TNbmDwQIeGtP3Qmx5o5dqz9xzqbUVG4oiCA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230522 64bit (built May 22
 2023))
 with ESMTPS id <0RVD00A12EEXEBF0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 28 May 2023 13:20:57 +0000 (GMT)
To: Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 28 May 2023 21:20:32 +0800
Message-id: <20230528132033.217664-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-version: 1.0
X-Source-IP: 115.124.30.112
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10724
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=875 phishscore=0 clxscore=151 priorityscore=111
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305280115 domainage_hfrom=8809
Cc: ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: correct return value of
	ocfs2_local_free_info()
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R101e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046049;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VjcqgX0_1685280033;
X-ServerName: out30-112.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: WO2ZpxQ6APCF4-jxZ8_Cv5iLYOQlL-z9
X-Proofpoint-ORIG-GUID: WO2ZpxQ6APCF4-jxZ8_Cv5iLYOQlL-z9
Reporting-Meta:
 AAELDswK4O58QBA935gazIwpOco9SdxJv58r8i+GKqL4jrAUxXvtLp1anyMA0+eW
 AwYqhYJDlJ3bUbhBDRMBZXcbMC5z/FOSHrPZRqwevcNwPC811/j/DghS+UE8ovtY
 Hh18xNVDK41JDNJqzGNKv1MHxnIubjpbLP4hJFI92PHT7s8PQz7+tep1fG7cC9aa
 J73mXkahB053X7sDNYxOUwi8EvxIwUHbHC64jT/iwiT/D4iDfl/s1Vfp+GUD9Bgs
 hdh76F35ZbPDwvTsmKvF8p0P0i4lc3OwZ4iKWC94eRcaUQcPMfzzE9SGfrAB1yF1
 nLJa6O1apGMR4oRqcqqhosclhxBTXlFdcW7aMnhifDeAzsKW8RZktDZ5FF4K65hs
 43GTyOXyAC/Prne1yvJujYAfRH1+IBXpRn4Wjvi3eQ9qUOCjCg4JRzw3KFvEN0kT
 oufi3gVkil5ZN6R5TYNbC462RPf/EwKM3ks2jBcfGX0VLxa5WMKlvkRp06T9eFIS
 aWve1c+bq89JmQEHk20xDeFtkOqFqrfeTdyjgZdf3X17

Now in ocfs2_local_free_info(), it returns 0 even if it actually fails.
Though it doesn't cause any real problem since the only caller
dquot_disable() ignores the return value, we'd better return correct
as it is.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/quota_local.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 5022b3e9bfcd..dfaae1e52412 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -811,7 +811,7 @@ static int ocfs2_local_free_info(struct super_block *sb, int type)
 	struct ocfs2_quota_chunk *chunk;
 	struct ocfs2_local_disk_chunk *dchunk;
 	int mark_clean = 1, len;
-	int status;
+	int status = 0;
 
 	iput(oinfo->dqi_gqinode);
 	ocfs2_simple_drop_lockres(OCFS2_SB(sb), &oinfo->dqi_gqlock);
@@ -853,17 +853,14 @@ static int ocfs2_local_free_info(struct super_block *sb, int type)
 				 oinfo->dqi_libh,
 				 olq_update_info,
 				 info);
-	if (status < 0) {
+	if (status < 0)
 		mlog_errno(status);
-		goto out;
-	}
-
 out:
 	ocfs2_inode_unlock(sb_dqopt(sb)->files[type], 1);
 	brelse(oinfo->dqi_libh);
 	brelse(oinfo->dqi_lqi_bh);
 	kfree(oinfo);
-	return 0;
+	return status;
 }
 
 static void olq_set_dquot(struct buffer_head *bh, void *private)
-- 
2.24.4


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
