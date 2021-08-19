Return-Path: <SRS0=eOWJ=NK=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F59C432BE
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 Aug 2021 06:32:25 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D8D8D610CF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 Aug 2021 06:32:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D8D8D610CF
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17J6WNvn013918;
	Thu, 19 Aug 2021 06:32:24 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3agu24jxxt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Aug 2021 06:32:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17J6V88O023054;
	Thu, 19 Aug 2021 06:32:13 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3ae2y3rm7s-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 19 Aug 2021 06:32:13 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mGbaw-0007Ko-Vq; Wed, 18 Aug 2021 23:32:06 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1mGbaq-0007KK-Fy
	for ocfs2-devel@oss.oracle.com; Wed, 18 Aug 2021 23:32:00 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17J6V7aO158319
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 06:32:00 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3aeqkxtx2y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 06:31:54 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	17J6RaNo007986
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 06:31:53 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102])
	by mx0b-00069f01.pphosted.com with ESMTP id 3ah6vne6fx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 19 Aug 2021 06:31:53 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur01lp2055.outbound.protection.outlook.com [104.47.2.55])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-22-BFRLM51iNAuSdXxmDWggug-1; Thu, 19 Aug 2021 08:31:50 +0200
X-MC-Unique: BFRLM51iNAuSdXxmDWggug-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=gveH/yfS61tJaTZlUa20lYsKf5aq8RTkTVjP/M9bB++2AMLrxXVbt8d6V4i5vxPdl4tijkJJq4YuX2bgPbtDU75KTvmqCXqnbYyysknurBn7Y9+1Wy9JZzz54hrfjeiVvvWv6G+T4APJj3wLZtk9JkKzkSFnM3fW3XSgUGR4xi6IH9r3E+vwsWBWyi0FoMhOuXbVHqIObL9SqcCTVTDaxaD/xTqU/hJRzClTAj+G34DiSs342AXH231zQPjWqKmjRENn1YWDgfpinGqn4dizCY4n40mkm1fLxKL5o76H6nVL3E/3CBGooS0Ls83fv/c1tP8K+HrkGPtbPfSsQaqa+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=kLJV0QgvtZh5aOuNO8Qm4aCuyLBV0FiSMgp72g7+A3E=;
	b=P1YHzh0P6NzPx02Y+JGrBPT7H4PduBk4K56Oy2vokWv819x111uqCBIcAUFreskByOx3og4uIjmCwEs+R045Xx8+rOxM06GSEROS4OQBvjFvPxKBrE2gFnsKRZ7jrzOQZGlkHPzYYMFleIT5qPXIqPq3PnxXfV/j+/RV+YxUCSenFhKwaPoxL/nYesdClNv9KXw96f6n53pjfZJ0lGu2alaQApFStLGd5h+etBXm5IFQM+Q5qhsKSYR1MaHKppEBVX13rhp1YxMP1oFTa2CUggUmDksxQIhc9Tg1wZCGCyIWnLTZUD+0ra6lv+Dh6i3mb/POhMbKNOH2tGickDwF+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux-foundation.org; dkim=none (message not signed)
	header.d=none;linux-foundation.org; dmarc=none action=none
	header.from=suse.com;
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21)
	by AM7PR04MB6886.eurprd04.prod.outlook.com (2603:10a6:20b:106::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15;
	Thu, 19 Aug 2021 06:31:48 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71%4]) with mapi id 15.20.4415.024;
	Thu, 19 Aug 2021 06:31:48 +0000
To: Joseph Qi <joseph.qi@linux.alibaba.com>, mark@fasheh.com,
        jlbec@evilplan.org, Wengang Wang <wen.gang.wang@oracle.com>
References: <20210729110230.18983-1-ghe@suse.com>
	<5821fd0f-2018-dc1b-a5c0-f948a7debff4@linux.alibaba.com>
	<c7e1f0a7-e75c-d1e0-870d-dc480d070079@suse.com>
	<71608a14-58f4-dba0-d695-fee65de89192@linux.alibaba.com>
	<801438f5-655a-c708-aa25-343d54a2f11e@suse.com>
	<86e3d724-3147-ccaa-998f-0f857c575f7e@linux.alibaba.com>
	<a0a9710f-461a-99c8-92f6-a99bb11b3a4e@suse.com>
	<4ba3b404-824b-90a3-ef43-9ab6510ee073@linux.alibaba.com>
From: Gang He <ghe@suse.com>
Message-ID: <5a1af56c-3eab-5baf-62a3-1c98bac104ba@suse.com>
Date: Thu, 19 Aug 2021 14:31:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.13.0
In-Reply-To: <4ba3b404-824b-90a3-ef43-9ab6510ee073@linux.alibaba.com>
Content-Language: en-US
X-ClientProxiedBy: HK2PR04CA0065.apcprd04.prod.outlook.com
	(2603:1096:202:14::33) To AM6PR04MB6488.eurprd04.prod.outlook.com
	(2603:10a6:20b:f8::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.67.20.87] (60.251.47.115) by
	HK2PR04CA0065.apcprd04.prod.outlook.com (2603:1096:202:14::33)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19
	via Frontend Transport; Thu, 19 Aug 2021 06:31:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46a6cf74-90fd-424c-3cef-08d962db05ae
X-MS-TrafficTypeDiagnostic: AM7PR04MB6886:
X-Microsoft-Antispam-PRVS: <AM7PR04MB688618AC8FB53317D197130ACFC09@AM7PR04MB6886.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 99WYJmx/6YCbE/AbUQPDD9VV1jtukCN58nXqbDlUg9yEhNCkMj7WrPUjFHUn05QZBw5J5IlRD/VRzGWpLhJXONm33Dttc0DdfjWjexoZoGZAewPSPqWNvQgaNt1M5fVOalr23G4XEPDFH3rrdTt6qH5RiBxn7kEBC70UW3e+zFAV3NiW6MxqGnYGa0Nj1PeDvWvPjW4Riiwrja0Q2Kpal1zpuNcS2QIm3/Y4LavtuaD6LwGdiZ7z5CjctMassB93iLCk1MLAyoU77K+0bneCUY2QwyPYsZJhiebLlcBiNe8e+AeVWuLKbLAGCdaq17xNv7B2DZRMBW1EWGR0dZUpVZABt/TuMKTCVQ2d31hncOI/NrJnRodWdNclXt01sxkx5gYapzxnTdv0QOFvrQDN89a9Wli7vluk/9GNxbMNlud6mrYhRYV+8AYVAknk5NRkcfJ721zA4AUyOwgY9yd6DlIwCurhR3E9pnM6mn8sjKrkI/fve7HdlgGN5EF510n0r9yJjhuvbuZmbfVw4E0F1g71V3410GZR6waoArNKo1c50O+oV0kXcBHOGzqCl8YrA2/temAgOrHiAMezngIRX5mdp1uXj8pmC7/3jIN8Fc21QzIGcB0YrV4DGPGCom+wOIoZR8pAI2xJl5Od+dYlv4z7u8zTq9DXGJHiYDLVFlyKoRatYqmuk+OTWFQGAPvaazlxYYWRJtguySCEYGuKAwsjBhXUUuS7G1qQbl38SGs=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(346002)(376002)(136003)(396003)(39860400002)(366004)(8676002)(6486002)(6666004)(66946007)(16576012)(5660300002)(38100700002)(478600001)(83380400001)(31686004)(8936002)(110136005)(31696002)(26005)(36756003)(316002)(55236004)(2906002)(4326008)(66476007)(53546011)(66556008)(186003)(2616005)(86362001)(956004)(43740500002)(45980500001);
	DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yQT3wWC3QZ6s0K2e/n9388s62N4lq5U2Q+QVt53j0AuWEuqNFiadi9p/jOJh?=
	=?us-ascii?Q?yNA4AnfDPjcHHDta2thygts0tR2eaFNVTLCE8YOlA88ikhalP6MojFrCxpCl?=
	=?us-ascii?Q?nOrL5tKMiWCyq6H6zq1Ry3jvQkloL+BbQXfIDNp8l78h8iuL/2Rkt/zKhjAz?=
	=?us-ascii?Q?VLB5c+0x0l7qgBffTah9rAU51KRDEcgKobYqPA9+9JXVW6wxQSlJF6Ul9XHv?=
	=?us-ascii?Q?0uMjmx8WNsklJ4bU7LxMGomPd9GS8J5xeeCPvRxlG2xdJuyCym8JZ/r84v4P?=
	=?us-ascii?Q?twPHSRZkw6DnAay2LHr95cnlzXWES1KJOT8HopjAbFbU5Bu0rHFD+cKZVG2G?=
	=?us-ascii?Q?ufM0Wsm2OKTUESoR+zHnF2mpjpmGhaWiVkajrIOvF5+6XYSMOktlz57rQVTR?=
	=?us-ascii?Q?C+frmwhYUdSIWiROLm1BnK53RyAuP8nUWwQKiy2X6pwLoK1qRofTBQyAkDSV?=
	=?us-ascii?Q?9UYF5Dyk1vFvzG+8eeuMLdO6EWOQBPX3STe6yKJlgxHZ3ehuSuz49dVtXIhg?=
	=?us-ascii?Q?Xo0FkCglnZasBAfSDz1VSV3p3ASYDLRxDIFiasgV8DdxFKKfqqQkWd1IK0By?=
	=?us-ascii?Q?8Vqy7noulqRiwutyxvl/7jFwzm7mNxkuxoOcQgzP8DyezcSEN5UX1I1dX/vx?=
	=?us-ascii?Q?5MzL/aHY0UpzxawlOuOGO6gINP4vl8565+wP4p/UD1RbSLzWUyus9dfgK9Do?=
	=?us-ascii?Q?pecZpKdCeAJGI0c3/cRf3XoRET86djyLQ7RIpGXz7wrYQJGAhDBU7ttiuwRr?=
	=?us-ascii?Q?FaAV0+9GAQg3rYlK2HtBElgoqz+uZVOZIcGpeTpLhpuitiXTSwlBxSGFLQvc?=
	=?us-ascii?Q?JWbNnUOlJDPXRqarjLcOBasnTPCD1QSm3aDnLhmjLtN/yWLjWz4BAaO7Cqx4?=
	=?us-ascii?Q?btQfWvLWE4ritAcSXe8TUe9el5OFpM6pisXL8xyxUXj5MwjFV5YBFxAqt6A6?=
	=?us-ascii?Q?p131WzrIu/N9DlpvjxzdILgUzPfPGoUDNJRNyc4hJ8BG2RplcShZS17hGRcg?=
	=?us-ascii?Q?Kc5rrUy6Wm7wdrjmEnCFn0jLJlijoS+Uc5QvbH4qbjD2ivkrc6GVN3snnVpj?=
	=?us-ascii?Q?HuF5veZwwxaSPMBy9FjQFPW1hAUGFzmcj7eFtRv6baV/nuUgQ5XdGUIYOXnQ?=
	=?us-ascii?Q?O3PeqyfsQIRLtEEnbkhCbN+GnErgwnWg2lf1I3r/75e79xoABeWkO2eycrNs?=
	=?us-ascii?Q?jKsew4I5BhlGkPa0Xgy1US7yFFrjRCe023wxKjCGOgtSRllSYK0vU2PfPzng?=
	=?us-ascii?Q?XOKLPEClORm7cTlTOvbNLEBvLgxqV13BHED9gbJPN5ACbUb0FofdsL4g6AJH?=
	=?us-ascii?Q?2uY2vJAWmkiHJJ/ydQhH1xRl?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46a6cf74-90fd-424c-3cef-08d962db05ae
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 06:31:48.3509 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eUS1G70GLYHwfOSdFYoLGoYSGxLy3wItqDVv2o/DMJJqclpjEM0Rrkdx7bp48y4+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6886
X-Source-IP: 194.104.111.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10080
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	clxscore=236 bulkscore=0
	mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
	spamscore=0 lowpriorityscore=0 priorityscore=145 impostorscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108190034
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10080
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	bulkscore=0 malwarescore=0
	mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108190034
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108190034
X-Proofpoint-GUID: PRicpz4JxkYlJOB3oVoR7n6Mf6YROMB-
X-Proofpoint-ORIG-GUID: PRicpz4JxkYlJOB3oVoR7n6Mf6YROMB-

CgpPbiAyMDIxLzgvMTkgMTA6MDIsIEpvc2VwaCBRaSB3cm90ZToKPiAKPiAKPiBPbiA4LzE5LzIx
IDk6NTEgQU0sIEdhbmcgSGUgd3JvdGU6Cj4+Cj4+Cj4+IE9uIDIwMjEvOC8xOCAxOToyMCwgSm9z
ZXBoIFFpIHdyb3RlOgo+Pj4KPj4+Cj4+PiBPbiA4LzE4LzIxIDU6MjAgUE0sIEdhbmcgSGUgd3Jv
dGU6Cj4+Pj4KPj4+Pgo+Pj4+IE9uIDIwMjEvOC8xMyAxNzo1NCwgSm9zZXBoIFFpIHdyb3RlOgo+
Pj4+Pgo+Pj4+Pgo+Pj4+PiBPbiA4LzkvMjEgNjowOCBQTSwgR2FuZyBIZSB3cm90ZToKPj4+Pj4+
IEhpIEpvc2VwaCBhbmQgQWxsLAo+Pj4+Pj4KPj4+Pj4+IFRoZSBkZWFkbG9jayBpcyBjYXVzZWQg
Ynkgc2VsZi1sb2NraW5nIG9uIG9uZSBub2RlLgo+Pj4+Pj4gVGhlcmUgaXMgdGhyZWUgbm9kZSBj
bHVzdGVyIChtb3VudGVkIHRvIC9tbnQvc2hhcmVkKSwgdGhlIHVzZXIgcnVuIHJlZmxpbmsgY29t
bWFuZCB0byBjbG9uZSB0aGUgZmlsZSB0byB0aGUgc2FtZSBkaXJlY3RvcnkgcmVwZWF0ZWRseSwK
Pj4+Pj4+IGUuZy4KPj4+Pj4+ICDCoMKgwqByZWZsaW5rICIvbW50L3NoYXJlZC90ZXN0IiBcCj4+
Pj4+PiAgwqDCoMKgIi9tbnQvc2hhcmVkLy5zbmFwc2hvdHMvdGVzdC5gZGF0ZSArJW0lZCVIJU0l
U2AuYGhvc3RuYW1lYCIKPj4+Pj4+Cj4+Pj4+PiBBZnRlciBhIHdoaWxlLCB0aGUgcmVmbGluayBw
cm9jZXNzIG9uIGVhY2ggbm9kZSBpcyBodW5nLCB0aGUgZmlsZSBzeXN0ZW0gY2Fubm90IGJlIGxp
c3RlZC4KPj4+Pj4+IFRoZSBwcm9ibGVtYXRpYyByZWZsaW5rIGNvbW1hbmQgcHJvY2VzcyBpcyBi
bG9ja2VkIGJ5IGl0c2VsZiwgZS5nLiB0aGUgcmVmbGluayBwcm9jZXNzIGlzIGh1bmcgYXQgZ2hl
LXNsZTE1c3AyLW5kMiwKPj4+Pj4+IGtlcm5lbDogdGFzazpyZWZsaW5rwqDCoMKgwqDCoMKgwqDC
oCBzdGF0ZTpEIHN0YWNrOsKgwqDCoCAwIHBpZDoxNjk5MiBwcGlkOsKgIDQ1MzAKPj4+Pj4+IGtl
cm5lbDogQ2FsbCBUcmFjZToKPj4+Pj4+IGtlcm5lbDrCoCBfX3NjaGVkdWxlKzB4MmZkLzB4NzUw
Cj4+Pj4+PiBrZXJuZWw6wqAgPyB0cnlfdG9fd2FrZV91cCsweDE3Yi8weDRlMAo+Pj4+Pj4ga2Vy
bmVsOsKgIHNjaGVkdWxlKzB4MmYvMHhhMAo+Pj4+Pj4ga2VybmVsOsKgIHNjaGVkdWxlX3RpbWVv
dXQrMHgxY2MvMHgzMTAKPj4+Pj4+IGtlcm5lbDrCoCA/IF9fd2FrZV91cF9jb21tb24rMHg3NC8w
eDEyMAo+Pj4+Pj4ga2VybmVsOsKgIHdhaXRfZm9yX2NvbXBsZXRpb24rMHhiYS8weDE0MAo+Pj4+
Pj4ga2VybmVsOsKgID8gd2FrZV91cF9xKzB4YTAvMHhhMAo+Pj4+Pj4ga2VybmVsOsKgIF9fb2Nm
czJfY2x1c3Rlcl9sb2NrLmlzcmEuNDErMHgzYjUvMHg4MjAgW29jZnMyXQo+Pj4+Pj4ga2VybmVs
OsKgID8gb2NmczJfaW5vZGVfbG9ja19mdWxsX25lc3RlZCsweDFmYy8weDk2MCBbb2NmczJdCj4+
Pj4+PiBrZXJuZWw6wqAgb2NmczJfaW5vZGVfbG9ja19mdWxsX25lc3RlZCsweDFmYy8weDk2MCBb
b2NmczJdCj4+Pj4+PiBrZXJuZWw6wqAgb2NmczJfaW5pdF9zZWN1cml0eV9hbmRfYWNsKzB4YmUv
MHgxZDAgW29jZnMyXQo+Pj4+Pj4ga2VybmVsOsKgIG9jZnMyX3JlZmxpbmsrMHg0MzYvMHg0YzAg
W29jZnMyXQo+Pj4+Pj4ga2VybmVsOsKgID8gb2NmczJfcmVmbGlua19pb2N0bCsweDJjYS8weDM2
MCBbb2NmczJdCj4+Pj4+PiBrZXJuZWw6wqAgb2NmczJfcmVmbGlua19pb2N0bCsweDJjYS8weDM2
MCBbb2NmczJdCj4+Pj4+PiBrZXJuZWw6wqAgb2NmczJfaW9jdGwrMHgyNWUvMHg2NzAgW29jZnMy
XQo+Pj4+Pj4ga2VybmVsOsKgIGRvX3Zmc19pb2N0bCsweGEwLzB4NjgwCj4+Pj4+PiBrZXJuZWw6
wqAga3N5c19pb2N0bCsweDcwLzB4ODAKPj4+Pj4+Cj4+Pj4+PiBJbiBmYWN0LCB0aGUgZGVzdGlu
YXRpb24gZGlyZWN0b3J5KC5zbmFwc2hvdHMpIGlub2RlIGRsbSBsb2NrIHdhcyBhY3F1aXJlZCBi
eSBnaGUtc2xlMTVzcDItbmQyLCBuZXh0IHRoZXJlIGlzIGJhc3QgbWVzc2FnZSBmcm9tIG90aGVy
IG5vZGVzIHRvIGFzayBnaGUtc2xlMTVzcDItbmQyIGRvd25jb252ZXJ0IGxvY2ssIGJ1dCB0aGUg
b3BlcmF0aW9uIGZhaWxlZCwgdGhlIGtlcm5lbCBtZXNzYWdlIGlzIHByaW50ZWQgbGlrZSwKPj4+
Pj4+IGtlcm5lbDogKG9jZnMyZGMtQUEzNUREOSwyNTYwLDMpOm9jZnMyX2Rvd25jb252ZXJ0X2xv
Y2s6MzY2MCBFUlJPUjogRExNIGVycm9yIC0xNiB3aGlsZSBjYWxsaW5nIG9jZnMyX2RsbV9sb2Nr
IG9uIHJlc291cmNlIE0wMDAwMDAwMDAwMDAwMDAwMDQ2ZTAyMDAwMDAwMDAKPj4+Pj4+IGtlcm5l
bDogKG9jZnMyZGMtQUEzNUREOSwyNTYwLDMpOm9jZnMyX3VuYmxvY2tfbG9jazozOTA0IEVSUk9S
OiBzdGF0dXMgPSAtMTYKPj4+Pj4+IGtlcm5lbDogKG9jZnMyZGMtQUEzNUREOSwyNTYwLDMpOm9j
ZnMyX3Byb2Nlc3NfYmxvY2tlZF9sb2NrOjQzMDMgRVJST1I6IHN0YXR1cyA9IC0xNgo+Pj4+Pj4K
Pj4+Pj4+IFRoZW4sIHRoZSByZWZsaW5rIHByb2Nlc3MgdHJpZXMgdG8gYWNxdWlyZSB0aGlzIGRp
cmVjdG9yeSBpbm9kZSBkbG0gbG9jaywgdGhlIHByb2Nlc3MgaXMgYmxvY2tlZCwgdGhlIGRsbSBs
b2NrIHJlc291cmNlIGluIG1lbW9yeSBsb29rcyBsaWtlCj4+Pj4+Pgo+Pj4+Pj4gIMKgwqDCoMKg
wqAgbF9uYW1lID0gIk0wMDAwMDAwMDAwMDAwMDAwMDQ2ZTAyMDAwMDAwMDAiLAo+Pj4+Pj4gIMKg
wqDCoMKgwqAgbF9yb19ob2xkZXJzID0gMCwKPj4+Pj4+ICDCoMKgwqDCoMKgIGxfZXhfaG9sZGVy
cyA9IDAsCj4+Pj4+PiAgwqDCoMKgwqDCoCBsX2xldmVsID0gNSAnXDAwNScsCj4+Pj4+PiAgwqDC
oMKgwqDCoCBsX3JlcXVlc3RlZCA9IDAgJ1wwMDAnLAo+Pj4+Pj4gIMKgwqDCoMKgwqAgbF9ibG9j
a2luZyA9IDUgJ1wwMDUnLAo+Pj4+Pj4gIMKgwqDCoMKgwqAgbF90eXBlID0gMCAnXDAwMCcsCj4+
Pj4+PiAgwqDCoMKgwqDCoCBsX2FjdGlvbiA9IDAgJ1wwMDAnLAo+Pj4+Pj4gIMKgwqDCoMKgwqAg
bF91bmxvY2tfYWN0aW9uID0gMCAnXDAwMCcsCj4+Pj4+PiAgwqDCoMKgwqDCoCBsX3BlbmRpbmdf
Z2VuID0gNjQ1OTQ4LAo+Pj4+Pj4KPj4+Pj4+Cj4+Pj4+PiBTbyBmYXIsIEkgZG8gbm90IGtub3cg
d2hhdCBtYWtlcyBkbG0gbG9jayBmdW5jdGlvbiBmYWlsZWQsIGl0IGFsc28gbG9va3Mgd2UgZG8g
bm90IGhhbmRsZSB0aGlzIGZhaWx1cmUgY2FzZSBpbiBkbG1nbHVlIGxheWVyLCBidXQgSSBhbHdh
eXMgcmVwcm9kdWNlIHRoaXMgaGFuZyB3aXRoIG15IHRlc3Qgc2NyaXB0LCBlLmcuCj4+Pj4+Pgo+
Pj4+Pj4gIMKgwqDCoCBsb29wPTEKPj4+Pj4+ICDCoMKgwqAgd2hpbGUgKChsb29wKyspKSA7IGRv
Cj4+Pj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKgIGZvciBpIGluIGBzZXEgMSAxMDBgOyBkbwo+Pj4+
Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmVmbGluayAiL21udC9zaGFyZWQvdGVzdCIgIi9t
bnQvc2hhcmVkLy5zbmFwc2hvdHMgL3Rlc3QuJHtsb29wfS4ke2l9LmBkYXRlICslbSVkJUglTSVT
YC5gaG9zdG5hbWVgIgo+Pj4+Pj4gIMKgwqDCoMKgwqDCoMKgwqDCoCBkb25lCj4+Pj4+PiAgwqDC
oMKgwqDCoMKgwqDCoMKgIHVzbGVlcCA1MDAwMDAKPj4+Pj4+ICDCoMKgwqDCoMKgwqDCoMKgwqAg
cm0gLWYgL21udC9zaGFyZWQvLnNuYXBzaG90cy90ZXN0bm9kZTEucWNvdzIuKi5gaG9zdG5hbWVg
Cj4+Pj4+PiAgwqDCoMKgIGRvbmUKPj4+Pj4+Cj4+Pj4+PiBNeSBwYXRjaCBjaGFuZ2VzIG11bHRp
cGxlIGFjcXVpcmluZyBkZXN0IGRpcmVjdG9yeSBpbm9kZSBkbG0gbG9jayBkdXJpbmcgaW4gb2Nm
czJfcmVmbGluayBmdW5jdGlvbiwgaXQgYXZvaWRzIHRoZSBoYW5nIGlzc3VlIGhhcHBlbiBhZ2Fp
bi5UaGUgY29kZSBjaGFuZ2UgYWxzbyBjYW4gaW1wcm92ZSByZWZsaW5rIHBlcmZvcm1hbmNlIGlu
IHRoaXMgY2FzZS4KPj4+Pj4+Cj4+Pj4+PiBUaGFua3MKPj4+Pj4+IEdhbmcKPj4+Pj4KPj4+Pj4g
J3N0YXR1cyA9IC0xNicgaW1wbGllcyBETE1fQ0FOQ0VMR1JBTlQuCj4+Pj4+IERvIHlvdSB1c2Ug
c3RhY2sgdXNlciBpbnN0ZWFkIG9mIG8yY2I/IElmIHllcywgY2FuIHlvdSB0cnkgbzJjYiB3aXRo
Cj4+Pj4+IHlvdXIgcmVwcm9kdWNlcj8KPj4+Pgo+Pj4+IEkgc2V0dXAgbzJjYiBiYXNlZCBvY2Zz
MiBjbHVzdGVycyB3aXRoIHNsZTE1c3AyIGFuZCBvcmFjbGVMaW51eDh1NC4KPj4+PiBBZnRlciB0
d28gZGF5IHRlc3Rpbmcgd2l0aCB0aGUgc2FtZSBzY3JpcHQsIEkgZGlkIG5vdCBlbmNvdW50ZXIg
ZGxtX2xvY2sgZG93bmNvbnZlcnQgZmFpbHVyZSwgdGhlIGhhbmcgaXNzdWUgZGlkIG5vdCBoYXBw
ZW4uCj4+Pj4gQWZ0ZXIgbXkgcGF0Y2ggd2FzIGFwcGxpZWQsIHRoZXJlIHdhcyBub3QgYW55IHNp
ZGUgZWZmZWN0LCB0aGUgcmVmbGluayBwZXJmb3JtYW5jZSB3YXMgZG91YmxlZCBpbiB0aGUgY2Fz
ZS4KPj4+Pgo+Pj4KPj4+IERvIHlvdSBtZWFuIHRoZSBoYW5nIG9ubHkgaGFwcGVucyBvbiBzdGFj
ayB1c2VyPwo+PiBZZXMuCj4+IFdoeT8gc2luY2UgbzJjYiBiYXNlZCBkbG1fbG9jayBkaWQgbm90
IHJldHVybiBlcnJvciAtMTYgd2hlbiBkb3duY292ZXJ0IGRsbSBsb2NrIGR1cmluZyB0aGUgd2hv
bGUgdGVzdGluZy4KPj4gQnV0IHBtY2sgYmFzZWQgZGxtX2xvY2sgcmV0dW5lZCBlcnJvciAtMTYg
ZHVyaW5nIHRoZSB0ZXN0aW5nLCB0aGVuIHdlIGRpZCBub3QgaGFuZGxlIHRoaXMgZXJyb3IgZnVy
dGhlciBpbiBkbG1nbHVlIGxheWVyLCBuZXh0IGVuY291bnRlciB0aGUgaGFuZyBpc3N1ZSB3aGVu
IGRsbV9sb2NrIGFjcXVpcmUgdGhlIGxvY2suIE1heWJlIHRoZXJlIGlzIGEgcmFjZSBjb25kaXRp
b24gd2hlbiB1c2luZyBkbG1fbG9jay9kbG1fdW5sb2NrKGNhbmNlbCkgaW4gZGxtZ2x1ZSBsYXll
ci4KPj4gQW55d2F5LCB0aGUgcHJvYmxlbSBiZWxvbmdzIHRvIG9jZnMyIG93biBwYXJ0cy4KPj4K
PiBJIG1lYW50IGlmIERMTV9DQU5DRUxHUkFOVCBpcyBub3QgdGhlIGV4cGVjdGVkIHJldHVybiBj
b2RlLCB3ZSdkCj4gYmV0dGVyIGZpeCB0aGUgaXNzdWUgaW4gc3RhY2tfdXNlci5jIGJ1dCBub3Qg
ZGxtZ2x1ZSwgZS5nLiBzb21lIHNwZWNpZmljCj4gd3JhcHBlci4KV2UgY2Fubm90IHdyYXBwZXIo
b3IgaWdub3JlKSB0aGlzIGVycm9yIGluIHN0YWNrX3VzZXIsIG90aGVyd2lzZSBpdCB3aWxsIAps
ZWFkIHRvIGEgaGFuZyBwcm9ibGVtIHdoZW4gdGhlIG5leHQgZGxtX2xvY2sgaXMgaW52b2tlZC4K
QmFzZWQgb24gY29tbWVudHMgZnJvbSBmcy9kbG0gbWFpbnRhaW5lciwgdGhlIGVycm9yIC0xNiBp
cyByZXR1cm5lZCBieSAKZGxtX2xvY2sgaW4gY2FzZSBvY2ZzMiBjYWxscyBkbG1fdW5sb2NrKENB
TkNFTCkgdG8gY2FuY2VsIGFuIGluLXByb2dyZXNzIApkbG1fbG9jaygpIHJlcXVlc3QuCkluIGZh
Y3QsIGlmIHlvdSByZWFkIHRoZSBjb2RlIGNvbW1lbnRzIGluIGRsbWdsdWUuYywgaXQgYWxzbyB0
YWxrZWQgCmFib3V0IHRoZSBzaW1pbGFyIHNpdHVhdGlvbiwgYnV0IEkgZmVlbCB0aGUgY3VycmVu
dCBjb2RlIHNob3VsZCBzdGlsbCAKaGFzIGEgcmFjZSBjb25kaXRpb24sIHRoZW4gdHJpZ2dlciBk
bG1fbG9jayByZXR1cm4gLTE2IGVycm9yLgpGb3IgbzJjYiBzdGFjaywgaXQncyBkbG1fbG9jayBk
aWQgbm90IGV4cG9zZSB0aGlzIGVycm9yLCBtYXliZSBpdCBpcyAKZGlmZmVyZW50IGluIGRsbSBp
bXBsZW1lbnRhdGlvbi4KClRoYW5rcwpHYW5nCgo+IAo+IFRoYW5rcywKPiBKb3NlcGgKPiAKCgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZl
bCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3Jh
Y2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
