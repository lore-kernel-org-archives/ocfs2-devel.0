Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EED2C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 17 May 2022 16:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=xd8DjSHB/ta0houfRIbcYjD+5bDaMQxcFK7Bmb0vcSM=;
 b=xNmJU/EsOobNKc3pa1WR+nWdBv6zV0Tfo5j1qm/iSIOErAJv+YSt2VC2dlGkKGWNw3cFWxhlXVU3
   wt3rzyBaDrbJFYqdBFgH79dVdnVn6IIlnMXNZsraTONDAc+u2+alVAU2CcYT73KUoOAnzDHTnJca
   IvIKJx3oXykV8IWOAc6HYQUqlC8QY9PQUD2TyOCxCdP5yfUmQbJpYjGsXY7XUAW6JFrpuhuE8hdt
   G5WNHVQZ8PHNKpo2OeCXMsM06GgO+5A5By29G7t1MkR8kJkEuyuSh1AMTtayFuhJDZMKrk10TugI
   k9to8GbfB4kU5XtkyVzCAparGzBTromCqvcM5Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=xd8DjSHB/ta0houfRIbcYjD+5bDaMQxcFK7Bmb0vcSM=;
 b=Dqsqv933AjKagiJx7TQN7OkRPEvNfq9Cdb3KLNlM4/lWTwcriqUK+MNyzJS5b6MNPHKCx5DENFEx
   Zku7m7w4xOnyTzU4rQ9WpQ5EVFJ6e5iN5B6/VyVB43/Zf4PbFGnFi8aMpfFJarud37iT1gPsfyff
   XacnmDXz5TP0WpVRJoQw0atQza2CVrPOEl7O3zH0gJBVrsOeD/qcaxpTpo5cPHCzW2eV7ma7l7cp
   BdtSMdAAHrUMX8kAY6bdgi7oFeOPuAJnn+WcYBCzR8ncBx//qgz2BtB8nHi24P7bBFKNumr3PYi7
   HB3x+GKC9fA2e3JrW8JuZ0efiio2coiOUHXBLw==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RC1002I3BOJFS30@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 17 May 2022 16:12:19 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=message-id : date : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=FGPiMxSEVvVFc27/qnq8jbPHOmpyK8M+ZP8pcr80YZ4=;
 b=P1dSuNG5O9bHU2HyNYsmMFIWnmwtXiyqB4NBk8YP2kq6ICMtEEkpm6Je3EofcB+tklqz
 OH7YvtfPKyF2jz+nYiGrv9fJDTh4yBgFKCUx7iZ2AJxZ88nTUzk/FlxDutq7hmZTE0h8
 H/UcTbCCKyf9ZJCbh9rSFkb0clih5m21udtYRC+qsX75p4vqCw04030Ey+rULjlFID9S
 n2DjEXRvQ/8xHL9k+SwppXSYrOdFbnPeMekQVGezGeyX8STVZcay23n1GCsdDfc2lCG7
 OZ/SL1J1H4v7aMvVJk1XzZLmHL0xZjkmeGLAvGojokgWTgT+UQA5IAJLMv36A8Ngjtdh WA==
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z0K3l9bX0Gj+C2FMllJlSEx3r2WACWknCyidW6A4sj0Nmr5KE0Potb0v4M5HgL3aOu5+MNpqYby7qwRpFmrpRT5izKS7756FD7IXrkjT7j5XGC6Ez7Tyoaf+QLqvcSFe6IL8sEHQEW84/XtwdLPE0kU71cFq/YIMldpkEO9gPMG49LyviLHF51O3eb+3z0Lt1B+clncdDx70p3evXxAPSngQN7rtNFeDZ349USidgMxwZXVKZqhkEiSNcK8qyDYgcBHHXU27ixrJ+mJ5UTQ/LdGuH7mPw1ihISaNcT2AsLLwr+laRWvXRw4rmR2E4sk/zMdgb1kUuwWgcwVNDiQqaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FGPiMxSEVvVFc27/qnq8jbPHOmpyK8M+ZP8pcr80YZ4=;
 b=gOr6Uk8/4NY7jJGS5+sVgZOgVpWs3ng2EzZ1TSWZAlB6Ywa1dR7U9rAhLK4kU+QeN0nMzymBpm3aUmw0sPetYJDdblSsHNyB6Fi6tx5w2OtdXk9VsOehWSc4l3k1ytn3KBa6+Byi9D/SNQVHjmJXvswwCJX2RWn4OkVUO2CRisXRw+G6PEuQi762evqsRdbBx2ez3oQN9rUM2cyeh/kLuIOKDjauch7D1xGyJZSjq4M3j16N3J9FUtVgqTg6AzE9A3o+1MCVJdIXz7oZHOsFU7rOWyhutts8caL5hTqKivWKDHSBFyLdMY7UMtlF5k3nlIaHQ4jmF4zKtbVUaYO//Q==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FGPiMxSEVvVFc27/qnq8jbPHOmpyK8M+ZP8pcr80YZ4=;
 b=h7Uq3gUgRbWrjsapUnVNHM7GvqG4cvLpYNriPG5GGC0RzIn/WN7n+Huvwjwlb4xzQH2qfi/38PGud/CjpGncA6uXaJfZgnbT6+0kukSyX9glWE/HOrOBkVwNbY0+P7D1JrIXaBaNIOtHnN8xWIumNrLP/6jLS5FTJV8fJEVPskg=
Message-id: <e3daeccc-823a-665e-7068-4001114e7d36@oracle.com>
Date: Tue, 17 May 2022 09:12:00 -0700
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
In-reply-to: <362038a6-5ae4-3eb9-2426-159ac40b74a2@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 16:12:03.9877 (UTC)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,
 18.0.874 definitions=2022-05-17_03:2022-05-17, 2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170100
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
X-ClientProxiedBy: SA9PR13CA0157.namprd13.prod.outlook.com
 (2603:10b6:806:28::12) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3ef5d6e-4f62-4770-4a7e-08da381ffb55
X-MS-TrafficTypeDiagnostic: DM5PR10MB1579:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 mWF4ZhBK0ZSZmsycH5oTIHQKYSk23OoF1DSiJQNAN7LbuniP16PijlDW2gO0K2VdKwdsg87kXCxkf6kSrqG52CYR8bM6RZjJDwZV74svi92uZu44sooZOsHCNWSeU+ehvQw7YNwpc1WgYEnGLwzJwMKI585+9/Om9uVLri8Q5DoCtYAA9GLDQitCLVdKd62dGjzvKtN7j/zY4rsbHuSK8DwHxRmse9EKVx4uQLRxScR4s8LzjY170srCwMU1KEYwYmiQ4QeaFIwSQtMw8VBboOrXbJCjwuJx65/bAbD2QLxiFJFf6DEiuz0rkXfLJpPL0wX9AU7OJe6oGfqKdMeAerv906GBSXM5YleAbcY52taj3hI4eI4fqce/kUyOMMy7Yngr0yNy0yi/FhA+b1uK2TYUw77TdjH4atmzCDqvWlP2p4cQ4ccB8JKPVJObguxwNk7NyQ3HVjDxtU2HQsDzXNVpjyaQ6F+PdVLOLF0R3gunStvKX9LzHkLuMklw1fZXJ4s6tWql/+UXxi1xX2K04VN3xBRa3SblklDv3/nr7nriEHuLVyrku8FTsIa882ZYKNQyjGTi0vAyhuM0VVrus2OCbK4D2Ap/Fw3Rm5zLsTU=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 f3ef5d6e-4f62-4770-4a7e-08da381ffb55
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 X6ImKmdjyBZRnyDoJMQlkar9Ig4a2b1aBuDuMkpAW7owjm4af+1kHVTXqySAvh5iekYIJr/soVfJo2U3O4iOWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1579
X-Proofpoint-ORIG-GUID: IMDM3BuKyxhFVFM0NMKqVRBirv-G5Zoe
X-Proofpoint-GUID: IMDM3BuKyxhFVFM0NMKqVRBirv-G5Zoe
Reporting-Meta:
 AAHwETLqKrQsEPQLTXfroi1Q6meiGC6QGgj++Epe2RJLIvmh2pRXzaf0JIqwpzi7
 mrXE4xMfEmAhQ8FhTOui0OsRSX5GvlgQW5ebieKzGDEiSScKofBayt9c2Buy/s7D
 5jguOSRTnYJWPVSTlRPKkcZbmDhVW2WIk3Xm7fYNJrha840tUMBOWdcq5h9XutSG
 ba2+1M5HpERhez2sx4GzxTrH9TRSXZSqGHKGwKEHB+MwSH/wLbHq+MT9eFgUTI8P
 g29/kN8kr3C/gVilN2x0FV+oFNqfC4La9dTQ3bWXEwJTlVx/mvEJiTlhMqJDtmDR
 59Mk8ikMeE9F9kpWL8W4mqhInWN0CXLNXNGEv9GmwCcYmGUXGPp9IyxmzI73RWwR
 VhDVZgNGUQlXFXlDusV7rbL9+u0U2c83fsnh8f1cVQhsC9iIdLoyWzWMrViWQJcb
 uhV9wHDbmpi28iRk/lbjS/Lyy09nvaYZ6+QLAVMUEeP8oLjS8Rqy7oTc0WUkkv3s
 NOa3nVnuUs1rX7T4FKkKHCY7sHRLEf6Zq0c/aUPOS7a4Tw==


On 5/16/22 6:58 PM, Joseph Qi wrote:
>
> On 5/17/22 12:30 AM, Junxiao Bi wrote:
>> On 5/15/22 7:57 AM, Joseph Qi wrote:
>>> On 5/14/22 12:27 AM, Junxiao Bi wrote:
>>>> On 5/12/22 7:05 PM, Joseph Qi wrote:
>>>>
>>>>> On 5/11/22 7:22 AM, Junxiao Bi wrote:
>>>>>> The following function is the only place that check USER_LOCK_ATTACHED,
>>>>>> this flag is set when lock request is granted through user_bast() and
>>>>>> only the following function will clear it.
>>>>>>
>>>>> user_ast?
>>>> Good catch, that's a typo, should be user_ast.
>>>>>> Checking of this flag here is to make sure ocfs2_dlm_unlock is not
>>>>>> issued if this lock is never granted. For example, lock file is created
>>>>>> and then get removed, open file never happens.
>>>>>>
>>>>>> Clearing the flag here is not necessary because this is the only function
>>>>>> that checks it, if another flow is executing user_dlm_destroy_lock(), it
>>>>>> will bail out at the beginning because of USER_LOCK_IN_TEARDOWN and never
>>>>>> check USER_LOCK_ATTACHED.
>>>>>> Drop the clear, so we don't need take care it for the following
>>>>>> error handling patch.
>>>>>>
>>>>> Seems it depends on initializing lockres every time, but it seems this
>>>>> is not true for directory now.
>>>> Sorry, i didn't get this. Can you elaborate this?
>>>>
>>> lockres may be reused and if we don't reinitialized, the left flag can
>>> cause unexpected behavior.
>> I don't know how it could get reused since it's going to be removed. Anyway USER_LOCK_IN_TEARDOWN is still set in lockres. All the flow will bail out because of this flag.
>>
> dlmfs_inode_private is allocated from kmem_cache.
> The case I'm thinking about is, calling user_dlm_destroy_lock() without
> a valid ast comming before. So checking USER_LOCK_ATTACHED here may be
> incorrect.
> But look more closer, it seems that lockres is unused for directories.
> So it won't be a real issue.
Yes, lock is only for file, not direcotry.
> Could you please send a new version with update description?

Sorry, little confused, which part of description needs update?

Thanks,

Junxiao.

>
> Thanks,
> Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
