Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86F56C433FE
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 02:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+YM2ahqSaTWcgahgbyYHwFQRAdME+fJXvfiqMFns98Q=;
 b=QmKxXadcYt5E4TmpCYH3Ycg5D2OgvmYSNgOxnBrMOTTOuSuEea1ekmHQg8CQZxCbWHiQgeaf4AvA
   //KSvK5td80fDe4gI10D8/3LDB9Bbd8iOcskXV2A9j+DwZruBUHhHE9g9ZAItIsif8LyaGT7DieC
   rVMconFaPjthiMgIhYDE0nH6CsfccISkm6ex8WMVNb07Y0/GAPEBPNpptASXQk4EuAsmcbBSptu1
   nRMnrUU/iuXrVS1ZHjEPT1afCtv+3Y8W0VR13u8tLyBd0lGq7trk67OQVxVKNhk6rEOI9ymmno6t
   jAkLM8PazK0mnI2qCEv6MIPoLIB8qga6WMIUeQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+YM2ahqSaTWcgahgbyYHwFQRAdME+fJXvfiqMFns98Q=;
 b=FG3++HYux/S8C8ARPj6pxTyZkbkGXH3/e7ky0kw0HiAxrQb3paaYjUIdSOobAdqxS9birOzj0FMc
   XH8Zw2NiKyxxTY2Likf7jp3T8oK1g6mfKpYX+m9e48MCIyac6cflOYpkdKsN7AQCf89YvJEN2lhN
   Kjr2Jf2Mot8InqJQkxv749FnU7aEXkyBk9X9NiYFmxZpxzsAo0Yt2WzM6P0XBRH/TB/Cl9Y9wnwM
   226fyeLYeRpS8dHnShczW1Q4EVI32IJLJFGqN8xb7fc+roqbdmhHLc0TntIr3ukgxM7iVeCU0VTs
   l394hlavcNFVFs6aKKc267b/yCyiJkqgDSRwzw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK200HQVZY3DJ10@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 02:22:51 +0000 (GMT)
To: <linux-kernel@vger.kernel.org>, <qemu-devel@nongnu.org>,
 <linux-f2fs-devel@lists.sourceforge.net>, <linux-erofs@lists.ozlabs.org>,
 <ocfs2-devel@oss.oracle.com>, <linux-mtd@lists.infradead.org>,
 <amd-gfx@lists.freedesktop.org>
Date: Fri, 21 Oct 2022 10:20:51 +0800
Message-id: <20221021022102.2231464-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-version: 1.0
X-Originating-IP: [10.175.103.91]
X-Source-IP: 45.249.212.188
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 clxscore=14 priorityscore=162 mlxlogscore=531 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 impostorscore=0 suspectscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210011 domainage_hfrom=8319
Cc: alexander.deucher@amd.com, richard@nod.at, mst@redhat.com,
 gregkh@linuxfoundation.org, somlo@cmu.edu, chao@kernel.org,
 huangjianan@oppo.com, liushixin2@huawei.com, luben.tuikov@amd.com,
 hsiangkao@linux.alibaba.com, rafael@kernel.org, jaegeuk@kernel.org
Subject: [Ocfs2-devel] [PATCH 00/11] fix memory leak while kset_register()	fails
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
X-ServerName: szxga02-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-GUID: SKskdyxtlyx9NdaLSfv0FmHSjYNAX7Pr
X-Proofpoint-ORIG-GUID: SKskdyxtlyx9NdaLSfv0FmHSjYNAX7Pr
Reporting-Meta:
 AAGWMax8bsk4+M13KDZvuGecUd8eqy9Eo45iq2/xXP5UMLwZk0DhiqOE/222qW+x
 EfHcPk9Po8acPLf2cjId4CNvg+U5iLXO2WSbZWiuSRPlexHGGCUywCJ/SyQGcJDj
 pWy4j7+4XQxcyAZZYZ8O6NDzYBJ1HFXOu9d/nSVDXJlV5dyQR2CJZ+oBMNjfpHz3
 lC3qwHMEOFYmRbn+VylNX0i8dsrO+Mw4mPBG5x774O2H456Yvwvl6ZzGTlC8zqjE
 nAyqXs1Jk7hKx7cy5/e4xPrqedXDV3iVdRrf9OhtBZwV27+9G7lkt40FWP2GodbI
 YKyl+5FT1w24w1+0OtZwa5U+OrLSrfU0IHy7RXoi6pCxnDapSPK5ao/+/yVfQviT
 0Nhxa1SheQ04k5k/HdrnGDX9M/2c+WZLqA/tZewwDyzpNGHpp4s0+Sl9bwIMXDfT
 7UIGbH8zt6vD2P4qmXgvfEcpVVNorjVPFkUVM1rqaayZgvv0Rzi2WaHvS1nQGoKQ
 XbK3SMhiiW5hi6+baUhGDn7gzZyy4QRCjiOJJ7hJFMCs

The previous discussion link:
https://lore.kernel.org/lkml/0db486eb-6927-927e-3629-958f8f211194@huawei.com/T/

kset_register() is currently used in some places without calling
kset_put() in error path, because the callers think it should be
kset internal thing to do, but the driver core can not know what
caller doing with that memory at times. The memory could be freed
both in kset_put() and error path of caller, if it is called in
kset_register().

So make the function documentation more explicit about calling
kset_put() in the error path of caller first, so that people
have a chance to know what to do here, then fixes this leaks
by calling kset_put() from callers.

Liu Shixin (1):
  ubifs: Fix memory leak in ubifs_sysfs_init()

Yang Yingliang (10):
  kset: fix documentation for kset_register()
  kset: add null pointer check in kset_put()
  bus: fix possible memory leak in bus_register()
  kobject: fix possible memory leak in kset_create_and_add()
  class: fix possible memory leak in __class_register()
  firmware: qemu_fw_cfg: fix possible memory leak in
    fw_cfg_build_symlink()
  f2fs: fix possible memory leak in f2fs_init_sysfs()
  erofs: fix possible memory leak in erofs_init_sysfs()
  ocfs2: possible memory leak in mlog_sys_init()
  drm/amdgpu/discovery: fix possible memory leak

 drivers/base/bus.c                            | 4 +++-
 drivers/base/class.c                          | 6 ++++++
 drivers/firmware/qemu_fw_cfg.c                | 2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 5 +++--
 fs/erofs/sysfs.c                              | 4 +++-
 fs/f2fs/sysfs.c                               | 4 +++-
 fs/ocfs2/cluster/masklog.c                    | 7 ++++++-
 fs/ubifs/sysfs.c                              | 2 ++
 include/linux/kobject.h                       | 3 ++-
 lib/kobject.c                                 | 5 ++++-
 10 files changed, 33 insertions(+), 9 deletions(-)

-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
