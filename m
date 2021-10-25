Return-Path: <SRS0=IoPu=PN=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A4C8C433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon, 25 Oct 2021 19:01:11 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 244046108B
	for <ocfs2-devel@archiver.kernel.org>; Mon, 25 Oct 2021 19:01:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 244046108B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PISE8T022613;
	Mon, 25 Oct 2021 19:01:10 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3bx1vxr5cx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Oct 2021 19:01:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19PIxsOO170776;
	Mon, 25 Oct 2021 19:01:07 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3bvv5sj6k2-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 25 Oct 2021 19:01:07 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mf5DW-00078R-Gk; Mon, 25 Oct 2021 12:01:06 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <agruenba@redhat.com>) id 1mf5DT-00078B-Lk
	for ocfs2-devel@oss.oracle.com; Mon, 25 Oct 2021 12:01:03 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19PItUmo154795
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 19:01:03 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 3bva76xjve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 19:01:02 +0000
Received: from pps.filterd (m0246575.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19PIwkLu026735
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 19:01:01 GMT
Received: from us-smtp-delivery-124.mimecast.com
	(us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by mx0b-00069f01.pphosted.com with ESMTP id 3bwytvt2da-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 19:01:01 +0000
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
	[209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-562-iUKUSM-eMk2iOecezc1eFA-1; Mon, 25 Oct 2021 15:00:56 -0400
X-MC-Unique: iUKUSM-eMk2iOecezc1eFA-1
Received: by mail-wm1-f70.google.com with SMTP id
	r205-20020a1c44d6000000b0032cb058fe13so1937820wma.7
	for <ocfs2-devel@oss.oracle.com>; Mon, 25 Oct 2021 12:00:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=QkyoC/NexH1Nu0O2R4wJhF/62iz6WrFzKuF9woFeRsA=;
	b=MvMUBIaA552MMchqTHaoBv45nxWlxTOzYsr6YEHLmefFWqQY8t3aIzRQwj+CHvpGBZ
	W7nmPHiAID8zGWbwcGvWui02EWTnNlmOSwpd37IolhdI2kwMfuzkY5S+I5al4vWUChvU
	Q72D7jq5ye5F+TJaVAknxO6b/LNM7Z1EEbJiz1CfmboAEhE6Jbwb4KjwybextW+66lPK
	JKmJXb15oE5WxGO5PBD/EIKJuiItYfIzkvp7AGjNNx6v70c9ZBjff1D3JLCPR+1ZjnKf
	+rbYcPqUsgOxrJDNxe9dLohGPUyq3s+KBm96YpC4rZ4o/wW7B759+Y1sCminSRfuw8cn
	XRYg==
X-Gm-Message-State: AOAM530s4Y9t6xfJ4628EuuocMPIWW21UKwf0JqkCmptDG/Wc0RWrN23
	S3eoMC3etJ1V/eZGRqG9mVtANTpI0c//lqz6eTSp7Q0DYH7vXnr0kMeIUJGwKwdBJVGR818pD32
	W2Omt9Du9LF5HHLbVEYi9yr/nQj9WeM7BxEzDzg==
X-Received: by 2002:a7b:c74f:: with SMTP id w15mr21890328wmk.186.1635188455458;
	Mon, 25 Oct 2021 12:00:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzXLWqbHTas2L+Ep0jJ8Ym3FrcHaKtpcTPgh7nV35XP5aJDxyjNlJ4UaNmG9hWfJd1eun8dCJKnnE+XiZ6mmk=
X-Received: by 2002:a7b:c74f:: with SMTP id w15mr21890297wmk.186.1635188455236;
	Mon, 25 Oct 2021 12:00:55 -0700 (PDT)
MIME-Version: 1.0
References: <20211019134204.3382645-1-agruenba@redhat.com>
	<CAHk-=wh0_3y5s7-G74U0Pcjm7Y_yHB608NYrQSvgogVNBxsWSQ@mail.gmail.com>
	<YXBFqD9WVuU8awIv@arm.com>
	<CAHk-=wgv=KPZBJGnx_O5-7hhST8CL9BN4wJwtVuycjhv_1MmvQ@mail.gmail.com>
	<YXCbv5gdfEEtAYo8@arm.com>
	<CAHk-=wgP058PNY8eoWW=5uRMox-PuesDMrLsrCWPS+xXhzbQxQ@mail.gmail.com>
	<YXL9tRher7QVmq6N@arm.com>
	<CAHk-=wg4t2t1AaBDyMfOVhCCOiLLjCB5TFVgZcV4Pr8X2qptJw@mail.gmail.com>
In-Reply-To: <CAHk-=wg4t2t1AaBDyMfOVhCCOiLLjCB5TFVgZcV4Pr8X2qptJw@mail.gmail.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 25 Oct 2021 21:00:43 +0200
Message-ID: <CAHc6FU7BEfBJCpm8wC3P+8GTBcXxzDWcp6wAcgzQtuaJLHrqZA@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
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
X-Source-IP: 170.10.133.124
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
Cc: kvm-ppc@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Catalin Marinas <catalin.marinas@arm.com>,
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10148 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110250111
X-Proofpoint-ORIG-GUID: lj-DtveEIeHkic3WF6_cB_MZFkRCAS6X
X-Proofpoint-GUID: lj-DtveEIeHkic3WF6_cB_MZFkRCAS6X

On Fri, Oct 22, 2021 at 9:23 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Oct 22, 2021 at 8:06 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > Probing only the first byte(s) in fault_in() would be ideal, no need to
> > go through all filesystems and try to change the uaccess/probing order.
>
> Let's try that. Or rather: probing just the first page - since there
> are users like that btrfs ioctl, and the direct-io path.

For direct I/O, we actually only want to trigger page fault-in so that
we can grab page references with bio_iov_iter_get_pages. Probing for
sub-page error domains will only slow things down. If we hit -EFAULT
during the actual copy-in or copy-out, we know that the error can't be
page fault related. Similarly, in the buffered I/O case, we only
really care about the next byte, so any probing beyond that is
unnecessary.

So maybe we should split the sub-page error domain probing off from
the fault-in functions. Or at least add an argument to the fault-in
functions that specifies the amount of memory to probe.

Thanks,
Andreas


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
