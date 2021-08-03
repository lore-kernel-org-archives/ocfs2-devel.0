Return-Path: <SRS0=ZEQb=M2=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E3F4C4338F
	for <ocfs2-devel@archiver.kernel.org>; Tue,  3 Aug 2021 19:43:43 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 81D6A60F38
	for <ocfs2-devel@archiver.kernel.org>; Tue,  3 Aug 2021 19:43:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 81D6A60F38
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 173JUrtW004779;
	Tue, 3 Aug 2021 19:43:41 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a6fxhc4fg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Aug 2021 19:43:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 173JVKHf135812;
	Tue, 3 Aug 2021 19:43:40 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3a5g9vn7hd-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 03 Aug 2021 19:43:40 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mB0KB-00015z-CY; Tue, 03 Aug 2021 12:43:39 -0700
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1mB0K5-00015W-Q4
	for ocfs2-devel@oss.oracle.com; Tue, 03 Aug 2021 12:43:33 -0700
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	173JVKTS135886
	for <ocfs2-devel@oss.oracle.com>; Tue, 3 Aug 2021 19:43:33 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3020.oracle.com with ESMTP id 3a5g9vn7c5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 03 Aug 2021 19:43:33 +0000
Received: from pps.filterd (m0246579.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	173JRni4003766
	for <ocfs2-devel@oss.oracle.com>; Tue, 3 Aug 2021 19:43:32 GMT
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com
	[209.85.167.43])
	by mx0b-00069f01.pphosted.com with ESMTP id 3a7axerq0m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 03 Aug 2021 19:43:31 +0000
Received: by mail-lf1-f43.google.com with SMTP id f42so435805lfv.7
	for <ocfs2-devel@oss.oracle.com>; Tue, 03 Aug 2021 12:43:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=nGXjTo8qo5IxOBBXxPEhxEW50sCDdvHfqLDIjlbW7zc=;
	b=Rt876KI0DiSWjc+9so/bVcgJw8ZlZgW3BJC2cQmRDtISt+B0gcvG6ZlJOlQeTT8eS1
	OqX66q7OOta0plUbdPyAbqT5U/i7aGSRZOcECK5T/m3aB3sbGK/sfA7lBovgEpbN3j8+
	4YVWt0NjTdzjIP5Upshyx4pzkhYOUMRXyu8XpWt1Q3HNZn+FoF8R0uX8kX9jwrNCg33M
	IOHtK1wyTTY1yeHBH2JwPL0PVstJMbNAW0QCXwnFTkW+rThfLq+mFcFod+URrXQNnCZB
	RY9ANY30ysAgdOMKJU6ET5cVmyooRVKHeMpX30ZagqWVSF/9YzTUiiJkO6oLYSyQ7XZu
	Mskg==
X-Gm-Message-State: AOAM530H0Yc2gp9Nwb+o32XSVMx1erFSzcprKtVcxHt1nioH0XcF/UB3
	lO511WtUOQ5qKwobFPb34UsKVzsBOqtq8g21
X-Google-Smtp-Source: ABdhPJwI3GcRK3ZK350NBSlEFrYkiN99zyDeKBW9xPCqPuo1PXsU5zz7vXpn7DMbLklMUOXXOG4YEQ==
X-Received: by 2002:a05:6512:556:: with SMTP id
	h22mr9229233lfl.461.1628019808953; 
	Tue, 03 Aug 2021 12:43:28 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com.
	[209.85.167.51]) by smtp.gmail.com with ESMTPSA id
	c17sm1334360lfr.88.2021.08.03.12.43.27
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 03 Aug 2021 12:43:28 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id p38so552874lfa.0
	for <ocfs2-devel@oss.oracle.com>; Tue, 03 Aug 2021 12:43:27 -0700 (PDT)
X-Received: by 2002:ac2:4885:: with SMTP id x5mr1818950lfc.487.1628019807490; 
	Tue, 03 Aug 2021 12:43:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210803191818.993968-1-agruenba@redhat.com>
	<20210803191818.993968-4-agruenba@redhat.com>
In-Reply-To: <20210803191818.993968-4-agruenba@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Aug 2021 12:43:11 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiF7jkOrpCe8=s+s=xxw8NovYWfNpe+kVHZth4m0mV5XQ@mail.gmail.com>
Message-ID: <CAHk-=wiF7jkOrpCe8=s+s=xxw8NovYWfNpe+kVHZth4m0mV5XQ@mail.gmail.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
X-Source-IP: 209.85.167.43
X-ServerName: mail-lf1-f43.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	impostorscore=0
	adultscore=0 spamscore=0 mlxscore=0 clxscore=356 phishscore=0
	bulkscore=0
	mlxlogscore=999 priorityscore=0 malwarescore=0 lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108030124
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	malwarescore=0 phishscore=0
	spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108030124
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108030124
X-Proofpoint-GUID: yB2Q9Yxn2Hz_bLYOD655pIjLIIAlNvND
X-Proofpoint-ORIG-GUID: yB2Q9Yxn2Hz_bLYOD655pIjLIIAlNvND

On Tue, Aug 3, 2021 at 12:18 PM Andreas Gruenbacher <agruenba@redhat.com> wrote:
>
> Turn fault_in_pages_{readable,writeable} into versions that return the number
> of bytes faulted in instead of returning a non-zero value when any of the
> requested pages couldn't be faulted in.

Ugh. This ends up making most users have horribly nasty conditionals.

I think I suggested (or maybe that was just my internal voice and I
never actually vocalized it) using the same semantics as
"copy_to/from_user()" for fault_in_pages_{readable|writable}().

Namely to return the number of bytes *not* faulted in.

That makes it trivial to test "did I get everything" - becasue zero
means "nothing failed" and remains the "complete success" marker.

And it still allows for the (much less common) case of "ok, I need to
know about partial failures".

So instead of this horror:

-               if (!fault_in_pages_writeable(buf_fx, fpu_user_xstate_size))
+               if (fault_in_writeable(buf_fx, fpu_user_xstate_size) ==
+                               fpu_user_xstate_size)

you'd just have

-               if (!fault_in_pages_writeable(buf_fx, fpu_user_xstate_size))
+               if (!fault_in_writeable(buf_fx, fpu_user_xstate_size))

because zero would continue to be a marker of success.

                 Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
