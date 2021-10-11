Return-Path: <SRS0=+lI3=PA=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6AB1C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 12 Oct 2021 00:00:22 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5F27460F11
	for <ocfs2-devel@archiver.kernel.org>; Tue, 12 Oct 2021 00:00:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5F27460F11
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BNQ9Ni017592;
	Tue, 12 Oct 2021 00:00:21 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bmtmk1ykj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Oct 2021 00:00:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19BNt3mu153569;
	Tue, 12 Oct 2021 00:00:19 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bkyv95t5w-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 12 Oct 2021 00:00:19 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1ma5DO-00055y-FW; Mon, 11 Oct 2021 17:00:18 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1ma5Cy-0004ym-Kv
	for ocfs2-devel@oss.oracle.com; Mon, 11 Oct 2021 16:59:52 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19BNt39x069166
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 23:59:52 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3bkyv7w21j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 23:59:51 +0000
Received: from pps.filterd (m0246574.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19BJXCtb004391
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 23:59:50 GMT
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com
	[209.85.167.42])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bmuhab0sy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 23:59:50 +0000
Received: by mail-lf1-f42.google.com with SMTP id r19so77511809lfe.10
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 16:59:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=OgVSO9l8+qaj3s+luNrigHMuS+kRVTnezRpRHPjbW94=;
	b=299AYyPzHKfOrjPjC5xxW7mUVPrLZNAgW9P9MJngqZ0DQEFATFcdGjlWEsKfz0Tt7w
	GA1T0CVv/s7ODXUukbDpsPKlwTTrWkDhJiOZQ0p3RqHF7HDigGlB50vseRAcpadbXipn
	ZDUhssrwBTIP/yhqKDibAGyevgXXlXaOdydDX80JSYwGEiA8HThNaVUrcsi+Bn2Fc2Wi
	c50F/05zgSIQKYddsjPrS+ZYLpzZQ4pIcfGK4/WXuWP3RmecAiGdpqPQ8+4ILrZ1HHUm
	W2pE03h0Ef4iG78n+tz9kB3aBG5itBu/EPaJEoqR51MKW5X10ZxuzN5c9axdIX5tcmSw
	gLPA==
X-Gm-Message-State: AOAM531FEZRdh0xi4TqXWtHF5UupBVBWzVptrFoXFoojeLpmK/WWmCoj
	CUlFxnHw8emKzwAF8u8JH6M4IFGssB1k/25s
X-Google-Smtp-Source: ABdhPJzkBpz1ujwymtm5rJK4yy3CJpINzlWKy1eJN2cxloC8a5VjVE5oTn1jNAo217Rowb1SPOig4g==
X-Received: by 2002:a19:2d14:: with SMTP id k20mr30010189lfj.56.1633996786899; 
	Mon, 11 Oct 2021 16:59:46 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com.
	[209.85.167.41]) by smtp.gmail.com with ESMTPSA id
	y25sm836328lfg.179.2021.10.11.16.59.44
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 11 Oct 2021 16:59:44 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id i24so78237529lfj.13
	for <ocfs2-devel@oss.oracle.com>; Mon, 11 Oct 2021 16:59:44 -0700 (PDT)
X-Received: by 2002:a05:6512:139b:: with SMTP id
	p27mr30802647lfa.173.1633996784057; 
	Mon, 11 Oct 2021 16:59:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wh5p6zpgUUoY+O7e74X9BZyODhnsqvv=xqnTaLRNj3d_Q@mail.gmail.com>
	<YSk7xfcHVc7CxtQO@zeniv-ca.linux.org.uk>
	<CAHk-=wjMyZLH+ta5SohAViSc10iPj-hRnHc-KPDoj1XZCmxdBg@mail.gmail.com>
	<YSk+9cTMYi2+BFW7@zeniv-ca.linux.org.uk>
	<YSldx9uhMYhT/G8X@zeniv-ca.linux.org.uk>
	<YSqOUb7yZ7kBoKRY@zeniv-ca.linux.org.uk> <YS40qqmXL7CMFLGq@arm.com>
	<YS5KudP4DBwlbPEp@zeniv-ca.linux.org.uk> <YWR2cPKeDrc0uHTK@arm.com>
	<CAHk-=wjvQWj7mvdrgTedUW50c2fkdn6Hzxtsk-=ckkMrFoTXjQ@mail.gmail.com>
	<YWSnvq58jDsDuIik@arm.com>
In-Reply-To: <YWSnvq58jDsDuIik@arm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Oct 2021 16:59:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiNWOY5QW5ZJukt_9pHTWvrJhE2=DxPpEtFHAWdzOPDTg@mail.gmail.com>
Message-ID: <CAHk-=wiNWOY5QW5ZJukt_9pHTWvrJhE2=DxPpEtFHAWdzOPDTg@mail.gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
X-Source-IP: 209.85.167.42
X-ServerName: mail-lf1-f42.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10134
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
	suspectscore=0
	mlxscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0 clxscore=414
	spamscore=0 mlxlogscore=777 priorityscore=60 adultscore=0 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001
	definitions=main-2110110136 domainage_hfrom=5410
X-Spam: Clean
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [RFC][arm64] possible infinite loop in btrfs
	search_ioctl()
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10134 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110136
X-Proofpoint-GUID: LwsUBlV0RyOLzlC_1gK7Blkp-5IUHYJz
X-Proofpoint-ORIG-GUID: LwsUBlV0RyOLzlC_1gK7Blkp-5IUHYJz

On Mon, Oct 11, 2021 at 2:08 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> +#ifdef CONFIG_ARM64_MTE
> +#define FAULT_GRANULE_SIZE     (16)
> +#define FAULT_GRANULE_MASK     (~(FAULT_GRANULE_SIZE-1))

[...]

> If this looks in the right direction, I'll do some proper patches
> tomorrow.

Looks fine to me. It's going to be quite expensive and bad for caches, though.

That said, fault_in_writable() is _supposed_ to all be for the slow
path when things go south and the normal path didn't work out, so I
think it's fine.

I do wonder how the sub-page granularity works. Is it sufficient to
just read from it? Because then a _slightly_ better option might be to
do one write per page (to catch page table writability) and then one
read per "granule" (to catch pointer coloring or cache poisoning
issues)?

That said, since this is all preparatory to us wanting to write to it
eventually anyway, maybe marking it all dirty in the caches is only
good.

                Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
