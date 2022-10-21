Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F068AC43217
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 02:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VgxvJJ/Jc/8LRosGrmnbU5IknoS709MuKY91QHE/k9k=;
 b=sOFl8XWBq/nHLCr0AcJq5RIYkqfsWwS0RJoQF9s7DGOsk7cW3rO92oXwwhkdDFjSDE/XmsB3op0R
   LI120v6GlUypz+6cTBSOTyHrrqNjJs9h17mOndhfJYuHsME2I/okR+aTICc+It1ctvkJo20KVnwa
   TN+pjjb9kFf6buBIyLLu/vc/WGJ0TpVPBLZbwWLmnx3VYXZrv68tbqiJFGIqTPXoYBBbhCL5kyFS
   bOIpyPFxdAnkQe1+QFio6xb2JjuV4eSawyMMor2ReS0ycK/hjGgjgo73mJNsGQxivWQP+T5fY+GD
   Twy5o2PwviK4ah+VCmIk0EZF6r3dDbcCR2Uelg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VgxvJJ/Jc/8LRosGrmnbU5IknoS709MuKY91QHE/k9k=;
 b=hVphgLcgwH/RWe+gnbAen2i2zf424FIZg9a70Br/Wub+Ds+oQ3rwif9LnWSiqIdw2SWASk0Pjg9g
   6PXt9Cj126Z9NfChenkDsKY98Lj1CjsmrKPlSBswHbfQwy5yS5/1XrkphOZZxcevF/e55wPwxZo9
   L+xjKHcS2xgHvXvU2b4NzdMCKOydWrHtmeBbhTJTbxSB/KkwwC2CrmxneGjTIr7fuIlOu67ZQSPk
   b26TPhd0ZClZX7SaJOfBev1rQEfioKoOFqIEYsYnJAV+8mvqlz90Wa8Bn9HnU4GICy5keAs19GPW
   yCJSjI/PUNY33p6MmynpTowFsHCZoHllh0Ovow==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK200KGZZYC7QB0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 02:23:00 +0000 (GMT)
To: <linux-kernel@vger.kernel.org>, <qemu-devel@nongnu.org>,
 <linux-f2fs-devel@lists.sourceforge.net>, <linux-erofs@lists.ozlabs.org>,
 <ocfs2-devel@oss.oracle.com>, <linux-mtd@lists.infradead.org>,
 <amd-gfx@lists.freedesktop.org>
Date: Fri, 21 Oct 2022 10:21:02 +0800
Message-id: <20221021022102.2231464-12-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20221021022102.2231464-1-yangyingliang@huawei.com>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.103.91]
X-Source-IP: 45.249.212.187
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=223 impostorscore=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=979 adultscore=0 bulkscore=0 clxscore=25 phishscore=0 spamscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210011 domainage_hfrom=8319
Cc: alexander.deucher@amd.com, richard@nod.at, mst@redhat.com,
 gregkh@linuxfoundation.org, somlo@cmu.edu, chao@kernel.org,
 huangjianan@oppo.com, liushixin2@huawei.com, luben.tuikov@amd.com,
 hsiangkao@linux.alibaba.com, rafael@kernel.org, jaegeuk@kernel.org
Subject: [Ocfs2-devel] [PATCH 11/11] ubifs: Fix memory leak in
	ubifs_sysfs_init()
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
From: Yang Yingliang via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Yang Yingliang <yangyingliang@huawei.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-ServerName: szxga01-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-GUID: oD8InqKsFYgJ2P42ZV9i3pxeIYd_XcbN
X-Proofpoint-ORIG-GUID: oD8InqKsFYgJ2P42ZV9i3pxeIYd_XcbN
Reporting-Meta:
 AAEEFqEROhsUH2JFQKSN1lyoWoc1mjN1+JrayHs6vPvFtQW3VIjDfy2nG29Q43FZ
 ApE/1d6sPbFFX12sEpmBK7ES8rdPgFrdMWG2n1JXF/Bxakr/NKdcbx6O2Dc4jnah
 BPpjOHhoLUL0YviwHrNEKsf+HmhqGqzp9qIid/YCRQHS893H87WQ0YKCT4RqkCpo
 4zCzyusmYZEY13hNykwjPpRdAw/2QM5R7c2b51xNkOsNhafzzwVXwx1UE7eJGmQU
 dDqRQLqtB56Z566c69L/9qxCWtPfBzSKRiOOCueH4FGOpQ0UYkp7lyymOk+wfgFS
 AcNOxjnNgEKYboEmOi39vhHchmOzDpDtV3J/uEGbLeVEQ/kqjna2YuvxVkE4rAUR
 Bw1NgnyV5IjouFJc0Hju+NBrSXSGUD8IcTf+bDcn9COWy5M6DsPpfc//r/Byx9gJ
 fPKLAy978Cxht+KuJIaohVM9UQrU3DYC1oBcoeiER9216docbsJLqi0yrGeH2a/P
 HmZDXLOdq73OZAIYtV78FRTEFwldV1M2GQAFrKE9AMJbCg==

From: Liu Shixin <liushixin2@huawei.com>

When insmod ubifs.ko, a kmemleak reported as below:

 unreferenced object 0xffff88817fb1a780 (size 8):
   comm "insmod", pid 25265, jiffies 4295239702 (age 100.130s)
   hex dump (first 8 bytes):
     75 62 69 66 73 00 ff ff                          ubifs...
   backtrace:
     [<ffffffff81b3fc4c>] slab_post_alloc_hook+0x9c/0x3c0
     [<ffffffff81b44bf3>] __kmalloc_track_caller+0x183/0x410
     [<ffffffff8198d3da>] kstrdup+0x3a/0x80
     [<ffffffff8198d486>] kstrdup_const+0x66/0x80
     [<ffffffff83989325>] kvasprintf_const+0x155/0x190
     [<ffffffff83bf55bb>] kobject_set_name_vargs+0x5b/0x150
     [<ffffffff83bf576b>] kobject_set_name+0xbb/0xf0
     [<ffffffff8100204c>] do_one_initcall+0x14c/0x5a0
     [<ffffffff8157e380>] do_init_module+0x1f0/0x660
     [<ffffffff815857be>] load_module+0x6d7e/0x7590
     [<ffffffff8158644f>] __do_sys_finit_module+0x19f/0x230
     [<ffffffff815866b3>] __x64_sys_finit_module+0x73/0xb0
     [<ffffffff88c98e85>] do_syscall_64+0x35/0x80
     [<ffffffff88e00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

When kset_register() failed, we should call kset_put to cleanup it.

Fixes: 2e3cbf425804 ("ubifs: Export filesystem error counters")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 fs/ubifs/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ubifs/sysfs.c b/fs/ubifs/sysfs.c
index 06ad8fa1fcfb..54270ad36321 100644
--- a/fs/ubifs/sysfs.c
+++ b/fs/ubifs/sysfs.c
@@ -144,6 +144,8 @@ int __init ubifs_sysfs_init(void)
 	kobject_set_name(&ubifs_kset.kobj, "ubifs");
 	ubifs_kset.kobj.parent = fs_kobj;
 	ret = kset_register(&ubifs_kset);
+	if (ret)
+		kset_put(&ubifs_kset);
 
 	return ret;
 }
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
