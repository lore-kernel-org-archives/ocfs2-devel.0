Return-Path: <SRS0=6hlh=KG=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D165C433ED
	for <ocfs2-devel@archiver.kernel.org>; Tue, 11 May 2021 13:57:14 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6F7DB611BF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 11 May 2021 13:57:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F7DB611BF
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14BDsidF156407;
	Tue, 11 May 2021 13:57:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 message-id : mime-version : in-reply-to : cc : subject : list-id :
 list-unsubscribe : list-archive : list-post : list-help : list-subscribe :
 content-type : content-transfer-encoding : sender; s=corp-2020-01-29;
 bh=1WkQ/h0JlY7R8QF674vvJVpNVGw/tNpkYLwI1Xf7Ozw=;
 b=Le0uxq+RUXMuUMZNxidBmolrl1/ExQy1iQd/wfQMTwjz3VXYxhNuRkohSgRQAfDWlQkS
 SW8DWOfXh7j5sg07zAti71G7574zEB8Jv7cOtp1xqo1WSb9LCwe7b1InEU2TWfNsKUh3
 bKWjyVSJjeG/lMmGdbl77Qt0Kcy12xWsYWNMelIhS430RsG8iOXNXa4sqGQR5E4W8jCn
 3cz1BGWKSPV+KdbED5+WHF06/KJFRznU30XxAAxC4xtMEAhbhBo88Lsi+ROqA04KayDH
 8BMUi5OMjuRKbMbt0lG6A6oEYIikr0nGns0PuD0WBRE7/0R4dAht80Rz+CLrtJr1t8UE 3g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2120.oracle.com with ESMTP id 38dk9nes1y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 May 2021 13:57:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14BDpbup018226;
	Tue, 11 May 2021 13:57:11 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 38dfrxa8jy-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 11 May 2021 13:57:11 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lgSpl-0002BN-LV; Tue, 11 May 2021 06:54:01 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <dan.carpenter@oracle.com>) id 1lgSpj-0002BA-TW
	for ocfs2-devel@oss.oracle.com; Tue, 11 May 2021 06:54:00 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14BDpbF2018202
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 13:53:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by userp3030.oracle.com with ESMTP id 38dfrxa3n0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 13:53:59 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14BDrxQD028423
	for <ocfs2-devel@oss.oracle.com>; Tue, 11 May 2021 13:53:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userp3030.oracle.com with ESMTP id 38dfrxa3ks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 May 2021 13:53:59 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 14BDrw1Y004638;
	Tue, 11 May 2021 13:53:58 GMT
Received: from kadam (/102.36.221.92) by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Tue, 11 May 2021 06:53:57 -0700
Date: Tue, 11 May 2021 16:53:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mark Fasheh <mark@fasheh.com>
Message-ID: <20210511135350.GV1955@kadam>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <bd7ddc22-11c4-3e88-120a-d68f153f573d@linux.alibaba.com>
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: fix snprintf() checking
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105110107
X-Proofpoint-ORIG-GUID: zUdF1tXqugkqAAvcpUP1xpwnn9_ZqNpN
X-Proofpoint-GUID: zUdF1tXqugkqAAvcpUP1xpwnn9_ZqNpN
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110107

The snprintf() function returns the number of bytes which would have
been printed if the buffer was large enough.  In other words it can
return ">= remain" but this code assumes it returns "== remain".

The run time impact of this bug is not very severe.  The next iteration
through the loop would trigger a WARN() when we pass a negative limit
to snprintf().  We would then return success instead of -E2BIG.

The kernel implementation of snprintf() will never return negatives so
there is no need to check and I have deleted that dead code.

Fixes: a860f6eb4c6a ("ocfs2: sysfile interfaces for online file check")
Fixes: 74ae4e104dfc ("ocfs2: Create stack glue sysfs files.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
v2: update the Fixes tag, add Joseph's R-b tag.

 fs/ocfs2/filecheck.c | 6 +-----
 fs/ocfs2/stackglue.c | 8 ++------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
index 90b8d300c1ee..de56e6231af8 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -326,11 +326,7 @@ static ssize_t ocfs2_filecheck_attr_show(struct kobject *kobj,
 		ret = snprintf(buf + total, remain, "%lu\t\t%u\t%s\n",
 			       p->fe_ino, p->fe_done,
 			       ocfs2_filecheck_error(p->fe_status));
-		if (ret < 0) {
-			total = ret;
-			break;
-		}
-		if (ret == remain) {
+		if (ret >= remain) {
 			/* snprintf() didn't fit */
 			total = -E2BIG;
 			break;
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index d50e8b8dfea4..16f1bfc407f2 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -500,11 +500,7 @@ static ssize_t ocfs2_loaded_cluster_plugins_show(struct kobject *kobj,
 	list_for_each_entry(p, &ocfs2_stack_list, sp_list) {
 		ret = snprintf(buf, remain, "%s\n",
 			       p->sp_name);
-		if (ret < 0) {
-			total = ret;
-			break;
-		}
-		if (ret == remain) {
+		if (ret >= remain) {
 			/* snprintf() didn't fit */
 			total = -E2BIG;
 			break;
@@ -531,7 +527,7 @@ static ssize_t ocfs2_active_cluster_plugin_show(struct kobject *kobj,
 	if (active_stack) {
 		ret = snprintf(buf, PAGE_SIZE, "%s\n",
 			       active_stack->sp_name);
-		if (ret == PAGE_SIZE)
+		if (ret >= PAGE_SIZE)
 			ret = -E2BIG;
 	}
 	spin_unlock(&ocfs2_stack_lock);
-- 
2.30.2

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
