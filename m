Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 120F4C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 18 May 2022 15:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Dt++9Ht1g1zWUf7Ze8VXW2Za4ONjajEnR4qyWmm+hDc=;
 b=V5nm20yhTjobxV5E6uGr7vcw0inANeORaIcNp20SXjrw0PjCH84L5skSbMekp7MDCYEq75n2d+1H
   fZafPKK4h1M10hCySkXhidqMehoXSnnteQldhsJfXgrNGn6pcGDY/Cj7wtBafTr27vXHeqzvjMsN
   5l7zcnCsLn3uTi90+T0qFV746I8PFMCuAecfL/guWtzh/c0Nchyt/PiNQFvIpVtuJbzX/awWB+7K
   KVUBYZUXS3SxPhJmtCYX4IbuDumgeO+mR9YnS1T8Fl4vvwy5JPVD0dbWJX+t0JVHxL+LccW1Bjel
   Jx+DrBiwW8TMrZQ9/83XB+PZtNCKvID8DU0cOQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Dt++9Ht1g1zWUf7Ze8VXW2Za4ONjajEnR4qyWmm+hDc=;
 b=SiElOZIU5obPJ9P8RF/HDKsihyN8vqB/PM+UbL+zDqwGa6yuRtclzYwLvDGO7rPc15k5wzQOWNeY
   Q5KLWaDqxSQZvT5W737y8rG3V45BryFF3nirdLNcm89ev7uZeC+1HRHju+MGr4T1ZudFF6pHCGG8
   kWpwRrByL+Sl3dpICTxt4xewnimaUnxSDw3PEOAihUHcmWtzFgnRTReV4i4r0X+dFis1F7ZVPevP
   nnjL2EfRxFJNwn/5TiISeCuQKkUxTX3LYGPZnvK796MYgCzH/cfOYme7LrovWbpzMqqWIZhmWNYw
   8XeDPEN2uSiIo1f+DYpo5IKRNE0L+pI2ZDUHGw==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RC300M595JFN620@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 18 May 2022 15:54:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=message-id : date : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=jir9KvrgBw1otR4VEngfygxZW776JpccVzbVfCD3ol4=;
 b=VeagBX8I8W4XFbzG7i1em64SPESER8uJxcmnd1/4Ym23eAZj9PGthMIWKfsZmEgfcFdO
 GcaiOfbZRLZvdNOcsNq1RI/MwDNbfaQgVL+tAqV2i6tokae+9v8zyqrZ1hNQNmbbk+zA
 INEaa5ML9IN1zp9/Y9RxQ15aJlGZDbtil6I1tARQvBj2jCnAyotE8uFNJKqnQNOvXOMM
 Kepw7tAY1DBJpRDjYtF0k9/aRCj6PaTK9BUM3ObOmJ3JWgXbw9QK9xJqb8MiXjruanxh
 xX49GMHB3Iio+P3JVWuYB8KCPhqQkIcW1ePJSTjO90+7iFg4yCWgs3s2Fz1XqDAH0mYO Ow==
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKcD0uuY7Pb+A1r6FFhx8W4qL4cvWdRNDfQW27lZf89MX7uZ4C6kRiCxV38CsyXaue6cmpt5h9jTz775IHTJn3K8cUH+phG6r+hKODDBLsbYFY2UAxX5QzQdWTmOhYJyuSE23W5EtBpmTbisqx2vTwN1/n3t9QIFm2w6yo6ttOlCAtlNP+LjnDj0C9Yz/aXCyawOwUUi6Tvmf/5oEZGdQChs0tXkZjxD9QC+y3ndkRwMvSDui0KiE4ga9gt1MJxjpMAgx3qhgO9LGZKLjHGppW240P3Od3m7Afcb9bbtFVEvq7Lhi4VCLOFZeSeEBBoaekqmpniBcztUYT3U/uobeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jir9KvrgBw1otR4VEngfygxZW776JpccVzbVfCD3ol4=;
 b=KD60iSbrE5jX/49/hG5Bg2JkHgzdM8f8VVjKhIMECRVaMkzVx1bdYlwQj9dfsIn9FR8GOWmxPIAzHBd6+QpSZ3/yE0WchvTKyEsJo2jtBUBejoMT87ZIS2SgyASTHk2WKDuAuf7ZkmJxh+UYXCasoeFHcnHchOM08RZ0ETiUp+JHr+trH/LliQ4Fxad5QjGIcXkJ7L5a0Nj+oeLQTWEXV992xLx4qUZbrCbt5RVKwi/oIW+hKVSGKrQIZRsHN6AhuvMZYTOXei6Swbre0t+OO+RoBiRqMCElExeeeidORAq9SEpV54T3Pv/W3LY99pKRm8KhShQ5hGikXXiRJi+pHw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jir9KvrgBw1otR4VEngfygxZW776JpccVzbVfCD3ol4=;
 b=BEz6n6L/OZx54Gwu0MenmiSPpAZl+sVkeBRIBRawif2YoT0aXa+pOFicQlbJ2oniiuPTGwpUkUJehSPKcnzBUgTApJXTc3B9IydRBOb2whZ3oJiAthuraR5E9f9SFhDx47M3rfx85dkaqw0hIyZFuyvJ5VE/TGn8oA5Ag860Y80=
Message-id: <edb5fe9f-a6bb-e70b-ef94-eee606f78ff4@oracle.com>
Date: Wed, 18 May 2022 08:54:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220510232213.23435-1-junxiao.bi@oracle.com>
 <cde723f1-db5b-d912-580e-04ddf6a0810a@linux.alibaba.com>
 <7511d9c1-c725-734b-a730-d493ddc37b43@oracle.com>
 <7b620c53-0c45-da2c-829e-26195cbe7d4e@linux.alibaba.com>
 <cc181847-abc9-f6b4-fca0-8d59d0ad1d7c@oracle.com>
 <362038a6-5ae4-3eb9-2426-159ac40b74a2@linux.alibaba.com>
 <e3daeccc-823a-665e-7068-4001114e7d36@oracle.com>
 <0277d743-1e03-89f5-38ec-1b833e8f5e43@linux.alibaba.com>
In-reply-to: <0277d743-1e03-89f5-38ec-1b833e8f5e43@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 15:54:29.1142 (UTC)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,
 18.0.874 definitions=2022-05-18_06:2022-05-17, 2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205180094
Subject: Re: [Ocfs2-devel] [PATCH 1/2] ocfs2: dlmfs: not clear
 USER_LOCK_ATTACHED when destroy lock
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
From: Junxiao Bi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Junxiao Bi <junxiao.bi@oracle.com>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: DM6PR14CA0062.namprd14.prod.outlook.com
 (2603:10b6:5:18f::39) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10fbbab3-1bd6-433e-8203-08da38e6b0e1
X-MS-TrafficTypeDiagnostic: DM6PR10MB3836:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 XUBTmjxMKFFzPyl7S3Rk4uMenkxNaoBTJhOCF4mWIUEF23d2aN1dvz+7jtAc3VSNEBM1MCWGS4DV7o4aKPImZnWO0+3ct14o7o+kkSarPctgzQFooJiLF+Cp3wdXroBcv50+BUqRe8vgWZ1fVr+79RSf+M+2uOIgY0z/XLpeWum6RX8eJdkXhZ9rxTkLKKTP9nQsItiJEodYOhGWaeY2tVtzZrW0LOrG4Nfpd7rrFJJ75ZrZNBegZTcsn3hA1+Lliq7OOfl2m161S1VFfPJ1ehVG1PgZ4X3kwzccCPztNUiArP68Sn8QdgBQAwHCjJ8A8tecKNT/L4doBAaemFkT7k8jNsqm5B8dqcYdOvXnnXxjiUm1oZUT8xWymH+cZOd7ZVKKcOqFllYqk4q61lsPmNXTchSDzLKj1UnSGmwWqj7Hhw1qB6/TZbMvMVkKMVf67h4vCXzFJC85XX57GwCVoBl0xcj7Sxi9V1qz6Rk3TVE+jzIHJ2GUz9ut1nOK+5diFknF8XpG7csrN2XK+HQkhCiVUl70KitBRKPO5Dk0gWaqQXn01Zlc/J7KsvGMH0JshFh7Zol96bS8HTUFzm6cLFTZ54O7gBzoSYYfYX61t9c=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 10fbbab3-1bd6-433e-8203-08da38e6b0e1
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 CY35Ci6+HIJsCUeL7is71BD58ZBdGe2+F7W///bHwYlWIbv2k0mBtbhdOSlnIAtdvg/+xZsKKLXe41y0kOHzGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3836
X-Proofpoint-ORIG-GUID: n4NZ3KvQsFGMesj8caAXdab27H1Syh_W
X-Proofpoint-GUID: n4NZ3KvQsFGMesj8caAXdab27H1Syh_W
Reporting-Meta:
 AAEYJ+RUP8KtyOSHEPiI7WRPcHx1kxG6Fxz5pBf2n0UZbqSly/ZBOPekBevF6PmF
 +ySRWKNPFjwV8VhCq8Z0ZI7i8jREHbJvoP86+gfxLg2rorv6bPN4ZI6xaD0nKbe/
 +Sri2hTreNbkfh7eLgjIkqyd8uUloseVYtDJfMtYmVhrNOcfCaRW4n4NQ7wwc5Lo
 WPLx1KYskRDCacs0CN0D7ADxLVHlIQqzFdHctrzsCn0eTbe/wCjX65mtrVoMgVj+
 6PYP9hfaj18mZusqm2mzRl0eQVU678JG0FCX+65d6X5ix/wbaN5z24JHXZiOicMv
 6nVxr5gzvxy8ZECBkAveko4fZB9W2edvwFjotnYbnXo4y38/aANHO9ATGFzJp+O0
 9QTwTRUZiU+1yZ29z4+nXgkKKEeD0duTxiu6RFYV2tc3o3Qtw9Jekm8oM+klMXEH
 39x0g3bFf/PiUrbqX7IIAssrKm1nMRszFrTA472PlCGaWalk/pydfXUGZboTK3Kp
 Abv/nolvsZvrtu/d7KOcjL/NHeS9Q+C28uZSp0behd+N


On 5/17/22 6:54 PM, Joseph Qi wrote:
>
> On 5/18/22 12:12 AM, Junxiao Bi wrote:
>> On 5/16/22 6:58 PM, Joseph Qi wrote:
>>> On 5/17/22 12:30 AM, Junxiao Bi wrote:
>>>> On 5/15/22 7:57 AM, Joseph Qi wrote:
>>>>> On 5/14/22 12:27 AM, Junxiao Bi wrote:
>>>>>> On 5/12/22 7:05 PM, Joseph Qi wrote:
>>>>>>
>>>>>>> On 5/11/22 7:22 AM, Junxiao Bi wrote:
>>>>>>>> The following function is the only place that check USER_LOCK_ATTACHED,
>>>>>>>> this flag is set when lock request is granted through user_bast() and
>>>>>>>> only the following function will clear it.
>>>>>>>>
>>>>>>> user_ast?
>>>>>> Good catch, that's a typo, should be user_ast.
>>>>>>>> Checking of this flag here is to make sure ocfs2_dlm_unlock is not
>>>>>>>> issued if this lock is never granted. For example, lock file is created
>>>>>>>> and then get removed, open file never happens.
>>>>>>>>
>>>>>>>> Clearing the flag here is not necessary because this is the only function
>>>>>>>> that checks it, if another flow is executing user_dlm_destroy_lock(), it
>>>>>>>> will bail out at the beginning because of USER_LOCK_IN_TEARDOWN and never
>>>>>>>> check USER_LOCK_ATTACHED.
>>>>>>>> Drop the clear, so we don't need take care it for the following
>>>>>>>> error handling patch.
>>>>>>>>
>>>>>>> Seems it depends on initializing lockres every time, but it seems this
>>>>>>> is not true for directory now.
>>>>>> Sorry, i didn't get this. Can you elaborate this?
>>>>>>
>>>>> lockres may be reused and if we don't reinitialized, the left flag can
>>>>> cause unexpected behavior.
>>>> I don't know how it could get reused since it's going to be removed. Anyway USER_LOCK_IN_TEARDOWN is still set in lockres. All the flow will bail out because of this flag.
>>>>
>>> dlmfs_inode_private is allocated from kmem_cache.
>>> The case I'm thinking about is, calling user_dlm_destroy_lock() without
>>> a valid ast comming before. So checking USER_LOCK_ATTACHED here may be
>>> incorrect.
>>> But look more closer, it seems that lockres is unused for directories.
>>> So it won't be a real issue.
>> Yes, lock is only for file, not direcotry.
>>> Could you please send a new version with update description?
>> Sorry, little confused, which part of description needs update?
>>
> The typo that user_ast() is for granting lock request. And better to include
> the information we discussed above.

got it, will send a v2

Thanks,

Junxiao.


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
