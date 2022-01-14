Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABAA0C433EF
	for <ocfs2-devel@archiver.kernel.org>; Fri, 14 Jan 2022 02:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=aOhnNUhxw/+9WgPP0NBQ+S9gA57O9Vk3YnxlsOnpNSQ=;
 b=OFcMtGoQcCfxh1Efg48jqoOV+2+wDoSrmpoF6Jb0A5hKoSXfGu/thX8DEdYOVrGQDjDRTXwLVrVn
   IWzkPuTUeeDAoo+UmtPZmfzmYNDBGiRqAEd4QFLXZLgXSyTo/DQIXbzy+fDB5cNuqQGK+z5pI6Na
   CexUf0X/NwNQ8uUfjaRQe0ndlW48Fsole0s11ktrT3L8/LGw8sLAmhSTwmUKmPhet7YVu5luX3PD
   XoQVgjMSPxzcV2CmYTDdK0iHFb2K6HJMOdvk7P8DbjJ2ePvM31C1+/mupOA9qfPcVYRYy/NzkddY
   ZM21BXS3Mifw91JMJUNuSY0TQhr8od/AQThFsA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=aOhnNUhxw/+9WgPP0NBQ+S9gA57O9Vk3YnxlsOnpNSQ=;
 b=i9GiXV0bJVam8kuHgbDopJwaLAwxoPHYbFKqPWVeBfR//bbrqueZltIhs1m3JY+4PhZwjhQcNV2w
   V/yRB0XeDIabRfG0AUzHcHwQwXjDH7wVehKYK6bJGBfezkDTuweWiuC0F0Ypc/pXczMUpldteZdr
   OsRDlywrxq6uFBxRfUX5InFC7nqibiKcoQuj4b+30+2X7HXzICvkMvp8LrWdeBZklwEOacLN25Vk
   b8mvlngUaynmP1NnIInsVu+f4ko/ZopDOD/SN9UsB0atWnkKR048D8FC7iRIAVa6ud6poMDB+kss
   Ljd1LbsnQx9zzqutyfWgAnO6p6X2iCxy63rX6g==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20211209 64bit (built Dec  9
 2021))
 with ESMTP id <0R5O0047IH1K6V80@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 14 Jan 2022 02:17:44 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
To: akpm@linux-foundation.org, ocfs2-devel@oss.oracle.com
Date: Fri, 14 Jan 2022 10:16:41 +0800
Message-id: <20220114021641.13927-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-version: 1.0
X-Source-IP: 115.124.30.44
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10226
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 priorityscore=205 mlxscore=0 adultscore=0 bulkscore=0
 malwarescore=0 phishscore=0 clxscore=207 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201140013
 domainage_hfrom=8310
Cc: Minghao Chi <chi.minghao@zte.com.cn>, CGEL ZTE <cgel.zte@gmail.com>
Subject: [Ocfs2-devel] [PATCH] ocfs2: cleanup some return variables
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R191e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
 TI=SMTPD_---0V1mPsPk_1642126646;
X-ServerName: out30-44.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: LR6_qIDekTPDX4RVxrrZMElcxWmBUE75
X-Proofpoint-GUID: LR6_qIDekTPDX4RVxrrZMElcxWmBUE75
Reporting-Meta:
 AAHEaB9KXw+aRuEDkFEugn/M/0ZPYk7hy0dwtH3BEhROKDLtiOGzHO6ZQYQjl7hs
 Y6V1mAhLGMWY/BZlhcKE6zs3PorhaqSmcC5S8Rfjzk87ucq1v4EPk0nQvbmC0G0R
 xDB9m4pCfXy8KJuLMiaos54MmnpXn/OkTBiPrcrHMjnnnAPWyxJPdtqvQMFis5Ri
 440PNp/3LLlpvab2Cqn4mrlBq/eLe4H3pGnxBrmYCGENO3iIZNY799cz/YReJLJQ
 L5iZnvCAbd9iiSJfY7Ge48zfWmyGIXqceRXKdPHUnHnsbUFni0v/bbaVz+4DGcYa
 EL95sARKeUY8Jqq3iHFDBcsQVzhsVDDmD7a0z0VcSbWaqztkeiGEMnclCKfScsDh
 vGagF3pIacLApUMpZTFSi1Z0qOKuspBuh7cgD93VMlaX+vKd8yTI79t06Zueqe4R
 /xtDfz5y48rCik+rgqA5q7+M1LgWBZ9AQCEEjbkemHeqfkcfzxPY+MZTD6DVc8J1
 TKF7PeKUS9S6pmzRxRIsHmume74hrj+BZ/qKxZAhC8E2

Simply return directly instead of assign the return value to another
variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Cc: Minghao Chi <chi.minghao@zte.com.cn>
Cc: CGEL ZTE <cgel.zte@gmail.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/file.c       |  9 +++------
 fs/ocfs2/stack_user.c | 18 ++++++------------
 2 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index fc5f780fa235..24321c44cd42 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -540,15 +540,12 @@ int ocfs2_add_inode_data(struct ocfs2_super *osb,
 			 struct ocfs2_alloc_context *meta_ac,
 			 enum ocfs2_alloc_restarted *reason_ret)
 {
-	int ret;
 	struct ocfs2_extent_tree et;
 
 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), fe_bh);
-	ret = ocfs2_add_clusters_in_btree(handle, &et, logical_offset,
-					  clusters_to_add, mark_unwritten,
-					  data_ac, meta_ac, reason_ret);
-
-	return ret;
+	return ocfs2_add_clusters_in_btree(handle, &et, logical_offset,
+					   clusters_to_add, mark_unwritten,
+					   data_ac, meta_ac, reason_ret);
 }
 
 static int ocfs2_extend_allocation(struct inode *inode, u32 logical_start,
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 85a47621e0c0..a75e2b7d67f5 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -683,28 +683,22 @@ static int user_dlm_lock(struct ocfs2_cluster_connection *conn,
 			 void *name,
 			 unsigned int namelen)
 {
-	int ret;
-
 	if (!lksb->lksb_fsdlm.sb_lvbptr)
 		lksb->lksb_fsdlm.sb_lvbptr = (char *)lksb +
 					     sizeof(struct dlm_lksb);
 
-	ret = dlm_lock(conn->cc_lockspace, mode, &lksb->lksb_fsdlm,
-		       flags|DLM_LKF_NODLCKWT, name, namelen, 0,
-		       fsdlm_lock_ast_wrapper, lksb,
-		       fsdlm_blocking_ast_wrapper);
-	return ret;
+	return dlm_lock(conn->cc_lockspace, mode, &lksb->lksb_fsdlm,
+			flags|DLM_LKF_NODLCKWT, name, namelen, 0,
+			fsdlm_lock_ast_wrapper, lksb,
+			fsdlm_blocking_ast_wrapper);
 }
 
 static int user_dlm_unlock(struct ocfs2_cluster_connection *conn,
 			   struct ocfs2_dlm_lksb *lksb,
 			   u32 flags)
 {
-	int ret;
-
-	ret = dlm_unlock(conn->cc_lockspace, lksb->lksb_fsdlm.sb_lkid,
-			 flags, &lksb->lksb_fsdlm, lksb);
-	return ret;
+	return dlm_unlock(conn->cc_lockspace, lksb->lksb_fsdlm.sb_lkid,
+			  flags, &lksb->lksb_fsdlm, lksb);
 }
 
 static int user_dlm_lock_status(struct ocfs2_dlm_lksb *lksb)
-- 
2.19.1.6.gb485710b


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
