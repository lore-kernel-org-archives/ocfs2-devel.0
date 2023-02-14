Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B084C05027
	for <ocfs2-devel@archiver.kernel.org>; Tue, 14 Feb 2023 11:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VFEm7wwu/GLB8Defk0yd1Vs3ovQma8s/NSUIJXWJT5U=;
 b=Mlhv6RXFaMrLSKL0w/2Ciu+N1XCr867XHqXEaCEkWyuKzzHs4be6wvfODFTepAxYy2ZttMEX/9KT
   2TsEwablWDsqoEtFVoR1A0cm7e0kP9yrLXk7hZeOFFuvZ7mwy4s9lLzbP4mtNAbNMbZMFriKq9N7
   CRV+i0o7USM3Q8Uc/tT/nuppYzKTpvKOtHAEMVy6WyY30BOTN4U4SiHwFBswxQt4Y6ErMEM94Cq1
   hrIotj43c365ZNj6J3Hct27DqKxD5DbzIe4vsvK1Gt65JdcfJXdVVd0IWclfhVynATSIy1sMlU6t
   f+4y2DBIDZdohVYcYg3U5IZmiJlY5Un5Ub0ACg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VFEm7wwu/GLB8Defk0yd1Vs3ovQma8s/NSUIJXWJT5U=;
 b=Ane5hQgeBcnClmOQGspqhoFu55Wzun/4Wi8HAykxTi+XnxwmbntsYyRx7Tc10YAq+GR+BYi1v9a/
   ziyjD9ILbuNGC7IlLfqoSMjV2N0il1E3vSTfJboN2JjQ5ovXjSwgZMkUQAG314uZIdyqBRzWpKI1
   yzAxS5bWZ/t2hMYuvMAaxvn3WHb6zqdjID9HoLkQSFgp/Bc7ilcBTXtL37azqNjCKSzHRwqTxk8e
   xoJF4FllSaMZ4bMEiK5Ti+qWEcDQ85EDWOI7TfjEWkNS1obNVjTWwdFhWRHs/okWL9XU0VdSW2f0
   go0lR6FhW6bbi6IxWmtt56AnQmIxEV7eGgelLA==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQ200CZJHMFIMA0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 14 Feb 2023 11:08:39 +0000 (GMT)
Message-id: <c60fddf7-f49d-3f7c-9383-5fee2ccf7a65@linux.alibaba.com>
Date: Tue, 14 Feb 2023 19:08:16 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20230210100457.xv5wchadnd7kkazb@c73>
 <9ceabc71-5b18-5a1f-12e2-ea63aecd78e5@linux.alibaba.com>
 <20230214043344.szvhwukkdkzsky5n@c73>
In-reply-to: <20230214043344.szvhwukkdkzsky5n@c73>
X-Source-IP: 115.124.30.111
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10620
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 adultscore=0 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=933 priorityscore=1501 mlxscore=0 phishscore=0
 clxscore=-105 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302140095 domainage_hfrom=8706
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R981e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046050;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0Vbfygpv_1676372896;
X-ServerName: out30-111.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 2yS9Q9JTOFavQsIbKU6BvcX9_Yx02ZpH
X-Proofpoint-GUID: 2yS9Q9JTOFavQsIbKU6BvcX9_Yx02ZpH
Reporting-Meta:
 AAHzlyezI/x4l297B1LNPLXEh1WJxWP35w/x+BBH2zbsqgu0Bn7HBkojgNkgrMIQ
 eKfUBjvUMV8AG+phtIDWCPK2j/VtPhd3aWPqsCryTRf6B9Ag8/EPb+yxjfVTlcUW
 ZkFvHOfAL/hCKSF/XMIJ0LsW0RFgCUWsPMI7+wiug6e6gopvS1T1xfFs/PoPgtpU
 qKES+7fzkEPhCE+HdHhacJFMd77YwTIZnjk6+irEsC3sNsR5u6Fu8Sb+FH9yLYGN
 nUl3mfdC8rPmj7oLgEFADt6SbH438VhPWAkLvGqzumwatk4ti8WXLrEm+vp4QKaF
 6Dywjcs2Nd2FJ7oOWeBLJhKuc2DaCAf35dG+xE9uxtMzO7/qVt7KCJoIlqhOG771
 u7vjmbTJ6qIgcKM7LuOeVtTA6hOZuSpA9sJiyqnCa8fmT4OA3Pag1SJqnoQ0ujZg
 zk0xqsT5jEfpg9IjuXG/StGwJg5pjoBqea8n7+QyxuyNkae56P5+Ep3xNtAw87S+
 goenuW4mSayXNOFMKso74oDeV//JrNlt/Iwi5CnBPck=

Hi,

On 2/14/23 12:33 PM, Heming Zhao wrote:
> On Tue, Feb 14, 2023 at 10:52:30AM +0800, Joseph Qi wrote:
>> Hi, Sorry about the late reply.
>> This thread is indeed a long time ago:(
>> It seems that I said the two ocfs2_journal_access_di() are for different
>> buffer head. Anyway, I have to recall the discussion before and get back
>> to you.
>>
> If you belive from [a] to [b.1] doesn't need any journal protection, my patch
> makes sense from theory.
> 
> From code logic, if the defrag path (ocfs2_split_extent) doesn't call
> jbd2_journal_restart(), current code is absolute correct. Increasing credits
> can't help avoid jbd2 assert crash, but make more easily to trigger crash,
> because it makes jbd2_journal_extend() more easily to return "status > 0". In my
> view, the correct fix should delete the access/dirty pair and make sure the
> ocfs2_split_extent() is journal self-service.
> 
> Different buffer head issue could be handled by rechecking ocfs2_split_extent(),
> make sure all journal handle branches are correct. I already checked
> ocfs2_split_extent, but I can't assure my eyes didn't miss any corner.

ocfs2_split_extent are not just 'read' operations, it may grow the tree,
that's why we have to do a transaction here.

The whole code flow:
ocfs2_ioctl_move_extents
  ocfs2_move_extents
    __ocfs2_move_extents_range
      ocfs2_defrag_extent  [1]
        ocfs2_start_trans  [a]
        __ocfs2_move_extent
          ocfs2_journal_access_di
          ocfs2_split_extent
          ocfs2_journal_dirty
        ocfs2_commit_trans
      ocfs2_move_extent  [2]
        ocfs2_start_trans
        __ocfs2_move_extent
          ocfs2_journal_access_di
          ocfs2_split_extent
          ocfs2_journal_dirty
        ocfs2_commit_trans
    ocfs2_start_trans  [b]
    ocfs2_journal_access_di
    ocfs2_journal_dirty
    ocfs2_commit_trans

In above, [a] and [b] are different transaction start/commit pair, and
each allocates different journal credits, even they are operate the same
bh, they are still different operations.

My another question is, __ocfs2_move_extent will be called by both
ocfs2_defrag_extent and ocfs2_move_extent, why this doesn't happen on the
other path?

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
