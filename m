Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54175C43334
	for <ocfs2-devel@archiver.kernel.org>; Fri,  3 Jun 2022 22:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5FrTTw5PwUZFurSP073OClhy/U3EARxq3WncYqpc6xM=;
 b=G7hb7xlDxVLvaheACTfnHdwx/gP2j/H395eP9vhyV5a7YXSm/nY0bWhA/IogZyguBXt9JQ7iYS79
   PnCr3uObvG2UB7+lfRIZNkQmb/NRGBIVQW/0UeoL9q8nBFaP3ebIa+eeCBJHqQ08VBzZwcq6WRdu
   7CYcAAbc8EfK/o5BF6/8qnd0va5teKz9aobk3TROJPJRRg6RX/0zLnFe/K9lnmi0D1Ph50kiDOXN
   +h++Sa70bPvRZtiCqdISSyO8a1qthyZ9mVVqfQE8kIn4X2m8bKWgwTvNrfucqi1BeJXYbwh96xtc
   LIzYN+m1YNkC4CyvFwGGuMngGACu9xzN++P6Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5FrTTw5PwUZFurSP073OClhy/U3EARxq3WncYqpc6xM=;
 b=mU1SKQNnOz55srb+OkENVLaKKesWIh5pEJKkFSYTqNSoliM2zRpeqqgXzD2BxehJu2G/8PL79jhJ
   Sbmv5KYY73S00CTmHoo1KCeWRivsW0aSuBtUPiAXdnhccTzm1el20Gx/jHmoPwiMKQzVEP/gark/
   diQ69qnQ26KG41f94rEnIydmt4FPxbt3rGFll+CBJt6zDvKRvEl5f31TFxrsBR30J2bz4mLRjc7r
   Hm/qxgEjxt5QcGcxmVUcqxX85X8SNiEmy1psoJrtVHfOA/vM1eWYTfkKWsVx4V6Xbp83P2TFi+Fn
   JNAxX8r/H4yHjn3BDzqp0jZ5Owm6V3x7i9uYRA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RCX00OMWAF3NW00@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 03 Jun 2022 22:28:15 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to
 : cc : subject : date : message-id : content-transfer-encoding : content-type
 : mime-version; s=corp-2021-07-09;
 bh=IgfjhP/lKQHjEi1RMFMzTK9gKIE0dM0jsRZ/58IVeY8=;
 b=PjBXdfASep/MlDeobuyGkCD4EXaIIqOuIbwY9aUnfsAMyPrMO++NYplcRN50vKwlk/KQ
 oL/ZqFV76XY0EDZPVg5uSk0TG+hdx0IcDHjz0PFVxNeAORURDyEsT19ESWvg1zCXruiO
 npFC19+GUdBqs8EoZUaKqDXO8WrJJ8KnW8uuSXpxW0OD4VsRhSWk72Xcaa7zjH5U4+kM
 m4N+a5YbZ2F6UIR5IBOe5SN3XTzJvfnR6BDnGSDRunPEajGm8BiXAFrqvuP9Pm7gUUnu
 rBrsKPk8WzYNXaRnLPkG/XvRtYDPsvPp4dwZc1SHREC6FumgKEHLn56wr+x6zoKehq7c ew==
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LUcxejxqge4Mhmytw+/yJ97w6zyh/l2DM4QFNbuAk/q+Ux9aReZk6L0PZ8WQUiDQRChrWuzWfgI9FfnD8N3FnCp2VWybJ+L47Abj29+pKWVVDYL2D26pDGI5MkNMbHhJQfFZzhAJRBwaS+3nxX0Qr621tbFWrv9LCiyYTpWhxxuy8YK+bU/XniJClm9tglQCkNINNuhSk0xlJy9bwfAX8yP0TBLyoBZdWAMGvI/VERf3nPqwEC5Dtpuu97MBS7lMuqB8xcjNBxYwWfHmMaVINcAyS+GNCFoQHHZbO0H1E+6mkiz9PI+PmMEKJkVcLHzz8TtpRH9wyyq0kkhMh6yEnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IgfjhP/lKQHjEi1RMFMzTK9gKIE0dM0jsRZ/58IVeY8=;
 b=ic8LkzooClHVW/uSfei7Ix6jEzWHxGGk9+Dg8EsiHUUbrZ0FuV627915MYY+/Zp/1+rnsDLpJmeA/pmGOxzQFdP4FWhg3jlGcV29dTwxZY0g2wMszCcn3LVQomGq+L7o4NisAvC0sORk5PPzzFKMUgmvnMhwWeRl4SYhqxX3ae4TbEBjBPhKrfpc8Tez0SghSzVKLYVnyZ1y6yxzwW87pSSlyEXxQE81JK+UMNyAaJrwZU1LDb62ytdLElHeoccSgvK7X1wiMESZnT4FteXtS3lHVcfv0QdrDnW+byVT6OyRqtaxLzpjxLAw5C5RIXr4LVBBdy+tlDZpGREqbQ4+Kw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IgfjhP/lKQHjEi1RMFMzTK9gKIE0dM0jsRZ/58IVeY8=;
 b=hl6GzzEu3ezmvcj5wS9O2aU/lQAHdtZ4hs8+CSwQnyO9jLbnhuinFHpRUrkLBuXBjKUpPmLXp/vCPkZh4/YnHNmNFUuOdfpC+PTMjGvNaWbZ0cfLeZzRpZNVDgM8rTOqo3l22fXW0PAX7Ed1bU3l74d4049xP8LLxfj1GyGgsMw=
To: ocfs2-devel@oss.oracle.com
Date: Fri,  3 Jun 2022 15:28:01 -0700
Message-id: <20220603222801.42488-1-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 22:28:04.0025 (UTC)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,
 18.0.874 definitions=2022-06-03_08:2022-06-02, 2022-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030088
Subject: [Ocfs2-devel] [PATCH] Revert
 "ocfs2: mount shared volume without ha	stack"
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
From: Junxiao Bi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Junxiao Bi <junxiao.bi@oracle.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: SJ0PR05CA0160.namprd05.prod.outlook.com
 (2603:10b6:a03:339::15) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8100e114-9cb4-4968-a855-08da45b05316
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 EwwXU9R132tJSdST2Nc3SyqumcXuFFgqcLCbMHA59wlg5MYJNDtJsAvaWszXMM0/mGQlJD7/PIn7aSRkBZ1nFjQfUx485nqrKokw1fPPvI3xM5J/LYf+XntgceCGJIbwj8zDsSlTiDJkgVh4MvqqGSnhlnS8qMntCtfoMlquWKsa11YHNFugN0wNCwwTQ5+/3YfBKawLP/BXzzeG9u+lqlRJ4sBpp6uLRzhsC+SVNiM468uK10Z7U/p9KjnBXL0wjKg+BDlV1Uw/nTBFj8Wcy+OKv6yjSpFW/P5zAo5BBdO3zpba7UhvK7HiPlMJjUg0om2gT10WmoDlJh3lUGlionIigUQtmZ7yMV0bkFXY7Qa5Kx4tLkZBeEujd5Y4gxtbj3s0hXC2pTRiBELvRiIkaRb2w2mP8aa7PdWoHWmFDgd+G9B22546NlRVJwBi90y8cdbScQdD/lm5Vkh4CsZv31oC47ioi2JsZEKY+LiBYLpUQpdD51ZNavkcwXH0j/tbREmBwydKFGu6H3kIlFWsfsIUWxsjKmU0Ls+o2daDGGGDBC7U51L9GaVbfIzdjp5bwstahzrIOwGla3+e5jLXCLqc6FqfHWnorvzyp8CyNrs=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 8100e114-9cb4-4968-a855-08da45b05316
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 knvvJA7hjaoG7QSyh0V9MTH8tDBWf9AVbJ3phI2Pfa/aHROFQDBRlL158FJeFoAdDjtAep6920EdGB/+S69Vlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5128
X-Proofpoint-GUID: NlrZ5dSau_HtTACa4rBqCfFCkoiWz7vz
X-Proofpoint-ORIG-GUID: NlrZ5dSau_HtTACa4rBqCfFCkoiWz7vz
Reporting-Meta:
 AAFJ00xwt72T3WVP1ZVM3O1t9lrW+mxaaOsZO6Kke+sbK1JuPhA1tgY//juhL5Hq
 LOx7qcu3dXOsKhlSXxOJvwLDACyzW+R17E8m/BOhHr6y6xzwWbYBrQnZDawbfS9b
 2Qf4O+E31ddOt8E7f3+BJACDhEqwUH1yuPXCLse+UvgCMAuj8giDla+WzYnNi7TU
 Zj/O5mhviyPqtxJEnv52uG9FOsJ6SbnL2lhzuNb1kim8rZfxAsZYEarRqsR2uI0P
 5+2uT0qbV7Orr5zXpGipKwTg77wg5lQmDttqv+jUWXlEMs446+rToqfPJrDUn1DZ
 e+AIF4FyGacKS2gC71bSwdPA0sEUoOPnqPyYhSYVMINiHYm3o91sayr4BfG7iiTs
 HNn81xIb1D63+oetXJpTE9wpzSc+3sm3BpyOKo/e5cE+KBNU/Gd+i8zFnsPu1U87
 IX2DK6+fi7rkVoEt+bjmp9R+SKnYoXEwFbvy67j2ePOIXxGQbDFbQ6nVDXMXNfeA
 vCoR4XHW7v7qUltKKF/7KhOu6+VYBEhHGhIjy8wWUok/

This reverts commit 912f655d78c5d4ad05eac287f23a435924df7144.

This commit introduced a regression that can cause mount hung.
The changes in __ocfs2_find_empty_slot causes that any node with
none-zero node number can grab the slot that was already taken by
node 0, so node 1 will access the same journal with node 0, when it
try to grab journal cluster lock, it will hung because it was already
acquired by node 0.
It's very easy to reproduce this, in one cluster, mount node 0 first,
then node 1, you will see the following call trace from node 1.

[13148.735424] INFO: task mount.ocfs2:53045 blocked for more than 122 seconds.
[13148.739691]       Not tainted 5.15.0-2148.0.4.el8uek.mountracev2.x86_64 #2
[13148.742560] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[13148.745846] task:mount.ocfs2     state:D stack:    0 pid:53045 ppid: 53044 flags:0x00004000
[13148.749354] Call Trace:
[13148.750718]  <TASK>
[13148.752019]  ? usleep_range+0x90/0x89
[13148.753882]  __schedule+0x210/0x567
[13148.755684]  schedule+0x44/0xa8
[13148.757270]  schedule_timeout+0x106/0x13c
[13148.759273]  ? __prepare_to_swait+0x53/0x78
[13148.761218]  __wait_for_common+0xae/0x163
[13148.763144]  __ocfs2_cluster_lock.constprop.0+0x1d6/0x870 [ocfs2]
[13148.765780]  ? ocfs2_inode_lock_full_nested+0x18d/0x398 [ocfs2]
[13148.768312]  ocfs2_inode_lock_full_nested+0x18d/0x398 [ocfs2]
[13148.770968]  ocfs2_journal_init+0x91/0x340 [ocfs2]
[13148.773202]  ocfs2_check_volume+0x39/0x461 [ocfs2]
[13148.775401]  ? iput+0x69/0xba
[13148.777047]  ocfs2_mount_volume.isra.0.cold+0x40/0x1f5 [ocfs2]
[13148.779646]  ocfs2_fill_super+0x54b/0x853 [ocfs2]
[13148.781756]  mount_bdev+0x190/0x1b7
[13148.783443]  ? ocfs2_remount+0x440/0x440 [ocfs2]
[13148.785634]  legacy_get_tree+0x27/0x48
[13148.787466]  vfs_get_tree+0x25/0xd0
[13148.789270]  do_new_mount+0x18c/0x2d9
[13148.791046]  __x64_sys_mount+0x10e/0x142
[13148.792911]  do_syscall_64+0x3b/0x89
[13148.794667]  entry_SYSCALL_64_after_hwframe+0x170/0x0
[13148.797051] RIP: 0033:0x7f2309f6e26e
[13148.798784] RSP: 002b:00007ffdcee7d408 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
[13148.801974] RAX: ffffffffffffffda RBX: 00007ffdcee7d4a0 RCX: 00007f2309f6e26e
[13148.804815] RDX: 0000559aa762a8ae RSI: 0000559aa939d340 RDI: 0000559aa93a22b0
[13148.807719] RBP: 00007ffdcee7d5b0 R08: 0000559aa93a2290 R09: 00007f230a0b4820
[13148.810659] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffdcee7d420
[13148.813609] R13: 0000000000000000 R14: 0000559aa939f000 R15: 0000000000000000
[13148.816564]  </TASK>

To fix it, we can just fix __ocfs2_find_empty_slot. But original commit
introduced the feature to mount ocfs2 locally even it is cluster based,
that is a very dangerous, it can easily cause serious data corruption,
there is no way to stop other nodes mounting the fs and corrupting it.
Setup ha or other cluster-aware stack is just the cost that we have to
take for avoiding corruption, otherwise we have to do it in kernel.

Fixes: 912f655d78c5("ocfs2: mount shared volume without ha stack")
Cc: <stable@vger.kernel.org>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/ocfs2.h    |  4 +---
 fs/ocfs2/slot_map.c | 46 +++++++++++++++++++--------------------------
 fs/ocfs2/super.c    | 21 ---------------------
 3 files changed, 20 insertions(+), 51 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 337527571461..740b64238312 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -277,7 +277,6 @@ enum ocfs2_mount_options
 	OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT = 1 << 15,  /* Journal Async Commit */
 	OCFS2_MOUNT_ERRORS_CONT = 1 << 16, /* Return EIO to the calling process on error */
 	OCFS2_MOUNT_ERRORS_ROFS = 1 << 17, /* Change filesystem to read-only on error */
-	OCFS2_MOUNT_NOCLUSTER = 1 << 18, /* No cluster aware filesystem mount */
 };
 
 #define OCFS2_OSB_SOFT_RO	0x0001
@@ -673,8 +672,7 @@ static inline int ocfs2_cluster_o2cb_global_heartbeat(struct ocfs2_super *osb)
 
 static inline int ocfs2_mount_local(struct ocfs2_super *osb)
 {
-	return ((osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT)
-		|| (osb->s_mount_opt & OCFS2_MOUNT_NOCLUSTER));
+	return (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT);
 }
 
 static inline int ocfs2_uses_extended_slot_map(struct ocfs2_super *osb)
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index 0b0ae3ebb0cf..da7718cef735 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -252,16 +252,14 @@ static int __ocfs2_find_empty_slot(struct ocfs2_slot_info *si,
 	int i, ret = -ENOSPC;
 
 	if ((preferred >= 0) && (preferred < si->si_num_slots)) {
-		if (!si->si_slots[preferred].sl_valid ||
-		    !si->si_slots[preferred].sl_node_num) {
+		if (!si->si_slots[preferred].sl_valid) {
 			ret = preferred;
 			goto out;
 		}
 	}
 
 	for(i = 0; i < si->si_num_slots; i++) {
-		if (!si->si_slots[i].sl_valid ||
-		    !si->si_slots[i].sl_node_num) {
+		if (!si->si_slots[i].sl_valid) {
 			ret = i;
 			break;
 		}
@@ -456,30 +454,24 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
 	spin_lock(&osb->osb_lock);
 	ocfs2_update_slot_info(si);
 
-	if (ocfs2_mount_local(osb))
-		/* use slot 0 directly in local mode */
-		slot = 0;
-	else {
-		/* search for ourselves first and take the slot if it already
-		 * exists. Perhaps we need to mark this in a variable for our
-		 * own journal recovery? Possibly not, though we certainly
-		 * need to warn to the user */
-		slot = __ocfs2_node_num_to_slot(si, osb->node_num);
+	/* search for ourselves first and take the slot if it already
+	 * exists. Perhaps we need to mark this in a variable for our
+	 * own journal recovery? Possibly not, though we certainly
+	 * need to warn to the user */
+	slot = __ocfs2_node_num_to_slot(si, osb->node_num);
+	if (slot < 0) {
+		/* if no slot yet, then just take 1st available
+		 * one. */
+		slot = __ocfs2_find_empty_slot(si, osb->preferred_slot);
 		if (slot < 0) {
-			/* if no slot yet, then just take 1st available
-			 * one. */
-			slot = __ocfs2_find_empty_slot(si, osb->preferred_slot);
-			if (slot < 0) {
-				spin_unlock(&osb->osb_lock);
-				mlog(ML_ERROR, "no free slots available!\n");
-				status = -EINVAL;
-				goto bail;
-			}
-		} else
-			printk(KERN_INFO "ocfs2: Slot %d on device (%s) was "
-			       "already allocated to this node!\n",
-			       slot, osb->dev_str);
-	}
+			spin_unlock(&osb->osb_lock);
+			mlog(ML_ERROR, "no free slots available!\n");
+			status = -EINVAL;
+			goto bail;
+		}
+	} else
+		printk(KERN_INFO "ocfs2: Slot %d on device (%s) was already "
+		       "allocated to this node!\n", slot, osb->dev_str);
 
 	ocfs2_set_slot(si, slot, osb->node_num);
 	osb->slot_num = slot;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index f7298816d8d9..438be028935d 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -172,7 +172,6 @@ enum {
 	Opt_dir_resv_level,
 	Opt_journal_async_commit,
 	Opt_err_cont,
-	Opt_nocluster,
 	Opt_err,
 };
 
@@ -206,7 +205,6 @@ static const match_table_t tokens = {
 	{Opt_dir_resv_level, "dir_resv_level=%u"},
 	{Opt_journal_async_commit, "journal_async_commit"},
 	{Opt_err_cont, "errors=continue"},
-	{Opt_nocluster, "nocluster"},
 	{Opt_err, NULL}
 };
 
@@ -618,13 +616,6 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 		goto out;
 	}
 
-	tmp = OCFS2_MOUNT_NOCLUSTER;
-	if ((osb->s_mount_opt & tmp) != (parsed_options.mount_opt & tmp)) {
-		ret = -EINVAL;
-		mlog(ML_ERROR, "Cannot change nocluster option on remount\n");
-		goto out;
-	}
-
 	tmp = OCFS2_MOUNT_HB_LOCAL | OCFS2_MOUNT_HB_GLOBAL |
 		OCFS2_MOUNT_HB_NONE;
 	if ((osb->s_mount_opt & tmp) != (parsed_options.mount_opt & tmp)) {
@@ -865,7 +856,6 @@ static int ocfs2_verify_userspace_stack(struct ocfs2_super *osb,
 	}
 
 	if (ocfs2_userspace_stack(osb) &&
-	    !(osb->s_mount_opt & OCFS2_MOUNT_NOCLUSTER) &&
 	    strncmp(osb->osb_cluster_stack, mopt->cluster_stack,
 		    OCFS2_STACK_LABEL_LEN)) {
 		mlog(ML_ERROR,
@@ -1137,11 +1127,6 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	       osb->s_mount_opt & OCFS2_MOUNT_DATA_WRITEBACK ? "writeback" :
 	       "ordered");
 
-	if ((osb->s_mount_opt & OCFS2_MOUNT_NOCLUSTER) &&
-	   !(osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT))
-		printk(KERN_NOTICE "ocfs2: The shared device (%s) is mounted "
-		       "without cluster aware mode.\n", osb->dev_str);
-
 	atomic_set(&osb->vol_state, VOLUME_MOUNTED);
 	wake_up(&osb->osb_mount_event);
 
@@ -1452,9 +1437,6 @@ static int ocfs2_parse_options(struct super_block *sb,
 		case Opt_journal_async_commit:
 			mopt->mount_opt |= OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT;
 			break;
-		case Opt_nocluster:
-			mopt->mount_opt |= OCFS2_MOUNT_NOCLUSTER;
-			break;
 		default:
 			mlog(ML_ERROR,
 			     "Unrecognized mount option \"%s\" "
@@ -1566,9 +1548,6 @@ static int ocfs2_show_options(struct seq_file *s, struct dentry *root)
 	if (opts & OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT)
 		seq_printf(s, ",journal_async_commit");
 
-	if (opts & OCFS2_MOUNT_NOCLUSTER)
-		seq_printf(s, ",nocluster");
-
 	return 0;
 }
 
-- 
2.24.3 (Apple Git-128)


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
