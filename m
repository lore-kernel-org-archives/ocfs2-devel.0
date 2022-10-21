Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 791DCC4321E
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 02:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9qMHzyWDLTiShrgxR1+3bOyrfToofGFuDVf7bqH+ozA=;
 b=DWdALEq5GOOijmJPl/EiQyCKpXCEDKq2VMZkDaWy5Ska3ubqTSfED9i0ScKQ9Nrg7xXT7/PA66qT
   MLesixbexo7zlgWiQWX512sTpxYHTEcE1wfLl+UqyMRelT0ey2P+6tL+r3YsZtZ5h2OTybskCf1a
   mYMfCUUpe73grjC8rHrYTgch8tc+M6i5zAWwQimf/UAWFfrsDWesFx4JwVUxrw8cg+J06+D+PyWA
   IsdGvgpd5baVqHdPMSDGSZX5TMkaXERcY6Fe4KhtQU7KypYYZyUPC13q1KryopbdudtjKRW/bUvo
   eNL9Jqk+D58wttl9OYyaAps2hhG0GXrBjJhwww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9qMHzyWDLTiShrgxR1+3bOyrfToofGFuDVf7bqH+ozA=;
 b=ooNQ7UjEyDAp0oMiZBqWkUOtEecpnK9yugo+YTzmAMn73PL+4mZwuNqk03VWGOD3qmeVVkLrMlEc
   R8gQqlIL2OwFuvQDcVPANY1R9Fkz2Ptl+l/YOUBVoHrINeNg0dI7OdvSmPF5EtnyhPGOO7IxqUlw
   /kOXVMWqLZ/5JrVKxc9DVPu1cbH+T4Gnbzaiil4qUoItbIzrOqxFJF7K6kNNBf4JlvMgW9yg3FEz
   KpsEidIK6XZIVXavZe0E1YdbP315fNGdRpUocIkYldM6ji51gzg+GnVftVOV+rvLb+5d1JWiuH9v
   7KWWICDbCbKKXqBxZr0NdorJDwZ4cW6IW2cVgA==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK2003L4ZY7HB10@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 02:22:55 +0000 (GMT)
To: <linux-kernel@vger.kernel.org>, <qemu-devel@nongnu.org>,
 <linux-f2fs-devel@lists.sourceforge.net>, <linux-erofs@lists.ozlabs.org>,
 <ocfs2-devel@oss.oracle.com>, <linux-mtd@lists.infradead.org>,
 <amd-gfx@lists.freedesktop.org>
Date: Fri, 21 Oct 2022 10:20:57 +0800
Message-id: <20221021022102.2231464-7-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-reply-to: <20221021022102.2231464-1-yangyingliang@huawei.com>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
MIME-version: 1.0
X-Originating-IP: [10.175.103.91]
X-Source-IP: 45.249.212.255
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=190 spamscore=0 malwarescore=0 clxscore=25 impostorscore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210011 domainage_hfrom=8319
Cc: alexander.deucher@amd.com, richard@nod.at, mst@redhat.com,
 gregkh@linuxfoundation.org, somlo@cmu.edu, chao@kernel.org,
 huangjianan@oppo.com, liushixin2@huawei.com, luben.tuikov@amd.com,
 hsiangkao@linux.alibaba.com, rafael@kernel.org, jaegeuk@kernel.org
Subject: [Ocfs2-devel] [PATCH 06/11] firmware: qemu_fw_cfg: fix possible	memory
 leak in fw_cfg_build_symlink()
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
X-ServerName: szxga08-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-GUID: XVYhVBPuPJ1JXqgI-_invwtckVrEWsP_
X-Proofpoint-ORIG-GUID: XVYhVBPuPJ1JXqgI-_invwtckVrEWsP_
Reporting-Meta:
 AAGlgu0ENsCPw8rh3Kf8s6PW7qCmBFuxELGMl2io4HguAuPCuSj0ejCx87uj89dB
 d3fLfiYyG1q86R7ShRvRIsTThKZgdk3kTxPz0M/GoHPVkNux1Po+fCal7SCy/D28
 gebPI45MtF+RvdqpX/VcKlLa/J3dLoAeoLKoH7/VlGHO3txL9ZKjMuwngk9cgOk5
 +SBj16k+aWqc5NhQJuuKId0jI5MEUtyl5GsdMPwgpbAYmq3VcEu6wXM2Cr8itWhk
 PsrrZEIk/8dfDu95RMbkELh8+fyfJ1wM7MhCKkeVIbtSXGdw42q8WHEHMRf8du4Z
 RMgwUvF2zDyhnAvl3u8+Ks670x4SqPguW6j49zEJfXNEx2U9h5y/iBrLo6nsMlbI
 nt9z4OhZSYHvC8zY2uMJwQMU8VWTF9iNfXZJFZkEfv4MBK6X2FfXaR6l1umEtyAe
 HWmqArDpyJ2Cw1tulncFCPmvInIqAFahU3rdDIrXr5cOTVuXcNjzWRdA1EKHcOsA
 m5xM0I/GF2h4W9tjttNXc5BoI+/qfWaC+RMd5MUfUlCI

Inject fault while loading module, kset_register() may fail, if
it fails, but the refcount of kobject is not decreased to 0, the
name allocated in kobject_set_name() is leaked. To fix this by
calling kset_put(), so that name can be freed in callback function
kobject_cleanup() and 'subdir' is freed in kset_release().

unreferenced object 0xffff88810ad69050 (size 8):
  comm "swapper/0", pid 1, jiffies 4294677178 (age 38.812s)
  hex dump (first 8 bytes):
    65 74 63 00 81 88 ff ff                          etc.....
  backtrace:
    [<00000000a80c7bf1>] __kmalloc_node_track_caller+0x44/0x1b0
    [<000000003f0167c7>] kstrdup+0x3a/0x70
    [<0000000049336709>] kstrdup_const+0x41/0x60
    [<00000000175616e4>] kvasprintf_const+0xf5/0x180
    [<000000004bcc30f7>] kobject_set_name_vargs+0x56/0x150
    [<000000004b0251bd>] kobject_set_name+0xab/0xe0
    [<00000000700151fb>] fw_cfg_sysfs_probe+0xa5b/0x1320

Fixes: 246c46ebaeae ("firmware: create directory hierarchy for sysfs fw_cfg entries")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/firmware/qemu_fw_cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/qemu_fw_cfg.c b/drivers/firmware/qemu_fw_cfg.c
index a69399a6b7c0..d036e69cabbb 100644
--- a/drivers/firmware/qemu_fw_cfg.c
+++ b/drivers/firmware/qemu_fw_cfg.c
@@ -544,7 +544,7 @@ static int fw_cfg_build_symlink(struct kset *dir,
 			}
 			ret = kset_register(subdir);
 			if (ret) {
-				kfree(subdir);
+				kset_put(subdir);
 				break;
 			}
 
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
