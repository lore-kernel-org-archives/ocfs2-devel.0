Return-Path: <SRS0=MDmv=HD=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D61BC433E0
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 Feb 2021 12:26:04 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A4C0364E97
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 Feb 2021 12:26:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4C0364E97
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 111CDl65183688;
	Mon, 1 Feb 2021 12:26:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 message-id : mime-version : cc : subject : list-id : list-unsubscribe :
 list-archive : list-post : list-help : list-subscribe : content-type :
 content-transfer-encoding : sender; s=corp-2020-01-29;
 bh=mY92HvifO++kCBncmxIpmSW42f9lnG6JQ6Yv/MMfn0Y=;
 b=mIPvuoCdd1ZXI+HDLs/P+Nef/z0g49j3crOfX5MUTfCU2Fty06rTpfxA7asaKs7s3Xxx
 6QgzFZfdjwskAtw8PKaZKu6Hvb8FPm+YRpn8mURTkiZAMZmvgsegmuYlFzhQO+Qlm+6M
 MQoJsP+LC3LdHRSwykeF/S0b6Fuq9SLCogp+10FcC1MZBKybBLUVp1DFNwRPPlQhTy1W
 C44Wyzvc5YrcMeOjz1LvfpgMRUW5OOF+wAuy+9VG+5oRE+trfcuNEELT0jQoeMkW5dJq
 6F59GSKGS0b4Ig4r1CgpdrlTQO6YabPOXOs+cv4gAGWaKxsjTf2JXCm3UImx8u0bAsUN Vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2130.oracle.com with ESMTP id 36cvyan4x9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Feb 2021 12:26:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 111CAR08013011;
	Mon, 1 Feb 2021 12:26:01 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 36dhcuvvhu-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 01 Feb 2021 12:26:01 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l6YHI-0007zn-Mz; Mon, 01 Feb 2021 04:26:00 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <dan.carpenter@oracle.com>) id 1l6YHF-0007zO-9V
	for ocfs2-devel@oss.oracle.com; Mon, 01 Feb 2021 04:25:57 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	111CA8c3147116
	for <ocfs2-devel@oss.oracle.com>; Mon, 1 Feb 2021 12:25:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by userp3020.oracle.com with ESMTP id 36dh7pn4sw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 01 Feb 2021 12:25:57 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 111CPuXc003418
	for <ocfs2-devel@oss.oracle.com>; Mon, 1 Feb 2021 12:25:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by userp3020.oracle.com with ESMTP id 36dh7pn4s8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Feb 2021 12:25:56 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
	by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 111CPq9q007836;
	Mon, 1 Feb 2021 12:25:52 GMT
Received: from mwanda (/10.175.186.133)
	by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Mon, 01 Feb 2021 04:25:51 -0800
Date: Mon, 1 Feb 2021 15:25:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mark Fasheh <mark@fasheh.com>, Jiri Slaby <jirislaby@kernel.org>
Message-ID: <YBfzR7AbZZ4Pp6sq@mwanda>
MIME-Version: 1.0
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
Cc: Jens Axboe <axboe@kernel.dk>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alex Shi <alex.shi@linux.alibaba.com>,
        ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix a use after free on error
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9881 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102010064
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9881 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010064

The error handling in this function frees "reg" but it is still on the
"o2hb_all_regions" list so it will lead to a use after free.  The fix
for this is to only add it to the list after everything has succeeded.

Fixes: 1cf257f51191 ("ocfs2: fix memory leak")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This is from static analysis and hasn't been tested.

 fs/ocfs2/cluster/heartbeat.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 0179a73a3fa2..92af4dc813e7 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -2025,7 +2025,6 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 		}
 		set_bit(reg->hr_region_num, o2hb_region_bitmap);
 	}
-	list_add_tail(&reg->hr_all_item, &o2hb_all_regions);
 	spin_unlock(&o2hb_live_lock);
 
 	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
@@ -2053,6 +2052,10 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 
 	o2hb_debug_region_init(reg, o2hb_debug_dir);
 
+	spin_lock(&o2hb_live_lock);
+	list_add_tail(&reg->hr_all_item, &o2hb_all_regions);
+	spin_unlock(&o2hb_live_lock);
+
 	return &reg->hr_item;
 
 unregister_handler:
-- 
2.29.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
