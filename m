Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4A0FC76196
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Mar 2023 13:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CDOnASGfKcIdJbuvj641QW99d1ch2PfMj5MaY+NsWyc=;
 b=dNEmthamDxTE1Ee54p2vj/TWfxv/B/NtOvgGkXOPOndJMIb2l6/BqcnBF/mMqYHGSYAvELeiaIhM
   JulecvQ3luIZZJErNSONdYf2KKhV31dx51b5DenQMcqyjtHFwciVbR4ysPJxiIEizLn74XuKKa/K
   ZNwv4anrcJwReixVDyH653HvKyKv/Mn7iO4huAdnEDNx5itZQzyFmjv4PUht/MrgXsh1gxK+Y67p
   wLeCunnuPZjnlgx3OXIFWTzet7H5UOHCg/5Ymr/h275A3L11YaWNsJsYxCoBEr+OAgGXGrc3mwhA
   DI+uyfW2EE2eK9olgmogSvc/b3z06rSpg4j3fA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CDOnASGfKcIdJbuvj641QW99d1ch2PfMj5MaY+NsWyc=;
 b=BIj2621auImXdHHrCKhivJ4I2f0FgBjMwm5uL+rvczL2YOqzLj7jDh/v9+U4FNXlv8FqcjDhPlzK
   Ne/kAvGDda3szM3+it0LTbCVE+ti7HYtANnD7yzJqiZbZZwwzsESpNW7dp+ak7k5hkmFwSUKCaaO
   cueXPYsHhwcGq1p8HAmjjazwp5rwbzq1MTLqwsbpAgN0AlhLiDcKAz/uxVdX4hS9c6sL4BKFGaUM
   HfJZ2c1SvKOEBh5jOneaA+pAP4yFZ6Po74iepfd1Spdw753S36QAv35RxW8mZEQUw/RuJI2An9n9
   0I5e9jowv3+aZevlEKMGGQIu+8smzuOOT9ZYCA==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RS8005MHH8GH700@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 28 Mar 2023 13:53:04 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1680011559; bh=QThtAYBctl4ZF0TdOu9mqdLeJgeOJlgbh5jK+mftH7w=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=y8VIIhD/uhmI4tJx87Zn9eA+rSZ+UkpvsvrVaL/U9Yu48iZ5FbJR5t5oHQ9xykVnc
 jzQo8LGE8W0Zx0iJbmse0OPoLFF+FRJ6w9nIU/+zy0Ugl3w81ffK6D/KK9zfAwfQWn
 fmK3adf1yeMvCzFjhruJVzWbHJXDZbp9HpEhLpsg=
Date: Tue, 28 Mar 2023 15:52:35 +0200
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <ZCLxIwF1Yfi35tqk@kroah.com>
References: <16793134471133@kroah.com>
 <20230321032024.165992-1-joseph.qi@linux.alibaba.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230321032024.165992-1-joseph.qi@linux.alibaba.com>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10662
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=223 lowpriorityscore=0 adultscore=0 impostorscore=0 mlxscore=0
 clxscore=247 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303280110
Cc: Jan Kara <jack@suse.cz>, stable@vger.kernel.org,
 Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix data corruption after failed	write
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
From: Greg KH via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Greg KH <gregkh@linuxfoundation.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: 0lANndoQ9usNNMl5i5Jla_pG4iZ6-mFa
X-Proofpoint-ORIG-GUID: 0lANndoQ9usNNMl5i5Jla_pG4iZ6-mFa
Reporting-Meta:
 AAEFsWvuMoJj1uZZ1G+Ubsh8tRQkkL63tw5ZGrhqIu/CEalCZQaJRBoIQxjAIFmU
 iL1vc+DzKzO+41MzZyEtHvzer60EgL+1tnQSsTpQ1j952ldMKqufaTpne+cjepOP
 7w0Muh9WL22xrRIvXAyDM1mN+U2E/ZehMg1/FQ3M9Uko7E/4p67d3kH5MguAgFW9
 FRnCK2S19pnskhLBc8cckpUKj4MVXE0LqIfEbtgVQtqEFQ8mISjf1iPsWRRsik3k
 o5xHGkxii6Ypxpukzk5MrHI0yp4kv1h72uqZJ6DeTAlwajI6VNDFzTdrb3b2Vhnr
 RivaSNAG/qb8PHBhiZ6vJLdcrfgAL8JBoAglj23ODAaoKFbXQHuxH1Vho97IpE/9
 EadYgi+jT9epagVtdnVmFLmFTw+Pg3iw982aVn+TC8qwA3Ojpx4wYApRpmwgjgb/
 llQvAFjywWGHKMRjrgBzSTqEEJk4+F/UWVvuEARhs97C8Mml0wH+js3iGQvhL9T9
 ASCcxcoVw30IogpVd3DFcdMWDaJAwrgv6Ca2goX64VuQ

On Tue, Mar 21, 2023 at 11:20:24AM +0800, Joseph Qi wrote:
> From: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
> 
> commit 90410bcf873cf05f54a32183afff0161f44f9715 upstream.
> 
> When buffered write fails to copy data into underlying page cache page,
> ocfs2_write_end_nolock() just zeroes out and dirties the page.  This can
> leave dirty page beyond EOF and if page writeback tries to write this page
> before write succeeds and expands i_size, page gets into inconsistent
> state where page dirty bit is clear but buffer dirty bits stay set
> resulting in page data never getting written and so data copied to the
> page is lost.  Fix the problem by invalidating page beyond EOF after
> failed write.
> 
> Link: https://lkml.kernel.org/r/20230302153843.18499-1-jack@suse.cz
> Fixes: 6dbf7bb55598 ("fs: Don't invalidate page buffers in block_write_full_page()")
> Signed-off-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: Mark Fasheh <mark@fasheh.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: Changwei Ge <gechangwei@live.cn>
> Cc: Gang He <ghe@suse.com>
> Cc: Jun Piao <piaojun@huawei.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> [ replace block_invalidate_folio to block_invalidatepage ]
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/aops.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 

Now queued up, thanks.

greg k-h

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
