Return-Path: <SRS0=S1qZ=ML=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 932BAC07E9D
	for <ocfs2-devel@archiver.kernel.org>; Mon, 19 Jul 2021 19:27:02 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 27576610D2
	for <ocfs2-devel@archiver.kernel.org>; Mon, 19 Jul 2021 19:27:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27576610D2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16JJQOeD003136;
	Mon, 19 Jul 2021 19:27:00 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 39vqm9a6xh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jul 2021 19:27:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16JJADcg115932;
	Mon, 19 Jul 2021 19:26:58 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 39v8yt9q2x-1;
	Mon, 19 Jul 2021 19:26:58 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1m5Yun-0007Ax-HE; Mon, 19 Jul 2021 12:26:57 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <torvalds@linuxfoundation.org>) id 1m5Yug-0007AT-Rx
	for ocfs2-devel@oss.oracle.com; Mon, 19 Jul 2021 12:26:50 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	16JJBFR4157896
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 19:26:50 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3030.oracle.com with ESMTP id 39upe8u9px-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 19:26:50 +0000
Received: from pps.filterd (m0246572.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	16JJGtif017348
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 19:26:49 GMT
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com
	[209.85.167.48])
	by mx0b-00069f01.pphosted.com with ESMTP id 39w7phver1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 19:26:48 +0000
Received: by mail-lf1-f48.google.com with SMTP id y42so32077908lfa.3
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 12:26:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=K1xCs+r00YlYYmkHhfeZ23WXN1acy6oHwi3mHUNeu3k=;
	b=NwW9Vc1MjTQ4hvKYP7K+lKwjGFNCAoU61V2AvY0f0UWK+UxplyU7T85mUgUm3gVBvN
	g1d/9/l1C5FRt+p+9wQhE0XqcPaOYk0bXAWrqhLYmPccTvGKIIKPaiWyfgrId74JY1t7
	J6LJczaMPD6zs69jm9tdWn8dkD+Urwy2CyhcRTByCdgX2cw1axf7FAYsvCns4+rV7yig
	SZjzLv0D9/MlMWO+B3vQsDDuBoSSZsBTMvB70lf9WhQ0AI0WHNHwY0Z8UNsLvURuapn1
	RnvaR3QuEqCHGk6GLJqTiLV+oBkazUWYNqsXbc0grCyAPvY0a9VVbHNN8wU5d7pELflf
	b5VQ==
X-Gm-Message-State: AOAM533E0qcVrF66MqLj4Qjo2oi+jmuCc94+YaHagEky9Nd1oZUpPfR2
	YGqbHdotWyIpBXH8AuZOay9QLnxHvs0I/1hR
X-Google-Smtp-Source: ABdhPJwavqkpOqazM05wu1SyaBoxnWKmaqJ6wzLMCyEthK1tn9dlodYY6XCM3sozD1LYg3Un8pfnFQ==
X-Received: by 2002:a05:6512:ac7:: with SMTP id
	n7mr5907824lfu.564.1626722805288; 
	Mon, 19 Jul 2021 12:26:45 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com.
	[209.85.167.54]) by smtp.gmail.com with ESMTPSA id
	s6sm1355044lfd.171.2021.07.19.12.26.43
	for <ocfs2-devel@oss.oracle.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 19 Jul 2021 12:26:44 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id i5so32095636lfe.2
	for <ocfs2-devel@oss.oracle.com>; Mon, 19 Jul 2021 12:26:43 -0700 (PDT)
X-Received: by 2002:ac2:4475:: with SMTP id y21mr18958429lfl.487.1626722803588;
	Mon, 19 Jul 2021 12:26:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210718223932.2703330-1-agruenba@redhat.com>
	<20210718223932.2703330-2-agruenba@redhat.com>
In-Reply-To: <20210718223932.2703330-2-agruenba@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 19 Jul 2021 12:26:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=whxmBjwU+NpeVnUrMEgqk7qAF0VRwtXS2YPJo2n3WGyWg@mail.gmail.com>
Message-ID: <CAHk-=whxmBjwU+NpeVnUrMEgqk7qAF0VRwtXS2YPJo2n3WGyWg@mail.gmail.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
X-Source-IP: 209.85.167.48
X-ServerName: mail-lf1-f48.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:198.145.29.98/31 ip4:72.55.140.81
	include:_spf.google.com
	include:amazonses.com include:_spf.salesforce.com ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
	impostorscore=0
	adultscore=0 clxscore=411 priorityscore=0 mlxscore=0 lowpriorityscore=0
	bulkscore=0 mlxlogscore=995 malwarescore=0 phishscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107190110
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	suspectscore=0 bulkscore=0
	malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107190110
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 1/6] iov_iter: Introduce
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107190110
X-Proofpoint-GUID: IbyOV8VlLw3PeRlUQx-iOei5CLfUIVyU
X-Proofpoint-ORIG-GUID: IbyOV8VlLw3PeRlUQx-iOei5CLfUIVyU

On Sun, Jul 18, 2021 at 3:39 PM Andreas Gruenbacher <agruenba@redhat.com> wrote:
>
> Introduce a new fault_in_iov_iter helper for manually faulting in an iterator.
> Other than fault_in_pages_writeable(), this function is non-destructive.

You mean "Unlike" rather than "Other than" (also in the comment of the patch).

This is fairly inefficient, but as long as it's the exceptional case,
that's fine. It might be worth making that very explicit, so that
people don't try to use it normally.

                Linus

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
