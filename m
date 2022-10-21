Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86A7FC4332F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 02:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=zFveVdAmxbJoy3lP0CxUnTe5MlcjJr1wqy0vZcx5dnQ=;
 b=vKdvE3WKD93AenRPCaGpiM8oFOGUXEycpDpLRObIdGSe7NcaTO7U3JpfbaLY2e+km8Zc6tjICYlQ
   paYT5V3IUJ8MtFUmc4AQ63T70bRrxBEN/mt4n1K9ZYmslQghB+euqQiJKTt75mDSgikqUq2L6NY7
   3P9Wb7SpQCs0NBD7sg+sY8Qlf5GewpMn3diuoUvotyM8hFxTPEUJdxdnFwVHImfiQMBDnCOBm6dn
   4VM6hZdfLWM/NsxJz0JtEH7ySZdQdyqQve8G0cGa4hMx2apBKZQRETtdzUE35W6LET6fbsHXbub7
   6bbsxsZuHliynMvq6ln+UlrgEjvofZkljbVseA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=zFveVdAmxbJoy3lP0CxUnTe5MlcjJr1wqy0vZcx5dnQ=;
 b=K0LVXcTiedxPQbXgDEV1m7mTgeqBkrtZ8mjutJOV/4sNOYwoXFjNZsaHBZTn3qFQe4zNkOeBWvsI
   lKRKfC0FnCmKLqOL71ckG5uJeGFIz9hPrcgeAxJCWNjggX3RBaSSIxWLsEonIN1yMffWsm6YK/fy
   Y9DKxAtxc2qTL7B1+bUN8oIODlqi/ERU7yN9thhTyshKYh7wNJPBlafRkn+4fsx8V1QrqZNaPUwr
   3bwD+gDrAXzWSNzNM8tKo3hKZcyE0LZGhNquTR6EWMLb6yl2kFZA0m01QXiqeMEfgHGpqX0UDvFC
   B2spkmhCWmQ+FDhY7mQagIsS59L3BTfXES5u0Q==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK200A8JZY4HD70@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 02:22:52 +0000 (GMT)
To: <linux-kernel@vger.kernel.org>, <qemu-devel@nongnu.org>,
 <linux-f2fs-devel@lists.sourceforge.net>, <linux-erofs@lists.ozlabs.org>,
 <ocfs2-devel@oss.oracle.com>, <linux-mtd@lists.infradead.org>,
 <amd-gfx@lists.freedesktop.org>
Date: Fri, 21 Oct 2022 10:20:53 +0800
Message-id: <20221021022102.2231464-3-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20221021022102.2231464-1-yangyingliang@huawei.com>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.103.91]
X-Source-IP: 45.249.212.187
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 clxscore=15 priorityscore=159 mlxlogscore=810 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 impostorscore=0 suspectscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210011 domainage_hfrom=8319
Cc: alexander.deucher@amd.com, richard@nod.at, mst@redhat.com,
 gregkh@linuxfoundation.org, somlo@cmu.edu, chao@kernel.org,
 huangjianan@oppo.com, liushixin2@huawei.com, luben.tuikov@amd.com,
 hsiangkao@linux.alibaba.com, rafael@kernel.org, jaegeuk@kernel.org
Subject: [Ocfs2-devel] [PATCH 02/11] kset: add null pointer check in	kset_put()
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
X-Proofpoint-ORIG-GUID: 12Fm14NVohcr8iv7XPotQtIrbeAbZQjP
X-Proofpoint-GUID: 12Fm14NVohcr8iv7XPotQtIrbeAbZQjP
Reporting-Meta:
 AAGlgu0ENsCPw8rh3Kf8s6PW7qCmBFuxELGMl2io4HguAuPCuSj0ejCx87uj89dB
 d3fLfiYyG1q86R7ShRvHIsTThKZgdk3kTxOyZAXgThD83cTpE8764H1tNPpxRy68
 +OVdmVokB02yCZWvdtXd6RzvcR++YFlKonaX4B8qsMQAxnausxskkKro8HWgeCWo
 7urkeC4sWsWXiY/68iYEMcjBVF7WqrarczcIK+v9vL1y4LlX+3UEzdL2Ao90+CE3
 1xyQ7AaGkEzmqOkoF2A9/EXRhLG+EbGfDw7YbrOMpcDq/dBCKBxQN+JL4f8iJZtO
 TfNnvj67a9odb+36qpkcVf56/8zf0T/aHMPpR5LE7jC8g1XINyMskCVNaXst7Let
 0JTHymSGUQBfZx9QtSp6ENKa5Rd+SvhDsCz/4w3E6+JZdXVbUNfxoKTKA1Lomq0Y
 VCCqBPChFVpsMiXFlNZVxHhHuaPhg9VEqyMwqBlTJseMox51Rrn8BiBWk3drWwh2
 wEtfzAtqPYjOyoICHD0HVlPODAwcxPjvvW07NP8aoSdA

kset_put() can be called from drivers, add null pointer
check to make it more robust.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 include/linux/kobject.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 57fb972fea05..e81de8ba41a2 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -195,7 +195,8 @@ static inline struct kset *kset_get(struct kset *k)
 
 static inline void kset_put(struct kset *k)
 {
-	kobject_put(&k->kobj);
+	if (k)
+		kobject_put(&k->kobj);
 }
 
 static inline const struct kobj_type *get_ktype(struct kobject *kobj)
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
