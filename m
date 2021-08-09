Return-Path: <SRS0=Syhr=NA=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA223C4338F
	for <ocfs2-devel@archiver.kernel.org>; Mon,  9 Aug 2021 10:08:05 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7F11F6105A
	for <ocfs2-devel@archiver.kernel.org>; Mon,  9 Aug 2021 10:08:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7F11F6105A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 179A7R6U030941;
	Mon, 9 Aug 2021 10:08:04 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aav18gsb0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Aug 2021 10:08:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 179A61vj003177;
	Mon, 9 Aug 2021 10:08:03 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aa3xr1yu7-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 09 Aug 2021 10:08:02 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mD2CP-0002n3-DR; Mon, 09 Aug 2021 03:08:01 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1mD2Bb-0002li-OZ
	for ocfs2-devel@oss.oracle.com; Mon, 09 Aug 2021 03:07:11 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	179A62t7003244
	for <ocfs2-devel@oss.oracle.com>; Mon, 9 Aug 2021 10:07:11 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3020.oracle.com with ESMTP id 3aa3xr1xbb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 09 Aug 2021 10:07:09 +0000
Received: from pps.filterd (m0246575.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	179A4gBC025100
	for <ocfs2-devel@oss.oracle.com>; Mon, 9 Aug 2021 10:07:07 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aavjwuwdm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 09 Aug 2021 10:07:07 +0000
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
	(mail-am5eur03lp2058.outbound.protection.outlook.com [104.47.8.58])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-18-8oo1ZP_ROcKtDPCsOdIC4Q-1; Mon, 09 Aug 2021 12:07:03 +0200
X-MC-Unique: 8oo1ZP_ROcKtDPCsOdIC4Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=atl23CjRpYQRyZ4yfmaywg8qMn3AX5ZBKEcd7aa1wLdhi23Hx7Q9GF0LzA0PkxqViuEO6QtSpG6rT6LKYAxuteDIfFiWMzNRdc2JdUcinOhiafN7NTTdquzVeqluw8JYEa2smhb18pyqSYT94r9HUNzh1ePGzzhw9dvD0gr5zYlj+t/V6c/iEfVd38j/DlbykY25LsjN1ZsYfypY9z7CpegZ0715I61j/tG5YymeJFaC9xyLv88vaUo7ya2biu7Be7qwNamGQjT4Nh2OTLywZb0BECTT2djDYzg1Qa9HvVEo3qBbGMFIK1PAagxPsUgE/BF3R9rvD8HDadsq1oDERQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=6nj0Fl0H/lQ7sJ8TkpE2w7XWaM9hHQrG9ex6225UNSQ=;
	b=WxZtMaVhtLxNHnQ0XVoiXTu8Lt9EEi7TKPpxS+aHULvdYjFzDUgYHBoIKv6A3Lbp1HiST1Gx0jmAcbWrelc2P53HYH6x0rm91hyTYH9B9VT0GPq/mCoHt6IzR0LbvGTSC4PHyPUEB8amve3AhM9/bAwgtIuXrpfY6vPcGb45pMcHCE3K5MXty9nj/8bfFpNJ1veBkN1Ohy7SbETL5m2STXz6tGWW62Q1hleBliFYNNy76KP0IzJyqwzA1gksdOMdQlwZCHTb1vDwjAqaNz5Xpo3KTpESd9DoAnclt3vBW/KsaYs6Pw+QXiKhvGqsQKwhJ1Y+nHTM9dv2lMkfkF0d3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux-foundation.org; dkim=none (message not signed)
	header.d=none;linux-foundation.org; dmarc=none action=none
	header.from=suse.com;
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21)
	by AM5PR0402MB2705.eurprd04.prod.outlook.com (2603:10a6:203:96::16)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16;
	Mon, 9 Aug 2021 10:07:02 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71%4]) with mapi id 15.20.4394.023;
	Mon, 9 Aug 2021 10:07:02 +0000
To: Joseph Qi <joseph.qi@linux.alibaba.com>, mark@fasheh.com,
        jlbec@evilplan.org, Wengang Wang <wen.gang.wang@oracle.com>
References: <20210729110230.18983-1-ghe@suse.com>
	<5821fd0f-2018-dc1b-a5c0-f948a7debff4@linux.alibaba.com>
From: Gang He <ghe@suse.com>
Message-ID: <c7e1f0a7-e75c-d1e0-870d-dc480d070079@suse.com>
Date: Mon, 9 Aug 2021 18:08:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
In-Reply-To: <5821fd0f-2018-dc1b-a5c0-f948a7debff4@linux.alibaba.com>
Content-Language: en-US
X-ClientProxiedBy: HKAPR04CA0014.apcprd04.prod.outlook.com
	(2603:1096:203:d0::24) To AM6PR04MB6488.eurprd04.prod.outlook.com
	(2603:10a6:20b:f8::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.110] (111.202.167.1) by
	HKAPR04CA0014.apcprd04.prod.outlook.com (2603:1096:203:d0::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15
	via Frontend Transport; Mon, 9 Aug 2021 10:06:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af9dd698-dd9f-4d3a-5906-08d95b1d6ea0
X-MS-TrafficTypeDiagnostic: AM5PR0402MB2705:
X-Microsoft-Antispam-PRVS: <AM5PR0402MB2705C56F699EE9162C4078DCCFF69@AM5PR0402MB2705.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5JC3iFaHIdM7hLeOimUmTjl7Mx5T8DJrAzhvPp7eq0KgLgnt4BnrX7zhgNCzWRTyf41USIHf8fYpizYgdoXegcpVHhDZ1y2tirFUc0xZHtOkOiTa/IcycW1yQuzTLwovGbmcJpsMAelYT1up3QTNL1Y2aP21I4ZQ2VDp/zrLOZHGwrCHXLz3uaJWz1btm6ont9LSWOmUIvxVBjkCneS9xIokywYO/VMpaIKhNh1HMdqtOim4+cPzHd/zcG1BOmVo0FEbqFA0giJ+OUSi3xMVGfRF3jNfKdubhw573wxyMcJc5voWfC/8mUyTy9mOHsW9ahj6Amp68zdyvElV9KZZaLCatbI74c00L7Z48EbWBSSTc561v0T9C8vWPEZ4uP1BbpAsEnzq1+TKxDNFsEO8yLmQvmaKQ1BC7PfijKbDkmWtpOhSmeyF7NitDhut+fgoWhdhWohl8UUzZwBFP84qL80ZcU7KxCgnjdL4eXRaon7e2yTngQrNrtZivRDIEB7egThka/WLpAasDfr22dSOCLe0wqQzZ8s88IR43Tl5pww7ygesKk++pxN7JChqL/oEzsmKT/OXQiRfEEbI20UhHPkG7Xmta2gE8LrvHUnxvcyIL0GADy7PB6vUJ+J4HDKAR+EEEaTuFdY1xbNkJH/VKTBV4hu8eztL0DnVRSkOx2bfVBR26BWbpBJ0V0RVlhfKGGlFXzEEljzg5rz3MYJ3V19C+N9p6QEWzmchMK5uwn7wqjPE7+7Avl0JN774VLn9
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(366004)(376002)(346002)(396003)(39850400004)(136003)(66476007)(66556008)(66946007)(4326008)(31686004)(2906002)(5660300002)(8936002)(30864003)(53546011)(8676002)(186003)(478600001)(2616005)(6486002)(6666004)(26005)(16576012)(31696002)(110136005)(38100700002)(83380400001)(956004)(316002)(86362001)(36756003)(13296009)(43740500002)(45980500001);
	DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWdVaW9RSGpNOWVDcTNRazRjejVLSHJnMmxLSm1EalAvWUlWTzlRMFE1L3g1?=
	=?utf-8?B?RHNPcmQ3dXRTazh1MTR0cGZINWkzSWU5Qnh1UkNvc3hCV1l2VDRyNXVXcHRj?=
	=?utf-8?B?VVVJVUg1KzZ2ZXdnMXdJNUlJSzg0OTRWMTZOQWhsY04xZks1dlYva29wU3NX?=
	=?utf-8?B?ZWZBaTd4ZytsV0pwZENoOWVpVHpEc2Z5M3lrbU5nSEswRWY0Q29pdlF0M1hE?=
	=?utf-8?B?U0k0ek5pN0wzN0M0SXBNUHkvcDdManliYmdpK0RqbzJUSXVIVi80Z1E1Z1NB?=
	=?utf-8?B?R0x3eWhhR3hPYkFHd3hEOHA0Mk01Rk1mNlFldWRiaERZNmF3eEl1bkF6YnEx?=
	=?utf-8?B?MGJUeW9taGg4Mk5sYW44L0hOeS9UYVphaTU1Z1pCNjhneGVlS3lHVGtVRDNB?=
	=?utf-8?B?b3ZJZFEvdXF5WXcxYUlEYjEzMThJN3RPWGJ4Mk9YUjk0ODlQcUt0czQwTGRh?=
	=?utf-8?B?QXk2eEJVN0FQajlQWS85OEF0cWlCZ1c1SWttdFJxeVl6U1E2NHFtUFZMOExH?=
	=?utf-8?B?a2JXMDRkMWYzZzFKUm9MeVE2OWhPQ2lQemNESmpBK05YeW1NZUVOa2luQ2JH?=
	=?utf-8?B?dTU0ZlEwTngrWDMwM3FCaW5YcGdtT2huU2JuZmFONGlJT1pJL2ZjM2IxcXpz?=
	=?utf-8?B?MlNlZm1Sc1dxWWNXV2JtcisrbFdZSHdSbUdVOTBUUS81TU43USs5Wi9wckNi?=
	=?utf-8?B?TSs4Uy9WNzd6cjBXM3JoTkV3dTNRcHNMTy8yL3RSSXZienROc0MrZm16RVVR?=
	=?utf-8?B?VFQ1WUkveExKVFlaaEk1Rm11cU9ya04rYm8zUTgxS0hRanNWUjUySk04MEZh?=
	=?utf-8?B?Uk02RFpkWXEyeGZjWVVaRkdjWHZvRTVMdDBqekNaVUZvSDNNV0szKzBVOXYw?=
	=?utf-8?B?a296djRaakd5VHViZW5DeHB3L251SUVGM1FNOWlJWnFKbTlhOTZzU0JBcGJh?=
	=?utf-8?B?RlE4c1hFNGxzY1RsK3F2c0hxU1NzNkVYMjROVVRQamdGb3hEU2RsZmpmTWNp?=
	=?utf-8?B?d2NKVzBZVmNvMGNRWVVpemhtMGFlVDljZmRxdEltYTNOV3Izb3Q5WFg3blZa?=
	=?utf-8?B?RXM0Tyt4RDUxdEVPbmhrTlBiTy92VExIblQyR01SbFR3RUo0Q2paRXhXOHpy?=
	=?utf-8?B?d3o4d0gwdkJteWhBZXZtRG9uWkcyU21xYjA4dFhYTTJNME1Wb05vU050bDBE?=
	=?utf-8?B?VTdGbGJDSFFwK1pqMUM4MnpNdDRMTGJxQVNlbUNwd1htUWRRWGpQRjNvdGxE?=
	=?utf-8?B?ekY4S1Yzak1lQzlnMEpmZGRGVHhmallwSmNpaC9FTlN6aU0wdzVFWmdKMEd3?=
	=?utf-8?B?bVpZN2svMHVuTmFCWEhrRllaSU9VWmtRelZaMkN5aEZrU3NzUzV0bFRUb1NU?=
	=?utf-8?B?MXcxclZqOEV3c0hFbnE2ZFBiUFY0TmZvNzdMVU8wRng3VXJ4emxoS0ZpQjNC?=
	=?utf-8?B?SEJwTENjZGlwdDV3SVc2N1lCclc0UVFEZnRUdURmSnoxcGhOL2todWt2cVVy?=
	=?utf-8?B?enlPdDRZWUEyZzVhTFNBaFJMTTVyOFpPVmgwbXJsdGQ0dnF3RERRMDg1NmpE?=
	=?utf-8?B?QW9KSjRyVkY4MDVWWi9naTJQenl1TUFXZUxGK2czREFFU0pSOTlFTzRNU1Jn?=
	=?utf-8?B?K0FzSEVNeEx6ZUcrWmhsblBQSnJyZHFkMllrek1ENHkySW13YVhDZkpEUFNj?=
	=?utf-8?B?U2dscUw1Ny84eWd3UUJkT1JmeE0rTTJyYmxpd1lKUXh1OG84aFppY2RXN0ZL?=
	=?utf-8?Q?VUhtt++VeMmpvblqe4xKUlvOkjHvbFrDmXthsPN?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af9dd698-dd9f-4d3a-5906-08d95b1d6ea0
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 10:07:02.0106 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SGVutNxcfvZfcbW3cP254u9/FlXjdQSgTx5A+gG5yG+kZeHUWjKT1JWQH6BUkmfw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0402MB2705
X-Source-IP: 194.104.111.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10070
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	adultscore=0
	priorityscore=120 malwarescore=0 mlxlogscore=999 impostorscore=0
	spamscore=0 bulkscore=0 clxscore=256 mlxscore=0 lowpriorityscore=0
	phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108090079
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10070
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	mlxscore=0
	suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 spamscore=0
	bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108090080
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10070 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090080
X-Proofpoint-ORIG-GUID: 1A6QSXuHc2Hh3dKShVl2DUVACltCwnkx
X-Proofpoint-GUID: 1A6QSXuHc2Hh3dKShVl2DUVACltCwnkx

Hi Joseph and All,

The deadlock is caused by self-locking on one node.
There is three node cluster (mounted to /mnt/shared), the user run 
reflink command to clone the file to the same directory repeatedly,
e.g.
  reflink "/mnt/shared/test" \
  "/mnt/shared/.snapshots/test.`date +%m%d%H%M%S`.`hostname`"

After a while, the reflink process on each node is hung, the file system 
cannot be listed.
The problematic reflink command process is blocked by itself, e.g. the 
reflink process is hung at ghe-sle15sp2-nd2,
kernel: task:reflink         state:D stack:    0 pid:16992 ppid:  4530
kernel: Call Trace:
kernel:  __schedule+0x2fd/0x750
kernel:  ? try_to_wake_up+0x17b/0x4e0
kernel:  schedule+0x2f/0xa0
kernel:  schedule_timeout+0x1cc/0x310
kernel:  ? __wake_up_common+0x74/0x120
kernel:  wait_for_completion+0xba/0x140
kernel:  ? wake_up_q+0xa0/0xa0
kernel:  __ocfs2_cluster_lock.isra.41+0x3b5/0x820 [ocfs2]
kernel:  ? ocfs2_inode_lock_full_nested+0x1fc/0x960 [ocfs2]
kernel:  ocfs2_inode_lock_full_nested+0x1fc/0x960 [ocfs2]
kernel:  ocfs2_init_security_and_acl+0xbe/0x1d0 [ocfs2]
kernel:  ocfs2_reflink+0x436/0x4c0 [ocfs2]
kernel:  ? ocfs2_reflink_ioctl+0x2ca/0x360 [ocfs2]
kernel:  ocfs2_reflink_ioctl+0x2ca/0x360 [ocfs2]
kernel:  ocfs2_ioctl+0x25e/0x670 [ocfs2]
kernel:  do_vfs_ioctl+0xa0/0x680
kernel:  ksys_ioctl+0x70/0x80

In fact, the destination directory(.snapshots) inode dlm lock was 
acquired by ghe-sle15sp2-nd2, next there is bast message from other 
nodes to ask ghe-sle15sp2-nd2 downconvert lock, but the operation 
failed, the kernel message is printed like,
kernel: (ocfs2dc-AA35DD9,2560,3):ocfs2_downconvert_lock:3660 ERROR: DLM 
error -16 while calling ocfs2_dlm_lock on resource 
M0000000000000000046e0200000000
kernel: (ocfs2dc-AA35DD9,2560,3):ocfs2_unblock_lock:3904 ERROR: status = -16
kernel: (ocfs2dc-AA35DD9,2560,3):ocfs2_process_blocked_lock:4303 ERROR: 
status = -16

Then, the reflink process tries to acquire this directory inode dlm 
lock, the process is blocked, the dlm lock resource in memory looks like

     l_name = "M0000000000000000046e0200000000",
     l_ro_holders = 0,
     l_ex_holders = 0,
     l_level = 5 '\005',
     l_requested = 0 '\000',
     l_blocking = 5 '\005',
     l_type = 0 '\000',
     l_action = 0 '\000',
     l_unlock_action = 0 '\000',
     l_pending_gen = 645948,


So far, I do not know what makes dlm lock function failed, it also looks 
we do not handle this failure case in dlmglue layer, but I always 
reproduce this hang with my test script, e.g.

   loop=1
   while ((loop++)) ; do
         for i in `seq 1 100`; do
           reflink "/mnt/shared/test" "/mnt/shared/.snapshots 
/test.${loop}.${i}.`date +%m%d%H%M%S`.`hostname`"
         done
         usleep 500000
         rm -f /mnt/shared/.snapshots/testnode1.qcow2.*.`hostname`
   done

My patch changes multiple acquiring dest directory inode dlm lock during 
in ocfs2_reflink function, it avoids the hang issue happen again.The 
code change also can improve reflink performance in this case.

Thanks
Gang


On 2021/8/4 9:57, Joseph Qi wrote:
> Hi Gang,
> As I mentioned in your previous mail, I'd like we describe the issue in
> the following way:
> 
> Node 1		Node 2		Node3
> ...
> 		...
> 				...
> 
> That will be more easier to understand the lock sequence.
> 
> Thanks,
> Joseph
> 
> On 7/29/21 7:02 PM, Gang He wrote:
>> Running reflink from multiple nodes simultaneously to clone a file
>> to the same directory probably triggers a deadlock issue.
>> For example, there is a three node ocfs2 cluster, each node mounts
>> the ocfs2 file system to /mnt/shared, and run the reflink command
>> from each node repeatedly, like
>>    reflink "/mnt/shared/test" \
>>    "/mnt/shared/.snapshots/test.`date +%m%d%H%M%S`.`hostname`"
>> then, reflink command process will be hung on each node, and you
>> can't list this file system directory.
>> The problematic reflink command process is blocked at one node,
>> task:reflink         state:D stack:    0 pid: 1283 ppid:  4154
>> Call Trace:
>>    __schedule+0x2fd/0x750
>>    schedule+0x2f/0xa0
>>    schedule_timeout+0x1cc/0x310
>>    ? ocfs2_control_cfu+0x50/0x50 [ocfs2_stack_user]
>>    ? 0xffffffffc0e3e000
>>    wait_for_completion+0xba/0x140
>>    ? wake_up_q+0xa0/0xa0
>>    __ocfs2_cluster_lock.isra.41+0x3b5/0x820 [ocfs2]
>>    ? ocfs2_inode_lock_full_nested+0x1fc/0x960 [ocfs2]
>>    ocfs2_inode_lock_full_nested+0x1fc/0x960 [ocfs2]
>>    ocfs2_init_security_and_acl+0xbe/0x1d0 [ocfs2]
>>    ocfs2_reflink+0x436/0x4c0 [ocfs2]
>>    ? ocfs2_reflink_ioctl+0x2ca/0x360 [ocfs2]
>>    ocfs2_reflink_ioctl+0x2ca/0x360 [ocfs2]
>>    ocfs2_ioctl+0x25e/0x670 [ocfs2]
>>    do_vfs_ioctl+0xa0/0x680
>>    ksys_ioctl+0x70/0x80
>>    __x64_sys_ioctl+0x16/0x20
>>    do_syscall_64+0x5b/0x1e0
>> The other reflink command processes are blocked at other nodes,
>> task:reflink         state:D stack:    0 pid:29759 ppid:  4088
>> Call Trace:
>>    __schedule+0x2fd/0x750
>>    schedule+0x2f/0xa0
>>    schedule_timeout+0x1cc/0x310
>>    ? ocfs2_control_cfu+0x50/0x50 [ocfs2_stack_user]
>>    ? 0xffffffffc0b19000
>>    wait_for_completion+0xba/0x140
>>    ? wake_up_q+0xa0/0xa0
>>    __ocfs2_cluster_lock.isra.41+0x3b5/0x820 [ocfs2]
>>    ? ocfs2_inode_lock_full_nested+0x1fc/0x960 [ocfs2]
>>    ocfs2_inode_lock_full_nested+0x1fc/0x960 [ocfs2]
>>    ocfs2_mv_orphaned_inode_to_new+0x87/0x7e0 [ocfs2]
>>    ocfs2_reflink+0x335/0x4c0 [ocfs2]
>>    ? ocfs2_reflink_ioctl+0x2ca/0x360 [ocfs2]
>>    ocfs2_reflink_ioctl+0x2ca/0x360 [ocfs2]
>>    ocfs2_ioctl+0x25e/0x670 [ocfs2]
>>    do_vfs_ioctl+0xa0/0x680
>>    ksys_ioctl+0x70/0x80
>>    __x64_sys_ioctl+0x16/0x20
>>    do_syscall_64+0x5b/0x1e0
>> or
>> task:reflink         state:D stack:    0 pid:18465 ppid:  4156
>> Call Trace:
>>    __schedule+0x302/0x940
>>    ? usleep_range+0x80/0x80
>>    schedule+0x46/0xb0
>>    schedule_timeout+0xff/0x140
>>    ? ocfs2_control_cfu+0x50/0x50 [ocfs2_stack_user]
>>    ? 0xffffffffc0c3b000
>>    __wait_for_common+0xb9/0x170
>>    __ocfs2_cluster_lock.constprop.0+0x1d6/0x860 [ocfs2]
>>    ? ocfs2_wait_for_recovery+0x49/0xd0 [ocfs2]
>>    ? ocfs2_inode_lock_full_nested+0x30f/0xa50 [ocfs2]
>>    ocfs2_inode_lock_full_nested+0x30f/0xa50 [ocfs2]
>>    ocfs2_inode_lock_tracker+0xf2/0x2b0 [ocfs2]
>>    ? dput+0x32/0x2f0
>>    ocfs2_permission+0x45/0xe0 [ocfs2]
>>    inode_permission+0xcc/0x170
>>    link_path_walk.part.0.constprop.0+0x2a2/0x380
>>    ? path_init+0x2c1/0x3f0
>>    path_parentat+0x3c/0x90
>>    filename_parentat+0xc1/0x1d0
>>    ? filename_lookup+0x138/0x1c0
>>    filename_create+0x43/0x160
>>    ocfs2_reflink_ioctl+0xe6/0x380 [ocfs2]
>>    ocfs2_ioctl+0x1ea/0x2c0 [ocfs2]
>>    ? do_sys_openat2+0x81/0x150
>>    __x64_sys_ioctl+0x82/0xb0
>>    do_syscall_64+0x61/0xb0
>>
>> The deadlock is caused by multiple acquiring the destination directory
>> inode dlm lock in ocfs2_reflink function, we should acquire this
>> directory inode dlm lock at the beginning, and hold this dlm lock until
>> end of the function.
>>
>> Signed-off-by: Gang He <ghe@suse.com>
>> ---
>>   fs/ocfs2/namei.c        | 32 +++++++++++++-------------------
>>   fs/ocfs2/namei.h        |  2 ++
>>   fs/ocfs2/refcounttree.c | 15 +++++++++++----
>>   fs/ocfs2/xattr.c        | 12 +-----------
>>   fs/ocfs2/xattr.h        |  1 +
>>   5 files changed, 28 insertions(+), 34 deletions(-)
>>
>> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
>> index 2c46ff6ba4ea..f8bbb22cc60b 100644
>> --- a/fs/ocfs2/namei.c
>> +++ b/fs/ocfs2/namei.c
>> @@ -2489,6 +2489,7 @@ static int ocfs2_prep_new_orphaned_file(struct inode *dir,
>>   }
>>   
>>   int ocfs2_create_inode_in_orphan(struct inode *dir,
>> +				 struct buffer_head **dir_bh,
>>   				 int mode,
>>   				 struct inode **new_inode)
>>   {
>> @@ -2597,13 +2598,16 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
>>   
>>   	brelse(new_di_bh);
>>   
>> -	if (!status)
>> -		*new_inode = inode;
>> -
>>   	ocfs2_free_dir_lookup_result(&orphan_insert);
>>   
>> -	ocfs2_inode_unlock(dir, 1);
>> -	brelse(parent_di_bh);
>> +	if (!status) {
>> +		*new_inode = inode;
>> +		*dir_bh = parent_di_bh;
>> +	} else {
>> +		ocfs2_inode_unlock(dir, 1);
>> +		brelse(parent_di_bh);
>> +	}
>> +
>>   	return status;
>>   }
>>   
>> @@ -2760,11 +2764,11 @@ int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
>>   }
>>   
>>   int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>> +				   struct buffer_head *dir_bh,
>>   				   struct inode *inode,
>>   				   struct dentry *dentry)
>>   {
>>   	int status = 0;
>> -	struct buffer_head *parent_di_bh = NULL;
>>   	handle_t *handle = NULL;
>>   	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
>>   	struct ocfs2_dinode *dir_di, *di;
>> @@ -2778,14 +2782,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>>   				(unsigned long long)OCFS2_I(dir)->ip_blkno,
>>   				(unsigned long long)OCFS2_I(inode)->ip_blkno);
>>   
>> -	status = ocfs2_inode_lock(dir, &parent_di_bh, 1);
>> -	if (status < 0) {
>> -		if (status != -ENOENT)
>> -			mlog_errno(status);
>> -		return status;
>> -	}
>> -
>> -	dir_di = (struct ocfs2_dinode *) parent_di_bh->b_data;
>> +	dir_di = (struct ocfs2_dinode *) dir_bh->b_data;
>>   	if (!dir_di->i_links_count) {
>>   		/* can't make a file in a deleted directory. */
>>   		status = -ENOENT;
>> @@ -2798,7 +2795,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>>   		goto leave;
>>   
>>   	/* get a spot inside the dir. */
>> -	status = ocfs2_prepare_dir_for_insert(osb, dir, parent_di_bh,
>> +	status = ocfs2_prepare_dir_for_insert(osb, dir, dir_bh,
>>   					      dentry->d_name.name,
>>   					      dentry->d_name.len, &lookup);
>>   	if (status < 0) {
>> @@ -2862,7 +2859,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>>   	ocfs2_journal_dirty(handle, di_bh);
>>   
>>   	status = ocfs2_add_entry(handle, dentry, inode,
>> -				 OCFS2_I(inode)->ip_blkno, parent_di_bh,
>> +				 OCFS2_I(inode)->ip_blkno, dir_bh,
>>   				 &lookup);
>>   	if (status < 0) {
>>   		mlog_errno(status);
>> @@ -2886,10 +2883,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>>   	iput(orphan_dir_inode);
>>   leave:
>>   
>> -	ocfs2_inode_unlock(dir, 1);
>> -
>>   	brelse(di_bh);
>> -	brelse(parent_di_bh);
>>   	brelse(orphan_dir_bh);
>>   
>>   	ocfs2_free_dir_lookup_result(&lookup);
>> diff --git a/fs/ocfs2/namei.h b/fs/ocfs2/namei.h
>> index 9cc891eb874e..03a2c526e2c1 100644
>> --- a/fs/ocfs2/namei.h
>> +++ b/fs/ocfs2/namei.h
>> @@ -24,6 +24,7 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
>>   		     struct buffer_head *orphan_dir_bh,
>>   		     bool dio);
>>   int ocfs2_create_inode_in_orphan(struct inode *dir,
>> +				 struct buffer_head **dir_bh,
>>   				 int mode,
>>   				 struct inode **new_inode);
>>   int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
>> @@ -32,6 +33,7 @@ int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
>>   		struct inode *inode, struct buffer_head *di_bh,
>>   		int update_isize, loff_t end);
>>   int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>> +				   struct buffer_head *dir_bh,
>>   				   struct inode *new_inode,
>>   				   struct dentry *new_dentry);
>>   
>> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
>> index 7f6355cbb587..a9a0c7c37e8e 100644
>> --- a/fs/ocfs2/refcounttree.c
>> +++ b/fs/ocfs2/refcounttree.c
>> @@ -4250,7 +4250,7 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
>>   {
>>   	int error, had_lock;
>>   	struct inode *inode = d_inode(old_dentry);
>> -	struct buffer_head *old_bh = NULL;
>> +	struct buffer_head *old_bh = NULL, *dir_bh = NULL;
>>   	struct inode *new_orphan_inode = NULL;
>>   	struct ocfs2_lock_holder oh;
>>   
>> @@ -4258,7 +4258,7 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
>>   		return -EOPNOTSUPP;
>>   
>>   
>> -	error = ocfs2_create_inode_in_orphan(dir, inode->i_mode,
>> +	error = ocfs2_create_inode_in_orphan(dir, &dir_bh, inode->i_mode,
>>   					     &new_orphan_inode);
>>   	if (error) {
>>   		mlog_errno(error);
>> @@ -4304,13 +4304,15 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
>>   
>>   	/* If the security isn't preserved, we need to re-initialize them. */
>>   	if (!preserve) {
>> -		error = ocfs2_init_security_and_acl(dir, new_orphan_inode,
>> +		error = ocfs2_init_security_and_acl(dir, dir_bh,
>> +						    new_orphan_inode,
>>   						    &new_dentry->d_name);
>>   		if (error)
>>   			mlog_errno(error);
>>   	}
>>   	if (!error) {
>> -		error = ocfs2_mv_orphaned_inode_to_new(dir, new_orphan_inode,
>> +		error = ocfs2_mv_orphaned_inode_to_new(dir, dir_bh,
>> +						       new_orphan_inode,
>>   						       new_dentry);
>>   		if (error)
>>   			mlog_errno(error);
>> @@ -4328,6 +4330,11 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
>>   			iput(new_orphan_inode);
>>   	}
>>   
>> +	if (dir_bh) {
>> +		ocfs2_inode_unlock(dir, 1);
>> +		brelse(dir_bh);
>> +	}
>> +
>>   	return error;
>>   }
>>   
>> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
>> index dd784eb0cd7c..3f23e3a5018c 100644
>> --- a/fs/ocfs2/xattr.c
>> +++ b/fs/ocfs2/xattr.c
>> @@ -7203,16 +7203,13 @@ int ocfs2_reflink_xattrs(struct inode *old_inode,
>>   /*
>>    * Initialize security and acl for a already created inode.
>>    * Used for reflink a non-preserve-security file.
>> - *
>> - * It uses common api like ocfs2_xattr_set, so the caller
>> - * must not hold any lock expect i_mutex.
>>    */
>>   int ocfs2_init_security_and_acl(struct inode *dir,
>> +				struct buffer_head *dir_bh,
>>   				struct inode *inode,
>>   				const struct qstr *qstr)
>>   {
>>   	int ret = 0;
>> -	struct buffer_head *dir_bh = NULL;
>>   
>>   	ret = ocfs2_init_security_get(inode, dir, qstr, NULL);
>>   	if (ret) {
>> @@ -7220,17 +7217,10 @@ int ocfs2_init_security_and_acl(struct inode *dir,
>>   		goto leave;
>>   	}
>>   
>> -	ret = ocfs2_inode_lock(dir, &dir_bh, 0);
>> -	if (ret) {
>> -		mlog_errno(ret);
>> -		goto leave;
>> -	}
>>   	ret = ocfs2_init_acl(NULL, inode, dir, NULL, dir_bh, NULL, NULL);
>>   	if (ret)
>>   		mlog_errno(ret);
>>   
>> -	ocfs2_inode_unlock(dir, 0);
>> -	brelse(dir_bh);
>>   leave:
>>   	return ret;
>>   }
>> diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
>> index 00308b57f64f..b27fd8ba0019 100644
>> --- a/fs/ocfs2/xattr.h
>> +++ b/fs/ocfs2/xattr.h
>> @@ -83,6 +83,7 @@ int ocfs2_reflink_xattrs(struct inode *old_inode,
>>   			 struct buffer_head *new_bh,
>>   			 bool preserve_security);
>>   int ocfs2_init_security_and_acl(struct inode *dir,
>> +				struct buffer_head *dir_bh,
>>   				struct inode *inode,
>>   				const struct qstr *qstr);
>>   #endif /* OCFS2_XATTR_H */
>>
> 


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
