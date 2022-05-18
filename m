Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CF2CC433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 18 May 2022 01:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qHFq9ggdX2leWUyQQmbfQ/t1apFtZ16sSROFVw13zV4=;
 b=1Clj9UXMphRArjc9qYRie63PaKJGZOeurQ/fevl46PbmEr0jox/6vK7/dTLaCibhVsC3au/wmZqX
   LKTCUOJ0Lj5fqcI1totsEOi1Vd2OhvVj55nz1hNAkSexv+8cw4QLAqPrHeuqm/HV/lMhXqxSTHx3
   SIC28Hx6QByM9uSHGcDKgiiyxUk18MpTGOIaMfNRfaRGvCFI/mDmgnjW2A2ecK18Ob9M59efVp5+
   pqh7dYyepk9unziwY5hk23SSi1rpxCxoL9/y7d0dc4C5McETenCc+h0/A632OeLACLp7RFCKUgVG
   g8Cu3yFuhuRscwcXGks5IVrMhSKhcE2Fpdccgg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qHFq9ggdX2leWUyQQmbfQ/t1apFtZ16sSROFVw13zV4=;
 b=LRb+5n7LlrpZLb96O1SgkDh8fagI5oOf+hrwgqhVJili93sX0gzUYJLfY8pxg6K0bzNvWs8geB2P
   E4k7C/051thzyyKb7NpWZawcfwD7RPzIUaowbJXkXlgbeOQrGMIx4HGR3GQDXFwca/RK2CxCoytf
   qTiPwZyT86VHzCQwX+7BEC4mHmevS20wJytyBh0XEIhsUpi0rzz3ZvMGZOqnqb76Bnz1Ycj1f6HT
   Zeju9BU7lnQ4uWC3idJMAM042KPMrsXHTEOtVjuR2hVbxQX4TRJ9AJJN+cBm+6F7qE7VZ72kJP8Q
   UClEwfR6JwBaL0AEaLzpL/8EcbS41csWgmGk+A==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RC20022C2N8FZ40@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 18 May 2022 01:54:44 +0000 (GMT)
Message-id: <0277d743-1e03-89f5-38ec-1b833e8f5e43@linux.alibaba.com>
Date: Wed, 18 May 2022 09:54:27 +0800
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
 <362038a6-5ae4-3eb9-2426-159ac40b74a2@linux.alibaba.com>
 <e3daeccc-823a-665e-7068-4001114e7d36@oracle.com>
In-reply-to: <e3daeccc-823a-665e-7068-4001114e7d36@oracle.com>
X-Source-IP: 115.124.30.131
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10350
 signatures=593597
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 priorityscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0
 clxscore=78 spamscore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205180008 domainage_hfrom=8434
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R151e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04423;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VDYOtAn_1652838867;
X-ServerName: out30-131.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: 8JOW7HRYn7AUsb1UBGoMGDkDLj75dtlz
X-Proofpoint-ORIG-GUID: 8JOW7HRYn7AUsb1UBGoMGDkDLj75dtlz
Reporting-Meta:
 AAFtBrkp583TrVbGM+olEFqJAsmeOylBSS6q7KnPvXojt08fnFuHnlH4JPapqAMV
 LKZpWmjy4MrORk7O/kZ8UtQ2ZdEeD/tZVuQyi9aMZfEUKXuv+ZNbdhyJiDkERZUT
 IKCNYJRecdLeYy1FNFvtYdc2hrJSnyNzCoUfzeTH9FarVy5Id8cirMUzngpK030m
 siTzDNeM9QFpHaqS3dnr7d/WOAMT9P4D+Vmtt2t1AHzAu3ExGXpHZQ5F1SKjIY8z
 MlqBqJCLLCdMyKwjmDp4mCTXkz7rnvNvjq7Qx4NndFB65xai887sp2FW+x0E6DO9
 5paPJHUUWPTgsD2QcXszwROxyLNtBJKN3Jr2aTAwPgVw0l9DSZIof322SnXCCbQP
 T3QEAg1pbqNEMs1HnaeyxlB39ug89i0N+7NbpW4f8Xn0TcuREzmeE4utS0UsZODf
 9UIP4CYA1x8kIxem8KLA0v0A92d4s4zPjovBYV5c5NRFM0Bvmez4gDMCMmDH39Gb
 w5A5OzjQgcOnETvpZSgJpeagfJd0rWLYe5LhbgemS+Id



On 5/18/22 12:12 AM, Junxiao Bi wrote:
> 
> On 5/16/22 6:58 PM, Joseph Qi wrote:
>>
>> On 5/17/22 12:30 AM, Junxiao Bi wrote:
>>> On 5/15/22 7:57 AM, Joseph Qi wrote:
>>>> On 5/14/22 12:27 AM, Junxiao Bi wrote:
>>>>> On 5/12/22 7:05 PM, Joseph Qi wrote:
>>>>>
>>>>>> On 5/11/22 7:22 AM, Junxiao Bi wrote:
>>>>>>> The following function is the only place that check USER_LOCK_ATTACHED,
>>>>>>> this flag is set when lock request is granted through user_bast() and
>>>>>>> only the following function will clear it.
>>>>>>>
>>>>>> user_ast?
>>>>> Good catch, that's a typo, should be user_ast.
>>>>>>> Checking of this flag here is to make sure ocfs2_dlm_unlock is not
>>>>>>> issued if this lock is never granted. For example, lock file is created
>>>>>>> and then get removed, open file never happens.
>>>>>>>
>>>>>>> Clearing the flag here is not necessary because this is the only function
>>>>>>> that checks it, if another flow is executing user_dlm_destroy_lock(), it
>>>>>>> will bail out at the beginning because of USER_LOCK_IN_TEARDOWN and never
>>>>>>> check USER_LOCK_ATTACHED.
>>>>>>> Drop the clear, so we don't need take care it for the following
>>>>>>> error handling patch.
>>>>>>>
>>>>>> Seems it depends on initializing lockres every time, but it seems this
>>>>>> is not true for directory now.
>>>>> Sorry, i didn't get this. Can you elaborate this?
>>>>>
>>>> lockres may be reused and if we don't reinitialized, the left flag can
>>>> cause unexpected behavior.
>>> I don't know how it could get reused since it's going to be removed. Anyway USER_LOCK_IN_TEARDOWN is still set in lockres. All the flow will bail out because of this flag.
>>>
>> dlmfs_inode_private is allocated from kmem_cache.
>> The case I'm thinking about is, calling user_dlm_destroy_lock() without
>> a valid ast comming before. So checking USER_LOCK_ATTACHED here may be
>> incorrect.
>> But look more closer, it seems that lockres is unused for directories.
>> So it won't be a real issue.
> Yes, lock is only for file, not direcotry.
>> Could you please send a new version with update description?
> 
> Sorry, little confused, which part of description needs update?
> 

The typo that user_ast() is for granting lock request. And better to include
the information we discussed above.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
