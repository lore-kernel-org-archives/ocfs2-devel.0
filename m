Return-Path: <SRS0=sznG=PI=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7667CC433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 20 Oct 2021 20:14:59 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2D090610C8
	for <ocfs2-devel@archiver.kernel.org>; Wed, 20 Oct 2021 20:14:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2D090610C8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KJ7J5L019145;
	Wed, 20 Oct 2021 20:14:58 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3btqypguak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Oct 2021 20:14:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KKBajC102844;
	Wed, 20 Oct 2021 20:14:56 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3br8gurn9h-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 20 Oct 2021 20:14:56 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mdHwA-0008TB-Gf; Wed, 20 Oct 2021 13:11:46 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mdHw7-0008Sl-9e
	for ocfs2-devel@oss.oracle.com; Wed, 20 Oct 2021 13:11:43 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KKBBeQ186408
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Oct 2021 20:11:43 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3bqpj7mswb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Oct 2021 20:11:42 +0000
Received: from pps.filterd (m0246580.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19KHGLWq019451
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Oct 2021 20:11:42 GMT
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com
	[209.85.167.45])
	by mx0b-00069f01.pphosted.com with ESMTP id 3btashc2t7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Oct 2021 20:11:41 +0000
Received: by mail-lf1-f45.google.com with SMTP id y15so164729lfk.7
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Oct 2021 13:11:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=2mjyTuiMt0G/NI9j2uGhr176LQ8tHUDaZsPCBpnXywo=;
	b=aWpfsUbMkeOHd8Uh4T2Au6d0TAldf4JLfvwI/xPIjXJ8b1QliXuBNx45N5z/lZeg8q
	yNgN8KBYQlXiGeJcZ74sspxcYThK9gWPu42zav1uQHx59iX73ufbq3pZzwcxkUOKkuO1
	qywQflAcedE6JFzhhu8JZ69T8MC1KoPIevujkNt1pyaw9KcNkAfd0hsiX4AC3T2K3WMR
	7aiUhWbFVAqcdU4tzQp3mE4oAsmJqgY/W2XL4jn7YECKvosyFzAEyimc6OU1pmJQnBDc
	S3o16/9QXusUZyyxkskXHavD5a2FXIMt3QXiY8sSNnnswK2J/Rcl1+bIFP3LbtsXcXV0
	s8WQ==
X-Gm-Message-State: AOAM531EMK7JpIla1GloyCvoLgcv3jeeNu7LAakxUGZ7EovUANYLbmxp
	EYavIw7jVx3iLF5oxd85+P6kiTPu6qhwuywe
X-Google-Smtp-Source: ABdhPJwrpZT4yaCfHZw5KY1Z1t2qn8YloVqWbiDsbiKKkEmoJDJFEmv0+J5QYqy7Ha2/Cd50/yePXg==
X-Received: by 2002:a05:6512:3e0e:: with SMTP id
	i14mr1240126lfv.639.1634760698806; 
	Wed, 20 Oct 2021 13:11:38 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com.
	[209.85.208.177]) by smtp.gmail.com with ESMTPSA id
	bf20sm322076ljb.137.2021.10.20.13.11.35
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 20 Oct 2021 13:11:36 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id q16so50730ljg.3
	for <ocfs2-devel@oss.oracle.com>; Wed, 20 Oct 2021 13:11:35 -0700 (PDT)
X-Received: by 2002:a2e:9945:: with SMTP id r5mr1210626ljj.249.1634760695569; 
	Wed, 20 Oct 2021 13:11:35 -0700 (PDT)
MIME-Version: 1.0
References: <20211019134204.3382645-1-agruenba@redhat.com>
	<CAHk-=wh0_3y5s7-G74U0Pcjm7Y_yHB608NYrQSvgogVNBxsWSQ@mail.gmail.com>
	<YXBFqD9WVuU8awIv@arm.com>
In-Reply-To: <YXBFqD9WVuU8awIv@arm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 20 Oct 2021 10:11:19 -1000
X-Gmail-Original-Message-ID: <CAHk-=wgv=KPZBJGnx_O5-7hhST8CL9BN4wJwtVuycjhv_1MmvQ@mail.gmail.com>
Message-ID: <CAHk-=wgv=KPZBJGnx_O5-7hhST8CL9BN4wJwtVuycjhv_1MmvQ@mail.gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
X-Source-IP: 209.85.167.45
X-ServerName: mail-lf1-f45.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 mlxlogscore=610
	adultscore=0 malwarescore=0 priorityscore=60 impostorscore=0
	phishscore=0
	mlxscore=0 bulkscore=0 suspectscore=0 clxscore=419 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109230001
	definitions=main-2110200116 domainage_hfrom=5419
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110200116
X-Proofpoint-ORIG-GUID: UVm_vEEzman4rKO9Ezg5u3pOgXSIUErN
X-Proofpoint-GUID: UVm_vEEzman4rKO9Ezg5u3pOgXSIUErN

On Wed, Oct 20, 2021 at 6:37 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> The atomic "add zero" trick isn't that simple for MTE since the arm64
> atomic or exclusive instructions run with kernel privileges and
> therefore with the kernel tag checking mode.

Are there any instructions that are useful for "probe_user_write()"
kind of thing? We could always just add that as an arch function, with
a fallback to using the futex "add zero" if the architecture doesn't
need anything special.

Although at least for MTE, I think the solution was to do a regular
read, and that checks the tag, and then we could use the gup machinery
for the writability checks.

                Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
