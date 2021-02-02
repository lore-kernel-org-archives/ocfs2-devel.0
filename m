Return-Path: <SRS0=xZbm=HE=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F418BC433E0
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Feb 2021 11:32:21 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8DB9364E9B
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Feb 2021 11:32:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DB9364E9B
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 112BP3DI191035;
	Tue, 2 Feb 2021 11:32:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 message-id : mime-version : cc : subject : list-id : list-unsubscribe :
 list-archive : list-post : list-help : list-subscribe : content-type :
 content-transfer-encoding : sender; s=corp-2020-01-29;
 bh=Yge4xTcxb8Kfgi3tNXcev5ZIvRHtsSdxq/G/mJDRONo=;
 b=qpgMen+mAOX7/lsqA8kZCqWLBsVj2l0IOKUXcYCN6TOpPP2UKg8tBAoFCArl4NiETFRF
 QtR5T+KQInUGuqOtVx9dAFqWBupUCQMcDR2V8BaGnQBSxTIiNl1/7VB6XhDQD9r82hZ4
 xIxcQUIlsQHfww0mW+WXabHepjZwA6Kv3AwikWazpQ8xSSxyIJD4ExpFX3fNTlyn6Wmo
 UoXVMNJUiasBkpcyPU3C5J8VaKK/o5/i+sbvvBBr0cZqsGz+xjchSdUEzdssfPS7lNZX
 +h/nLMQs/WUD8lExRoRFRacN4+J+ipq8y64Oj2SklCLZRrcpw8Vcxj/vGgwNEWHv2GW4 kA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 36cydkt906-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Feb 2021 11:32:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 112BUBC6170383;
	Tue, 2 Feb 2021 11:32:19 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36dh7rand2-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 02 Feb 2021 11:32:19 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l6tus-0003iG-LR; Tue, 02 Feb 2021 03:32:18 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <dan.carpenter@oracle.com>) id 1l6tur-0003i2-17
	for ocfs2-devel@oss.oracle.com; Tue, 02 Feb 2021 03:32:17 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	112BVUFh014496
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Feb 2021 11:32:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by aserp3030.oracle.com with ESMTP id 36dh1nv8j5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 02 Feb 2021 11:32:16 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 112BWGKS017014
	for <ocfs2-devel@oss.oracle.com>; Tue, 2 Feb 2021 11:32:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserp3030.oracle.com with ESMTP id 36dh1nv8h9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Feb 2021 11:32:16 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 112BWC7j023955;
	Tue, 2 Feb 2021 11:32:12 GMT
Received: from mwanda (/102.36.221.92) by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Tue, 02 Feb 2021 03:32:12 -0800
Date: Tue, 2 Feb 2021 14:32:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mark Fasheh <mark@fasheh.com>
Message-ID: <YBk4M6HUG8jB/jc7@mwanda>
MIME-Version: 1.0
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
Cc: Jens Axboe <axboe@kernel.dk>, Takashi Iwai <tiwai@suse.de>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Jiri Slaby <jirislaby@kernel.org>, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: Fix a use after free on error
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020080
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020079

The error handling in this function frees "reg" but it is still on the
"o2hb_all_regions" list so it will lead to a use after freew.  Joseph Qi
points out that we need to clear the bit in the "o2hb_region_bitmap" as
well

Fixes: 1cf257f51191 ("ocfs2: fix memory leak")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: The first version didn't clear the bit.

 fs/ocfs2/cluster/heartbeat.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 0179a73a3fa2..12a7590601dd 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -2042,7 +2042,7 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 			o2hb_nego_timeout_handler,
 			reg, NULL, &reg->hr_handler_list);
 	if (ret)
-		goto free;
+		goto remove_item;
 
 	ret = o2net_register_handler(O2HB_NEGO_APPROVE_MSG, reg->hr_key,
 			sizeof(struct o2hb_nego_msg),
@@ -2057,6 +2057,12 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 
 unregister_handler:
 	o2net_unregister_handler_list(&reg->hr_handler_list);
+remove_item:
+	spin_lock(&o2hb_live_lock);
+	list_del(&reg->hr_all_item);
+	if (o2hb_global_heartbeat_active())
+		clear_bit(reg->hr_region_num, o2hb_region_bitmap);
+	spin_unlock(&o2hb_live_lock);
 free:
 	kfree(reg);
 	return ERR_PTR(ret);
-- 
2.30.0


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
