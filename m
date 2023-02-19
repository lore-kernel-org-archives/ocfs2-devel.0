Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25168C636CC
	for <ocfs2-devel@archiver.kernel.org>; Sun, 19 Feb 2023 11:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/pbXq4BRuKE0ddGPQJ1ntEHA3kORlstAmxgjklTMB34=;
 b=0KeAD5eyg0f7woDfV9QXH6VgXMWHjw/V1blzQNxM6B7BZ8Ra39whPn4llRCUfpGByX93njR1BZDQ
   JjGHpAGunqwyppcQDcoy0wC9eZwhgApPQYnu6UT59VG99bZNGBAV7gbeo0W8NW8+WDFKLjg04wY3
   7y3D523kaCO6NhvAOpsdXYCjFkD5eXmmLwqwQh8Btpfab9i+tegzcXt5LdznRXMbghAGLlvBRzIA
   c5kGsNXH7s3Cmvd3NT07ipMkPUJGx017QAyy7cOIR9doV9XczeIqIVKUDpndG+gN2K7C9FANzffC
   ZoAXZ1qyqKEJj5baBzcicbLlVEcOvjgxWUghuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/pbXq4BRuKE0ddGPQJ1ntEHA3kORlstAmxgjklTMB34=;
 b=pfInZBJjVLvMMDqyCKV+jRmEaHKXWLKQzPxBIxWLJd1AvxTGwuB6eLze9WMLulpCj28gSzgAaQ1I
   4iLy+Mig3JozheuHLSBhXExHV3KgW+xjXCW14UxltJ5t/laSjGVLy2R4y6KccAyXUQXRV4uidsQ4
   U1PGatvENZRkI3F/VCFMJGbRCZGQji0Yr1Qp+Wx08yYrGNfMEJ6GSrYBP9iafq7H1lVhonKC6273
   k8aQayuOh2iVlEEveSgoCSK2+DY8rIOR96m42QxbMyvf1IqP8v+v56WUSLP1x6y8E4FM3DRIxtqG
   NtLOiB7dBpUOwJ6aoDRQ4IGocqy0M1b5VzSyqA==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230206 64bit (built Feb  6
 2023))
 with ESMTPS id <0RQB00OI4R6SX2D0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 19 Feb 2023 11:13:40 +0000 (GMT)
Message-id: <78b869df-258e-513d-dc86-c5d9c5bf5c56@linux.alibaba.com>
Date: Sun, 19 Feb 2023 19:12:50 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, akpm <akpm@linux-foundation.org>
References: <20230217003717.32469-1-heming.zhao@suse.com>
In-reply-to: <20230217003717.32469-1-heming.zhao@suse.com>
X-Source-IP: 115.124.30.118
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10625
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=-106
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 impostorscore=0 mlxscore=0
 adultscore=0 spamscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302190104 domainage_hfrom=8711
Cc: ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix defrag path triggering jbd2	ASSERT
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R211e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045168;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VbyELgU_1676805170;
X-ServerName: out30-118.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: wPkFsX3kjsnmF1esr0HIiGhye52occT2
X-Proofpoint-GUID: wPkFsX3kjsnmF1esr0HIiGhye52occT2
Reporting-Meta:
 AAG4DamGeYwjKac5ggk4dDo1sttfiZKXkhcH4aGNV6kI/2XI4uS55wbJPfO4YZl1
 GJ8yRZKn8dk+so1ljoIrRXrbZMY7QbETiJNEFowfCQyEMox+0EsiGTs5C72W2ObN
 6s5EEMrICbfesRnTBL0wlWecYANjrSVCOzbFGf6tOCv1j52HxDQT4UTuvgipDCxF
 4YltInUVCIKw0jbTP9wPHKW835V06sXBnybiNFM7/j0nuYO5Zx7J9ubzG8+oqlaC
 NQA6PTv9Tz8VYHp5fxrgTrejSzoPicCvJrep4ijnwB84Gmf/G5UucULd8CivMhSV
 nwmP8zO3k0tPYTWLMv6GPHVCMtL31BiD9X7D/XX/er39L5ah7GaEOd9nCB6qaW1+
 nXVE7HzY0fn36jzu0US3a5vfujJi2SZtWLGxAlgnWyoJraDZbTUw3/j4vrWxPpgT
 UYvPK6I9qpRfU9Jqhb7OfSyO3pGKIng9i2c1hIF6lLv+h1zvYPCwe7gJpyzKFlq5
 NwGQpS5ONMDoNiIyiLtUSWmtmIMc/wLwIc4cs3WWkYGS



On 2/17/23 8:37 AM, Heming Zhao wrote:
> code path:
> 
> ocfs2_ioctl_move_extents
>  ocfs2_move_extents
>   ocfs2_defrag_extent
>    __ocfs2_move_extent
>     + ocfs2_journal_access_di
>     + ocfs2_split_extent  //sub-paths call jbd2_journal_restart
>     + ocfs2_journal_dirty //crash by jbs2 ASSERT
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
> Analysis
> 
> This bug has the same root cause of 'commit 7f27ec978b0e ("ocfs2: call
> ocfs2_journal_access_di() before ocfs2_journal_dirty() in ocfs2_write_end_nolock()")'.
> For this bug, jbd2_journal_restart() is called by ocfs2_split_extent()
> during defragmenting.
> 
> How to fix
> 
> For ocfs2_split_extent() can handle journal operations totally by itself.
> Caller doesn't need to call journal access/dirty pair, and caller only
> needs to call journal start/stop pair. The fix method is to remove journal
> access/dirty from __ocfs2_move_extent().
> 
> The discussion for this patch:
> https://oss.oracle.com/pipermail/ocfs2-devel/2023-February/000647.html
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> v1 -> v2:
> - doesn't change any code.
> - change patch subject from "ocfs2: fix J_ASSERT_JH in defragment path"
>   to "ocfs2: fix defrag path triggering jbd2 ASSERT"
> - rewrite/polish commit log
> 
> v1: https://oss.oracle.com/pipermail/ocfs2-devel/2022-May/000101.html
> 
> ---
>  fs/ocfs2/move_extents.c | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index 192cad0662d8..6251748c695b 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -105,14 +105,6 @@ static int __ocfs2_move_extent(handle_t *handle,
>  	 */
>  	replace_rec.e_flags = ext_flags & ~OCFS2_EXT_REFCOUNTED;
>  
> -	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode),
> -				      context->et.et_root_bh,
> -				      OCFS2_JOURNAL_ACCESS_WRITE);
> -	if (ret) {
> -		mlog_errno(ret);
> -		goto out;
> -	}
> -
>  	ret = ocfs2_split_extent(handle, &context->et, path, index,
>  				 &replace_rec, context->meta_ac,
>  				 &context->dealloc);
> @@ -121,8 +113,6 @@ static int __ocfs2_move_extent(handle_t *handle,
>  		goto out;
>  	}
>  
> -	ocfs2_journal_dirty(handle, context->et.et_root_bh);
> -
>  	context->new_phys_cpos = new_p_cpos;
>  
>  	/*

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
