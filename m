Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64EECC433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 15:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9CBG1l+M1DfOYuynLjUV3opbm1GKkrsp/jUvT6d9Y14=;
 b=0ytNK2xWmlsYD6pojaGc3VuStuyPEKENVpAV9Lbm12YRRDoeVTNDfQN66TJOSYAi1emnBthTslkH
   C+Hw+STjE0xvvIXykWmgbZed8+UfMteWe2eRdgbOIGL44AsPTSbfBwYy06qGIWqLoYyksHhHIig7
   1G6e32cpE+NBOzHskaxRMic+cRCeneLXtbwT9edOZeA9mW3cw4wrsCEY8TILJDCo6H6DKsCiXKzb
   V+FPpDgsrAdB7sJi8FJxx/pT7AfCNpLges0KmRNDNMWAi4hAi6FUrfGEI/xTg6YDikA3DdwTEdD+
   I5OQFQTrEzURGlCommzyga8a4ksVj8EKOS9Quw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9CBG1l+M1DfOYuynLjUV3opbm1GKkrsp/jUvT6d9Y14=;
 b=RNYajKvePhBfJJr2yKv9tP9T3csaLMH09k2xzqXHgFFeYhyVHrWpZ6P+XU5a+jGcGU/+wCOk98S2
   mt+qRo0RlwLTJ9+t/fE1okDbEQr/6KKi86wCGqJN1kdCrutNYfeO1fJPfL1Gdp+hp3ryNulcIdqH
   rC5xrewmZ7FFJlc3Ekiekx+6bHkAdklUaaDejhLpTD+nmOUVKw/7tLlUdTm7XyqSBWm6jmFEKiJq
   Qk5O9MzQ5tz6/bBlYis/r7vrZkmwl/zqZcBWHAO9TKA5pVgV3ZyBbz0ATBYq9EahCEa+SB4hywKN
   h5EQTCFcIZ58mKJe9HwLPPAnsFN88ijyvNzT0A==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD200AD9B8R7W90@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 15:34:03 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=message-id : date : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=HNVdt2P/VG5jU2TpwZgefB+PJCjGba7ktBavJdMi3m8=;
 b=X3k3WSJGKn7UNsqI4iURTmGo6sdbRHtCaesZD3ipGiQTW4La8HkRlJCcCfBVB8AROcFj
 XgbbxsNhiQJVAI1PICaOfj1abmVeslU7Pxm0Fn7YYv/CxAufT2TeH83PKkh0xBJ/PrcS
 QzN29h0tIK4XpDVIyo2cV1EfeNPUoAH6WqQOK8dqax1TJxtbvLiS+yatZcWgmhnzWEMx
 8Q8G1x6CaFHxXUpAarszr7LvegZcptmkV9q5LdBKKl09FGi1lifCBxEbgpxMXxlQ65do
 s7Llf9KbO4cBwX6QAAjd4tnfadKEE7iNATgcR4Ja/CQiPySl0gIN+8Gp6s5Y/npnDdhx 8A==
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ob+0W9b9I5qKB2KoESYgWvJZG2nsCLSMmq3eIh8isLwoIOxNB2K0jMkQ7knSBqbQSEA+ytrAH/545xWu5lGs6Has4Pu+WMHzKQ5G+GrOi+WAukZwbaeWUctqGHKotpK/8Fc4wkcyVlRMMfXLPcsXnW7qZOADlOeLtyGflW7DHUHO3KhBOnOvh8TZd8vAvAj+e/a72CxCl6/QAs8jcVfLoTXoih5TpRuG7bT1jSvHv/cYMwVPp85hjbRTUCXCwbamqkMwN3KWH5/JCRsfk73//4lEbOhncUdi3P0///qiXoMpiKS4L3mgH62zRmDgqJwgoKV1kupyNtUPSrN4yZbHYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HNVdt2P/VG5jU2TpwZgefB+PJCjGba7ktBavJdMi3m8=;
 b=mfaWYEB0pDQKRCZ3FKR5I3ELg8ORlcthL3v20E3wq1NFDdHU7Xrnai5HyRj9kDeha2DPv0LyhpjfW7iaBdLlouVLoR+jadZBUKF/5VMGSxJga/Nf25fhVIIyAYr7BHZUGHcw9Ummhj9K5288lq575t3aVGbvauD9eBEF5iIGnuBYyy5Syii/CYwmF4gUARo+Egn7uRUZ1TEK323Snw1ENU0Q9DzMKj3bZQaroCYPd4OCuAV8cvYRuoi/FRJQe1ayMbyb99r2sXbLtRXB0gdmiGzbeFhAlVs6bZC5eQ8fNPJlkqIdEAL01rSyR5Y1hwOEpIDBaufMZ7Gnd26ixfGgIQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HNVdt2P/VG5jU2TpwZgefB+PJCjGba7ktBavJdMi3m8=;
 b=FQy0c7TzNziT4EWhsf0V5MgXa9yX8ssaD1FmF7duex4AAFgMJPe33bDvzwEGKAmpL9Q3Peq2BP+pNkbv9Wqo2HdCw8VOaD2TxyCxQbuRr6HU1Rn389dz8vEeAOhmLwbPLmjY59fcuGyxUG0eWcC8Nz0ucSWnLItaVYFOnFXGyFU=
Message-id: <c0902ca6-e6d1-a8fa-cb9c-4474a636bd18@oracle.com>
Date: Mon, 6 Jun 2022 08:33:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220603223122.43174-1-junxiao.bi@oracle.com>
 <ba010e81-5ac8-79f5-61c0-5aac46068388@linux.alibaba.com>
In-reply-to: <ba010e81-5ac8-79f5-61c0-5aac46068388@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 15:33:52.8056 (UTC)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,
 18.0.874 definitions=2022-06-06_04:2022-06-02, 2022-06-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060069
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: kill EBUSY from dlmfs_evict_inode
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
X-ClientProxiedBy: SN6PR2101CA0015.namprd21.prod.outlook.com
 (2603:10b6:805:106::25) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4538ace8-f940-408f-622c-08da47d1f5fb
X-MS-TrafficTypeDiagnostic: CH0PR10MB4843:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 cqbOHlDzOEHwO1Vp3X4mM3N3jj2N/CUXxZ2OnRCPHl4hjxY7HQ8/Iucw5YuCxZr9jtP1s/3gFemv4ke7DsHpKE936ssSl+Ji1bCe0n1v21WehORPXKl42iznsGH0rs7b4i/YVvT5tyN/yHqx5FCSeLOdXRo47AWIl46759d8Wi94nCXDsx8lcMbwS1ygu2Uc4vIxlNp2Dpo+ohAyGKm67by2N5P3Y3UACIvixMb7EvTFIoQRbUk2iyDaFixkt1BqBWBC+2cqbln+G7q1RD7W5G7NT7lX8dBdzYxg50csz5bBVGXTpk6aJc2+TehmPYBY1IryeIxUAUyngLVns6hvICF7tbUbgH83tmqhAsvPLEh4WKd3b1LtyYVWVrxC0PTbSvzHkuMQ6gsCSCFbGnpXrd9luGKXTOgndbxy7DAOFZeU4uYvk1v6aA9ymgyKm15qBcruGPPx4afTVVvhKjXwF26O/9SKLGNS1DRm2xnrnAEL6bYk19sTrx1fJFGwngLyzd0sc+Qz6dfzh+YSwrqNtLn8D7p4J6KkNOUkCzds/Vsg5yG7xX+l/xfOtqVz2wTQbB2Fu0sH1ivUONm1jx7NoCr7caIqky91c319qCZIEBI=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 4538ace8-f940-408f-622c-08da47d1f5fb
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 9omV6ZlrtgZZ5ME1erApt6U2OvvDOE7EzUKC6VYHPWnBscpeKPwsykHKwOmhYN3KT6i9Kr2r05BYcuPcgh+alw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4843
X-Proofpoint-GUID: T9W2YFS_2HEtbe1pGA-aC5lTBNRImoBV
X-Proofpoint-ORIG-GUID: T9W2YFS_2HEtbe1pGA-aC5lTBNRImoBV
Reporting-Meta:
 AAH913V6zfyq+MJ5BR1t2O8tt1E0sNNbaI7Z9S20PRfxc8EYORDlgnNl0EMvwaLq
 DHzsDQPw3T5sA63nVcbJqFAnUfHz/gGNoA9/u2FomyBZTYdSXrm6VahXWe3OquQd
 tmFxEmoTUvMwUvbYNf1eW1FN/vcIuYQkCvh8vC2Wnhy/G3CuUnWv4Lt7BPKLRD02
 LYogQxPk6jt/7Na5drq1h0nGB58eUbn4a0LZBbpc6RJmRBxOBae0hdnt3xThYjf+
 sAwvf5Ik5fiyWVWdH8mbs48KeWlt9CbCJoFx3LF1Pv8R98ZohqJ/8nKEwFMuMSUb
 pAs5auNBUCTdbYnPud088UePca2OnV475sQOet5lvone0dvtDBZGlcnAD0KEoA1F
 62Qt/Jt/GTdN2C8WkmLPwhQNsksk7g2s/I5vIkKFq/wAIpAyFI3boaV0JyB7YgJ9
 mMrHLJxRC+DM97UOqtci+wPFEfv8dzxFPSmHB6Uwil/jkJNLG7QJG5V6FS6K10kf
 03EYcSYxv4RG3LVlE/SmDtIcmfflszLGXRhFt18emi6X

On 6/5/22 6:46 AM, Joseph Qi wrote:

>
> On 6/4/22 6:31 AM, Junxiao Bi wrote:
>> When unlink a dlmfs, first it will invoke dlmfs_unlink(), and then invoke
>> dlmfs_evict_inode(), user_dlm_destroy_lock() is invoked in both places,
>> the second one from dlmfs_evict_inode() will get EBUSY error because
>> USER_LOCK_IN_TEARDOWN is already set in lockres. This doesn't affect
>> any function, just the error log is anonying.
> s/anonying/annoying
>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>> ---
>>   fs/ocfs2/dlmfs/dlmfs.c | 14 +++++++++++---
>>   1 file changed, 11 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
>> index e360543ad7e7..a120610dff7e 100644
>> --- a/fs/ocfs2/dlmfs/dlmfs.c
>> +++ b/fs/ocfs2/dlmfs/dlmfs.c
>> @@ -296,17 +296,25 @@ static void dlmfs_evict_inode(struct inode *inode)
>>   {
>>   	int status;
>>   	struct dlmfs_inode_private *ip;
>> +	struct user_lock_res *lockres;
>> +	int destroyed;
>>   
>>   	clear_inode(inode);
>>   
>>   	mlog(0, "inode %lu\n", inode->i_ino);
>>   
>>   	ip = DLMFS_I(inode);
>> +	lockres = &ip->ip_lockres;
>>   
>>   	if (S_ISREG(inode->i_mode)) {
>> -		status = user_dlm_destroy_lock(&ip->ip_lockres);
>> -		if (status < 0)
>> -			mlog_errno(status);
>> +		spin_lock(&lockres->l_lock);
>> +		destroyed = !!(lockres->l_flags & USER_LOCK_IN_TEARDOWN);
>> +		spin_unlock(&lockres->l_lock);
>> +		if (!destroyed) {
>> +			status = user_dlm_destroy_lock(lockres);
>> +			if (status < 0)
>> +				mlog_errno(status);
>> +		}
>>   		iput(ip->ip_parent);
>>   		goto clear_fields;
>>   	}
> As you describes, it firstly invokes unlink and then evict, but strictly
> speaking, flag USER_LOCK_IN_TEARDOWN doesn't mean 'destroyed', it could
> be destroying, destroyed, or even unattached.
>
> So how about just checking the flag like other places?
> Something like:
>
> 	/* Don't destroy lockres twice */
> 	spin_lock(&lockres->l_lock);
> 	(lockres->l_flags & USER_LOCK_IN_TEARDOWN) {
> 		spin_unlock(&lockres->l_lock);
> 		goto skip;
> 	}
> 	spin_unlock(&lockres->l_lock);
> 	status = user_dlm_destroy_lock(lockres);
> 	...
> skip:
> 	iput(ip->ip_parent);
> 	...

Sound like the concern is about the variable name, how about 
s/destroyed/tearingdown ?

Thanks,

Junxiao.

> Thanks,
> Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
