Return-Path: <SRS0=ZEQb=M2=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D7EEC4338F
	for <ocfs2-devel@archiver.kernel.org>; Tue,  3 Aug 2021 21:38:35 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 317FB60F8F
	for <ocfs2-devel@archiver.kernel.org>; Tue,  3 Aug 2021 21:38:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 317FB60F8F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 173LZdqn026344;
	Tue, 3 Aug 2021 21:38:34 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a7aq08dqh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Aug 2021 21:38:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 173LZgQt031519;
	Tue, 3 Aug 2021 21:38:32 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3a4un0djbk-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 03 Aug 2021 21:38:31 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mB27K-0006ZL-S4; Tue, 03 Aug 2021 14:38:30 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mB27J-0006Z0-5s
	for ocfs2-devel@oss.oracle.com; Tue, 03 Aug 2021 14:38:29 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	173LaKB7136556
	for <ocfs2-devel@oss.oracle.com>; Tue, 3 Aug 2021 21:38:28 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3a78d5ffgd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 03 Aug 2021 21:38:28 +0000
Received: from pps.filterd (m0246576.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	173LYFdZ030335
	for <ocfs2-devel@oss.oracle.com>; Tue, 3 Aug 2021 21:38:27 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a763nn50w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 03 Aug 2021 21:38:27 +0000
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
	[209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-474-YfUJTezzP_Kgne6_SFBsQA-1; Tue, 03 Aug 2021 17:38:25 -0400
X-MC-Unique: YfUJTezzP_Kgne6_SFBsQA-1
Received: by mail-wm1-f70.google.com with SMTP id
	l38-20020a05600c1d26b0290259bef426efso160509wms.8
	for <ocfs2-devel@oss.oracle.com>; Tue, 03 Aug 2021 14:38:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=EM3F3OHS2L2GE9YJO2LmAbAEq5eEZ/246ein95lIcos=;
	b=Oapf3/wLE7Td8vFMAB0xQcaExR9wmxy/s8sMTX77mJ1ta+1Uv6PhBV9X84XZmNrtFd
	UbFkI5Dl0AJBzrqUiHevNfjjokBiWdS4AuLnYwep2+Uxz+qXwKXS9e0IxLFdkIvrI28K
	X7WprPchms/ghlDY5xeGdsFH3E8CYCdcAHHyCWP8UO/cKgyRqBwq+NJgqejUpAZdj2up
	fNTJUgiNPph3Gnm1bZZg4IZ3AQ0kF38I3tvho+G0CBcj76KbKb/2dd6p23lpfdV8k+Q/
	anbTjZWjQG+/l48sHxjnchPpuBrmdMOqRGZZPZgd9ZbfkAqrkxDk1iX6kFuWD04aGeeP
	2cuw==
X-Gm-Message-State: AOAM532fcOAHG/rniwdD7SOgq0TUgrwFx4sn3trgXlTvxfHBSzGEpE1a
	JBa779yI5PduyxhleH4eFVoLMLTfCpZ9bLrkKFi03wpoUi4o3nrbC54EMd5cyIVg0f1OEQajgGI
	aTGK61VOnFGYr+cP+/Uu/Ja40r5auqDJ2jVBoGg==
X-Received: by 2002:adf:dd8b:: with SMTP id x11mr24885011wrl.357.1628026704025;
	Tue, 03 Aug 2021 14:38:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZzs1zl2V3LTsadj+4bR4O6BnVBDX/GlTJnBJVWvnotmNbJsR03yyQqgOjRCTvd6UqzZnYP7e1CCrvtQ8KSCA=
X-Received: by 2002:adf:dd8b:: with SMTP id x11mr24884995wrl.357.1628026703875;
	Tue, 03 Aug 2021 14:38:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210803191818.993968-1-agruenba@redhat.com>
	<20210803191818.993968-4-agruenba@redhat.com>
	<YQmtnuqDwBIBf4N+@zeniv-ca.linux.org.uk>
In-Reply-To: <YQmtnuqDwBIBf4N+@zeniv-ca.linux.org.uk>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Tue, 3 Aug 2021 23:38:12 +0200
Message-ID: <CAHc6FU7iAPOPO7gtDjpSAVyHwgJ7HQPEhDC_2T__DM8GPW5crQ@mail.gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=agruenba@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.111.0.0/16
	ip4:136.147.128.0/20 ip4:136.147.176.0/20 ip4:148.105.8.0/21
	ip4:148.139.0.2 include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-Source-IP: 170.10.133.124
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.111.0.0/16
	ip4:136.147.128.0/20 ip4:136.147.176.0/20 ip4:148.105.8.0/21
	ip4:148.139.0.2 include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065
	signatures=668682
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	mlxscore=0 adultscore=0
	malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108030135
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v5 03/12] Turn fault_in_pages_{readable,
	writeable} into fault_in_{readable, writeable}
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108030135
X-Proofpoint-ORIG-GUID: EH7VQIjPPDhgqBRohgeNnHSg2iJvrOuN
X-Proofpoint-GUID: EH7VQIjPPDhgqBRohgeNnHSg2iJvrOuN

On Tue, Aug 3, 2021 at 10:57 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Aug 03, 2021 at 09:18:09PM +0200, Andreas Gruenbacher wrote:
> > Turn fault_in_pages_{readable,writeable} into versions that return the number
> > of bytes faulted in instead of returning a non-zero value when any of the
> > requested pages couldn't be faulted in.  This supports the existing users that
> > require all pages to be faulted in, but also new users that are happy if any
> > pages can be faulted in.
> >
> > Neither of these functions is entirely trivial and it doesn't seem useful to
> > inline them, so move them to mm/gup.c.
> >
> > Rename the functions to fault_in_{readable,writeable} to make sure that code
> > that uses them can be fixed instead of breaking silently.
>
> Sigh...  We'd already discussed that; it's bloody pointless.  Making short
> fault-in return success - absolutely.  Reporting exact number of bytes is
> not going to be of any use to callers.

I'm not actually convinced that you're right about this. Let's see
what we'll end up with; we can always strip things down in the end.

Thanks,
Andreas


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
