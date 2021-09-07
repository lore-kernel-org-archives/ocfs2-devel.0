Return-Path: <SRS0=sHJd=N5=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49CE7C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Sep 2021 15:57:17 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EC74860F25
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Sep 2021 15:57:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EC74860F25
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 187Ee9ZE008807;
	Tue, 7 Sep 2021 15:57:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : references : in-reply-to : content-id : mime-version : cc :
 subject : list-id : list-unsubscribe : list-archive : list-post :
 list-help : list-subscribe : content-type : content-transfer-encoding :
 sender; s=corp-2021-07-09;
 bh=3AARU8VVNyt3iaHnHn9jvIqWe1L5vZKjo3WdAP52kcs=;
 b=brN1iLLUW+43S8Nux9Z0op68Im5+TEwYLN02i9bAGbXItDJDxDu4bvQZ1caF/LqFtOJY
 IVcZSJaxlr3qEgPoLcxfF8zsxJhyomW41fGFZWllEglG2z4YTEw0BTn6F3eaqzTgClGz
 CdPTgGzoxxp7mJCzGCrwrjcoFdXL+Z/WGBU22+CATLxoR0CEN2jCxNHw6VY2n6Q+sB9H
 1tDGKm1vl52A5ssdsBkijkhLRWEtK9F2hNCRR1Ci1l/OyBHRpd9/c0iGVKCEg3ICXD6t
 nVS6jP8ZAJ/YaLpGmgctDdntmK5kZuOG4jSpmXE5w0SWdnNXEczSg2M1otP0plQjVtQO qQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : references : in-reply-to : content-id : mime-version : cc :
 subject : list-id : list-unsubscribe : list-archive : list-post :
 list-help : list-subscribe : content-type : content-transfer-encoding :
 sender; s=corp-2020-01-29;
 bh=3AARU8VVNyt3iaHnHn9jvIqWe1L5vZKjo3WdAP52kcs=;
 b=JJrTt1nD5l0WqxBhm+ak6C8UTUAz1icxXYK/WgnELobcl0H0PS4mWDMg0YGorc63oWrJ
 0Ox7CxPeXLqj5UMBzIYTqss7vr8olr9uka2jg6ube6M08hM928Ps3KCAC2BALZLnxwSs
 0EkpofPoO5p3X3dsuUOy/g1/0QeGQM0vNuHadIcPWPEdSzcWFB+KLS7CdVqjhBEjvEvE
 7lSakxUR9HEButh3dMfJT7op4q+tfQYCpT10RvHachi6yroM0odNW3GKsFEmX8mWRGE1
 RwUyQA2fCqHNMzK25UDpAS5fac1XHyFEj6I4oDGQ1H3UnStRxjxe+bM8AiUo/Do7nwnD zQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3awpwktf3g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Sep 2021 15:57:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 187FsnvD116778;
	Tue, 7 Sep 2021 15:57:14 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3auwwx3un5-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 07 Sep 2021 15:57:14 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mNdTE-0004DQ-29; Tue, 07 Sep 2021 08:57:12 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <wen.gang.wang@oracle.com>) id 1mNdTA-0004Cv-3H
	for ocfs2-devel@oss.oracle.com; Tue, 07 Sep 2021 08:57:08 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	187Fu3gn163611
	for <ocfs2-devel@oss.oracle.com>; Tue, 7 Sep 2021 15:57:07 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com
	(mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
	by aserp3020.oracle.com with ESMTP id 3av0m4ssp6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 07 Sep 2021 15:57:07 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
	by SN4PR10MB5541.namprd10.prod.outlook.com (2603:10b6:806:1e8::22)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22;
	Tue, 7 Sep 2021 15:57:06 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::64da:7ae6:af82:ebfe]) by
	SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::64da:7ae6:af82:ebfe%5]) with mapi id 15.20.4478.025;
	Tue, 7 Sep 2021 15:57:06 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Gang He <ghe@suse.com>
Thread-Topic: [Ocfs2-devel] [PATCH] ocfs2: avoid getting dlm lock of the
	target directory multiple times during reflink process
Thread-Index: AQHXnjEQ7mXexg5a5UWyHghQ8QAQ56uYxZ+A
Date: Tue, 7 Sep 2021 15:57:06 +0000
Message-ID: <3FF09C2E-2855-457E-8533-50BBD8EECEF1@oracle.com>
References: <20210826075941.28480-1-ghe@suse.com>
	<744d756c-7640-d312-37ef-126755324e8a@suse.com>
In-Reply-To: <744d756c-7640-d312-37ef-126755324e8a@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: suse.com; dkim=none (message not signed)
	header.d=none; suse.com; dmarc=none action=none header.from=oracle.com; 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3114647-82d1-4005-9b41-08d972182452
x-ms-traffictypediagnostic: SN4PR10MB5541:
x-ms-exchange-transport-forked: True
x-oracle-tenancy: 1
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fmEFX++i24ABYO/355HEEUzg0LooHjs7X2+vUEJI0WbOhbQpGBxBrUkjENRtQk3MOScYqMTi8nqE1QSi1A3OjH7nnzfO8gBTK8u5dNZYLSpi6mMZCNIfOGERwDfg17PF3BrkbG9BMtXjF4INCHwQz36yVj28A1+NBOjBxVkAmXkbopI1WFFZh9wS7nU7De4pSpFjj8s+FKSZ9e9jArB1c2POHCZTX2dUtcJ/fQBeEO9bW9UC/gYv7mMtejDH2Z7YW6JDLeviRLC9wjOyEYxEFAjpe1hKHoyyCmgbFHJ4VY+j9C0Uz7wK73cwMHFDwpfMU/X0NZgzz9VfeSP7PT0VAAqgwkgKjyRkZao0DOM+6ziRipJKda9+SW1eozIKMdVhk/T+Km01Wtbs+ujxEyvBWWtG2oxKTVnfsqXAsOdz7bD+SqLx/WsTT8k3VQp6KpmwHi1whdZ1xWur6z3+mZYtS0uOXXukObjD7PIIXxvHz8tiT48nWBr2PQ/B43CWONh4ZcM0SQEDrT1mcvi2f/VjFRLdCZNvjwKsfbev45HUD1JoB6/iug+YljMkf7PsqsXJBHalb+G2LV+1ERZJKe5pYQ7kmaKJBzAYTKsxuaugyoKetQ204oxu0egGNqT1GeKwXjFVsdznPW3J+gvyMx4HUv4wEibt8Oo0pg+t08hYXY6ZNv7bV+MCbBHQBv8uf2KR
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SN6PR10MB2701.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
Content-ID: <8148C25A8015E74F863E82B93E436038@namprd10.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3114647-82d1-4005-9b41-08d972182452
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2021 15:57:06.3411 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fqUepSkiqdXWjLk39HaSyOWbTU3+jlcrAyw4gj8U6bsooWmJlVnjN07bduUVV90QyvEoORIat3k0bnOtH7YDVxJWxDV5sP3TxtinnwZmHJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5541
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 04
X-MS-Exchange-CrossPremises-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-originalclientipaddress: 2606:b400:8301:1010::16aa
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating; SFV:SKI;
	SKIP:0; 
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: SN4PR10MB5541.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10099
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	adultscore=0
	phishscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
	malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2108310000 definitions=main-2109070104
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10099 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109070104
X-Proofpoint-GUID: eh22pz4VBGGsyU0X2KhnfT0u7brBEbdI
X-Proofpoint-ORIG-GUID: eh22pz4VBGGsyU0X2KhnfT0u7brBEbdI

Hi Gang,

Sure, I will look into the problem you are trying to address. Any bug fix and performance improvement is welcomed!
Well, can you please provide the analysis on the tcpdumps between the (two) nodes that covers the reflink operation with/without your patch to show how you saved dlm locking ping-pongs?

And what cases did you test to get better performance?

thanks,
wengang

> On Aug 30, 2021, at 11:25 PM, Gang He <ghe@suse.com> wrote:
> 
> Hello Joseph and Wengang,
> 
> When you have time, please help review this patch.
> About the deadlock problem which was caused by ocfs2_downconvert_lock 
> failure, we have the fix patch, it is very key.
> But I feel this patch is still useful as a optimization patch, the user
> case is to reflink the files to the same directory concurrently, our 
> users usually backup the files(via reflink) from the cluster nodes 
> concurrently(via crontab) every day/hour.
> The current design, during the reflink process, the node will 
> acquire/release dlm lock of the target directory multiple times,
> this is very inefficient in concurrently reflink.
> 
> 
> Thanks
> Gang
> 
> On 2021/8/26 15:59, Gang He wrote:
>> During the reflink process, we should acquire the target directory
>> inode dlm lock at the beginning, and hold this dlm lock until end
>> of the function.
>> With this patch, we avoid dlm lock ping-pong effect when clone
>> files to the same directory simultaneously from multiple nodes.
>> There is a typical user scenario, users regularly back up files
>> to a specified directory through the reflink feature from the
>> multiple nodes.
>> 
>> Signed-off-by: Gang He <ghe@suse.com>
>> ---
>>  fs/ocfs2/namei.c        | 32 +++++++++++++-------------------
>>  fs/ocfs2/namei.h        |  2 ++
>>  fs/ocfs2/refcounttree.c | 15 +++++++++++----
>>  fs/ocfs2/xattr.c        | 12 +-----------
>>  fs/ocfs2/xattr.h        |  1 +
>>  5 files changed, 28 insertions(+), 34 deletions(-)
>> 
>> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
>> index 2c46ff6ba4ea..f8bbb22cc60b 100644
>> --- a/fs/ocfs2/namei.c
>> +++ b/fs/ocfs2/namei.c
>> @@ -2489,6 +2489,7 @@ static int ocfs2_prep_new_orphaned_file(struct inode *dir,
>>  }
>> 
>>  int ocfs2_create_inode_in_orphan(struct inode *dir,
>> +				 struct buffer_head **dir_bh,
>>  				 int mode,
>>  				 struct inode **new_inode)
>>  {
>> @@ -2597,13 +2598,16 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
>> 
>>  	brelse(new_di_bh);
>> 
>> -	if (!status)
>> -		*new_inode = inode;
>> -
>>  	ocfs2_free_dir_lookup_result(&orphan_insert);
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
>>  	return status;
>>  }
>> 
>> @@ -2760,11 +2764,11 @@ int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
>>  }
>> 
>>  int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>> +				   struct buffer_head *dir_bh,
>>  				   struct inode *inode,
>>  				   struct dentry *dentry)
>>  {
>>  	int status = 0;
>> -	struct buffer_head *parent_di_bh = NULL;
>>  	handle_t *handle = NULL;
>>  	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
>>  	struct ocfs2_dinode *dir_di, *di;
>> @@ -2778,14 +2782,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>>  				(unsigned long long)OCFS2_I(dir)->ip_blkno,
>>  				(unsigned long long)OCFS2_I(inode)->ip_blkno);
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
>>  	if (!dir_di->i_links_count) {
>>  		/* can't make a file in a deleted directory. */
>>  		status = -ENOENT;
>> @@ -2798,7 +2795,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>>  		goto leave;
>> 
>>  	/* get a spot inside the dir. */
>> -	status = ocfs2_prepare_dir_for_insert(osb, dir, parent_di_bh,
>> +	status = ocfs2_prepare_dir_for_insert(osb, dir, dir_bh,
>>  					      dentry->d_name.name,
>>  					      dentry->d_name.len, &lookup);
>>  	if (status < 0) {
>> @@ -2862,7 +2859,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>>  	ocfs2_journal_dirty(handle, di_bh);
>> 
>>  	status = ocfs2_add_entry(handle, dentry, inode,
>> -				 OCFS2_I(inode)->ip_blkno, parent_di_bh,
>> +				 OCFS2_I(inode)->ip_blkno, dir_bh,
>>  				 &lookup);
>>  	if (status < 0) {
>>  		mlog_errno(status);
>> @@ -2886,10 +2883,7 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>>  	iput(orphan_dir_inode);
>>  leave:
>> 
>> -	ocfs2_inode_unlock(dir, 1);
>> -
>>  	brelse(di_bh);
>> -	brelse(parent_di_bh);
>>  	brelse(orphan_dir_bh);
>> 
>>  	ocfs2_free_dir_lookup_result(&lookup);
>> diff --git a/fs/ocfs2/namei.h b/fs/ocfs2/namei.h
>> index 9cc891eb874e..03a2c526e2c1 100644
>> --- a/fs/ocfs2/namei.h
>> +++ b/fs/ocfs2/namei.h
>> @@ -24,6 +24,7 @@ int ocfs2_orphan_del(struct ocfs2_super *osb,
>>  		     struct buffer_head *orphan_dir_bh,
>>  		     bool dio);
>>  int ocfs2_create_inode_in_orphan(struct inode *dir,
>> +				 struct buffer_head **dir_bh,
>>  				 int mode,
>>  				 struct inode **new_inode);
>>  int ocfs2_add_inode_to_orphan(struct ocfs2_super *osb,
>> @@ -32,6 +33,7 @@ int ocfs2_del_inode_from_orphan(struct ocfs2_super *osb,
>>  		struct inode *inode, struct buffer_head *di_bh,
>>  		int update_isize, loff_t end);
>>  int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
>> +				   struct buffer_head *dir_bh,
>>  				   struct inode *new_inode,
>>  				   struct dentry *new_dentry);
>> 
>> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
>> index 7f6355cbb587..a9a0c7c37e8e 100644
>> --- a/fs/ocfs2/refcounttree.c
>> +++ b/fs/ocfs2/refcounttree.c
>> @@ -4250,7 +4250,7 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
>>  {
>>  	int error, had_lock;
>>  	struct inode *inode = d_inode(old_dentry);
>> -	struct buffer_head *old_bh = NULL;
>> +	struct buffer_head *old_bh = NULL, *dir_bh = NULL;
>>  	struct inode *new_orphan_inode = NULL;
>>  	struct ocfs2_lock_holder oh;
>> 
>> @@ -4258,7 +4258,7 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
>>  		return -EOPNOTSUPP;
>> 
>> 
>> -	error = ocfs2_create_inode_in_orphan(dir, inode->i_mode,
>> +	error = ocfs2_create_inode_in_orphan(dir, &dir_bh, inode->i_mode,
>>  					     &new_orphan_inode);
>>  	if (error) {
>>  		mlog_errno(error);
>> @@ -4304,13 +4304,15 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
>> 
>>  	/* If the security isn't preserved, we need to re-initialize them. */
>>  	if (!preserve) {
>> -		error = ocfs2_init_security_and_acl(dir, new_orphan_inode,
>> +		error = ocfs2_init_security_and_acl(dir, dir_bh,
>> +						    new_orphan_inode,
>>  						    &new_dentry->d_name);
>>  		if (error)
>>  			mlog_errno(error);
>>  	}
>>  	if (!error) {
>> -		error = ocfs2_mv_orphaned_inode_to_new(dir, new_orphan_inode,
>> +		error = ocfs2_mv_orphaned_inode_to_new(dir, dir_bh,
>> +						       new_orphan_inode,
>>  						       new_dentry);
>>  		if (error)
>>  			mlog_errno(error);
>> @@ -4328,6 +4330,11 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
>>  			iput(new_orphan_inode);
>>  	}
>> 
>> +	if (dir_bh) {
>> +		ocfs2_inode_unlock(dir, 1);
>> +		brelse(dir_bh);
>> +	}
>> +
>>  	return error;
>>  }
>> 
>> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
>> index dd784eb0cd7c..3f23e3a5018c 100644
>> --- a/fs/ocfs2/xattr.c
>> +++ b/fs/ocfs2/xattr.c
>> @@ -7203,16 +7203,13 @@ int ocfs2_reflink_xattrs(struct inode *old_inode,
>>  /*
>>   * Initialize security and acl for a already created inode.
>>   * Used for reflink a non-preserve-security file.
>> - *
>> - * It uses common api like ocfs2_xattr_set, so the caller
>> - * must not hold any lock expect i_mutex.
>>   */
>>  int ocfs2_init_security_and_acl(struct inode *dir,
>> +				struct buffer_head *dir_bh,
>>  				struct inode *inode,
>>  				const struct qstr *qstr)
>>  {
>>  	int ret = 0;
>> -	struct buffer_head *dir_bh = NULL;
>> 
>>  	ret = ocfs2_init_security_get(inode, dir, qstr, NULL);
>>  	if (ret) {
>> @@ -7220,17 +7217,10 @@ int ocfs2_init_security_and_acl(struct inode *dir,
>>  		goto leave;
>>  	}
>> 
>> -	ret = ocfs2_inode_lock(dir, &dir_bh, 0);
>> -	if (ret) {
>> -		mlog_errno(ret);
>> -		goto leave;
>> -	}
>>  	ret = ocfs2_init_acl(NULL, inode, dir, NULL, dir_bh, NULL, NULL);
>>  	if (ret)
>>  		mlog_errno(ret);
>> 
>> -	ocfs2_inode_unlock(dir, 0);
>> -	brelse(dir_bh);
>>  leave:
>>  	return ret;
>>  }
>> diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
>> index 00308b57f64f..b27fd8ba0019 100644
>> --- a/fs/ocfs2/xattr.h
>> +++ b/fs/ocfs2/xattr.h
>> @@ -83,6 +83,7 @@ int ocfs2_reflink_xattrs(struct inode *old_inode,
>>  			 struct buffer_head *new_bh,
>>  			 bool preserve_security);
>>  int ocfs2_init_security_and_acl(struct inode *dir,
>> +				struct buffer_head *dir_bh,
>>  				struct inode *inode,
>>  				const struct qstr *qstr);
>>  #endif /* OCFS2_XATTR_H */
>> 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
