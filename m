Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3143C433EF
	for <ocfs2-devel@archiver.kernel.org>; Thu,  2 Jun 2022 09:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=463KmLbWRvE6B1g06sH9pURAGo/xMgQlHAz8r8GkzQA=;
 b=grbRk1QaNcjLCZKHoJgafHJNnv8vuTUUW7nDDurdSmGqv0q5kOu0itnT0E93QgPOwSHscSE43ors
   8+rChgICpWEsQ+ReprDQM3SBUbTWtD+2GsOAVE/lh0Wt4C3sl8+RrrDctTMDe9So+6OUEZ6h0J2b
   67w3vOV5v3XZfRmzFjkzhjdr7moRHj3FSdgonU6k9DEjLHQUMmtr12DpSWPM1lO/K8F2o0ETNPN3
   qvHRbIIkEz16ClLxBmBPPsq7dQ5tQAXVBTNS1GBc9j2/lIlfNElMRBBDsujlUgLrfFtx6MqOO0s8
   SlP+x9pDUIeEd3tGhNuD1gMlRelphBDxRnaNyg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=463KmLbWRvE6B1g06sH9pURAGo/xMgQlHAz8r8GkzQA=;
 b=pdJjOifsUbrCL8dG05iQTKjK+Q0pLnJVVOOiCp449gSV/QYJgmpIlFMQwK6EjjH1cJeWbu+JmeEO
   eHLrTDoWBDlRh1AbDPqlljS247/2ITngaDV4ryx9yxt52JfrATuphML0/43Oc7oRrT5k08SrJZ+9
   /EMZTBVb0kvSAr8iQd/kmUUXVhzQTKP5gr8Yo1sbS1RKEqbkZnGinlG3KuKTLqgrHqeNkuyUgbWc
   gPhu3Bk+VcHSblONu7S8rB1MGt24l5Kb8yPUg3s9pWl3NrHeuxAmwWGQpgBz3Y1Jsc0/YwsEUL9i
   j4HildLlkXsZTXwHpeB4h9cvs2/Z3Oi3GGVJHQ==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RCU00629FXPXUA0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 02 Jun 2022 09:34:37 +0000 (GMT)
Message-id: <b68e3888-9820-e065-239d-f8c8bb9564f9@linux.alibaba.com>
Date: Thu, 2 Jun 2022 17:34:18 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220521101416.29793-1-heming.zhao@suse.com>
In-reply-to: <20220521101416.29793-1-heming.zhao@suse.com>
X-Source-IP: 115.124.30.131
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10365
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 priorityscore=60
 spamscore=0 clxscore=136 bulkscore=0 mlxlogscore=959 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206020039 domainage_hfrom=8449
Subject: Re: [Ocfs2-devel] [PATCH 1/2] ocfs2: fix jbd2 assertion in	defragment
 path
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R531e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VFA150t_1654162458;
X-ServerName: out30-131.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: 4Kb_vlrCOizjX6T5yV1lTnwboUuh8OnD
X-Proofpoint-ORIG-GUID: 4Kb_vlrCOizjX6T5yV1lTnwboUuh8OnD
Reporting-Meta:
 AAF5leOBf9SoZQCknY4Yc6h7hluHOgaezB/hzX6021D/Lu6ZhNJiEPXLgsOGZ6bq
 VD1cYJG5jszC0VinX0NzIJdQBqiMsV+MVECkvVR4+oDES+BVC+Tq2bT7fiLlp2VJ
 p/9AVsPRDhgVX7yMyayyyL3dIRkpSstZOGCtyq73jQ1ndXhwXNBETM1+0Pv4Spxj
 tTsuF1rL2LGw1CP2FB4/q0weLkKHlLKNyJvhBSLfJ6pP32kDzjv0Y8Hp1q00SMhx
 jIVatXzAxGkSQCjVY/lWXFmMG9VPpV0mybCJXa3x/xNmETR3+m9vG6kCdpJw8RSD
 lTNfvm3Sjd7W5tIPHbZeAZ3jtKWfOoPY0zL3mVj8n5ex2szpBNJzm1NN4Sgobqat
 ZWpC8NogmdTvIPgCz/SI1j+b5BViWLoOLWNVwF0GfmcjJRDyEsmutYXel6ZbWkgt
 9GbV6kkCO5IDFmBVJD7bJsmZHi/zX6MwMZqi7ZoPkSl8wpl2+nj/W1RAyocHuJ2M
 /OfCe+LZLAwTw5P1FbrsAkKH8bkcO9BdHyiBKCw8s8E=

Hi,

Sorry for the late response since I was busy on other things...

On 5/21/22 6:14 PM, Heming Zhao wrote:
> defragfs triggered jbd2 report ASSERT when working.
> 
> code path:
> 
> ocfs2_ioctl_move_extents
>  ocfs2_move_extents
>   __ocfs2_move_extents_range
>    ocfs2_defrag_extent
>     __ocfs2_move_extent
>      + ocfs2_journal_access_di
>      + ocfs2_split_extent  //[1]
>      + ocfs2_journal_dirty //crash
> 
> [1]: ocfs2_split_extent called ocfs2_extend_trans, which committed
> dirty buffers then restarted the transaction. The changed transaction
> triggered jbd2 ASSERT.
> 
> crash stacks:
> 
> PID: 11297  TASK: ffff974a676dcd00  CPU: 67  COMMAND: "defragfs.ocfs2"
>  #0 [ffffb25d8dad3900] machine_kexec at ffffffff8386fe01
>  #1 [ffffb25d8dad3958] __crash_kexec at ffffffff8395959d
>  #2 [ffffb25d8dad3a20] crash_kexec at ffffffff8395a45d
>  #3 [ffffb25d8dad3a38] oops_end at ffffffff83836d3f
>  #4 [ffffb25d8dad3a58] do_trap at ffffffff83833205
>  #5 [ffffb25d8dad3aa0] do_invalid_op at ffffffff83833aa6
>  #6 [ffffb25d8dad3ac0] invalid_op at ffffffff84200d18
>     [exception RIP: jbd2_journal_dirty_metadata+0x2ba]
>     RIP: ffffffffc09ca54a  RSP: ffffb25d8dad3b70  RFLAGS: 00010207
>     RAX: 0000000000000000  RBX: ffff9706eedc5248  RCX: 0000000000000000
>     RDX: 0000000000000001  RSI: ffff97337029ea28  RDI: ffff9706eedc5250
>     RBP: ffff9703c3520200   R8: 000000000f46b0b2   R9: 0000000000000000
>     R10: 0000000000000001  R11: 00000001000000fe  R12: ffff97337029ea28
>     R13: 0000000000000000  R14: ffff9703de59bf60  R15: ffff9706eedc5250
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>  #7 [ffffb25d8dad3ba8] ocfs2_journal_dirty at ffffffffc137fb95 [ocfs2]
>  #8 [ffffb25d8dad3be8] __ocfs2_move_extent at ffffffffc139a950 [ocfs2]
>  #9 [ffffb25d8dad3c80] ocfs2_defrag_extent at ffffffffc139b2d2 [ocfs2]
> 
> The fix method is simple, ocfs2_split_extent includes three paths. all
> the paths already have journal access/dirty pair. We only need to
> remove journal access/dirty from __ocfs2_move_extent.
> 

I am not sure what you mean by "all three paths have journal access/
dirty pair".

It seems we can't do it in your way, as journal access has different
ocfs2_trigger with different offset, e.g. dinode is different from
extent block.

Or we may reserve enough credits to resolve this issue? 

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
