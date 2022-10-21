Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27417C4332F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 02:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=tTZfC3SjVnsZbcasKk4wwhSy2LkzTd4PkfYJNQYn3dE=;
 b=iRBvSz6VEKdRB9jbsG3fcl6sRkUnPZNhPmadyFzW4wJPlA/OpxtrczRhIw6fhKI/tQDijkcOfSX6
   mEQ3zwyzY+7EyptSTFTbtBR4m8ZgEaR72xXLL4bG1I+/1duahNvwvu+SAUuHLLbAks4Er+iKwliE
   03paOgGXgUC63shnncB3ZIYQuoQQoUgSwuF7YVC8Meaz83KX+/ZDkNOJbf5XvLHdAB9o25ra2Fx+
   pVSa81cXzKrqLKhUvBJLMJwS79p6LEjMX1f2IbazkK9UYFM2MyAmt0NHr1EkPbPZ5DfYeZPTzmtv
   C44NhMYoY4lBuBXQYaRRCMVXxWQnO9TTV7itRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=tTZfC3SjVnsZbcasKk4wwhSy2LkzTd4PkfYJNQYn3dE=;
 b=fUBmQWFpukLowvZbKjmqEDOTMvkY0YHMGPt1iovvRmwoWVvQ3kAk/Un9kY+yNA20LPSn/OpULDqM
   2aOasRKsK9jwSgJk2APAuXp5OehT32AcrgS2N9irC/5ueenO0LJhQNC7FY6yHTiKsPHKNSB5LlgJ
   8BuyHMSJZvGG9x5dYGceQ4pGwi0D79KypvUAuZ1AlQfzZ1eWUFmFEM7942ls0P/P1Zn9IAkfiyhK
   Jo4wW0fuM0czklnc+OuyT6mL8R8JHYHT2nqRi1a7VHjmRX7ew4XZbyDEXdEZ7kdn8qSdpdoLQQrz
   xTDyFe/hbv/R0+zA55LozQkAuTSWn8GvYVejHQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK2005MPZYEAE90@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 02:23:02 +0000 (GMT)
To: <linux-kernel@vger.kernel.org>, <qemu-devel@nongnu.org>,
 <linux-f2fs-devel@lists.sourceforge.net>, <linux-erofs@lists.ozlabs.org>,
 <ocfs2-devel@oss.oracle.com>, <linux-mtd@lists.infradead.org>,
 <amd-gfx@lists.freedesktop.org>
Date: Fri, 21 Oct 2022 10:20:52 +0800
Message-id: <20221021022102.2231464-2-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20221021022102.2231464-1-yangyingliang@huawei.com>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.103.91]
X-Source-IP: 45.249.212.188
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 clxscore=23 priorityscore=226 mlxlogscore=771 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 impostorscore=0 suspectscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210011 domainage_hfrom=8319
Cc: alexander.deucher@amd.com, richard@nod.at, mst@redhat.com,
 gregkh@linuxfoundation.org, somlo@cmu.edu, chao@kernel.org,
 huangjianan@oppo.com, liushixin2@huawei.com, luben.tuikov@amd.com,
 hsiangkao@linux.alibaba.com, rafael@kernel.org, jaegeuk@kernel.org
Subject: [Ocfs2-devel] [PATCH 01/11] kset: fix documentation for	kset_register()
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
X-Proofpoint-ORIG-GUID: O3PX0XqMVDdY3SDUHkCQsP9Q5xRUXIwP
X-Proofpoint-GUID: O3PX0XqMVDdY3SDUHkCQsP9Q5xRUXIwP
Reporting-Meta:
 AAFEKcQ8UBbaG/LbfAg6wNx6jrrm80gKaG4bC4wCYzffaCJR4d9eGPI9F+fpLC4C
 1dFQ3wRcF15HgthtxC3t/e62Qc2/CscXcpJVJFQXxi1zuHhpsrCTNum9lHZpPT/m
 Y3DkAR9Z6qsuYu2I4g5QFJN2Z3jW4TaA05+Sw31/5qgys/z95uJV9G2InHOYly+C
 Pv5XyRSawVmDQoxLSIOXkMbsx4vmJ/VTJ5SGqM5Ni6NgNBUWBVKF5GSFJEapK18y
 hIkt/hbn+VDBP6TotkNLo9XLmkSHGU5ZWWvmzDIlQM8qP/qfo8WUxFsVcgPtGIQa
 s11AzZ3++lizteRxcnI/3bYXcpMwO3fOhUNNHSwX0QI9s7c9VdI2AYn59cDGyb3P
 OvC1TrzC+jmZrj0xRcgVZ1cJI71Ma7IRPdh6EqRU4ngoGiRUduWqYfJnEe/MZqh7
 58+hHGdyFTs1DaW7uyMxvMGHE0odW75cidThRVZ0vUWz+xG/S4uFH6vhU5C+9eMD
 iQAHPXzft98eOMLMeJJLSvDXpmYKKBPH4EZ54fzry5xc

kset_register() is currently used in some places without calling
kset_put() in error path, because the callers think it should be
kset internal thing to do, but the driver core can not know what
caller doing with that memory at times. The memory could be freed
both in kset_put() and error path of caller, if it is called in
kset_register().

So make the function documentation more explicit about calling
kset_put() in the error path of caller.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 lib/kobject.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/kobject.c b/lib/kobject.c
index a0b2dbfcfa23..6da04353d974 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -834,6 +834,9 @@ EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
 /**
  * kset_register() - Initialize and add a kset.
  * @k: kset.
+ *
+ * If this function returns an error, kset_put() must be called to
+ * properly clean up the memory associated with the object.
  */
 int kset_register(struct kset *k)
 {
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
