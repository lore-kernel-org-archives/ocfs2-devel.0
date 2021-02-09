Return-Path: <SRS0=s8PX=HL=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8E23C433E6
	for <ocfs2-devel@archiver.kernel.org>; Tue,  9 Feb 2021 01:54:28 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6533C64E66
	for <ocfs2-devel@archiver.kernel.org>; Tue,  9 Feb 2021 01:54:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6533C64E66
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191JZqE015239;
	Tue, 9 Feb 2021 01:54:27 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2130.oracle.com with ESMTP id 36hjhqnyue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Feb 2021 01:54:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191KpxC089692;
	Tue, 9 Feb 2021 01:54:26 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36j4vqn7ng-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 09 Feb 2021 01:54:26 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l9IBQ-0000Ka-3F; Mon, 08 Feb 2021 17:51:16 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ruansy.fnst@cn.fujitsu.com>) id 1l9IBK-0000IL-Ff
	for ocfs2-devel@oss.oracle.com; Mon, 08 Feb 2021 17:51:10 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1191K9xC155573
	for <ocfs2-devel@oss.oracle.com>; Tue, 9 Feb 2021 01:51:10 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3030.oracle.com with ESMTP id 36j4pn231b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Tue, 09 Feb 2021 01:51:10 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	1191Ni14012067
	for <ocfs2-devel@oss.oracle.com>; Tue, 9 Feb 2021 01:51:09 GMT
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by userp2030.oracle.com with ESMTP id 36hh5hbt85-1
	for <ocfs2-devel@oss.oracle.com>; Tue, 09 Feb 2021 01:51:09 +0000
X-IronPort-AV: E=Sophos;i="5.81,163,1610380800"; d="scan'208";a="104350489"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 09 Feb 2021 09:51:05 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id 3C2874CE6F87;
	Tue,  9 Feb 2021 09:51:04 +0800 (CST)
Received: from irides.mr (10.167.225.141) by G08CNEXMBPEKD05.g08.fujitsu.local
	(10.167.33.204) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Tue, 9 Feb 2021 09:51:02 +0800
To: Jan Kara <jack@suse.cz>
References: <20210207170924.2933035-1-ruansy.fnst@cn.fujitsu.com>
	<20210208153911.GE30081@quack2.suse.cz>
From: Ruan Shiyang <ruansy.fnst@cn.fujitsu.com>
Message-ID: <31e9aa48-7830-efe2-837f-e31cba2da491@cn.fujitsu.com>
Date: Tue, 9 Feb 2021 09:50:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210208153911.GE30081@quack2.suse.cz>
Content-Language: en-US
X-Originating-IP: [10.167.225.141]
X-ClientProxiedBy: G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) To
	G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204)
X-yoursite-MailScanner-ID: 3C2874CE6F87.AC9A2
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
X-PDR: PASS
X-Source-IP: 183.91.158.132
X-ServerName: mail.cn.fujitsu.com
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
	malwarescore=0 mlxscore=0
	adultscore=0 spamscore=0 lowpriorityscore=0 priorityscore=108
	suspectscore=0 clxscore=205 bulkscore=0 mlxlogscore=996 impostorscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102090002
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by aserp3030.oracle.com id
	1191K9xC155573
Cc: darrick.wong@oracle.com, linux-nvdimm@lists.01.org, david@fromorbit.com,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 0/7] fsdax,
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090002
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1034 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090002

CgpPbiAyMDIxLzIvOCDkuIvljYgxMTozOSwgSmFuIEthcmEgd3JvdGU6Cj4gT24gTW9uIDA4LTAy
LTIxIDAxOjA5OjE3LCBTaGl5YW5nIFJ1YW4gd3JvdGU6Cj4+IFRoaXMgcGF0Y2hzZXQgaXMgYXR0
ZW1wdCB0byBhZGQgQ29XIHN1cHBvcnQgZm9yIGZzZGF4LCBhbmQgdGFrZSBYRlMsCj4+IHdoaWNo
IGhhcyBib3RoIHJlZmxpbmsgYW5kIGZzZGF4IGZlYXR1cmUsIGFzIGFuIGV4YW1wbGUuCj4+Cj4+
IE9uZSBvZiB0aGUga2V5IG1lY2hhbmlzbSBuZWVkIHRvIGJlIGltcGxlbWVudGVkIGluIGZzZGF4
IGlzIENvVy4gIENvcHkKPj4gdGhlIGRhdGEgZnJvbSBzcmNtYXAgYmVmb3JlIHdlIGFjdHVhbGx5
IHdyaXRlIGRhdGEgdG8gdGhlIGRlc3RhbmNlCj4+IGlvbWFwLiAgQW5kIHdlIGp1c3QgY29weSBy
YW5nZSBpbiB3aGljaCBkYXRhIHdvbid0IGJlIGNoYW5nZWQuCj4+Cj4+IEFub3RoZXIgbWVjaGFu
aXNtIGlzIHJhbmdlIGNvbXBhcmlzb24gLiAgSW4gcGFnZSBjYWNoZSBjYXNlLCByZWFkcGFnZSgp
Cj4+IGlzIHVzZWQgdG8gbG9hZCBkYXRhIG9uIGRpc2sgdG8gcGFnZSBjYWNoZSBpbiBvcmRlciB0
byBiZSBhYmxlIHRvCj4+IGNvbXBhcmUgZGF0YS4gIEluIGZzZGF4IGNhc2UsIHJlYWRwYWdlKCkg
ZG9lcyBub3Qgd29yay4gIFNvLCB3ZSBuZWVkCj4+IGFub3RoZXIgY29tcGFyZSBkYXRhIHdpdGgg
ZGlyZWN0IGFjY2VzcyBzdXBwb3J0Lgo+Pgo+PiBXaXRoIHRoZSB0d28gbWVjaGFuaXNtIGltcGxl
bWVudGVkIGluIGZzZGF4LCB3ZSBhcmUgYWJsZSB0byBtYWtlIHJlZmxpbmsKPj4gYW5kIGZzZGF4
IHdvcmsgdG9nZXRoZXIgaW4gWEZTLgo+Pgo+PiBTb21lIG9mIHRoZSBwYXRjaGVzIGFyZSBwaWNr
ZWQgdXAgZnJvbSBHb2xkd3luJ3MgcGF0Y2hzZXQuICBJIG1hZGUgc29tZQo+PiBjaGFuZ2VzIHRv
IGFkYXB0IHRvIHRoaXMgcGF0Y2hzZXQuCj4gCj4gSG93IGRvIHlvdSBkZWFsIHdpdGggSFdQb2lz
b24gY29kZSB0cnlpbmcgdG8gcmV2ZXJzZS1tYXAgc3RydWN0IHBhZ2UgYmFjawo+IHRvIGlub2Rl
LW9mZnNldCBwYWlyPyBUaGlzIGFsc28gbmVlZHMgdG8gYmUgZml4ZWQgZm9yIHJlZmxpbmsgdG8g
d29yayB3aXRoCj4gREFYLgo+IAoKSSBoYXZlIHBvc3RlZCB2MyBwYXRjaHNldCB0byBhZGQgcmV2
ZXJzZS1tYXAgc3VwcG9ydCBmb3IgZGF4IHBhZ2UgCnllc3RlcmRheS4gIFBsZWFzZSB0YWtlIGEg
bG9vayBhdCB0aGlzOgoKICAgaHR0cHM6Ly9sa21sLm9yZy9sa21sLzIwMjEvMi84LzM0NwoKCi0t
ClRoYW5rcywKUnVhbiBTaGl5YW5nLgoKPiAJCQkJCQkJCUhvbnphCj4gCj4+Cj4+IChSZWJhc2Vk
IG9uIHY1LjEwKQo+PiA9PQo+Pgo+PiBTaGl5YW5nIFJ1YW4gKDcpOgo+PiAgICBmc2RheDogT3V0
cHV0IGFkZHJlc3MgaW4gZGF4X2lvbWFwX3BmbigpIGFuZCByZW5hbWUgaXQKPj4gICAgZnNkYXg6
IEludHJvZHVjZSBkYXhfY29weV9lZGdlcygpIGZvciBDb1cKPj4gICAgZnNkYXg6IENvcHkgZGF0
YSBiZWZvcmUgd3JpdGUKPj4gICAgZnNkYXg6IFJlcGxhY2UgbW1hcCBlbnRyeSBpbiBjYXNlIG9m
IENvVwo+PiAgICBmc2RheDogRGVkdXAgZmlsZSByYW5nZSB0byB1c2UgYSBjb21wYXJlIGZ1bmN0
aW9uCj4+ICAgIGZzL3hmczogSGFuZGxlIENvVyBmb3IgZnNkYXggd3JpdGUoKSBwYXRoCj4+ICAg
IGZzL3hmczogQWRkIGRlZHVwZSBzdXBwb3J0IGZvciBmc2RheAo+Pgo+PiAgIGZzL2J0cmZzL3Jl
ZmxpbmsuYyAgICAgfCAgIDMgKy0KPj4gICBmcy9kYXguYyAgICAgICAgICAgICAgIHwgMTg4ICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tCj4+ICAgZnMvb2NmczIvZmls
ZS5jICAgICAgICB8ICAgMiArLQo+PiAgIGZzL3JlbWFwX3JhbmdlLmMgICAgICAgfCAgMTQgKy0t
Cj4+ICAgZnMveGZzL3hmc19ibWFwX3V0aWwuYyB8ICAgNiArLQo+PiAgIGZzL3hmcy94ZnNfZmls
ZS5jICAgICAgfCAgMzAgKysrKysrLQo+PiAgIGZzL3hmcy94ZnNfaW5vZGUuYyAgICAgfCAgIDgg
Ky0KPj4gICBmcy94ZnMveGZzX2lub2RlLmggICAgIHwgICAxICsKPj4gICBmcy94ZnMveGZzX2lv
bWFwLmMgICAgIHwgICAzICstCj4+ICAgZnMveGZzL3hmc19pb3BzLmMgICAgICB8ICAxMSArKy0K
Pj4gICBmcy94ZnMveGZzX3JlZmxpbmsuYyAgIHwgIDIzICsrKystCj4+ICAgaW5jbHVkZS9saW51
eC9kYXguaCAgICB8ICAgNSArKwo+PiAgIGluY2x1ZGUvbGludXgvZnMuaCAgICAgfCAgIDkgKy0K
Pj4gICAxMyBmaWxlcyBjaGFuZ2VkLCAyNzAgaW5zZXJ0aW9ucygrKSwgMzMgZGVsZXRpb25zKC0p
Cj4+Cj4+IC0tIAo+PiAyLjMwLjAKPj4KPj4KPj4KCgoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRl
dmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5m
by9vY2ZzMi1kZXZlbA==
