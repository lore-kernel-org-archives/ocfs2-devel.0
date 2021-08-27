Return-Path: <SRS0=bb4f=NS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D090DC432BE
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 22:35:59 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7B0B360EBA
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 22:35:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7B0B360EBA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RKMH0Q002209;
	Fri, 27 Aug 2021 22:35:59 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3apvjr1qvc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 22:35:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17RMZrJ3055371;
	Fri, 27 Aug 2021 22:35:57 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3ajpm5f4bp-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 27 Aug 2021 22:35:56 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mJkRn-0003rC-3y; Fri, 27 Aug 2021 15:35:39 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mJkRh-0003qk-Jq
	for ocfs2-devel@oss.oracle.com; Fri, 27 Aug 2021 15:35:33 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17RMZVHx009671
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 22:35:33 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 3aq2hv2ksv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 22:35:32 +0000
Received: from pps.filterd (m0246573.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17RHdRff030718
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 22:35:27 GMT
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com
	[209.85.167.49])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aq4n0apch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 22:35:27 +0000
Received: by mail-lf1-f49.google.com with SMTP id bq28so17380109lfb.7
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 15:35:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=0rGLz7zH5VYaPQJm/5R2FgZ/IY8lzcUOIJsQBb/VIWM=;
	b=Vz7pIWeWarS8hM617A7sJC2qrKdiAvG1Ct+A8VkVYEeaq+eh4tClJ7WFujGyFjU7EZ
	HgN1eS4jTT07QogDsWVXATkgm8OKy3bNSXrj2lG+fKvQFm/fJYHthettzXKXvRyApH0p
	a7V8nf/dWxVrf9rdkYIsgO3x/QIsX+9sCi6ImackO+6PpHicZHhtEBUvKKtVw2u9IkFE
	6hjX9O/H88+ceE8oxqvmH1Vfu4YPRgwnATe1oXnebqyZJBEYVPZ/tAF0dbmejNfLDpj7
	YvP580HYXPufJ3n/IcKW6mzVlPt93dhtnu8ZsBUMqEU0tyL70PpoS5iBM19AtzE3+aB1
	XLng==
X-Gm-Message-State: AOAM530iD/YBmFMx1Od04MeK6Tl2htzRkoFffux8XSGuUFs+/i4KWjbY
	STBVTWnSTHXPBLtvZ1Y9v+iJZ7NSjN8pIBUg
X-Google-Smtp-Source: ABdhPJyvnxKGEJnYrDwe7TG8pdd2fH3NsdNTfSMCAjUTFZO+rxiPPO29JI4r0e2yXu1UjZDeSt7a/Q==
X-Received: by 2002:a05:6512:3e11:: with SMTP id
	i17mr8183851lfv.613.1630103723725; 
	Fri, 27 Aug 2021 15:35:23 -0700 (PDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com.
	[209.85.208.172]) by smtp.gmail.com with ESMTPSA id
	r199sm376655lff.266.2021.08.27.15.35.22
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 27 Aug 2021 15:35:22 -0700 (PDT)
Received: by mail-lj1-f172.google.com with SMTP id s12so14121568ljg.0
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 15:35:22 -0700 (PDT)
X-Received: by 2002:a05:651c:908:: with SMTP id
	e8mr9500825ljq.507.1630103722494; 
	Fri, 27 Aug 2021 15:35:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<20210827164926.1726765-17-agruenba@redhat.com>
	<20210827183018.GJ12664@magnolia>
	<CAHc6FU44mGza=G4prXh08=RJZ0Wu7i6rBf53BjURj8oyX5Q8iA@mail.gmail.com>
	<20210827213239.GH12597@magnolia>
In-Reply-To: <20210827213239.GH12597@magnolia>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Aug 2021 15:35:06 -0700
X-Gmail-Original-Message-ID: <CAHk-=whCCyxkk+wfDZ5bQNX62MfdprBLpy_RwpSFhFziA2Oecg@mail.gmail.com>
Message-ID: <CAHk-=whCCyxkk+wfDZ5bQNX62MfdprBLpy_RwpSFhFziA2Oecg@mail.gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
X-Source-IP: 209.85.167.49
X-ServerName: mail-lf1-f49.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
	phishscore=0 mlxscore=0
	impostorscore=0 suspectscore=0 bulkscore=0 priorityscore=120
	lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=405
	spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000
	definitions=main-2108270133 domainage_hfrom=5365
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
	adultscore=0 spamscore=0
	bulkscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108270133
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 16/19] iomap: Add done_before argument
	to iomap_dio_rw
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270133
X-Proofpoint-GUID: 9HuWcWpdJ4kuC3lmKv8d9D5kp28azeDp
X-Proofpoint-ORIG-GUID: 9HuWcWpdJ4kuC3lmKv8d9D5kp28azeDp

On Fri, Aug 27, 2021 at 2:32 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> No, because you totally ignored the second question:
>
> If the directio operation succeeds even partially and the PARTIAL flag
> is set, won't that push the iov iter ahead by however many bytes
> completed?
>
> We already finished the IO for the first page, so the second attempt
> should pick up where it left off, i.e. the second page.

Darrick, I think you're missing the point.

It's the *return*value* that is the issue, not the iovec.

The iovec is updated as you say. But the return value from the async
part is - without Andreas' patch - only the async part of it.

With Andreas' patch, the async part will now return the full return
value, including the part that was done synchronously.

And the return value is returned from that async part, which somehow
thus needs to know what predated it.

Could that pre-existing part perhaps be saved somewhere else? Very
possibly. That 'struct iomap_dio' addition is kind of ugly. So maybe
what Andreas did could be done differently. But I think you guys are
arguing past each other.

           Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
