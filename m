Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CF97C38A2D
	for <ocfs2-devel@archiver.kernel.org>; Tue, 25 Oct 2022 07:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WnDZdVnsn6OlOd9hMPMo70ZNqs/6JNdwDAzhtvvsZdw=;
 b=r2eKaIaTUrGgYfas7Hx4QGwlFMG981YtewA1ti2tPhMcrmimOgXh0sZ5WqCh7Gth+/+Tc5noy2vO
   6JbboKS5a4RwxShQL9ZjPwdC0UgRCQ+dPaTsgp+6Q42UoRHNAwdV7aQ+8wC4d4JNzvUm9wnvqX2f
   /T1mx3uorPI1tqUzE9vndLkGaPFntod53JsR2rKgdUoaxLMxe14dKGVkD4ASrkn8ZltZqQWkSS9T
   fpGJtNNqIZ+9IVGdlv656YNWOvJsJt0l5hoDsv+nyO3N+ep5jtIJJQKfylRcE4x3Pnemf6vT843a
   XjOcuUdJoHqy2D5HzrpTbzhfFpt356jR1c8K+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WnDZdVnsn6OlOd9hMPMo70ZNqs/6JNdwDAzhtvvsZdw=;
 b=NtHFwBwSEKzRltQic4RnRYBkvvGD0ROkT8htglsklMocniZvLexxf1VkNNcRLGgSDTHOgZrp1wXG
   DhQJj/vVqdYWNNy4OzvuRK+0O9ucEETEtyXABY3/vWg4cXVMbcVq9kV1+OhDaDc46TmtwCz+m1wN
   rR98mSJVYVBQOXczhKn3w1gjwkCNnigh0qZTuy63dJoo5QyUrTqpLYUr5MxedqXa5ZcgWlwbSx9T
   deviSqEclCd1ipU0cF7IDCKuTmMz9oizGzK7qPVvV8dhrZfMG1l3R1DrEHp69VqThwK/aIKQCpY3
   4L6ZOFuBSfjc5Jq5BOL6bwRg8qUYDWciFVaJOA==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RKA00H5BS880S80@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 25 Oct 2022 07:16:56 +0000 (GMT)
To: <linux-kernel@vger.kernel.org>, <qemu-devel@nongnu.org>,
 <linux-f2fs-devel@lists.sourceforge.net>, <linux-erofs@lists.ozlabs.org>,
 <ocfs2-devel@oss.oracle.com>, <linux-mtd@lists.infradead.org>,
 <amd-gfx@lists.freedesktop.org>
Date: Tue, 25 Oct 2022 15:15:49 +0800
Message-id: <20221025071549.1280528-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-version: 1.0
X-Originating-IP: [10.175.103.91]
X-Source-IP: 45.249.212.187
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10510
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 impostorscore=0 clxscore=-66 priorityscore=1501
 adultscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250041 domainage_hfrom=8323
Cc: yangyingliang@huawei.com, alexander.deucher@amd.com, richard@nod.at,
 mst@redhat.com, gregkh@linuxfoundation.org, somlo@cmu.edu, chao@kernel.org,
 huangjianan@oppo.com, liushixin2@huawei.com, luben.tuikov@amd.com,
 hsiangkao@linux.alibaba.com, rafael@kernel.org, jaegeuk@kernel.org
Subject: [Ocfs2-devel] [PATCH v3] kset: fix memory leak when kset_register()
	returns error
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
X-Proofpoint-GUID: 4T_96VCnfwc67hUEw0-37QhDtaga5dLm
X-Proofpoint-ORIG-GUID: 4T_96VCnfwc67hUEw0-37QhDtaga5dLm
Reporting-Meta:
 AAGMnvfx9HojqzotqJQTOo9PHdVElrG1BE9mxmbA42OfrMCnoT9IHdndGMTJPwUu
 /7rDTB7VOHfOpLfBrlMFbwOq/zkwFDkX5fr9uOu6j9Q16+IpCxNS6azwUDjYYM7k
 RZ9OReWO4glftMyJxoknbjN/s7QBACrYMR8LrB4nLy/eUp9EH85wqIoNPAFCexOV
 WyNm+1N06XJ3I/fQre3l0OGkr0QqVpRTYGX05+hhTPUJdDUdMMJRU44fWpmSCmLr
 oCU/wUWP1WBf+zr65Eh1wqhffO82PZIZASeUHwFNm11abFl2E9BzZKHSp1RsrhP8
 ghtVZCJMx9tJOMamOWd2f6Z8EFoHl+lgBoU5FYd6GbkLuGss3lVDm5AW8GoMRSkP
 5QQ66Nu9mbH3mlkNGIPg6iup0X9PhB8kn1UPfCnPP0E8W5uov+zvRWb+oMF2WO29
 9AWN1o3TEOfRUcr4BmzDlA9cHkF7/G5yHneFMBBRx04HbQfLNJAP8YI1qhSRKtOb
 VYW16HbUmCRCIeYY1eMO1PKWAouFg0tqvzmHxDi8RA==

Inject fault while loading module, kset_register() may fail.
If it fails, the kset.kobj.name allocated by kobject_set_name()
which must be called before a call to kset_register() may be
leaked, since refcount of kobj was set in kset_init().

To mitigate this, we free the name in kset_register() when an
error is encountered, i.e. when kset_register() returns an error.

A kset may be embedded in a larger structure which may be dynamically
allocated in callers, it needs to be freed in ktype.release() or error
path in callers, in this case, we can not call kset_put() in kset_register(),
or it will cause double free, so just call kfree_const() to free the
name and set it to NULL to avoid accessing bad pointer in callers.

With this fix, the callers don't need care about freeing the name
and may call kset_put() if kset_register() fails.

Suggested-by: Luben Tuikov <luben.tuikov@amd.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
v2 -> v3:
  Update commit message and comment of kset_register().

v1 -> v2:
  Free name inside of kset_register() instead of calling kset_put()
  in drivers.
---
 lib/kobject.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index a0b2dbfcfa23..3cd19b9ca5ab 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -834,6 +834,9 @@ EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
 /**
  * kset_register() - Initialize and add a kset.
  * @k: kset.
+ *
+ * NOTE: On error, the kset.kobj.name allocated by() kobj_set_name()
+ * is freed, it can not be used any more.
  */
 int kset_register(struct kset *k)
 {
@@ -844,8 +847,12 @@ int kset_register(struct kset *k)
 
 	kset_init(k);
 	err = kobject_add_internal(&k->kobj);
-	if (err)
+	if (err) {
+		kfree_const(k->kobj.name);
+		/* Set it to NULL to avoid accessing bad pointer in callers. */
+		k->kobj.name = NULL;
 		return err;
+	}
 	kobject_uevent(&k->kobj, KOBJ_ADD);
 	return 0;
 }
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
