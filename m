Return-Path: <SRS0=EKoi=MP=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F9CAC4338F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 23 Jul 2021 23:40:57 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B06CA60E99
	for <ocfs2-devel@archiver.kernel.org>; Fri, 23 Jul 2021 23:40:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B06CA60E99
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16NNLfNC011440;
	Fri, 23 Jul 2021 23:40:55 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 39xvm7w0av-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jul 2021 23:40:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16NNedbW161574;
	Fri, 23 Jul 2021 23:40:54 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3a04yuetwx-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 23 Jul 2021 23:40:54 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m74mj-0000Z4-Ag; Fri, 23 Jul 2021 16:40:53 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1m74mf-0000Ye-Pu
	for ocfs2-devel@oss.oracle.com; Fri, 23 Jul 2021 16:40:49 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16NNLVbD044858
	for <ocfs2-devel@oss.oracle.com>; Fri, 23 Jul 2021 23:40:49 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 39wunrr6ye-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 23 Jul 2021 23:40:49 +0000
Received: from pps.filterd (m0246573.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16NNI57A022325
	for <ocfs2-devel@oss.oracle.com>; Fri, 23 Jul 2021 23:40:46 GMT
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com
	[209.85.167.54])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a0119k98a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 23 Jul 2021 23:40:43 +0000
Received: by mail-lf1-f54.google.com with SMTP id r26so4645135lfp.5
	for <ocfs2-devel@oss.oracle.com>; Fri, 23 Jul 2021 16:40:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=7xkMQPx7Z/4PMvWsEiJNAXvxh1Yr4z8dYX5ZnaiIDS4=;
	b=e8Jnmt040V/thvRm26tpqtGRGlWv1Ek2EOSVOYZdtg/MrzPyBXUpwhbTEgiknppXnt
	pzhein1Pe0uP+GAaYrUyzqKMRgaF32svQzFFQGY57C6L38xtNgTZgoaBHs3oU89RDrt1
	9SonD8Fr8N5d2wyqjXH5IHApSm7upYLelfPD8BId39TziE/3EpO+VaSnurYQRCrO0Cnn
	KaYo9onSb3v8BsR2PW5o4lqQyW+QPYiZyH8kefJeJhBQaiss3GOlovSAcpU0gtKpNUK1
	0keTGz5uBjRyfl1fVezwpUKM3AbGy/RJHZGBIwr6b3BAl3QgcRCi9jGXfHeNL8vPt5ZD
	mUuQ==
X-Gm-Message-State: AOAM531jlnCDGryjgngX8bhhMZEfyj7DAK3q6pa6lbWJe1boYo8JC63U
	78TAkilHwU+KWlih42G3S9nFyFQWSSpEB01v
X-Google-Smtp-Source: ABdhPJyKi3QpcWiMzzTBW6F1cI6fnlzbkFcU4OZR/4BgmrMrXqo96Ly2CLQGZvC9vlQp1Dt3zt46Tw==
X-Received: by 2002:ac2:4845:: with SMTP id 5mr4711286lfy.313.1627083640291;
	Fri, 23 Jul 2021 16:40:40 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com.
	[209.85.208.176])
	by smtp.gmail.com with ESMTPSA id x3sm3508677lji.12.2021.07.23.16.40.38
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 23 Jul 2021 16:40:39 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id m9so3581740ljp.7
	for <ocfs2-devel@oss.oracle.com>; Fri, 23 Jul 2021 16:40:38 -0700 (PDT)
X-Received: by 2002:a2e:90cd:: with SMTP id o13mr4693434ljg.465.1627083638619; 
	Fri, 23 Jul 2021 16:40:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210723205840.299280-1-agruenba@redhat.com>
	<20210723205840.299280-2-agruenba@redhat.com>
In-Reply-To: <20210723205840.299280-2-agruenba@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 23 Jul 2021 16:40:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg1n8yVeKABgfx7itM5o1jXVx6WXRF5PxHx+uqeFBmsmQ@mail.gmail.com>
Message-ID: <CAHk-=wg1n8yVeKABgfx7itM5o1jXVx6WXRF5PxHx+uqeFBmsmQ@mail.gmail.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
X-Source-IP: 209.85.167.54
X-ServerName: mail-lf1-f54.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10054
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 suspectscore=0
	spamscore=0 bulkscore=0 mlxscore=0 clxscore=367 impostorscore=0
	adultscore=0 mlxlogscore=999 priorityscore=149 phishscore=0
	malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107230138
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10054
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	phishscore=0 spamscore=0
	bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107230138
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v3 1/7] iov_iter: Introduce
	fault_in_iov_iter helper
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10054 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107230139
X-Proofpoint-ORIG-GUID: FSwwln9uivmxddtFU4JM_L5kd80RTe6t
X-Proofpoint-GUID: FSwwln9uivmxddtFU4JM_L5kd80RTe6t

On Fri, Jul 23, 2021 at 1:58 PM Andreas Gruenbacher <agruenba@redhat.com> wrote:
>
> Introduce a new fault_in_iov_iter helper for manually faulting in an iterator.
> Other than fault_in_pages_writeable(), this function is non-destructive.

Again, as I pointed out in the previous version, "Other than" is not
sensible language.

You mean "Unlike".

Same issue in the comment:

> + * Other than fault_in_pages_writeable(), this function is non-destructive even
> + * when faulting in pages for writing.

It really should be

  "Unlike fault_in_pages_writeable(), this function .."

to parse correctly.

I understand what you mean, but only because I know what
fault_in_pages_writeable() does and what the issue was.

And in a year or two, I might have forgotten, and wonder what you meant.

             Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
