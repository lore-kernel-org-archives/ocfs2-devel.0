Return-Path: <SRS0=tkcu=NR=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D04E1C432BE
	for <ocfs2-devel@archiver.kernel.org>; Thu, 26 Aug 2021 06:11:02 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6B96260F58
	for <ocfs2-devel@archiver.kernel.org>; Thu, 26 Aug 2021 06:11:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6B96260F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17Q3qQY6031546;
	Thu, 26 Aug 2021 06:11:01 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3ap3ear68s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Aug 2021 06:11:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17Q69f9k060612;
	Thu, 26 Aug 2021 06:11:00 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3ajpm1xxf3-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 26 Aug 2021 06:10:59 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mJ8bK-00081x-RY; Wed, 25 Aug 2021 23:10:58 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1mJ8bF-00081W-KP
	for ocfs2-devel@oss.oracle.com; Wed, 25 Aug 2021 23:10:53 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17Q61Ng5135478
	for <ocfs2-devel@oss.oracle.com>; Thu, 26 Aug 2021 06:10:53 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3ajsa8nq2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 26 Aug 2021 06:10:52 +0000
Received: from pps.filterd (m0246576.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17Q1f4rY000554
	for <ocfs2-devel@oss.oracle.com>; Thu, 26 Aug 2021 06:10:51 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ap1gq9vpg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 26 Aug 2021 06:10:50 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur05lp2171.outbound.protection.outlook.com [104.47.17.171])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-30-QN4m5btfO1eoEPXfHXTzww-1; Thu, 26 Aug 2021 08:10:47 +0200
X-MC-Unique: QN4m5btfO1eoEPXfHXTzww-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=iJzpBLxlB8wcBZ2bCtsXrOiGCkH+Altb4ZNONsbppdJy5nvhy7XZN4Xn1DTRYbmV8oIOtKrXny6hfW0BNV0VdI5JLwF/p1SCrkw4/OQX9B7UOXd2gdEGXnJncxgaSsdX+yU5doSx/f2aT/N8thLoUtwdfnHBkjTKrxvi80zHc07DnozfV4jxEWZAqJjAGBSagU0rWKFPokI4zcQhD/lql1qniboxmvx6qMDz14EKJJwqIFpK72ZQwf84KemFp5zeQ1bGjAM6VC8yyTA90IlFB4lflBg6ziynpWNrPbKKuvUcu2316lYWDBdiqFFwC0HepLyrTFqZ7RXc2lXk1FEU9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=0Sbu1lxA+bkzV0iWnSw8x3N2y5VK5NOFou/xP1hVKDU=;
	b=jsEokY5Lm5HuFcMcUJgM6w5i2p/bdnhRJFsfPUWS4j6Ny+OXOPi22cyHuqBzi1SNrnFokcvYNQK7tHw+zUpuillsX9/ZWGDTSEUwsu6ubb02uY3B/RvY9RuiPA1Mb1rHT5agojV9u6Mqn+sUwADTFAbp6shwCQtagXfR/0aWH7ueEclHUc3RS6Il/PJsSzxhkTrX5RbrOUcA/5YRcHnNpdxWRZK/ChbKR5i+hsDE4vt14+UyAcQGR1IGlkiXqN/ntHbPklGrSOJDShc67PfUguaWyxv1b5pLs7YGqQfx/RrNtpkGa7IXgA19Oo04qNCjG/CFwLWH7wPnmD0oCwkwdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Authentication-Results: fasheh.com; dkim=none (message not signed)
	header.d=none; fasheh.com; dmarc=none action=none header.from=suse.com; 
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21)
	by AM6PR0402MB3832.eurprd04.prod.outlook.com (2603:10a6:209:24::26)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22;
	Thu, 26 Aug 2021 06:10:46 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71%4]) with mapi id 15.20.4457.017;
	Thu, 26 Aug 2021 06:10:46 +0000
From: Gang He <ghe@suse.com>
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Date: Thu, 26 Aug 2021 14:10:38 +0800
Message-ID: <20210826061038.22295-1-ghe@suse.com>
X-Mailer: git-send-email 2.32.0
X-ClientProxiedBy: HK0PR01CA0057.apcprd01.prod.exchangelabs.com
	(2603:1096:203:a6::21) To AM6PR04MB6488.eurprd04.prod.outlook.com
	(2603:10a6:20b:f8::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (60.251.47.115) by
	HK0PR01CA0057.apcprd01.prod.exchangelabs.com
	(2603:1096:203:a6::21) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384)
	id 15.20.4457.19 via Frontend Transport;
	Thu, 26 Aug 2021 06:10:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c14aa248-c1ea-4b7c-d897-08d968583e31
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3832:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3832DFDC7FBC8F4D9D648823CFC79@AM6PR0402MB3832.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gieBtJnnsx3lfYNuh4U/mQcnlh8Xbhxd7reNiOyZHfupzc3miV79AhxZS2l6awCRXKFAdr0jAEmCHE0jHBaLKoubI6LzWfrM6Y+38qiVY7SxS77S8fAxQvC9izn/jFk/wXh1jOHjXJQ9uMdJz9kjbTi+31o/d7vCUwkvGd15sKbLuGZKat1pPSI60dniDUTIgmQnNwit9ruS6+qWO/lOs7r/MhIIkkzp9tpfnTUAXXV1KsjgDT2HOKYPI2ZIadbulJIDng/NAvGpxdDPlud5b9cEe1145hyrUSxR/24EDF5mSQDoNWS6J6EPs9NGwwgMdYPngm8mlySc9zF6DRyBucJQWI3JaqAMcCmrJr4QOI4cPUurHqVloaNML3cZJz+Uue772N0xXKo9ZuOvStsh0cBk9sfdspPOIWucv+msmibpBxpmL0yj3Oeu5vWQNJOy1ZsFZKiaNa/LMhsAyuZdy52wGlZ7aGhIZQl/TMAGBHRymr6tRhS2FaYxwvqbYaX8C70cCcMhMqK+jNlX1m4FhIbzkiZIrCxcvOvKTOtzidrYtRLYqnNIg1Ek2LYaz08ljOhxuY6FLRRAUzIXtFGQxeLJ51JKqiHv1cZuK0xuYLXzxOlN8qeDEkjhZ123246cBsrpkWyiD+Lipy7Zf78WCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(366004)(66946007)(1076003)(66556008)(6486002)(83380400001)(66476007)(2616005)(6496006)(4326008)(186003)(6666004)(38100700002)(498600001)(55236004)(36756003)(5660300002)(2906002)(8936002)(8676002)(86362001)(26005)(956004);
	DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RRH9HKFHTfyUCJeQFsnf1uPJGfRGVwOxtVrqMShOvEtFJ5nCxNoH4Z4i1JtF?=
	=?us-ascii?Q?c6DBYu/VHAMhCeMSh/uf/2PMFg6PL3Avri4xw4Uy26pe+T0pKRVH+QeWB6ZU?=
	=?us-ascii?Q?DMHQp+ba0ujVGrM4pztfSjwcMMxOs1IRJ5FnTQYMceLuGtnq14JKiE6zDeXE?=
	=?us-ascii?Q?WQwI9emmjXj99Fb+2dA5J0UibtfoART6NxoLbpHGVVfBgnqUZOvq9bqxEna0?=
	=?us-ascii?Q?tBU24NERwoayVFUo+JuG7KDBQgIoIS/byJyOEvmSl/HIkjgwFV/Ve6Slo4Rw?=
	=?us-ascii?Q?mZraCKlrvhwuwDMmX9c+nsbaALrpu5ZK1fKw6I4sIL6iR9SG0wuTFzp7KxO/?=
	=?us-ascii?Q?NP1CB0KA0DbfbN2xBIz2oWKiMmJx6EPVvVdry2Dig3ezJ0HZSdj/+8Y016vM?=
	=?us-ascii?Q?zyZ9QYEN1hbuo4wtOR0ApkEC6kxPVzT8x8lWmYltpu2mLLOKY1FA6LIch33M?=
	=?us-ascii?Q?8eC7emcnJ42LSKjyrqdSy2ksSVFU5VB+7OcrtAxLaaFDBpm4le8iHCJ0LAyo?=
	=?us-ascii?Q?rBT+HMXt/5QZW+MWBgRmFfEBU0hYvS7eiGz4VNEBzJ9/JVJe5YbF7POtpR2t?=
	=?us-ascii?Q?lnrWNX6zezc1Iyp6jbZlOCug/kib3B5LHgRXz67PMuWjyzYFnjMkRWYXUm8U?=
	=?us-ascii?Q?2tkr3pMW0sniA6NUou+5o11FKW0sW9Zo9zs8tVm3pkqFDTcoZmkRTfEiEohj?=
	=?us-ascii?Q?mun4eP0uf8Tb90fHMDMbVI7H7OwF5txpsrDCdRaouGly0AQiCei8yzrOzfrl?=
	=?us-ascii?Q?q6folhk3xhMEDbZWTtWolVbwsqQv+yTwHkz5xZ0bMn490P2PwF4U/RTmL3PT?=
	=?us-ascii?Q?YG4YPZU4NX79iP6j5/yu0HjD5DXlD/ookBMXq96PeWxHGk7PMQzWJQiYcscR?=
	=?us-ascii?Q?NPcS33F3FRRoqrdYmoMOFz2LcIsUTRZwTRToNTaK3vlcCQiG1e0O0ZNj01FD?=
	=?us-ascii?Q?vq7ThB9CWi8C5sUB4FdZITHUt1+LOxy9QSQECxM1cJHBAg/+AB5OxRmxRg3p?=
	=?us-ascii?Q?Mep69uNqO2ehltp/vk/SSopeSJhPrLrAS8AdaquVwuwlavDqz37+DliJzvK/?=
	=?us-ascii?Q?jpaaSPuGJUZprvRDnKW1Q5NJ/FMY9mEWMlDfAFpyL6yKnLDxkYC+xI9rZM/I?=
	=?us-ascii?Q?fUIuNmyoRvaTFNUPjMEPiI2QAKam3l3YHUwVRZiOjnEPco16JeGomzvAutdk?=
	=?us-ascii?Q?/RSB4aF1cG+K8LEQfimdBsbMShaz0D68wpFHfKiU4esj1voLbtLjy/itqZau?=
	=?us-ascii?Q?594GFliyAeUmbgNiukUbS4lwvONyNvuzMFdyu5fiAUKTcRi3fVHVOWlWJsN8?=
	=?us-ascii?Q?EgkQ5RA2IW6gL3lCHZ5Be/l7?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c14aa248-c1ea-4b7c-d897-08d968583e31
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 06:10:46.0410 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7rLIdgQegeA3xWbJCvbYAUpCk6Wh/45Uv/Z1fN5SJYpUPbNsGxByP9IixhaTcZMF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3832
X-Source-IP: 194.104.111.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com include:_spf.salesforce.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10087
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
	phishscore=0 spamscore=0
	impostorscore=0 clxscore=291 adultscore=0 lowpriorityscore=0
	bulkscore=0
	mlxlogscore=948 mlxscore=0 priorityscore=153 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108260037
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10087
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	spamscore=0
	mlxlogscore=897 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
	suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108260036
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: ocfs2_downconvert_lock failure results
	in deadlock
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10087 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108260037
X-Proofpoint-ORIG-GUID: b5tfJw2a1iJuJ0ennFeQqE8hXBQggqWc
X-Proofpoint-GUID: b5tfJw2a1iJuJ0ennFeQqE8hXBQggqWc

Usually, ocfs2_downconvert_lock() function always downconverts
dlm lock to the expected level for satisfy dlm bast requests
from the other nodes.
But there is a rare situation. When dlm lock conversion is being
canceled, ocfs2_downconvert_lock() function will return -EBUSY.
You need to be aware that ocfs2_cancel_convert() function is
asynchronous in fsdlm implementation.
If we does not requeue this lockres entry, ocfs2 downconvert
thread no longer handles this dlm lock bast request. Then, the
other nodes will not get the dlm lock again, the current node's
process will be blocked when acquire this dlm lock again.

Signed-off-by: Gang He <ghe@suse.com>
---
 fs/ocfs2/dlmglue.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 48fd369c29a4..c454c218fbfe 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3671,13 +3671,11 @@ static int ocfs2_downconvert_lock(struct ocfs2_super *osb,
 			     OCFS2_LOCK_ID_MAX_LEN - 1);
 	lockres_clear_pending(lockres, generation, osb);
 	if (ret) {
-		ocfs2_log_dlm_error("ocfs2_dlm_lock", ret, lockres);
+		if (ret != -EBUSY)
+			ocfs2_log_dlm_error("ocfs2_dlm_lock", ret, lockres);
 		ocfs2_recover_from_dlm_error(lockres, 1);
-		goto bail;
 	}
 
-	ret = 0;
-bail:
 	return ret;
 }
 
@@ -3912,6 +3910,13 @@ static int ocfs2_unblock_lock(struct ocfs2_super *osb,
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 	ret = ocfs2_downconvert_lock(osb, lockres, new_level, set_lvb,
 				     gen);
+	/* ocfs2_cancel_convert() is in progress, try again later */
+	if (ret == -EBUSY) {
+		ctl->requeue = 1;
+		mlog(ML_BASTS, "lockres %s, ReQ: Downconvert busy\n",
+		     lockres->l_name);
+		ret = 0;
+	}
 
 leave:
 	if (ret)
-- 
2.12.3


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
