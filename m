Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11DCAC77B72
	for <ocfs2-devel@archiver.kernel.org>; Mon, 17 Apr 2023 21:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RZyqJKnJKkseFFGOiO2lflpIR24p/LKk84y2uMUtMGY=;
 b=jaxfpTAmWEQML8kTckAi1X/Iz5dOgUy8oXuEuvnpulrDl7l+bGbt4kjHp1uXw/d2CEmFieAsWgH3
   Ilr6z+30OyjFgnYq2esgDGkv9O/Cku2lm/K9S2O4dTgQPxxkb1md31UnB5Zx23NNyq3cGpZPghGN
   /J3DwNtbxdnPoo2xQ8BNEjmdyhKIGHJ2xKhy7pEDqA96LRDgqB4GNyduqBFB2Gk0PHQC3wTiSgc7
   no0lTik/IqqXanPPE+sj5TTv23iS9ERpmnXa8To3qL9vx38WpfnRXY5c59JJwJWPMAus2Sqw2+go
   mRjSeguD1RRTSWNjrzaYK9z9RwxiUb0fBCPBHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RZyqJKnJKkseFFGOiO2lflpIR24p/LKk84y2uMUtMGY=;
 b=bhXbf82cGVrVzTwP6dXlhXA1lJWej8e82dTYtOq/G9uXvWRaqRWCRks4LwhAzXCXHm2vMAdGL3TU
   n9x48CRUaH+0QfZXfy5IfsPhxYml7k/EKYV3V7jMrb9uTy86QarX9jSYX183qigRw9p9k2FGE7pF
   FOC9UKMx4iXsfUeF1+44GN+FT4MVV4LTDZ5ATF7p/21IMwza5YU4cSFXFI1wX8LS64wD5gObhnKV
   SmUtciPcZ+dm6GoLj7wzTquGlkU3JpOc9GN2SsIfBZejk9ug+nuAcI44xN45HWdGlWXNNyjj15cw
   7cB1MsiD3ZrsJJL9Mi+zb0iYEmjuNc/kx7fEOg==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230331 64bit (built Mar 31
 2023))
 with ESMTPS id <0RTA00KQO3G04660@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 17 Apr 2023 21:24:00 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1681764996; bh=0+A/sy/nKjWGdM2ei3CM0vIESLpQzczKIP5odrvO/rI=;
 h=From:To:Cc:Subject:Date:From;
 b=N1XAB+9dQnTChAkENPua0gGLRD1ygRlXZAODcMKunV80KTpADPPha0Ms9qvO89yBP
 iZFljBQx+99yKfwsx0Bz02t8h0s+IYOEHXu0G/z9MNnErNFsyqv3wVMQwBwfjyaH/M
 GmDy0n3fgcz3yoXf0sPN1j6c0UtyiLOo2WLE1ubYP+vu9IBtPn2KvH3O1dMjn1hH6o
 mB1KWFdSbFPQjEm7RoXrYREQg4lj/dOAPxrWlhI3+RFCvJhiKD6hkxlXHp55mWZPWH
 mccVhdsGyG+/GEdkjhfp27vMD8AvB8r2xXnMdQ39drve81rc8/mVksozX+h1r/WlH5
 nUpO064QicxEg==
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Mon, 17 Apr 2023 22:56:24 +0200
Message-id: <20230417205631.1956027-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10683
 signatures=596816
Cc: Jens Axboe <axboe@kernel.dk>,
 =?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
 Arnd Bergmann <arnd@arndb.de>, Christian Brauner <brauner@kernel.org>,
 linux-kernel@vger.kernel.org, =?UTF-8?q?Christoph=20B=C3=B6hmwalder?=
 <christoph.boehmwalder@linbit.com>, David Sterba <dsterba@suse.com>,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: reduce ioctl stack usage
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
From: Arnd Bergmann via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Arnd Bergmann <arnd@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-ORIG-GUID: F3L_lkqnT9ktmbbDPRKFgt-QF_2UBjtN
X-Proofpoint-GUID: F3L_lkqnT9ktmbbDPRKFgt-QF_2UBjtN
X-Mailman-Approved-At: Mon, 17 Apr 2023 21:23:58 +0000
Reporting-Meta:
 AAGrAOzz9pXUbPb2FNAdQV2ONXgKigMUFlU7KUVoMfpwWULI9sG6X5GywVxoSUmE
 rR0SXlVIagnt6VGYLeQrGepXHkAvK58kOhgECwEHrX9NiDoJTam7ErNUMf7tEu5M
 RYMEIK//BERKCeeuGWEuLpYhGRi1rkoM8DYCDN1WvY9S3prn9rVJ4su0I+0Wkz88
 Zy8kOi4iFi/D3WNV3niS9iZzLRbt2ygCIW/ZHZ7lSsNCpNsoPbGqM2F08OlTs/JT
 hEPClygTza0b1nXa1kdIFRBrCqHYFqvonlbKx/ZV/nkqmgW1qZjJxsFbyv87F5Vp
 1uWHcgA2GMp7KlYUnfzoTAn2SFCmzIQ3aKTz9oHxCABCV+ZzfHwJEqZyCTxGLFvZ
 NbrbIzh+YuYMujjD8pbA+yLf90ZoOVuXFVx0Kk9Y0Zi7Xk23KOICZC9nCvxv/cLU
 dpgPCc1+HrbfuOPOfGPHdcbZ7w/VhMLYIHjLk87qSPuKF0mI78/zQO3iDyDcUvzP
 NVn02e/YZVw2PyUBKfIQZIOdQUxjLSabJdo+HV5pd4PM

From: Arnd Bergmann <arnd@arndb.de>

On 32-bit architectures with KASAN_STACK enabled, the total stack usage
of the ocfs2_ioctl function grows beyond the warning limit:

fs/ocfs2/ioctl.c: In function 'ocfs2_ioctl':
fs/ocfs2/ioctl.c:934:1: error: the frame size of 1448 bytes is larger than 1400 bytes [-Werror=frame-larger-than=]

Move each of the variables into a basic block, and mark ocfs2_info_handle()
as noinline_for_stack, in order to have the variable share stack slots.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/ocfs2/ioctl.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 811a6ea374bb..b1550ba73f96 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -803,8 +803,8 @@ static int ocfs2_get_request_ptr(struct ocfs2_info *info, int idx,
  * a better backward&forward compatibility, since a small piece of
  * request will be less likely to be broken if disk layout get changed.
  */
-static int ocfs2_info_handle(struct inode *inode, struct ocfs2_info *info,
-			     int compat_flag)
+static noinline_for_stack int
+ocfs2_info_handle(struct inode *inode, struct ocfs2_info *info, int compat_flag)
 {
 	int i, status = 0;
 	u64 req_addr;
@@ -840,27 +840,26 @@ static int ocfs2_info_handle(struct inode *inode, struct ocfs2_info *info,
 long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
-	int new_clusters;
-	int status;
-	struct ocfs2_space_resv sr;
-	struct ocfs2_new_group_input input;
-	struct reflink_arguments args;
-	const char __user *old_path;
-	const char __user *new_path;
-	bool preserve;
-	struct ocfs2_info info;
 	void __user *argp = (void __user *)arg;
+	int status;
 
 	switch (cmd) {
 	case OCFS2_IOC_RESVSP:
 	case OCFS2_IOC_RESVSP64:
 	case OCFS2_IOC_UNRESVSP:
 	case OCFS2_IOC_UNRESVSP64:
+	{
+		struct ocfs2_space_resv sr;
+
 		if (copy_from_user(&sr, (int __user *) arg, sizeof(sr)))
 			return -EFAULT;
 
 		return ocfs2_change_file_space(filp, cmd, &sr);
+	}
 	case OCFS2_IOC_GROUP_EXTEND:
+	{
+		int new_clusters;
+
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
 
@@ -873,8 +872,12 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		status = ocfs2_group_extend(inode, new_clusters);
 		mnt_drop_write_file(filp);
 		return status;
+	}
 	case OCFS2_IOC_GROUP_ADD:
 	case OCFS2_IOC_GROUP_ADD64:
+	{
+		struct ocfs2_new_group_input input;
+
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
 
@@ -887,7 +890,14 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		status = ocfs2_group_add(inode, &input);
 		mnt_drop_write_file(filp);
 		return status;
+	}
 	case OCFS2_IOC_REFLINK:
+	{
+		struct reflink_arguments args;
+		const char __user *old_path;
+		const char __user *new_path;
+		bool preserve;
+
 		if (copy_from_user(&args, argp, sizeof(args)))
 			return -EFAULT;
 		old_path = (const char __user *)(unsigned long)args.old_path;
@@ -895,11 +905,16 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		preserve = (args.preserve != 0);
 
 		return ocfs2_reflink_ioctl(inode, old_path, new_path, preserve);
+	}
 	case OCFS2_IOC_INFO:
+	{
+		struct ocfs2_info info;
+
 		if (copy_from_user(&info, argp, sizeof(struct ocfs2_info)))
 			return -EFAULT;
 
 		return ocfs2_info_handle(inode, &info, 0);
+	}
 	case FITRIM:
 	{
 		struct super_block *sb = inode->i_sb;
-- 
2.39.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
