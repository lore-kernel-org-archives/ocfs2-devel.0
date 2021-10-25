Return-Path: <SRS0=IoPu=PN=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F472C433F5
	for <ocfs2-devel@archiver.kernel.org>; Mon, 25 Oct 2021 19:40:53 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 26D9961215
	for <ocfs2-devel@archiver.kernel.org>; Mon, 25 Oct 2021 19:40:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 26D9961215
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PJEFNt030931;
	Mon, 25 Oct 2021 19:40:52 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bx1vxratt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Oct 2021 19:40:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19PJZrUP106422;
	Mon, 25 Oct 2021 19:40:51 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bvv5sm3aw-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 25 Oct 2021 19:40:50 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mf5mv-0008JJ-0y; Mon, 25 Oct 2021 12:37:41 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mf5mt-0008Ix-Qd
	for ocfs2-devel@oss.oracle.com; Mon, 25 Oct 2021 12:37:39 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19PJZtnA069452
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 19:37:39 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by userp3030.oracle.com with ESMTP id 3bv7gv811h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 19:37:39 +0000
Received: from pps.filterd (m0246573.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19PJRsA9003405
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 19:37:38 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [216.205.24.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bx2re8368-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 19:37:37 +0000
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
	[209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-523-YZbbziWONMCzHhz44llFeQ-1; Mon, 25 Oct 2021 15:37:34 -0400
X-MC-Unique: YZbbziWONMCzHhz44llFeQ-1
Received: by mail-wm1-f70.google.com with SMTP id
	5-20020a1c0005000000b0032c9c156acbso4061594wma.9
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 12:37:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=9aAky+o+A3o8orvEWSZgWo8dAX6pVohf78faelvH+XE=;
	b=awcqjogXC+b/afVXMjtk3QCglrHHO127TxDzr+LCc7ZBj4xbTPg+ZFFCgwQ21cxl0X
	DHhj+lw8j9sjtJqwR/osNGTryfCCJh3ClLOUwZ3oI8bNTpPgLu9Nl4HcRWuTYrVlcVNL
	OmGwazTBMcs4A9bdg8CkRpL3HdHtHwwbnXN/Ioo6YU3EfZGqTX6qnuFHfydputPYBVt7
	H+ZEkwJbJ28x7WoXX2b9UgiKkpTnICPdi89ugPftIBlpSdG51EwftklvBmI5yXRuNO9i
	vqyM/x48paEWmUYW0O/oT/cIlz/hXRhb0jRXAyw2nvDAC6PXZV5Ih1XrfTBQOt7vbm3y
	vxBQ==
X-Gm-Message-State: AOAM5325TH6/fPdE/dbixv/zOLW2YIetwS41UoBTRTvlf80sSLb7bDq8
	w+ATUCRT2klDe/KQCpOzFiaOiky2oz6AfPxE5AjbPzLhS+H+TbXmVs094ZmAfkmocSGECDWWyVK
	Swz+wgO1fBKXiKXAmxC4j9eRx5f7I7+L8Jq1Gow==
X-Received: by 2002:adf:e411:: with SMTP id g17mr24943041wrm.228.1635190653765;
	Mon, 25 Oct 2021 12:37:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4ZUW3Mo472pPGFPqydjyYBJNjFGoCJJfUViSULsVvl27H2hHnmzQ8wgBE36rQvAagQBtIOpD1/zpOLrWd37Q=
X-Received: by 2002:adf:e411:: with SMTP id g17mr24943016wrm.228.1635190653583;
	Mon, 25 Oct 2021 12:37:33 -0700 (PDT)
MIME-Version: 1.0
References: <YS5KudP4DBwlbPEp@zeniv-ca.linux.org.uk> <YWR2cPKeDrc0uHTK@arm.com>
	<CAHk-=wjvQWj7mvdrgTedUW50c2fkdn6Hzxtsk-=ckkMrFoTXjQ@mail.gmail.com>
	<YWSnvq58jDsDuIik@arm.com>
	<CAHk-=wiNWOY5QW5ZJukt_9pHTWvrJhE2=DxPpEtFHAWdzOPDTg@mail.gmail.com>
	<CAHc6FU7bpjAxP+4dfE-C0pzzQJN1p=C2j3vyXwUwf7fF9JF72w@mail.gmail.com>
	<YXE7fhDkqJbfDk6e@arm.com>
	<CAHc6FU5xTMOxuiEDyc9VO_V98=bvoDc-0OFi4jsGPgWJWjRJWQ@mail.gmail.com>
	<YXGexrdprC+NTslm@arm.com>
	<CAHc6FU7im8UzxWCzqUFMKOwyg9zoQ8OZ_M+rRC_E20yE5RNu9g@mail.gmail.com>
	<YXMFw34ZpW+CwlmI@arm.com>
In-Reply-To: <YXMFw34ZpW+CwlmI@arm.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 25 Oct 2021 21:37:22 +0200
Message-ID: <CAHc6FU43-n3tk+vvhXKCX+oyUu4x23-vh8pg18wRgYsB0rt+rA@mail.gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
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
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
	ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
	include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-Source-IP: 216.205.24.124
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:103.23.64.2 ip4:103.23.65.2
	ip4:103.23.66.26 ip4:103.23.67.26
	ip4:107.21.15.141 ip4:108.177.8.0/21 ip4:128.17.0.0/20
	ip4:128.17.128.0/20
	ip4:128.17.192.0/20 ip4:128.17.64.0/20 ip4:128.245.0.0/20
	ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
	ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
	include:spf1.redhat.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10148
	signatures=668683
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Will Deacon <will@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10148 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110250114
X-Proofpoint-ORIG-GUID: moHMMcGDUfrzw4oUC9I_y4mTpFKBj0q2
X-Proofpoint-GUID: moHMMcGDUfrzw4oUC9I_y4mTpFKBj0q2

On Fri, Oct 22, 2021 at 8:41 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Thu, Oct 21, 2021 at 08:00:50PM +0200, Andreas Gruenbacher wrote:
> > On Thu, Oct 21, 2021 at 7:09 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > This discussion started with the btrfs search_ioctl() where, even if
> > > some bytes were written in copy_to_sk(), it always restarts from an
> > > earlier position, reattempting to write the same bytes. Since
> > > copy_to_sk() doesn't guarantee forward progress even if some bytes are
> > > writable, Linus' suggestion was for fault_in_writable() to probe the
> > > whole range. I consider this overkill since btrfs is the only one that
> > > needs probing every 16 bytes. The other cases like the new
> > > fault_in_safe_writeable() can be fixed by probing the first byte only
> > > followed by gup.
> >
> > Hmm. Direct I/O request sizes are multiples of the underlying device
> > block size, so we'll also get stuck there if fault-in won't give us a
> > full block. This is getting pretty ugly. So scratch that idea; let's
> > stick with probing the whole range.
>
> Ah, I wasn't aware of this. I got lost in the call trees but I noticed
> __iomap_dio_rw() does an iov_iter_revert() only if direction is READ. Is
> this the case for writes as well?

It's the EOF case, so it only applies to reads:

        /*
         * We only report that we've read data up to i_size.
         * Revert iter to a state corresponding to that as some callers (such
         * as the splice code) rely on it.
         */
        if (iov_iter_rw(iter) == READ && iomi.pos >= dio->i_size)
                iov_iter_revert(iter, iomi.pos - dio->i_size);

Andreas


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
