Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92739C4167E
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 02:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1gwRjwrTndNYneoYKSzjAFm7IQx7lvt6QjZbNn6S3K8=;
 b=fAwBvbkaNIn/4cw69oNOdXWG9sF9w4PSZZqva6mFqJ47yImaADEaFLJf29NdfE6wuJz3yUbKXozj
   GuN74U7s5Fa8kAPTKTnrBsEX/eksJX0WdBnMjmvb5buU8ZY9Sk78ahMetwq+wTxmMnV2uokDmZjy
   5DYwZkwT4wY8ZBK2rK+37IErhyHVFNJTeTgzy4Am4tSH9UjdntyRcQLvbygx7BrEEZiQsD4wGkQN
   wEFJ0eO8bMxR6yW5Ey1XCgy7sp+dqkVHwtSk9lXxl3vd1L23mU3oJeqGVUwa0gbL2F0F3KzQncB9
   uBiUKXz8Jo6OyPVd8ETsIzSu08QB4w2LKZouLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=1gwRjwrTndNYneoYKSzjAFm7IQx7lvt6QjZbNn6S3K8=;
 b=VjNe1knWSSx9sqXW0tMrQzHoLcsQRqi6w9GGv9ZIFabRnwK9SV1TmksykC08643JpzW/IUyoxSL3
   XgpBqxQx58efq45MC6KeKRemGgNiguwufrxVIGGEPiLvekhYrSkPAmVRDpWxcen8g6tpbcZeLoZk
   s8Ej3Pmvlkt/ulcpxNPT4ZRfaH/aWN/3LlfkxILxukIHbAcRr/0hWRAdCrlCdDTNliYuk7uF6Q6d
   3TmSFLbjvJLw/VbegldGFJr+z6vY6GNFkZavr9AbWvG2mECLnSidtUs+22qVA1W3dZ+5RurqyzpU
   rVwWjtlCkN1sincf23LLQCR1R/87aySHqkts3g==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK2003LAZY8HB10@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 02:22:56 +0000 (GMT)
To: <linux-kernel@vger.kernel.org>, <qemu-devel@nongnu.org>,
 <linux-f2fs-devel@lists.sourceforge.net>, <linux-erofs@lists.ozlabs.org>,
 <ocfs2-devel@oss.oracle.com>, <linux-mtd@lists.infradead.org>,
 <amd-gfx@lists.freedesktop.org>
Date: Fri, 21 Oct 2022 10:20:58 +0800
Message-id: <20221021022102.2231464-8-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20221021022102.2231464-1-yangyingliang@huawei.com>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.103.91]
X-Source-IP: 45.249.212.187
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 clxscore=22 priorityscore=212 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 impostorscore=0 suspectscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210011 domainage_hfrom=8319
Cc: alexander.deucher@amd.com, richard@nod.at, mst@redhat.com,
 gregkh@linuxfoundation.org, somlo@cmu.edu, chao@kernel.org,
 huangjianan@oppo.com, liushixin2@huawei.com, luben.tuikov@amd.com,
 hsiangkao@linux.alibaba.com, rafael@kernel.org, jaegeuk@kernel.org
Subject: [Ocfs2-devel] [PATCH 07/11] f2fs: fix possible memory leak in
	f2fs_init_sysfs()
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
X-Proofpoint-ORIG-GUID: -l-e5P5K2P9HPsArZSShHjpMKoFrR0TF
X-Proofpoint-GUID: -l-e5P5K2P9HPsArZSShHjpMKoFrR0TF
Reporting-Meta:
 AAEk8cI6SBGj400tUcrYr93EVsvdBu2aoIrafaXLZp7VP0Ix/eTZFBNk4P/YZn1n
 brB422vd6Tc/Xf4CapwFsR8EnZdIUTuV0zWwtvHMMfF8txzPYIk/XOg3TSnJsew2
 dcwQqoJcoMl8Cby977+Sszo7wlygPcLxdvcUSW7Db22rBkOiPVki4b2QyKjwZnEa
 l4vD5T35U161s+WHwtf0zw5USEMjHupzIZIuWTDPauch+DQ+qJjbJ+eEA69rUiVp
 iZz7vvB6bKh32i+pCtiaZl815blPeYR05jxhasH8BJXVHBLpTCM3N6uLeGc2fQDW
 RJkrO2UWGYncLylcLPXpg1tZzvVzir1c9gbsxMjGe+a8yYDZmHKi+dnAuKFoivcj
 eeuJq/EH8ipv6n7ygPQ67oeWPa0evLUVc3YEYTjk7++q5v9yV40UJGg+5+RQUurt
 6dCK9aeOFLhne5tvaqmjzf9cc9Dtm5dfElPTf+NvKKWoamKnAIjoQA7I12zcNlyQ
 4SeT+qvBRRGwzlAaYYCDrhe7RkgFtfg4VSougV67UiM=

Inject fault while loading module, kset_register() may fail,
if it fails, but the refcount of kobject is not decreased to
0, the name allocated in kobject_set_name() is leaked. Fix
this by calling kset_put(), so that name can be freed in
callback function kobject_cleanup().

unreferenced object 0xffff888101b7cc80 (size 8):
  comm "modprobe", pid 252, jiffies 4294691378 (age 31.760s)
  hex dump (first 8 bytes):
    66 32 66 73 00 88 ff ff                          f2fs....
  backtrace:
    [<000000001db5b408>] __kmalloc_node_track_caller+0x44/0x1b0
    [<000000002783a073>] kstrdup+0x3a/0x70
    [<00000000ead2b281>] kstrdup_const+0x63/0x80
    [<000000003e5cf8f7>] kvasprintf_const+0x149/0x180
    [<00000000c4d949ff>] kobject_set_name_vargs+0x56/0x150
    [<0000000044611660>] kobject_set_name+0xab/0xe0

Fixes: bf9e697ecd42 ("f2fs: expose features to sysfs entry")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Chao Yu <chao@kernel.org>
---
 fs/f2fs/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index df27afd71ef4..2ef7a48967be 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -1250,8 +1250,10 @@ int __init f2fs_init_sysfs(void)
 	kobject_set_name(&f2fs_kset.kobj, "f2fs");
 	f2fs_kset.kobj.parent = fs_kobj;
 	ret = kset_register(&f2fs_kset);
-	if (ret)
+	if (ret) {
+		kset_put(&f2fs_kset);
 		return ret;
+	}
 
 	ret = kobject_init_and_add(&f2fs_feat, &f2fs_feat_ktype,
 				   NULL, "features");
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
