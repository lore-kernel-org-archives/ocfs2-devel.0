Return-Path: <SRS0=NURE=N6=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D92C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Sep 2021 06:07:30 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CBAEA61026
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Sep 2021 06:07:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CBAEA61026
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1884COah018117;
	Wed, 8 Sep 2021 06:07:29 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3axcs19f0r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Sep 2021 06:07:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18866HkP008836;
	Wed, 8 Sep 2021 06:07:27 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3axcpq3ncd-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 08 Sep 2021 06:07:26 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mNqk1-0005GZ-Nn; Tue, 07 Sep 2021 23:07:25 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1mNqjV-0005Fb-Gn
	for ocfs2-devel@oss.oracle.com; Tue, 07 Sep 2021 23:06:53 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	18866Isq008911
	for <ocfs2-devel@oss.oracle.com>; Wed, 8 Sep 2021 06:06:53 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3axcpq3ms3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 08 Sep 2021 06:06:48 +0000
Received: from pps.filterd (m0246578.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	187MoWK7009985
	for <ocfs2-devel@oss.oracle.com>; Wed, 8 Sep 2021 06:06:47 GMT
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102])
	by mx0b-00069f01.pphosted.com with ESMTP id 3axcm9f7fp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 08 Sep 2021 06:06:46 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
	(mail-db8eur05lp2113.outbound.protection.outlook.com [104.47.17.113])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-5-G4IyeGp_MzmEihuRszoYHQ-1; Wed, 08 Sep 2021 08:06:43 +0200
X-MC-Unique: G4IyeGp_MzmEihuRszoYHQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=dwnEjA638/0rxifRUVKpUeTxD9VR2wF5w6EzJMnFB4Cejm98Q9gi081hKItFL/6s2NNQ+2bOHr9EjiqEnoGPzqXkTYBvxe1EJ+7clLylQ4xjydNrAtKuc8R08S55Rj0Fi0suRZnGAYCe/r03IgVvIZ0nn7DxxI4Be2LLB4Z7/fOmfeeYQkFokwD0nF6yydAVJFtgZDQSwGVpg0dGU7tnOcNZ1sWNaV/pB+AMQtaCZxrRe1D1k3rzRPpXYnVQiwxWtVK6NeIlaz51PVIriVcjk4eyVL6O1bGek5o52LYzAcbFCJieocksBFYHfWVcul8YUUToNVmO+zvtxzM8s86kbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version; 
	bh=iFFAuJ6JSxfMGg4B2QZKQwXtdRuATLDtsis3gi9hirk=;
	b=HinMHKY9bdjq0OwHPLoKLggKxu3Ii8xXthhdFORVMl/2K7hz4e1cW4acjjR2E4LLUfHjKCDLdbseyp6YEgrJNQikDWN3dBDCpbmDH2YuNvQGkBJophbZ7xHBBQQBHMUSIP4+vaj+dHYK+NYs3ytSUD4nkMd9GQI0hb5uBOeXhX2D6rUQUlR3q/18RB4lsr8z5lEPu8MACDlNzQVzO+dmYpuaig3G7dkipPRW0mWyGO71rmcvJbfAhpSdtSKP3tN6u8J5+l/Vk4kODGyI2UpwM2FATVfT0NQPe4WYLVORKUTnFZ15IEVK3RnlxXwSTRWSwmpkAoC4QUbocV187+y7Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=suse.com; 
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21)
	by AM5PR0401MB2532.eurprd04.prod.outlook.com (2603:10a6:203:37::7)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22;
	Wed, 8 Sep 2021 06:06:42 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::793c:6276:4f2a:4d71%4]) with mapi id 15.20.4500.014;
	Wed, 8 Sep 2021 06:06:42 +0000
To: Wengang Wang <wen.gang.wang@oracle.com>
References: <20210826075941.28480-1-ghe@suse.com>
	<744d756c-7640-d312-37ef-126755324e8a@suse.com>
	<3FF09C2E-2855-457E-8533-50BBD8EECEF1@oracle.com>
From: Gang He <ghe@suse.com>
Message-ID: <2abbfd28-da40-3218-f226-0621cb683716@suse.com>
Date: Wed, 8 Sep 2021 14:06:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.13.0
In-Reply-To: <3FF09C2E-2855-457E-8533-50BBD8EECEF1@oracle.com>
Content-Language: en-US
X-ClientProxiedBy: HK2PR0401CA0003.apcprd04.prod.outlook.com
	(2603:1096:202:2::13) To AM6PR04MB6488.eurprd04.prod.outlook.com
	(2603:10a6:20b:f8::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.67.20.87] (60.251.47.115) by
	HK2PR0401CA0003.apcprd04.prod.outlook.com (2603:1096:202:2::13)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14
	via Frontend Transport; Wed, 8 Sep 2021 06:06:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4483a0fa-579f-457b-76ba-08d9728ed44b
X-MS-TrafficTypeDiagnostic: AM5PR0401MB2532:
X-Microsoft-Antispam-PRVS: <AM5PR0401MB25328E973BCC254923988F54CFD49@AM5PR0401MB2532.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dAmtylzX0b/v+0F7isdaz9RDyF3DXDxTQQgWrL4YEXMyL7ThMSxGQcOTsNRI4+T9D56sxGy7mTPneTd0qxvF/tkBzG20q5KlEKcSn8rG5bMKTMOFMPWiy71EQ5XnZOEwTyNLj4pVRp2xOM+lTo2RWzM6FgMRqWCbacIzyU5pOAmolBTghTPjeaUHlmk9HGIq3FngL1NXn1To2H6Io5EKt+ERi8j7XoR5w60DVRXLCzwtRDn4ycLNtXAeL5fBfAoWqmZuaGEvoGE7LwxNOdKfZjs87z1VmNrDHFQDHiaxMu8wMYk7LJxBkVyXcItTO98x4n7yanyRvQ+sywD6jAsA12P5gZLWzGgFq3wDim1iqIe8Z7NawQZoZ8rEAZRykOUlt7SEMpuHlC6rziZ9mmfONZoRoquv5UynZzYVR0P6T8nGbIfWagnPV7NNZXzOaHrrDW76YAig/9RtXICRzddzDVFYcjy0hWD9Ve55DcDnYmy3D0iMXKmXVpgqnKxapJaA8JkE16UkGueli2XYPadrVY5ud0wYpaF8XPag6QUXaZwK72+mu/P4Cz5jJiEKYCVp+mb1EFQkv6p1SljFCwHVWSHYggGPYxgj7DAFcFLcskGdGNZKEfhZDm4JIsFAnQEOy7V/bQ2yXBHmvSvNctVJz3UfWvU3MnWLDMubZER7ODd3J0oF7Yw3YpCsX2BRwgi+dAqtLYWsPqL8O8BRef5M2LOc8p42K7L5D6iG9FbofgPhURnVeeiP0JzMubZqDEHAchROzO05NhW7/yFakEll6ud3395BwSyB7/Mzep1gbMXcVV26kcpcIKjbdPVrVJD4
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(376002)(346002)(366004)(39860400002)(136003)(396003)(55236004)(38100700002)(8676002)(6916009)(956004)(2616005)(66946007)(31686004)(53546011)(6486002)(83380400001)(16576012)(26005)(2906002)(186003)(54906003)(36756003)(316002)(478600001)(966005)(4326008)(6666004)(66556008)(5660300002)(31696002)(66476007)(86362001)(8936002)(43740500002)(45980500001);
	DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2tIZENNbXZ3UlNtbHJjdFA0RFEvUVhvVk1Pa2ZJVEN1VC95OEFHdWtuNU5o?=
	=?utf-8?B?cEMvckpETlJ1Z2dMc2hXSElXaFpFZWEweFBPWlNXOXdCQ0FvYnk0clBPL0Nm?=
	=?utf-8?B?MzFSc2o0UTJ2NVpnR3FoeDBrS2tzYUlNV3UybVc1U2Z6a3E1TjBiOWVtN3JN?=
	=?utf-8?B?NTM4cGpMUWJ0VGlrMUhVc0oxRW5BYTJGeFgxVEJYTndmK1E5RVNObHRTb3hw?=
	=?utf-8?B?eGpVVHRJS0hmbkNPeWpjaHNOT3hZYzlWaVJzK01GN3NpT2lNNDZWMXBxdmlS?=
	=?utf-8?B?dDlUYlFNaTJnR01tamVXU2RIM2FpOG9heHVOemwyVUdQaXhhMEFjQjdIWk1E?=
	=?utf-8?B?VG1KZ3h4R20vdjZVdmFjdW1qZTVsMDhiaDJSSFN5UkNvVml1V0pGN2oyUllH?=
	=?utf-8?B?N2lIQ0pyaXpJZDlDa1g2UVROb2dLSEkrS1MxbHlsdjh0V1daREYyYnNIR1ZJ?=
	=?utf-8?B?VVN4d1Y3OWpJTW5IdWprcnNCaHo3d2NjOHp6cVZ4U0gvSUNnWWNhdmM4MW5H?=
	=?utf-8?B?MEhxc0Y1djhsU1NVaEtIbjhpNFhPQUR5VUZ6S0FqNmFVUGhGK1Z2Zk96S1F2?=
	=?utf-8?B?QlgvYVJzUGkwd2VWM1FzRXBTS1l0eTNKSkNZdk9BQmhzb3JBaVVFa2xaVDAz?=
	=?utf-8?B?a3ArbXVsUW94Y0M5Um16L05SOXVyQ2NTS3RvczAvRzZDRnoyL3RPYnFlNFoz?=
	=?utf-8?B?aDhqNzRVK3BiYlUxZGcrQ3IwdDJINUQzSlF3NzFVUmZEK2JQaVRHblNIa09C?=
	=?utf-8?B?bkNROW5XcmhXeDJNeWEwV1ArRGJmR2RuU3BSa3dFSnkwUHpOY05xbWVYendH?=
	=?utf-8?B?VlFYU0RVUU1JUEVqcHNEa29lTmloYTVPQ01IYWVUQktCWlRyeWxEaENCYVlK?=
	=?utf-8?B?RHlzRnE5T3FyVXhldXdWOERweXJkWGVSdEVqbGRuZ0c1UG85RHZCU2Z2NVFZ?=
	=?utf-8?B?YWdjMzhkL01EeXpCc2ZTTzZnS0kxTWtuTHp2dGlQWC9RQ2dMaThtNDRKVjZa?=
	=?utf-8?B?TndaSDloUEVEWkZZcXBCKzhwbUlGVDZIMm5ZWVJRaDJIdWFoMno3T2FMcFBl?=
	=?utf-8?B?aENobkpnY3BLZG1QYzlpRjlvQk5rOFpaN2JUa1A3OUltRHFvWTI1QjRyNk5q?=
	=?utf-8?B?akZ1SktNZGtadCtCRzdkcC96LzdQWjIreWNhMVdZQkJIZytNb1JEeEY3QmVJ?=
	=?utf-8?B?SFgyYnJLRENmMXFxVEo0d3NicnNIQ1hzd200SHRlMFNtb0N3TGxacW1GaXlR?=
	=?utf-8?B?SFRINGUvdldUd1UxM3dtTGJOZnRQVCswVmZQa1VsTEpLOHJzRWZSaEwvV2pi?=
	=?utf-8?B?c2U5U2hvekYvZXNOM1JYQnB1TjdUeW96dWVpQm0xekVWZlZUcjNSZnZ4VEpt?=
	=?utf-8?B?UjNrbDVRcmRoV2lTZm9HZ3VIRTdVQ1ZDNW5rS1Q0ZTN1blNXVEhQQnp5RlU3?=
	=?utf-8?B?S0FOSmhBdm15Qzk0czZsTlY1SFNqZm1SbEtRcDJoNy9ZY1hyL2NzN1RRZTlJ?=
	=?utf-8?B?cFlFaStoMmdodWtnNXRmWVdMZUtwd3BqemJTdnhUaWsvSUswSDVyYW9Pb1gx?=
	=?utf-8?B?NzVKdFZjVlR6N0c4SkpZMFM5RW9WQ1lkQk1lWm1QTFR0VFl6SHNQWjVCNFlZ?=
	=?utf-8?B?WkRrSitTSm1reWVNbG4yTmRDdmZ4OEpXckF5QmhGVmkyUDhDczFGZEV3SFQ1?=
	=?utf-8?B?QXYxazdDS214ckJBSXo0T25aTVpJV2pEUzVsdURHRzVIM0xLRGZwdzhSVms5?=
	=?utf-8?Q?oju4Gn8i5R0FF2NX3LWAGKtZKXwL8rS+xlyRw7J?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4483a0fa-579f-457b-76ba-08d9728ed44b
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2021 06:06:42.3622 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AzXcbs1Xt7Ken4uKuSzlJQP7SBmodivoHcWZQQXEIFKZujW+DDZ1nggONDcdI9pc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2532
X-Source-IP: 194.104.109.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com include:_spf.salesforce.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10100
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=249
	mlxscore=0 spamscore=0
	malwarescore=0 impostorscore=0 priorityscore=196 phishscore=0
	suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999
	lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109030001 definitions=main-2109080038
X-Spam: Clean
Cc: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: avoid getting dlm lock of the
 target directory multiple times during reflink process
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10100 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109080038
X-Proofpoint-ORIG-GUID: N2RrN9q7iYDdFwSU4VXh0EBItPE2D1Wa
X-Proofpoint-GUID: N2RrN9q7iYDdFwSU4VXh0EBItPE2D1Wa



On 2021/9/7 23:57, Wengang Wang wrote:
> Hi Gang,
> 
> Sure, I will look into the problem you are trying to address. Any bug fix and performance improvement is welcomed!
> Well, can you please provide the analysis on the tcpdumps between the (two) nodes that covers the reflink operation with/without your patch to show how you saved dlm locking ping-pongs?
The code change will hold the reflink destination dir inode dlm lock, 
release it until the whole reflink process is completed.
The current code will hold/release this dlm lock three times during the 
reflink process. If there are some concurrently reflink operation to 
that directory from other nodes, the ping-pong effect is that directory 
inode related data will be synchronized(multiple times) to the disk when 
inode dlm lock is downconverted during one reflink operation.

According to my test, running the reflink command to clone a file to the 
same directory repeatedly from three nodes, the code change can shorten 
the previous half of the time.

Thanks
Gang

> 
> And what cases did you test to get better performance?
> 
> thanks,
> wengang
> 
>> On Aug 30, 2021, at 11:25 PM, Gang He <ghe@suse.com> wrote:
>>
>> Hello Joseph and Wengang,
>>
>> When you have time, please help review this patch.
>> About the deadlock problem which was caused by ocfs2_downconvert_lock
>> failure, we have the fix patch, it is very key.
>> But I feel this patch is still useful as a optimization patch, the user
>> case is to reflink the files to the same directory concurrently, our
>> users usually backup the files(via reflink) from the cluster nodes
>> concurrently(via crontab) every day/hour.
>> The current design, during the reflink process, the node will
>> acquire/release dlm lock of the target directory multiple times,
>> this is very inefficient in concurrently reflink.
>>
>>
>> Thanks
>> Gang
>>
>> On 2021/8/26 15:59, Gang He wrote:
>>> During the reflink process, we should acquire the target directory
>>> inode dlm lock at the beginning, and hold this dlm lock until end
>>> of the function.
>>> With this patch, we avoid dlm lock ping-pong effect when clone
>>> files to the same directory simultaneously from multiple nodes.
>>> There is a typical user scenario, users regularly back up files
>>> to a specified directory through the reflink feature from the
>>> multiple nodes.
>>>
>>> Signed-off-by: Gang He <ghe@suse.com>
>>> ---
>>>   fs/ocfs2/namei.c        | 32 +++++++++++++-------------------
>>>   fs/ocfs2/namei.h        |  2 ++
>>>   fs/ocfs2/refcounttree.c | 15 +++++++++++----
>>>   fs/ocfs2/xattr.c        | 12 +-----------
>>>   fs/ocfs2/xattr.h        |  1 +
>>>   5 files changed, 28 insertions(+), 34 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
>>> index 2c46ff6ba4ea..f8bbb22cc60b 100644
>>> --- a/fs/ocfs2/namei.c
>>> +++ b/fs/ocfs2/namei.c
>>> @@ -2489,6 +2489,7 @@ static int ocfs2_prep_new_orphaned_file(struct inode *dir,
>>>   }
>>>
>>>   int ocfs2_create_inode_in_orphan(struct inode *dir,
>>> +				 struct buffer_head **dir_bh,
>>>   				 int mode,
>>>   				 struct inode **new_inode)
>>>   {
>>> @@ -2597,13 +2598,16 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
>>>
>>>   	brelse(new_di_bh);
>>>
>>> -	if (!status)
>>> -		*new_inode = inode;
>>> -
>>>   	ocfs2_free_dir_lookup_result(&orphan_insert);
>>>
>>> -	ocfs2_inode_unlock(dir, 1);
>>> -	brelse(parent_di_bh);
>>> +	if (!status) {
>>> +		*new_inode = inode;
>>> +		*dir_bh = parent_di_bh;
>>> +	} else {
>>> +		ocfs2_inode_unlock(dir, 1);
>>> +		brelse(parent_di_bh);
>>> +	}
>>> +
>>>   	return status;
>>>   }
>>>
>>> @@ -2760,11 +2764,11 @@ int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
>>>   }
>>>
>>>   int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>>> +				   struct buffer_head *dir_bh,
>>>   				   struct inode *inode,
>>>   				   struct dentry *dentry)
>>>   {
>>>   	int status = 0;
>>> -	struct buffer_head *parent_di_bh = NULL;
>>>   	handle_t *handle = NULL;
>>>   	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
>>>   	struct ocfs2_dinode *dir_di, *di;
>>> @@ -2778,14 +2782,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>>>   				(unsigned long long)OCFS2_I(dir)->ip_blkno,
>>>   				(unsigned long long)OCFS2_I(inode)->ip_blkno);
>>>
>>> -	status = ocfs2_inode_lock(dir, &parent_di_bh, 1);
>>> -	if (status < 0) {
>>> -		if (status != -ENOENT)
>>> -			mlog_errno(status);
>>> -		return status;
>>> -	}
>>> -
>>> -	dir_di = (struct ocfs2_dinode *) parent_di_bh->b_data;
>>> +	dir_di = (struct ocfs2_dinode *) dir_bh->b_data;
>>>   	if (!dir_di->i_links_count) {
>>>   		/* can't make a file in a deleted directory. */
>>>   		status = -ENOENT;
>>> @@ -2798,7 +2795,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>>>   		goto leave;
>>>
>>>   	/* get a spot inside the dir. */
>>> -	status = ocfs2_prepare_dir_for_insert(osb, dir, parent_di_bh,
>>> +	status = ocfs2_prepare_dir_for_insert(osb, dir, dir_bh,
>>>   					      dentry->d_name.name,
>>>   					      dentry->d_name.len, &lookup);
>>>   	if (status < 0) {
>>> @@ -2862,7 +2859,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>>>   	ocfs2_journal_dirty(handle, di_bh);
>>>
>>>   	status = ocfs2_add_entry(handle, dentry, inode,
>>> -				 OCFS2_I(inode)->ip_blkno, parent_di_bh,
>>> +				 OCFS2_I(inode)->ip_blkno, dir_bh,
>>>   				 &lookup);
>>>   	if (status < 0) {
>>>   		mlog_errno(status);
>>> @@ -2886,10 +2883,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>>>   	iput(orphan_dir_inode);
>>>   leave:
>>>
>>> -	ocfs2_inode_unlock(dir, 1);
>>> -
>>>   	brelse(di_bh);
>>> -	brelse(parent_di_bh);
>>>   	brelse(orphan_dir_bh);
>>>
>>>   	ocfs2_free_dir_lookup_result(&lookup);
>>> diff --git a/fs/ocfs2/namei.h b/fs/ocfs2/namei.h
>>> index 9cc891eb874e..03a2c526e2c1 100644
>>> --- a/fs/ocfs2/namei.h
>>> +++ b/fs/ocfs2/namei.h
>>> @@ -24,6 +24,7 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
>>>   		     struct buffer_head *orphan_dir_bh,
>>>   		     bool dio);
>>>   int ocfs2_create_inode_in_orphan(struct inode *dir,
>>> +				 struct buffer_head **dir_bh,
>>>   				 int mode,
>>>   				 struct inode **new_inode);
>>>   int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
>>> @@ -32,6 +33,7 @@ int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
>>>   		struct inode *inode, struct buffer_head *di_bh,
>>>   		int update_isize, loff_t end);
>>>   int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>>> +				   struct buffer_head *dir_bh,
>>>   				   struct inode *new_inode,
>>>   				   struct dentry *new_dentry);
>>>
>>> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
>>> index 7f6355cbb587..a9a0c7c37e8e 100644
>>> --- a/fs/ocfs2/refcounttree.c
>>> +++ b/fs/ocfs2/refcounttree.c
>>> @@ -4250,7 +4250,7 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
>>>   {
>>>   	int error, had_lock;
>>>   	struct inode *inode = d_inode(old_dentry);
>>> -	struct buffer_head *old_bh = NULL;
>>> +	struct buffer_head *old_bh = NULL, *dir_bh = NULL;
>>>   	struct inode *new_orphan_inode = NULL;
>>>   	struct ocfs2_lock_holder oh;
>>>
>>> @@ -4258,7 +4258,7 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
>>>   		return -EOPNOTSUPP;
>>>
>>>
>>> -	error = ocfs2_create_inode_in_orphan(dir, inode->i_mode,
>>> +	error = ocfs2_create_inode_in_orphan(dir, &dir_bh, inode->i_mode,
>>>   					     &new_orphan_inode);
>>>   	if (error) {
>>>   		mlog_errno(error);
>>> @@ -4304,13 +4304,15 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
>>>
>>>   	/* If the security isn't preserved, we need to re-initialize them. */
>>>   	if (!preserve) {
>>> -		error = ocfs2_init_security_and_acl(dir, new_orphan_inode,
>>> +		error = ocfs2_init_security_and_acl(dir, dir_bh,
>>> +						    new_orphan_inode,
>>>   						    &new_dentry->d_name);
>>>   		if (error)
>>>   			mlog_errno(error);
>>>   	}
>>>   	if (!error) {
>>> -		error = ocfs2_mv_orphaned_inode_to_new(dir, new_orphan_inode,
>>> +		error = ocfs2_mv_orphaned_inode_to_new(dir, dir_bh,
>>> +						       new_orphan_inode,
>>>   						       new_dentry);
>>>   		if (error)
>>>   			mlog_errno(error);
>>> @@ -4328,6 +4330,11 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
>>>   			iput(new_orphan_inode);
>>>   	}
>>>
>>> +	if (dir_bh) {
>>> +		ocfs2_inode_unlock(dir, 1);
>>> +		brelse(dir_bh);
>>> +	}
>>> +
>>>   	return error;
>>>   }
>>>
>>> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
>>> index dd784eb0cd7c..3f23e3a5018c 100644
>>> --- a/fs/ocfs2/xattr.c
>>> +++ b/fs/ocfs2/xattr.c
>>> @@ -7203,16 +7203,13 @@ int ocfs2_reflink_xattrs(struct inode *old_inode,
>>>   /*
>>>    * Initialize security and acl for a already created inode.
>>>    * Used for reflink a non-preserve-security file.
>>> - *
>>> - * It uses common api like ocfs2_xattr_set, so the caller
>>> - * must not hold any lock expect i_mutex.
>>>    */
>>>   int ocfs2_init_security_and_acl(struct inode *dir,
>>> +				struct buffer_head *dir_bh,
>>>   				struct inode *inode,
>>>   				const struct qstr *qstr)
>>>   {
>>>   	int ret = 0;
>>> -	struct buffer_head *dir_bh = NULL;
>>>
>>>   	ret = ocfs2_init_security_get(inode, dir, qstr, NULL);
>>>   	if (ret) {
>>> @@ -7220,17 +7217,10 @@ int ocfs2_init_security_and_acl(struct inode *dir,
>>>   		goto leave;
>>>   	}
>>>
>>> -	ret = ocfs2_inode_lock(dir, &dir_bh, 0);
>>> -	if (ret) {
>>> -		mlog_errno(ret);
>>> -		goto leave;
>>> -	}
>>>   	ret = ocfs2_init_acl(NULL, inode, dir, NULL, dir_bh, NULL, NULL);
>>>   	if (ret)
>>>   		mlog_errno(ret);
>>>
>>> -	ocfs2_inode_unlock(dir, 0);
>>> -	brelse(dir_bh);
>>>   leave:
>>>   	return ret;
>>>   }
>>> diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
>>> index 00308b57f64f..b27fd8ba0019 100644
>>> --- a/fs/ocfs2/xattr.h
>>> +++ b/fs/ocfs2/xattr.h
>>> @@ -83,6 +83,7 @@ int ocfs2_reflink_xattrs(struct inode *old_inode,
>>>   			 struct buffer_head *new_bh,
>>>   			 bool preserve_security);
>>>   int ocfs2_init_security_and_acl(struct inode *dir,
>>> +				struct buffer_head *dir_bh,
>>>   				struct inode *inode,
>>>   				const struct qstr *qstr);
>>>   #endif /* OCFS2_XATTR_H */
>>>
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel@oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
