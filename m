Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B08C5C4332F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 02:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=N5YBqJY4eTH5kqGNyOxsZt2QOM3We9V1np9MR4UDO9o=;
 b=JXCu/lDz9AyeBKUCcU5oFpDqsYJ0nU3qPvSEd5bbwS3YDoxXx++JuMZIJR3+0XaSKR95Xh3L++Mx
   o+Nhfmrc3Z+j+sRA1fKmrerIfQfE+6y+NkT3hNmIQ7bQ9Hfsdi7sU/BHvKVNz5ywzVenXxB1rV+y
   xJ497Xe15Ho2AbPEqPm06oYtsIG33TrXwcxefBwkVAPK4BwaLiuu2opMrh4vIZKeuIwlZQyZFJmJ
   ELK5tNJQ0S7I03sNKIge66KY8vxnsuNw5RZkSR2sSxbieCgXXEmnRtlB3gETFXZRkBlyu7ZxMzs0
   BrIc3jxQ96lAhDlYsXNMNdTE0PgwWGfKH3TGkQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=N5YBqJY4eTH5kqGNyOxsZt2QOM3We9V1np9MR4UDO9o=;
 b=eztg/4AnIcQmDNFaGzhs3tgxYHXEzYspLZLto7skWGxtbkk+mYe/c77vWvaMxIghaSS2mjLVhIR5
   NnkMFBTAEAnGxHYHpzMU27N8L1JIOCRUIArH6LfmS5Jwy1RoDohl/wKuTna8BEJ71ICStfbG4R4e
   jD5GvVbZqYBdQdOHQXEEIK06Scp8NO5cbVbyxJjzE3b/5btuxV0tuRKzOHuY7sjKC2Szpj0ibp9F
   zXHSLAuROf8W93bBrgkImCCQs2+wxRs/7W5Fk3FazmYtH+GCEDvur6NrEHR+mo/xFdaCMSn18qFl
   iO/gfYQIrHa5sHZC7OnQbdQt19jRingXOrUc9g==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK20093IZYC5GA0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 02:23:00 +0000 (GMT)
To: <linux-kernel@vger.kernel.org>, <qemu-devel@nongnu.org>,
 <linux-f2fs-devel@lists.sourceforge.net>, <linux-erofs@lists.ozlabs.org>,
 <ocfs2-devel@oss.oracle.com>, <linux-mtd@lists.infradead.org>,
 <amd-gfx@lists.freedesktop.org>
Date: Fri, 21 Oct 2022 10:21:01 +0800
Message-id: <20221021022102.2231464-11-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20221021022102.2231464-1-yangyingliang@huawei.com>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.103.91]
X-Source-IP: 45.249.212.188
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 clxscore=28 priorityscore=212 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 impostorscore=0 suspectscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210011 domainage_hfrom=8319
Cc: alexander.deucher@amd.com, richard@nod.at, mst@redhat.com,
 gregkh@linuxfoundation.org, somlo@cmu.edu, chao@kernel.org,
 huangjianan@oppo.com, liushixin2@huawei.com, luben.tuikov@amd.com,
 hsiangkao@linux.alibaba.com, rafael@kernel.org, jaegeuk@kernel.org
Subject: [Ocfs2-devel] [PATCH 10/11] drm/amdgpu/discovery: fix possible	memory
 leak
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
X-Proofpoint-ORIG-GUID: v0B_pgSsos_saQ-EQLZnPiFdw8tPCOCK
X-Proofpoint-GUID: v0B_pgSsos_saQ-EQLZnPiFdw8tPCOCK
Reporting-Meta:
 AAFMtwi5BHwwFqKq1tzSl3eDb3AYsPdhq2olwWkLrNVo510saKNNJuGq+LMYGR6s
 7ghht1iA6y9WGCFSygJhblFJBOCnFMSS0WuFD+2yt+dZoig6kXER86yvTUINI3Uz
 VMmj2ixLl6HavxD2MGZ5Kk5LOQzqOcVt4LXYd74cUXoYRdTvmZtyl+SwKg8gOC8v
 fnmPw0xtIj6LBdytYNiOLpS34y87iQKaVHYaC+6jVj9Hb2aaBpnWW8f6qZd7pSyI
 hwDbslGPYE+EBOo1cCM9Kz9QvAD9cUk0Df7ChY8G9HHCo4kLgZfJM8IgNqK1DMrX
 TNO+mxbfyV5yikJ3k/cP7yM2cqUjyaoavYgk4wtcm5pIAOvaB7sF9og3EgXRFhno
 jQdq3i/AZm/9SmzrNZfHOMTm4HUkLHnW1qrdKZIjxdls661Nk7Rx8MY61vMjoCOZ
 j4ZMM3fH/YV9/ucYph3KUzm8EZx5Jy9YRlP4pRoFH/r0p4qeHemZt/TwJSionAyr
 XPgV5GwaxkCADardCOdJcMxpJmhWvJmE0+PC1fJPiNkrHw==

If kset_register() fails, the refcount of kobject is not 0,
the name allocated in kobject_set_name(&kset.kobj, ...) is
leaked. Fix this by calling kset_put(), so that it will be
freed in callback function kobject_cleanup().

Cc: stable@vger.kernel.org
Fixes: a6c40b178092 ("drm/amdgpu: Show IP discovery in sysfs")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Luben Tuikov <luben.tuikov@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index 3993e6134914..638edcf70227 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -863,7 +863,7 @@ static int amdgpu_discovery_sysfs_ips(struct amdgpu_device *adev,
 				res = kset_register(&ip_hw_id->hw_id_kset);
 				if (res) {
 					DRM_ERROR("Couldn't register ip_hw_id kset");
-					kfree(ip_hw_id);
+					kset_put(&ip_hw_id->hw_id_kset);
 					return res;
 				}
 				if (hw_id_names[ii]) {
@@ -954,7 +954,7 @@ static int amdgpu_discovery_sysfs_recurse(struct amdgpu_device *adev)
 		res = kset_register(&ip_die_entry->ip_kset);
 		if (res) {
 			DRM_ERROR("Couldn't register ip_die_entry kset");
-			kfree(ip_die_entry);
+			kset_put(&ip_die_entry->ip_kset);
 			return res;
 		}
 
@@ -989,6 +989,7 @@ static int amdgpu_discovery_sysfs_init(struct amdgpu_device *adev)
 	res = kset_register(&adev->ip_top->die_kset);
 	if (res) {
 		DRM_ERROR("Couldn't register die_kset");
+		kset_put(&adev->ip_top->die_kset);
 		goto Err;
 	}
 
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
