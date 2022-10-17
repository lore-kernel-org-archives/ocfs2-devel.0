Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 515C9C433FE
	for <ocfs2-devel@archiver.kernel.org>; Mon, 17 Oct 2022 13:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=TjNOAbRCQKUzlyOQYlvDM/WGvpONrBsM3CMmRmzs0HI=;
 b=M5AX5c3nqpczLZ8myljoc2cHxd1CUEoIappFlOFcQI2XoJLf2hkBM05q58QuTYOM4BzRlwI65kPu
   tMztoDgZEqNxDX2dGxnSbqSV5WIaX/Tq/t/b4XkVsNevdtBbXmiVAWYVRBNxRWZMq4fSvkKEEyYV
   NMatVfc87eTvh4Jg6VrMFFeuo4N4HtdA832KB+lubz4R7nedszlmUZEycTpmT/5o3D28I9tStuyw
   4kjk35aErGiQZ6oB+GmHczNp1NHeZfvDLAhWF6sqPW7Ega0HkI+JkkF2Um475LODkC0n1fQMHaZm
   78T4wf0qYiFnTMXCZvZbkWRHJt5CVmVmW36xIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=TjNOAbRCQKUzlyOQYlvDM/WGvpONrBsM3CMmRmzs0HI=;
 b=m/N2kDiAxdkwDIv+0/xRI0PzuT4BZiVmmrbm+YUmUoORaK5ZCA2AxuCqpA8B5VrjlNkuosuAi/Xg
   mWLHgzbJZb1Z269J41QFoCRKak/opprUV9xXl1+LaNFCx2GQFSOECUd3cwCWtOKLmtwws2978/+4
   v/riM7dwU+bIIWWE0zd8y4OFIPG5344DPfSCHwxgnqHgpFBYZYvIXtvv8Ua0rtHxTckVRNtPyf5m
   5ov3WWqvmorCCv9hOaHhzc/tCiizgObzdKVk9J8Yysngrg4wGs8CSOyp5gHSaK/MTenXclSC+XkD
   OXsmJqp5Hv5sOYC9puS1jZoUs16erRqL7FHDmg==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RJW00G1WEWRUL20@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 17 Oct 2022 13:02:51 +0000 (GMT)
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 17 Oct 2022 21:02:26 +0800
Message-id: <20221017130227.234480-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-version: 1.0
X-Source-IP: 115.124.30.42
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10503
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 priorityscore=208 lowpriorityscore=0 bulkscore=0 impostorscore=0 phishscore=0
 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0 malwarescore=0 clxscore=100
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210170075 domainage_hfrom=8586
Cc: ocfs2-devel@oss.oracle.com, Yan Wang <wangyan122@huawei.com>
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: fix BUG when iput after	ocfs2_mknod
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R181e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045176;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VSOt2QZ_1666011747;
X-ServerName: out30-42.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: WQl3HksrzQkLVnVONLHzX58_zSyXzlxv
X-Proofpoint-GUID: WQl3HksrzQkLVnVONLHzX58_zSyXzlxv
Reporting-Meta:
 AAEPrev2N3yTpEOKx0Y9CsEcfL2+H7DwPD1yQLoptC73s6NGkUmbFIk+MG2s9FlK
 gzrE/9XxwjNj3hyX08kG5+cFRX1pSCVxCbTAq3qx/azioevzYAlb4A5bZz9yOkH/
 dBOEx9pYd6gwf+SYdZLDOXeGQo/Iu+WDbjMoOW+J62aILjczbq0+9NVMflA5djSl
 d5rKKAbWXNnEfgG8I1YHrqHiTQ1KA0nqu8UUS7TGNs1S5ifGVHJokkYpbwwvUVXx
 +fjENOVGpVaUJ987/cLlYc/s8ESV6z/MNERlyu6e1M5Xe9owEyAWZEJ51B5/Pink
 3CshCDfvclmxxznNjdyxsA9KcwM94iwVLGdo98HEWURPfbH2jP4t0iocXNpfElS/
 1aQEvjq3i5cj6miE2Vy7PJDKswc0OAwr/ndDIXOSqlafsFWlvo/6ABpIWpy7IpE+
 tIzTazs9+l+61ZuuWgMVqvL767/WnN36GkVQkHLyI1rYsOl0wEqMHXbzfmuLKKYW
 pnARubFOV7+C+vqdaXSMu8Ntf4Gzr3tNhEXJsFbtqL8=

Commit b1529a41f777 tried to reclaim the claimed inode if
__ocfs2_mknod_locked() fails later. But this introduce a race, the freed
bit may be reused immediately by another thread, which will update
dinode, e.g. i_generation. Then iput this inode will lead to BUG:
  inode->i_generation != le32_to_cpu(fe->i_generation)

We could make this inode as bad, but we did want to do operations like
wipe in some cases. Since the claimed inode bit can only affect that an
dinode is missing and will return back after fsck, it seems not a big
problem. So just leave it as is by revert the reclaim logic.

Fixes: b1529a41f777 ("ocfs2: should reclaim the inode if '__ocfs2_mknod_locked' returns an error")
Reported-by: Yan Wang <wangyan122@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/namei.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 961d1cf54388..1a97e167b219 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -632,18 +632,9 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 		return status;
 	}
 
-	status = __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
+	return __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
 				    parent_fe_bh, handle, inode_ac,
 				    fe_blkno, suballoc_loc, suballoc_bit);
-	if (status < 0) {
-		u64 bg_blkno = ocfs2_which_suballoc_group(fe_blkno, suballoc_bit);
-		int tmp = ocfs2_free_suballoc_bits(handle, inode_ac->ac_inode,
-				inode_ac->ac_bh, suballoc_bit, bg_blkno, 1);
-		if (tmp)
-			mlog_errno(tmp);
-	}
-
-	return status;
 }
 
 static int ocfs2_mkdir(struct user_namespace *mnt_userns,
-- 
2.24.4


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
