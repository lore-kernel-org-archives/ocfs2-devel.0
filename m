Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BC33C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 12 Apr 2022 11:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=szv83PYZQoHOBPDJp0jU5D5JXTAJG7oFeU4gnExIyXU=;
 b=G20pogK/BmhcnfCiR/0yZ1TAs4HiGbqc8vwFfkOCOyFke6zUIEGoU43gAr73V9yEgFp0AkUlLx1c
   NLf13QV8jYY6gN0+FBSCCsGp73r8iQoUPDdxis8iXirwilu7Ygwwt1M13YAIOeXhr4Kj2lhYn9Mm
   hlqpsaZ78DwKYWiyP5KL6BIRxdSa8WaKXD/IX1G3E4edzG/RKw80l3e25/TMdfkwa54m0vualQJ+
   bnemZiD61bdiRTVqGZdpAxk3bnpn8bN5FsUUrGgF7ta/8Wu/roctynECllb1CYjr+JcmWLJ3sxdh
   zUE2hob2BzY9GuqEw3l8GhX8MjJxy5DKQ8GgWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=szv83PYZQoHOBPDJp0jU5D5JXTAJG7oFeU4gnExIyXU=;
 b=kYrALsIiFgloIRJdh0FQ12mhcGP8NOh8xyEx8YAZWnGZNMph/n14PdOJJX444T6Y2CJIfp76B5C/
   SF6N2hki1MTPeoXVz3c0iJQfVK2MNscWu+i0i819/bKbzX2pMR0s+WpW19RE7HuO2l/8qO6Bgx4G
   IY+ZF8zKkXINxW6qXwnmX2SI67n1TP/BurS3MAgSIaxCgS12CD/kYMLFUeBszDy3PToBInqd64g2
   zkL2ytrVooakvCeVhOQas15wzPXZxD2e3HVhyrDPoQcvwIeOBWXrnb3Pwq3N9cLl4uL9juDDsS0J
   SixP3oDKvT9he/Zi45tF70f8TFk+jhsoVeb7Dw==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA8002GS6FIFN10@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 12 Apr 2022 11:54:54 +0000 (GMT)
Message-id: <5bad382a-1fba-64b8-8785-cf1c229e82f6@linux.alibaba.com>
Date: Tue, 12 Apr 2022 19:54:35 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>
References: <20220408103012.1419-1-heming.zhao@suse.com>
 <20220408103012.1419-5-heming.zhao@suse.com>
 <5bd3a683-b0bd-b6b9-32c0-b57026f109aa@linux.alibaba.com>
 <20220412082248.qzacxmvexkpwqhua@c73>
In-reply-to: <20220412082248.qzacxmvexkpwqhua@c73>
X-Source-IP: 115.124.30.130
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10314
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 spamscore=0 clxscore=118 malwarescore=0 lowpriorityscore=0 priorityscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 impostorscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120055 domainage_hfrom=8398
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v1 4/5] ocfs2: ocfs2_mount_volume does
 cleanup job before return error
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
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R581e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0V9ul-59_1649764475;
X-ServerName: out30-130.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: mh6Ia8hl0Z97bzVuG601JGng--bQdxMa
X-Proofpoint-GUID: mh6Ia8hl0Z97bzVuG601JGng--bQdxMa
Reporting-Meta:
 AAHnxl9xTR2RqEZB7tFgv6w4fRXCA8EmPZw6VeLI7IjaZ6LluKnb3XBQ7P7rfDcF
 kwhkZoCEKDgUeB1h9ifxNeVc/JsRMUhBEqYtFAC8NZZTF13q5aw+4G0c0I/9ugmE
 FLF3VQZcxK2tHUaW3kie2wRKFauven40rX2h9bA3LjlJK7dsNjoFIrzzIGU5bHhM
 IE3RfVnf/U+iNlWB2SlglP1nYWAiTeE4CTS/etEiHZBo8jmR/0ItghU66mDW9MLa
 Pgzpjq//NQ736AfJXmXsScoeHmq+55jv6LQVL4oJELMWNo/oVC8CwOon4DxZgkP3
 vywzbhxe864vEXAhTAm6UZdsbc7CmBv2AUWl6+cCsmKnRYX92QhLlTu02/uSkQoh
 353zqQXto27OXBo1+dh712Melmy9RcIq7H4PS+4zO4DI1TjWotquHE9wsv2+HiPG
 4AxhIvDDGy/Mb5wqzWNpnFO9/3IKqW5ycz/EMkYRx6uur0txtJGnuLSTKpBu25iy
 MfiaipUfMuBpSA/2pO4PKsB4s47iBiy9X4gddDrtO14=



On 4/12/22 4:22 PM, Heming Zhao wrote:
> My last reply (on 4.10) had messy format, because thunderbird automatically
> add '\r' after '\n'. For easy review, I use neomutt to resend my replay.
> Please check my comments in below.
> 
> On Sat, Apr 09, 2022 at 09:46:19PM +0800, Joseph Qi wrote:
>>
>>
>> On 4/8/22 6:30 PM, Heming Zhao wrote:
>>> After this patch, when error, ocfs2_fill_super doesn't take care to
>>> release resources which are allocated in ocfs2_mount_volume.
>>>
>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>> ---
>>>  fs/ocfs2/super.c | 32 ++++++++++++++++++++------------
>>>  1 file changed, 20 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>>> index 8443ba031dec..d4b7a29cb364 100644
>>> --- a/fs/ocfs2/super.c
>>> +++ b/fs/ocfs2/super.c
>>> @@ -1803,11 +1803,10 @@ static int ocfs2_get_sector(struct super_block *sb,
>>>  static int ocfs2_mount_volume(struct super_block *sb)
>>>  {
>>>  	int status = 0;
>>> -	int unlock_super = 0;
>>>  	struct ocfs2_super *osb = OCFS2_SB(sb);
>>>  
>>>  	if (ocfs2_is_hard_readonly(osb))
>>> -		goto leave;
>>> +		goto out;
>>>  
>>>  	mutex_init(&osb->obs_trim_fs_mutex);
>>>  
>>> @@ -1817,44 +1816,53 @@ static int ocfs2_mount_volume(struct super_block *sb)
>>>  		if (status == -EBADR && ocfs2_userspace_stack(osb))
>>>  			mlog(ML_ERROR, "couldn't mount because cluster name on"
>>>  			" disk does not match the running cluster name.\n");
>>> -		goto leave;
>>> +		goto out;
>>>  	}
>>>  
>>>  	status = ocfs2_super_lock(osb, 1);
>>>  	if (status < 0) {
>>>  		mlog_errno(status);
>>> -		goto leave;
>>> +		goto out_dlm;
>>>  	}
>>> -	unlock_super = 1;
>>>  
>>>  	/* This will load up the node map and add ourselves to it. */
>>>  	status = ocfs2_find_slot(osb);
>>>  	if (status < 0) {
>>>  		mlog_errno(status);
>>> -		goto leave;
>>> +		goto out_super_lock;
>>>  	}
>>>  
>>>  	/* load all node-local system inodes */
>>>  	status = ocfs2_init_local_system_inodes(osb);
>>>  	if (status < 0) {
>>>  		mlog_errno(status);
>>> -		goto leave;
>>> +		goto out_super_lock;
>>>  	}
>>>  
>>>  	status = ocfs2_check_volume(osb);
>>>  	if (status < 0) {
>>>  		mlog_errno(status);
>>> -		goto leave;
>>> +		goto out_system_inodes;
>>>  	}
>>>  
>>>  	status = ocfs2_truncate_log_init(osb);
>>> -	if (status < 0)
>>> +	if (status < 0) {
>>>  		mlog_errno(status);
>>> +		goto out_journal_shutdown;
>>
>> ocfs2_check_volume() not only does journal initialization,
>> but also local alloc.
>>
> 
> I agree and already handled this case. Please read following explanation.
> 
> Call flow:
> 
> ocfs2_fill_super
>  ocfs2_mount_volume
>   + ocfs2_init_local_system_inodes //[1]
>   + ocfs2_check_volume
>      ocfs2_load_local_alloc //may fail
> 
> If ocfs2_load_local_alloc fails, only "//local_alloc:%04d" is bad.
> And other alloced inodes (from [1]) still exist.
> 
> Also note, the sys inodes release function is ocfs2_release_system_inodes(),
> which could handle both osb->global_system_inodes[] & osb->local_system_inodes[]
> are NULL pointer case.
> 
> The cleanup job will be done in both places:
> - ocfs2_mount_volume (patch 4/5)
> - ocfs2_fill_super (patch 5/5)
> 
> Related code after patched 4/5:
> (please check my comment start with "hm:")
> ```
> static int ocfs2_mount_volume(struct super_block *sb)
> {
> 	... ...
> 	
> 	status = ocfs2_check_volume(osb);
> 	if (status < 0) {
> 		mlog_errno(status);
> 		
> 		//hm:
> 		//need to release global/local sys inodes (by //ocfs2_release_system_inodes())
> 		//which are alloced by above [1].
> 		goto out_system_inodes;
> 	}
> 	
> 	status = ocfs2_truncate_log_init(osb);
> 	if (status < 0) {
> 		mlog_errno(status);
> 		
> 		//hm:
> 		//need to release journal: by ocfs2_journal_shutdown()
> 		//need to release global/local sys inodes: byocfs2_release_system_inodes()
> 		goto out_journal_shutdown;
> 	}
> 	
> 	ocfs2_super_unlock(osb, 1);
> 	return status; //<== hm: will change to 0 under next comment
> 	
> out_journal_shutdown:
> 	ocfs2_journal_shutdown(osb); //hm: through to label "out_system_inodes".
> out_system_inodes:
> 	ocfs2_release_system_inodes(osb);
> out_super_lock:
> 	ocfs2_super_unlock(osb, 1);
> out_dlm:
> 	ocfs2_dlm_shutdown(osb, 0);
> out:
> 	return status;
> }
> ``` 
I mean we may need call ocfs2_shutdown_local_alloc() to do the cleanup.
In ocfs2_fill_super(), you don't do that.

Thanks,
Joseph


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
