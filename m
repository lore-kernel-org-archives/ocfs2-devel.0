Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF061C77B6D
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=puHGAFre7ABecN1x81QfRZ8gG95khkBjeijXriS5rKA=;
 b=hoCsUmNbB14k7SNR2lDo4qmz1ccEuupzsdR5R+wtd+c3QAKeL7vqFvMJ+AkiaVGM+wouEgwpIVH2
   U9ttRelOxrRgtjzFK6wVpjf9pzVvyIw7TWd6vDfubX5tW+ArMBSB4W4kYCpuSC/oW7IaJJuTPBp5
   YFHMdZNZNSkbq70fUmTRtkeLNjVrgiTf1HBKNcQHMTh+Rt+VQoTX3aT8usQ8Cs5TBTl42j/yH5jt
   ET3mgweWgv2ws+i0DcV6XtZ17L+AxzOlciQtX4dmOq4gj3v+z5EIHsJgU4rguEkf1icrWUyAWog5
   Vx4dd58dCH66XaL83Ao/Yt4Pq7vrxd4XV+Q4KQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=puHGAFre7ABecN1x81QfRZ8gG95khkBjeijXriS5rKA=;
 b=e5Tz+CJt/SSNqOfIoafjUnAd5i/u1cSi4cGAHxAp7i94HJ+1JNqq8M0Zmco4MybAno0zP4OmxGuQ
   ciJvWREBEkcqJ24uFs0cisS5wpOkYujlSlur2+9bKEl26u5LybWRlQ3DndN1GT7Ll/IG4NPpQMSg
   hPoRv5C9W9/qxbt4e7ju6Q8aS8NlCSVCiaGPUM0+LSwGtrrZKsPMncgQx8xsetBpv4VjmtiELl33
   sKek9B6Z3XN25jFarTOLKl7tnMBQcRQ4w3ZeHuedbn0KOo9nrIJtFFGct0vvRP7V4aUiO5b5Fe6a
   ZK4VaSAtLpELDDgTSwv27cM5WEA/thZLoOU+zw==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX00K9EM161T20@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OFyQMCpvCjwpcH7Xhmc/CCrU/Wp/qpLeZb/GB/mLlrNkemJkxfQsdH0XoWkHxwNNw2bwE15f1It99Eebow29i6hXrb+CG/0qRg+wkeg5w6M6+OcRIFywkCY/8FZzK5mS1o2HawkQljlvYXujKe3LFGk/8mYXfqQyFJwH7pRbF7KM2RIPpvXTiphT2WEeex8jJaDPldz8BiyQ0oHDIwxFXSXIuaap3jpsW75VWNNUxJhVn2ep1Go1Jh7uNIqUsEL8B+M13zsQaoD3ijIDiUm46cPtYHKqUYt4F4OLo2eAQFzqAatn4ycLUpdkFwAlS2Emwtu5lojASGfA/OUVUniP5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=meK3eJWZv3zCgZpfoN2XpmXl+kR+wlAHWD36VfQ5CfE=;
 b=bOzbuU/h6YA5gFpxMp7vdOR7JC2M+lw9SSX0w9HQvXeiI5J2eT/MieLYXRLOuN+7q217IDSL5tdx5zgB7jRoN27fh1JRNNQXL8JRbRLpQmWVqrP4+OrK1CaUL2KsTut9AgubJEBYN9gU/k/diSjJ/uXQ7FSxVrsrME9LllvoUntzOwCdcMbnN1SH+T1I6/hj3g0FMtV4Mbe0lRfYWFX9IShKk1HinTvKAsdqNvtRVJl/0nJK+9LuMhwZkqRpFBL8nt/11Ndij4sq3suXEqMFtNq5VzdU0MpEUVjM6bYgjzxKTlMx8MsbGEAiPIDNp12IfYwr32R0o3RvXQTsmmCQyg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com; dkim=pass
 header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=meK3eJWZv3zCgZpfoN2XpmXl+kR+wlAHWD36VfQ5CfE=;
 b=hbuJDvumQukOVUFj7PR3cO6foLEEqTlEy4wFo+7H1+GCF5Bj7qbBhr7EgXFkh52+Nlf37UdMaOlgZGocoFYWxVQaWhup4o118UdPmL4ejfsFbak2ZJ2zRwQjNT+C5Yxn7H+abYsYAPHCZNTkg5M0Fr6FD7az9+u0Z1XuSvEps8vj1v8CEgKhwqQFzD2AkUwwlrKOx9d0Euih/8gYh6sacTikQGMZy+4FLXLiwJvqTf8SMX31oH/QS3ZONhuyydBrHmbR0KsUR914QHygTS59KjnEnfZ6FZj9HXMgR6Kav1U9KiUInuJbEDloeP8Jv++cf28PjPK2OnDW+HT/bkLLMA==
To: xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com,
 jefflexu@linux.alibaba.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 rpeterso@redhat.com, agruenba@redhat.com, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, viro@zeniv.linux.org.uk, brauner@kernel.org
Date: Thu,  9 Mar 2023 20:40:34 +0800
Message-id: <20230309124035.15820-4-frank.li@vivo.com>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20230309124035.15820-1-frank.li@vivo.com>
References: <20230309124035.15820-1-frank.li@vivo.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SEZPR06MB5269.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199018)(36756003)(186003)(38350700002)(38100700002)(86362001)(1076003)(6512007)(6506007)(26005)(83380400001)(6666004)(921005)(2616005)(316002)(5660300002)(52116002)(7416002)(478600001)(6486002)(107886003)(4326008)(41300700001)(2906002)(8936002)(66946007)(4744005)(66556008)(8676002)(66476007);
 DIR:OUT; SFP:1102;
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 12:41:37.6749 (UTC)
X-Source-IP: 40.107.215.125
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10643
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=74
 lowpriorityscore=0 suspectscore=0 mlxscore=0 malwarescore=0 impostorscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxlogscore=703 adultscore=0
 priorityscore=159 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303090102 domainage_hfrom=9102
Cc: Yangtao Li <frank.li@vivo.com>, linux-kernel@vger.kernel.org,
 cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v2 4/5] ext4: convert to use i_blockmask()
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
From: Yangtao Li via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Yangtao Li <frank.li@vivo.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: SI2PR01CA0006.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::14) To SEZPR06MB5269.apcprd06.prod.outlook.com
 (2603:1096:101:78::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5269:EE_|KL1PR06MB6259:EE_
X-MS-Office365-Filtering-Correlation-Id: f57bed93-7152-467c-dc4b-08db209b9fbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 E28tnN0AujbpmRZCk6r838sx8XzdR4QOnZsbXrmykSp75UD0A/y6Xm5/d1Ij6fV5gqqK1fM5Ekm8uo4q9tyermXalqW8exywaZz9u84vs7iCAzxGkSyj9PtnlY2cUDRFyFf0hIUI72uhsAM4dZU0+svfl0xLcAyEkWF8WRH7n8igQD6+1HQELI7qKJSK6YnXKhLvlMEofu8hvRAQ4hy04oKbyrz/13Vymu57P9Ug7wZCdkaBWJTgAIZ8HNtDWFyFEDQiAtTJH2icaH57ug9SjLUALU0QoHPT835TGfBqFLVTZGynRgLgA69eSIwby3BRHljMFP4Mbq8GDQ0Ofa40kx88YKyDRS9ZUeiPwCrLkqia07KxJvBBGcmJ/xpZj7kbBaDoOv4FCJ+N+GyG0VUp1Y1AHT7NgWzwAP95LfiV/ye9dZwA/tdM1UDPmm3BiXR073VQpy1vQcn3us6VcFIZm5r1SiK461i1Aj3lShlFlcg1UqxSC2NPd23+FhS8g1R6k5KMyt2v7Cr0voq2BMgFjZBhr+fI0WbotS1JzEmM6urQMgV25THqSRF5u+XkSKvzW7Rsv9WPTFqmBpBeBcAwM1IKmUaz07UWa9ODGif03lnzt1Fw9P8yNM3q5UEKAo401R1egvamSqc3mdR/OpbuhZaCkTsJwcAmEhG2/an81pmQ0VfvGBudEB1htMym3VEJr/3vlvsE4eeAWGD4C3cntAXt96KoIZucnq7+mXXEa7M=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?ZgLxxfX4t1McWSOmo8olL9zhL7a+yo63tKZgLEGPM+bFjj1dBBDPgqMRTNYr?=
 =?us-ascii?Q?BdNh+bcEBs60dG1kBA1T8LqDM2DBpmriz8QVdQ8I5YRldTo/o0LA4YmRFQIE?=
 =?us-ascii?Q?wCXmlTxZ9T1VixePb+TUTweGwczPXYu6Nclr35lrviR4qPBrR5+9jqNCK3i4?=
 =?us-ascii?Q?dJ65DOgTl5UpWXZnOKz2IAUOFJ+zFjsIujWf0QJkwI6PrC6AlYUbwISfAwHC?=
 =?us-ascii?Q?qv1Kug2wkxDx+gQbGlmTaNXf13ctN1hy9cVeWJCmfibRdWOXtd7hlqmRvxqb?=
 =?us-ascii?Q?GCf8Rg1aOtowXDdD6hXEyBd4UtAF4EnC5Wc5uBeJkUckL7B4wmqlrdxpTtHu?=
 =?us-ascii?Q?wXhbnLUXEF+VZ0wxfL34qbS1hglNwPC3BCoUfCV8lS3hTMQV2keqty2HWZF6?=
 =?us-ascii?Q?uKKTJ4lqYMfWycqedrniZA8JcqMAWz0WTOl6/SAPlpk+zUqVfSjyCf2MSax2?=
 =?us-ascii?Q?GRHX+GHdeh+FShO6d/BOdSyp/+IRpMACzUHjwaof9itmgu+f2mSOWkRqmocJ?=
 =?us-ascii?Q?tjxDGwZCmJIa9aqU+Z6lKd2xF91EMuSorqtUNRedXaF/LK7ALBGPWtAi3BLP?=
 =?us-ascii?Q?h+lkurzDb0WUQDgRqnysv5d/COtRXH05I3mM66bozQLd1mXkXoFYC7U5AIMj?=
 =?us-ascii?Q?exs/wgEBcf6dJI6PZ1WoDqR+0sWa5ywRiqnsW3gpKNARmaRrm4406eKYqBRX?=
 =?us-ascii?Q?S77jqkPxhCbv7hA5j6Pql8fD9kK24AgBpkLqKcaHPK5UxSrXhEg6P5qQLwWv?=
 =?us-ascii?Q?YjgcYGzuAKbTl3BiBVMZQf8zOdMcpaccIlxzTDZoXw9P38m0p9X1Z9oukxmW?=
 =?us-ascii?Q?9M2l8RkIJWhi513JMNzHLQJHYNPohSqZ5jRc2xXGKranwyox7Lzuo1yip4NX?=
 =?us-ascii?Q?ZwPVxEQTJMxTDETm3Cbl3jubdEuUPrqUtqayzUrbPf2x9Mjh2elkySCbw1W+?=
 =?us-ascii?Q?6SDF8HHE4DDj5rolI3PVZSZWRidhigHkDXhSfPAaLY6kxnNv4H61bNASph4i?=
 =?us-ascii?Q?DMVn2VzhIkWX5UmYrh2KZ5UdKic1EHB5I4Wpnc24yahLnC9lcwqii790St9v?=
 =?us-ascii?Q?dihSvgB7cq8I3T636aCs4nLu5qveMGVPoiffRqhCeb2slcz9rrxMZCJfmLr8?=
 =?us-ascii?Q?SoFdCPQlH4Gpc7hjQzxqsMtPRpY/unsSgY05CLAaSbwoUql6sY2qi7xerVnz?=
 =?us-ascii?Q?J+CVfv0nLJGPOvNcGLYaDlcK2+rgzc+TAY2Uc0nIiDyTSwVUwRF7DxB4sLmg?=
 =?us-ascii?Q?GDDZuM+U8VZDMhE7+B+0Pz/lKF3vb/10W9h+7lh78fxVUZsKr35Hro9vcoC7?=
 =?us-ascii?Q?oFLLXiuIUKdLS9kPIsgCsQbjGDvksOX439gN7RNXRsoalHG4mo90TeSjY0ip?=
 =?us-ascii?Q?NOslqK3EeE1XK4NeHXtMcBUV+Yn30bgkYAUbmh0BRAyQ5V+Wcu01YEa4e+mz?=
 =?us-ascii?Q?/xC7dvzkBbTYyMGnVzWcYSHuHEsyfTERq8r1jky+K/eokdE3nU9CZvzqa/AK?=
 =?us-ascii?Q?YigYmMsAhbEipJNkqVjr6NCFBV0YIiIey43i4gSFjSAfuv+c+73bFArtWwhQ?=
 =?us-ascii?Q?LIYXU3Gvwf5DzvbRR13H1DRwVgktRb/byIy68c6l?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 f57bed93-7152-467c-dc4b-08db209b9fbc
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 +dlKu3pch/ixyeDj8WZgn90xdOKVnn/PxaOGafWNX4R/lfto4+glIrZ4a8O+iuorfDlSeTgLt506p+3lDGMYdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB6259
X-ServerName: mail-sgaapc01on2125.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.protection.outlook.com -all
X-Spam: Clean
X-Proofpoint-GUID: KPUyp7uFhuduX_X3y37p-R-O76Rk7J21
X-Proofpoint-ORIG-GUID: KPUyp7uFhuduX_X3y37p-R-O76Rk7J21
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAE2dT0ZX1zd407aqWI1lnvwSVZ3VjMs4qcH1w7Sf5JzNw+OuR/9i2AJ21WsZSyL
 8IgWxJylV15tUSNgIcSdmsncHMB/7ClktXEF0lgyIY2eeVx1nwB+WIpraGlNvuCm
 aXuwZ3tW9wW6gfde0fVndqTaNdEG+xKxSsigKAgtBYrHPrkyCsFasSjRThr8XgrY
 fydY1NqquKQ4AkgVSWpGOQd5B7y7tvMS0c3rrpOw+0KWrP+TrXJ8SbEUkw2cafye
 qKEccpW7vkJP8Bs6GNDfly2rHs5uai60hNpxugbFa6siKvagVxzdPi9uCiIbf0KI
 i713Zw2Ubu6gz1wvSryqnJdPXHISKxharJeb7or3VHDfkU+CdbMndvBDjBv/pbKC
 QNnjvXXYIgE8G7IKWyTOhKSCRAbHTUDr9B2YRz+TRq+/vK5djngeOEpZL4vX+gNN
 umvsU1fhDcKdEBTcgKRqACS4wFVsQo1ItEDxvVYM1YN/Bd7ms7Jg4XX9AIUC7kTs
 CxkOeLI71CQd5Zzz6qy2hif+XzscqpfB8lOLKGxdOf7K

Use i_blockmask() to simplify code.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
---
v2:
-convert to i_blockmask()
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d251d705c276..eec36520e5e9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2218,7 +2218,7 @@ static int mpage_process_page_bufs(struct mpage_da_data *mpd,
 {
 	struct inode *inode = mpd->inode;
 	int err;
-	ext4_lblk_t blocks = (i_size_read(inode) + i_blocksize(inode) - 1)
+	ext4_lblk_t blocks = (i_size_read(inode) + i_blockmask(inode))
 							>> inode->i_blkbits;
 
 	if (ext4_verity_in_progress(inode))
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
