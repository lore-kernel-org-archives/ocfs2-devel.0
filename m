Return-Path: <SRS0=KptY=KF=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C54E1C433B4
	for <ocfs2-devel@archiver.kernel.org>; Mon, 10 May 2021 22:19:56 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 500C96147E
	for <ocfs2-devel@archiver.kernel.org>; Mon, 10 May 2021 22:19:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 500C96147E
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14AMJAj2003956;
	Mon, 10 May 2021 22:19:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : references :
 from : message-id : date : in-reply-to : mime-version : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2020-01-29; bh=DoMddbPwPha8ryACt1BJkQD3gMrJv5LqCqykO/DXDvo=;
 b=odKR+7Kt91ME9niGw0YHVqIbBHGmCj3RuQVdqbR0NmVPPwVKWfkEclJrXVkHb1cbhr0C
 xoDlOLPvQrBe9mr1U+e7ctdutzvngNQtvy5J12wgqvLFehY6kRpfTRVh2lkElCHez7AO
 8SMeCszrhY9dvzte3QDGdZKJzltw24mRSbFK7w4ue6V6+yekpanJF4y+Vp1u3/hhXwOV
 DM/buFEcwk2qya7OMH6LzVJvMrk+Bnndj+2VR5BarKfhkYKkwZz0N2hfMKSir5YL1aNk
 b5xzDmXaLLaECkgNOmR57BPT1QS6D74m4PvbMH9jHSbkfpnoKlbEuflDVrH325UMUfKF hQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2120.oracle.com with ESMTP id 38dk9nctcv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 May 2021 22:19:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14AMJmqb168487;
	Mon, 10 May 2021 22:19:54 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 38dfrw6p1a-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 10 May 2021 22:19:54 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lgECi-00083q-6S; Mon, 10 May 2021 15:16:44 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <junxiao.bi@oracle.com>) id 1lgECe-00083P-QD
	for ocfs2-devel@oss.oracle.com; Mon, 10 May 2021 15:16:40 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14ALxZ1S110903
	for <ocfs2-devel@oss.oracle.com>; Mon, 10 May 2021 22:16:40 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam08lp2045.outbound.protection.outlook.com [104.47.73.45])
	by userp3030.oracle.com with ESMTP id 38dfrw6j5d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 10 May 2021 22:16:40 +0000
Authentication-Results: suse.cz; dkim=none (message not signed)
	header.d=none;suse.cz; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
	by BY5PR10MB4274.namprd10.prod.outlook.com (2603:10b6:a03:206::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.29;
	Mon, 10 May 2021 22:16:38 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f]) by
	SJ0PR10MB4752.namprd10.prod.outlook.com
	([fe80::7865:7d35:9cee:363f%5]) with mapi id 15.20.4108.031;
	Mon, 10 May 2021 22:16:38 +0000
To: Andrew Morton <akpm@linux-foundation.org>
References: <20210426220552.45413-1-junxiao.bi@oracle.com>
	<20210509162306.9de66b1656f04994f3cb5730@linux-foundation.org>
From: Junxiao Bi <junxiao.bi@oracle.com>
Message-ID: <4d120e2e-5eb4-1bbb-cc63-8c3b7c62dac0@oracle.com>
Date: Mon, 10 May 2021 15:15:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.10.1
In-Reply-To: <20210509162306.9de66b1656f04994f3cb5730@linux-foundation.org>
Content-Language: en-US
X-Originating-IP: [73.231.9.254]
X-ClientProxiedBy: SA0PR11CA0071.namprd11.prod.outlook.com
	(2603:10b6:806:d2::16) To SJ0PR10MB4752.namprd10.prod.outlook.com
	(2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-227-171.vpn.oracle.com (73.231.9.254) by
	SA0PR11CA0071.namprd11.prod.outlook.com (2603:10b6:806:d2::16)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24
	via Frontend Transport; Mon, 10 May 2021 22:16:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e94c67db-cbfb-49e2-3b83-08d9140147bb
X-MS-TrafficTypeDiagnostic: BY5PR10MB4274:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lgBdQ8fUryExvQIITRiksKKt6cLgW+B6Pg63bt1etCdVhYJD3wETq9fMz3OjOp62tBO/XqepRGA1LdIzDs/v0q1IalERZliSE/sUNuZoHuDGROlokgZI3XyIUaXGtgEFrrBKPsbKOnKhFvZXmEFel6m5CaAnKh3bwcGqOpzHLg9Vv5JbKna6E2FXD3sHk3bIaPvctwC/kWB4h5oeWcrpDldzCSfh+w1PfaOsR8rABxoY22gLYM7a/lQ6WMFMY0Pi2tmTzhhfviWyXbYKLhJpGdnRxcT2Dv3sZbCFEwPh7XufQ0jS/plZP2cllLvCBwpkEdmCMOqEu2Kgf6l+nOWlqCEk/w7RyUzTlbKnNyOxYjrQutitrLIXQNWMDCzhuxNRwuaQBp7gsSaVeAaXkVL/rO+ysAw14sCQ6TPUzoDYYYAOcv1EaSvbWA2tgiqTxIhLL22oQk9lcqo7CBMUCrV4R0D0BtgDqoF8VxQ7EvE3P8rjly6vE+L1dFRI1kNI2+qKUUB4E35Kejfb4rci9se0Q2f1CHpTugBeW6T37k+cStqIo2T3ovC73SoLPD/Fyb8p
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dDM5WHlpcWtTUHorVTNjQXhSWFluQXRyVVhxUi91NGgvZHFhbUF0SHlrRHdK?=
	=?utf-8?B?ckdoaG0yWEYyRmhlc3NvVDJSTE9IQ1c4OXZ0Nm1qQlFxS24yYkQwZXM3ZWxH?=
	=?utf-8?B?VVRuZ0hSaSsvclZ1LzZJRDNJTElENDJLZ2NlYmMvWEg1UWJpSFZ2MWVTaDlU?=
	=?utf-8?B?amFUOGs4VEt6R3NKNHVTVkdmaU45NXBYUzN1YXB1TmhpNG9vRTFoWnNQT2xX?=
	=?utf-8?B?a2JKT0NEbEdXQ0t6a1lyckFSSFpIcUwrdm03ZGQ1ZUpJT0Zwbi9VVDF1NUhE?=
	=?utf-8?B?cmd0YS9Wb3FrYUVDUDlEQTJIMi9ZRGJ1blBHYWVKNnkyK1V0YzludlNrZ0Fa?=
	=?utf-8?B?MVRPais3ZGg4N1B2ZHI4NkNMalA4bEhVNnJJbW4rZEtZOTV5SjljaW82bHJW?=
	=?utf-8?B?V3JSUTcvZmt6WEgyUE13MGNlYmJGY0ovRjVNTUxaMktwbTE4NFNEcjFkMjNi?=
	=?utf-8?B?aGFSN01xaWgwa0l0bGVUVlNLYjJ0ckdyV29vRFdrMDZDc1JTbW9Rb2dkbmlC?=
	=?utf-8?B?N1NZTDhTOGUvc0VTK3J1VU5SWjRRbWZ1TW5TWk5MNCtxbEpiaVVVem8rNFQy?=
	=?utf-8?B?N2tlOUc3c1NQdGJnaTBuc2VVTzN3N3N0Qk55YnV4L2NjWHVVT09uVHFXaUd5?=
	=?utf-8?B?bTI5WXBnUnN1Zkp4WnRjWU9OU3YzNCtuZ2xjUXEvZ2xtckRMNjErbi9XRC9Q?=
	=?utf-8?B?SXZVeEZFaFBSRTByS3I1NU04dFZGbGNBRGVISkVDQ3piOFVCZ0dOYXJ2RmdW?=
	=?utf-8?B?ZU9QY2FRdGJqU004dTdiOElEVUNOMEpzenJtdzRDckQyY3pqRWpZQlFPT1Zi?=
	=?utf-8?B?c3FsTFRWdEJGZkVzck1md24xZTJhMkgvVjV0WVYyNWZ5UzJrTkI5SGQrUVMw?=
	=?utf-8?B?VXgzMmhmNTBvVURqeVZqNXVqc2hQaUR2bU4xWTQycjhWZ05HRFQ2SWZuVDZT?=
	=?utf-8?B?N1pnMnZ4WTJ3blBwQWk4QXU4bGNJQUhKRmFqUmhCdmF0cGhHR0kwOWpsbE9G?=
	=?utf-8?B?cmphY0JCVHZVM2VaQlluTXVYUzEwOUhMb3JqbUtMTnEzeDBzQVBwcWNGZ2kx?=
	=?utf-8?B?c3VSM3FHd2pWR0N6MFVOQityTnZCeG5FY0ppU2lyZVZzQnBnSXJXYzBCN1NX?=
	=?utf-8?B?cEtRcjVWVklrRmxRK0JJZHVUQ3FJSWFVY3B2Mzd4YmdrazNaV2w2bkNIYyt6?=
	=?utf-8?B?dVpVRnc0Q2RDdUNtNU9ZUWR1MHFtVnR6N1ZkRkszNzJOdEgraHZGTThxektG?=
	=?utf-8?B?ZFR5UmVJL0ZUK3BJemxjWHk1c2Rva3RsS0hPNzNleHduWXZRaWNncnlPejVP?=
	=?utf-8?B?ZkhNdkhJQ3pjVm9DbzFqdE41Q3JuRzNJMGtvM1VyakJqK3R3b3RkOGRPUVNs?=
	=?utf-8?B?VzF1eXA3OGNyckttWStMcTViQU10MTlQQUg4NlFGWGx3SUhLUGxxbEE5WGNv?=
	=?utf-8?B?LzR0SmJHdmphQzExaGhrUVhFZlpOVTJCQmFhdlJPTGVoaVhSQW1KcmEyRUl3?=
	=?utf-8?B?aC9hQkhKWWZYaHJRTXRnSkdUUEl4S3JQNHlrVk1WQXJwNFpWRXZPeW5NV0VZ?=
	=?utf-8?B?UnRTTjhMM2NuK2tNbVU4ZkhPOWNEbWNpUjdwQlBQNGdnRjJFc1pLeUg5MzZN?=
	=?utf-8?B?Y240Mmc1T2hLaHRkRDR6ZG9CUUpRUmxKd2VIVTJ4SVQ3RXZIRFlWMWJCd0xS?=
	=?utf-8?B?ZVd4Rk1GQnM1UDdFZlFpREVMeWZIaDFtV3l1bUxIcWN5akd3Z2syaFJDMCt3?=
	=?utf-8?Q?y4P/vUC+YGqWgfNbeu7W4ckjevJkFZWBuGCfL79?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e94c67db-cbfb-49e2-3b83-08d9140147bb
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 22:16:38.2134 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IggfOIr7C/U6W3qrA4B0pjxXWytc9d5kVY6c/BIJkFtYYKrNHHi6O+20F92U6Iz2fEZRKcnuroAit/KyiClmDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4274
X-MS-Exchange-CrossPremises-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 14
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission: 
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 73.231.9.254
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating;SFV:SKI;SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: BY5PR10MB4274.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	phishscore=0
	adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0 malwarescore=0
	spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105100149
Cc: cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 1/3] fs/buffer.c: add new api to allow eof
 writeback
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100150
X-Proofpoint-ORIG-GUID: K-LIrjJqIKS4t68O8x3EQukitDXkNtva
X-Proofpoint-GUID: K-LIrjJqIKS4t68O8x3EQukitDXkNtva
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105100150

On 5/9/21 4:23 PM, Andrew Morton wrote:

> On Mon, 26 Apr 2021 15:05:50 -0700 Junxiao Bi <junxiao.bi@oracle.com> wrote:
>
>> When doing truncate/fallocate for some filesytem like ocfs2, it
>> will zero some pages that are out of inode size and then later
>> update the inode size, so it needs this api to writeback eof
>> pages.
> Seems reasonable.  But can we please update the
> __block_write_full_page_eof() comment?  It now uses the wrong function
> name and doesn't document the new `eof' argument.

Jan suggested using sb_issue_zeroout to zero eof pages in 
ocfs2_fallocate, that can

also fix the issue for ocfs2. For gfs2, i though it had the same issue, 
but i didn't get

a confirm from gfs2 maintainer, if gfs2 is ok, then maybe this new api 
is not necessary?

Thanks,

Junxiao.

>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
