Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65BA0C4332F
	for <ocfs2-devel@archiver.kernel.org>; Mon, 17 Oct 2022 13:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pHrFAYb/W50YxhiH6+ZxAM2CRDNIj3n/fsp0/tE1uo0=;
 b=CkrjzieQS6dBK5YwMfLzeA8Q7PmWaKvsCgxSrZ9DnOGA9LHrQ2NZccHCJCuNwOln9O3XI04G9B9m
   i9T39i0i4M1iLKA6+W80C5r8TN2ORm6T3iyQLLjL0hoWKOiAb5QJ9yddDRYhUVOxj7MkEPg6UCfD
   GK4sFOnCItpkqJcz/B87jNx5KdyB8gepq8zbWLxYOZnIHOXxVwdcEiYGd/6QeYZdXfuCvRtxL7Mz
   fLHdHDqNj0Cj/FTSKFeletOZQMpXI12LdptdAi7sVp7RYarko6XcPldjCarZ48j0KhZjVKAp0R9g
   ZlHNqlHJ38eLP+9asnBT3SYg1+LCdMcT8cjkPg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pHrFAYb/W50YxhiH6+ZxAM2CRDNIj3n/fsp0/tE1uo0=;
 b=g0z7AJvAGCkVDiwZp0E1dare4EPoSTn4Jx7mKCKUW2MDDK8Mi+64IkXHcvXbij9JzAFeUGmVNrG3
   SEVF7OZ/JD/Sb7LwvVQGNqMqUpgeJSdXeRHFc0OqG7CHu9Kjg9QhSdeifG9vpQi4euD2daND9ad1
   Jd1K5Psl/KhF+PL7JMq833RaRXNXupOmeXonX4VrPFtQ1RHldbHGR0MWrdJ+w6j5t1M48/KynGzw
   1BBRZd6SJlxY4OEgwo/fqaf/YL8Gb4SjkZG3GcRipS7XC4jYU0KJqPT7/scnfK5IvFGXuRoDoH9b
   7CKGknldINkb3SD903yDn5u88IoqQKqlxLs9Ug==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RJW00C3UEWTVID0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 17 Oct 2022 13:02:53 +0000 (GMT)
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 17 Oct 2022 21:02:27 +0800
Message-id: <20221017130227.234480-2-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-reply-to: <20221017130227.234480-1-joseph.qi@linux.alibaba.com>
References: <20221017130227.234480-1-joseph.qi@linux.alibaba.com>
MIME-version: 1.0
X-Source-IP: 115.124.30.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10503
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=-81 impostorscore=0 malwarescore=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210170075
 domainage_hfrom=8586
Cc: ocfs2-devel@oss.oracle.com, Yan Wang <wangyan122@huawei.com>
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: clear dinode links count in case	of
 error
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R111e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046049;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VSPlz3b_1666011749;
X-ServerName: out30-133.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: qdxZINMNy2q2EctHOzsyPKW-r0zmQXJe
X-Proofpoint-GUID: qdxZINMNy2q2EctHOzsyPKW-r0zmQXJe
Reporting-Meta:
 AAGQLFQ6DAZPtMzlvA60rUpXc9Yu4lZnZXT7Bm6OnO9s0CNOjtSnGm/0O7Z/Mf3z
 EyOs2a98aDzQqzLG1lCIxFhiv+CiT6ffNqCebIluYVw3wDDsL5Vo3erZjin31aAh
 l72L+z48o/sbD3NajxHtspRZxe3NFP3dSxeEjXSgsH0Z5Op/bNfspSg1Ik8wrueV
 RbD41GRR874XJey0rIHgu6mBuLuUEagHsv/gFJDK2PSjEjbLtvImX78+Y3j1uir2
 WRQCrmtQ1hKF6D3fU+kXnb6sPzrDnQXdXMU5s5ZSVlSgaGzJmPR9qpxjtQvYSyDz
 pvL6XGRn9/5cv1OC2FHtZBmaxAgRGaOrwLKQmUiXaigl44L+Ld7+PtRb+bvaEDPi
 B48B41xNwhDyVFOZ4N/w/KegmB9i8/7/b1ca5TBpOJYvOjB9wIVb17XnrjQpXnYF
 7QPHEwzy5lcrhqDXD1KvNcRdPSzzxz60ezCP+9ynmk49FTemaVcRLGWLxmXstXx3
 2RitNFADW2wXCm6aWF1Y0yxAmKpeVUxJy0Atwgk24s4=

In ocfs2_mknod(), if error occurs after dinode successfully allocated,
ocfs2 i_links_count will not be 0.
So even we clear inode i_nlink before iput in error handling, it still
won't wipe inode since we'll refresh inode from dinode during inode
lock. So just like clear inode i_nlink, we clear ocfs2 i_links_count as
well.
Also do the same change for ocfs2_symlink().

Reported-by: Yan Wang <wangyan122@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/namei.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 1a97e167b219..05f32989bad6 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -232,6 +232,7 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
 	handle_t *handle = NULL;
 	struct ocfs2_super *osb;
 	struct ocfs2_dinode *dirfe;
+	struct ocfs2_dinode *fe = NULL;
 	struct buffer_head *new_fe_bh = NULL;
 	struct inode *inode = NULL;
 	struct ocfs2_alloc_context *inode_ac = NULL;
@@ -382,6 +383,7 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
 		goto leave;
 	}
 
+	fe = (struct ocfs2_dinode *) new_fe_bh->b_data;
 	if (S_ISDIR(mode)) {
 		status = ocfs2_fill_new_dir(osb, handle, dir, inode,
 					    new_fe_bh, data_ac, meta_ac);
@@ -454,8 +456,11 @@ static int ocfs2_mknod(struct user_namespace *mnt_userns,
 leave:
 	if (status < 0 && did_quota_inode)
 		dquot_free_inode(inode);
-	if (handle)
+	if (handle) {
+		if (status < 0 && fe)
+			ocfs2_set_links_count(fe, 0);
 		ocfs2_commit_trans(osb, handle);
+	}
 
 	ocfs2_inode_unlock(dir, 1);
 	if (did_block_signals)
@@ -2019,8 +2024,11 @@ static int ocfs2_symlink(struct user_namespace *mnt_userns,
 					ocfs2_clusters_to_bytes(osb->sb, 1));
 	if (status < 0 && did_quota_inode)
 		dquot_free_inode(inode);
-	if (handle)
+	if (handle) {
+		if (status < 0 && fe)
+			ocfs2_set_links_count(fe, 0);
 		ocfs2_commit_trans(osb, handle);
+	}
 
 	ocfs2_inode_unlock(dir, 1);
 	if (did_block_signals)
-- 
2.24.4


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
