Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF789FA373E
	for <ocfs2-devel@archiver.kernel.org>; Mon, 24 Oct 2022 12:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8a+J8Tk1RL0yacc0BK7fAdOY/PXxpwfxq68B76qGBSc=;
 b=xXAed+O/zM7fwg7ggEr4DHYHlavDyNy4u7hRz3tdVgNA3keDtTSyAzbc8Nh8wP25KZO3viN9m4P1
   7kono5Hxpo0SS6E4nMsPH6YcWfwpIvvQsscB2wOMI+2ZHRsPlqgM7OS0PVC8B348IkTBmVtwIsLa
   GODr/nV0sjiYkfCDQ7w5jz2kpzdyS3EWGpzXTs/0qlZYUn9mzigxt2Kt5GMR2IOS0BUSURg5so5e
   d6lAhf5RUjvOLsLVH/pS8doKDlIquo4WDp8RiKKdo6Q8LuSIKw08Q56BJE1oodeFBudhftU28+O6
   0hQACMxR8MZlDxuqFjs8TfCREDgkc2GoNYonyw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=8a+J8Tk1RL0yacc0BK7fAdOY/PXxpwfxq68B76qGBSc=;
 b=ttQsvm+FwjRxgKGCW/+an0UR4Ai2OH3jK7iU36QkI6EVVaiIbmSmtn3v0SdR8pGMbWu0f3Xg9ALg
   da0rFE6FRIg74US6EIBNaisP/i/MXajI0winPlYUgn/FQIyvCTtdi8tNYGqvgKyNsgb59nyU+IyT
   hT886n4U+D1rnC6XPMrU9E3FcXV8VsMS5s7AQv28x8kWqAZRT18gbqW69tENeyGRZPDv8xaQCcuX
   fEjQdVhIMtjuH7bavmUI++CJOERX3OCE1lzCbRCssTqBHd/J0SaziKGuwGHNVwjuO1/mgN4i7YTV
   zpTmYiIefO+LlvFzu8SVb4txahkcBkfdw/3aVw==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK900803BMMMG40@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 24 Oct 2022 12:20:46 +0000 (GMT)
To: <linux-kernel@vger.kernel.org>, <qemu-devel@nongnu.org>,
 <linux-f2fs-devel@lists.sourceforge.net>, <linux-erofs@lists.ozlabs.org>,
 <ocfs2-devel@oss.oracle.com>, <linux-mtd@lists.infradead.org>,
 <amd-gfx@lists.freedesktop.org>
Date: Mon, 24 Oct 2022 20:19:10 +0800
Message-id: <20221024121910.1169801-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-version: 1.0
X-Originating-IP: [10.175.103.91]
X-Source-IP: 45.249.212.188
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10509
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 clxscore=31 lowpriorityscore=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0
 priorityscore=159 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240076 domainage_hfrom=8322
Cc: alexander.deucher@amd.com, richard@nod.at, mst@redhat.com,
 gregkh@linuxfoundation.org, somlo@cmu.edu, chao@kernel.org,
 huangjianan@oppo.com, liushixin2@huawei.com, luben.tuikov@amd.com,
 hsiangkao@linux.alibaba.com, rafael@kernel.org, jaegeuk@kernel.org
Subject: [Ocfs2-devel] [PATCH v2] kset: fix memory leak when kset_register()
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
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-ServerName: szxga02-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: vFALOJLLJ02586sUIKJnFlzyKM6Nz_eh
X-Proofpoint-GUID: vFALOJLLJ02586sUIKJnFlzyKM6Nz_eh
Reporting-Meta:
 AAH1wr0PR9FusETGm2SHXW4VXRHZ9CHqOwSJfpG2Vnso743XmCuPhqzPwWvHWObR
 pJqMo0hxuWK2cXW29uLga6YP6Wx73E0xqgIxYLIOs9RK+MJTgMr/62weg12NU66f
 aYwK9RdC7osmRZOrURV8SXc6RAJrJ3kd04CwpMSXP6JXyjxPK+8gvG4I4YZ04zZ+
 fphZ54wa6ObI98vH/qiXUDjafz5YCXOAS2UGtsAn6/QwuSXsSofUhDzLEDp8Yj2U
 vIkf8ZCeAVxlGzuvnxJkLHOPQjWUUr7KKF543ORDE/CLYMYBnQmVVNeqEWHXd4NQ
 MIQalJwJhdoJedMfZhsasUKw/q014UjG3+Cugevp5nbnabvq6ViAL9MZx5h1ok7e
 qFwdWtyjDpzrQwDuPHNSDUk96uq5ErS8+hPTe7pF57yNAgbsxyGo2SGsQbfVT8iR
 9n86wDMiCvjUJN35aa2MUI+TczZ9hcI+5IIFAjmAlvKgz1FmWwg4Pxuyfp4lamx3
 2+djO2sXLteGoNommdnbIxmGiBH6uuHipFjq51sp5g==

Inject fault while loading module, kset_register() may fail.
If it fails, the name allocated by kobject_set_name() which
is called before kset_register() is leaked, because refcount
of kobject is hold in kset_init().

As a kset may be embedded in a larger structure which needs
be freed in release() function or error path in callers, we
can not call kset_put() in kset_register(), or it will cause
double free, so just call kfree_const() to free the name and
set it to NULL.

With this fix, the callers don't need to care about the name
freeing and call an extra kset_put() if kset_register() fails.

Suggested-by: Luben Tuikov <luben.tuikov@amd.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
v1 -> v2:
  Free name inside of kset_register() instead of calling kset_put()
  in drivers.
---
 lib/kobject.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index a0b2dbfcfa23..3409a89c81e5 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -834,6 +834,9 @@ EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
 /**
  * kset_register() - Initialize and add a kset.
  * @k: kset.
+ *
+ * NOTE: On error, the kset.kobj.name allocated by() kobj_set_name()
+ * which is called before kset_register() in caller need be freed.
  */
 int kset_register(struct kset *k)
 {
@@ -844,8 +847,11 @@ int kset_register(struct kset *k)
 
 	kset_init(k);
 	err = kobject_add_internal(&k->kobj);
-	if (err)
+	if (err) {
+		kfree_const(k->kobj.name);
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
