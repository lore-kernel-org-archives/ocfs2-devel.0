Return-Path: <SRS0=bb4f=NS=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C2AC432BE
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 19:06:09 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1D15A60EE4
	for <ocfs2-devel@archiver.kernel.org>; Fri, 27 Aug 2021 19:06:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1D15A60EE4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RGOvOP002206;
	Fri, 27 Aug 2021 19:06:08 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3apvjr1dyu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Aug 2021 19:06:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17RJ5eor031909;
	Fri, 27 Aug 2021 19:06:07 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3akb92mu3p-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 27 Aug 2021 19:06:06 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mJhAz-0002VB-V2; Fri, 27 Aug 2021 12:06:05 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mJhAu-0002Uh-6g
	for ocfs2-devel@oss.oracle.com; Fri, 27 Aug 2021 12:06:00 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17RJ5oWU083677
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 19:05:59 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3030.oracle.com with ESMTP id 3ajpm56tem-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 19:05:54 +0000
Received: from pps.filterd (m0246578.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17RI3srd025359
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 19:05:53 GMT
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com
	[209.85.208.174])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aq3up1dd8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 19:05:53 +0000
Received: by mail-lj1-f174.google.com with SMTP id d16so13158713ljq.4
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 12:05:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=Xurqpx2HBsUzvPtF9beAd23C15iGKZUtGtKLy9/65Yo=;
	b=dS+0BrUxTTg8+DqTdZSiWqW7enuFWd8HNvbeC00xWOUaid2ZXueRoPXrGJ1mumgQaV
	QwyxrZmMKmhVDDrgzazlWfpR0k9zzN/bloINjV+3/VUc498PCeTaxjoI2MGYEVkC542d
	9e9iq3sCM+jdFwoPdh/J1azQmEfJ7Bqw1BtJSjQrG+F46yOHU5sSbKhzRrM7GkkdSL6v
	eyc+8bq7eAji7NtrphgkrW5Y0720VJt4oVTxfFo5mlgnh4NbKyXVlcVNZ9GIAWaBl9EJ
	R3rVsFLd0EVJfOmjWwc4+WqpIBZSkqCJUfesVU69tMDGlsvCuH/qLBb32v3Pq4Cpbi43
	by8A==
X-Gm-Message-State: AOAM532XczK3uP4Ak2Cg7RS5Id35vkCgLM4A7OoXvxzmBQ7RqhE5WiEA
	B7dPyPL8pK1sdxKQvCdxuBGnXcgZtqOFUnOs
X-Google-Smtp-Source: ABdhPJz2WWVRaVVIKrPwsPhXEVra6ddqEX6EmdGlDkiRkoUPBjzCKu/zCDN2Cgo1Hj9V8p+xHZv5+w==
X-Received: by 2002:a2e:84c7:: with SMTP id q7mr8863573ljh.61.1630091150545;
	Fri, 27 Aug 2021 12:05:50 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com.
	[209.85.167.51])
	by smtp.gmail.com with ESMTPSA id x4sm775617ljm.98.2021.08.27.12.05.49
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 27 Aug 2021 12:05:49 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id x27so16438007lfu.5
	for <ocfs2-devel@oss.oracle.com>; Fri, 27 Aug 2021 12:05:49 -0700 (PDT)
X-Received: by 2002:a05:6512:104b:: with SMTP id
	c11mr7660072lfb.201.1630091149264; 
	Fri, 27 Aug 2021 12:05:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<20210827164926.1726765-6-agruenba@redhat.com>
	<YSkz025ncjhyRmlB@zeniv-ca.linux.org.uk>
In-Reply-To: <YSkz025ncjhyRmlB@zeniv-ca.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Aug 2021 12:05:32 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh5p6zpgUUoY+O7e74X9BZyODhnsqvv=xqnTaLRNj3d_Q@mail.gmail.com>
Message-ID: <CAHk-=wh5p6zpgUUoY+O7e74X9BZyODhnsqvv=xqnTaLRNj3d_Q@mail.gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
X-Source-IP: 209.85.208.174
X-ServerName: mail-lj1-f174.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
	lowpriorityscore=0
	phishscore=0 impostorscore=0 spamscore=0 adultscore=0 bulkscore=0
	clxscore=383 suspectscore=0 priorityscore=283 malwarescore=0
	mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108270111
	domainage_hfrom=5365
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	phishscore=0 malwarescore=0
	mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108270111
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 05/19] iov_iter: Introduce
	fault_in_iov_iter_writeable
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270111
X-Proofpoint-GUID: YQFw6stPFWsqARYz-qFeAxm6xtp5Qf7a
X-Proofpoint-ORIG-GUID: YQFw6stPFWsqARYz-qFeAxm6xtp5Qf7a

On Fri, Aug 27, 2021 at 11:52 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Again, the calling conventions are wrong.  Make it success/failure or
> 0/-EFAULT.  And it's inconsistent for iovec and non-iovec cases as it is.

Al, the 0/-EFAULT thing DOES NOT WORK.

The whole "success vs failure" model is broken.

Because "success" for some people is "everything worked".

And for other people it is "at least _part_ of it worked".

So no, 0/-EFAULT fundamentally cannot work, because the return needs
to be able to handle that ternary situation (ie "nothing" vs
"something" vs "everything").

This is *literally* the exact same thing that we have for
copy_to/from_user(). And Andreas' solution (based on my suggestion) is
the exact same one that we have had for that code since basically day
#1.

The whole "0/-EFAULT" is simpler, yes. And it's what
"{get|put}_user()" uses, yes. And it's more common to a lot of other
functions that return zero or an error.

But see above. People *need* that ternary result, and "bytes/pages
uncopied" is not only the traditional one we use elsewhere in similar
situations, it's the one that has the easiest error tests for existing
users (because zero remains "everything worked").

Andreas originally had that "how many bytes/pages succeeded" return
value instead, and yes, that's also ternary. But it means that now the
common "complete success" test ends up being a lot uglier, and the
semantics of the function changes completely where "0" no longer means
success, and that messes up much more.

So I really think you are barking entirely up the wrong tree.

If there is any inconsistency, maybe we should make _more_ cases use
that "how many bytes/pages not copied" logic, but in a lot of cases
you don't actually need the ternary decision value.

So the inconsistency is EXACTLY the same as the one we have always had
for get|put_user() vs copy_to|from_user(), and it exists for the EXACT
same reason.

IOW, please explain how you'd solve the ternary problem without making
the code a lot uglier.

              Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
