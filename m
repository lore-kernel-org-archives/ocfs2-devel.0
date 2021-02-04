Return-Path: <SRS0=QTdx=HG=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D8BEC433DB
	for <ocfs2-devel@archiver.kernel.org>; Thu,  4 Feb 2021 16:28:52 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C4AF064F42
	for <ocfs2-devel@archiver.kernel.org>; Thu,  4 Feb 2021 16:28:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4AF064F42
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114GF1Aa064694;
	Thu, 4 Feb 2021 16:28:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : references :
 from : message-id : date : in-reply-to : mime-version : cc : subject :
 list-id : list-unsubscribe : list-archive : list-post : list-help :
 list-subscribe : content-type : content-transfer-encoding : sender;
 s=corp-2020-01-29; bh=qNdHgLW6XrchpQEeQ5ebIA+0lEF14Nzig00yVFakUxI=;
 b=v3M3qhvL/BVGVes2Z2W+81fIHCbX6qvknAjNR/YJXNARK6CXUS5IEwGZOEspT0IAJXZw
 9798ueyEXHlCBceyVyWuvwAkm3eb08YiObZXjBgqHESy+bQnxklofiCjydPOLclmZ5Bl
 NXrlgiiQnHMZ3Hz0SGTsQktC35ZjgvqfZez4bqeFf//ZRe+a4rei/ySHccElMwd3LH/D
 wP1ScCGKFFMYTTtcaAfd4ZLpSqgA98PtPfZDmIezyPyCCypUl+vghBzSONVVRaal10XG
 u3oO4pEwCiNi/Gh1qqC32/3Nt8OCVTpivRSi2FfbVurYIr1oiSXkJb2QRQTNqOfHLVY/ dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 36cydm61w0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Feb 2021 16:28:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114GEgHY192724;
	Thu, 4 Feb 2021 16:28:49 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 36dhd1k2r5-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 04 Feb 2021 16:28:49 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l7hUu-000082-FV; Thu, 04 Feb 2021 08:28:48 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <wen.gang.wang@oracle.com>) id 1l7hUT-00007A-TM
	for ocfs2-devel@oss.oracle.com; Thu, 04 Feb 2021 08:28:21 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	114GGKnT097124
	for <ocfs2-devel@oss.oracle.com>; Thu, 4 Feb 2021 16:28:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
	by userp3020.oracle.com with ESMTP id 36dh7vce59-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 04 Feb 2021 16:28:21 +0000
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
	header.d=none; vger.kernel.org;
	dmarc=none action=none header.from=oracle.com; 
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
	by SN6PR10MB2704.namprd10.prod.outlook.com (2603:10b6:805:49::33)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20;
	Thu, 4 Feb 2021 16:28:19 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::d47:b19:f750:c969]) by SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::d47:b19:f750:c969%7]) with mapi id 15.20.3825.020;
	Thu, 4 Feb 2021 16:28:19 +0000
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
        Yang Li <yang.lee@linux.alibaba.com>
References: <1612408323-23579-1-git-send-email-yang.lee@linux.alibaba.com>
	<cea953c5-79e7-8bd3-13ca-8ee4f25ff03f@linux.alibaba.com>
From: Wengang Wang <wen.gang.wang@oracle.com>
Message-ID: <a1bfdae4-9b54-9797-22fa-0361292dbcaa@oracle.com>
Date: Thu, 4 Feb 2021 08:28:17 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <cea953c5-79e7-8bd3-13ca-8ee4f25ff03f@linux.alibaba.com>
Content-Language: en-US
X-Originating-IP: [71.198.166.82]
X-ClientProxiedBy: BYAPR05CA0026.namprd05.prod.outlook.com
	(2603:10b6:a03:c0::39) To SN6PR10MB2701.namprd10.prod.outlook.com
	(2603:10b6:805:45::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-158-151.vpn.oracle.com (71.198.166.82) by
	BYAPR05CA0026.namprd05.prod.outlook.com (2603:10b6:a03:c0::39)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11
	via Frontend Transport; Thu, 4 Feb 2021 16:28:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c94b834c-3111-4f22-3926-08d8c929e1e0
X-MS-TrafficTypeDiagnostic: SN6PR10MB2704:
X-MS-Exchange-Transport-Forked: True
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KQHm3P84YvpxK5iWkjD1L4xK5MH20/TKJPh4+i5X0rU02EEUlB9mfw28crg35Coqatl26PB8EMryj6n4nmrp1cFvnv/hDHlrsOUmAjaJLbkr//AB3JkSBu9oKDx4lVo5BNDd183Y5BoPwWLCNortHA05tQxX9KeAkvEVtuTIpxohprpFNwcYi4rbUDhDAMBFP2cUr171CDGFTN8m4EuEPXH0GBBBq0GpmDCeYCw3Werft8ueQ2EfmLQBhb9HjD9Y7ELa/mpqOxDV3whPQX9qu3ExjzttrBrDLrBDVGPk+u9XHyeh430Md0VsMtbA9BWR6flf39zw6mQYooOUAc9PXSINUQcLaIa9zcxwNuLEitkBfcCoie6slSVqmrdAAjwPclzD4Qx9fmr3FKfz6chynTCjv8SxYNMPgZELXFJ6aqPXbF/GrKLKUbyC4cUc8M1bGH5fCZPUrniAZ/vRaOWJd1KP4AYiC2oRZGUMr9hcbduwb7i5bnGMKvwZnPlw2ODmfFVFP49VIMoONlrvFlr9jZFfdskQqYEaWQXATvbEcGc=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SN6PR10MB2701.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cnUxeVdreTdvVHZJWWNUM2VaK0xzNjJBMEJxUGZkRm5tY211WHNtRC8xUzRN?=
	=?utf-8?B?QzF1d2lxdmxQS3J0ZFFEMndxTnc2M0xjWk9QalFhbFpPREtXQTh6bkpkcEp2?=
	=?utf-8?B?cE9qUDNPd2FRMmhGSVhlU0sySzllRGNWTVdKems5bE5yQk4vQnJ0Rm1nN3RR?=
	=?utf-8?B?ekw3K2xtMDhubkVpZ0lTWXBNT3l4SEc4aHVXOUNIcTZwVEtSRzFoVlM5VzZm?=
	=?utf-8?B?c2hGclUrTHdENTltWmMrNHE4aFBmbTdzMG15MlNxYlZ5L3luR2hLdVpLR2Vp?=
	=?utf-8?B?cHllWjgwMGZUb1hHdDBDaU1JQXR6NnZZc0trMUJneHBkQzFlLzd0b1BUZllj?=
	=?utf-8?B?SlFESlcrOXNKa3AxU0ZoRGttVHhVYmNmNVN1azNrMjVoWVpNMFJveG5qUFN2?=
	=?utf-8?B?cHVqR1hqK3NJM1VsWVZ1bjYzVUo3eDZDeW1NbEp3YVJxZUZBZFBtcVNOOG5z?=
	=?utf-8?B?VGp1NzZyTEF6Z3phZlB3RkZVSlZjS1BlTHNzZGRaNXpBdDduSC9YZFJIMm1J?=
	=?utf-8?B?aXdzeTQvZFhRbFEyZ2pRUk50SGx1T3pUb3pKRmFSMUlLMUNaMm5QWmt4SW9W?=
	=?utf-8?B?OFJBb0p4UUhkbE9ieHkyc0RnYWhlMkxqV0ZaT21FeVR3blZQdGRsV0NIYjdq?=
	=?utf-8?B?VlNXUlptU2tCYmVYU1ZLd2xVZVl0d0k2cExuRnFISFdpMVl6MXNGelNkRUsy?=
	=?utf-8?B?dVFNY1QwK2F1bGpabFQrOEo2akozVUhMVDJZYlgyLzBsZlBjVmYrMXZuZldF?=
	=?utf-8?B?dndqWitHRmlWSEJnQnBxQ3lNNGhXWThZMTZyMTI5dlBjcWx0dnVtUndvM3Ry?=
	=?utf-8?B?N3VZNS9HUkdYemdSeGt5RVYrUmZXWU5ROUtvdWlJU1B0Z00rYWJCNk01UzdF?=
	=?utf-8?B?RXFkUGtTRHg3NUplRHlYUnpDb1JMd3l3dkhjNlN3R2dDUGNZcVlpTlRvNjY1?=
	=?utf-8?B?bVE0dzQ5anBBeGNYMVZuMitGa3RPbVE2QVoreDd4cjMzeCs1Qk5uTkxpRXdo?=
	=?utf-8?B?QUhLMkR2K0VuNTdkZEN3dDMvR1FQaDVMRzRYN1VCVUJZSzg2Z1BCT0ttaE5F?=
	=?utf-8?B?NC9ORTBWVXpHTVlrK1ptMUNlNllodGgyUk5DODV1ZDRPYTJFeU82eU5vdjRH?=
	=?utf-8?B?czVwbXZRM3FLcVhkOHdHWHp1TW1zY3BEaitSU1hnUmJNSzhDV1VWU1ljbmJD?=
	=?utf-8?B?VzRnSzZhYXBVaExkRGJFb2hqMmg0RE05TmpCbUJrNlEvTzlTS2tYQ0hSTGJG?=
	=?utf-8?B?NjJvVS9aZUZNNGJvS0YyVTJvRDdSR0p3VXVReUtvWkxnckQ2SjdQMWtQaC8x?=
	=?utf-8?B?cmY5ZkxtbUZ6S2RVdTJFTmcyaEFJalFrbnV1ZzZYTWN2RjZPNGdVN0toR0Nw?=
	=?utf-8?B?MnRTdnFYTTMyVEZ0WVYwY25xRG5IUWZtTDRjZFRlOTRLT2hMQUkvaTVXNm1L?=
	=?utf-8?B?M0JzaWRrYUpXaER1Z2w1eE9SWXpoRXpwSTNCY0dtdUJybVFhdi9UcmVLODU4?=
	=?utf-8?B?ZFdIbkpOTkY3NzR6bGM1Y1VIeUlQZFFJNVh6ZmFNdTVMTEhZT1o5K0RsanZ4?=
	=?utf-8?B?ZndRTG5yK200SStIN0ZKeGxRT05uQ2J6elRDK3RLMm5MbUdSdW9GRytqR3Rp?=
	=?utf-8?B?aFo4bHNtanduT0ZWVEdUYkwxUFNSNysxcjRxMTdWdXhZR3VzeS8vUERjNFJL?=
	=?utf-8?B?WWwvYnY2TGFxM09mYmpkby9WK0xzOGZKMG9PNUNObkYzMGxpV1VtL25PK0dt?=
	=?utf-8?Q?kamLnJL/Ap7mNmTNxNBiz++OtAxfivzQD0Ac/Vu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c94b834c-3111-4f22-3926-08d8c929e1e0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 16:28:19.6034 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7CIp22tX0LHPOxEe9TNXpCFWoIvbVclTNH9iBlFYq0CUOjNwCg+I3z2F6noa52WHjP53Cw1tnGXfL8tDTZEYe60fCfnPnfYIvsdloMH75/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2704
X-MS-Exchange-CrossPremises-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission: 
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 71.198.166.82
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating;SFV:SKI;SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: SN6PR10MB2704.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
	mlxscore=0
	suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
	bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102040101
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: Remove unneeded return variable
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102040101
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1011
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040101

Actually I think the macro of map_flag() is ugly. Yang may want to fix 
that first.

Thanks,
Wengang

On 2/3/21 9:12 PM, Joseph Qi wrote:
> NAK.
> This was discussed before, please refer:
> https://oss.oracle.com/pipermail/ocfs2-devel/2020-April/014969.html
>
> Thanks,
> Joseph
>
> On 2/4/21 11:12 AM, Yang Li wrote:
>> This patch removes unneeded return variables, using only
>> '0' instead.
>> It fixes the following warning detected by coccinelle:
>> ./fs/ocfs2/stack_o2cb.c:69:5-16: Unneeded variable: "o2dlm_flags".
>> Return "0" on line 84
>>
>> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
>> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
>> ---
>>   fs/ocfs2/stack_o2cb.c | 4 +---
>>   1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
>> index dbf8b57..2da9633 100644
>> --- a/fs/ocfs2/stack_o2cb.c
>> +++ b/fs/ocfs2/stack_o2cb.c
>> @@ -66,8 +66,6 @@ static inline int mode_to_o2dlm(int mode)
>>   	}
>>   static int flags_to_o2dlm(u32 flags)
>>   {
>> -	int o2dlm_flags = 0;
>> -
>>   	map_flag(DLM_LKF_NOQUEUE, LKM_NOQUEUE);
>>   	map_flag(DLM_LKF_CANCEL, LKM_CANCEL);
>>   	map_flag(DLM_LKF_CONVERT, LKM_CONVERT);
>> @@ -81,7 +79,7 @@ static int flags_to_o2dlm(u32 flags)
>>   	/* map_flag() should have cleared every flag passed in */
>>   	BUG_ON(flags != 0);
>>   
>> -	return o2dlm_flags;
>> +	return 0;
>>   }
>>   #undef map_flag
>>   
>>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
