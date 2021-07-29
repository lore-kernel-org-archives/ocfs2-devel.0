Return-Path: <SRS0=3WGi=MV=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20AAFC4338F
	for <ocfs2-devel@archiver.kernel.org>; Thu, 29 Jul 2021 11:03:27 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B999460BD3
	for <ocfs2-devel@archiver.kernel.org>; Thu, 29 Jul 2021 11:03:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B999460BD3
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TAtZUM026221;
	Thu, 29 Jul 2021 11:03:26 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a234w71y1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jul 2021 11:03:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16TAxV9v157117;
	Thu, 29 Jul 2021 11:03:24 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3a23576hut-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 29 Jul 2021 11:03:24 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m93ox-0005GF-4j; Thu, 29 Jul 2021 04:03:23 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1m93oR-0005En-7k
	for ocfs2-devel@oss.oracle.com; Thu, 29 Jul 2021 04:02:51 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16TB1Idw013593
	for <ocfs2-devel@oss.oracle.com>; Thu, 29 Jul 2021 11:02:50 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3a2350p801-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 29 Jul 2021 11:02:50 +0000
Received: from pps.filterd (m0246578.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16TAwaYT012716
	for <ocfs2-devel@oss.oracle.com>; Thu, 29 Jul 2021 11:02:49 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a34vq5f1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 29 Jul 2021 11:02:48 +0000
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur02lp2057.outbound.protection.outlook.com [104.47.6.57])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-21-QRnzzYpIMT6s2aVz42bX6A-1; Thu, 29 Jul 2021 13:02:45 +0200
X-MC-Unique: QRnzzYpIMT6s2aVz42bX6A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=GFQPFswwe8UBWM/WNGIo8GWq0unD/yQ7DostB1DE++OvsSA5TYVr117R2+DHOi7YDa7wagjV0IDL1I1lctgcbdB4sLhXCtH3btONdonk9BYh5rTRIiWJNgDZW2abt63RAgALB3VsDZjfiDyNRn0SaVA8fSpCd8GCDxsg47u30Twg3g/Y54j9CDpqNh3XWzuZFctGLiwmEqJDOTYTRIO6lbrct9uciKk2hMNnF5kGKEGu6wvC910kHPQGs8fHqKVHQ6lJC2DXGpzVs0GSy/0GCQn118wQUXBYmAVV/r6TKoMvnaJ+7tjnC4PpLnI3yZIYJmg1/xwmnrRiO+BiCFLCfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=+yKJAwhklxM8l7dbisUBVQ9nNuPfk6vcFzZ5mRVLENc=;
	b=GxeuDt9/QTfJASqriPirx9hzRHdfTQMjP7NVRzpbhe+hoRHtrB1mdh5bt3apnrL9KXjlDqAHoeJTpdV78kccsMtN/HNgUYyGxM+wvxqoLkyaBP+clh2XEa+mER8EiqNkL8PuvFylzxQwKTQayYvl5kuWHp+DO1GQUSmDKBaxIXbuddmRbtH07aacoe310Ez8/ZkBO9qdBoz/ZAHgFuW12xS17nbCSTDIoDPvVJgHttNMtEx1tpJbyfqkQacxFv71dul2jfrMFil6HSkAVrKt9PQXgLm9KP5Q8H6PQJ14kDf4WClk/rXVBjz42xF35bEwilnEd2x9++voJVwn14CpfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Authentication-Results: fasheh.com; dkim=none (message not signed)
	header.d=none; fasheh.com; dmarc=none action=none header.from=suse.com; 
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21)
	by AM6PR04MB5799.eurprd04.prod.outlook.com (2603:10a6:20b:a9::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29;
	Thu, 29 Jul 2021 11:02:43 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::b973:ec65:6b36:1eaa]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::b973:ec65:6b36:1eaa%6]) with mapi id 15.20.4373.019;
	Thu, 29 Jul 2021 11:02:43 +0000
From: Gang He <ghe@suse.com>
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Date: Thu, 29 Jul 2021 19:02:30 +0800
Message-ID: <20210729110230.18983-1-ghe@suse.com>
X-Mailer: git-send-email 2.32.0
X-ClientProxiedBy: HKAPR03CA0015.apcprd03.prod.outlook.com
	(2603:1096:203:c8::20) To AM6PR04MB6488.eurprd04.prod.outlook.com
	(2603:10a6:20b:f8::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (60.251.47.115) by
	HKAPR03CA0015.apcprd03.prod.outlook.com (2603:1096:203:c8::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.8
	via Frontend Transport; Thu, 29 Jul 2021 11:02:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad7ba163-a6f7-498c-ae6c-08d9528063da
X-MS-TrafficTypeDiagnostic: AM6PR04MB5799:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB5799B7BA4D19A6C0FE5DD771CFEB9@AM6PR04MB5799.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Z/Iwos++ltN9mjSta86cRMw/MgxM50umz3tGvu7HNf84YiId/Bhmn6jJSsoJDIYslAy+YfF+2rXY81zv78sYf4psoVxI07ESPO+bSDqMRnFgP92lpFEXBcfJJ5kGoHCPsOksd1CInUhDaLl/zctmikNRRQ3Wl1SmYCMWz0g9sje20XArP/iPy+CXnCLsWWqVa0Dc4MxosbGnEmc3KkJdVgUIed6QGgUi8LplwYUWMkwi6BbymL7GwRrJcy5I/72pS2tcOTU6OUVJm31oHe3O4btiT3X7YrBGxU2C4gFxM73d/DVW2mt0Fks6X788vGVjciAmNbLXp2ZCT34omYnR6ziBHnc8sk/RHZfsOcrCBH9zU+2DtTiljlyEfFmY20XWzAFnijBK7Cst37MXfgNDjp02hC80SwHUj1YG+oWY+/9yUmZt5eWKGsVXGzH8h+MouZOR37FCb7tZCise/u5vifv5vDREOYChcdSd/v5n9kp5ZG7KzPRuV9epL8Ve/tMGzkWIw6UXNUhvaDlrSmB6NsdCxmcVNT6ApfosC7G6BQbNAf4ooAaqkbil+0yRDSDno1kEske7f12wEpaL4OKED9yLy5QQxk1zoYpWPOSQAeDGWHZTPe2ToxygUmpzGRLyK/SOlAUKs4w/SpcyzE91g==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(396003)(376002)(346002)(39860400002)(366004)(136003)(8936002)(1076003)(956004)(478600001)(8676002)(38100700002)(55236004)(86362001)(5660300002)(2616005)(316002)(83380400001)(6666004)(66556008)(6496006)(6486002)(4326008)(26005)(2906002)(66476007)(186003)(66946007)(36756003);
	DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FAcSVI9jXjOsowzmdXQ50RUCC3Fk1Cxm9QZj8WswJyEtkHALQELc9fBX4mi5?=
	=?us-ascii?Q?zDF9dmGDNT4upEhYgE+2bNIlUFoCujOOi8OUxSpCmbVG+r6GOwHb9diI/rGk?=
	=?us-ascii?Q?HfCchAjC5PUXtAiAwoFnTYm5IkZnQ0k65sV64cR+feWShCb16AuTAFA9nTIZ?=
	=?us-ascii?Q?j/LWPvDQ7LuqEXSAeS+a4FhQirx0M+IG7r6wMfnJQ/8F86Y75/cxpkHYJesU?=
	=?us-ascii?Q?NMLGTOBjTeTauhypgjGbREya4hO32Enyi1TegQZ0aleyGdWlDgDpuMlLkxPN?=
	=?us-ascii?Q?Aq7UgwmWiR97iUJTEdO+KFomF2nNaiahiizHiu9zRdQC2ZME5RYiQVxOahgK?=
	=?us-ascii?Q?lbDZ3/ouv4A0nW8cdLxG1jLQ75aKjUPrkJ8SS4QmdGy7nQOy2Du2Pw6Y0K4x?=
	=?us-ascii?Q?OupIrS8JmhvG74n7tAYx/LvqpHmp2DrJ/zeQ3fTw+v3bp8oOpYHokRSWaGKP?=
	=?us-ascii?Q?yocSARoXpZe/VoHjB5DGrlKJ2X/OmnKeLBv+zpHgVNryRh3cnVW6VKtKiTsS?=
	=?us-ascii?Q?azNqyfQEonLDBhtdGZrHD6eT+FFDRO2j0E/yHU81R+tBeaa0AbWcd8cda0cZ?=
	=?us-ascii?Q?GZh2qiAV6eLbaqq1/2ARQAHcOKqF2PuecaorgfS+IQizbVMDbxqbd9THePiJ?=
	=?us-ascii?Q?Fhw3R9hWEH2cS1Ux/JDlxfaRF44vCtk7uRP7yuJrSU9zZ2o1o3Q+fmys0aYO?=
	=?us-ascii?Q?WqYY70gobXdXRvpoXX4PG063j3waS3A6l7qi2V8PMHqUf7Mvg/zUDnGeE77W?=
	=?us-ascii?Q?npffnbKs+xA1l57WmzT5/LZW/DlB70Ii2Jb7W7shdhtc/ijlugBozjlEhgUc?=
	=?us-ascii?Q?RmGJSOXLtQeVPevRswnD+kql1VIAEvv5XCE42/CvdPXAo66Ms8+y2ykLKwJ8?=
	=?us-ascii?Q?XpTegOAAwMfu2Sdj9DYwlrA90LpVc0U2kl/eK2E1HRqLObzW3Xa3aaPE7Ix1?=
	=?us-ascii?Q?fqwvdQ6T8gTWXWUUIqLqz1jva5LiOhny0KCRRRxw/Lf5+LsGrtSiRUvmJQwU?=
	=?us-ascii?Q?q1+E4gMM3RJDMmp9pEnnKTAKwyJvuEswOzF+U7Xq6hyC56o47mmAbH5WRdTl?=
	=?us-ascii?Q?Ry6VEKfKZFDnFmDkZxgI+Ae+c074wwauQ4q0a3vGnnA2MmQ+jMVIXt18b3tH?=
	=?us-ascii?Q?rZIpF4RcCFOTGcjb9cno83f0sEwowJ7rQv3m7iwYjPfofD35BOJkE0IY3bF8?=
	=?us-ascii?Q?kfuXZxRzKJ/Ae7tpP16F8AA8nkJdr9fjYJFlcp12/RCGjO6p+rT06k+6Iu5v?=
	=?us-ascii?Q?nj7TnQ4BzNZzEewALhWEVLT1fnTlCNJNXBgoj37mOqHubSCAh1BoJqaccukt?=
	=?us-ascii?Q?AdSrvkUb81hlOCh+Mqeg9poV?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad7ba163-a6f7-498c-ae6c-08d9528063da
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 11:02:43.6701 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6fPYOQmdYao1QbCzvs6SSI9rSduRAxnyb7tDxVoc+KJ3fmfVhXqlapLMxK3BYyVu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5799
X-Source-IP: 194.104.109.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	mlxscore=0 bulkscore=0
	phishscore=0 spamscore=0 clxscore=239 malwarescore=0 impostorscore=0
	mlxlogscore=999 priorityscore=181 adultscore=0 lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2107290071
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	spamscore=0
	mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
	malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2107290071
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: reflink deadlock when clone file to
	the same directory simultaneously
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290071
X-Proofpoint-ORIG-GUID: P6hGsLedzAVgtJ5e-a8CM4y3U9NkOGUM
X-Proofpoint-GUID: P6hGsLedzAVgtJ5e-a8CM4y3U9NkOGUM

Running reflink from multiple nodes simultaneously to clone a file
to the same directory probably triggers a deadlock issue.
For example, there is a three node ocfs2 cluster, each node mounts
the ocfs2 file system to /mnt/shared, and run the reflink command
from each node repeatedly, like
  reflink "/mnt/shared/test" \
  "/mnt/shared/.snapshots/test.`date +%m%d%H%M%S`.`hostname`"
then, reflink command process will be hung on each node, and you
can't list this file system directory.
The problematic reflink command process is blocked at one node,
task:reflink         state:D stack:    0 pid: 1283 ppid:  4154
Call Trace:
  __schedule+0x2fd/0x750
  schedule+0x2f/0xa0
  schedule_timeout+0x1cc/0x310
  ? ocfs2_control_cfu+0x50/0x50 [ocfs2_stack_user]
  ? 0xffffffffc0e3e000
  wait_for_completion+0xba/0x140
  ? wake_up_q+0xa0/0xa0
  __ocfs2_cluster_lock.isra.41+0x3b5/0x820 [ocfs2]
  ? ocfs2_inode_lock_full_nested+0x1fc/0x960 [ocfs2]
  ocfs2_inode_lock_full_nested+0x1fc/0x960 [ocfs2]
  ocfs2_init_security_and_acl+0xbe/0x1d0 [ocfs2]
  ocfs2_reflink+0x436/0x4c0 [ocfs2]
  ? ocfs2_reflink_ioctl+0x2ca/0x360 [ocfs2]
  ocfs2_reflink_ioctl+0x2ca/0x360 [ocfs2]
  ocfs2_ioctl+0x25e/0x670 [ocfs2]
  do_vfs_ioctl+0xa0/0x680
  ksys_ioctl+0x70/0x80
  __x64_sys_ioctl+0x16/0x20
  do_syscall_64+0x5b/0x1e0
The other reflink command processes are blocked at other nodes,
task:reflink         state:D stack:    0 pid:29759 ppid:  4088
Call Trace:
  __schedule+0x2fd/0x750
  schedule+0x2f/0xa0
  schedule_timeout+0x1cc/0x310
  ? ocfs2_control_cfu+0x50/0x50 [ocfs2_stack_user]
  ? 0xffffffffc0b19000
  wait_for_completion+0xba/0x140
  ? wake_up_q+0xa0/0xa0
  __ocfs2_cluster_lock.isra.41+0x3b5/0x820 [ocfs2]
  ? ocfs2_inode_lock_full_nested+0x1fc/0x960 [ocfs2]
  ocfs2_inode_lock_full_nested+0x1fc/0x960 [ocfs2]
  ocfs2_mv_orphaned_inode_to_new+0x87/0x7e0 [ocfs2]
  ocfs2_reflink+0x335/0x4c0 [ocfs2]
  ? ocfs2_reflink_ioctl+0x2ca/0x360 [ocfs2]
  ocfs2_reflink_ioctl+0x2ca/0x360 [ocfs2]
  ocfs2_ioctl+0x25e/0x670 [ocfs2]
  do_vfs_ioctl+0xa0/0x680
  ksys_ioctl+0x70/0x80
  __x64_sys_ioctl+0x16/0x20
  do_syscall_64+0x5b/0x1e0
or
task:reflink         state:D stack:    0 pid:18465 ppid:  4156
Call Trace:
  __schedule+0x302/0x940
  ? usleep_range+0x80/0x80
  schedule+0x46/0xb0
  schedule_timeout+0xff/0x140
  ? ocfs2_control_cfu+0x50/0x50 [ocfs2_stack_user]
  ? 0xffffffffc0c3b000
  __wait_for_common+0xb9/0x170
  __ocfs2_cluster_lock.constprop.0+0x1d6/0x860 [ocfs2]
  ? ocfs2_wait_for_recovery+0x49/0xd0 [ocfs2]
  ? ocfs2_inode_lock_full_nested+0x30f/0xa50 [ocfs2]
  ocfs2_inode_lock_full_nested+0x30f/0xa50 [ocfs2]
  ocfs2_inode_lock_tracker+0xf2/0x2b0 [ocfs2]
  ? dput+0x32/0x2f0
  ocfs2_permission+0x45/0xe0 [ocfs2]
  inode_permission+0xcc/0x170
  link_path_walk.part.0.constprop.0+0x2a2/0x380
  ? path_init+0x2c1/0x3f0
  path_parentat+0x3c/0x90
  filename_parentat+0xc1/0x1d0
  ? filename_lookup+0x138/0x1c0
  filename_create+0x43/0x160
  ocfs2_reflink_ioctl+0xe6/0x380 [ocfs2]
  ocfs2_ioctl+0x1ea/0x2c0 [ocfs2]
  ? do_sys_openat2+0x81/0x150
  __x64_sys_ioctl+0x82/0xb0
  do_syscall_64+0x61/0xb0

The deadlock is caused by multiple acquiring the destination directory
inode dlm lock in ocfs2_reflink function, we should acquire this
directory inode dlm lock at the beginning, and hold this dlm lock until
end of the function.

Signed-off-by: Gang He <ghe@suse.com>
---
 fs/ocfs2/namei.c        | 32 +++++++++++++-------------------
 fs/ocfs2/namei.h        |  2 ++
 fs/ocfs2/refcounttree.c | 15 +++++++++++----
 fs/ocfs2/xattr.c        | 12 +-----------
 fs/ocfs2/xattr.h        |  1 +
 5 files changed, 28 insertions(+), 34 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 2c46ff6ba4ea..f8bbb22cc60b 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2489,6 +2489,7 @@ static int ocfs2_prep_new_orphaned_file(struct inode *dir,
 }
 
 int ocfs2_create_inode_in_orphan(struct inode *dir,
+				 struct buffer_head **dir_bh,
 				 int mode,
 				 struct inode **new_inode)
 {
@@ -2597,13 +2598,16 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
 
 	brelse(new_di_bh);
 
-	if (!status)
-		*new_inode = inode;
-
 	ocfs2_free_dir_lookup_result(&orphan_insert);
 
-	ocfs2_inode_unlock(dir, 1);
-	brelse(parent_di_bh);
+	if (!status) {
+		*new_inode = inode;
+		*dir_bh = parent_di_bh;
+	} else {
+		ocfs2_inode_unlock(dir, 1);
+		brelse(parent_di_bh);
+	}
+
 	return status;
 }
 
@@ -2760,11 +2764,11 @@ int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
 }
 
 int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
+				   struct buffer_head *dir_bh,
 				   struct inode *inode,
 				   struct dentry *dentry)
 {
 	int status = 0;
-	struct buffer_head *parent_di_bh = NULL;
 	handle_t *handle = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	struct ocfs2_dinode *dir_di, *di;
@@ -2778,14 +2782,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 				(unsigned long long)OCFS2_I(dir)->ip_blkno,
 				(unsigned long long)OCFS2_I(inode)->ip_blkno);
 
-	status = ocfs2_inode_lock(dir, &parent_di_bh, 1);
-	if (status < 0) {
-		if (status != -ENOENT)
-			mlog_errno(status);
-		return status;
-	}
-
-	dir_di = (struct ocfs2_dinode *) parent_di_bh->b_data;
+	dir_di = (struct ocfs2_dinode *) dir_bh->b_data;
 	if (!dir_di->i_links_count) {
 		/* can't make a file in a deleted directory. */
 		status = -ENOENT;
@@ -2798,7 +2795,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 		goto leave;
 
 	/* get a spot inside the dir. */
-	status = ocfs2_prepare_dir_for_insert(osb, dir, parent_di_bh,
+	status = ocfs2_prepare_dir_for_insert(osb, dir, dir_bh,
 					      dentry->d_name.name,
 					      dentry->d_name.len, &lookup);
 	if (status < 0) {
@@ -2862,7 +2859,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 	ocfs2_journal_dirty(handle, di_bh);
 
 	status = ocfs2_add_entry(handle, dentry, inode,
-				 OCFS2_I(inode)->ip_blkno, parent_di_bh,
+				 OCFS2_I(inode)->ip_blkno, dir_bh,
 				 &lookup);
 	if (status < 0) {
 		mlog_errno(status);
@@ -2886,10 +2883,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 	iput(orphan_dir_inode);
 leave:
 
-	ocfs2_inode_unlock(dir, 1);
-
 	brelse(di_bh);
-	brelse(parent_di_bh);
 	brelse(orphan_dir_bh);
 
 	ocfs2_free_dir_lookup_result(&lookup);
diff --git a/fs/ocfs2/namei.h b/fs/ocfs2/namei.h
index 9cc891eb874e..03a2c526e2c1 100644
--- a/fs/ocfs2/namei.h
+++ b/fs/ocfs2/namei.h
@@ -24,6 +24,7 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
 		     struct buffer_head *orphan_dir_bh,
 		     bool dio);
 int ocfs2_create_inode_in_orphan(struct inode *dir,
+				 struct buffer_head **dir_bh,
 				 int mode,
 				 struct inode **new_inode);
 int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
@@ -32,6 +33,7 @@ int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
 		struct inode *inode, struct buffer_head *di_bh,
 		int update_isize, loff_t end);
 int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
+				   struct buffer_head *dir_bh,
 				   struct inode *new_inode,
 				   struct dentry *new_dentry);
 
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 7f6355cbb587..a9a0c7c37e8e 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4250,7 +4250,7 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
 {
 	int error, had_lock;
 	struct inode *inode = d_inode(old_dentry);
-	struct buffer_head *old_bh = NULL;
+	struct buffer_head *old_bh = NULL, *dir_bh = NULL;
 	struct inode *new_orphan_inode = NULL;
 	struct ocfs2_lock_holder oh;
 
@@ -4258,7 +4258,7 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
 		return -EOPNOTSUPP;
 
 
-	error = ocfs2_create_inode_in_orphan(dir, inode->i_mode,
+	error = ocfs2_create_inode_in_orphan(dir, &dir_bh, inode->i_mode,
 					     &new_orphan_inode);
 	if (error) {
 		mlog_errno(error);
@@ -4304,13 +4304,15 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
 
 	/* If the security isn't preserved, we need to re-initialize them. */
 	if (!preserve) {
-		error = ocfs2_init_security_and_acl(dir, new_orphan_inode,
+		error = ocfs2_init_security_and_acl(dir, dir_bh,
+						    new_orphan_inode,
 						    &new_dentry->d_name);
 		if (error)
 			mlog_errno(error);
 	}
 	if (!error) {
-		error = ocfs2_mv_orphaned_inode_to_new(dir, new_orphan_inode,
+		error = ocfs2_mv_orphaned_inode_to_new(dir, dir_bh,
+						       new_orphan_inode,
 						       new_dentry);
 		if (error)
 			mlog_errno(error);
@@ -4328,6 +4330,11 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
 			iput(new_orphan_inode);
 	}
 
+	if (dir_bh) {
+		ocfs2_inode_unlock(dir, 1);
+		brelse(dir_bh);
+	}
+
 	return error;
 }
 
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index dd784eb0cd7c..3f23e3a5018c 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -7203,16 +7203,13 @@ int ocfs2_reflink_xattrs(struct inode *old_inode,
 /*
  * Initialize security and acl for a already created inode.
  * Used for reflink a non-preserve-security file.
- *
- * It uses common api like ocfs2_xattr_set, so the caller
- * must not hold any lock expect i_mutex.
  */
 int ocfs2_init_security_and_acl(struct inode *dir,
+				struct buffer_head *dir_bh,
 				struct inode *inode,
 				const struct qstr *qstr)
 {
 	int ret = 0;
-	struct buffer_head *dir_bh = NULL;
 
 	ret = ocfs2_init_security_get(inode, dir, qstr, NULL);
 	if (ret) {
@@ -7220,17 +7217,10 @@ int ocfs2_init_security_and_acl(struct inode *dir,
 		goto leave;
 	}
 
-	ret = ocfs2_inode_lock(dir, &dir_bh, 0);
-	if (ret) {
-		mlog_errno(ret);
-		goto leave;
-	}
 	ret = ocfs2_init_acl(NULL, inode, dir, NULL, dir_bh, NULL, NULL);
 	if (ret)
 		mlog_errno(ret);
 
-	ocfs2_inode_unlock(dir, 0);
-	brelse(dir_bh);
 leave:
 	return ret;
 }
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index 00308b57f64f..b27fd8ba0019 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -83,6 +83,7 @@ int ocfs2_reflink_xattrs(struct inode *old_inode,
 			 struct buffer_head *new_bh,
 			 bool preserve_security);
 int ocfs2_init_security_and_acl(struct inode *dir,
+				struct buffer_head *dir_bh,
 				struct inode *inode,
 				const struct qstr *qstr);
 #endif /* OCFS2_XATTR_H */
-- 
2.21.0


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
