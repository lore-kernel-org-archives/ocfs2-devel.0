Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61EF2ECAAA2
	for <ocfs2-devel@archiver.kernel.org>; Sun, 28 Aug 2022 23:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=JK5VC0ahKw8rSOv/8dK1MkNzIxYgh8Q3lrBmBfWB+nI=;
 b=FKBmPcYkW0a5eIgc9ReIlGxBUIoBrrzTHrIge1Id7IIZySv9Jhvdl3mrrq0gns9vqpiKIm9kjPI4
   TeQrE6ApNhcLV5YrZ8rzPejjlyd4wUg3C24Tp1kEA0MAxr2/6cy0Mdd8YtcsXqTn1QbP/CDlZ1XV
   +hoqIRys0O1bwmQpqCI22doop2i6u9DPoczQi+LIxqmzKMLaU/AR4DO11hJFRClbtXyl42SFsiSH
   IZNHKP5/45qati9xn54TKkeDmalqXfRYHsEGq/1CKYtVEpjNI7plmMMt2CZRGSCr3GCUkCCr/Yf9
   6da0/seA/PsbPLbjQ14zWXxNGrOCsqhk/sbYNA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=JK5VC0ahKw8rSOv/8dK1MkNzIxYgh8Q3lrBmBfWB+nI=;
 b=QfB3vbep67mDxFpP2V7FYqiERFKqZsGodOBJIRHe5+WUPU1Yed5Dt7nDmperg2Vvr3oYxoPMdwVa
   wY64ZA/+rOYl9rcJeCGmucQ25Fr+aGq5vkVSziZaajR1NAT3v5XXNSY8h8xLQ88ResKp6/hXPH1P
   L65901mXEAA4CUbVrMjqhHO0Qg4t1fdvqX+MBzqfMv9lav0/Oh2CZT3KygYUBiOtVjv4XTbGNNnu
   efOA0boNrKruErUpwLokGk5J0MT+UypBPwNwlBLsLZRGI4KnQ4aMyhxRsp0UqImBNMDq6s+Ds1Md
   SD25eQDOg/IuaVBz1KYC9tFMtoO3YSoJmdRqPA==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220817 64bit (built Aug 17
 2022))
 with ESMTPS id <0RHC008YCMEBKP00@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 28 Aug 2022 23:25:23 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1661720611; bh=kl9Qkhx458qe7eNXjn7ZBSd4VQOpDEZgiTu7c9T5dMI=;
 h=Date:To:From:Subject:From;
 b=YrLm2Fc8OP6wQNPZBVBU4NV0juqY1IsdAw5n7fNi/eLsXTWEDJAOeHzM65oSUUQsA
 q46AzPgPu4/zB1PniVLTsTzt39yc2h7FIG6ap0pBNUGyP7T/zSZavuoSrNnPY9ay/t
 huFcGOh4AisUkBXjHLcZTe3EBCrvNBhI89kp1NgM=
Date: Sun, 28 Aug 2022 14:03:30 -0700
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, piaojun@huawei.com,
 mark@fasheh.com, junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
 jlbec@evilplan.org, heming.zhao@suse.com, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20220828210331.5AC83C433C1@smtp.kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10453
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=120 mlxlogscore=999 mlxscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 clxscore=172 bulkscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208280087
Subject: [Ocfs2-devel] [merged mm-stable]
	ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown.patch	removed
 from -mm tree
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
From: Andrew Morton via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Andrew Morton <akpm@linux-foundation.org>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: nHW0xZAo-c9CDIGMdmKsL0r0dbl5rgUw
X-Proofpoint-ORIG-GUID: nHW0xZAo-c9CDIGMdmKsL0r0dbl5rgUw
Reporting-Meta:
 AAEXasM8d1FwYMCezx/KWZLpuhTli8P57gmYLlS99TYL5Bfmex/Ny339vfB8jbR4
 nw0/tSWQ59DZ92JdVXrMUhcATBxrokX+Nzssa5o1pMdVGApAOLOZd+qZCKa4PZKr
 RWj+24XBgkv16diSeIfYTA34E/xcFt9KlYiN3dYH0oVJpOK37V4bdCoGK6YOBUyN
 PjQNN76CzIzqOMkJM9l6qqs/V0vUEj2qavFnMSQXUqs5MUHerZOuKipW4VPaBIla
 7YTOXJyMyuzOJY4Dz/crxxy5Oz+GiasAWUtXVY+rdh0MZShvm4wL2FdoMj/K3D1z
 a21FycrjN05bkvSTeT0WbdKWvEFr9TXX+JiUAztJNtm9zrJQ+97E7uvqXAJ9PLaF
 H4S5ZwtEPmWqdzyop0hn4qXo2tSeg3uDdlWbXIUsEAa6XeZj2rgE8AGa6rQjmSUx
 8+I+dwd81T5ixos94FPJK64rkChlzvcXa1viBA2l5GdjOe4To6F6tpHDckW/aMfA
 /ulVrcw7e/RmXpivZr4/HSQLjF/cQzjSBIzQs6+xVEvV


The quilt patch titled
     Subject: ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heming Zhao <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown
Date: Mon, 15 Aug 2022 16:57:54 +0800

After commit 0737e01de9c4 ("ocfs2: ocfs2_mount_volume does cleanup job
before return error"), any procedure after ocfs2_dlm_init() fails will
trigger crash when calling ocfs2_dlm_shutdown().

ie: On local mount mode, no dlm resource is initialized.  If
ocfs2_mount_volume() fails in ocfs2_find_slot(), error handling will call
ocfs2_dlm_shutdown(), then does dlm resource cleanup job, which will
trigger kernel crash.

This solution should bypass uninitialized resources in
ocfs2_dlm_shutdown().

Link: https://lkml.kernel.org/r/20220815085754.20417-1-heming.zhao@suse.com
Fixes: 0737e01de9c4 ("ocfs2: ocfs2_mount_volume does cleanup job before return error")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    8 +++++---
 fs/ocfs2/super.c   |    3 +--
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/dlmglue.c~ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown
+++ a/fs/ocfs2/dlmglue.c
@@ -3403,10 +3403,12 @@ void ocfs2_dlm_shutdown(struct ocfs2_sup
 	ocfs2_lock_res_free(&osb->osb_nfs_sync_lockres);
 	ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
 
-	ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
-	osb->cconn = NULL;
+	if (osb->cconn) {
+		ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
+		osb->cconn = NULL;
 
-	ocfs2_dlm_shutdown_debug(osb);
+		ocfs2_dlm_shutdown_debug(osb);
+	}
 }
 
 static int ocfs2_drop_lock(struct ocfs2_super *osb,
--- a/fs/ocfs2/super.c~ocfs2-fix-freeing-uninitialized-resource-on-ocfs2_dlm_shutdown
+++ a/fs/ocfs2/super.c
@@ -1914,8 +1914,7 @@ static void ocfs2_dismount_volume(struct
 	    !ocfs2_is_hard_readonly(osb))
 		hangup_needed = 1;
 
-	if (osb->cconn)
-		ocfs2_dlm_shutdown(osb, hangup_needed);
+	ocfs2_dlm_shutdown(osb, hangup_needed);
 
 	ocfs2_blockcheck_stats_debugfs_remove(&osb->osb_ecc_stats);
 	debugfs_remove_recursive(osb->osb_debug_root);
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
