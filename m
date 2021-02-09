Return-Path: <SRS0=s8PX=HL=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBCF7C433DB
	for <ocfs2-devel@archiver.kernel.org>; Tue,  9 Feb 2021 01:56:33 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1F99C64E42
	for <ocfs2-devel@archiver.kernel.org>; Tue,  9 Feb 2021 01:56:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F99C64E42
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191KNJ2106142;
	Tue, 9 Feb 2021 01:56:32 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2120.oracle.com with ESMTP id 36hkrmwwpv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Feb 2021 01:56:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191LCWl196434;
	Tue, 9 Feb 2021 01:56:31 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 36j51vdccm-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 09 Feb 2021 01:56:31 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l9IDR-0000ls-6s; Mon, 08 Feb 2021 17:53:21 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ruansy.fnst@cn.fujitsu.com>) id 1l9IDP-0000ld-HO
	for ocfs2-devel@oss.oracle.com; Mon, 08 Feb 2021 17:53:19 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1191K95S155486
	for <ocfs2-devel@oss.oracle.com>; Tue, 9 Feb 2021 01:53:19 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by aserp3030.oracle.com with ESMTP id 36j4pn2489-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 09 Feb 2021 01:53:19 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1191NYD3001435
	for <ocfs2-devel@oss.oracle.com>; Tue, 9 Feb 2021 01:53:18 GMT
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by userp2040.oracle.com with ESMTP id 36hhqtw7fy-1
	for <ocfs2-devel@oss.oracle.com>; Tue, 09 Feb 2021 01:53:18 +0000
X-IronPort-AV: E=Sophos;i="5.81,163,1610380800"; d="scan'208";a="104350575"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 09 Feb 2021 09:53:15 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id 9EFD34CE6F82;
	Tue,  9 Feb 2021 09:53:10 +0800 (CST)
Received: from irides.mr (10.167.225.141) by G08CNEXMBPEKD05.g08.fujitsu.local
	(10.167.33.204) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Tue, 9 Feb 2021 09:53:08 +0800
To: Christoph Hellwig <hch@lst.de>
References: <20210207170924.2933035-1-ruansy.fnst@cn.fujitsu.com>
	<20210207170924.2933035-4-ruansy.fnst@cn.fujitsu.com>
	<20210208151419.GC12872@lst.de>
From: Ruan Shiyang <ruansy.fnst@cn.fujitsu.com>
Message-ID: <3f2826a8-df98-e7b0-6ab8-0f410488bc55@cn.fujitsu.com>
Date: Tue, 9 Feb 2021 09:53:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210208151419.GC12872@lst.de>
Content-Language: en-US
X-Originating-IP: [10.167.225.141]
X-ClientProxiedBy: G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) To
	G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204)
X-yoursite-MailScanner-ID: 9EFD34CE6F82.AF079
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
	spamscore=0 bulkscore=0 clxscore=206 malwarescore=0 suspectscore=0
	priorityscore=108 mlxscore=0 mlxlogscore=709 impostorscore=0
	phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102090002
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by aserp3030.oracle.com id
	1191K95S155486
Cc: jack@suse.cz, darrick.wong@oracle.com, linux-nvdimm@lists.01.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        dan.j.williams@intel.com, linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 3/7] fsdax: Copy data before write
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
 definitions=main-2102090002
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1034
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090002

CgpPbiAyMDIxLzIvOCDkuIvljYgxMToxNCwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4+ICAg
CXN3aXRjaCAoaW9tYXAudHlwZSkgewo+PiAgIAljYXNlIElPTUFQX01BUFBFRDoKPj4gK2NvdzoK
Pj4gICAJCWlmIChpb21hcC5mbGFncyAmIElPTUFQX0ZfTkVXKSB7Cj4+ICAgCQkJY291bnRfdm1f
ZXZlbnQoUEdNQUpGQVVMVCk7Cj4+ICAgCQkJY291bnRfbWVtY2dfZXZlbnRfbW0odm1hLT52bV9t
bSwgUEdNQUpGQVVMVCk7Cj4+ICAgCQkJbWFqb3IgPSBWTV9GQVVMVF9NQUpPUjsKPj4gICAJCX0K
Pj4gICAJCWVycm9yID0gZGF4X2lvbWFwX2RpcmVjdF9hY2Nlc3MoJmlvbWFwLCBwb3MsIFBBR0Vf
U0laRSwKPj4gLQkJCQkJCU5VTEwsICZwZm4pOwo+PiArCQkJCQkJJmthZGRyLCAmcGZuKTsKPiAK
PiBBbnkgY2hhbmNlIHlvdSBjb3VsZCBsb29rIGludG8gZmFjdG9yaW5nIG91dCB0aGlzIGNvZGUg
aW50byBhIGhlbHBlcgo+IHRvIGF2b2lkIHRoZSBnb3RvIG1hZ2ljLCB3aGljaCBpcyBhIGxpdHRs
ZSB0b28gY29udm9sdXRlZD8KPiAKPj4gICAJc3dpdGNoIChpb21hcC50eXBlKSB7Cj4+ICAgCWNh
c2UgSU9NQVBfTUFQUEVEOgo+PiArY293Ogo+PiAgIAkJZXJyb3IgPSBkYXhfaW9tYXBfZGlyZWN0
X2FjY2VzcygmaW9tYXAsIHBvcywgUE1EX1NJWkUsCj4+IC0JCQkJCQlOVUxMLCAmcGZuKTsKPj4g
KwkJCQkJCSZrYWRkciwgJnBmbik7Cj4+ICAgCQlpZiAoZXJyb3IgPCAwKQo+PiAgIAkJCWdvdG8g
ZmluaXNoX2lvbWFwOwo+PiAgIAo+PiAgIAkJZW50cnkgPSBkYXhfaW5zZXJ0X2VudHJ5KCZ4YXMs
IG1hcHBpbmcsIHZtZiwgZW50cnksIHBmbiwKPj4gICAJCQkJCQlEQVhfUE1ELCB3cml0ZSAmJiAh
c3luYyk7Cj4+ICAgCj4+ICsJCWlmIChzcmNtYXAudHlwZSAhPSBJT01BUF9IT0xFKSB7Cj4gCj4g
U2FtZSBoZXJlLgoKVGhhbmtzIGZvciBzdWdnZXN0aW9uLiAgSSdsbCB0cnkgaXQuCgoKLS0KVGhh
bmtzLApSdWFuIFNoaXlhbmcuCj4gCj4gCgoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBv
c3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2Nm
czItZGV2ZWw=
