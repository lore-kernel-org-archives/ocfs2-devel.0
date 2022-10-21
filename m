Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8498CC4167D
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 02:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=LFPfh+AqtBp4D/fSpCdqEAPYuFmr+oRuD3e5SttW160=;
 b=Ae73ajk4YrpxHC/dk+xtMAVb8QCuxXW8txXN6iZiBqhic4Q++3MZCqOnj+S9wtgKQwmG8W78GXKr
   JCShnSdFvtdpP6jkOrPfxF0svET/TMAmb7YPD+JmttOCzNpd2bUM3U50CIL54rrCvZyATO7CQCTw
   gFoHXz01tijBRQBv0y39lG9SsnwbkogxDwoJiPS8nBi3ooJUHKS36Tk2cuCr0FrBk78hQalCbJ2Z
   21L7L/APu7QAdRFhAtCB/lhaxN0PspG370v7Jqx+DdyzE6RfK6wq7NGFgwhpJP88vlGmrRgF1A/C
   oP/WLC2Z7jzBTaaZZgq504QHoPUKPuJ8WxwNdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=LFPfh+AqtBp4D/fSpCdqEAPYuFmr+oRuD3e5SttW160=;
 b=OYw/6Avc1U66eP34a7O5m1jGnYqJr6dj2YUReRBP+DBUiuL5FSfefnpKepdUz621wddPYxcjx9Ve
   x/NjZQ+3RSBOArK94sE8q1kj+ADvVezTmRx0KiZac+OFn/E7WX+zfdqPHJTjsDsJUsHthxcGldog
   y0u2M+UlrsLO3ggjdwk0npi4NLE2bqmwII8lXOcO1rAYrlkk/tnlFsiBcMYh8gR/anW/8xD1RFiD
   BBRva3tu5hDOaYHHk/36ahTgVjDApwovZHBXfUdmlhQWLafdxCmrHan7a3ASwmCoj1oX+2E922za
   PRb3OcP2SY+3EkPbHpSgFpkMaS2yLa+BYdZ7pg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK200KEYZY87QB0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 02:22:56 +0000 (GMT)
To: <linux-kernel@vger.kernel.org>, <qemu-devel@nongnu.org>,
 <linux-f2fs-devel@lists.sourceforge.net>, <linux-erofs@lists.ozlabs.org>,
 <ocfs2-devel@oss.oracle.com>, <linux-mtd@lists.infradead.org>,
 <amd-gfx@lists.freedesktop.org>
Date: Fri, 21 Oct 2022 10:20:54 +0800
Message-id: <20221021022102.2231464-4-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20221021022102.2231464-1-yangyingliang@huawei.com>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.103.91]
X-Source-IP: 45.249.212.187
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=159 impostorscore=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 clxscore=16 phishscore=0 spamscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210011 domainage_hfrom=8319
Cc: alexander.deucher@amd.com, richard@nod.at, mst@redhat.com,
 gregkh@linuxfoundation.org, somlo@cmu.edu, chao@kernel.org,
 huangjianan@oppo.com, liushixin2@huawei.com, luben.tuikov@amd.com,
 hsiangkao@linux.alibaba.com, rafael@kernel.org, jaegeuk@kernel.org
Subject: [Ocfs2-devel] [PATCH 03/11] bus: fix possible memory leak in
	bus_register()
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
X-Proofpoint-ORIG-GUID: 5G8mAOrNv7VGe8EKORh_8wfqBiLDz5eR
X-Proofpoint-GUID: 5G8mAOrNv7VGe8EKORh_8wfqBiLDz5eR
Reporting-Meta:
 AAGWMax8bsk4+M13KDZvuGecUd8eqy9Eo45iq2/xXP5UMLwZk0DhiqOE/222qW+x
 EfHcPk9Po8acPLf2cjIm4CNvg+U5iLXO2WTfb4agVf1r6//idXXRX089zjojZ6E/
 +kStqBJgTvfH7e796ljXIjSxIRw2ZuihftrkOwIluelLpCjM6FrRiSWETvr8q5z0
 zfJkm24hhNhBIlnx6aUd6hBU6HLF+sh7M3SrZh1QHAtPt+3eFwBbJaBztyM1fvMe
 gkC5Zj+IlXFdXerD3TccjGzqhtiIghqU2FaipTWg1drk8mcqpeM0uZw7OrmQmyBK
 F1gDptnvADgl5DyX/LRxtNvqcrrL1hJ839LRCO1YSp5+3+pWt5VFyuQrfazkppJH
 7jq6xOyjL2zDwCF07RNMQVERqiIu6301IZ1P/uZa2QQCrvjrpkpEL5/ZIR1qBvW6
 nql5Pd6ebqSjOCJJvH9bwt72XaRnwURxmdKiaZcZIK79pzVijVhAohgS/Nu865Ge
 YX4Wyj587NRH5WfaEsuC4oPkJR+zpTP5PXpnOahJnLBT

Inject fault while loading module (e.g. edac_core.ko), kset_register()
may fail in bus_register(), if it fails, but the refcount of kobject is
not decreased to 0, the name allocated in kobject_set_name() is leaked.
To fix this by calling kset_put(), so that name can be freed in callback
function kobject_cleanup().

unreferenced object 0xffff888103bddb68 (size 8):
  comm "systemd-udevd", pid 341, jiffies 4294903262 (age 42.212s)
  hex dump (first 8 bytes):
    65 64 61 63 00 00 00 00                          edac....
  backtrace:
    [<000000009e31d566>] __kmalloc_track_caller+0x1ae/0x320
    [<00000000e4cfd8de>] kstrdup+0x3a/0x70
    [<000000003d0ec369>] kstrdup_const+0x68/0x80
    [<000000008e5c3b20>] kvasprintf_const+0x10b/0x190
    [<00000000b9a945aa>] kobject_set_name_vargs+0x56/0x150
    [<000000000df9278c>] kobject_set_name+0xab/0xe0
    [<00000000f51dc49f>] bus_register+0x132/0x350
    [<000000007d91c2e5>] subsys_register+0x23/0x220

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/base/bus.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 7ca47e5b3c1f..301b5330f9d8 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -804,8 +804,10 @@ int bus_register(struct bus_type *bus)
 	priv->drivers_autoprobe = 1;
 
 	retval = kset_register(&priv->subsys);
-	if (retval)
+	if (retval) {
+		kset_put(&priv->subsys);
 		goto out;
+	}
 
 	retval = bus_create_file(bus, &bus_attr_uevent);
 	if (retval)
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
