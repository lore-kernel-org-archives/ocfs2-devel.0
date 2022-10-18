Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 679D6C4332F
	for <ocfs2-devel@archiver.kernel.org>; Tue, 18 Oct 2022 07:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=bE4NRJvQxz/X3+vv4xmkz2VGy1SgzVFgPJHMxDv+hSs=;
 b=rKkSewQc5ZqATLFijhvEviMRW/3aP/3pXvaJ9KfoxtpKZpdilDEEMo/uRtzA+ZQo/QPCIlLEgW2p
   9F+Eh8BgVrDRTa7dHaEe6Wj+2r1viz2zFjWJzcNrXTD0o/v2+/heo+mYNAUlinGpILfRW1444QF3
   hpmGEEIvNXzc19+gkrLKVQyxzaTdggY8E1vy7eWzbZBJ1Aipw0cSzKBy4K+26bYLJO18n2AVyw6o
   XhdTUfU2yjVhF06lIubsQ+bbx58AwNErbt+neEKxnILAI+7OHAV3ZkNy44sDJecqPs21PA+xwDy5
   hWs5gPouivfn36TB+CzBCy4uMdVGMtgPdsjEow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=bE4NRJvQxz/X3+vv4xmkz2VGy1SgzVFgPJHMxDv+hSs=;
 b=pdDyVKZGEF1S/LcFHdc4r7TXeXUUM3mgDLcYQflzmUGSoEeE8SygXKNXNfgQ2dFTfl2ECsmgk9yb
   l2VnWiyKSnJF2b0P42clLSsYmdZL0pMMWBJJ4zzKAZIjk3kZqC8lKy1jR2OWw9wj9UCe2HEl2twH
   tRhrzNWKt3EpOiuMMJER7Hxu9otywlvAY56rJ3HzjxBfccwUDHxc9kPsGSva+01MuMGMgxUYuHge
   3uYc3L2/QXnxnP6JOBfzmBRs/JyXsJnPxnpEcp+lB/ee6fZHlIGPlQ25aCukwDgO4/SOCyBji+al
   tyzIqt28cSHUBa3DgHbOYGGocQKZj8yJenNXKg==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RJX00FPCV8Y5310@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 18 Oct 2022 07:53:22 +0000 (GMT)
To: <linux-kernel@vger.kernel.org>, <ocfs2-devel@oss.oracle.com>
Date: Tue, 18 Oct 2022 15:52:13 +0800
Message-id: <20221018075213.736562-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-version: 1.0
X-Originating-IP: [10.175.103.91]
X-Source-IP: 45.249.212.188
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10503
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 mlxscore=0 adultscore=0
 clxscore=8 spamscore=0 suspectscore=0 priorityscore=175 mlxlogscore=999
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210180044 domainage_hfrom=8316
Cc: gregkh@linuxfoundation.org
Subject: [Ocfs2-devel] [PATCH] ocfs2: possible memory leak in mlog_sys_init()
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
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-ServerName: szxga02-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: wWC5MpwBFnRKGsPFxp_77vDIBVtQNfbM
X-Proofpoint-GUID: wWC5MpwBFnRKGsPFxp_77vDIBVtQNfbM
Reporting-Meta:
 AAG8Jx07JzgR1pFQwkmO4jiylaawf5Hb8N5UBpXkMpoft0J8mCURuBdjmbJM9fSS
 3bF94J3DTHX4morM92OjtDv4U3yjCNtUe8i3boDstJ8qeUrk7i8VbojGO8zwzzJW
 PJ90sT/pm8eilGL5pnuNwSZVq42xDAdVt0yK9//HJl0pY/6T0sbEQxJ7lZ29w56N
 ENx9JKXwi5MOvx2MQ6/jbU8QXM2gR1v56ypyw4dkMG/hZ155H8tmN6f+fcy8+RxN
 ViFSghoYQnNvtxuN4C7nLTBaPP0UeWu5XyxTaDr40V6l+NUf2qNZsmFmBdmg1p4a
 f1MVWSvsbxo4NerqY8BT0xzwkzdIrN5n0v+B7PxB511YQVtXsO7m/gRVFO/PsLHx
 hZiM0UyJZDkLwMYFpsA77fVhSkxcjJws0PGF1eEUW56jFp0XjS47+rKR0SClrvRq
 7T2+JyGGF9Ah9d9rz4umNKNrcMXh9/DH1wpQ2O0j8GiQcXoP9aznRGxCkSHAebqa
 IaAcYvadf7mZQ58z8iYr/WBD81tmotMBz1Ze8Kt9NAtA

Inject fault while probing module, kset_register() may fail,
if it fails, but the refcount of kobject is not decreased to
0, the name allocated in kobject_set_name() is leaked. Fix
this by calling kset_put(), so that name can be freed in
callback function kobject_cleanup().

unreferenced object 0xffff888100da9348 (size 8):
  comm "modprobe", pid 257, jiffies 4294701096 (age 33.334s)
  hex dump (first 8 bytes):
    6c 6f 67 6d 61 73 6b 00                          logmask.
  backtrace:
    [<00000000306e441c>] __kmalloc_node_track_caller+0x44/0x1b0
    [<000000007c491a9e>] kstrdup+0x3a/0x70
    [<0000000015719a3b>] kstrdup_const+0x63/0x80
    [<0000000084e458ea>] kvasprintf_const+0x149/0x180
    [<0000000091302b42>] kobject_set_name_vargs+0x56/0x150
    [<000000005f48eeac>] kobject_set_name+0xab/0xe0

Fixes: 34980ca8faeb ("Drivers: clean up direct setting of the name of a kset")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 fs/ocfs2/cluster/masklog.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index 563881ddbf00..7f9ba816d955 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -156,6 +156,7 @@ static struct kset mlog_kset = {
 int mlog_sys_init(struct kset *o2cb_kset)
 {
 	int i = 0;
+	int ret;
 
 	while (mlog_attrs[i].attr.mode) {
 		mlog_default_attrs[i] = &mlog_attrs[i].attr;
@@ -165,7 +166,11 @@ int mlog_sys_init(struct kset *o2cb_kset)
 
 	kobject_set_name(&mlog_kset.kobj, "logmask");
 	mlog_kset.kobj.kset = o2cb_kset;
-	return kset_register(&mlog_kset);
+	ret = kset_register(&mlog_kset);
+	if (ret)
+		kset_put(&mlog_kset);
+
+	return ret;
 }
 
 void mlog_sys_shutdown(void)
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
