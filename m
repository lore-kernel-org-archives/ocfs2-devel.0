Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FF62C4321E
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 02:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lEJGt0NIZ4HFju9VZsWGdn8zPFWgAqsQlns99LkFCA8=;
 b=vt3898MkAcNlR9nISGOzkAjTC57QFkHXD9LoxOXOhMu2vxYA4Heg9zH5XRKsF5//fp3XhAzZmWjT
   Fsg0t60PG/OVdpHGHd7bcOC3O7OM1XtAA0XVHGcQ4ILS2KZMIjkR+TGD6/Hu63wCo3TNIN1/FVo3
   vJRrI+cxSBiHuNzk3SZ6v78RPD02vtmvBaWswmlzRkwqj6CiJhM+7of9f5IU8cEhuXijEf+HtvoQ
   BRZ9uJGtt4ZT/Nz2GPqyzfR9cBqyhnM5o4SnRag1CjGqk/BZxrUuKbiAAMvam+X6/cGUomrhV7iO
   d9lNgQr3wHmdJVkvjKvPgVGBTHlqJ28Ww8XlFQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lEJGt0NIZ4HFju9VZsWGdn8zPFWgAqsQlns99LkFCA8=;
 b=nAdloEKQD35v81/w+ripL2XNB9MjW6GZeqmwVr0kJoFaD6UMwz78yHQhAfCQKXy1SfdowXtWJYv+
   ACkGeG88ngbcwFrMyx7/tQBgWuXGtqdBuW/Ih3tlTDzZqjOYuXtW7bijtipU+EN9pK99WriG1j7e
   9qjnQ8IwZt+1DuxW0z/qRfGsRZBOPPO+KTBddWBylOVaG28pkakDXFeyN9+lJQibevW8i0GeGynn
   Wnwy+jJSNitwHHDWFUvd7aSFG86c/nbG1XghuU1ah2xcuW1z6yq3ecwckSrqcmqanlrxoK9WyQN8
   33VM/LyVJsMQbaeID9PwgZXYlPqdWrJXmw0XHg==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK200GX2ZYFNKB0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 02:23:05 +0000 (GMT)
To: <linux-kernel@vger.kernel.org>, <qemu-devel@nongnu.org>,
 <linux-f2fs-devel@lists.sourceforge.net>, <linux-erofs@lists.ozlabs.org>,
 <ocfs2-devel@oss.oracle.com>, <linux-mtd@lists.infradead.org>,
 <amd-gfx@lists.freedesktop.org>
Date: Fri, 21 Oct 2022 10:20:55 +0800
Message-id: <20221021022102.2231464-5-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20221021022102.2231464-1-yangyingliang@huawei.com>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.103.91]
X-Source-IP: 45.249.212.188
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=226 spamscore=0 malwarescore=0 clxscore=23 impostorscore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=952 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210011 domainage_hfrom=8319
Cc: alexander.deucher@amd.com, richard@nod.at, mst@redhat.com,
 gregkh@linuxfoundation.org, somlo@cmu.edu, chao@kernel.org,
 huangjianan@oppo.com, liushixin2@huawei.com, luben.tuikov@amd.com,
 hsiangkao@linux.alibaba.com, rafael@kernel.org, jaegeuk@kernel.org
Subject: [Ocfs2-devel] [PATCH 04/11] kobject: fix possible memory leak in
	kset_create_and_add()
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
X-Proofpoint-ORIG-GUID: Xo6-ACIn6yJR26KbFCHU8oNyV5h8w2iX
X-Proofpoint-GUID: Xo6-ACIn6yJR26KbFCHU8oNyV5h8w2iX
Reporting-Meta:
 AAHT9m4BIahXJxJNeD4S1FXEmiBtO2wCBUhPljmKFmaW/kaqUYwylb5oUCfALIkQ
 dreHlAkGb++jQppXC8/myxBMKCqIPxYjxnwEvqMtSWkdZ9lduUUhGqWxWkCTJmp+
 Rlq80LqeLzAbDinfoqDcLrgItnPRCslAfHKGULED9U6R4XRjOuedArGelulT9Uhc
 8AV0dNDpIn0ZojVm3vRoIi9JPjcm912i9fTmpPDjsUVU3UINeqnEAWlhiolTeSZ9
 ZtDhlO3vNWjA7N2CXQUi5r7HXMz7+qnEa5c+Rf8m6zF5VNZVYjZklPxYbKpoI8kQ
 ZZVB3pXloBxbh9Gh6lzc/qvvqIk5moChJWhghuzbf/wa9zLyYs6IK51Tu7rcmq/n
 ij+0UHTR8DOtmI4SzNyIBj16eolv25rkn0feq12+tVCKfi6raNKL6AcrOdhW59ct
 UG8l+snNtu1SaNI1fGJlguFS1rIcJPOK/FzZMZSZJNAjubIlB4JgKQ3NB8ntLzAF
 JvlbNLsFU2evOdl888wQVOe2WhiqT43IpkWWmCy2KIMb

Inject fault while loading module (e.g. qemu_fw_cfg.ko), kset_register()
may fail in kset_create_and_add(), if it fails, but the refcount of kobject
is not decreased to 0, the name allocated in kset_create() is leaked. To fix
this by calling kset_put(), so that name can be freed in callback function
kobject_cleanup() and kset can be freed in kset_release().

unreferenced object 0xffff888103cc8c08 (size 8):
  comm "modprobe", pid 508, jiffies 4294915182 (age 120.020s)
  hex dump (first 8 bytes):
    62 79 5f 6e 61 6d 65 00                          by_name.
  backtrace:
    [<00000000572f97f9>] __kmalloc_track_caller+0x1ae/0x320
    [<00000000a167a5cc>] kstrdup+0x3a/0x70
    [<000000001cd0d05e>] kstrdup_const+0x68/0x80
    [<00000000b9101e6d>] kvasprintf_const+0x10b/0x190
    [<0000000088f2b8df>] kobject_set_name_vargs+0x56/0x150
    [<000000003f8aca68>] kobject_set_name+0xab/0xe0
    [<00000000249f7816>] kset_create_and_add+0x72/0x200

Fixes: b727c702896f ("kset: add kset_create_and_add function")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 lib/kobject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 6da04353d974..e77f37200876 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -985,7 +985,7 @@ struct kset *kset_create_and_add(const char *name,
 		return NULL;
 	error = kset_register(kset);
 	if (error) {
-		kfree(kset);
+		kset_put(kset);
 		return NULL;
 	}
 	return kset;
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
