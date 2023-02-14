Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA530C636CC
	for <ocfs2-devel@archiver.kernel.org>; Tue, 14 Feb 2023 02:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=zT+fIGY2tHpNZ4ijqRg5ISzNAko0GypTNlbA/+jIk34=;
 b=LDzf0hKd6L/0i7TC9Mc+wWLaTtykHmIzlHGrj5TffE4bVRkA4F32B+m1/Wm265D+nBQq/evBxlMm
   ih0LnFVOqOTfpujOSdVmeLE176UrkXbPjiLEJ+rIKLpDAP8h1uLgHOBreBlH30sLgFZDj+yfMgv7
   idS99EHLyaHtM4KzJ/KXKarvZO6MnjbE1YHMHXedRY76tBkpgm9xpSNgIFbcs2GAZjt8s0K7gPto
   a378k3h+xGAQfcIak+/V4H5a5XYloBLh9iWT227C4Ju9UsRvhSj+SaVQFD407XKaholeodiYa8Cj
   EbSQV+0tKhwxppJl4zPTw29+pXED5w2DmIPHwg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=zT+fIGY2tHpNZ4ijqRg5ISzNAko0GypTNlbA/+jIk34=;
 b=qiOHqfW2Kl5QyUvkTBsbdV3Qg1dsuPrS53garF5u1eB4SstyNZTpf7T6ek7cJ2lgOh0fohpi51ZT
   EVXGrBuakLWDG0dqWW8cdo2jYWLe2VodvKew7ieF5osiUJ5SiLTu7L6RT09qR7gqHA0tMfILxakq
   An/vvxjmiBLW4YrWu5HEiPqCMA+KYMUZYkMdM37ALJqQuWm2R+x5IigUu5QH/wYGhttWLjBr8Ig0
   s6JOcIkp7x6NQQVEBGsB2upTkOeg0qLU54jwkXiG6B8lewBvUeN3s7ALyeHhBOogUD/IKzMQbsKX
   VMrNdhU5kNfziSswL4wqKF/V+vEqexiZFGRHTw==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQ1009WZUO3YC40@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 14 Feb 2023 02:52:51 +0000 (GMT)
Message-id: <9ceabc71-5b18-5a1f-12e2-ea63aecd78e5@linux.alibaba.com>
Date: Tue, 14 Feb 2023 10:52:30 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20230210100457.xv5wchadnd7kkazb@c73>
In-reply-to: <20230210100457.xv5wchadnd7kkazb@c73>
X-Source-IP: 115.124.30.100
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10620
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=104 bulkscore=0 impostorscore=0 clxscore=31
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302140021 domainage_hfrom=8706
Cc: jack@suse.com
Subject: Re: [Ocfs2-devel] discuss about jbd2 assertion in defragment path
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R141e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046059;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VbdjKFn_1676343150;
X-ServerName: out30-100.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: uZc8PChH9PHkFeFJ7C0eRLgOIYLNvccT
X-Proofpoint-ORIG-GUID: uZc8PChH9PHkFeFJ7C0eRLgOIYLNvccT
Reporting-Meta:
 AAHaeGyID8RoTxWeDSLavur0CAnDdLwcckHsxXXLudJRugfjuy8Hc2E3HJIQ1N/O
 Y22TlRDbYVHrsUbHvg5UMezNGNiR8qPMZecDzUskyH3l5ZNfVuLAnrxXoseBFaGZ
 RoVrPwd0NANpw1UnrsOuFsZYeMj54loFGfoON9IS1jRpPrbOIzJ5ob34784sxiHP
 EcHmVToekMVcYZ+4FHwyl7/9yCM4MEeiYat/ns7FeuJa0d9UHRD9Ug0xZ1Oac8WE
 R28uYytVL7Olm5NlUataWyf8KBZIJd2sxtcQvHqUF4VaYWm8Cf8Z4E7LcnKumDqO
 qVmUPZRWM8kX85DaC6u+yhgsM2yOAMrFQ5Zi8yHsMUr7AazwajNMgnFFyuJZNs/r
 bbouLIPlwvIQN5nsq/EbJc6uzaXVLDEmWmnM8/FRqlC9tlqnX7E0rHLHydKgawDS
 xM2GnIbpc4FiPb3JbFl7TeFh2YVgOThBj4utStDvWthDzjn2R4GPOS/FMpdeOCpT
 7ywIPYu+atPmOdAHC/vU10o0fIc2HA64b8d7QE6PNQU=

Hi, Sorry about the late reply.
This thread is indeed a long time ago:(
It seems that I said the two ocfs2_journal_access_di() are for different
buffer head. Anyway, I have to recall the discussion before and get back
to you.

Thanks,
Joseph

On 2/10/23 6:04 PM, Heming Zhao wrote:
> Hello Joseph,
> 
> I am sorry to wake up a long time ago thread.
> 
> All mails of this thread (my patch is [1]):
> [1] https://oss.oracle.com/pipermail/ocfs2-devel/2022-May/000101.html
> [2] https://oss.oracle.com/pipermail/ocfs2-devel/2022-June/000105.html
> [3] https://oss.oracle.com/pipermail/ocfs2-devel/2022-June/000109.html
> [4] https://oss.oracle.com/pipermail/ocfs2-devel/2022-June/000217.html
> 
> I re-checked ocfs2 defragmentation & jbd2 flow recently, I still think my
> patch [1] is right. At least, the fixing code is correct, the patch commit
> log needs to polish.
> 
> This bug has the same root cause of commit 7f27ec978b0e ("ocfs2: call
> ocfs2_journal_access_di() before ocfs2_journal_dirty() in ocfs2_write_end_nolock()").
> For this bug, jbd2_journal_restart() is called by ocfs2_split_extent() during
> defragmenting, and it's not about "not enough credits" issue you ever said in [2].
> 
> I explain my thinking again in this mail.
> 
> the crash call flow:
> 
> ocfs2_defrag_extent //caller call it in while() loop.
>  + handle = ocfs2_start_trans(osb, credits)
>  + __ocfs2_move_extent
>  |  + ocfs2_journal_access_di //[a]
>  |  + ocfs2_split_extent      //[b]
>  |  |  + if                   //[b.1]
>  |  |  |   ocfs2_replace_extent_rec/ocfs2_split_and_insert
>  |  |  + else
>  |  |     ocfs2_try_to_merge_extent
>  |  |
>  |  + ocfs2_journal_dirty     //[c]
>  |
>  + ocfs2_commit_trans(osb, handle) //<== complete this handle
> 
> In my viewpoint, ocfs2_split_extent() is journal self-service function. I still
> belive the two lines ([a] & [c]) in __ocfs2_move_extent() are totally useless.
> In ocfs2_split_extent(), the code from the first code line to "if-else" code
> area ([b.1]) doesn't need any journal protection, and we also could see there
> are only read operations.
> 
> If we worry about data corruption after removing [a] & [c], (e.g: my eyes missed
> some journal operations from [a] to [b.1]), we could only delete [c]. So the
> fixed code seems (only remove line [c]):
> 
> ocfs2_defrag_extent
>  + handle = ocfs2_start_trans(osb, credits)
>  + __ocfs2_move_extent
>  |  + ocfs2_journal_access_di //[a]  <-- keep it, but remove pair dirty action
>  |  + ocfs2_split_extent      //[b]
>  |     + if                   //[b.1]
>  |     |   ocfs2_replace_extent_rec/ocfs2_split_and_insert
>  |     + else
>  |        ocfs2_try_to_merge_extent
>  |
>  + ocfs2_commit_trans(osb, handle)
> 
> Thanks,
> Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
