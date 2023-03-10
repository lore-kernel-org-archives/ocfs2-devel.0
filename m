Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEB37C7EE22
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3gXcSuKvSNQOeoilj9OSccW7GuaZ/gIlCkY8GxtJClw=;
 b=jlSuitva1D2Uw/ZGgU3Mav0lURfp6y8EndulCNu6op5GN0nvgiFvfIWDITUSXRou+bPk2PNXRJrd
   43/3H8S4M+Ku034quj1BUEE0V7i8Wj0t2DfS9N6dpcI4UVeYSDaOpYb8MlAW5OLiT332ay9QxIHT
   PZRqHT0RY94C97bsh7QFpN4qZCkMN54aEpo2wIedjWNgZ2TeWMBTwMMeYljbKuCdABcTEJiB8mEy
   6k+EvqlZMI/RNZjSqt/0jQpuqe+fgp45F1CvxIa3hRTMaXKNlcqo8cLnXIAPpGewyvQn9cxFT6is
   xA0lZE7yMbZpubg4WSLae/alu4T6vUF0ULT98Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3gXcSuKvSNQOeoilj9OSccW7GuaZ/gIlCkY8GxtJClw=;
 b=uz2ki9YMdwRFaoLllSQyz4so32epRhNNukexV1RchvKQL1zzJuVnJ76a55t0cjleMMMpydjHASx5
   HBILDpUGuuvC6NkULDuK1jmPe5GxslCSLVv/euSwhTBBZ88Up5IMKrYa0w1Zr0u5/FGWcXJk9Oa/
   lIBN+rWdT5MpY1fU6gn+lfJrCagZOBkv0zlZ9PqvxI6Efbq5C2GpVfCuX3YxKMIdoqHoE7uokFcX
   riSLMS4b7FO1r8ojsRry5i6ToeT0ObDWafUQMo4RErQYrr/Fwo5Efb1N075GqXfkDJyxzGEjBEBq
   FO+TFLyaXgPYprLBxWJxgm0zVOErcSEplEI/OQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX00KENM191T20@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZL7s1imO+5b3clVsT6Pnn5ktPSA13dm2/c8CZCoi+S4MOKPO3Uedk5cY2GPLm73vQgXbLjuQ1p4epWMGvHJzBSwk6GFqSmi2nyf5h0kKJvW1tBHoG6LJJj4f4Py4FjhBEzwWeyKJBPMTOwDa0ilKNTG8WCJttYip96Ldnh6FMDv2OaqdD0dSCtuiQmx3IW4asZMM6L6S1UEUp5r7KeW5Bzr1YT8VFgk0AoYK8kuWU7gd6oogR8MWjmUoM1TdGF7BWJ5cLIfa3p4OP3VIpAbcqgwDQQ1NsOMmA/FrZtg51l8dBggZcMzYlabKhIHqst50YxCR6hY4UO4V1Z4hRBdJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AkqlOAKWJrQIHLi4ycPcFOW24bEkozylZHka4VWrcr0=;
 b=Oeblz+Mxl+Uix8Rsf/x/MloKBov/rVtYqEXl1rob5aLakgnhcMGEWyVWZMWXNqi7i1UnCpUhnz0/nDo3ecuvqdkAqcAV76+qb3cXdlWhdyWbszszh2n6vWwPuKcdYTUn4msu5lREWICoy2clG3Vuz2zCBMTk74LIDfL306iB/07765egNWgvuIAm+HsidJlYUWaP8elcFvUg3hYAqvgeU6nZjxS1BVGWdZ+Ixfe3qFG5Ztid/nvOetFBwAszFEqx2ezPLdR/CQzixMwKGHx/CSvQKJ+itDk3nnmxulfAxz/gN+Rgm7h2INQnPT0k0cVCzKN0w4t+9oB6eqdWvFCdwA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com; dkim=pass
 header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AkqlOAKWJrQIHLi4ycPcFOW24bEkozylZHka4VWrcr0=;
 b=nfoNsjhyRZTBZ6vFbZz5VQg6D3dj+nx2lPq10eORmdYg5vmaF5rfTTRoiz6jxMAakBsDZJEEPsDToHcQfN/DztXmddI6FYFGEsOxK2gT6iKHinF0h0ccBWhCq+lsQZSN3OkdCW38MhphKMAFAPvvwqEhdnKZswbzzHsCCmkvg3Dc60/bDlL/03Rt4lK5I5edO6MV5CwRG36qV6NT27pbXg1+2gHaE5gfpFtiF0ujkSjwUUHB3jv72wvCb5NxlxF/GGHGNBaa+LS41iAU8TAvLZE6Ht1PKljdmIJugLa//YNfLtpWlSGx0YJlvbJsI9IM2d7mxRR4aqY38qda0bmRvA==
To: xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com,
 jefflexu@linux.alibaba.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 rpeterso@redhat.com, agruenba@redhat.com, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, viro@zeniv.linux.org.uk, brauner@kernel.org
Date: Fri, 10 Mar 2023 14:15:49 +0800
Message-id: <20230310061549.11254-1-frank.li@vivo.com>
X-Mailer: git-send-email 2.35.1
In-reply-to: <e8054874-88d8-e539-8fd4-6123821aa3a8@linux.alibaba.com>
References: <e8054874-88d8-e539-8fd4-6123821aa3a8@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SEZPR06MB5269.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(451199018)(86362001)(558084003)(36756003)(921005)(38350700002)(38100700002)(83380400001)(478600001)(8936002)(2906002)(5660300002)(52116002)(7416002)(4326008)(8676002)(66946007)(66476007)(66556008)(316002)(6486002)(2616005)(26005)(186003)(41300700001)(6506007)(6666004)(6512007)(1076003); DIR:OUT;
 SFP:1102;
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 06:15:58.7693 (UTC)
X-Source-IP: 40.107.255.138
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10644
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 priorityscore=219 malwarescore=0
 mlxlogscore=562 adultscore=0 clxscore=120 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100049 domainage_hfrom=9103
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v4 2/5] erofs: convert to use i_blockmask()
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
X-ClientProxiedBy: TYCP286CA0074.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31a::19) To SEZPR06MB5269.apcprd06.prod.outlook.com
 (2603:1096:101:78::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5269:EE_|SEYPR06MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: 021e69c6-fabb-49a9-1d1c-08db212eea13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 HHGjy8qDOIgtgI2uRNhgVpdKnZkv1uEPcVRtwmpND1njfNAPZSkIl/uhjsDufCAzirVOSePxbWJYYusBHegjXqIdGKU3Xzy4Evw6dxV7LYWa+MKDi2ee/ehSm8Iz9FPwMxLrUsj2tuLrekL2GJegTu0ooFWZkGwv4VopTbO5HPb7yn0seG45oSmkTodmgafXmmIIOR4R3xd1fNgtpT/j4bdlNTpixcG9SF83q1wafdYlMIUZ9GO4Cfyk2nCgZgfDZ3QeOa0RlPPLOp2Qu4gwih3bzMS4hQ15e35XgLPsotOMURf7vPTCj3sZItR584fqg+kfOCbccV0TarEi9HMm9Y6B6tRRiZ/pn82XrSQ7HcU8wpttmJR3UKDfAkh+aio+Iiz1HHCjP0Pt7JxOOkn/t7aHUekkDWtmSar4wF08kbPzigNKiYAc09Ijjh7p4ZqA6RDgEC2ITZXv2A1wKHY7UsrPUkIOJhLKbJg1fpWGOYEDU5rn5Jrw7t5LKYgEChxzcCiV4Wi5q2JRTQUgc5TnqERTFyLhLPpMbs+rGVMeSuLKcNjUAzCPNvYMds/BTRzeYRtORW1oqL71xAREg55xhJahSQe9d8fXmVbhc5jQxngAkfC68JOxMjf2EQBJEUcxUikg3vLon3XBL3ESyykHeYa+hfBCRs2/PVj882H1pJlbSeXLtPSUthEJS0VmvQNIRSxGL5zyqXP13XnEwevCB8iUht62V7URrqcYVMe2vE8=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?oQctHQSLyFiIBUOKPS5mfINF9wc9Jh/1kUspOGDjI3HDtZv1Cantx0mSzW/T?=
 =?us-ascii?Q?uG0c85b2AsSeLRz5p3Na+/vmaV1inMaybwvezUNHh0q0Vv5WE9SqgXXYXg9i?=
 =?us-ascii?Q?/dKHNz4dMuTKjZult59beYlcheYYdHpYWMJPr/pya/N6xrwvoOahCb+jqkXK?=
 =?us-ascii?Q?42Yl57dnG10kWAxKM4oBy0PjPfdPpePl9Q+S2RXAUoUmzZxkPWZegefboM5I?=
 =?us-ascii?Q?4N1nfyFSoZWUE6T4aW48Z8v5Om1ZScRJSrgG2MeIRNB9onWpnmHDQLkyMvyu?=
 =?us-ascii?Q?QSV0TNsmbH3tzy4mEDFI1WFL5bfol+bhBILeOezYOFgfCgDMDVN0fRl1bL9o?=
 =?us-ascii?Q?0NY9vZ2MaA/a1jynudHBjq9pG3M3ddKpU5e/7NJRznhIm4giCp9Btl+ej73t?=
 =?us-ascii?Q?yBM3nnnwBa2xDscrdri/kIcgoQPwcfWIw44RTtyf130OpSTq1CmnpO5wqEEk?=
 =?us-ascii?Q?yuxp6aEo876PMRG5VK0JziEWZnvGwIAOaD/ZaD0Ds9SlMD4JsYPxG95mZQj3?=
 =?us-ascii?Q?7Pfoj8aPbt53VRDJMooN9JsBVz48cjWOaDa58qJIfoXDuxbGMcrv2ozmEMj0?=
 =?us-ascii?Q?BhN9xY8FmRHanH7QH1fZcBXlzbVQlWad8rrc/lJoSKbAkWG0u2WGtpd0dCHG?=
 =?us-ascii?Q?fmps0wVbnQF0lyDFx4lfm/SyiBcC8LUCIX/qL+nPepGcpZzJQBQn5adxo5EX?=
 =?us-ascii?Q?wg6qaB3qjRt0B9QZ0wrNPumxGtigNbgEaX84aV8k+Yg6j1QaYd18K+xEObSf?=
 =?us-ascii?Q?hz9JyZnaMO69b4TXdQzJ30vuKoZ9iVRnbDbx/qeUFSaB6hPT9xxnPM2trxlK?=
 =?us-ascii?Q?3Z64N3Zdq1m1HH6D3gTCDlNnA4VCHMpTON8dO9sZIhYFj4tO5hQHLm2l3cbT?=
 =?us-ascii?Q?+LYj7soNyf/Wx5K5mLC7Nv5xQCQ9vs9Wo8JKQKtC1+RE8m7L278CAZJrIjw4?=
 =?us-ascii?Q?sum0aZ7Ei4EzYN21tnIuKs87+S01SrXz9owvUu/45Ch0t9usH9J2jLgOrrI3?=
 =?us-ascii?Q?JqUdBLhaY2HGSsftcLqgMNq3868iIuHHhhRtsjShJfz2FXmtPLg3XCNgcRFt?=
 =?us-ascii?Q?mgOt+1ljuBxhRNrxDElTtwiK0QqM3mAKczHYoFXAnP+4tsJl0pne3XEoLZJS?=
 =?us-ascii?Q?vqzU0FCBnDsCSBsTcS0yKAq3Ui0+wHrCfwuS6xRnbU6iDek7c2p42Qf+mSKh?=
 =?us-ascii?Q?z12c3dzSYgN4BpjQ9cIUFogopVWzOhDyS5XCx3qiIIN3VNt1s53M8kp4ReQE?=
 =?us-ascii?Q?S3UEIiWM2urdD1akbiHEIWLtdNfDrztsJqMFpjz3xg5lHT5odgbzn7DjVDch?=
 =?us-ascii?Q?TAM5jmoTEEGAm+WToYXM0+3a2aP1UPpAQ/mu86NaHXTBkuGXM77Ue59w6jqe?=
 =?us-ascii?Q?Q5jBhgXDFjMGNMhQJJo33EDUacMat56rt+Mj+qmh5GFoq+0QGp+8XtNMn5u6?=
 =?us-ascii?Q?xDxZaIGXAALvWN4Xqn4nVLkHAuVOfph3XnDyW+iaYTNX/Q4u+SVj/kKRIMCY?=
 =?us-ascii?Q?8uW8dU3kA/CxDsHh8TXgCXIZFVP88pQH4hDKOYGknyBKLqgqHCqfTeMjvQnw?=
 =?us-ascii?Q?qyaJdfcIWauu94WCqD7hvAGbC6Y5UxsAst7CNhb0?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 021e69c6-fabb-49a9-1d1c-08db212eea13
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 pIvaICdj3u/sccP3mUuwvYY3U2FfzOeFlUbBI2GqhB2KM2VEZXNa+jUGDMN7seaOq4CtkE4iRu2uRxZYUwwIkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6129
X-ServerName: mail-psaapc01on2138.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.protection.outlook.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: uWKMkn1Z6NRxGdBybi1xJau03umkEG8Q
X-Proofpoint-GUID: uWKMkn1Z6NRxGdBybi1xJau03umkEG8Q
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAF2ZR2AfcWj9C6hRzKffIFez1A4y/BOnktonO7NLGDJcKz+ILtJptIP0diSvwpV
 0hZMpCogTOpWjtLGGhaT3ths9YiwQElOkbojYK6kHrN7P6dAgWMeNSPvmvLqYFOt
 eZtGqRf98XeDh1uTGdkNusjWp8/pNsiW16feZqA6dOUcZAgcg1QC/iR8jAFpJvBz
 X+11/nGKjKNwph1ZncXVRRXwrG74GPeGLSCrQBOtgw+HtDk2qU8Ll6xJiedW3Es4
 iFFT5zn1x4hq3Z/lQePOlmFpYKMrofLtTQGiH0FXhQAwpEdYRG0OnC35taEH/8XI
 6kepJQwMzvL3Fpy3jQOoTuaCQnWYFexGCKQoovmfSf7qrdecH6FdJ8JA9ap0NlFb
 ZcnPzIYLxCD0tfjXH02D/yJ/iif5hFYpZSNNSBmbtu/UMYxxXYMxzX02usOzdBH5
 HkLdz/qUV6oUgLLYvz9iTAJN0ba6kJQalNdSyweTF33ULoI5/KLko3gcA1s2fRsB
 ov3+eHx4ZN/1Pqgv5V2iFVSHo58uw9SESXMejhf9bpmPlQ==

Hi Gao Xiang,

> Please help drop this one since we'd like to use it until i_blockmask() lands to upstream.

I'm OK. Not sure if I need to resend v5?

Thx,
Yangtao

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
