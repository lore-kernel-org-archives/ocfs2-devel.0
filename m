Return-Path: <SRS0=MO47=IL=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F020AC433E0
	for <ocfs2-devel@archiver.kernel.org>; Sat, 13 Mar 2021 16:31:07 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 90E0A64ECE
	for <ocfs2-devel@archiver.kernel.org>; Sat, 13 Mar 2021 16:31:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90E0A64ECE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12DGTlSn100643;
	Sat, 13 Mar 2021 16:31:06 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2120.oracle.com with ESMTP id 378p1ngpgp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 13 Mar 2021 16:31:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12DGUmRb096602;
	Sat, 13 Mar 2021 16:31:05 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 378mqjsppa-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sat, 13 Mar 2021 16:31:05 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lL74I-00053M-Q9; Sat, 13 Mar 2021 08:24:46 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ngompa13@gmail.com>) id 1lL74B-00052s-An
	for ocfs2-devel@oss.oracle.com; Sat, 13 Mar 2021 08:24:39 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12DGLGDf050731
	for <ocfs2-devel@oss.oracle.com>; Sat, 13 Mar 2021 16:24:39 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3020.oracle.com with ESMTP id 378n71qmvr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 13 Mar 2021 16:24:39 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12DGOZIg042175
	for <ocfs2-devel@oss.oracle.com>; Sat, 13 Mar 2021 16:24:38 GMT
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com
	[209.85.219.176]) by userp2030.oracle.com with ESMTP id 378kegw33m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 13 Mar 2021 16:24:37 +0000
Received: by mail-yb1-f176.google.com with SMTP id p193so28710187yba.4
	for <ocfs2-devel@oss.oracle.com>; Sat, 13 Mar 2021 08:24:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc:content-transfer-encoding;
	bh=aXi6zxmykvKGGuEUIknBGQuu/CrpF+OFk8aqg1g8+Js=;
	b=kAj+3vtx8IDHOz/e4eiGqUmuH7n9GKULicghFO+0Enrx++FGbffZdIpnST73WJY6Q2
	vnjCqQsConlW8FJwcJ4HgqHDwL5xNFOnFTAn0ANyPSa3+ZQUokD6BIgKoJJuCW6xYRfG
	ndt2JPvaSJ7hZ0KynYX3ZPhR2Jkh4ZN2CgLoZxJZLPb4lCoomWj+A2WmgR1tagJxelK4
	RUzFYlCQ2P7D20mFnFWie2Bb7BV0EC0VKihqsxt6JCPoykubwjVwAlR9p9P2f+jK3VNL
	vbe9LGmGLj0XAJBhZHDYeNMLgp01ZkPQXr/5GNTDpafEazqvf6rPe6tqPcSEbXO+BewC
	XUyw==
X-Gm-Message-State: AOAM5320GRop6agkxnT9gQ9Yq0WiFRK4uFV/J5WHY6eKiZW8MRdeiPAK
	w9KaqmjAekOI/fpQ9T+sV0IU30MYf+N/oIo8eNk=
X-Google-Smtp-Source: ABdhPJwtKc3ckDh1wM2gREfAQUcazj9bOTqT8gJ/CC1jACL5d+N8mbIM5sD/vFtR/QEb1ipgGC33qgcC6cjdF7XgPjg=
X-Received: by 2002:a25:424f:: with SMTP id p76mr27228411yba.109.1615652676401;
	Sat, 13 Mar 2021 08:24:36 -0800 (PST)
MIME-Version: 1.0
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<CAEg-Je-OLidbfzHCJvY55x+-cOfiUxX8CJ1AeN8VxXAVuVyxKQ@mail.gmail.com>
	<20210310130227.GN3479805@casper.infradead.org>
	<20210310142159.kudk7q2ogp4yqn36@fiona>
	<20210310142643.GQ3479805@casper.infradead.org>
	<YEy4+SPUvQkL44PQ@angband.pl>
In-Reply-To: <YEy4+SPUvQkL44PQ@angband.pl>
From: Neal Gompa <ngompa13@gmail.com>
Date: Sat, 13 Mar 2021 11:24:00 -0500
Message-ID: <CAEg-Je-JCW5xa6w5Z9n7+UNnLju251SmqnXiReA2v41fFaXAtw@mail.gmail.com>
To: Adam Borowski <kilobyte@angband.pl>
X-PDR: PASS
X-Source-IP: 209.85.219.176
X-ServerName: mail-yb1-f176.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9922
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 suspectscore=0
	phishscore=0 impostorscore=0 mlxlogscore=647 mlxscore=0 spamscore=0
	malwarescore=0 adultscore=0 priorityscore=332 clxscore=180 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103130127
X-Spam: Clean
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        david <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        linux-xfs <linux-xfs@vger.kernel.org>, ocfs2-devel@oss.oracle.com,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [Ocfs2-devel] [PATCH v2 00/10] fsdax,
	xfs: Add reflink&dedupe support for fsdax
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9922 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103130128
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9922 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1034 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103130128

T24gU2F0LCBNYXIgMTMsIDIwMjEgYXQgODowOSBBTSBBZGFtIEJvcm93c2tpIDxraWxvYnl0ZUBh
bmdiYW5kLnBsPiB3cm90ZToKPgo+IE9uIFdlZCwgTWFyIDEwLCAyMDIxIGF0IDAyOjI2OjQzUE0g
KzAwMDAsIE1hdHRoZXcgV2lsY294IHdyb3RlOgo+ID4gT24gV2VkLCBNYXIgMTAsIDIwMjEgYXQg
MDg6MjE6NTlBTSAtMDYwMCwgR29sZHd5biBSb2RyaWd1ZXMgd3JvdGU6Cj4gPiA+IERBWCBvbiBi
dHJmcyBoYXMgYmVlbiBhdHRlbXB0ZWRbMV0uIE9mIGNvdXJzZSwgd2UgY291bGQgbm90Cj4gPgo+
ID4gQnV0IHdoeT8gIEEgY29tcGxldGVuZXNzIGZldGlzaD8gIEkgZG9uJ3QgdW5kZXJzdGFuZCB3
aHkgeW91IGRlY2lkZWQKPiA+IHRvIGRvIHRoaXMgd29yay4KPgo+ICogeGZzIGNhbiBzaGFwc2hv
dCBvbmx5IHNpbmdsZSBmaWxlcywgYnRyZnMgZW50aXJlIHN1YnZvbHVtZXMKPiAqIGJ0cmZzLXNl
bmR8cmVjZWl2ZQo+ICogZW51bWVyYXRpb24gb2YgY2hhbmdlZCBwYXJ0cyBvZiBhIGZpbGUKPgoK
WEZTIGNhbm5vdCBkbyBzbmFwc2hvdHMgc2luY2UgaXQgbGFja3MgbWV0YWRhdGEgQ09XLiBYRlMg
cmVmbGlua2luZyBpcwpwcmltYXJpbHkgZm9yIHNwYWNlIGVmZmljaWVuY3kuCgoKCi0tIArnnJ/l
rp/jga/jgYTjgaTjgoLkuIDjgaTvvIEvIEFsd2F5cywgdGhlcmUncyBvbmx5IG9uZSB0cnV0aCEK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRl
dmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5v
cmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
