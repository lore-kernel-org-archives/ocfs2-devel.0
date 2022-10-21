Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 321C2C433FE
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 02:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XsV3dCli54Rly92a8cFogLV/eF4nO/tsMaNeqYXLjOs=;
 b=MPHJ5YMr/R6hTcqMz0Ypm6LzS05WKSy0HaoIVvdHk+oOiSA0ZRDNlFciOul7q+4HSnr7Xse3au9f
   bH6Ijwi5Ll6HeqycSZBxL841OvsaiAnUVLHAoGx1QzSfUxma6zIDAeWKzYp36qgTSQfP3Z6RLw7w
   OBNi/gHWwX4Y9KtEQIYegSgb/dy/IwxvBXSV+8ed4ydAkbHBYQ2nPtln6Y5KACZvP4yNBWqpRE1+
   9mxBNBTAI8ronC5yB7EFiJMky5fNq3e4A2KdHyClarrbmJdgJIAfFfrjtqvIsrIN28GxWaJPMWFp
   sPiMS6FXnV/argyNb2EEG/VHIekNmVRtqDmtJA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XsV3dCli54Rly92a8cFogLV/eF4nO/tsMaNeqYXLjOs=;
 b=rz6PKX/HhQTW7rC3zyIqkiG+vOD7lYKMHod6Df3djGX/eQQuHSHlD3LtOWX5DHLGxN7c22tOFRyC
   ULmz1L6YYedpdsKkVUbJyJcOSk4F08uHO8I6QAeSy8tjCwuiznkzLNvveAj6LF/72X04UhlPtGjE
   qczv4JV9Rug8Z0l0gOjycSY8xB8SrW8JQRR1hBjXa7qqrU8phMj+uOcBp24CtQ7g+kPAXP24+qBC
   FmREJ8GoxOkUNNfwt9Txh0+XI0Zr/vLYcPJNll6eOsbX+hcsFb6/jcJ/IWF6G5WgG40O2+XNcw3j
   1TcI4GozVNIABRNrpEC+T23JOCM5AsWr3/wsaw==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK200HQRZZ5I150@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 02:23:29 +0000 (GMT)
To: <linux-kernel@vger.kernel.org>, <qemu-devel@nongnu.org>,
 <linux-f2fs-devel@lists.sourceforge.net>, <linux-erofs@lists.ozlabs.org>,
 <ocfs2-devel@oss.oracle.com>, <linux-mtd@lists.infradead.org>,
 <amd-gfx@lists.freedesktop.org>
Date: Fri, 21 Oct 2022 10:21:00 +0800
Message-id: <20221021022102.2231464-10-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20221021022102.2231464-1-yangyingliang@huawei.com>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.103.91]
X-Source-IP: 45.249.212.188
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 clxscore=-57 suspectscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 impostorscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210011 domainage_hfrom=8319
Cc: alexander.deucher@amd.com, richard@nod.at, mst@redhat.com,
 gregkh@linuxfoundation.org, somlo@cmu.edu, chao@kernel.org,
 huangjianan@oppo.com, liushixin2@huawei.com, luben.tuikov@amd.com,
 hsiangkao@linux.alibaba.com, rafael@kernel.org, jaegeuk@kernel.org
Subject: [Ocfs2-devel] [PATCH 09/11] ocfs2: possible memory leak in
	mlog_sys_init()
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
X-Proofpoint-ORIG-GUID: 3Z4TGLUbYuCMskNs4tIYmv2qQ4LWT_7l
X-Proofpoint-GUID: 3Z4TGLUbYuCMskNs4tIYmv2qQ4LWT_7l
Reporting-Meta:
 AAGRfGcH+HM0znrHhE+MqXw+8rwTsEduEoCGfMVT0xNITIm7ixlJ+aKkrqMYLBnI
 kaMareD/2PIJAVUIW9YcOQ2336aEbj+9oHC1XfMWWfCytzFgYWCn00wv8kgOdQ7T
 Dv5pZuNhUrE/v0P5uqGXSJ8ScWS/8lcQTt1NSd4qMeRsdjGYECtq/O+wAaJf2HlG
 QUsX66C5/PWPu3kng9LvFP0dSrPS7W4My9pPdcrEJH3/zofd+uKvz3YsELZPFIjm
 O4O5C5QX/MTrRzTB0m1aiCGfDku6vwG7bAm6ekU/YQRP1N+Ha6OMXAUnP93dS68v
 8G6WnEmtS/476q6Pq5EiE90Sgdvmq0UlQNq/UE/nY/GcM2xCPZHGw/N8KxESLd4Q
 SWi9f7SrlxjvFkpiUBMd3i1n7pu1CFzFnghJZ7iX0iqDosQ/BzaLE7wOgz2nd1JP
 Q0d5Rc3xOnQbqxnz07HEeUeisk25kYSanwYIt6fBDAGkmkfJRuv1/YL9TikwL/9S
 Vf0p/MaJR1AdHgbRe92wfpO9INX6bgu8fmq+bqOdRb0H

Inject fault while loading module, kset_register() may fail,
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
