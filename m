Return-Path: <SRS0=rA73=PP=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44CF1C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 27 Oct 2021 21:18:29 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D9FC76113B
	for <ocfs2-devel@archiver.kernel.org>; Wed, 27 Oct 2021 21:18:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D9FC76113B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RL51ot017567;
	Wed, 27 Oct 2021 21:18:28 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fg4rna-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Oct 2021 21:18:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19RLBvv7071972;
	Wed, 27 Oct 2021 21:18:26 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bx4grr7nn-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 27 Oct 2021 21:18:26 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mfqGS-0002i7-FN; Wed, 27 Oct 2021 14:15:16 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mfqGO-0002ho-SS
	for ocfs2-devel@oss.oracle.com; Wed, 27 Oct 2021 14:15:13 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19RLBwCb072037
	for <ocfs2-devel@oss.oracle.com>; Wed, 27 Oct 2021 21:15:12 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3020.oracle.com with ESMTP id 3bx4grr3tx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 27 Oct 2021 21:15:11 +0000
Received: from pps.filterd (m0246575.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19RHWUBE011503
	for <ocfs2-devel@oss.oracle.com>; Wed, 27 Oct 2021 21:15:10 GMT
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com
	[209.85.208.177])
	by mx0b-00069f01.pphosted.com with ESMTP id 3by9bsvqxj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 27 Oct 2021 21:15:08 +0000
Received: by mail-lj1-f177.google.com with SMTP id 205so6937806ljf.9
	for <ocfs2-devel@oss.oracle.com>; Wed, 27 Oct 2021 14:15:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=hiXmABk2yLJcTBwV/OV64LUSAMHnd37fHZz79FC6JvU=;
	b=dGdDCzmpxPLH8PHapEkw/sXo2THZQ/xLYSVDx9lIBpiWv7BOS9RXtOyIAjj5PjusBV
	pMiGwFayWBwnAg+6hTpdZzldYJP/ajlctxlmppgJIxfqo156yNu6oHGVGv4h7YTREHkE
	YAnegdXe6ArE4syuRr2qXN4UQwmkg5b2GAdYyJPpD+YCxM3avHf2A9vhg2wIkB34SdwP
	1y20uNYkpQESCHiY+MSiHaS1LZoYzceiTOTrDXl6zFF0F9Iges8oo5X8+ouWalE5t3b7
	U/2jFS12TfFelV7ihjgzSO27zsCxwKfyQVn68aBk31jW/sMYCFP1g2uJK9y/xJjWDLMB
	Pb1Q==
X-Gm-Message-State: AOAM532aVrVOYNYPIg2AJSelV9/ysRUdHRNURRUzvTuOgM1RbNgtlZV3
	0+6HrLNtbWXJedH9NxA3RpPL68G8iJ3OTODO
X-Google-Smtp-Source: ABdhPJyKRQCqbiUQtpfwBwShu5TDW5wlID8XQ19ydhbsvrFFVe+sEcdTmLbzCnjB6Mova3AyEfgI1w==
X-Received: by 2002:a2e:9205:: with SMTP id k5mr273752ljg.451.1635369305358;
	Wed, 27 Oct 2021 14:15:05 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com.
	[209.85.167.48])
	by smtp.gmail.com with ESMTPSA id q5sm90559ljb.125.2021.10.27.14.15.04
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 27 Oct 2021 14:15:05 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id bq11so8941372lfb.10
	for <ocfs2-devel@oss.oracle.com>; Wed, 27 Oct 2021 14:15:04 -0700 (PDT)
X-Received: by 2002:a19:f619:: with SMTP id x25mr90493lfe.141.1635369304547;
	Wed, 27 Oct 2021 14:15:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wh0_3y5s7-G74U0Pcjm7Y_yHB608NYrQSvgogVNBxsWSQ@mail.gmail.com>
	<YXBFqD9WVuU8awIv@arm.com>
	<CAHk-=wgv=KPZBJGnx_O5-7hhST8CL9BN4wJwtVuycjhv_1MmvQ@mail.gmail.com>
	<YXCbv5gdfEEtAYo8@arm.com>
	<CAHk-=wgP058PNY8eoWW=5uRMox-PuesDMrLsrCWPS+xXhzbQxQ@mail.gmail.com>
	<YXL9tRher7QVmq6N@arm.com>
	<CAHk-=wg4t2t1AaBDyMfOVhCCOiLLjCB5TFVgZcV4Pr8X2qptJw@mail.gmail.com>
	<CAHc6FU7BEfBJCpm8wC3P+8GTBcXxzDWcp6wAcgzQtuaJLHrqZA@mail.gmail.com>
	<YXhH0sBSyTyz5Eh2@arm.com>
	<CAHk-=wjWDsB-dDj+x4yr8h8f_VSkyB7MbgGqBzDRMNz125sZxw@mail.gmail.com>
	<YXmkvfL9B+4mQAIo@arm.com>
In-Reply-To: <YXmkvfL9B+4mQAIo@arm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 Oct 2021 14:14:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjQqi9cw1Guz6a8oBB0xiQNF_jtFzs3gW0k7+fKN-mB1g@mail.gmail.com>
Message-ID: <CAHk-=wjQqi9cw1Guz6a8oBB0xiQNF_jtFzs3gW0k7+fKN-mB1g@mail.gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
X-Source-IP: 209.85.208.177
X-ServerName: mail-lj1-f177.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10150
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	priorityscore=70 impostorscore=0
	phishscore=0 adultscore=0 clxscore=341 malwarescore=0 bulkscore=0
	mlxscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=621
	suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000
	definitions=main-2110270119 domainage_hfrom=5426
X-Spam: Clean
Cc: kvm-ppc@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v8 00/17] gfs2: Fix mmap + page fault
	deadlocks
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10150 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110270119
X-Proofpoint-ORIG-GUID: 2sKoBBcY6cD1UDp35ouCZOvxNck1jmsw
X-Proofpoint-GUID: 2sKoBBcY6cD1UDp35ouCZOvxNck1jmsw

On Wed, Oct 27, 2021 at 12:13 PM Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
> As an alternative, you mentioned earlier that a per-thread fault status
> was not feasible on x86 due to races. Was this only for the hw poison
> case? I think the uaccess is slightly different.

It's not x86-specific, it's very generic.

If we set some flag in the per-thread status, we'll need to be careful
about not overwriting it if we then have a subsequent NMI that _also_
takes a (completely unrelated) page fault - before we then read the
per-thread flag.

Think 'perf' and fetching backtraces etc.

Note that the NMI page fault can easily also be a pointer coloring
fault on arm64, for exactly the same reason that whatever original
copy_from_user() code was. So this is not a "oh, pointer coloring
faults are different". They have the same re-entrancy issue.

And both the "pagefault_disable" and "fault happens in interrupt
context" cases are also the exact same 'faulthandler_disabled()'
thing. So even at fault time they look very similar.

So we'd have to have some way to separate out only the one we care about.

               Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
