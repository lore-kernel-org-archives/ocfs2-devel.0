Return-Path: <SRS0=LbgC=OD=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A8DBC433F5
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Sep 2021 14:28:54 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0D44F60F58
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Sep 2021 14:28:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0D44F60F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DESqCZ024407;
	Mon, 13 Sep 2021 14:28:53 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3b1h45jxr9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Sep 2021 14:28:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18DEDPCo034919;
	Mon, 13 Sep 2021 14:28:51 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3b167qh6vu-1;
	Mon, 13 Sep 2021 14:28:50 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mPmwz-0004hg-TU; Mon, 13 Sep 2021 07:28:49 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <fdmanana@gmail.com>) id 1mMAnt-0004Ii-Vw
	for ocfs2-devel@oss.oracle.com; Fri, 03 Sep 2021 08:08:30 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	183EsXGY049041
	for <ocfs2-devel@oss.oracle.com>; Fri, 3 Sep 2021 15:08:29 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by userp3030.oracle.com with ESMTP id 3ate07m1uf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 03 Sep 2021 15:08:29 +0000
Received: from pps.filterd (m0246577.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	18397hv3030907
	for <ocfs2-devel@oss.oracle.com>; Fri, 3 Sep 2021 15:08:28 GMT
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com
	[209.85.222.182])
	by mx0b-00069f01.pphosted.com with ESMTP id 3au7wc9am1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 03 Sep 2021 15:08:28 +0000
Received: by mail-qk1-f182.google.com with SMTP id a66so6094775qkc.1
	for <ocfs2-devel@oss.oracle.com>; Fri, 03 Sep 2021 08:08:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
	:from:date:message-id:subject:to:cc:content-transfer-encoding;
	bh=dfVAyRi3egcPmrpkkX6mL213sIGpEaRWvxdiTkq+xW8=;
	b=lABpGGDwgMW/qWk8wlnOyd59IJyYaY/EmAeRC+JPazsONyqERZYptYhtIq2wWWI3qg
	gQ5sn5MsvjX6bootjipivTrbwswFJ/qAvuoZGQngA18HnqjI3e0gF1Ji/w0rXKf9DHmA
	5mexVgBo6uMtd2Auo3j7VZZvUkifbk1ZjaRgKS1rrhxUBIaShlNlQl4eGX1L02g5tDB2
	TI+TAM9dD+64zwGu+FoXR1co/UXi/s3OxgIMtCXQGnC6l9ZCF8vRv6P88hYdoktfbS6m
	tkEYdvN59nrIjQeM7i0FXR1dr40d7WKFWDMNTK74VCDdNeRIJ6rRBXkT5bR8hZ2qq/Gc
	GO2A==
X-Gm-Message-State: AOAM533sA9NlAHP4ZM49S/Zp5zn0djANXMdms3Lgjwyx0takdIsGLpO9
	HIwWSi8fYtpQjFDzhMQPdTL9uheSjoYrNaUChS/f/dTjzUM=
X-Google-Smtp-Source: ABdhPJxOxNoEKZDrnzr5I27hdDLrYAI3fzlDltFTJm77mMKSv9gWkp9I05ZDbo+9/cQzt6JSbVvTx3kldRbLUD+SG7w=
X-Received: by 2002:a05:620a:2844:: with SMTP id
	h4mr3924402qkp.388.1630681707290; 
	Fri, 03 Sep 2021 08:08:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210827164926.1726765-1-agruenba@redhat.com>
In-Reply-To: <20210827164926.1726765-1-agruenba@redhat.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Fri, 3 Sep 2021 16:07:51 +0100
Message-ID: <CAL3q7H709FSbHtinPRqe6XtZEvhmkSVBhFHUGMiVDW7Ngb3wrQ@mail.gmail.com>
To: Andreas Gruenbacher <agruenba@redhat.com>
X-Source-IP: 209.85.222.182
X-ServerName: mail-qk1-f182.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10096
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
	spamscore=0
	impostorscore=0 malwarescore=0 bulkscore=0 suspectscore=0
	mlxlogscore=999
	priorityscore=331 clxscore=203 adultscore=0 mlxscore=0
	lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2108310000 definitions=main-2109030093
X-Spam: Clean
X-Mailman-Approved-At: Mon, 13 Sep 2021 07:28:45 -0700
Cc: kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        cluster-devel@redhat.com, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v7 00/19] gfs2: Fix mmap + page fault
	deadlocks
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
Reply-To: fdmanana@gmail.com
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10105 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109130095
X-Proofpoint-ORIG-GUID: XRMz9fLJE_IJg6yuMwVSeJrdC8ogfLJE
X-Proofpoint-GUID: XRMz9fLJE_IJg6yuMwVSeJrdC8ogfLJE

T24gRnJpLCBBdWcgMjcsIDIwMjEgYXQgNTo1MSBQTSBBbmRyZWFzIEdydWVuYmFjaGVyIDxhZ3J1
ZW5iYUByZWRoYXQuY29tPiB3cm90ZToKPgo+IEhpIGFsbCwKPgo+IGhlcmUncyBhbm90aGVyIHVw
ZGF0ZSBvbiB0b3Agb2YgdjUuMTQtcmM3LiAgQ2hhbmdlczoKPgo+ICAqIFNvbWUgb2YgdGhlIHBh
dGNoIGRlc2NyaXB0aW9ucyBoYXZlIGJlZW4gaW1wcm92ZWQuCj4KPiAgKiBQYXRjaCAiZ2ZzMjog
RWxpbWluYXRlIGlwLT5pX2doIiBoYXMgYmVlbiBtb3ZlZCBmdXJ0aGVyIHRvIHRoZSBmcm9udC4K
Pgo+IEF0IHRoaXMgcG9pbnQsIEknbSBub3QgYXdhcmUgb2YgYW55dGhpbmcgdGhhdCBzdGlsbCBu
ZWVkcyBmaXhpbmcsCgpIaSwgdGhhbmtzIGZvciBkb2luZyB0aGlzLgoKSW4gYnRyZnMgd2UgYWxz
byBoYXZlIGEgZGVhZGxvY2sgKGFmdGVyIHRoZSBjb252ZXJzaW9uIHRvIHVzZSBpb21hcApmb3Ig
ZGlyZWN0IElPKSB0cmlnZ2VyZWQgYnkgeW91ciByZWNlbnQgdGVzdCBjYXNlIGZvciBmc3Rlc3Rz
LApnZW5lcmljLzY0NyBbMV0uCkV2ZW4gdGhvdWdoIHdlIGNhbiBmaXggaXQgaW4gYnRyZnMgd2l0
aG91dCB0b3VjaGluZyBpb21hcCwgaW92X2l0ZXIsCmV0YywgaXQgd291bGQgYmUgdG9vIGNvbXBs
ZXggZm9yIHN1Y2ggYSByYXJlIGFuZCBleG90aWMgY2FzZSAoYSB1c2VyCnBhc3NpbmcgYSBidWZm
ZXIgZm9yIGEgZGlyZWN0IElPIHJlYWQvd3JpdGUgdGhhdCBpcyBtZW1vcnkgbWFwcGVkIHRvCnRo
ZSBzYW1lIGZpbGUgcmFuZ2Ugb2YgdGhlIG9wZXJhdGlvbiBpcyB2ZXJ5IHVuY29tbW9uIGF0IGxl
YXN0KS4gQnV0CnRoaXMgcGF0Y2hzZXQgd291bGQgbWFrZSB0aGUgZml4IG11Y2ggc2ltcGxlciBh
bmQgY2xlYW5lci4KCk9uZSB0aGluZyBJIG5vdGljZWQgaXMgdGhhdCwgZm9yIGRpcmVjdCBJTyBy
ZWFkcywgZGVzcGl0ZSBzZXR0aW5nIHRoZQotPm5vZmF1bHQgYXR0cmlidXRlIG9mIHRoZSBpb3Zf
aXRlciB0byB0cnVlLCB3ZSBjYW4gc3RpbGwgZ2V0IHBhZ2UKZmF1bHRzIHdoaWxlIGluIHRoZSBp
b21hcCBjb2RlLgpUaGlzIGhhcHBlbnMgd2hlbiByZWFkaW5nIGZyb20gaG9sZXMgYW5kIHVud3Jp
dHRlbi9wcmVhbGxvYyBleHRlbnRzLApiZWNhdXNlIGlvbWFwIGNhbGxzIGlvdl9pdGVyX3plcm8o
KSBhbmQgdGhpcyBzZWVtcyB0byBpZ25vcmUgdGhlIHZhbHVlCm9mIC0+bm9mYXVsdC4KSXMgdGhh
dCBpbnRlbnRpb25hbD8gSSBjYW4gZ2V0IGFyb3VuZCBpdCBieSBzdXJyb3VuZGluZyB0aGUgaW9t
YXAgY2FsbAp3aXRoIHBhZ2VmYXVsdF9kaXNhYmxlKCkgLyBwYWdlZmF1bHRfZW5hYmxlKCksIGJ1
dCBpdCBzZWVtcyBvZGQgdG8gZG8Kc28sIGdpdmVuIHRoYXQgaW92X2l0ZXItPm5vZmF1bHQgd2Fz
IHNldCB0byB0cnVlLgoKWzFdIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9mcy94ZnMv
eGZzdGVzdHMtZGV2LmdpdC9jb21taXQvP2lkPWQzY2JkYWJmZmM0Y2IyODg1MGU5N2JjN2JkOGE3
YTE0NjBkYjk0ZTUKClRoYW5rcy4KCj4KPgo+IFRoZSBmaXJzdCB0d28gcGF0Y2hlcyBhcmUgaW5k
ZXBlbmRlbnQgb2YgdGhlIGNvcmUgb2YgdGhpcyBwYXRjaCBxdWV1ZQo+IGFuZCBJJ3ZlIGFza2Vk
IHRoZSByZXNwZWN0aXZlIG1haW50YWluZXJzIHRvIGhhdmUgYSBsb29rLCBidXQgSSd2ZSBub3QK
PiBoZWFyZCBiYWNrIGZyb20gdGhlbS4gIFRoZSBmaXJzdCBwYXRjaCBzaG91bGQganVzdCBnbyBp
bnRvIEFsJ3MgdHJlZTsKPiBpdCdzIGEgcmVsYXRpdmVseSBzdHJhaWdodC1mb3J3YXJkIGZpeC4g
IFRoZSBzZWNvbmQgcGF0Y2ggcmVhbGx5IG5lZWRzCj4gdG8gYmUgbG9va2VkIGF0OyBpdCBtaWdo
dCBicmVhayB0aGluZ3M6Cj4KPiAgIGlvdl9pdGVyOiBGaXggaW92X2l0ZXJfZ2V0X3BhZ2Vzeyxf
YWxsb2N9IHBhZ2UgZmF1bHQgcmV0dXJuIHZhbHVlCj4gICBwb3dlcnBjL2t2bTogRml4IGt2bV91
c2VfbWFnaWNfcGFnZQo+Cj4KPiBBbCBhbmQgTGludXMgc2VlbSB0byBoYXZlIGEgZGlzYWdyZWVt
ZW50IGFib3V0IHRoZSBlcnJvciByZXBvcnRpbmcKPiBzZW1hbnRpY3MgdGhhdCBmdW5jdGlvbnMg
ZmF1bHRfaW5fe3JlYWRhYmxlLHdyaXRlYWJsZX0gYW5kCj4gZmF1bHRfaW5faW92X2l0ZXJfe3Jl
YWRhYmxlLHdyaXRlYWJsZX0gc2hvdWxkIGhhdmUuICBJJ3ZlIGltcGxlbWVudGVkCj4gTGludXMn
cyBzdWdnZXN0aW9uIG9mIHJldHVybmluZyB0aGUgbnVtYmVyIG9mIGJ5dGVzIG5vdCBmYXVsdGVk
IGluIGFuZCBJCj4gdGhpbmsgdGhhdCBiZWluZyBhYmxlIHRvIHRlbGwgaWYgIm5vdGhpbmciLCAi
c29tZXRoaW5nIiBvciAiZXZlcnl0aGluZyIKPiBjb3VsZCBiZSBmYXVsdGVkIGluIGRvZXMgaGVs
cCwgYnV0IEknbGwgbGl2ZSB3aXRoIGFueXRoaW5nIHRoYXQgYWxsb3dzCj4gdXMgdG8gbWFrZSBw
cm9ncmVzcy4KPgo+Cj4gVGhlIGlvbWFwIGNoYW5nZXMgc2hvdWxkIGlkZWFsbHkgYmUgcmV2aWV3
ZWQgYnkgQ2hyaXN0b3BoOyBJJ3ZlIG5vdAo+IGhlYXJkIGZyb20gaGltIGFib3V0IHRob3NlLgo+
Cj4KPiBUaGFua3MsCj4gQW5kcmVhcwo+Cj4gQW5kcmVhcyBHcnVlbmJhY2hlciAoMTYpOgo+ICAg
aW92X2l0ZXI6IEZpeCBpb3ZfaXRlcl9nZXRfcGFnZXN7LF9hbGxvY30gcGFnZSBmYXVsdCByZXR1
cm4gdmFsdWUKPiAgIHBvd2VycGMva3ZtOiBGaXgga3ZtX3VzZV9tYWdpY19wYWdlCj4gICBndXA6
IFR1cm4gZmF1bHRfaW5fcGFnZXNfe3JlYWRhYmxlLHdyaXRlYWJsZX0gaW50bwo+ICAgICBmYXVs
dF9pbl97cmVhZGFibGUsd3JpdGVhYmxlfQo+ICAgaW92X2l0ZXI6IFR1cm4gaW92X2l0ZXJfZmF1
bHRfaW5fcmVhZGFibGUgaW50bwo+ICAgICBmYXVsdF9pbl9pb3ZfaXRlcl9yZWFkYWJsZQo+ICAg
aW92X2l0ZXI6IEludHJvZHVjZSBmYXVsdF9pbl9pb3ZfaXRlcl93cml0ZWFibGUKPiAgIGdmczI6
IEFkZCB3cmFwcGVyIGZvciBpb21hcF9maWxlX2J1ZmZlcmVkX3dyaXRlCj4gICBnZnMyOiBDbGVh
biB1cCBmdW5jdGlvbiBtYXlfZ3JhbnQKPiAgIGdmczI6IE1vdmUgdGhlIGlub2RlIGdsb2NrIGxv
Y2tpbmcgdG8gZ2ZzMl9maWxlX2J1ZmZlcmVkX3dyaXRlCj4gICBnZnMyOiBFbGltaW5hdGUgaXAt
PmlfZ2gKPiAgIGdmczI6IEZpeCBtbWFwICsgcGFnZSBmYXVsdCBkZWFkbG9ja3MgZm9yIGJ1ZmZl
cmVkIEkvTwo+ICAgaW9tYXA6IEZpeCBpb21hcF9kaW9fcncgcmV0dXJuIHZhbHVlIGZvciB1c2Vy
IGNvcGllcwo+ICAgaW9tYXA6IFN1cHBvcnQgcGFydGlhbCBkaXJlY3QgSS9PIG9uIHVzZXIgY29w
eSBmYWlsdXJlcwo+ICAgaW9tYXA6IEFkZCBkb25lX2JlZm9yZSBhcmd1bWVudCB0byBpb21hcF9k
aW9fcncKPiAgIGd1cDogSW50cm9kdWNlIEZPTExfTk9GQVVMVCBmbGFnIHRvIGRpc2FibGUgcGFn
ZSBmYXVsdHMKPiAgIGlvdl9pdGVyOiBJbnRyb2R1Y2Ugbm9mYXVsdCBmbGFnIHRvIGRpc2FibGUg
cGFnZSBmYXVsdHMKPiAgIGdmczI6IEZpeCBtbWFwICsgcGFnZSBmYXVsdCBkZWFkbG9ja3MgZm9y
IGRpcmVjdCBJL08KPgo+IEJvYiBQZXRlcnNvbiAoMyk6Cj4gICBnZnMyOiBFbGltaW5hdGUgdmVz
dGlnaWFsIEhJRl9GSVJTVAo+ICAgZ2ZzMjogUmVtb3ZlIHJlZHVuZGFudCBjaGVjayBmcm9tIGdm
czJfZ2xvY2tfZHEKPiAgIGdmczI6IEludHJvZHVjZSBmbGFnIGZvciBnbG9jayBob2xkZXIgYXV0
by1kZW1vdGlvbgo+Cj4gIGFyY2gvcG93ZXJwYy9rZXJuZWwva3ZtLmMgICAgICAgICAgIHwgICAz
ICstCj4gIGFyY2gvcG93ZXJwYy9rZXJuZWwvc2lnbmFsXzMyLmMgICAgIHwgICA0ICstCj4gIGFy
Y2gvcG93ZXJwYy9rZXJuZWwvc2lnbmFsXzY0LmMgICAgIHwgICAyICstCj4gIGFyY2gveDg2L2tl
cm5lbC9mcHUvc2lnbmFsLmMgICAgICAgIHwgICA3ICstCj4gIGRyaXZlcnMvZ3B1L2RybS9hcm1h
ZGEvYXJtYWRhX2dlbS5jIHwgICA3ICstCj4gIGZzL2J0cmZzL2ZpbGUuYyAgICAgICAgICAgICAg
ICAgICAgIHwgICA3ICstCj4gIGZzL2J0cmZzL2lvY3RsLmMgICAgICAgICAgICAgICAgICAgIHwg
ICA1ICstCj4gIGZzL2V4dDQvZmlsZS5jICAgICAgICAgICAgICAgICAgICAgIHwgICA1ICstCj4g
IGZzL2YyZnMvZmlsZS5jICAgICAgICAgICAgICAgICAgICAgIHwgICAyICstCj4gIGZzL2Z1c2Uv
ZmlsZS5jICAgICAgICAgICAgICAgICAgICAgIHwgICAyICstCj4gIGZzL2dmczIvYm1hcC5jICAg
ICAgICAgICAgICAgICAgICAgIHwgIDYwICstLS0tCj4gIGZzL2dmczIvZmlsZS5jICAgICAgICAg
ICAgICAgICAgICAgIHwgMjQ1ICsrKysrKysrKysrKysrKysrKy0tCj4gIGZzL2dmczIvZ2xvY2su
YyAgICAgICAgICAgICAgICAgICAgIHwgMzQwICsrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0K
PiAgZnMvZ2ZzMi9nbG9jay5oICAgICAgICAgICAgICAgICAgICAgfCAgMjAgKysKPiAgZnMvZ2Zz
Mi9pbmNvcmUuaCAgICAgICAgICAgICAgICAgICAgfCAgIDUgKy0KPiAgZnMvaW9tYXAvYnVmZmVy
ZWQtaW8uYyAgICAgICAgICAgICAgfCAgIDIgKy0KPiAgZnMvaW9tYXAvZGlyZWN0LWlvLmMgICAg
ICAgICAgICAgICAgfCAgMjEgKy0KPiAgZnMvbnRmcy9maWxlLmMgICAgICAgICAgICAgICAgICAg
ICAgfCAgIDIgKy0KPiAgZnMveGZzL3hmc19maWxlLmMgICAgICAgICAgICAgICAgICAgfCAgIDYg
Ky0KPiAgZnMvem9uZWZzL3N1cGVyLmMgICAgICAgICAgICAgICAgICAgfCAgIDQgKy0KPiAgaW5j
bHVkZS9saW51eC9pb21hcC5oICAgICAgICAgICAgICAgfCAgMTEgKy0KPiAgaW5jbHVkZS9saW51
eC9tbS5oICAgICAgICAgICAgICAgICAgfCAgIDMgKy0KPiAgaW5jbHVkZS9saW51eC9wYWdlbWFw
LmggICAgICAgICAgICAgfCAgNTggKy0tLS0KPiAgaW5jbHVkZS9saW51eC91aW8uaCAgICAgICAg
ICAgICAgICAgfCAgIDQgKy0KPiAgbGliL2lvdl9pdGVyLmMgICAgICAgICAgICAgICAgICAgICAg
fCAxMDMgKysrKysrKy0tCj4gIG1tL2ZpbGVtYXAuYyAgICAgICAgICAgICAgICAgICAgICAgIHwg
ICA0ICstCj4gIG1tL2d1cC5jICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgMTM5ICsrKysr
KysrKysrLQo+ICAyNyBmaWxlcyBjaGFuZ2VkLCA3ODUgaW5zZXJ0aW9ucygrKSwgMjg2IGRlbGV0
aW9ucygtKQo+Cj4gLS0KPiAyLjI2LjMKPgoKCi0tIApGaWxpcGUgRGF2aWQgTWFuYW5hLAoK4oCc
V2hldGhlciB5b3UgdGhpbmsgeW91IGNhbiwgb3IgeW91IHRoaW5rIHlvdSBjYW4ndCDigJQgeW91
J3JlIHJpZ2h0LuKAnQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29t
Cmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
