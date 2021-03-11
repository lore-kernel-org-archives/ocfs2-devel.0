Return-Path: <SRS0=Hr1N=IJ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C3FEC433E6
	for <ocfs2-devel@archiver.kernel.org>; Thu, 11 Mar 2021 18:38:07 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1BBD664FE0
	for <ocfs2-devel@archiver.kernel.org>; Thu, 11 Mar 2021 18:38:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BBD664FE0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12BIU6XP105229;
	Thu, 11 Mar 2021 18:38:06 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 373y8byrtp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Mar 2021 18:38:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12BIVDOB027502;
	Thu, 11 Mar 2021 18:38:05 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 374kgvc7xq-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 11 Mar 2021 18:38:04 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lKQCB-0004sH-UW; Thu, 11 Mar 2021 10:38:03 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ngompa13@gmail.com>) id 1lKGeg-0006iE-B8
	for ocfs2-devel@oss.oracle.com; Thu, 11 Mar 2021 00:26:50 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12B8LZd4162516
	for <ocfs2-devel@oss.oracle.com>; Thu, 11 Mar 2021 08:26:50 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3020.oracle.com with ESMTP id 374kn26hbm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 11 Mar 2021 08:26:50 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12B8OKSa006520
	for <ocfs2-devel@oss.oracle.com>; Thu, 11 Mar 2021 08:26:49 GMT
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com
	[209.85.219.179]) by userp2030.oracle.com with ESMTP id 3773mfkap0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 11 Mar 2021 08:26:48 +0000
Received: by mail-yb1-f179.google.com with SMTP id x19so20899714ybe.0
	for <ocfs2-devel@oss.oracle.com>; Thu, 11 Mar 2021 00:26:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc:content-transfer-encoding;
	bh=dcZpA35LpDkKjUY2Q5hXt+oRBTl1Po2J4cSvuFIykJg=;
	b=NZ6jz07Lqqq9yIgM5k0HXaB9tFQKO0HqzI+wC1Th3FFDE0X4JfyA/f6xCxYXjrHbby
	YO9lXk4VWm6BORxw46Lqk6S3jKBmfTCJiSkH+sj28ZCXxkItdaEKDdxumNEhP5l3p1Zw
	PZbD37nvoWE68tBUIzOay/Okr94nUJrvV6Cvfabtm0bJt1+oMPgtEQ9xLgqJ0M9AWeC7
	KX9QQOz73H6Rdi6gTxzMOQLmPYqfnuWQFxD69Vbv+frdhDena/ZyU31KCuvUq2ZEh1Iv
	rukeMYYX86TIFvpsBJnEdNRS7Dm7hXjfGzcyH0sgkjY7NHV1visiBt8c+HQT6MbjMqe4
	HZEA==
X-Gm-Message-State: AOAM533+umlxSmgOt3cu1aPLGwL17z0iIfHPq4tBkxCDJ8fF1M11SY60
	YiJ0IV1J41CIbk1psEBX6QFbhKHfxJ6d7xRMnPo=
X-Google-Smtp-Source: ABdhPJxDi0GRK2/QkVfeTJCzVq2zudoeSp/hgMaL164lMJ0uHqYkS0fpHT+H5oc1+Mf9DUZcBDo/d2853Fvi8jdJEdg=
X-Received: by 2002:a25:cc13:: with SMTP id l19mr9850423ybf.260.1615451207278; 
	Thu, 11 Mar 2021 00:26:47 -0800 (PST)
MIME-Version: 1.0
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<CAEg-Je-OLidbfzHCJvY55x+-cOfiUxX8CJ1AeN8VxXAVuVyxKQ@mail.gmail.com>
	<20210310130227.GN3479805@casper.infradead.org>
	<20210310142159.kudk7q2ogp4yqn36@fiona>
	<20210310142643.GQ3479805@casper.infradead.org>
	<CAPcyv4i80GXjjoAD9G0AaRDWPbcTSLogJE9NokO4Eqpzt6UMkA@mail.gmail.com>
In-Reply-To: <CAPcyv4i80GXjjoAD9G0AaRDWPbcTSLogJE9NokO4Eqpzt6UMkA@mail.gmail.com>
From: Neal Gompa <ngompa13@gmail.com>
Date: Thu, 11 Mar 2021 03:26:11 -0500
Message-ID: <CAEg-Je9e1R2NAqtZfryM99+Z98SGjxTSQjt-CMyKRMxvDwtsyg@mail.gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
X-PDR: PASS
X-Source-IP: 209.85.219.179
X-ServerName: mail-yb1-f179.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 adultscore=0
	mlxscore=0 spamscore=0 mlxlogscore=831 phishscore=0 suspectscore=0
	bulkscore=0 clxscore=258 priorityscore=354 impostorscore=0
	malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103110046
X-Spam: Clean
X-Mailman-Approved-At: Thu, 11 Mar 2021 10:38:02 -0800
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103110095
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1034 mlxscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110095

T24gV2VkLCBNYXIgMTAsIDIwMjEgYXQgNzo1MyBQTSBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxp
YW1zQGludGVsLmNvbT4gd3JvdGU6Cj4KPiBPbiBXZWQsIE1hciAxMCwgMjAyMSBhdCA2OjI3IEFN
IE1hdHRoZXcgV2lsY294IDx3aWxseUBpbmZyYWRlYWQub3JnPiB3cm90ZToKPiA+Cj4gPiBPbiBX
ZWQsIE1hciAxMCwgMjAyMSBhdCAwODoyMTo1OUFNIC0wNjAwLCBHb2xkd3luIFJvZHJpZ3VlcyB3
cm90ZToKPiA+ID4gT24gMTM6MDIgMTAvMDMsIE1hdHRoZXcgV2lsY294IHdyb3RlOgo+ID4gPiA+
IE9uIFdlZCwgTWFyIDEwLCAyMDIxIGF0IDA3OjMwOjQxQU0gLTA1MDAsIE5lYWwgR29tcGEgd3Jv
dGU6Cj4gPiA+ID4gPiBGb3JnaXZlIG15IGlnbm9yYW5jZSwgYnV0IGlzIHRoZXJlIGEgcmVhc29u
IHdoeSB0aGlzIGlzbid0IHdpcmVkIHVwIHRvCj4gPiA+ID4gPiBCdHJmcyBhdCB0aGUgc2FtZSB0
aW1lPyBJdCBzZWVtcyB3ZWlyZCB0byBtZSB0aGF0IGFkZGluZyBhIGZlYXR1cmUKPiA+ID4gPgo+
ID4gPiA+IGJ0cmZzIGRvZXNuJ3Qgc3VwcG9ydCBEQVguICBvbmx5IGV4dDIsIGV4dDQsIFhGUyBh
bmQgRlVTRSBoYXZlIERBWCBzdXBwb3J0Lgo+ID4gPiA+Cj4gPiA+ID4gSWYgeW91IHRoaW5rIGFi
b3V0IGl0LCBidHJmcyBhbmQgREFYIGFyZSBkaWFtZXRyaWNhbGx5IG9wcG9zaXRlIHRoaW5ncy4K
PiA+ID4gPiBEQVggaXMgYWJvdXQgZ2l2aW5nIHJhdyBhY2Nlc3MgdG8gdGhlIGhhcmR3YXJlLiAg
YnRyZnMgaXMgYWJvdXQgb2ZmZXJpbmcKPiA+ID4gPiBleHRyYSB2YWx1ZSAoUkFJRCwgY2hlY2tz
dW1zLCAuLi4pLCBub25lIG9mIHdoaWNoIGNhbiBiZSBkb25lIGlmIHRoZQo+ID4gPiA+IGZpbGVz
eXN0ZW0gaXNuJ3QgaW4gdGhlIHJlYWQvd3JpdGUgcGF0aC4KPiA+ID4gPgo+ID4gPiA+IFRoYXQn
cyB3aHkgdGhlcmUncyBubyBEQVggc3VwcG9ydCBpbiBidHJmcy4gIElmIHlvdSB3YW50IERBWCwg
eW91IGhhdmUKPiA+ID4gPiB0byBnaXZlIHVwIGFsbCB0aGUgZmVhdHVyZXMgeW91IGxpa2UgaW4g
YnRyZnMuICBTbyB5b3UgbWF5IGFzIHdlbGwgdXNlCj4gPiA+ID4gYSBkaWZmZXJlbnQgZmlsZXN5
c3RlbS4KPiA+ID4KPiA+ID4gREFYIG9uIGJ0cmZzIGhhcyBiZWVuIGF0dGVtcHRlZFsxXS4gT2Yg
Y291cnNlLCB3ZSBjb3VsZCBub3QKPiA+Cj4gPiBCdXQgd2h5PyAgQSBjb21wbGV0ZW5lc3MgZmV0
aXNoPyAgSSBkb24ndCB1bmRlcnN0YW5kIHdoeSB5b3UgZGVjaWRlZAo+ID4gdG8gZG8gdGhpcyB3
b3JrLgo+Cj4gSXNuJ3QgREFYIHVzZWZ1bCBmb3IgcGFnZWNhY2hlIG1pbmltaXphdGlvbiBvbiBy
ZWFkIGV2ZW4gaWYgaXQgaXMKPiBhd2t3YXJkIGZvciBhIGNvcHktb24td3JpdGUgZnM/Cj4KPiBT
ZWVtcyBpdCB3b3VsZCBiZSBhIHVzZWZ1bCBjYXNlIHRvIGhhdmUgQ09XJ2QgVk0gaW1hZ2VzIG9u
IEJUUkZTIHRoYXQKPiBkb24ndCBuZWVkIHN1cGVyZmx1b3VzIHBhZ2UgY2FjaGUgYWxsb2NhdGlv
bnMuCgpJIGNvdWxkIGFsc28gc2VlIHRoaXMgYmVpbmcgdXNlZnVsIGZvciBkYXRhYmFzZXMgKGFu
ZCBtYXliZSBldmVuIHN3YXAKZmlsZXMhKSBvbiBCdHJmcywgaWYgSSdtIHVuZGVyc3RhbmRpbmcg
dGhpcyBmZWF0dXJlIGNvcnJlY3RseS4KCgotLSAK55yf5a6f44Gv44GE44Gk44KC5LiA44Gk77yB
LyBBbHdheXMsIHRoZXJlJ3Mgb25seSBvbmUgdHJ1dGghCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczIt
ZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL29jZnMyLWRldmVs
