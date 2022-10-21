Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55889C4332F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 02:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NeOAvwG78rHJLvEg1egwz1eV+52Ia32p4j2uGLArlfA=;
 b=FL/EAXrKnpIENNk+KR6xip7se/mLBa0Y0YxBOZfbgE+25j7DXDz+UOgHmRZ5Et+0MJ88OEWoIEKk
   LTVSewr5z0UesPNFN9ATd7dzhRDU1YHP6QKyz68cbKluXxWaTV2Esd7AKR3QA8DMXmaZgmNh729a
   0y9oEdMRzEFA6qqQIerZ8Pg14BZZrJaH+DbYUoA1mNb/TWwTNaFHL9ip5DVeDDxSJntdN/VXgOEF
   AXpdIhlG5hEVeKjinVsU2ydZ5+nXyFqXXSSMCSts7EN07p/SDPGXSf914j9JxMgsGaJuoAiGZ597
   XZjBSslKYdFP5SjgqNsgRpfRpJp0jU9k/mFXKQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NeOAvwG78rHJLvEg1egwz1eV+52Ia32p4j2uGLArlfA=;
 b=i2UBkyAn9Rb6FaPjNMxaiWq/AVJdA37U+gYh6z3kkqpZxoA6gyv5xDRLgF0Yfva+JCWCrAFsNb4y
   N1y/gSUDrh2josX8IM4Uuwn/Kf8DJrLlQaHuMeSzG6vs/nv8Zi3WdBpTpHY+4WC4JhnfZ7z4Dviv
   AbPyyWsMSd7ZcW2LlvEOU9CtFhsYrP6ubDsdtb7HyK7Si39Ftw4jXsn34WRzxO+qMxS+oc5914o5
   fVBE+sPnH1zGy0BgM5rsXDi3H5Vjc4qCSfZEyO0s2C3f13bXo3mifGlKsAxvoOqAruRK+JolQy3M
   6cPIDtK88LwOsPwhndhb811jQNXJul3FafONRQ==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK20094KZYF5GA0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 02:23:05 +0000 (GMT)
To: <linux-kernel@vger.kernel.org>, <qemu-devel@nongnu.org>,
 <linux-f2fs-devel@lists.sourceforge.net>, <linux-erofs@lists.ozlabs.org>,
 <ocfs2-devel@oss.oracle.com>, <linux-mtd@lists.infradead.org>,
 <amd-gfx@lists.freedesktop.org>
Date: Fri, 21 Oct 2022 10:20:59 +0800
Message-id: <20221021022102.2231464-9-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20221021022102.2231464-1-yangyingliang@huawei.com>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.103.91]
X-Source-IP: 45.249.212.188
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=233 spamscore=0 malwarescore=0 clxscore=26 impostorscore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=949 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210011 domainage_hfrom=8319
Cc: alexander.deucher@amd.com, richard@nod.at, mst@redhat.com,
 gregkh@linuxfoundation.org, somlo@cmu.edu, chao@kernel.org,
 huangjianan@oppo.com, liushixin2@huawei.com, luben.tuikov@amd.com,
 hsiangkao@linux.alibaba.com, rafael@kernel.org, jaegeuk@kernel.org
Subject: [Ocfs2-devel] [PATCH 08/11] erofs: fix possible memory leak in
	erofs_init_sysfs()
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
X-Proofpoint-GUID: TJmuXEsCBljUeT9fLhUpHfu9fB6ApE0I
X-Proofpoint-ORIG-GUID: TJmuXEsCBljUeT9fLhUpHfu9fB6ApE0I
Reporting-Meta:
 AAGlgu0ENsCPw8rh3Kf8s6PW7qCmBFuxELGMl2io4HguAuPCuSj0ejCx87uj89dB
 d3fLfiYyG1q86R7ShRtdI8TThKZgdk3kTxN+I9KlCUE92H/P+ylwI6pxlvqKRi1v
 tJB/oh+fo1LdF77P+ksmvG1/LLuYpu00c9TKpTRd9tZulinYGQ/adLBX0Fi6PLH7
 hMWbmkQsX3WlX/k9uDYBdx6wiP7UZeL0/EPGP/Sb1TWmQxuItocfNJyxB2+67TvS
 FqFkUpEazYze/AB8QzfADwuZkfAaRKWYtTF44CL0ak4vyEz4CKMXlAp/pdGFLqyQ
 Wy1pPtxNLPikaTZ6o+DyOo0+6z9c3k/fkWJrrJe+jaLTz2M/yr7mEtnrVLNWVCs9
 nvyWLaxeYbW8W1wse1dd34meQ1wPLLPDnA+pfejNLZxmyfuszHRTtm71ckyg8DI9
 2IxSUTHfoYsSqCPfQeoEGo7CfVf4IIA8cxGQvm3Mb6/tjx7LvBXd8B07BXrZiomE
 hbAan1syMEAUC2JHU0CGixtIYDJYc5u2oufNj+/xOcFm

Inject fault while loading module, kset_register() may fail,
if it fails, but the refcount of kobject is not decreased to
0, the name allocated in kobject_set_name() is leaked. Fix
this by calling kset_put(), so that name can be freed in
callback function kobject_cleanup().

unreferenced object 0xffff888101d228c0 (size 8):
  comm "modprobe", pid 276, jiffies 4294722700 (age 13.151s)
  hex dump (first 8 bytes):
    65 72 6f 66 73 00 ff ff                          erofs...
  backtrace:
    [<00000000e2a9a4a6>] __kmalloc_node_track_caller+0x44/0x1b0
    [<00000000b8ce02de>] kstrdup+0x3a/0x70
    [<000000004a0e01d2>] kstrdup_const+0x63/0x80
    [<00000000051b6cda>] kvasprintf_const+0x149/0x180
    [<000000004dc51dad>] kobject_set_name_vargs+0x56/0x150
    [<00000000b30f0bad>] kobject_set_name+0xab/0xe0

Fixes: 168e9a76200c ("erofs: add sysfs interface")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 fs/erofs/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/sysfs.c b/fs/erofs/sysfs.c
index 783bb7b21b51..653b35001bc5 100644
--- a/fs/erofs/sysfs.c
+++ b/fs/erofs/sysfs.c
@@ -254,8 +254,10 @@ int __init erofs_init_sysfs(void)
 	kobject_set_name(&erofs_root.kobj, "erofs");
 	erofs_root.kobj.parent = fs_kobj;
 	ret = kset_register(&erofs_root);
-	if (ret)
+	if (ret) {
+		kset_put(&erofs_root);
 		goto root_err;
+	}
 
 	ret = kobject_init_and_add(&erofs_feat, &erofs_feat_ktype,
 				   NULL, "features");
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
