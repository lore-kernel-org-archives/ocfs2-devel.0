Return-Path: <SRS0=eOWJ=NK=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 507E3C4338F
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 Aug 2021 01:53:25 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C4223610A1
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 Aug 2021 01:53:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C4223610A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17J1qY0C002053;
	Thu, 19 Aug 2021 01:53:23 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3age7mv5mw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Aug 2021 01:53:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17J1p4fY051502;
	Thu, 19 Aug 2021 01:53:21 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aeqkxesg1-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 19 Aug 2021 01:53:21 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mGXC7-0001wy-JR; Wed, 18 Aug 2021 18:50:11 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1mGXC1-0001vp-5P
	for ocfs2-devel@oss.oracle.com; Wed, 18 Aug 2021 18:50:05 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17J1j7U6087130
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 01:50:04 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3030.oracle.com with ESMTP id 3ae2y3cww5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 01:50:03 +0000
Received: from pps.filterd (m0246579.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17J1gqJS024267
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 01:50:02 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ah9s8j5pr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 01:50:02 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur01lp2057.outbound.protection.outlook.com [104.47.2.57])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-13-cxKwwCpZPTOVsYgLjnIXHQ-1; Thu, 19 Aug 2021 03:49:59 +0200
X-MC-Unique: cxKwwCpZPTOVsYgLjnIXHQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=kVUoqMVNkeHvqXFa2yBJhHBPcUshD6o9k1mv3urweH0DMQ+O4tJMWNMwnWGRQ/Oz/nZN58FNIkiiLPSj1wQmZoYZOo7IjP7HaTp9XUtYkVdT0EEHwKcSupvj5Mj/F9Suo2U1yWMLP7br0CdRuSNgp7bBdR1/jZHJqDTCgeGXnCI+E/aqG8apqQv/lgiU/GrxoITtczmPR228dQ07ei0AQwHjrVhOPS92yqcJX9zDpQ3GpxJBhrNK9A+yrbtqXupdiAik59WaeEdTfDISTAM3Qd5rbtZbLypeR7dgTf3LeQI209uMxZhEC4jl9mfS4dRGXcuQBvg7u87SW7SwTduPSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=P87XAgdTEanpeHo2kOOWvshohZ8Ntj63DAGx5iPm2Vw=;
	b=Duww9mzl+dduR7pgfcGPAH8MluoASztYMJH56WTXNGKEiDjg5SrjAqlMrIPRWnpBEZZ1T5Lu1vkU8aXeFKhjKi0w6vSIxZpdMIqP+QHWF8CEYfgBPk5m8VK/UOpCesISTT9go2meGATWoxKuF+EZJF94nl3bmoKsWXiWd0R50nVVS+Q7/rDLe1DgKaNweVdRbv5VA/qEfj3SkCtJ7MQa35MQf2e6AQF5UNWw4LdL+hZ/NAdwjurhIBZr5NYyhXhE0iy4FouW81O0u8ZD4+SfVJ+vm72DmFC+ner2CeoXr28OOI4ZZ7vnRvaQ6efkd0EBeJDvlgYETpDspCMmSo5S9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux-foundation.org; dkim=none (message not signed)
	header.d=none;linux-foundation.org; dmarc=none action=none
	header.from=suse.com;
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21)
	by AM6PR0402MB3941.eurprd04.prod.outlook.com (2603:10a6:209:23::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19;
	Thu, 19 Aug 2021 01:49:57 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71%4]) with mapi id 15.20.4415.024;
	Thu, 19 Aug 2021 01:49:57 +0000
To: Joseph Qi <joseph.qi@linux.alibaba.com>, mark@fasheh.com,
        jlbec@evilplan.org, Wengang Wang <wen.gang.wang@oracle.com>
References: <20210729110230.18983-1-ghe@suse.com>
	<5821fd0f-2018-dc1b-a5c0-f948a7debff4@linux.alibaba.com>
	<c7e1f0a7-e75c-d1e0-870d-dc480d070079@suse.com>
	<71608a14-58f4-dba0-d695-fee65de89192@linux.alibaba.com>
	<801438f5-655a-c708-aa25-343d54a2f11e@suse.com>
	<86e3d724-3147-ccaa-998f-0f857c575f7e@linux.alibaba.com>
From: Gang He <ghe@suse.com>
Message-ID: <a0a9710f-461a-99c8-92f6-a99bb11b3a4e@suse.com>
Date: Thu, 19 Aug 2021 09:51:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
In-Reply-To: <86e3d724-3147-ccaa-998f-0f857c575f7e@linux.alibaba.com>
Content-Language: en-US
X-ClientProxiedBy: HK2PR06CA0003.apcprd06.prod.outlook.com
	(2603:1096:202:2e::15) To AM6PR04MB6488.eurprd04.prod.outlook.com
	(2603:10a6:20b:f8::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.110] (111.205.14.52) by
	HK2PR06CA0003.apcprd06.prod.outlook.com (2603:1096:202:2e::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19
	via Frontend Transport; Thu, 19 Aug 2021 01:49:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c12169c8-6e0b-47e2-8b41-08d962b3a61d
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3941:
X-Microsoft-Antispam-PRVS: <AM6PR0402MB39411DE278E13162EFAF945CCFC09@AM6PR0402MB3941.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cr2pmSwxdnf2DgKoZLaxCqc/xOLcFn03mxGADK4cI9T8l7e7iod/QjOBH3QfKRl2NDELMudbUkvSa9mlK4UQJV/EdB9OmbrUuV0Is/oHOh5/1TJXTy4ObvnjJBAMhSZWW0dvPlX9VcN1Xr2hs7tXgd0bQFH27lQgXhg52MRrDklKnexWH+QtkPeyxuLlx7FPiZFSj+QBpNYBrK4tUVEs12lo2vdh34kbkC6JX+vnzoYuYX1I/YMUP9pAgaAr3+OvbbWK5QHIgTIry3Bvcrwa+O8rMiIuBe8y+U3YBuYfwyXl+n0XspG3SBkqQeXaWNQZBAaOiezb6FGyYrDblMWvxCfi8gmMjUtgJcgqUA7peX51o14MKx8kLxPQG82B31SxixzoT2jOiiFyuAbB7MFUP5Byihkm8q3ZwsoTsy7XO1Scwof8h46Q990Cxa/ulIITD6Y5o4gYhc6Tc1ANR6RWR396QYFpYCUppvzV/7jjomUQ2IUrrsDBKzvRi3QfkRS91iOrbC32alH+ZdfQ0023cxFR8K/eKlG0qKqdYaxG0e9yBssKeBBkouYOCdQNixL26EKMgydG5lqVcKIqt04Mc7136DZCFPpJ6T5k7+0DOi28sikeGMgdlflUX0boAfZnGNdc2gr4Gvpvh9onh0XOYrtcc5euSSpov1kTdt8xlgvaLc0DGeNDxcnHM+R6e9KMncNN/MHxvtC5OtOdpr3RRWT+LlNigAJKh5Brm73Hqw6Cukwm3pobtLSeWekwziQ3
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(346002)(376002)(396003)(39850400004)(136003)(366004)(5660300002)(4326008)(86362001)(478600001)(110136005)(36756003)(83380400001)(8676002)(186003)(53546011)(8936002)(956004)(6486002)(66476007)(16576012)(2906002)(26005)(66946007)(31696002)(316002)(31686004)(2616005)(66556008)(38100700002)(13296009)(43740500002)(45980500001);
	DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jl8GDJLXno7GGrQQMPPkgrDtmuTwzgwEFnM9quT+XPRIj/62d6jg86Erh5Ix?=
	=?us-ascii?Q?xsYdI/xrL8HKmlDen9eh2wQctfAV2ZCUTu9ZUQgqoWC6xbAYdKonD8bkHj6q?=
	=?us-ascii?Q?NQtNlDKOtKbOGhyKznv+fATGRNZiNHYZ5jDU2B/Y40mS7R9+wkkffhz/Zj6F?=
	=?us-ascii?Q?qUkJgbrIGLuObnXVWqoSnaVcF6lrcN7n6cmvQNQVENdQsNfC0Ty0YZ6d1Zns?=
	=?us-ascii?Q?Q+qfoMnUSpketUvFwkavAM+x9fd8Yv/NpDvzem1/WwmUODnp59XeTOsfc/KQ?=
	=?us-ascii?Q?6n0ESxq94hAUEPQSotYO2KtxWW95FOTCnwnFMUcaRbiZd0sJCAhnEnXSpCnY?=
	=?us-ascii?Q?nofALwBM2MacnLF7dO7W4+IMQhK/yPH2a40x9mD60o+VnTlldUoMi/vuqIdT?=
	=?us-ascii?Q?JuwgLZGTVn0vd8b1g7LdrAy/fNrj6SD9R2ZVRR80da+eQsA2/aOKm2Zy1Xs+?=
	=?us-ascii?Q?fDX+6EKZTcCFVBq+ulBpvcSK0In/ONnWkOiehhWRQF0hfUUG9VwR20M+FBho?=
	=?us-ascii?Q?tNA3lqO5HvoH4FnxVv6/puOEf5Lyzr/Ar7MKhg30aN0cpT5E+obLxrcgrhZT?=
	=?us-ascii?Q?8dPziBFR0bf6moGSAQ44DpVBetjqjumEk0jsxDXSHF7w1oVhm6UJrpI3OMZ9?=
	=?us-ascii?Q?pwU0+OH73A4ytt/3ZG3tzajfxIcaFG0pm0A4P875wqZEWBemPatKTA6PfnSb?=
	=?us-ascii?Q?7GemQMcUiKN3Jg/Hv6LSwgCueHgKYOv6RR2hpxiUGhc2J/k8KOMMjV5yldpp?=
	=?us-ascii?Q?yxRzR847q2zbl3A2B0EEQQ1yDvmmXNlW08zxKmdhAV0kQCwA/d2hvHVXdlj6?=
	=?us-ascii?Q?oFz4WncgaHHd1zClSKdQs8vPu7sjIgMt3/D2gAWgYf59vY1XeMZ37U883Idn?=
	=?us-ascii?Q?6pBnnA86UphtchjR4MK1Ufmy9Spc3jkkjbf+Z2tA/Api4gX+/oq/LG6bLFXU?=
	=?us-ascii?Q?rhWDMEV6QQfs28jLr+u1nJlXg7nPwok/djrTuL8ydB+eYJ2+Gz/lUmV/k0lY?=
	=?us-ascii?Q?V5kpB4ha0FVDQAUqvTIoGBGXHlPHyVTWMcMJc7b1rjShz30Q0MA1ProCDkDK?=
	=?us-ascii?Q?LEkHcfwaze0AAceceIYUhzOZAVI3k2pvpSUcYO6tlthmx5ROlNmXc/8U6FWg?=
	=?us-ascii?Q?/SzMwsfhtu3j7B2QReKqsgZs0ht+ELinpUrejeNpp4wMFNNNvzSDbXRMr9bD?=
	=?us-ascii?Q?YWvmO5QlAyaJtw88TlspTYpEwAYze3tra5MWp1VYZOx8JLLkYPMmPkVBrP6y?=
	=?us-ascii?Q?9yE35tlcN+HDz3TXoH/6GvZ2oBxU6Doz5sTMM9et5jUz47yOrjZlalu5onh2?=
	=?us-ascii?Q?i2//7OwkmR95Syho7meBI9nT?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c12169c8-6e0b-47e2-8b41-08d962b3a61d
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 01:49:57.7706 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lUbcMMFdpK4cZCXGkxdOLxPLWdfmaDSQBhOKzj8Y46Ij0fUnRiZKC5y3ZLLKBr50
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3941
X-Source-IP: 194.104.109.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10080
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
	phishscore=0 bulkscore=0
	malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 suspectscore=0
	impostorscore=0 lowpriorityscore=0 priorityscore=149 clxscore=252
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108190006
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10080
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	spamscore=0 adultscore=0
	suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108190006
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: reflink deadlock when clone file
 to the same directory simultaneously
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10080 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108190007
X-Proofpoint-ORIG-GUID: PhsqqRJT6mgh4TU0nZC0zBbXmw5oOc3m
X-Proofpoint-GUID: PhsqqRJT6mgh4TU0nZC0zBbXmw5oOc3m

CgpPbiAyMDIxLzgvMTggMTk6MjAsIEpvc2VwaCBRaSB3cm90ZToKPiAKPiAKPiBPbiA4LzE4LzIx
IDU6MjAgUE0sIEdhbmcgSGUgd3JvdGU6Cj4+Cj4+Cj4+IE9uIDIwMjEvOC8xMyAxNzo1NCwgSm9z
ZXBoIFFpIHdyb3RlOgo+Pj4KPj4+Cj4+PiBPbiA4LzkvMjEgNjowOCBQTSwgR2FuZyBIZSB3cm90
ZToKPj4+PiBIaSBKb3NlcGggYW5kIEFsbCwKPj4+Pgo+Pj4+IFRoZSBkZWFkbG9jayBpcyBjYXVz
ZWQgYnkgc2VsZi1sb2NraW5nIG9uIG9uZSBub2RlLgo+Pj4+IFRoZXJlIGlzIHRocmVlIG5vZGUg
Y2x1c3RlciAobW91bnRlZCB0byAvbW50L3NoYXJlZCksIHRoZSB1c2VyIHJ1biByZWZsaW5rIGNv
bW1hbmQgdG8gY2xvbmUgdGhlIGZpbGUgdG8gdGhlIHNhbWUgZGlyZWN0b3J5IHJlcGVhdGVkbHks
Cj4+Pj4gZS5nLgo+Pj4+ICDCoMKgcmVmbGluayAiL21udC9zaGFyZWQvdGVzdCIgXAo+Pj4+ICDC
oMKgIi9tbnQvc2hhcmVkLy5zbmFwc2hvdHMvdGVzdC5gZGF0ZSArJW0lZCVIJU0lU2AuYGhvc3Ru
YW1lYCIKPj4+Pgo+Pj4+IEFmdGVyIGEgd2hpbGUsIHRoZSByZWZsaW5rIHByb2Nlc3Mgb24gZWFj
aCBub2RlIGlzIGh1bmcsIHRoZSBmaWxlIHN5c3RlbSBjYW5ub3QgYmUgbGlzdGVkLgo+Pj4+IFRo
ZSBwcm9ibGVtYXRpYyByZWZsaW5rIGNvbW1hbmQgcHJvY2VzcyBpcyBibG9ja2VkIGJ5IGl0c2Vs
ZiwgZS5nLiB0aGUgcmVmbGluayBwcm9jZXNzIGlzIGh1bmcgYXQgZ2hlLXNsZTE1c3AyLW5kMiwK
Pj4+PiBrZXJuZWw6IHRhc2s6cmVmbGlua8KgwqDCoMKgwqDCoMKgwqAgc3RhdGU6RCBzdGFjazrC
oMKgwqAgMCBwaWQ6MTY5OTIgcHBpZDrCoCA0NTMwCj4+Pj4ga2VybmVsOiBDYWxsIFRyYWNlOgo+
Pj4+IGtlcm5lbDrCoCBfX3NjaGVkdWxlKzB4MmZkLzB4NzUwCj4+Pj4ga2VybmVsOsKgID8gdHJ5
X3RvX3dha2VfdXArMHgxN2IvMHg0ZTAKPj4+PiBrZXJuZWw6wqAgc2NoZWR1bGUrMHgyZi8weGEw
Cj4+Pj4ga2VybmVsOsKgIHNjaGVkdWxlX3RpbWVvdXQrMHgxY2MvMHgzMTAKPj4+PiBrZXJuZWw6
wqAgPyBfX3dha2VfdXBfY29tbW9uKzB4NzQvMHgxMjAKPj4+PiBrZXJuZWw6wqAgd2FpdF9mb3Jf
Y29tcGxldGlvbisweGJhLzB4MTQwCj4+Pj4ga2VybmVsOsKgID8gd2FrZV91cF9xKzB4YTAvMHhh
MAo+Pj4+IGtlcm5lbDrCoCBfX29jZnMyX2NsdXN0ZXJfbG9jay5pc3JhLjQxKzB4M2I1LzB4ODIw
IFtvY2ZzMl0KPj4+PiBrZXJuZWw6wqAgPyBvY2ZzMl9pbm9kZV9sb2NrX2Z1bGxfbmVzdGVkKzB4
MWZjLzB4OTYwIFtvY2ZzMl0KPj4+PiBrZXJuZWw6wqAgb2NmczJfaW5vZGVfbG9ja19mdWxsX25l
c3RlZCsweDFmYy8weDk2MCBbb2NmczJdCj4+Pj4ga2VybmVsOsKgIG9jZnMyX2luaXRfc2VjdXJp
dHlfYW5kX2FjbCsweGJlLzB4MWQwIFtvY2ZzMl0KPj4+PiBrZXJuZWw6wqAgb2NmczJfcmVmbGlu
aysweDQzNi8weDRjMCBbb2NmczJdCj4+Pj4ga2VybmVsOsKgID8gb2NmczJfcmVmbGlua19pb2N0
bCsweDJjYS8weDM2MCBbb2NmczJdCj4+Pj4ga2VybmVsOsKgIG9jZnMyX3JlZmxpbmtfaW9jdGwr
MHgyY2EvMHgzNjAgW29jZnMyXQo+Pj4+IGtlcm5lbDrCoCBvY2ZzMl9pb2N0bCsweDI1ZS8weDY3
MCBbb2NmczJdCj4+Pj4ga2VybmVsOsKgIGRvX3Zmc19pb2N0bCsweGEwLzB4NjgwCj4+Pj4ga2Vy
bmVsOsKgIGtzeXNfaW9jdGwrMHg3MC8weDgwCj4+Pj4KPj4+PiBJbiBmYWN0LCB0aGUgZGVzdGlu
YXRpb24gZGlyZWN0b3J5KC5zbmFwc2hvdHMpIGlub2RlIGRsbSBsb2NrIHdhcyBhY3F1aXJlZCBi
eSBnaGUtc2xlMTVzcDItbmQyLCBuZXh0IHRoZXJlIGlzIGJhc3QgbWVzc2FnZSBmcm9tIG90aGVy
IG5vZGVzIHRvIGFzayBnaGUtc2xlMTVzcDItbmQyIGRvd25jb252ZXJ0IGxvY2ssIGJ1dCB0aGUg
b3BlcmF0aW9uIGZhaWxlZCwgdGhlIGtlcm5lbCBtZXNzYWdlIGlzIHByaW50ZWQgbGlrZSwKPj4+
PiBrZXJuZWw6IChvY2ZzMmRjLUFBMzVERDksMjU2MCwzKTpvY2ZzMl9kb3duY29udmVydF9sb2Nr
OjM2NjAgRVJST1I6IERMTSBlcnJvciAtMTYgd2hpbGUgY2FsbGluZyBvY2ZzMl9kbG1fbG9jayBv
biByZXNvdXJjZSBNMDAwMDAwMDAwMDAwMDAwMDA0NmUwMjAwMDAwMDAwCj4+Pj4ga2VybmVsOiAo
b2NmczJkYy1BQTM1REQ5LDI1NjAsMyk6b2NmczJfdW5ibG9ja19sb2NrOjM5MDQgRVJST1I6IHN0
YXR1cyA9IC0xNgo+Pj4+IGtlcm5lbDogKG9jZnMyZGMtQUEzNUREOSwyNTYwLDMpOm9jZnMyX3By
b2Nlc3NfYmxvY2tlZF9sb2NrOjQzMDMgRVJST1I6IHN0YXR1cyA9IC0xNgo+Pj4+Cj4+Pj4gVGhl
biwgdGhlIHJlZmxpbmsgcHJvY2VzcyB0cmllcyB0byBhY3F1aXJlIHRoaXMgZGlyZWN0b3J5IGlu
b2RlIGRsbSBsb2NrLCB0aGUgcHJvY2VzcyBpcyBibG9ja2VkLCB0aGUgZGxtIGxvY2sgcmVzb3Vy
Y2UgaW4gbWVtb3J5IGxvb2tzIGxpa2UKPj4+Pgo+Pj4+ICDCoMKgwqDCoCBsX25hbWUgPSAiTTAw
MDAwMDAwMDAwMDAwMDAwNDZlMDIwMDAwMDAwMCIsCj4+Pj4gIMKgwqDCoMKgIGxfcm9faG9sZGVy
cyA9IDAsCj4+Pj4gIMKgwqDCoMKgIGxfZXhfaG9sZGVycyA9IDAsCj4+Pj4gIMKgwqDCoMKgIGxf
bGV2ZWwgPSA1ICdcMDA1JywKPj4+PiAgwqDCoMKgwqAgbF9yZXF1ZXN0ZWQgPSAwICdcMDAwJywK
Pj4+PiAgwqDCoMKgwqAgbF9ibG9ja2luZyA9IDUgJ1wwMDUnLAo+Pj4+ICDCoMKgwqDCoCBsX3R5
cGUgPSAwICdcMDAwJywKPj4+PiAgwqDCoMKgwqAgbF9hY3Rpb24gPSAwICdcMDAwJywKPj4+PiAg
wqDCoMKgwqAgbF91bmxvY2tfYWN0aW9uID0gMCAnXDAwMCcsCj4+Pj4gIMKgwqDCoMKgIGxfcGVu
ZGluZ19nZW4gPSA2NDU5NDgsCj4+Pj4KPj4+Pgo+Pj4+IFNvIGZhciwgSSBkbyBub3Qga25vdyB3
aGF0IG1ha2VzIGRsbSBsb2NrIGZ1bmN0aW9uIGZhaWxlZCwgaXQgYWxzbyBsb29rcyB3ZSBkbyBu
b3QgaGFuZGxlIHRoaXMgZmFpbHVyZSBjYXNlIGluIGRsbWdsdWUgbGF5ZXIsIGJ1dCBJIGFsd2F5
cyByZXByb2R1Y2UgdGhpcyBoYW5nIHdpdGggbXkgdGVzdCBzY3JpcHQsIGUuZy4KPj4+Pgo+Pj4+
ICDCoMKgIGxvb3A9MQo+Pj4+ICDCoMKgIHdoaWxlICgobG9vcCsrKSkgOyBkbwo+Pj4+ICDCoMKg
wqDCoMKgwqDCoMKgIGZvciBpIGluIGBzZXEgMSAxMDBgOyBkbwo+Pj4+ICDCoMKgwqDCoMKgwqDC
oMKgwqDCoCByZWZsaW5rICIvbW50L3NoYXJlZC90ZXN0IiAiL21udC9zaGFyZWQvLnNuYXBzaG90
cyAvdGVzdC4ke2xvb3B9LiR7aX0uYGRhdGUgKyVtJWQlSCVNJVNgLmBob3N0bmFtZWAiCj4+Pj4g
IMKgwqDCoMKgwqDCoMKgwqAgZG9uZQo+Pj4+ICDCoMKgwqDCoMKgwqDCoMKgIHVzbGVlcCA1MDAw
MDAKPj4+PiAgwqDCoMKgwqDCoMKgwqDCoCBybSAtZiAvbW50L3NoYXJlZC8uc25hcHNob3RzL3Rl
c3Rub2RlMS5xY293Mi4qLmBob3N0bmFtZWAKPj4+PiAgwqDCoCBkb25lCj4+Pj4KPj4+PiBNeSBw
YXRjaCBjaGFuZ2VzIG11bHRpcGxlIGFjcXVpcmluZyBkZXN0IGRpcmVjdG9yeSBpbm9kZSBkbG0g
bG9jayBkdXJpbmcgaW4gb2NmczJfcmVmbGluayBmdW5jdGlvbiwgaXQgYXZvaWRzIHRoZSBoYW5n
IGlzc3VlIGhhcHBlbiBhZ2Fpbi5UaGUgY29kZSBjaGFuZ2UgYWxzbyBjYW4gaW1wcm92ZSByZWZs
aW5rIHBlcmZvcm1hbmNlIGluIHRoaXMgY2FzZS4KPj4+Pgo+Pj4+IFRoYW5rcwo+Pj4+IEdhbmcK
Pj4+Cj4+PiAnc3RhdHVzID0gLTE2JyBpbXBsaWVzIERMTV9DQU5DRUxHUkFOVC4KPj4+IERvIHlv
dSB1c2Ugc3RhY2sgdXNlciBpbnN0ZWFkIG9mIG8yY2I/IElmIHllcywgY2FuIHlvdSB0cnkgbzJj
YiB3aXRoCj4+PiB5b3VyIHJlcHJvZHVjZXI/Cj4+Cj4+IEkgc2V0dXAgbzJjYiBiYXNlZCBvY2Zz
MiBjbHVzdGVycyB3aXRoIHNsZTE1c3AyIGFuZCBvcmFjbGVMaW51eDh1NC4KPj4gQWZ0ZXIgdHdv
IGRheSB0ZXN0aW5nIHdpdGggdGhlIHNhbWUgc2NyaXB0LCBJIGRpZCBub3QgZW5jb3VudGVyIGRs
bV9sb2NrIGRvd25jb252ZXJ0IGZhaWx1cmUsIHRoZSBoYW5nIGlzc3VlIGRpZCBub3QgaGFwcGVu
Lgo+PiBBZnRlciBteSBwYXRjaCB3YXMgYXBwbGllZCwgdGhlcmUgd2FzIG5vdCBhbnkgc2lkZSBl
ZmZlY3QsIHRoZSByZWZsaW5rIHBlcmZvcm1hbmNlIHdhcyBkb3VibGVkIGluIHRoZSBjYXNlLgo+
Pgo+IAo+IERvIHlvdSBtZWFuIHRoZSBoYW5nIG9ubHkgaGFwcGVucyBvbiBzdGFjayB1c2VyPwpZ
ZXMuCldoeT8gc2luY2UgbzJjYiBiYXNlZCBkbG1fbG9jayBkaWQgbm90IHJldHVybiBlcnJvciAt
MTYgd2hlbiBkb3duY292ZXJ0IApkbG0gbG9jayBkdXJpbmcgdGhlIHdob2xlIHRlc3RpbmcuCkJ1
dCBwbWNrIGJhc2VkIGRsbV9sb2NrIHJldHVuZWQgZXJyb3IgLTE2IGR1cmluZyB0aGUgdGVzdGlu
ZywgdGhlbiB3ZSAKZGlkIG5vdCBoYW5kbGUgdGhpcyBlcnJvciBmdXJ0aGVyIGluIGRsbWdsdWUg
bGF5ZXIsIG5leHQgZW5jb3VudGVyIHRoZSAKaGFuZyBpc3N1ZSB3aGVuIGRsbV9sb2NrIGFjcXVp
cmUgdGhlIGxvY2suIE1heWJlIHRoZXJlIGlzIGEgcmFjZSAKY29uZGl0aW9uIHdoZW4gdXNpbmcg
ZGxtX2xvY2svZGxtX3VubG9jayhjYW5jZWwpIGluIGRsbWdsdWUgbGF5ZXIuCkFueXdheSwgdGhl
IHByb2JsZW0gYmVsb25ncyB0byBvY2ZzMiBvd24gcGFydHMuCgo+IElNTywgd2UnZCBiZXR0ZXIg
ZGlyZWN0bHkgZml4IHRoZSBzdGFjayB1c2VyIGhhbmcgZmlyc3QsIGFuZCB0aGVuIG9wdGltaXpl
Cj4gcmVmbGluayBwZXJmb3JtYW5jZS4KQmVmb3JlIHdlIGZpeCB0aGUgcG90ZW50aWFsIHByb2Js
ZW0gaW4gZGxtZ2x1ZSBsYXllciwgSSBzdWdnZXN0IHRvIAphY2NlcHQgdGhpcyBwYXRjaCBmaXJz
dC4gU2luY2UgdGhlIGRsbWdsdWUgbGF5ZXIgY29kZSBpcyBraW5kIG9mIApjb21wbGlhbnQsIHdl
IG5lZWQgdG8gY2FyZWZ1bGx5IG1vZGlmeSB0aGlzIHBhcnQgb2YgdGhlIGNvZGUuIEJ1dCB0aGlz
IApwYXRjaCBjYW4gd29ya2Fyb3VuZCBkbG1fbG9jayBmYWlsdXJlKC0xNikgcHJvYmxlbSBmb3Ig
cGNtayBzdGFjaywgCm1lYW53aGlsZSwgaXQgYWxzbyBjYW4gaW1wcm92ZSB0aGUgcGVyZm9ybWFu
Y2UuCgpUaGFua3MKR2FuZwoKCj4gCj4gVGhhbmtzLAo+IEpvc2VwaAo+IAoKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcg
bGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21h
aWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
