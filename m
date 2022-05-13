Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6ED2C433EF
	for <ocfs2-devel@archiver.kernel.org>; Fri, 13 May 2022 16:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ucDdrKpbJcMzZiqAXMgmEt7I7bsJQBUPUPMpWMf/DHc=;
 b=CpmfMZgYUC2e2jA+cqrl7XeV3anPEAR6oUgScRwF/lameHQelNv7eJ701YN/PoSUACEt8fVIEY8s
   ly5NBp35OnG7PcYBdz+qJ7Mek9CcAUG+Wf/Zgpr2e8glyuvtqBlOEcA9PiouGnMmyj69HwZLJUWv
   ixX/I/Dk/DHf9WaZRVm51QdfKcH6sRnw0slBh0lT0qS/v0EYAqzceyBCRYSLAN1cnL2/5Tp8Kphb
   e/2TfGV7rShO5alwN8opaRERTWcgRM3jnNeB2XEDz8kBfyUyn6TwkPk40iDyZ/75ZrMjsQyt4D6E
   9PT0daJtNcoV2UJ58Gwt2I3opisWucfe2otQ0A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ucDdrKpbJcMzZiqAXMgmEt7I7bsJQBUPUPMpWMf/DHc=;
 b=ZlQH7AB8UhBl/kDyb2zUXVGncVWnyOKmr7d/hUPtPb3LOHjmthXAAWx8wkTxxovuQJk2mKD5aHFK
   JqmFy9XLtZttJFZVWnheaEuToqNgGBI8ZTSAFMc0fjsbercpEwOHzPvtCFgKoAkuoGKdHawJf0/n
   3XRppwB1HsuLFjQj4JuLU8Uw5wVzYb1nQ0kMDfsMRq1MGWHAkN5TF7o19AWSxWV4vvjMJK1hMK8q
   yWYOQTSBqgdNa4fT/tT+gHOM+ZBPf78EgpAy7vBXQFsc3yVCQFMma1bS0S+zOhHO2O/adxyMphsS
   cmPmVi6T2UH9BaPbgsvQP7U2vIHqztiDX6vGSw==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RBT00IM6XQ4AO20@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 13 May 2022 16:27:40 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=message-id : date : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=UJzpyg56BAxSygzpWzxiQCbtkX7rPepCFcRIaf4yfMU=;
 b=qQhpATBSry0VEmAR4njFiC7IKiQhQxKrFjMqDkPDX8wX0fh++CvkGUzBMW8/y+0Oyz8t
 NobrmUf88AZ3dk/Lb+zEHrH1WN0Nug72LQpdfHMzkP+sayNdfNf5FNmcnq0NwXRFWvy0
 lsa2PptLSbUbmsl5h5TkBiNBWf2RK8TOd1aihNyI12JneRAzrvYTkSkbbethixGtNyxv
 J/i5CYd5+cbGzqL0UeMXWZDCTQ5UyxjVeDiLeKihpj5nGhRN2BurFyS7EasOfBu8iynZ
 4WWwIn3UFjKGvaH37hoFn8UJ86rRShzkpNxbAWkUchg/NOBL6+7qYMZ3AIsm00mJ5rzE ng==
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MciFJ+YjiiW4tBI0l7ULxMEI9tKD2+9/bemKkpDarUR7dZF/282xI+tYI1MywDHF7pB4onT/c19+3kPUlxhDdGWx2iS5pqSEK3CERGDY8Kd1dElXB77C3F/Tg4JkgeaPptlqi6mffQ4p/QH7sv+ywCQSnTsD885l8a8jlKowW1ZTlKj5uqZAE8HbHa28qrmWb2lnkxL4F2AS8MV//KA0UT6sWyEosWubfImkRomDC2gUQjAdpR8XMN16tRfrjTPVrLkh1rPvhemEmNt9cBOqUFAqWuNOrJE7W/1otRxvw2mBMHSazmuDeKH0xOOqDzyGUgMwoClRBk4GVK5TRtFDMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UJzpyg56BAxSygzpWzxiQCbtkX7rPepCFcRIaf4yfMU=;
 b=Ak17/nlJbA7XzulmDezssGi87P2iPttkBjBdmiOLvZZ8lXwR4C3KuzmYN80kHAcELqasf21kZ3QreUXyfxZagz15GE3SflGLboYt8gLJT3WfglAX9ZTilpO5IIc3AJ4BbNYKD0lddrQlFD4RRbo3VMIiNthfteKfJVPQg4AIJfuK88m9tKQKJfbrVVZllXyjE+IQxHZoN9rXdOuY7dhOV4RVnr0dyciUUdWAhELQqGYSPuyIS+C/rta5f2+n7q9T+QoLdRxgUM3zfcgCJRCT5lCtWPBeXQDfpQz8KbXHt2/RNSd9sNpGebgbzV53Uyr6Lb2E/Xxqw0dmKzs7snoysA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UJzpyg56BAxSygzpWzxiQCbtkX7rPepCFcRIaf4yfMU=;
 b=i9GJcLjFPJU9860QEsrJdfhoQKoF+fD+KQmU5OdJj+kCo7s+dCjbONe8cxzyP14QJbh+7Q72kQKm3dmzxbhjjsytzRF17SOUEhULqiBpKTS3kO3MI2rOD/v0a5NJoI7x40wxXwGSMihtA/K0P4Phk/Bdya/6NYRh3WBFqDCYAjI=
Message-id: <7511d9c1-c725-734b-a730-d493ddc37b43@oracle.com>
Date: Fri, 13 May 2022 09:27:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220510232213.23435-1-junxiao.bi@oracle.com>
 <cde723f1-db5b-d912-580e-04ddf6a0810a@linux.alibaba.com>
In-reply-to: <cde723f1-db5b-d912-580e-04ddf6a0810a@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 16:27:27.2223 (UTC)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,
 18.0.858 definitions=2022-05-13_05:2022-05-13, 2022-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130071
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
X-ClientProxiedBy: SJ0PR05CA0105.namprd05.prod.outlook.com
 (2603:10b6:a03:334::20) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f9d243d-2090-4369-b6ae-08da34fd77f8
X-MS-TrafficTypeDiagnostic: SA2PR10MB4428:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 HbOQIrWP7qz3ey3elYSAWCBan0Z26O2eBOiTVfSiBUKvFymRzsGacRajZoNp7JdNf0AR4FZb18JyNRqgS1NWjFeYJFxIymP/SNy56eTUTnQ7NCyoSrkQWhdKj50KUnWSLqsXUvm7VUoEtXO8D2I+scALga/ySqMtAuv86wh5KB2anhpFZJKUjPngsK1HHB3LCkkOEqbD68W0Z1Aj5lrhThTFS7NwUBjKZIGqu4pugBwHX7JxTZSL6NA59UMspuf1RLH7KXRA1ejaSW7IJm7j0N1sohuLCOOXRCR6jGig9sS1+KtdrB/Qb2H5OYKD20/jwZ1MacTNkhHD2PMIpzzyvGa+vPoyuSkRDvpVrXrhfem8Z+fJp9zvG2cViUtCtmDtI2OKyWHIAreQAUNKmBizdEtmhL734k/w+AhK2NQ414mfL7GJ9yu69Jk5v9kBY88ds105MlnWKztmWdgkg0K5DSkt0UbzUmJ8jMOgEX3DR4KoR+Cx+2TnRkE5+iyldXm7Sm5VNat8Z52pHfm/m/Y/rxb40dzHVLRL6bj6IPmbTk6pvnAXqFzWQ5GX4ca1wFOSqjNY61ffS17HEDRK3EGFgoMq2yeVmq3egxMEnoLvkP8=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 4f9d243d-2090-4369-b6ae-08da34fd77f8
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 pmfsEv6Z+DSMO9wDsLTplvObeDr+sZgQmYg+NEuLrTzjfygzcfdz77cDQWEIet/FDRGaiV67lS/YUph3EFXhkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4428
X-Proofpoint-ORIG-GUID: -Wbh23Gf1OKQf0YvvHsz1VUGHCNR26Nc
X-Proofpoint-GUID: -Wbh23Gf1OKQf0YvvHsz1VUGHCNR26Nc
Reporting-Meta:
 AAGTFlPgrINm3lJoWjVOMe3fK1xS/5oeM4i7OH+UJQlfcWATn2GdCa/vvpB83aoA
 2CjiHgjeKrkBIuK9nMUPtbLmFfM8ej5ctPSUaqA2uUWoau1ultgwggiY3qdF9aki
 OeBrL6pFjltBhfd0wk1z91FjPYFqCThxjtF9jDHR0vyGCxN8N5KwQld6NIejH+WA
 IcqEV5z6xjlqLpz0mpaCo9TjLbCuzKbShIIT4hW+1/dnsnrMIq+rz4CbxbBet4Mj
 f7564HzA3a8GLW6RuiI3n02b35nrf+l7/3QnkO4Pk98K9QJyhKX/pMB9qZLE/EMN
 AEG6hbCSO57p5fufTrZ3y4AODAocBGdUbVSUx80JUWb+UUTk0ootIJTrq9uXyXdk
 Z4HqqUM8ntxSpGqIKZiYx4biIaozLifMW6SreHHZTO9V8ueiZRug4l8vdWEwPgUD
 h85DYnyUTpdHNNYt5mD8/dPYhjr/mXv1dZOceItB9IJDyguJmtBQFuOtbStn5On0
 SpR49a5fJxhcU9ni0GRjCGXMT24m7V/aP29DWF+251Fs

On 5/12/22 7:05 PM, Joseph Qi wrote:

>
> On 5/11/22 7:22 AM, Junxiao Bi wrote:
>> The following function is the only place that check USER_LOCK_ATTACHED,
>> this flag is set when lock request is granted through user_bast() and
>> only the following function will clear it.
>>
> user_ast?
Good catch, that's a typo, should be user_ast.
>
>> Checking of this flag here is to make sure ocfs2_dlm_unlock is not
>> issued if this lock is never granted. For example, lock file is created
>> and then get removed, open file never happens.
>>
>> Clearing the flag here is not necessary because this is the only function
>> that checks it, if another flow is executing user_dlm_destroy_lock(), it
>> will bail out at the beginning because of USER_LOCK_IN_TEARDOWN and never
>> check USER_LOCK_ATTACHED.
>> Drop the clear, so we don't need take care it for the following
>> error handling patch.
>>
> Seems it depends on initializing lockres every time, but it seems this
> is not true for directory now.

Sorry, i didn't get this. Can you elaborate this?

Thanks,

Junxiao.

>
> Thanks,
> Joseph
>
>> int user_dlm_destroy_lock(struct user_lock_res *lockres)
>> {
>>      ...
>>
>>      status = 0;
>>      if (!(lockres->l_flags & USER_LOCK_ATTACHED)) {
>>          spin_unlock(&lockres->l_lock);
>>          goto bail;
>>      }
>>
>>      lockres->l_flags &= ~USER_LOCK_ATTACHED;
>>      lockres->l_flags |= USER_LOCK_BUSY;
>>      spin_unlock(&lockres->l_lock);
>>
>> 	status = ocfs2_dlm_unlock(conn, &lockres->l_lksb, DLM_LKF_VALBLK);
>>      if (status) {
>>          user_log_dlm_error("ocfs2_dlm_unlock", status, lockres);
>>          goto bail;
>>      }
>> 	...
>> }
>>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>> ---
>>   fs/ocfs2/dlmfs/userdlm.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/fs/ocfs2/dlmfs/userdlm.c b/fs/ocfs2/dlmfs/userdlm.c
>> index 29f183a15798..af0be612589c 100644
>> --- a/fs/ocfs2/dlmfs/userdlm.c
>> +++ b/fs/ocfs2/dlmfs/userdlm.c
>> @@ -619,7 +619,6 @@ int user_dlm_destroy_lock(struct user_lock_res *lockres)
>>   		goto bail;
>>   	}
>>   
>> -	lockres->l_flags &= ~USER_LOCK_ATTACHED;
>>   	lockres->l_flags |= USER_LOCK_BUSY;
>>   	spin_unlock(&lockres->l_lock);
>>   

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
