Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37639C43334
	for <ocfs2-devel@archiver.kernel.org>; Fri, 10 Jun 2022 07:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yB8KeQ8XrrPezF8qktcMPrpuK0+0z7HicpeXxLzUP6o=;
 b=h9TB71kfVoPhE3UVeOPY5sw4F+FbQWnvr4yhZM3qUzDWN/pseEm4wzYZeqp1PKkyDvdQ54ewxmEg
   VY6BOxm9a7bfMH76Hsi9zyHzHijXLfjJ+wtYFzwJnwunA3PdVUXaVBJ74dNOFoxlrTRIrj/fmLsw
   crL8fkVNYvWKn9Jzea95HpTcnBDn1ocg7zyua+HiCQqSZngOMdhoqECB4q6HNnu9bG1sTMjilGaG
   19D0fezEajyX47vaI0/y2cbO023cl4s8K9GH82mZPY1PRmWvk5j2VtffGOcllHHX4mgzgMxm4u3x
   2Wk3ve5jF0jnz7gnZgZzYdfIXI04qk43ni9GlQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yB8KeQ8XrrPezF8qktcMPrpuK0+0z7HicpeXxLzUP6o=;
 b=J2bkmfX/7yfCLUcvHyTJnBrn9vtmGoo72a1lOlQiM4ZwkSU5ue0wdbfVA6Yzlnxf6JRA/vrHU/yt
   H8lzbYMCjzsuOTS+VDeP2eu7UiWgn90k/jrkLugJAHOFRDAkvIBLZf1l6k7sTTU4iM1gkxcB8DTO
   zy4lrKP5vDUSc5kzn2kph3pE833sKTIkAjz38OAs+m/l3++a0E0vdJx3IGHXf1rGwdVWTx1GgZQg
   TXSYdUy3QrJNSY/ruj9rYY2GvAfjs3wRNdx0Qq9i9YYmt+pUJHhhEopwg+to0ykpsaFHaozg00+9
   eqfkxTXGgiaXz1s7HaTkfT0P5YyJW56lUHSmAQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD900EBD49FS860@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 10 Jun 2022 07:46:27 +0000 (GMT)
Message-id: <729b67e8-51f0-87e1-e157-bcfea6f4b503@linux.alibaba.com>
Date: Fri, 10 Jun 2022 15:46:07 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220521101416.29793-1-heming.zhao@suse.com>
 <b68e3888-9820-e065-239d-f8c8bb9564f9@linux.alibaba.com>
 <20220604000828.2b3arxq6txtq22d4@c73>
In-reply-to: <20220604000828.2b3arxq6txtq22d4@c73>
X-Source-IP: 115.124.30.57
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10373
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=99
 mlxlogscore=881 impostorscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=70 bulkscore=0 malwarescore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206100026 domainage_hfrom=8457
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R131e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045168;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VFyAv9q_1654847167;
X-ServerName: out30-57.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: AhRTybhwb8G-ndfikhuRDiQlsVpwHSna
X-Proofpoint-GUID: AhRTybhwb8G-ndfikhuRDiQlsVpwHSna
Reporting-Meta:
 AAEiwLp8IjCjsmw/JHL/mXSqLy/Pbot1gXWVoaxzx/tKnPX1Lk1zPemgaAU1qviB
 Bq8Nizxgi6mtyNf6UNSYLLVs8eGRyiU6qS65yvYG1oE2dlXHuKs+1IW+W9B+vTL8
 uaWg3YvmrlcGr4pVWCauMp3vrihffmSEGTiisyOIaZzindpvCvmZPVd5/26FeXR/
 gF9wUzRYKfyj9o+jsXlV573D3MY9j2B+puswPV5js9XOEgzjFcndjA+Y68kxaIvb
 4LexDTJ5CtQNqiLsdUNJF5P36lNzihslzP+yrgVkvc6rN05dEOnvRkBMANzJkfqE
 GZ+3WJngCntTxwHtFJbcT5ey9/l6YfxVXD9kcSWoOrvRDk9IMuXox0KvrWXy7uwJ
 de90PvpAYM1DsmSdxPYqgxb6UkOCONJ9yCdTmhq+NYBSN/P8i2treIgoG/MDitxF
 8p5ANbKYr2aI+GHoadQISiXnzvrZuhMV4DLxhWK9iADepLG9QsS409Z3pNixkc0y
 1kSDhtSKvPRCD3n6gqxpByEAo4iFEQEcgq0xfdbJ6bU=



On 6/4/22 8:08 AM, Heming Zhao wrote:
> On Thu, Jun 02, 2022 at 05:34:18PM +0800, Joseph Qi wrote:
>> Hi,
>>
>> Sorry for the late response since I was busy on other things...
>>
>> On 5/21/22 6:14 PM, Heming Zhao wrote:
>>> defragfs triggered jbd2 report ASSERT when working.
>>>
>>> code path:
>>>
>>> ocfs2_ioctl_move_extents
>>>  ocfs2_move_extents
>>>   __ocfs2_move_extents_range
>>>    ocfs2_defrag_extent
>>>     __ocfs2_move_extent
>>>      + ocfs2_journal_access_di
>>>      + ocfs2_split_extent  //[1]
>>>      + ocfs2_journal_dirty //crash
>>>
>>> [1]: ocfs2_split_extent called ocfs2_extend_trans, which committed
>>> dirty buffers then restarted the transaction. The changed transaction
>>> triggered jbd2 ASSERT.
>>>
>>> crash stacks:
>>>
>>> PID: 11297  TASK: ffff974a676dcd00  CPU: 67  COMMAND: "defragfs.ocfs2"
>>>  #0 [ffffb25d8dad3900] machine_kexec at ffffffff8386fe01
>>>  #1 [ffffb25d8dad3958] __crash_kexec at ffffffff8395959d
>>>  #2 [ffffb25d8dad3a20] crash_kexec at ffffffff8395a45d
>>>  #3 [ffffb25d8dad3a38] oops_end at ffffffff83836d3f
>>>  #4 [ffffb25d8dad3a58] do_trap at ffffffff83833205
>>>  #5 [ffffb25d8dad3aa0] do_invalid_op at ffffffff83833aa6
>>>  #6 [ffffb25d8dad3ac0] invalid_op at ffffffff84200d18
>>>     [exception RIP: jbd2_journal_dirty_metadata+0x2ba]
>>>     RIP: ffffffffc09ca54a  RSP: ffffb25d8dad3b70  RFLAGS: 00010207
>>>     RAX: 0000000000000000  RBX: ffff9706eedc5248  RCX: 0000000000000000
>>>     RDX: 0000000000000001  RSI: ffff97337029ea28  RDI: ffff9706eedc5250
>>>     RBP: ffff9703c3520200   R8: 000000000f46b0b2   R9: 0000000000000000
>>>     R10: 0000000000000001  R11: 00000001000000fe  R12: ffff97337029ea28
>>>     R13: 0000000000000000  R14: ffff9703de59bf60  R15: ffff9706eedc5250
>>>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>>>  #7 [ffffb25d8dad3ba8] ocfs2_journal_dirty at ffffffffc137fb95 [ocfs2]
>>>  #8 [ffffb25d8dad3be8] __ocfs2_move_extent at ffffffffc139a950 [ocfs2]
>>>  #9 [ffffb25d8dad3c80] ocfs2_defrag_extent at ffffffffc139b2d2 [ocfs2]
>>>
>>> The fix method is simple, ocfs2_split_extent includes three paths. all
>>> the paths already have journal access/dirty pair. We only need to
>>> remove journal access/dirty from __ocfs2_move_extent.
>>>
>>
>> I am not sure what you mean by "all three paths have journal access/
>> dirty pair".
> 
> I am a newbie for ocfs2 & jbd2, I can't make sure this [1/2] patch is correct.
> Below is my analysis.
> 
> All three paths (below 1.[123]):
> 
> __ocfs2_move_extent
>  + ocfs2_journal_access_di
>  |
>  + ocfs2_split_extent           //[1]
>  |  + ocfs2_replace_extent_rec  //[1.1]
>  |  + ocfs2_split_and_insert    //[1.2]
>  |  + ocfs2_try_to_merge_extent //[1.3]
>  |
>  + + ocfs2_journal_dirty       //crash
> 
> All three paths have itselves journal access/dirty pair.
> So the access/dirty pair in caller __ocfs2_move_extent is unnecessary.
> 

ocfs2_journal_access_xxx() is to notify jbd2 to do a specific operation
to a bh. I said in my last mail, they are for different bh.

>>
>> It seems we can't do it in your way, as journal access has different
>> ocfs2_trigger with different offset, e.g. dinode is different from
>> extent block.
> 
> There are 3 ocfs2_split_extent callers:
>  fs/ocfs2/alloc.c <<ocfs2_change_extent_flag>>
>  fs/ocfs2/move_extents.c <<__ocfs2_move_extent>>
>  fs/ocfs2/refcounttree.c <<ocfs2_clear_ext_refcount>>
> 
> We can see, except defrag flow (caller __ocfs2_move_extent), other two
> don't use jbd2 access/dirty pair around ocfs2_split_extent.
> 

Not exactly, you have to take look the whole flow.

Thanks,
Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
