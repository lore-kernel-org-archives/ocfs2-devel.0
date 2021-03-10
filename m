Return-Path: <SRS0=Hr1N=IJ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6ADCC433DB
	for <ocfs2-devel@archiver.kernel.org>; Thu, 11 Mar 2021 18:38:06 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6304E64FE0
	for <ocfs2-devel@archiver.kernel.org>; Thu, 11 Mar 2021 18:38:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6304E64FE0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12BIVH0o136909;
	Thu, 11 Mar 2021 18:38:05 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2130.oracle.com with ESMTP id 37415rfkyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Mar 2021 18:38:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12BIVYH5040597;
	Thu, 11 Mar 2021 18:38:05 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 374kp1d2mq-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 11 Mar 2021 18:38:04 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lKQCB-0004rl-Ri; Thu, 11 Mar 2021 10:38:03 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ngompa13@gmail.com>) id 1lJz13-0000Ty-3i
	for ocfs2-devel@oss.oracle.com; Wed, 10 Mar 2021 05:36:45 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12ADVRQ6138399
	for <ocfs2-devel@oss.oracle.com>; Wed, 10 Mar 2021 13:36:45 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3030.oracle.com with ESMTP id 374kaq7c4x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 10 Mar 2021 13:36:45 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	12ADYLmY019605
	for <ocfs2-devel@oss.oracle.com>; Wed, 10 Mar 2021 13:36:44 GMT
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com
	[209.85.219.179]) by userp2030.oracle.com with ESMTP id 373yskuhes-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 10 Mar 2021 13:36:43 +0000
Received: by mail-yb1-f179.google.com with SMTP id h82so17801070ybc.13
	for <ocfs2-devel@oss.oracle.com>; Wed, 10 Mar 2021 05:36:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc:content-transfer-encoding;
	bh=2aYptJ+Gov2C+oARQmlRLopxW2URRuwXw1AKwLGZv1E=;
	b=fUkYGoqo7XUn78BMZDCAGhoGwwhvzGL1ktMp6uuG32pXLpkYBgtVVR5C9ZqjFRYMwE
	L/PZH1NeB6/FN5GtnnQn6Xdu+eGp4PJjYWoh7CB5lLZ2vmP27siBmTrEmDLoBdEvahom
	PDjbxxrNfeAC+uoMWJta/q5zXZ3B7MfTNCkAUuU9q7+O4w1Z44umSvFiwP3TCqRWM6VF
	U/EYXP5Sw5GUXLktWCWRNCgCvDrdPLL2eUIaCwsfOWeTWHHoTdaNSt5OtMKtCVZnCZIZ
	gx+Ra13qAyt4DFogYz9bpFTmCLTBIZoTrfdI5THvbSwn2trUo2W43S7m4gtETaw2ifI7
	ivJQ==
X-Gm-Message-State: AOAM532SSF0JhkadVpJ9T+t4ReVXZE06esZgS3CWE6g5sS8/51optyOp
	JYvmEYIw2s1Ozu2LEEQY+WQbbBV9QWfn6r6qFDWOlsuTF0Ftlg==
X-Google-Smtp-Source: ABdhPJz1jxdINaxIIQwiE1/7TJj4kvjkB1loYv97hj60cdpiwpI1AFhO8/qRMCL4/0SP4ps/aG+kQlYilaoS6/0nAb8=
X-Received: by 2002:a25:d8f:: with SMTP id 137mr1981743ybn.47.1615383402310;
	Wed, 10 Mar 2021 05:36:42 -0800 (PST)
MIME-Version: 1.0
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com>
	<CAEg-Je-OLidbfzHCJvY55x+-cOfiUxX8CJ1AeN8VxXAVuVyxKQ@mail.gmail.com>
	<20210310130227.GN3479805@casper.infradead.org>
In-Reply-To: <20210310130227.GN3479805@casper.infradead.org>
From: Neal Gompa <ngompa13@gmail.com>
Date: Wed, 10 Mar 2021 08:36:06 -0500
Message-ID: <CAEg-Je-F6ybPPV22-hq9=cuUCA7cw2xAA7Y-97tKhYUX1+fDwg@mail.gmail.com>
To: Matthew Wilcox <willy@infradead.org>
X-PDR: PASS
X-Source-IP: 209.85.219.179
X-ServerName: mail-yb1-f179.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 impostorscore=0
	phishscore=0 clxscore=285 priorityscore=490 spamscore=0 bulkscore=0
	malwarescore=0 adultscore=0 mlxlogscore=908 mlxscore=0 suspectscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2103100066
X-Spam: Clean
X-Mailman-Approved-At: Thu, 11 Mar 2021 10:38:02 -0800
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, darrick.wong@oracle.com,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        dan.j.williams@intel.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110095
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 priorityscore=1501 bulkscore=0 clxscore=1034
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110095

T24gV2VkLCBNYXIgMTAsIDIwMjEgYXQgODowMiBBTSBNYXR0aGV3IFdpbGNveCA8d2lsbHlAaW5m
cmFkZWFkLm9yZz4gd3JvdGU6Cj4KPiBPbiBXZWQsIE1hciAxMCwgMjAyMSBhdCAwNzozMDo0MUFN
IC0wNTAwLCBOZWFsIEdvbXBhIHdyb3RlOgo+ID4gRm9yZ2l2ZSBteSBpZ25vcmFuY2UsIGJ1dCBp
cyB0aGVyZSBhIHJlYXNvbiB3aHkgdGhpcyBpc24ndCB3aXJlZCB1cCB0bwo+ID4gQnRyZnMgYXQg
dGhlIHNhbWUgdGltZT8gSXQgc2VlbXMgd2VpcmQgdG8gbWUgdGhhdCBhZGRpbmcgYSBmZWF0dXJl
Cj4KPiBidHJmcyBkb2Vzbid0IHN1cHBvcnQgREFYLiAgb25seSBleHQyLCBleHQ0LCBYRlMgYW5k
IEZVU0UgaGF2ZSBEQVggc3VwcG9ydC4KPgo+IElmIHlvdSB0aGluayBhYm91dCBpdCwgYnRyZnMg
YW5kIERBWCBhcmUgZGlhbWV0cmljYWxseSBvcHBvc2l0ZSB0aGluZ3MuCj4gREFYIGlzIGFib3V0
IGdpdmluZyByYXcgYWNjZXNzIHRvIHRoZSBoYXJkd2FyZS4gIGJ0cmZzIGlzIGFib3V0IG9mZmVy
aW5nCj4gZXh0cmEgdmFsdWUgKFJBSUQsIGNoZWNrc3VtcywgLi4uKSwgbm9uZSBvZiB3aGljaCBj
YW4gYmUgZG9uZSBpZiB0aGUKPiBmaWxlc3lzdGVtIGlzbid0IGluIHRoZSByZWFkL3dyaXRlIHBh
dGguCj4KPiBUaGF0J3Mgd2h5IHRoZXJlJ3Mgbm8gREFYIHN1cHBvcnQgaW4gYnRyZnMuICBJZiB5
b3Ugd2FudCBEQVgsIHlvdSBoYXZlCj4gdG8gZ2l2ZSB1cCBhbGwgdGhlIGZlYXR1cmVzIHlvdSBs
aWtlIGluIGJ0cmZzLiAgU28geW91IG1heSBhcyB3ZWxsIHVzZQo+IGEgZGlmZmVyZW50IGZpbGVz
eXN0ZW0uCgpTbyBkb2VzIHRoYXQgbWVhbiB0aGF0IERBWCBpcyBpbmNvbXBhdGlibGUgd2l0aCB0
aG9zZSBmaWxlc3lzdGVtcyB3aGVuCmxheWVyZWQgb24gRE0gKGUuZy4gdGhyb3VnaCBMVk0pPwoK
QWxzbywgYmFzZWQgb24gd2hhdCB5b3UncmUgc2F5aW5nLCB0aGF0IG1lYW5zIHRoYXQgREFYJ2Qg
cmVzb3VyY2VzCndvdWxkIG5vdCBiZSBhYmxlIHRvIHVzZSByZWZsaW5rcyBvbiBYRlMsIHJpZ2h0
PyBUaGF0J2QgcHV0IGl0IGluCnNpbWlsYXIgdGVycml0b3J5IGFzIHN3YXAgZmlsZXMgb24gQnRy
ZnMsIEkgd291bGQgdGhpbmsuCgoKCi0tCuecn+Wun+OBr+OBhOOBpOOCguS4gOOBpO+8gS8gQWx3
YXlzLCB0aGVyZSdzIG9ubHkgb25lIHRydXRoIQoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVs
QG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9v
Y2ZzMi1kZXZlbA==
