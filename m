Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31126C433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu, 10 Mar 2022 03:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vyauUuj6Hd7/M/Kk1M0snCNLAB9w7B9gNB1kgVMsUT4=;
 b=cpGN+3i/6M6iYXqZmrLpscMICvGvRfi+75OWzc7pLzyd1xeJ8tR5xWDuCPuc413YvQXRJApAFmIx
   CtQktjLisAQTVi4y9G/ZYbxSioXeZqJhykq7yUrZRu/wWT5XBZztqp7N0zUVzz2RvWXS0nA/TS8k
   LXCTsV1UynJvx0Ofp8FD9zCaK6WCFzRj5IOaIeW3SIKBOjWtwd7ukjTFvVgh/jE89kUPrVFxjqhD
   8w2/KbPrprXqEebzwPhD85gbeObJ9CZIs+BFBygbmuneeOU/ZnvryEfiuj2mOIcWOhSMLiN4Uy8U
   u+RbeR13njsjOrTV+pZXp8dtxfhtNhUMCSFovA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vyauUuj6Hd7/M/Kk1M0snCNLAB9w7B9gNB1kgVMsUT4=;
 b=rjoMRHDTja3/fse3OW3n5Q0rpQHV/d+Uybs95BsvMBLAXf7aVFt/JcMdvB8iC6ttZ6hImclKU9qg
   c6mf6xLPtw420OtKZTbrx1GPHNpqL83v3Aw4eAQb7/yUEVYY4Lmjmg6+BwxOLBYGmvvyt5oonEg2
   qpCUMO6mzC2Pwi5o7+IWm3lqlohmYTauycaSifoRd24/WQJPRAKkNwv7p6V0MS333kQTwQcvvZL6
   yjtqqFAF5WLUmfSoi4UjQJEN+SjZNpGykLhff5vo2fCC/fkqTZY/gNzM33gV2JbKBC46Q1k96Gja
   ULiXMkRwBMuYfvcnShURBmzj9qc5KCzDVnEThQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R8I00E9NEAAI230@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 10 Mar 2022 03:13:22 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <5a5933bb-3078-2cfa-9403-a6b497199449@linux.alibaba.com>
Date: Thu, 10 Mar 2022 11:13:05 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Content-language: en-US
To: Dan Carpenter <dan.carpenter@oracle.com>, Joseph Qi <jiangqi903@gmail.com>
References: <20220307145138.GA22641@kili>
 <82b26a4a-2351-f2b3-dd7c-265308e6b384@gmail.com> <20220309145717.GX3315@kadam>
In-reply-to: <20220309145717.GX3315@kadam>
X-Source-IP: 115.124.30.43
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281
 signatures=692062
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 priorityscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 adultscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 clxscore=234 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203100014 domainage_hfrom=8365
Cc: Jakob Koschel <jakobkoschel@gmail.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [bug report] ocfs2/dlm: Fix race in adding/removing
 lockres' to/from the tracking list
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R761e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04395;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
 TI=SMTPD_---0V6mbsZe_1646881985;
X-ServerName: out30-43.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: K2NdeCwZ0n8F6jOgxZb4oUoh-LXyUDQo
X-Proofpoint-ORIG-GUID: K2NdeCwZ0n8F6jOgxZb4oUoh-LXyUDQo
Reporting-Meta:
 AAEzZ14T5WWCd8Jb01NeuYRZYRlUYfOtLnQPVoihf6OS1aOHBoQY4zK4Uruhn2l8
 KcUS6mT4fZSbnSH4jNyQhmn9/2uNJ5ZQYCbRJ5hPlVLmAcck6ornRCt8KL4Fg7CG
 tI0642W+TapKsWqsyOPc4649r4CiXblvR5WM4CU6LJIPKD3hSMB+zNf0JdvgcGNk
 AHZnkkYDmtz0OHb3q7oaA2By+FLDy3a+jm9DOgPevVAxWkmBxf6L1Q+wLm3imFhZ
 PPR+C2UtpUm8AHZF4Ee1GWKskJEO48oT/gtfKh+Q9CERgwDYawX+6wb9RLK/aCQs
 n8Yj0NQArb9lqCrx/zwp9LX8ag847QbtY0Z6mddGTgEWkLjnBlyNX0dla8vvy7px
 bBbqQ4exIV8dljRZk4oYDBXPS2BaTeQLWsUK5cxxz/QAP5CpGh1cCj643B9/0Ceh
 d/7MWXnMPw5Yi9TV/AgxtkQ5uw+IQacjAo1Ac2aSjOGE782XQoT2ZrTT8zeplP1e
 W0xQrHCGv4OicA2i+r3QjrTVsYF4xOYGq1ZLGsVu7T/YrQ==



On 3/9/22 10:57 PM, Dan Carpenter via Ocfs2-devel wrote:
> On Wed, Mar 09, 2022 at 03:46:11PM +0800, Joseph Qi wrote:
>>
>>
>> On 3/7/22 10:51 PM, Dan Carpenter via Ocfs2-devel wrote:
>>> Hello OCFS Devs,
>>>
>>> There is a big push to re-write list_for_each_entry() so that you
>>> can't use the list iterator outside the loop.  I wrote a check for that
>>> but this code has me puzzled.
>>>
>>> The patch b0d4f817ba5d: "ocfs2/dlm: Fix race in adding/removing
>>> lockres' to/from the tracking list" from Dec 16, 2008, leads to the
>>> following Smatch static checker warning:
>>>
>>> 	fs/ocfs2/dlm/dlmdebug.c:573 lockres_seq_start()
>>> 	warn: iterator used outside loop: 'res'
>>>
>>> fs/ocfs2/dlm/dlmdebug.c
>>>     539 static void *lockres_seq_start(struct seq_file *m, loff_t *pos)
>>>     540 {
>>>     541         struct debug_lockres *dl = m->private;
>>>     542         struct dlm_ctxt *dlm = dl->dl_ctxt;
>>>     543         struct dlm_lock_resource *oldres = dl->dl_res;
>>>     544         struct dlm_lock_resource *res = NULL;
>>>     545         struct list_head *track_list;
>>>     546 
>>>     547         spin_lock(&dlm->track_lock);
>>>     548         if (oldres)
>>>     549                 track_list = &oldres->tracking;
>>>     550         else {
>>>     551                 track_list = &dlm->tracking_list;
>>>     552                 if (list_empty(track_list)) {
>>>     553                         dl = NULL;
>>>     554                         spin_unlock(&dlm->track_lock);
>>>     555                         goto bail;
>>>     556                 }
>>>
>>> Why not do the list_empty() check after the else statement.  In the
>>> current code if "&oldres->tracking" is empty it will lead to a crash.
>>>
>> lockres will be added into tracking_list during initialize.
>>
> 
> I am not sure we understand each other.
> 
> This function is iterating over the list.  Nothing should be modifying
> the list until after we have released the spinlock.  Any modifications
> is a race condition.  Which initialize function are you talking about?
> 
dlm_init_lockres(), I mean if res is there, it seems won't be empty?
That's why we haven't encountered any real issue here, I guess.
But for code itself, I agree it makes a little puzzle.

> In the currect code if oldres is non-NULL and list_empty(&oldres->tracking)
> is true then it leads to a crash.  There is no reason that we cannot do:
> 
> 	if (oldres)
> 		track_list = &oldres->tracking;
> 	else
> 		track_list = &dlm->tracking_list;
> 
> 	if (list_empty(track_list)) {
> 		dl = NULL;
> 		spin_unlock(&dlm->track_lock);
> 		goto bail;
> 	}
> 
> This is cleaner and now we do not have know from outside context
> whether the &oldres->tracking list can be empty.
> 
>>
>>>     557         }
>>>     558 
>>>     559         list_for_each_entry(res, track_list, tracking) {
>>>     560                 if (&res->tracking == &dlm->tracking_list)
>>>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>> This should never be possible.  How is it possible?  If
>>> &dlm->tracking_list is the list head the it's not possible without
>>> memory corruption.  If &oldres->tracking is the list head then I do not
>>> see how it is possible without memory corruption.  We can't mix different
>>> types of list entries on the same list head?>
>> In case of oldres, and the iterator points to dlm_ctxt.
>> In this case, the lockres is not a valid one.
> 
> That doesn't make sense.  :/  This condition is doing pointer math.
> The offset of ->tracking is 136 bytes and ->tracking list is 88 bytes
> into the dlm struct.
> 
Now track_list is oldres->tracking, which is already linked to
dlm->tracking_list?

Thanks,
Joseph 

> 	if ((void *)res + 136 == (void *)dlm_ctxt + 88)
> 
> Use algebra to subtract 88 from both sides.
> 
> 	if ((void *)res + 48 == (void *)dlm_ctxt)
> 
> So dlm points to somewhere in the middle of "res" struct.
> 
>>  
>>>     561                         res = NULL;
>>>     562                 else
>>>     563                         dlm_lockres_get(res);
>>>     564                 break;
>>>
> 
> regards,
> dan carpenter
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
