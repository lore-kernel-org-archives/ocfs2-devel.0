Return-Path: <SRS0=Gdlw=MQ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A71C4320A
	for <ocfs2-devel@archiver.kernel.org>; Sat, 24 Jul 2021 20:37:40 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3ECF360725
	for <ocfs2-devel@archiver.kernel.org>; Sat, 24 Jul 2021 20:37:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3ECF360725
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16OKavkA006435;
	Sat, 24 Jul 2021 20:37:39 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a0bdrrs04-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jul 2021 20:37:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16OKYivK149749;
	Sat, 24 Jul 2021 20:37:38 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3a07ysre51-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sat, 24 Jul 2021 20:37:38 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m7OOv-0004Co-7p; Sat, 24 Jul 2021 13:37:37 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1m7OOp-0004CM-Ng
	for ocfs2-devel@oss.oracle.com; Sat, 24 Jul 2021 13:37:31 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16OKZWqP056247
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 20:37:31 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 3a08wc1nfs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 20:37:31 +0000
Received: from pps.filterd (m0246573.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16OKb9sT029965
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 20:37:30 GMT
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com
	[209.85.208.181])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a09215c6h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 20:37:30 +0000
Received: by mail-lj1-f181.google.com with SMTP id x7so6184829ljn.10
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 13:37:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=ho2aOvJzVUGxbigA5Ok8jwjbjidvHRLuevL3w0ehES8=;
	b=HdpJWfqZ/C+wPP3O5kkS1QeSQSMy3WKIXynxQHR63hyfL+xnVPpbNwg34xxVkXdsyP
	5Gpy1TcBuXw0rTZL/dju5YtdsTtmSJGHfUScbbTtDgDlTt6r1P1OG00hDBew+QAKsU8f
	+ObfPw6CSI/1bw/bwZM/624tJitGg8UXw6ZQmO37oaJsvl+DHA8uyGCA3SHCsd2HH+N1
	fR7HJX+zsoxPYPZgIEzLI880ezXtF+lWZXWre156Dr1iEgVdbGRbKZM2FWBT61DagyM1
	arGl22bkf+CCdhpaTHriNhlejITrYqWGZo66G/5ThMLFR62M/+w1/Wym87u30SQ2k+Hg
	P+6w==
X-Gm-Message-State: AOAM531O+Xl5giAKDkmYCOrapb7rqH7vAqMsawDVyXkXmtnpmXBpI79U
	/59Y5E3mst7ZJN4fFd2mEWew8G7Z2m583mSp
X-Google-Smtp-Source: ABdhPJyZ2euUJbesL7b8aOIOeb0DaaxihaORkB+lCD6SDNw+m3arQTldPFky8rxGe+rvqYqtjMLhyw==
X-Received: by 2002:a2e:9b84:: with SMTP id z4mr7236807lji.179.1627159047392; 
	Sat, 24 Jul 2021 13:37:27 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com.
	[209.85.167.54]) by smtp.gmail.com with ESMTPSA id
	a3sm2580398lfl.134.2021.07.24.13.37.26
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Sat, 24 Jul 2021 13:37:26 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id u3so8105628lff.9
	for <ocfs2-devel@oss.oracle.com>; Sat, 24 Jul 2021 13:37:26 -0700 (PDT)
X-Received: by 2002:ac2:44ad:: with SMTP id c13mr7135571lfm.377.1627159045780; 
	Sat, 24 Jul 2021 13:37:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210724193449.361667-1-agruenba@redhat.com>
	<20210724193449.361667-2-agruenba@redhat.com>
	<CAHk-=whodi=ZPhoJy_a47VD+-aFtz385B4_GHvQp8Bp9NdTKUg@mail.gmail.com>
	<YPx28cEvrVl6YrDk@zeniv-ca.linux.org.uk>
In-Reply-To: <YPx28cEvrVl6YrDk@zeniv-ca.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 24 Jul 2021 13:37:09 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj1d2ELuN-Qtf59dsJ4OG-YRqAk2YrLS3=PRMTc2trZvA@mail.gmail.com>
Message-ID: <CAHk-=wj1d2ELuN-Qtf59dsJ4OG-YRqAk2YrLS3=PRMTc2trZvA@mail.gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
X-Source-IP: 209.85.208.181
X-ServerName: mail-lj1-f181.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10055
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
	mlxlogscore=751
	clxscore=393 malwarescore=0 lowpriorityscore=0 impostorscore=0
	mlxscore=0
	spamscore=0 priorityscore=269 bulkscore=0 suspectscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107240124
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10055
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	malwarescore=0 adultscore=0
	bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=878
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107240124
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v4 1/8] iov_iter: Introduce
	iov_iter_fault_in_writeable helper
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10055 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107240124
X-Proofpoint-GUID: lKJu7TugRAmqOvYhyDCr8uYsi3eOQPsn
X-Proofpoint-ORIG-GUID: lKJu7TugRAmqOvYhyDCr8uYsi3eOQPsn

On Sat, Jul 24, 2021 at 1:26 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Sat, Jul 24, 2021 at 12:52:34PM -0700, Linus Torvalds wrote:
>
> > So I think the code needs to return 0 if _any_ fault was successful.
>
> s/any/the first/...

Yes, but as long as we do them in order, and stop when it fails, "any"
and "first" end up being the same thing ;)

> The same goes for fault-in for read

Yeah. That said, a partial write() (ie "read from user space") might
be something that a filesystem is not willing to touch for other
reasons, so I think returning -EFAULT in that case is, I think,
slightly more reasonable.

Things like "I have to prepare buffers to be filled" etc.

The partial read() case is at least something that a filesystem should
be able to handle fairly easily.

And I don't think returning -EFAULT early is necessarily wrong - we
obviously do it anyway if you give really invalid addresses.

But we have generally strived to allow partial IO for missing pages,
because people sometimes play games with unmapping things dynamically
or using mprotect() to catch modifications (ie doing things like catch
SIGSEGV/SIGBUS, and remap it).

But those kinds of uses tend to have to catch -EFAULT anyway, so I
guess it's not a big deal either way.

           Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
