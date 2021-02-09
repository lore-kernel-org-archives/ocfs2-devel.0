Return-Path: <SRS0=s8PX=HL=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18EDC433DB
	for <ocfs2-devel@archiver.kernel.org>; Tue,  9 Feb 2021 09:17:51 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 593A464EBA
	for <ocfs2-devel@archiver.kernel.org>; Tue,  9 Feb 2021 09:17:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 593A464EBA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11999lCB089226;
	Tue, 9 Feb 2021 09:17:50 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 36hk2kesq6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Feb 2021 09:17:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1199AwSq089615;
	Tue, 9 Feb 2021 09:17:49 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 36j51vtty7-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 09 Feb 2021 09:17:49 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l9P9Y-00061F-6N; Tue, 09 Feb 2021 01:17:48 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ruansy.fnst@cn.fujitsu.com>) id 1l9P99-00060E-M6
	for ocfs2-devel@oss.oracle.com; Tue, 09 Feb 2021 01:17:23 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1199Ab97168840
	for <ocfs2-devel@oss.oracle.com>; Tue, 9 Feb 2021 09:17:23 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3020.oracle.com with ESMTP id 36j4vr2ghn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 09 Feb 2021 09:17:23 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1199DDJn020713
	for <ocfs2-devel@oss.oracle.com>; Tue, 9 Feb 2021 09:17:22 GMT
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by userp2040.oracle.com with ESMTP id 36hhqu339x-1
	for <ocfs2-devel@oss.oracle.com>; Tue, 09 Feb 2021 09:17:22 +0000
X-IronPort-AV: E=Sophos;i="5.81,164,1610380800"; d="scan'208";a="104367244"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 09 Feb 2021 17:15:20 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id A2C304CE6F86;
	Tue,  9 Feb 2021 17:15:13 +0800 (CST)
Received: from irides.mr (10.167.225.141) by G08CNEXMBPEKD05.g08.fujitsu.local
	(10.167.33.204) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Tue, 9 Feb 2021 17:15:12 +0800
To: Christoph Hellwig <hch@lst.de>
References: <20210207170924.2933035-1-ruansy.fnst@cn.fujitsu.com>
	<20210207170924.2933035-6-ruansy.fnst@cn.fujitsu.com>
	<20210208151920.GE12872@lst.de>
From: Ruan Shiyang <ruansy.fnst@cn.fujitsu.com>
Message-ID: <9193e305-22a1-3928-0675-af1cecd28942@cn.fujitsu.com>
Date: Tue, 9 Feb 2021 17:15:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210208151920.GE12872@lst.de>
Content-Language: en-US
X-Originating-IP: [10.167.225.141]
X-ClientProxiedBy: G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) To
	G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204)
X-yoursite-MailScanner-ID: A2C304CE6F86.ACFE6
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
X-PDR: PASS
X-Source-IP: 183.91.158.132
X-ServerName: mail.cn.fujitsu.com
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
	lowpriorityscore=0 adultscore=0
	spamscore=0 bulkscore=0 clxscore=229 malwarescore=0 suspectscore=0
	priorityscore=60 mlxscore=0 mlxlogscore=999 impostorscore=0
	phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102090045
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by userp3020.oracle.com id
	1199Ab97168840
Cc: jack@suse.cz, darrick.wong@oracle.com, linux-nvdimm@lists.01.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 5/7] fsdax: Dedup file range to use a
	compare function
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090045
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 clxscore=1034 impostorscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090045

CgpPbiAyMDIxLzIvOCDkuIvljYgxMToxOSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gT24g
TW9uLCBGZWIgMDgsIDIwMjEgYXQgMDE6MDk6MjJBTSArMDgwMCwgU2hpeWFuZyBSdWFuIHdyb3Rl
Ogo+PiBXaXRoIGRheCB3ZSBjYW5ub3QgZGVhbCB3aXRoIHJlYWRwYWdlKCkgZXRjLiBTbywgd2Ug
Y3JlYXRlIGEKPj4gZnVuY2l0b24gY2FsbGJhY2sgdG8gcGVyZm9ybSB0aGUgZmlsZSBkYXRhIGNv
bXBhcmlzb24gYW5kIHBhc3MKPiAKPiBzL2Z1bmNpdG9uL2Z1bmN0aW9uL2cKPiAKPj4gKyNkZWZp
bmUgTUlOKGEsIGIpICgoKGEpIDwgKGIpKSA/IChhKSA6IChiKSkKPiAKPiBUaGlzIHNob3VsZCB1
c2UgdGhlIGV4aXN0aW5nIG1pbiBvciBtaW5fdCBoZWxwZXJzLgo+IAo+IAo+PiAgIGludCBnZW5l
cmljX3JlbWFwX2ZpbGVfcmFuZ2VfcHJlcChzdHJ1Y3QgZmlsZSAqZmlsZV9pbiwgbG9mZl90IHBv
c19pbiwKPj4gICAJCQkJICBzdHJ1Y3QgZmlsZSAqZmlsZV9vdXQsIGxvZmZfdCBwb3Nfb3V0LAo+
PiAtCQkJCSAgbG9mZl90ICpsZW4sIHVuc2lnbmVkIGludCByZW1hcF9mbGFncykKPj4gKwkJCQkg
IGxvZmZfdCAqbGVuLCB1bnNpZ25lZCBpbnQgcmVtYXBfZmxhZ3MsCj4+ICsJCQkJICBjb21wYXJl
X3JhbmdlX3QgY29tcGFyZV9yYW5nZV9mbikKPiAKPiBDYW4gd2Uga2VlcCBnZW5lcmljX3JlbWFw
X2ZpbGVfcmFuZ2VfcHJlcCBhcy1pcywgYW5kIGFkZCBhIG5ldwo+IGRheF9yZW1hcF9maWxlX3Jh
bmdlX3ByZXAsIGJvdGggc2hhcmluZyBhIGxvdy1sZXZlbAo+IF9fZ2VuZXJpY19yZW1hcF9maWxl
X3JhbmdlX3ByZXAgaW1wbGVtZW50YXRpb24/ICBBbmQgZm9yIHRoYXQKPiBpbXBsZW1lbnRhdGlv
biBJJ2QgYWxzbyBnbyBmb3IgY2xhc3NpYyBpZi9lbHNlIGluc3RlYWQgb2YgdGhlIGZ1bmN0aW9u
Cj4gcG9pbnRlci4KClRoZSBkYXggZGVkdXBlIGNvbXBhcmlzb24gbmVlZCB0aGUgaW9tYXBfb3Bz
IHBvaW50ZXIgYXMgYXJndW1lbnQsIHNvIG15IAp1bmRlcnN0YW5kaW5nIGlzIHRoYXQgd2UgZG9u
J3QgbW9kaWZ5IHRoZSBhcmd1bWVudCBsaXN0IG9mIApnZW5lcmljX3JlbWFwX2ZpbGVfcmFuZ2Vf
cHJlcCgpLCBidXQgbW92ZSBpdHMgY29kZSBpbnRvIApfX2dlbmVyaWNfcmVtYXBfZmlsZV9yYW5n
ZV9wcmVwKCkgd2hvc2UgYXJndW1lbnQgbGlzdCBjYW4gYmUgbW9kaWZpZWQgdG8gCmFjY2VwdHMg
dGhlIGlvbWFwX29wcyBwb2ludGVyLiAgVGhlbiBpdCBsb29rcyBsaWtlIHRoaXM6CgpgYGAKaW50
IGRheF9yZW1hcF9maWxlX3JhbmdlX3ByZXAoc3RydWN0IGZpbGUgKmZpbGVfaW4sIGxvZmZfdCBw
b3NfaW4sCgkJCQkgIHN0cnVjdCBmaWxlICpmaWxlX291dCwgbG9mZl90IHBvc19vdXQsCgkJCQkg
IGxvZmZfdCAqbGVuLCB1bnNpZ25lZCBpbnQgcmVtYXBfZmxhZ3MsCgkJCQkgIGNvbnN0IHN0cnVj
dCBpb21hcF9vcHMgKm9wcykKewoJcmV0dXJuIF9fZ2VuZXJpY19yZW1hcF9maWxlX3JhbmdlX3By
ZXAoZmlsZV9pbiwgcG9zX2luLCBmaWxlX291dCwKCQkJcG9zX291dCwgbGVuLCByZW1hcF9mbGFn
cywgb3BzKTsKfQpFWFBPUlRfU1lNQk9MKGRheF9yZW1hcF9maWxlX3JhbmdlX3ByZXApOwoKaW50
IGdlbmVyaWNfcmVtYXBfZmlsZV9yYW5nZV9wcmVwKHN0cnVjdCBmaWxlICpmaWxlX2luLCBsb2Zm
X3QgcG9zX2luLAoJCQkJICBzdHJ1Y3QgZmlsZSAqZmlsZV9vdXQsIGxvZmZfdCBwb3Nfb3V0LAoJ
CQkJICBsb2ZmX3QgKmxlbiwgdW5zaWduZWQgaW50IHJlbWFwX2ZsYWdzKQp7CglyZXR1cm4gX19n
ZW5lcmljX3JlbWFwX2ZpbGVfcmFuZ2VfcHJlcChmaWxlX2luLCBwb3NfaW4sIGZpbGVfb3V0LAoJ
CQlwb3Nfb3V0LCBsZW4sIHJlbWFwX2ZsYWdzLCBOVUxMKTsKfQpFWFBPUlRfU1lNQk9MKGdlbmVy
aWNfcmVtYXBfZmlsZV9yYW5nZV9wcmVwKTsKYGBgCgpBbSBpIHJpZ2h0PwoKCi0tClRoYW5rcywK
UnVhbiBTaGl5YW5nLgoKPiAKPj4gK2V4dGVybiBpbnQgdmZzX2RlZHVwZV9maWxlX3JhbmdlX2Nv
bXBhcmUoc3RydWN0IGlub2RlICpzcmMsIGxvZmZfdCBzcmNvZmYsCj4+ICsJCQkJCSBzdHJ1Y3Qg
aW5vZGUgKmRlc3QsIGxvZmZfdCBkZXN0b2ZmLAo+PiArCQkJCQkgbG9mZl90IGxlbiwgYm9vbCAq
aXNfc2FtZSk7Cj4gCj4gbm8gbmVlZCBmb3IgdGhlIGV4dGVybi4KPiAKPiAKCgoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGlu
ZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20v
bWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
