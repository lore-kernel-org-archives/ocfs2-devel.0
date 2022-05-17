Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED682C433F5
	for <ocfs2-devel@archiver.kernel.org>; Tue, 17 May 2022 01:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FV23dqGd8BmSw4z2WYdasbfP64Ph0BNdX4wASwKR0ns=;
 b=Qw9nVOjscnFcACtjnWhoVeUvjhAjnAuZPb412fMEUEcmpIO2giSE9fNtdxCW3zONCCNc872viiZc
   wQ3Hr7FQ/559ASxrM12hLT2yqca8OB6wYQg1tjHOQNSERRWEZtOA/lH1X8m/47Z5C2fTw8gl/Ll9
   QVplmoqxn6qf3i4QtJ9LEgD4kFWMt3+gC0noPRLOuoBr6WGtS43JuYVDypvKUeV6NAlDfJprQFuE
   xNUUjf9OC3s+8CiT7Bs9DvPdCZ+9/OGfWvhu2clGHP6EOmcb2wZ3RJFY/wvnZr2IukHzVL7tz0jG
   zen6N9WRLT/UXn7FxVcYEM7wpImqKxVOFuZE3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FV23dqGd8BmSw4z2WYdasbfP64Ph0BNdX4wASwKR0ns=;
 b=KRvf9ysNnGGwnkI/Cydscb9OC3kgqmjH385y5Tmpt4WgF2WqJCmm0Ckg+jVWKNF49eH3meVkQQ3S
   g1ctoIfb5pLMksMi5yExOYDsK5hA6hBF61oRAGO6Sz5E30wPPddIBYnJ85N/6CYQZVvLiS8tZWhG
   sEt82fOb+oZeBwcEWv2/bPqzk3hPjirB+28HhPE2jERak8MsDxVPFsZdtmFgNn7WGWc82hzHbmZ0
   v0Bv38rfyU++Pgrge7zJLwBcOx5pkP0Wa23uCH7abmLQYlbTi+VzCy+IstUar/gqch3uW5EjEBb4
   GpRaW6tbo+lX8PBbi0qmKOGJMZVxLbIkYLqWog==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RC000AAH85RH770@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 17 May 2022 01:58:39 +0000 (GMT)
Message-id: <362038a6-5ae4-3eb9-2426-159ac40b74a2@linux.alibaba.com>
Date: Tue, 17 May 2022 09:58:17 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-language: en-US
To: Junxiao Bi <junxiao.bi@oracle.com>, ocfs2-devel@oss.oracle.com
References: <20220510232213.23435-1-junxiao.bi@oracle.com>
 <cde723f1-db5b-d912-580e-04ddf6a0810a@linux.alibaba.com>
 <7511d9c1-c725-734b-a730-d493ddc37b43@oracle.com>
 <7b620c53-0c45-da2c-829e-26195cbe7d4e@linux.alibaba.com>
 <cc181847-abc9-f6b4-fca0-8d59d0ad1d7c@oracle.com>
In-reply-to: <cc181847-abc9-f6b4-fca0-8d59d0ad1d7c@oracle.com>
X-Source-IP: 115.124.30.132
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10349
 signatures=593597
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 clxscore=69 bulkscore=0 priorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170008 domainage_hfrom=8433
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
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R431e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04357;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VDPo8UG_1652752698;
X-ServerName: out30-132.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: c0XCXANW706AYICkgH5Rqcby-3NbmrHa
X-Proofpoint-GUID: c0XCXANW706AYICkgH5Rqcby-3NbmrHa
Reporting-Meta:
 AAHb5dyRMVWSx/MH3ivOhLAFk8jNc+bn3+cB1QgQEbAb0hZs0YFze4ybMRnNOMAx
 EzR1MO7uZZaVqVNgAbk7Nx3aug4ZoLi1bF2hKhCUPDUwlOZI3GqyEvS0hre9wg2m
 lK5lTiRWaghVVUz+AlAuIJoMTeDqIO6IQa4aFIvVRHnhx7xujFrDHO7673eagmdn
 lJuVOdF56t+A7aHgWZHoSy0QE3wpbIXlCtB3JExv/pZlZaQV2wIcui78IdwVJCtw
 oUua0gt1sO7qDUKqtW8s2Alsflhr1R1PEoYZ3BODnfylLzSq5CzXZigJrZS9zIT6
 MRokOAjKGwcghsyYcGX4d9UKwH3N7L5usfqKsTIcF7eneLxRH/BQfU7s5nIWNcVC
 +rbafiv75H63pCvs2cSzEFy9Etllmobn1z0yvqrK2lDjPxT/Z0RSLcxw/pNt0hOj
 lBy/Ishvd+j3/9dKNU4Uh0HPOf6/zoVkUSNIKwafQ1/lJCERT+/M8xXuhVgxWFrM
 adpMFM3UTXuwnUn12Ba9YwAShoWddO0GmVtHEFwItBq4



On 5/17/22 12:30 AM, Junxiao Bi wrote:
> 
> On 5/15/22 7:57 AM, Joseph Qi wrote:
>>
>> On 5/14/22 12:27 AM, Junxiao Bi wrote:
>>> On 5/12/22 7:05 PM, Joseph Qi wrote:
>>>
>>>> On 5/11/22 7:22 AM, Junxiao Bi wrote:
>>>>> The following function is the only place that check USER_LOCK_ATTACHED,
>>>>> this flag is set when lock request is granted through user_bast() and
>>>>> only the following function will clear it.
>>>>>
>>>> user_ast?
>>> Good catch, that's a typo, should be user_ast.
>>>>> Checking of this flag here is to make sure ocfs2_dlm_unlock is not
>>>>> issued if this lock is never granted. For example, lock file is created
>>>>> and then get removed, open file never happens.
>>>>>
>>>>> Clearing the flag here is not necessary because this is the only function
>>>>> that checks it, if another flow is executing user_dlm_destroy_lock(), it
>>>>> will bail out at the beginning because of USER_LOCK_IN_TEARDOWN and never
>>>>> check USER_LOCK_ATTACHED.
>>>>> Drop the clear, so we don't need take care it for the following
>>>>> error handling patch.
>>>>>
>>>> Seems it depends on initializing lockres every time, but it seems this
>>>> is not true for directory now.
>>> Sorry, i didn't get this. Can you elaborate this?
>>>
>> lockres may be reused and if we don't reinitialized, the left flag can
>> cause unexpected behavior.
> 
> I don't know how it could get reused since it's going to be removed. Anyway USER_LOCK_IN_TEARDOWN is still set in lockres. All the flow will bail out because of this flag.
> 

dlmfs_inode_private is allocated from kmem_cache.
The case I'm thinking about is, calling user_dlm_destroy_lock() without
a valid ast comming before. So checking USER_LOCK_ATTACHED here may be
incorrect.
But look more closer, it seems that lockres is unused for directories.
So it won't be a real issue.
Could you please send a new version with update description?

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
