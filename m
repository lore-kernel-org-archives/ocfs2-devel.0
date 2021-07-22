Return-Path: <SRS0=iQvO=MO=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79564C63793
	for <ocfs2-devel@archiver.kernel.org>; Thu, 22 Jul 2021 05:50:36 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1650860FD7
	for <ocfs2-devel@archiver.kernel.org>; Thu, 22 Jul 2021 05:50:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1650860FD7
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16M5kgNb006028;
	Thu, 22 Jul 2021 05:50:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : mime-version : subject : list-id : list-unsubscribe :
 list-archive : list-post : list-help : list-subscribe : content-type :
 content-transfer-encoding : sender; s=corp-2021-07-09;
 bh=GuJv3N0DuwN9FI5u7Jc3NqatdDiAFAduZ1QVFwjVtTM=;
 b=hkhTptzZZRCbCoRAiZrabOTdHk9lymv3xNPyKsmcjwj/dFcbHFhFLXC4os/VaU24TYAb
 7tZjoFFSU+QUHZvdZU/IX8NE+2pVrWwtKhL06w3jiKHVUaZWNoOOYee4jjq2bTGV/5BF
 iX2uzekIxfZX0bS0zOtbkJEQjrMTcTK2hpbVr/jMMELmPF9KoHCm5baPIsQ7cURhzqc2
 H/ekL2ho5T42q5J36QaVSaJv4xzrVNHUa/oMQcmV4iW+SKPTDQkLy96ZeitRp5EMhVEu
 n4zyiIbOAUxycjh+LNlRBX2FVcXHxI9C6TQCS5MBAt54mA9tRJd0i8QQ8JvK80oblW7W Ag== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : mime-version : subject : list-id : list-unsubscribe :
 list-archive : list-post : list-help : list-subscribe : content-type :
 content-transfer-encoding : sender; s=corp-2020-01-29;
 bh=GuJv3N0DuwN9FI5u7Jc3NqatdDiAFAduZ1QVFwjVtTM=;
 b=pmwxbhdaj6T8sml0s3uoVS5eXBzYFlh/f22PcpPHm8wCeHBecZMUz/ISmDUuF1LFIGL/
 GnKi3bkNlIos8BWQb3C8mIuaWA735E/W4BiHt++S/u1Mip4jZ3kO0NBUxgq3LmCeWKah
 /lyG2b7wGyEvUTSNt1x+v+CHizTywcUgsIoUyNJ9WUKYRz9cvp4NYCeeizAqBrooXMIi
 kV//Te4bJ0/oflPay5m5lm0BbZ3HUHy9d2myxn4XoK3Cy9pE1RnMJ5neG0jGVXkLGn5+
 pyuZAyZfv31GvQOpj0bxd6v9rq0D6tTtu9HQbA9f/MfYdmsaRowngEqk0raqJXQzWOhr hQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 39xvm7rdwv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jul 2021 05:50:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16M5kPjM100624;
	Thu, 22 Jul 2021 05:50:33 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 39v8yyw4wb-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 22 Jul 2021 05:50:33 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m6RbM-0000dU-9N; Wed, 21 Jul 2021 22:50:32 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1m6Rap-0000Uo-U4
	for ocfs2-devel@oss.oracle.com; Wed, 21 Jul 2021 22:49:59 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16M5jMJR060297
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Jul 2021 05:49:59 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
	by aserp3030.oracle.com with ESMTP id 39wunnbjy5-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Jul 2021 05:49:59 +0000
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=oracle.com; 
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by BYAPR10MB3061.namprd10.prod.outlook.com (2603:10b6:a03:83::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.25;
	Thu, 22 Jul 2021 05:49:57 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::e0a1:1074:ef31:e756]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::e0a1:1074:ef31:e756%5]) with mapi id 15.20.4352.025;
	Thu, 22 Jul 2021 05:49:57 +0000
From: Junxiao Bi <junxiao.bi@oracle.com>
To: ocfs2-devel@oss.oracle.com
Date: Wed, 21 Jul 2021 22:49:22 -0700
Message-Id: <20210722054923.24389-1-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
X-ClientProxiedBy: SN6PR08CA0027.namprd08.prod.outlook.com
	(2603:10b6:805:66::40) To SJ0PR10MB4752.namprd10.prod.outlook.com
	(2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-233-185.vpn.oracle.com (73.231.9.254) by
	SN6PR08CA0027.namprd08.prod.outlook.com (2603:10b6:805:66::40)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25
	via Frontend Transport; Thu, 22 Jul 2021 05:49:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a554435-c53b-4200-7a57-08d94cd48938
X-MS-TrafficTypeDiagnostic: BYAPR10MB3061:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:513;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3UpOZuxYoASp0oblT3o6QorucxWkPvnXGzionu4mP0bRMdm0IRDhmPF76STPh1UVLdcOKkBXBeXurLKB8RBcPkD7AJo/ycX7xiy8Ys+H2uzVhymexIdC0WI4HNbpewqIWwZhdHts2J6i1EcMUl/j9FJHk5p+7FTp5y7oUTdRejfDiK8PKleLJTzm5Hw20loSP5dMDSjHz3xwNs3sdgF8tdtrnbr4JyfM0zLtO5omwIDL/B4dMUbGuUJaNVgk+Cd85KVAX8L3oOPeKhg8yXqPK2qOdafxe/BRFnf2yw2H/gZZ9F0djWPuNVHhO5qY4Ppwr3PQwCc1ajzf/OgyemuxyvMfbVBnTlay7w7g6Zfb70qfMbNI1PKm1DTk/crxocETfNtw3sK38DpYAgCO+2l7mpjtWacyAbBsxFCey6EtNLbfYVmI6CQaU30LyGjwVSp4bde7GE0Q/K+9Dq8AQU1rcBZr+OGGFfVaMrVfSjwA2ThGn/BbjjwsJA7EFKfEfDiqXp7BSrq5E4UL1a6aC9zhanHU3WPmdgNB3FVJSWlL20Ia9k1Jnti24OffFLPG93Se2QTZfWxhb8vwu+QImrdJZi0+MdtrF92SrTg45WKPNQE=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QE+78tBpb9F5+awnaqhCUIRGo/D6gkt4iuwVs6cNyN33uJFavrjmXpivkoC4?=
	=?us-ascii?Q?y9jPwTb5Pt8DVOKnN14uYMKmMhJKCXc2ptiFKdK2VbdSsvvpPYuhI1M2/Q5H?=
	=?us-ascii?Q?0Y7KRcbLaZCjPsvYKUuNZRORhKo+I9GS11NsqwHImfQesA81Tkb9SXyGN0DY?=
	=?us-ascii?Q?k1ittSk4f5ECHv1xD5AVkX27pjfKJ1/GC0LQy9JkhVSE6di7qdcyAfcNk6ui?=
	=?us-ascii?Q?Bwoc3wkYEvpMOgpTz2hdW3K1csn2dKckujGrq5AqLNIBuF9xNWR7aIym2hZ3?=
	=?us-ascii?Q?Gomv30MLCrqvIE6/5Y4hVHsY3sdDTHGG5dsiRe/9mQRCkghNM0CyYi/mTqdT?=
	=?us-ascii?Q?RT5Wn4dhQV2OZYYKQwLGYXsarJrx5J4HdJyZsjHNWOUNgCgsNrg6C15dWg8w?=
	=?us-ascii?Q?QVDFeVxaogkjrh81UK3lISMaXQZrFcUgF4hxoZ8IuYfxcFCvjuW8K/dSV08g?=
	=?us-ascii?Q?7Pr5hkSnWWB68ekOASdMCgRrs0XtxP3XogoPDYwPlwBs+iPUrUPqnQO6DeIc?=
	=?us-ascii?Q?U8kIykkFnj8MsP5QoTOs44nqaGDJ2PBUO+FLKxtqsIC0jo3+6TJARz2SiVg7?=
	=?us-ascii?Q?VEPzCIM7mRWoHxxhQw9oWdJ0Yn/6MWDHo5dzef3ybBv1frr6nvRl5xwbtizg?=
	=?us-ascii?Q?LMaYMjftLYRJqB6C5lGlGihkPPdo7QUSBTwGJYeEho2S/yFUu26GII1a2DU0?=
	=?us-ascii?Q?JJMadYl75A4l6FKpEfALwtp16VVYYHilhlxuYeqjD/BjnQtMQcT/Q5aBB/if?=
	=?us-ascii?Q?3KwMmFUgK6iakhH9/9r76ECbimFMygq4XseyiQF4RKfp5m40RNRDJJiCFc4R?=
	=?us-ascii?Q?gKdYFuahqml7DtOZ/vI0sSMo53U/bZX3gVTesZPcPXN+m67KZdyU8uH3N8b0?=
	=?us-ascii?Q?bPuN8+Os5WUTM02A04zUktu9+lnpAJ60D1Kmo7QAADzKH08Ka8vGZkWnpFI2?=
	=?us-ascii?Q?6SV52NqPrkG7MolIE6SagHB37N8mrLW/hgXDhvLhG1nIKBfw1C8B2qPMuvIY?=
	=?us-ascii?Q?4aikSGMG2sfYtA/BzqakF7tCKrrWKoPFV4i74KzovhfjCCseA2bxX57ZslVf?=
	=?us-ascii?Q?JdDgPA4ZWdTEKt7sgdEsjSKrFv5kM6cL2qeh0cIaEfFee4E5j5rhmZjMC/ut?=
	=?us-ascii?Q?10F/Qh4igWUUreq7FN5hfIRdymAnG9rhfxMS2DRQtXTHbsW4MQqCaGgN15ts?=
	=?us-ascii?Q?EuvlIgCfPYnvBY75FD0Xp/t6UpSrAxigRGoBNgX8/vnYcdElNPUyF1pvO0Ex?=
	=?us-ascii?Q?ZQQ530RSAic0RM/KZPmCmvl0lT+1E33if3+byU1aGCdVG8VVjxZ5cfmhngIL?=
	=?us-ascii?Q?R/+fJsXOiN+aBsdU6GFxwjgf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a554435-c53b-4200-7a57-08d94cd48938
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 05:49:57.1908 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UuM0yQfasDKvxcWgeCK7OOcysyrma5fCsqBpCLVYbMmd5LON8GUpWB72o9sPiuJibOWmZgFF+JsoC1GLPyc7OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3061
X-MS-Exchange-CrossPremises-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission: 
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 73.231.9.254
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating;SFV:SKI;SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: BYAPR10MB3061.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10052
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	phishscore=0 spamscore=0
	bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107220033
Subject: [Ocfs2-devel] [PATCH V2 1/2] ocfs2: fix zero out valid data
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10052 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107220033
X-Proofpoint-ORIG-GUID: wc7xK9UF-UBuP_6DJ646VufkuZsZhDkM
X-Proofpoint-GUID: wc7xK9UF-UBuP_6DJ646VufkuZsZhDkM

If append-dio feature is enabled, direct-io write and fallocate could run
in parallel to extend file size, fallocate used "orig_isize" to record
i_size before taking "ip_alloc_sem", when ocfs2_zeroout_partial_cluster()
zeroout EOF blocks, i_size maybe already extended by ocfs2_dio_end_io_write(),
that will cause valid data zeroed out.

Fixes: 6bba4471f0cc ("ocfs2: fix data corruption by fallocate")
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
Changes in V2:
- fix commit id in the patch header

 fs/ocfs2/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 775657943057..53bb46ce3cbb 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1935,7 +1935,6 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		goto out_inode_unlock;
 	}
 
-	orig_isize = i_size_read(inode);
 	switch (sr->l_whence) {
 	case 0: /*SEEK_SET*/
 		break;
@@ -1943,7 +1942,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		sr->l_start += f_pos;
 		break;
 	case 2: /*SEEK_END*/
-		sr->l_start += orig_isize;
+		sr->l_start += i_size_read(inode);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1998,6 +1997,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		ret = -EINVAL;
 	}
 
+	orig_isize = i_size_read(inode);
 	/* zeroout eof blocks in the cluster. */
 	if (!ret && change_size && orig_isize < size) {
 		ret = ocfs2_zeroout_partial_cluster(inode, orig_isize,
-- 
2.24.3 (Apple Git-128)


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
