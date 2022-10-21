Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A4D7C4332F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 02:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vKOew3c2fLe4+sExGmmBEDPqfDuiIMtQ7nwbS6sb824=;
 b=D4XVu4kTmO6wvfvW2HLNLl9tdXiORH36fNrsYcNMECYNP5VgvJfxkJZMmzEMXdx/70t2M1dlp3V2
   FsdX0bRo9DiTzz5AqEeG9PbI0caywMgnvrS24Vn/dwRHHtM+WZvU83qFTeE1Am5F6mNrbkVGeFuu
   YahpLuMwXV4XFEhVeLDwj0ICGapKzOoRAnTUG+L+bYafPPTD8GGmSzjno3siXf6Q3VlJDhxbzo+l
   hyXVaZO1DUy4gV2RFLooxxyCt1Mi0Eoa8Bf+/aqFpmk5gG+xaOCc9+yRdlevk6JN8IXH3bCkKgMT
   T4icex9AZuEsDAP8Kv0AKbvy9/HCVsk4Ykdl/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vKOew3c2fLe4+sExGmmBEDPqfDuiIMtQ7nwbS6sb824=;
 b=GnHCtsDdGG9Ho17dBuhTU+kHLEdCy2dTPBvtpHADU+8Xyet+wy1rgK/ezBJf4tSHONvznt9KJ+uP
   FkpNKra8zhDC7Iahk2FBlQ5oquBTtihJZJi/65Iy4gkBtjm1XEgcV/ikNnQOxJowd+Tc7lCKKN6d
   l4mcD0L39DGGJ2c2j/yu9DRqx01Fn3H8Yjm6cymQbY8HwfIAIPHcIZTKr5MKf5OvvTK/vnlxPe3V
   pv4nhL0oZ2nSKMzfti+K0USDjcS7lGsVAxCkmXQFHDdcUUcQmb2pbguVKdleXMCT/C6JUIwVWtlL
   rya6hyF+LdzxMEkkScMQEoEqr0rpruBZqNkOGg==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK200HUTZZ5DJ10@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 02:23:29 +0000 (GMT)
To: <linux-kernel@vger.kernel.org>, <qemu-devel@nongnu.org>,
 <linux-f2fs-devel@lists.sourceforge.net>, <linux-erofs@lists.ozlabs.org>,
 <ocfs2-devel@oss.oracle.com>, <linux-mtd@lists.infradead.org>,
 <amd-gfx@lists.freedesktop.org>
Date: Fri, 21 Oct 2022 10:20:56 +0800
Message-id: <20221021022102.2231464-6-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20221021022102.2231464-1-yangyingliang@huawei.com>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.103.91]
X-Source-IP: 45.249.212.188
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=251 malwarescore=0 spamscore=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 clxscore=91 adultscore=0
 phishscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210011 domainage_hfrom=8319
Cc: alexander.deucher@amd.com, richard@nod.at, mst@redhat.com,
 gregkh@linuxfoundation.org, somlo@cmu.edu, chao@kernel.org,
 huangjianan@oppo.com, liushixin2@huawei.com, luben.tuikov@amd.com,
 hsiangkao@linux.alibaba.com, rafael@kernel.org, jaegeuk@kernel.org
Subject: [Ocfs2-devel] [PATCH 05/11] class: fix possible memory leak in
	__class_register()
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
X-Proofpoint-ORIG-GUID: IcXKm6D8iqfGnBR-K3BxNB2bI8dTYSpq
X-Proofpoint-GUID: IcXKm6D8iqfGnBR-K3BxNB2bI8dTYSpq
Reporting-Meta:
 AAG6Wn39JUzNg/QLJhQCMkSX1qqGJEl1oPOM/Aly/+sTnjTrLGtbqfAEmM0+NuH1
 Bt+zM0ATaMbYkKGnrqyvVbBM0pJEYCqoLV/hEUhh/2UJhtVBjJVv+Nf4D2S3wl7p
 /bIF6tGoTCvwRywvpmUOoQQ7+HdpV9LY13rh7/XcDw1gNDguJpfbyBJ83oTk7eGt
 ZRCqFcAv5D4Tr4E3n+RbogGVbIux/2wjiG//46HtV+HpH9NT5Y6gdTqMdx56ejzp
 Beij9BFn06n4yMxmF6mvNbVY08x+SdbJGgO35Tt/60BF3lHdc8p8HcuKouNWQps8
 Lt/VU5rYuMJbUaKO82MGfWCOxrUyKtR8tw7gpoYsgCQOn26Ju7phLWF3j+YVvB6h
 Jdj0/gX6pbnxkQIYdY7niFKNXeZ7w+3e2wqNuO00l5qdBXhwzfrM2/Ja2xdPRQDj
 xeIv5Gre/NcsdolWwFuAaeTa3V1iHbJS//W7lkfrPt+a8rZBFemTzQ3YIfGrptMS
 K/BGDiiyAjckfPZM77laYlLUAiZZAJnryGhvRMj44iA6

Inject fault while loading module (e.g. pktcdvd.ko), kset_register() may
fail in __class_register(), if it fails, but the refcount of kobject is
not decreased to 0, the name allocated in kobject_set_name() is leaked.
To fix this by calling kfree_const().

unreferenced object 0xffff888102fa8190 (size 8):
  comm "modprobe", pid 502, jiffies 4294906074 (age 49.296s)
  hex dump (first 8 bytes):
    70 6b 74 63 64 76 64 00                          pktcdvd.
  backtrace:
    [<00000000e7c7703d>] __kmalloc_track_caller+0x1ae/0x320
    [<000000005e4d70bc>] kstrdup+0x3a/0x70
    [<00000000c2e5e85a>] kstrdup_const+0x68/0x80
    [<000000000049a8c7>] kvasprintf_const+0x10b/0x190
    [<0000000029123163>] kobject_set_name_vargs+0x56/0x150
    [<00000000747219c9>] kobject_set_name+0xab/0xe0
    [<0000000005f1ea4e>] __class_register+0x15c/0x49a

If class_add_groups() fails, it need delete kobject and free its name,
besides, subsys_private also need be freed.

unreferenced object 0xffff888037274000 (size 1024):
  comm "modprobe", pid 502, jiffies 4294906074 (age 49.296s)
  hex dump (first 32 bytes):
    00 40 27 37 80 88 ff ff 00 40 27 37 80 88 ff ff  .@'7.....@'7....
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
  backtrace:
    [<00000000151f9600>] kmem_cache_alloc_trace+0x17c/0x2f0
    [<00000000ecf3dd95>] __class_register+0x86/0x49a

It can not call kset_put() or kset_unregister() in error path, because
the 'cls' will be freed in callback function class_release() and it also
freed in error path, it will cause double free.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/base/class.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 64f7b9a0970f..87de0a04ee9b 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -187,11 +187,17 @@ int __class_register(struct class *cls, struct lock_class_key *key)
 
 	error = kset_register(&cp->subsys);
 	if (error) {
+		kfree_const(cp->subsys.kobj.name);
 		kfree(cp);
 		return error;
 	}
 	error = class_add_groups(class_get(cls), cls->class_groups);
 	class_put(cls);
+	if (error) {
+		kobject_del(&cp->subsys.kobj);
+		kfree_const(cp->subsys.kobj.name);
+		kfree(cp);
+	}
 	return error;
 }
 EXPORT_SYMBOL_GPL(__class_register);
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
