Return-Path: <SRS0=MDmv=HD=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3138FC433E0
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 Feb 2021 03:43:41 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8DBF960231
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 Feb 2021 03:43:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DBF960231
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1113TsfK109428;
	Mon, 1 Feb 2021 03:43:39 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 36cydkk81u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Feb 2021 03:43:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1113U5se098098;
	Mon, 1 Feb 2021 03:43:38 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36dh7p4q0t-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 01 Feb 2021 03:43:38 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l6Q7l-0003Qt-4l; Sun, 31 Jan 2021 19:43:37 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1l6Q7H-0003Pv-TO
	for ocfs2-devel@oss.oracle.com; Sun, 31 Jan 2021 19:43:07 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1113VOCa076557
	for <ocfs2-devel@oss.oracle.com>; Mon, 1 Feb 2021 03:43:07 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3030.oracle.com with ESMTP id 36dh1ktp5q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 01 Feb 2021 03:43:07 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1113Ye5W017933
	for <ocfs2-devel@oss.oracle.com>; Mon, 1 Feb 2021 03:43:06 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102])
	by userp2030.oracle.com with ESMTP id 36dut9qweh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 01 Feb 2021 03:43:06 +0000
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur01lp2057.outbound.protection.outlook.com [104.47.1.57])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-26-rFwxXWC4M_mnD-Br50YL9w-1; Mon, 01 Feb 2021 04:43:02 +0100
X-MC-Unique: rFwxXWC4M_mnD-Br50YL9w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=HJH8CFPYZCthScuXoFaEQUygKCWsO6TkAlpwoYKERpR1+E+eFE4N2mJU3rtCIh40NtfznbSKH3DOYWwtqMX0mLoGZuc8AH/8uTPygR8wxs3j2S4ThBe5wEXdH6QLpUYpgt/XsPnVYilx6qGaECJ1Q3muhoQwZjXckHrN3Hyfe4cOlQcBso+K6U7kX5ZTQmsV8HBQUHeEGDK8ir6zSy5NcVTJROU6h4PMEoiw4s/K+1z8vnOF18jkZ+flOJ5RntkZCwkuibk03aI2ARxpvW9PfM1L7M9HYeNbv1EFVMqnsujOAwbAjE9KtW/xYpLJKYU7qwBWgbmF6NFvbYq7tbSS+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=A071KD7zF6R+9T7f/IB8eOELJS6t5J1Zj4d+F5jfWyE=;
	b=N+zSHzy7flpIkbXGfgAQpb69WcivrDTWuwN/SbDWXsmKcNd1MSHpnvM+VkWzO4WDhIvXDrXPH+lXfCB2j0uXw8uVrD1FHb/mVOQN0Tk6c137zfCtSvvaDz7bXq0wZTGKag0CFnDF+qFFn3ZEfT1NNoYffG2q7ltNuNgd/Q7LkbP2rNjdfL4MAcMANoJd1nyPK/FXr5LxmkH7d5rrj7r/qyb2/FBdBp70RUfW6T5Rctgd62xyXJX8VKtYsslQ5PLasADuhzsKZHj7Gvmmq859xJ81LNjrHXeLqOjrLaam/zRaDVWzpLVrX6A/w4iiMCWJcgaJuAdoj9f24a/NCnAm2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=suse.com; 
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21)
	by AM6PR04MB5432.eurprd04.prod.outlook.com (2603:10a6:20b:93::33)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19;
	Mon, 1 Feb 2021 03:43:00 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::9481:476f:7337:5da6]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::9481:476f:7337:5da6%6]) with mapi id 15.20.3805.024;
	Mon, 1 Feb 2021 03:43:00 +0000
To: ocfs2-devel@oss.oracle.com
References: <AM6PR04MB6488440A41759D9FF9A3C5A6CFB99@AM6PR04MB6488.eurprd04.prod.outlook.com>
	<3E55B25E-76CC-4FFE-BF98-0637BCB4D9CC@ORACLE.COM>
	<ce23a917-0cb1-065a-59b1-3e4789fb0d79@suse.com>
	<e0d299d1-21f1-0738-ff73-7cc3031cd581@oracle.com>
From: Gang He <ghe@suse.com>
Message-ID: <34a041e3-1db5-d8fe-f683-08978f23ebf9@suse.com>
Date: Mon, 1 Feb 2021 11:42:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
In-Reply-To: <e0d299d1-21f1-0738-ff73-7cc3031cd581@oracle.com>
Content-Language: en-US
X-Originating-IP: [111.205.14.62]
X-ClientProxiedBy: HK2PR02CA0171.apcprd02.prod.outlook.com
	(2603:1096:201:1f::31) To AM6PR04MB6488.eurprd04.prod.outlook.com
	(2603:10a6:20b:f8::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.105] (111.205.14.62) by
	HK2PR02CA0171.apcprd02.prod.outlook.com (2603:1096:201:1f::31)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17
	via Frontend Transport; Mon, 1 Feb 2021 03:42:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76960d2c-92e2-495c-bfea-08d8c66378ab
X-MS-TrafficTypeDiagnostic: AM6PR04MB5432:
X-Microsoft-Antispam-PRVS: <AM6PR04MB5432C96795526E78C30195E8CFB69@AM6PR04MB5432.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tr6nW22QAXOpvUJ6YL829SFAHbK7GldzTU6C13wWq9EI+YZtqAPuuwDDa+7lfM6kZFsFPPyLisl9t3zVkw+OShcMMIzb3qfCyNnw2UqXv7bmRSnpXnouIT/5wPoRLObrGcEySr7IuhNECGrh+Of7PWJteL3JhKHJ4kMuQzlRAnb0uqHyObyFj8FHwQiQcRsK9QOLOfIbbPR7RCbehtLwz/Ttdz9rJSdVSpw1yvFEGwyHlwUAoVivBL+zQKigXO2ltQjISW44EDhtqrKhhwiZWEwNtRwpv/mpFGRp4Z4GsMOdqcATx/cTMRe3bMU9aMlFjbAsSkP/Iiv48AP+89KT/mUxsJJW+xDK2G2GTDzv2QErxudCjfEgilCvFxJszyP9ei4B3poz2txQq2GgPKCg8c6HCIzXijVZLypIG+wF2e6PLD12xMqYd3A5/REFzY5fm/Ha688GNhZ2F7XGVqR8XDG2Q5EH3XOKEnkfptqWvgaDFpexEXiSPPGpj2Z51S39ebXPFq8N9if4JPrjz1T31+CMDj3RdWlRqunKG1xn51jBE29nzkWf9v7e0uS5vXtAy7oay9lR7Cw5sxC83cC11iXRQ3QBbyt9KXP4b04uCLg5BH/Ylunt073AP0nNt4+r4qTwjMZa5+8hmD9c35ZVYFjJOGBCLDvC1trhrK13/bFl7uo6blLL81RtZ46BRFIgJBvmSfYzFa+WUs4nsXWSNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(396003)(376002)(366004)(39860400002)(136003)(346002)(478600001)(36756003)(2906002)(966005)(16526019)(31686004)(86362001)(6486002)(8936002)(53546011)(66946007)(66476007)(66556008)(26005)(186003)(5660300002)(83380400001)(6666004)(316002)(8676002)(52116002)(16576012)(31696002)(6916009)(2616005)(956004)(13296008)(43740500002)(45980500001);
	DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?v8A1aAYRn2KL3yz2KTEA5GoBdOnFah5YqkPYdtsRPTbgxbr/CBPE5hMPDOTU?=
	=?us-ascii?Q?nuWcoNvFEDVnKDX/iYF4BgSBzzm6TVCLTTYPWpMCjAL1/f3LscGazfwQcurT?=
	=?us-ascii?Q?NqzGmPIIHV44hHWkznwD4e0GvlDRrO6gK2d58egXP78sSJd7oy5+ZK7OIQWT?=
	=?us-ascii?Q?yLVKcZ1CyhNFy7czOSVAH73diV0H2BUO1UILWIqjJzm0jLXfxxYmxyoZOv2u?=
	=?us-ascii?Q?b5KZ+9DunxlY/t10e7q0lran4dNQnTta/xoB+OkEOrPNwyLnuKDC1+40GwVN?=
	=?us-ascii?Q?iWSp1Z8p1O1X7ScpYS5dDamZPsGMGvyDYJDyij/AhTGfRNwM9rDzFxm+wQES?=
	=?us-ascii?Q?IPVuz1tUMvToxxDh7fFAD8V7cWQanyR/tkH2j/dx5UwousMTjqLisll5I3e1?=
	=?us-ascii?Q?lq4PNXgNHjEoq4pYvgPgeIL12oqeeJ8LQaQn9/5C2BV2IT09qj4BFLchNphc?=
	=?us-ascii?Q?gF6VmLcoRV0sr60VMSjCyWcU1G5krG3WB7iGvjR5nI0vKA0T2F3Hxrn21fk9?=
	=?us-ascii?Q?7WgHZre5UfldjhqU/M7szsVdlh3o5M7iR+FHrwYqU350WtDVBQRwKFGbQHMo?=
	=?us-ascii?Q?/Orhn1srtgWxfivQzZprDnuzmrTpYwTUGRYhbRJZuaXeAK5H9M4+lhyXC8h/?=
	=?us-ascii?Q?GDCGUsAz87c6aySXs99pW7EHcIxxH9CruXmJBIs3+qP/86oNCIKpekuxZluM?=
	=?us-ascii?Q?NPa/NXL7+GNUwOVd0GFmrlfP9Nuu7mlY+HvaV5dDSfjSNiAVgmdNuwv2oYm6?=
	=?us-ascii?Q?+t1eLVlcIPGUZih7i67oa2Jad467O7steh0EDUf5WoSvnjv0LdshP4PYCmKy?=
	=?us-ascii?Q?SUGanlYICeEhVODy1m72V1IShtRSlgQa8nO6olRjv9OLUF/2O0gfox24hX16?=
	=?us-ascii?Q?JudGigX8KJS4t9N9764Ug0h29PcNcB26lV+K1pVSGEp66laXzsFBIhemr3zJ?=
	=?us-ascii?Q?tlmvu7jdQHH4i8hkAVsP5yCatl1qLkPhpOzVzcfg6y09YH+QtjOl7d0ov2X3?=
	=?us-ascii?Q?aFem4i22Kasa3Mj8j8OlOcVjlQZGEQtK2zmK/T1QbCmSCovgD8K0hRZs5xyy?=
	=?us-ascii?Q?2CQJB6ks?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76960d2c-92e2-495c-bfea-08d8c66378ab
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2021 03:43:00.2888 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jWbTWaiajha/weu3YqFdoDAkaxyb1Hd27RD6QEKFSReboahI8RGL+H+XodPc+LZ2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5432
X-PDR: PASS
X-Source-IP: 62.140.7.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9881
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	impostorscore=0
	phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0
	lowpriorityscore=0 clxscore=233 malwarescore=0 spamscore=0
	priorityscore=48 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102010016
X-Spam: Clean
Subject: Re: [Ocfs2-devel] About the status of reflink-tools
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9881 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010016
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9881 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010016

SGkgV2VuZ2FuZywKClRoYW5rIGZvciB5b3VyIGluZm9ybWF0aW9uLgpBY2NvcmRpbmcgdG8gRGFy
cmljaydzIG1haWwsIHRoZSByZWZsaW5rIHJlbGF0ZWQgdG9vbHMgaGF2ZSBiZWVuIG1lcmdlZCAK
aW50byBjb3JldXRpbHMgcHJvamVjdCwgdGhhdCBtZWFucyB3ZSBjYW4gZm9yZ2V0IHJlZmxpbmst
dG9vbHMgcHJvamVjdC4KClRoYW5rcwpHYW5nCgpPbiAyMDIxLzEvMzAgMjozNCwgV2VuZ2FuZyBX
YW5nIHdyb3RlOgo+IAo+IE9uIDEvMjgvMjEgMTE6NDYgUE0sIEdhbmcgSGUgd3JvdGU6Cj4+IEhp
IEhlcmJlcnQsCj4+Cj4+Cj4+IE9uIDIwMjEvMS8yOSAxNTozMywgSGVyYmVydCBWYW4gRGVuIEJl
cmdoIHdyb3RlOgo+Pj4gSGkgR2FuZywKPj4+Cj4+PiBUaGUgcmVmbGluayBmdW5jdGlvbmFsaXR5
IGhhcyBiZWVuIG1lcmdlZCBpbnRvIHRoZSBjb3JldXRpbHMgcGFja2FnZS9wcm9qZWN0LiBUaGUg
Y3AgY29tbWFuZCBub3cgaGFzIGEg4oCUcmVmbGluayBvcHRpb24uIENoZWNrIGl0IG91dC4gSWYg
dGhpcyBpc27igJl0IHdoYXQgeW914oCZcmUgbG9va2luZyBmb3IsIHRoZW4gcGxlYXNlIGVsYWJv
cmF0ZS4KPj4gRm9yIHRoZSBvdGhlciB0b29scywgZS5nLiBzaGFyZWQtZHUsIHNoYXJlZC1maWxl
ZnJhZywgd2hlcmUgZG8geW91Cj4+IGRvd25sb2FkIHRoZSByZWxhdGVkIHNvdXJjZSBjb2RlPyBz
dGlsbCBjb3JldXRpbHM/IHRoYXQgbWVhbnMgdGhpcyBwYXJ0Cj4+IGNvZGUgaXMgaW5jbHVkZWQv
bWFpbnRhaW5lZCBieSBjb3JldXRpbHMgcHJvamVjdD8KPj4KPiAgICAgJCBycG0gLXFpIHJlZmxp
bmsKPiAgICAgTmFtZcKgwqDCoMKgwqDCoMKgIDogcmVmbGluawo+ICAgICBWZXJzaW9uwqDCoMKg
wqAgOiAwLjEuMAo+ICAgICBSZWxlYXNlwqDCoMKgwqAgOiAzLmVsNwo+ICAgICBBcmNoaXRlY3R1
cmU6IHg4Nl82NAo+ICAgICBJbnN0YWxsIERhdGU6IE1vbiAyMSBTZXAgMjAyMCAwNTo1Nzo1NiBQ
TSBHTVQKPiAgICAgR3JvdXDCoMKgwqDCoMKgwqAgOiBTeXN0ZW0gRW52aXJvbm1lbnQvS2VybmVs
Cj4gICAgIFNpemXCoMKgwqDCoMKgwqDCoCA6IDU1MDAzCj4gICAgIExpY2Vuc2XCoMKgwqDCoCA6
IEdQTAo+ICAgICBTaWduYXR1cmXCoMKgIDogUlNBL1NIQTI1NiwgU3VuIDA0IE1heSAyMDE0IDA2
OjMzOjAwIEFNIEdNVCwgS2V5IElECj4gICAgIDcyZjk3Yjc0ZWM1NTFmMDMKPiAgICAgU291cmNl
IFJQTcKgIDogcmVmbGluay0wLjEuMC0zLmVsNy5zcmMucnBtCj4gICAgIEJ1aWxkIERhdGXCoCA6
IFN1biAwNCBNYXkgMjAxNCAwNjozMjo1NSBBTSBHTVQKPiAgICAgQnVpbGQgSG9zdMKgIDogY2Et
YnVpbGQ1Ni51cy5vcmFjbGUuY29tCj4gICAgIFJlbG9jYXRpb25zIDogKG5vdCByZWxvY2F0YWJs
ZSkKPiAgICAgUGFja2FnZXLCoMKgwqAgOiBub2JvZHkgPG5vYm9keUBvcmFjbGUuY29tPgo+ICAg
ICBWZW5kb3LCoMKgwqDCoMKgIDogT3JhY2xlCj4gICAgIFVSTMKgwqDCoMKgwqDCoMKgwqAgOiBo
dHRwOi8vb3NzLm9yYWNsZS5jb20vZ2l0Lz9wPWpsYmVjL3JlZmxpbmsuZ2l0O2E9c3VtbWFyeQo+
ICAgICBTdW1tYXJ5wqDCoMKgwqAgOiBUb29sIHRvIGNyZWF0ZSByZWZsaW5rcyBvbiBvY2ZzMi9i
dHJmcy4KPiAgICAgRGVzY3JpcHRpb24gOgo+IAo+ICAgICBUaGUgcmVmbGluayB0b29sIGNyZWF0
ZXMgYSByZWZsaW5rIG9uIGFuIG9jZnMyIG9yIGEgYnRyZnMgZmlsZXN5c3RlbS4KPiAKPiBNYXli
ZSB0aGUgVVJMIHBhcnQgZ2l2ZXMgeW91IHNvbWUgaWRlYS4KPiAKPiBDaGVlcnMsCj4gV2VuZ2Fu
Zwo+IAo+PiBUaGFua3MKPj4gR2FuZwo+Pgo+Pj4gVGhhbmtzLAo+Pj4gSGVyYmVydC4KPj4+Cj4+
Pj4gT24gSmFuIDI4LCAyMDIxLCBhdCA2OjU5IFBNLCBHYW5nIEhlPEdIZUBzdXNlLmNvbT4gIHdy
b3RlOgo+Pj4+Cj4+Pj4gSGkgR3V5cywKPj4+Pgo+Pj4+IFlvdSBrbm93LCBvY2ZzMiByZWZsaW5r
IHJlbGF0ZWQgdXRpbGl0aWVzIHdlcmUgbWFpbnRhaW5lZCBieSBhIHNlcGVyYXRlZCBwcm9qZWN0
IHJlZmxpbmstdG9vbHMsCj4+Pj4gV2hhdCBpcyB0aGlzIHByb2plY3QncyBzdGF0dXM/IGUuZy4g
d2hvIGlzIG1haW50YWluaW5nIGl0LCB3aGVyZSBjYW4gd2UgZG93bmxvYWQgdGhlIGxhdGVzdCBz
b3VyY2UgY29kZT8KPj4+Pgo+Pj4+Cj4+Pj4gVGhhbmtzCj4+Pj4gR2FuZwo+Pj4+Cj4+Pj4gX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KPj4+PiBPY2ZzMi1k
ZXZlbCBtYWlsaW5nIGxpc3QKPj4+PiBPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQo+Pj4+IGh0
dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbAo+PiBfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwo+PiBPY2ZzMi1kZXZl
bCBtYWlsaW5nIGxpc3QKPj4gT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KPj4gaHR0cHM6Ly9v
c3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVsCj4gCj4gX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KPiBPY2ZzMi1kZXZlbCBtYWls
aW5nIGxpc3QKPiBPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQo+IGh0dHBzOi8vb3NzLm9yYWNs
ZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbAo+IAoKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApP
Y2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4v
bGlzdGluZm8vb2NmczItZGV2ZWw=
