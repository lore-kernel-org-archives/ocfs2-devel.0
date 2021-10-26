Return-Path: <SRS0=myWd=PO=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D556C433F5
	for <ocfs2-devel@archiver.kernel.org>; Tue, 26 Oct 2021 19:18:44 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 13E5660F39
	for <ocfs2-devel@archiver.kernel.org>; Tue, 26 Oct 2021 19:18:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 13E5660F39
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QIbBhd001290;
	Tue, 26 Oct 2021 19:18:43 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bx4g15ux1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Oct 2021 19:18:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19QJBwBE107335;
	Tue, 26 Oct 2021 19:18:42 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3bx4h14a1w-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 26 Oct 2021 19:18:41 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mfRy4-0003Cv-Sg; Tue, 26 Oct 2021 12:18:40 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mfRy1-0003CU-61
	for ocfs2-devel@oss.oracle.com; Tue, 26 Oct 2021 12:18:37 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19QJBWmB174029
	for <ocfs2-devel@oss.oracle.com>; Tue, 26 Oct 2021 19:18:37 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3020.oracle.com with ESMTP id 3bx4gbhjya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 26 Oct 2021 19:18:36 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19QGNqfh030738
	for <ocfs2-devel@oss.oracle.com>; Tue, 26 Oct 2021 19:18:35 GMT
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com
	[209.85.167.46])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bxajujfst-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 26 Oct 2021 19:18:35 +0000
Received: by mail-lf1-f46.google.com with SMTP id u11so1059137lfs.1
	for <ocfs2-devel@oss.oracle.com>; Tue, 26 Oct 2021 12:18:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=VZmINpwcYY7kcvI7sKLaSgNG7WCxmd5BZ4iNpf7lS1s=;
	b=uM4UnxRpCvrzhuNV6lqtdy/wz4I7tE2WB54yez6rKubJmHuIHxM12ezU660uUTi516
	EWFCzpjQO24pD8nzb/iUtggQCkhdhbrb4kUCVkXo4gy0ZJ9QR6aLsKsZLdGXZRf5tSrx
	/J7tFvwK9naYefQCj+5qXucZ01I9sXy89NvWunO536K44IW1XyCYzExAZRzckFLDKk2a
	C+YF2JIauJf4QMMlPaP6POH61ti3MwIEkZFfD89f8mCf4wlwY0uBVcd1e0ScuF/NEucJ
	SIHP9BKjcAt52sDf6bisZyLkGizAweW9yDGvvj70M1VjOKJSoQzr4X2nByGd8YYaFByl
	LtSA==
X-Gm-Message-State: AOAM530pWt24mzD1SkNOaCoB0U1yLjmxxV/GGywK2UFf626DvcHx/R7D
	WIpuG5L455qkajQMZHNwDd+N6KbvNNi1hccI
X-Google-Smtp-Source: ABdhPJySuS0tuTlY0UhNwYOUYoCsrd5BwEm6t93IVT+ZcXZFDJquznYwTK2CTPaWLAqoIoo5nfD05w==
X-Received: by 2002:a19:6913:: with SMTP id e19mr23206579lfc.346.1635275911947;
	Tue, 26 Oct 2021 12:18:31 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com.
	[209.85.208.181])
	by smtp.gmail.com with ESMTPSA id g18sm2012284lfu.4.2021.10.26.12.18.30
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 26 Oct 2021 12:18:31 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id k13so533533ljj.12
	for <ocfs2-devel@oss.oracle.com>; Tue, 26 Oct 2021 12:18:30 -0700 (PDT)
X-Received: by 2002:a2e:bc24:: with SMTP id b36mr28005819ljf.95.1635275910507; 
	Tue, 26 Oct 2021 12:18:30 -0700 (PDT)
MIME-Version: 1.0
References: <20211019134204.3382645-1-agruenba@redhat.com>
	<CAHk-=wh0_3y5s7-G74U0Pcjm7Y_yHB608NYrQSvgogVNBxsWSQ@mail.gmail.com>
	<YXBFqD9WVuU8awIv@arm.com>
	<CAHk-=wgv=KPZBJGnx_O5-7hhST8CL9BN4wJwtVuycjhv_1MmvQ@mail.gmail.com>
	<YXCbv5gdfEEtAYo8@arm.com>
	<CAHk-=wgP058PNY8eoWW=5uRMox-PuesDMrLsrCWPS+xXhzbQxQ@mail.gmail.com>
	<YXL9tRher7QVmq6N@arm.com>
	<CAHk-=wg4t2t1AaBDyMfOVhCCOiLLjCB5TFVgZcV4Pr8X2qptJw@mail.gmail.com>
	<CAHc6FU7BEfBJCpm8wC3P+8GTBcXxzDWcp6wAcgzQtuaJLHrqZA@mail.gmail.com>
	<YXhH0sBSyTyz5Eh2@arm.com>
	<CAHk-=wjWDsB-dDj+x4yr8h8f_VSkyB7MbgGqBzDRMNz125sZxw@mail.gmail.com>
In-Reply-To: <CAHk-=wjWDsB-dDj+x4yr8h8f_VSkyB7MbgGqBzDRMNz125sZxw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Oct 2021 12:18:14 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjm9XwkeqWRy4+OvmdmDojghNSYbu81PxYMoPDJKS_j3A@mail.gmail.com>
Message-ID: <CAHk-=wjm9XwkeqWRy4+OvmdmDojghNSYbu81PxYMoPDJKS_j3A@mail.gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Harry Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
X-Source-IP: 209.85.167.46
X-ServerName: mail-lf1-f46.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10149
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
	mlxscore=0 malwarescore=0
	adultscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
	impostorscore=0
	clxscore=350 priorityscore=100 mlxlogscore=853 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2110150000
	definitions=main-2110260107 domainage_hfrom=5425
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10149 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110260107
X-Proofpoint-ORIG-GUID: bF-KNC2L9FpEjt4-tcI7GfB3f51kZ68y
X-Proofpoint-GUID: bF-KNC2L9FpEjt4-tcI7GfB3f51kZ68y

On Tue, Oct 26, 2021 at 11:50 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Because for _most_ cases of "copy_to/from_user()" and friends by far,
> the only thing we look for is "zero for success".

Gaah. Looking around, I almost immediately found some really odd
exceptions to this.

Like parse_write_buffer_into_params() in amdgpu_dm_debugfs.c, which does

        r = copy_from_user(wr_buf_ptr, buf, wr_buf_size);

                /* r is bytes not be copied */
        if (r >= wr_buf_size) {
                DRM_DEBUG_DRIVER("user data not be read\n");
                return -EINVAL;
        }

and allows a partial copy to justy silently succeed, because all the
callers have pre-cleared the wr_buf_ptr buffer.

I have no idea why the code does that - it seems to imply that user
space could give an invalid 'size' parameter and mean to write only
the part that didn't succeed.

Adding AMD GPU driver people just to point out that this code not only
has odd whitespace, but that the pattern for "couldn't copy from user
space" should basically always be

        if (copy_from_user(wr_buf_ptr, buf, wr_buf_size))
                return -EFAULT;

because if user-space passes in a partially invalid buffer, you
generally really shouldn't say "ok, I got part of it and will use that
part"

There _are_ exceptions. We've had situations where user-space only
passes in the pointer to the buffer, but not the size. Bad interface,
but it historically happens for the 'mount()' system call 'data'
pointer. So then we'll copy "up to a page size".

Anyway, there are clearly some crazy users, and converting them all to
also check for negative error returns might be more painful than I
thought it would be.

                 Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
