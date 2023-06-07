Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BB43C87FDE
	for <ocfs2-devel@archiver.kernel.org>; Wed,  7 Jun 2023 20:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=H6lBHDwd5Y/t35+ev6BMeeQSrD1W0cyXNZwU+uBKAUM=;
 b=tzo3aG50C2oIuzhi/K78Xm+3b3D3YAXGoz2vYN9buoUI15C7inEsVObPfxkbVr0BihEg6OY0L3Mm
   aMSN5Z2+bMUgWZEsA5eOlwgM34rBaNAd7Kt7Md8FWvIEUsiYnwKvtzf7BQdNbgyncyQy9VaMXSdy
   cylll9UM6HDwc3lJMdbd+PXB7y1PwHkl4tjV50pgeGm+yr2hYuPOnpI5rFjQhWGyi5NqufNxLloa
   z7RCe0G3dijOlNreSrF7QZM/4xq83AgafZc+AikpOnFBu+U8In43JS4RsLDJPooGR/8qHeb7vu0i
   quxTn+K1JO68LvDiLK+SszXoa+XYaSOVOb9yxw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=H6lBHDwd5Y/t35+ev6BMeeQSrD1W0cyXNZwU+uBKAUM=;
 b=efNmlra9vpnt8pb9vXTMX3Cd1yhQMShgxeaqWATaZKV7vmaj/KOuDX5kIAW0TrLrNLD4BL4cVPd1
   o23MJKfCsjXL1TiReTXXJO/zN/S78lpWU7plkEthJAQA0plf7h4qBPdejVswWn355zFm8TGk4Gzx
   3s2irQElu5yui70qYDRiYwOg3K7HveZgjE5K0DWj/wVoks8AtUmAj2VLzn8+dnbj/lpl4S/SyLS2
   DJhlEy0lyfmOMnLY/RnT5VDoJ6PWsh3CiQQGxYn2ljTxl/ds77rHjjxyFxS/ltqd72X1YtCt3iPH
   lSbn4oiuRnHjnk6QomsH2X28ZMw0edbvazEmvQ==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RVW004Z4FKP9Y40@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 07 Jun 2023 20:00:25 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1686168011; bh=SUfIK17SIrwqjc6DhxsxfHxoKVKP+436Nuu3YXC3CII=;
 h=Date:To:From:Subject:From;
 b=WzWusXyoHZGTJhs08dWyBOx3ulMCOirLtOtPp+TMqTw+4mMn8fZaU0NsWdi4nt8P9
 dZB4a0rIGwY9TClg2n6w5hfCm2qL33lWwMUbPswNuxmwSBSHWI7qbwvdMJUIOQKhbj
 8qnuhXe7zk1SUbMqo1jYt15DXHOQa7ajWtjAF0Pg=
Date: Wed, 07 Jun 2023 13:00:10 -0700
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, piaojun@huawei.com,
 mark@fasheh.com, lhenriques@suse.de, junxiao.bi@oracle.com,
 joseph.qi@linux.alibaba.com, jlbec@evilplan.org, ghe@suse.com,
 gechangwei@live.cn, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
Message-id: <20230607200011.77350C433EF@smtp.kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10734
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=193
 malwarescore=0 priorityscore=154 adultscore=0 mlxscore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306070173
Subject: [Ocfs2-devel] [merged mm-hotfixes-stable]
	ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem.patch	removed
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
Content-type: multipart/mixed; boundary="===============5413395991338444290=="
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: BYYzYw16plm_Vof5dARcS732s724mCjD
X-Proofpoint-ORIG-GUID: BYYzYw16plm_Vof5dARcS732s724mCjD
Reporting-Meta:
 AAE9u7b+Tn/eiM1eEi7CWr/p0QpuHczGm+vfXdHdavAwxnfnaqtxKJHPxxDNWzZv
 TqzvqVqru/4hrPfVHSDMlUvJqppAI3z+oOOQtxv4XddEKy5s+2m/i5g2384i3Jz9
 1gLR9LYO9yScnNhpGwgX2Upbji0AiQCHIRmVCoN8TE8rB0FMT84nzj2i9kU9avgm
 8ixDG/MQSf9IlXU5RXyKNi5m+0dV0xqydG6UdZDxDFwIWb8DqXCcg05fqHwr1KA0
 Nw7TSFcvwvld0FHCQWMbxLnwl3rDnYoZHebAV0GmB5NLp9o1VJjBuXJ7TmzaRBsn
 3xltFwBW71OYfu/ClXEwo25IBkjhun3XsdJQ4M4Rd41a06KsQbUSHwzsC7EVHKNJ
 +UM0pXedlgD/GwLUNbar2gteBRZi3Tqufo3j9NKp5vHK2lvWcm/n+Yki5Mi2i3oI
 GjUN5hefjxfM7tIn4ehzmBwELv7M74G6F3Vg5FK9KGYBnMJAhHDqA8s0rH1/qy79
 KPFz3VWU+e9GgRfQ5NUPDfINIRI33c7p7U6MiDlH4OLL

--===============5413395991338444290==
Content-Type: text/plain


The quilt patch titled
     Subject: ocfs2: fix use-after-free when unmounting read-only filesystem
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Luís Henriques <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: fix use-after-free when unmounting read-only filesystem
Date: Mon, 22 May 2023 11:21:12 +0100

It's trivial to trigger a use-after-free bug in the ocfs2 quotas code using
fstest generic/452.  After a read-only remount, quotas are suspended and
ocfs2_mem_dqinfo is freed through ->ocfs2_local_free_info().  When unmounting
the filesystem, an UAF access to the oinfo will eventually cause a crash.
 
BUG: KASAN: slab-use-after-free in timer_delete+0x54/0xc0
Read of size 8 at addr ffff8880389a8208 by task umount/669
...
Call Trace:
 <TASK>
 ...
 timer_delete+0x54/0xc0
 try_to_grab_pending+0x31/0x230
 __cancel_work_timer+0x6c/0x270
 ocfs2_disable_quotas.isra.0+0x3e/0xf0 [ocfs2]
 ocfs2_dismount_volume+0xdd/0x450 [ocfs2]
 generic_shutdown_super+0xaa/0x280
 kill_block_super+0x46/0x70
 deactivate_locked_super+0x4d/0xb0
 cleanup_mnt+0x135/0x1f0
 ...
 </TASK>

Allocated by task 632:
 kasan_save_stack+0x1c/0x40
 kasan_set_track+0x21/0x30
 __kasan_kmalloc+0x8b/0x90
 ocfs2_local_read_info+0xe3/0x9a0 [ocfs2]
 dquot_load_quota_sb+0x34b/0x680
 dquot_load_quota_inode+0xfe/0x1a0
 ocfs2_enable_quotas+0x190/0x2f0 [ocfs2]
 ocfs2_fill_super+0x14ef/0x2120 [ocfs2]
 mount_bdev+0x1be/0x200
 legacy_get_tree+0x6c/0xb0
 vfs_get_tree+0x3e/0x110
 path_mount+0xa90/0xe10
 __x64_sys_mount+0x16f/0x1a0
 do_syscall_64+0x43/0x90
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

Freed by task 650:
 kasan_save_stack+0x1c/0x40
 kasan_set_track+0x21/0x30
 kasan_save_free_info+0x2a/0x50
 __kasan_slab_free+0xf9/0x150
 __kmem_cache_free+0x89/0x180
 ocfs2_local_free_info+0x2ba/0x3f0 [ocfs2]
 dquot_disable+0x35f/0xa70
 ocfs2_susp_quotas.isra.0+0x159/0x1a0 [ocfs2]
 ocfs2_remount+0x150/0x580 [ocfs2]
 reconfigure_super+0x1a5/0x3a0
 path_mount+0xc8a/0xe10
 __x64_sys_mount+0x16f/0x1a0
 do_syscall_64+0x43/0x90
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

Link: https://lkml.kernel.org/r/20230522102112.9031-1-lhenriques@suse.de
Signed-off-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Tested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/super.c~ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem
+++ a/fs/ocfs2/super.c
@@ -952,8 +952,10 @@ static void ocfs2_disable_quotas(struct
 	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
 		if (!sb_has_quota_loaded(sb, type))
 			continue;
-		oinfo = sb_dqinfo(sb, type)->dqi_priv;
-		cancel_delayed_work_sync(&oinfo->dqi_sync_work);
+		if (!sb_has_quota_suspended(sb, type)) {
+			oinfo = sb_dqinfo(sb, type)->dqi_priv;
+			cancel_delayed_work_sync(&oinfo->dqi_sync_work);
+		}
 		inode = igrab(sb->s_dquot.files[type]);
 		/* Turn off quotas. This will remove all dquot structures from
 		 * memory and so they will be automatically synced to global
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are




--===============5413395991338444290==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
--===============5413395991338444290==--
