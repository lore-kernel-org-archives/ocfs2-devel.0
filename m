Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BFEBC433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 23 Mar 2022 02:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=SEWmMZRyxwDPFQCuPuQI9CU/gQSVlZpv3GJNpnCyal0=;
 b=wXnt21Ce8iNPGlvxOaCePHV38fO2MkbpNSG/AEBxVxjUg0gblWkin3pQu7nvLVxp0E1Y6ZOsie3+
   oRR5AojDe9SooeUZhHpQ6x8Hua16c//jLWxbeHEc86UOxyeLnzebu5jsJcyQcgA/nesUD4urEFKf
   O8FsXXwDI9hn/wbTqvg+m9jge2ble2DtwhwGHqFYfXRToYfsjZgKtEaMKrGGnNs8Oom2KFijEHmr
   vysFiAMtarkpcyi8nMnJLQj1n1rQ1dm4tuonm8zOAQfFd5cGuMR+UlqWuXl8pdi9/NnCzLQbot6g
   j+d3OrHOlwQ4Jp0G8T1I/H/VBD5O8jW3XUCVRA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=SEWmMZRyxwDPFQCuPuQI9CU/gQSVlZpv3GJNpnCyal0=;
 b=jjiaOhkU2I6Q6tVh2WcIApOmjQZ0sUgbOJ4Vn/ur+nVNgXYg0SwkSnDpEzsol1z7LLVK72aLfDxv
   bocbxa4Ln4FBeA2xA9KxGcsz5Pka2e6ZPej7NHbcBfzPVV0LwdWHmS6ZH/TTEZ9b1zbB/KwisCjF
   cshS7s1sdbml3DmWjywO7kWSiljoQxCYZp5PKcPQWUuGb3xH6wGXE0lfWrDv9ul8W3Qk+8z5OkvL
   qpElPYdio7a5ZL3pFY5kQwIKUZUmkwxKvommIN0ATMKRaW1j+F9yedVI+G36fdG7zg5onv7/Wz4o
   u76lUoJES5IZvgpdr5laekI1wyk8kMOpnSypMw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R9600BYFF9P8930@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 23 Mar 2022 02:37:01 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
To: Valentin Vidic <vvidic@valentin-vidic.from.hr>,
 Dayvison <sathlerds@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 23 Mar 2022 10:36:44 +0800
Message-id: <20220323023644.40084-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-version: 1.0
X-Source-IP: 115.124.30.54
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10294
 signatures=694350
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 clxscore=181 priorityscore=0 mlxscore=0 malwarescore=0 spamscore=0 bulkscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230012 domainage_hfrom=8378
Cc: Tuo Li <islituo@gmail.com>, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix crash when mount with quota enabled
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
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
 TI=SMTPD_---0V7z9RE7_1648003004;
X-ServerName: out30-54.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: SVN6C8z6nF1LyMbLxTsE1nASx4MgRXZo
X-Proofpoint-ORIG-GUID: SVN6C8z6nF1LyMbLxTsE1nASx4MgRXZo
Reporting-Meta:
 AAFHTfqBQUCjbHykBrWMZLcbhnSEeeve71aelxWsGKpbwuliwds0O7IebOSjJctb
 VPXcpih76zsXwQCA3Uq1Zu1EMq2N+vdSYJ4fPonV9+0WJlEeVGx+2kWv+e6myp/N
 YjEa319LEDlYrj6hwUQBY8lCBYf6nXxyOtcFiRyDniZ5cTXamdti82IkY/4ZdSsg
 xf0me0ScFkU9uDX1SBKHbfZFgq4kIpsCsjLrxaxOxbKdh2cfWLdveGOb/RtRX9+n
 VHVnjriPl62swUnQyV+Ay8qgRmvelhu0oYrnsk+/XAM5dDeAHUrh/eJvnuDOTAXZ
 uS9svbX8ZWhMnhUcvRsSZXFcFSZN5x7efBlpbidVgOf8TJ4kywBVjRL1UfHO+PgK
 bgeec3AKQ5HPoQQaTGX6BPHYbkTRYPOLt2e08PW2RtSIYE7eNlAt/GiXNSDnyC4x
 wqKq69xWKnaiCrOVzwU2SekegW9FRMcbC30TAyq8mozk+0VmXKkYQd417tPQm6E6
 SmWJOEXFZaaoP+CuJNwy1AFGTjq1f5UTVmCid0RfWQUJ

There is a reported crash when mount ocfs2 with quota enabled.

RIP: 0010:ocfs2_qinfo_lock_res_init+0x44/0x50 [ocfs2]
Call Trace:
<TASK>
ocfs2_local_read_info+0xb9/0x6f0 [ocfs2]
? ocfs2_local_check_quota_file+0x197/0x390 [ocfs2]
dquot_load_quota_sb+0x216/0x470
? preempt_count_add+0x68/0xa0
dquot_load_quota_inode+0x85/0x100
ocfs2_enable_quotas+0xa0/0x1c0 [ocfs2]
ocfs2_fill_super.cold+0xc8/0x1bf [ocfs2]
mount_bdev+0x185/0x1b0
? ocfs2_initialize_super.isra.0+0xf40/0xf40 [ocfs2]
legacy_get_tree+0x27/0x40
vfs_get_tree+0x25/0xb0
path_mount+0x465/0xac0
__x64_sys_mount+0x103/0x140
do_syscall_64+0x3b/0xc0
entry_SYSCALL_64_after_hwframe+0x44/0xae
</TASK>

It is caused by when initializing dqi_gqlock, the corresponding dqi_type
and dqi_sb are not properly initialized.
This issue is introduced by commit 6c85c2c72819, which wants to avoid
accessing uninitialized variables in error cases.
So make global quota info properly initialized.

Reported-by: Dayvison <sathlerds@gmail.com>
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1007141
Fixes: 6c85c2c72819 ("ocfs2: quota_local: fix possible uninitialized-variable access in ocfs2_local_read_info()")
Tested-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Cc: stable@vger.kernel.org
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/quota_global.c | 23 ++++++++++++-----------
 fs/ocfs2/quota_local.c  |  2 --
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index f033de733adb..effe92c7d693 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -337,7 +337,6 @@ void ocfs2_unlock_global_qf(struct ocfs2_mem_dqinfo *oinfo, int ex)
 /* Read information header from global quota file */
 int ocfs2_global_read_info(struct super_block *sb, int type)
 {
-	struct inode *gqinode = NULL;
 	unsigned int ino[OCFS2_MAXQUOTAS] = { USER_QUOTA_SYSTEM_INODE,
 					      GROUP_QUOTA_SYSTEM_INODE };
 	struct ocfs2_global_disk_dqinfo dinfo;
@@ -346,29 +345,31 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 	u64 pcount;
 	int status;
 
+	oinfo->dqi_gi.dqi_sb = sb;
+	oinfo->dqi_gi.dqi_type = type;
+	ocfs2_qinfo_lock_res_init(&oinfo->dqi_gqlock, oinfo);
+	oinfo->dqi_gi.dqi_entry_size = sizeof(struct ocfs2_global_disk_dqblk);
+	oinfo->dqi_gi.dqi_ops = &ocfs2_global_ops;
+	oinfo->dqi_gqi_bh = NULL;
+	oinfo->dqi_gqi_count = 0;
+
 	/* Read global header */
-	gqinode = ocfs2_get_system_file_inode(OCFS2_SB(sb), ino[type],
+	oinfo->dqi_gqinode = ocfs2_get_system_file_inode(OCFS2_SB(sb), ino[type],
 			OCFS2_INVALID_SLOT);
-	if (!gqinode) {
+	if (!oinfo->dqi_gqinode) {
 		mlog(ML_ERROR, "failed to get global quota inode (type=%d)\n",
 			type);
 		status = -EINVAL;
 		goto out_err;
 	}
-	oinfo->dqi_gi.dqi_sb = sb;
-	oinfo->dqi_gi.dqi_type = type;
-	oinfo->dqi_gi.dqi_entry_size = sizeof(struct ocfs2_global_disk_dqblk);
-	oinfo->dqi_gi.dqi_ops = &ocfs2_global_ops;
-	oinfo->dqi_gqi_bh = NULL;
-	oinfo->dqi_gqi_count = 0;
-	oinfo->dqi_gqinode = gqinode;
+
 	status = ocfs2_lock_global_qf(oinfo, 0);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out_err;
 	}
 
-	status = ocfs2_extent_map_get_blocks(gqinode, 0, &oinfo->dqi_giblk,
+	status = ocfs2_extent_map_get_blocks(oinfo->dqi_gqinode, 0, &oinfo->dqi_giblk,
 					     &pcount, NULL);
 	if (status < 0)
 		goto out_unlock;
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 0e4b16d4c037..b1a8b046f4c2 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -702,8 +702,6 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 	info->dqi_priv = oinfo;
 	oinfo->dqi_type = type;
 	INIT_LIST_HEAD(&oinfo->dqi_chunk);
-	oinfo->dqi_gqinode = NULL;
-	ocfs2_qinfo_lock_res_init(&oinfo->dqi_gqlock, oinfo);
 	oinfo->dqi_rec = NULL;
 	oinfo->dqi_lqi_bh = NULL;
 	oinfo->dqi_libh = NULL;
-- 
2.19.1.6.gb485710b


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
