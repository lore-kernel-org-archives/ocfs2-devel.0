Return-Path: <SRS0=5YYK=JX=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D2C7C433B4
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Apr 2021 22:13:54 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A351C61152
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Apr 2021 22:13:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A351C61152
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13QMAF4g070926;
	Mon, 26 Apr 2021 22:13:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : in-reply-to : references : mime-version : subject : list-id :
 list-unsubscribe : list-archive : list-post : list-help : list-subscribe :
 content-type : content-transfer-encoding : sender; s=corp-2020-01-29;
 bh=vQlZxph0Z5mdFWOL3eyOW0biy4DiFyes/EDJuV9r8e4=;
 b=potuW/Vr3iOgJX2IQydeAkYOc+5VHB9olNZS9SGYk3RZlNlI4Lvdpc9efFNZtY5pNo4g
 oFf8WQKRn5ByElkfYzpgfBTlA/l1i2CBv7Hr4H5QS/yhBHbHYhfwKHUU3x3qetLl1V6i
 6BqYKFRGy2rMSFBZrQ80MOq+u3b7acI+wqOFsSqzODFAYC7V5kyf8hQXEGD1jPiIuXUa
 8f6ZEkm1OuBFgOAydF9LXeVfneqB4I3XJ9Auw8EPt0uPWO6mCy7MVv9V2kPgZKpYTjYQ
 oL3VKGLNdJD8vlZVozvChAT0oiE0cuClOFiubViCQR5OvJU25abs0aspZ80l/Yyusi+T hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2130.oracle.com with ESMTP id 385afsukdq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Apr 2021 22:13:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13QM6L20105607;
	Mon, 26 Apr 2021 22:13:51 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 384w3s6e17-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 26 Apr 2021 22:13:51 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lb9O8-0003u4-H9; Mon, 26 Apr 2021 15:07:32 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1lb9O5-0003sf-EJ
	for ocfs2-devel@oss.oracle.com; Mon, 26 Apr 2021 15:07:29 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13QM6Klh105544
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Apr 2021 22:07:29 GMT
Received: from nam04-bn3-obe.outbound.protection.outlook.com
	(mail-bn3nam04lp2054.outbound.protection.outlook.com [104.47.46.54])
	by userp3020.oracle.com with ESMTP id 384w3s65pu-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 26 Apr 2021 22:07:29 +0000
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=oracle.com; 
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by BY5PR10MB4307.namprd10.prod.outlook.com (2603:10b6:a03:212::18)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19;
	Mon, 26 Apr 2021 22:07:26 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f%5]) with mapi id 15.20.4065.027;
	Mon, 26 Apr 2021 22:07:26 +0000
From: Junxiao Bi <junxiao.bi@oracle.com>
To: ocfs2-devel@oss.oracle.com, cluster-devel@redhat.com,
        linux-fsdevel@vger.kernel.org
Date: Mon, 26 Apr 2021 15:05:52 -0700
Message-Id: <20210426220552.45413-3-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210426220552.45413-1-junxiao.bi@oracle.com>
References: <20210426220552.45413-1-junxiao.bi@oracle.com>
X-Originating-IP: [73.231.9.254]
X-ClientProxiedBy: SN6PR05CA0026.namprd05.prod.outlook.com
	(2603:10b6:805:de::39) To SJ0PR10MB4752.namprd10.prod.outlook.com
	(2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-151-113.vpn.oracle.com (73.231.9.254) by
	SN6PR05CA0026.namprd05.prod.outlook.com (2603:10b6:805:de::39)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16
	via Frontend Transport; Mon, 26 Apr 2021 22:07:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 437b5311-e205-4d22-619f-08d908ffad33
X-MS-TrafficTypeDiagnostic: BY5PR10MB4307:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:983;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GsYoCKgVvrm0oFXbxxwbAw/T7JhUB/1WzclmIqMJQ5hHsUfuX1Xz0ubAHXt0nW/EQZhQP+J0m1J0ZAc+yGSN4fEqzCDrwL/ZceGXJ7iA+MqSQvPFhAKzti28mt8fRXcqpu8Gi2gOg7ByD+WZEIiy0JYGz19+JUdGkVwDtWGHkbVvGESutRwbNJuuvDcusnsZDa6ifV56CKBWzC5t3FPJ613HVKv8rHSXcbIrqyltmWCgmNpoVHtNHfziJoeHjhYQuUgm73Dx4hOIn3EgH8MEAD4oGUIL+yYQu0lvkkR1hbJP2f21rN/L8BtpYQwzPLhc6Vd8hD00rXFcCuq5Qi25rchsj83KO9IONK2on0r+Kg3aNO7GvQY0HaGjolthlN8poJIphhoLbEaW4rPX8xzyyp1eul3IIVEzJ4uL9qEOu+HibqICkVX4TXJDiuqSLDMngjfba6r63P4gEMcTINxR/9JJkwGoElizBvLa/j6zwyh0izF3rYs87lrY8sR2qrVdvZ6RT3ZiATBl51lTs+sCGYW1b5DYYa0f4qAMxYvrAvg8tjZSqBomcghnD1LyH5rr
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zJB6o5Z/S34hevfuW0aQA+jVyj4OuDPC+H2CQzRA7I4LiqCVL3pEM3NP0kD5?=
	=?us-ascii?Q?jUPn5HezjKQe5zZysauNJaqJOIih+LnFzWK9JgksPSzUtX76jy8SGDeDLXUo?=
	=?us-ascii?Q?GwvmhkODwzPqH0jJO5GCW93XKfXeqWpW9L7aA9nra0r4TZN/S6Uz8XW8Fym1?=
	=?us-ascii?Q?G2JP/skmUfCFNA866mZxcNxElDYrZTZxcXp70ak1S7fv5/yyUe+T7s7QjHSY?=
	=?us-ascii?Q?PJ4IoIAdYR5C2uMjnypHFGfE0NkV1OKagEL3/J7C3J+YuWol7wUq90pnny9d?=
	=?us-ascii?Q?Qkf9MAAasnBytsprTgW4PIh50BOc4cFJxBV593cnKscrNu1GM2MTc8iiD/c5?=
	=?us-ascii?Q?0sDXLgCu98Pb1yQmFrvYxdLGiYKj34+tcJNWgJDObfGJ9mE2PeZfFZR9miSV?=
	=?us-ascii?Q?UC1ugn1mjsAEpomaG3+BvcpLfxL5tXxPafKUa7p5bx0hcGGs/+rCuMeZ0sbT?=
	=?us-ascii?Q?C2GTA3wNKD85ECTnuEz/80f+BzZnDX+xJsUVbjzQxOj2Ub3Yri3r4z+vv2Ge?=
	=?us-ascii?Q?RrEF+orFhWuC4P0WgpSu4x1fCdr8KFqI5P8y/N1sEceiiuqd2/Z82FLYsYBw?=
	=?us-ascii?Q?dhZccsX7jmIpPXKzQWEAEq5SOf47sN4qdbocpi1omiAcFvjYaQUrCXq7puNy?=
	=?us-ascii?Q?rROLMK8JJ3pMPTuw9CzQ0NIK2uxS8OeaiWfwECHYY/i9/isrd2ABjgARvZvs?=
	=?us-ascii?Q?KO6WHoOjjmM1P7tCbBzW78IDChxUwLo8eB3C4o5AiAnPcWw9qUJuUWkiVRPr?=
	=?us-ascii?Q?BQI6H4efv/1JtCDiAUp0c819Mo7Ze4GeYKXalkji8t/xoJJhOwEcNnIraJ0m?=
	=?us-ascii?Q?aREIpktI5mlJPuv3Li2SVs7JYbtE14glC/W3tULFj1HI6RcSn1cyyglzHsUT?=
	=?us-ascii?Q?GiSP05XWKxjGQiug1XlHA1orkBNp8swqsMl7pFVqKDWUA0hSqw3ZbkR4ISMt?=
	=?us-ascii?Q?oSQVa4pFnqoo/NTVJM8DNaMCBLEBt24nmLOZA+qbEXcvP5Am5IcDXd4/XkNN?=
	=?us-ascii?Q?lghNbDZQ11Sy8er5+bR+XSRAfh3LQqzqZ/7Lb/nc0cIYTjGSnJO248YQEZGo?=
	=?us-ascii?Q?G2gbcSCYBtKNlf1Y1b+eP/TAQZj+8KTXhfbfx5BrrsoELikxYLkh+AXkXgYY?=
	=?us-ascii?Q?KAEmSEWIe4lT0RuzHA3zgdB70bUveMH+oCMKnESnBZSt0PhY9EnOuGNmpMUG?=
	=?us-ascii?Q?zf74BalR1sTAB/80CMi3Fy1KCPBYavhli7q4n5EBQg1/akDwqSH5WTXZAlHn?=
	=?us-ascii?Q?/O/Rv9vzpVHomSW82tVcOUYDATZO4KHswgHnzYxFNDHX+tzjTCqjlONAZbMY?=
	=?us-ascii?Q?Mg31al3SMjF7JZR6kwaILaWz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 437b5311-e205-4d22-619f-08d908ffad33
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 22:07:26.6806 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AV2nH1kgmO15bSd33q5EULvTf6tmN7l6AXVOY4eg7O+YjuEZK1TRAVjsiU9PftSbml5PxPsAB6/8l0aTUbZ6uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4307
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
X-OrganizationHeadersPreserved: BY5PR10MB4307.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	malwarescore=0 mlxscore=0
	mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104060000 definitions=main-2104260167
Subject: [Ocfs2-devel] [PATCH 3/3] gfs2: fix out of inode size writeback
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104260167
X-Proofpoint-GUID: dNnzirzdprlBGgotnObMZbg8QxBsmKQu
X-Proofpoint-ORIG-GUID: dNnzirzdprlBGgotnObMZbg8QxBsmKQu
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104260167

Dirty flag of buffers out of inode size will be cleared and will not
be writeback.

Cc: <stable@vger.kernel.org>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/gfs2/aops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index cc4f987687f3..cd8a87555b3a 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -133,8 +133,8 @@ static int gfs2_write_jdata_page(struct page *page,
 	if (page->index == end_index && offset)
 		zero_user_segment(page, offset, PAGE_SIZE);
 
-	return __block_write_full_page(inode, page, gfs2_get_block_noalloc, wbc,
-				       end_buffer_async_write);
+	return __block_write_full_page_eof(inode, page, gfs2_get_block_noalloc, wbc,
+				       end_buffer_async_write, true);
 }
 
 /**
-- 
2.24.3 (Apple Git-128)


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
