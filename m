Return-Path: <SRS0=D8ch=HT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B5FFC433DB
	for <ocfs2-devel@archiver.kernel.org>; Wed, 17 Feb 2021 03:24:37 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E94E364E02
	for <ocfs2-devel@archiver.kernel.org>; Wed, 17 Feb 2021 03:24:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E94E364E02
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11H3OZTp018865;
	Wed, 17 Feb 2021 03:24:35 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2120.oracle.com with ESMTP id 36pd9a8d8j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Feb 2021 03:24:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11H3LYuN081887;
	Wed, 17 Feb 2021 03:24:34 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36prhsbcdr-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 17 Feb 2021 03:24:34 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lCDS5-0000R9-MA; Tue, 16 Feb 2021 19:24:33 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ruansy.fnst@cn.fujitsu.com>) id 1lCDS2-0000Qi-PG
	for ocfs2-devel@oss.oracle.com; Tue, 16 Feb 2021 19:24:30 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11H3KMAl036355
	for <ocfs2-devel@oss.oracle.com>; Wed, 17 Feb 2021 03:24:30 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by aserp3030.oracle.com with ESMTP id 36prbnymc5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 17 Feb 2021 03:24:30 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11H3O1O4006786
	for <ocfs2-devel@oss.oracle.com>; Wed, 17 Feb 2021 03:24:29 GMT
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by userp2040.oracle.com with ESMTP id 36qrn13tt5-1
	for <ocfs2-devel@oss.oracle.com>; Wed, 17 Feb 2021 03:24:29 +0000
X-IronPort-AV: E=Sophos;i="5.81,184,1610380800"; d="scan'208";a="104562120"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 17 Feb 2021 11:24:20 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id 1AC344CE602A;
	Wed, 17 Feb 2021 11:24:20 +0800 (CST)
Received: from irides.mr (10.167.225.141) by G08CNEXMBPEKD05.g08.fujitsu.local
	(10.167.33.204) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Wed, 17 Feb 2021 11:24:18 +0800
To: Christoph Hellwig <hch@lst.de>
References: <20210207170924.2933035-1-ruansy.fnst@cn.fujitsu.com>
	<20210207170924.2933035-6-ruansy.fnst@cn.fujitsu.com>
	<20210208151920.GE12872@lst.de>
	<9193e305-22a1-3928-0675-af1cecd28942@cn.fujitsu.com>
	<20210209093438.GA630@lst.de>
	<79b0d65c-95dd-4821-e412-ab27c8cb6942@cn.fujitsu.com>
	<20210210131928.GA30109@lst.de>
From: Ruan Shiyang <ruansy.fnst@cn.fujitsu.com>
Message-ID: <b00cfda5-464c-6161-77c6-6a25b1cc7a77@cn.fujitsu.com>
Date: Wed, 17 Feb 2021 11:24:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210210131928.GA30109@lst.de>
Content-Language: en-US
X-Originating-IP: [10.167.225.141]
X-ClientProxiedBy: G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) To
	G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204)
X-yoursite-MailScanner-ID: 1AC344CE602A.A9FC5
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
X-PDR: PASS
X-Source-IP: 183.91.158.132
X-ServerName: mail.cn.fujitsu.com
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=960
	spamscore=0 mlxscore=0
	suspectscore=0 adultscore=0 bulkscore=0 clxscore=159 priorityscore=0
	impostorscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102170021
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by aserp3030.oracle.com id
	11H3KMAl036355
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170020
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1034 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170021

CgpPbiAyMDIxLzIvMTAg5LiL5Y2IOToxOSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gT24g
VHVlLCBGZWIgMDksIDIwMjEgYXQgMDU6NDY6MTNQTSArMDgwMCwgUnVhbiBTaGl5YW5nIHdyb3Rl
Ogo+Pgo+Pgo+PiBPbiAyMDIxLzIvOSDkuIvljYg1OjM0LCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToKPj4+IE9uIFR1ZSwgRmViIDA5LCAyMDIxIGF0IDA1OjE1OjEzUE0gKzA4MDAsIFJ1YW4gU2hp
eWFuZyB3cm90ZToKPj4+PiBUaGUgZGF4IGRlZHVwZSBjb21wYXJpc29uIG5lZWQgdGhlIGlvbWFw
X29wcyBwb2ludGVyIGFzIGFyZ3VtZW50LCBzbyBteQo+Pj4+IHVuZGVyc3RhbmRpbmcgaXMgdGhh
dCB3ZSBkb24ndCBtb2RpZnkgdGhlIGFyZ3VtZW50IGxpc3Qgb2YKPj4+PiBnZW5lcmljX3JlbWFw
X2ZpbGVfcmFuZ2VfcHJlcCgpLCBidXQgbW92ZSBpdHMgY29kZSBpbnRvCj4+Pj4gX19nZW5lcmlj
X3JlbWFwX2ZpbGVfcmFuZ2VfcHJlcCgpIHdob3NlIGFyZ3VtZW50IGxpc3QgY2FuIGJlIG1vZGlm
aWVkIHRvCj4+Pj4gYWNjZXB0cyB0aGUgaW9tYXBfb3BzIHBvaW50ZXIuICBUaGVuIGl0IGxvb2tz
IGxpa2UgdGhpczoKPj4+Cj4+PiBJJ2Qgc2F5IGp1c3QgYWRkIHRoZSBpb21hcF9vcHMgcG9pbnRl
ciB0bwo+Pj4gZ2VuZXJpY19yZW1hcF9maWxlX3JhbmdlX3ByZXAgYW5kIGRvIGF3YXkgd2l0aCB0
aGUgZXh0cmEgd3JhcHBlcnMuICBXZQo+Pj4gb25seSBoYXZlIHRocmVlIGNhbGxlcnMgYW55d2F5
Lgo+Pgo+PiBPSy4KPiAKPiBTbyBsb29raW5nIGF0IHRoaXMgYWdhaW4gSSB0aGluayB5b3VyIHBy
b3Bvc2FsIGFjdGF1bGx5IGlzIGJldHRlciwKPiBnaXZlbiB0aGF0IHRoZSBpb21hcCB2YXJpYW50
IGlzIHN0aWxsIERBWCBzcGVjaWZpYy4gIFNvcnJ5IGZvcgo+IHRoZSBub2lzZS4KPiAKPiBBbHNv
IEkgdGhpbmsgZGF4X2ZpbGVfcmFuZ2VfY29tcGFyZSBzaG91bGQgdXNlIGlvbWFwX2FwcGx5IGlu
c3RlYWQKPiBvZiBvcGVuIGNvZGluZyBpdC4KPiAKClRoZXJlIGFyZSB0d28gZmlsZXMsIHdoaWNo
IGFyZSBub3QgcmVmbGlua2VkLCBuZWVkIHRvIGJlIGRpcmVjdF9hY2Nlc3MoKSAKaGVyZS4gIFRo
ZSBpb21hcF9hcHBseSgpIGNhbiBoYW5kbGUgb25lIGZpbGUgZWFjaCB0aW1lLiAgU28sIGl0IHNl
ZW1zIAp0aGF0IGlvbWFwX2FwcGx5KCkgaXMgbm90IHN1aXRhYmxlIGZvciB0aGlzIGNhc2UuLi4K
CgpUaGUgcHNldWRvIGNvZGUgb2YgdGhpcyBwcm9jZXNzIGlzIGFzIGZvbGxvd3M6CgogICBzcmNs
ZW4gPSBvcHMtPmJlZ2luKCZzcmNtYXApCiAgIGRlc3RsZW4gPSBvcHMtPmJlZ2luKCZkZXN0bWFw
KQoKICAgZGlyZWN0X2FjY2Vzcygmc3JjbWFwLCAmc2FkZHIpCiAgIGRpcmVjdF9hY2Nlc3MoJmRl
c3RtYXAsICZkYWRkcikKCiAgIHNhbWUgPSBtZW1jcHkoc2FkZHIsIGRhZGRyLCBtaW4oc3JjbGVu
LGRlc3RsZW4pKQoKICAgb3BzLT5lbmQoJmRlc3RtYXApCiAgIG9wcy0+ZW5kKCZzcmNtYXApCgpJ
IHRoaW5rIGEgbmVzdGVkIGNhbGwgbGlrZSB0aGlzIGlzIG5lY2Vzc2FyeS4gIFRoYXQncyB3aHkg
SSB1c2UgdGhlIG9wZW4gCmNvZGUgd2F5LgoKCi0tClRoYW5rcywKUnVhbiBTaGl5YW5nLgo+IAoK
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1k
ZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mu
b3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
