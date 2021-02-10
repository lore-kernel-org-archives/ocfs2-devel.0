Return-Path: <SRS0=lwyH=HM=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5164EC433DB
	for <ocfs2-devel@archiver.kernel.org>; Wed, 10 Feb 2021 13:26:25 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C338B64E16
	for <ocfs2-devel@archiver.kernel.org>; Wed, 10 Feb 2021 13:26:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C338B64E16
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ADPNMT021521;
	Wed, 10 Feb 2021 13:26:22 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 36m4upsum4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Feb 2021 13:26:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ADP3sL167799;
	Wed, 10 Feb 2021 13:26:22 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 36j51xjhb1-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 10 Feb 2021 13:26:21 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l9pPW-0005gO-VR; Wed, 10 Feb 2021 05:20:02 -0800
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63) (envelope-from <hch@lst.de>)
	id 1l9pP4-0005aF-8l
	for ocfs2-devel@oss.oracle.com; Wed, 10 Feb 2021 05:19:34 -0800
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11ADFRR7175052
	for <ocfs2-devel@oss.oracle.com>; Wed, 10 Feb 2021 13:19:34 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by aserp3020.oracle.com with ESMTP id 36j512mx9g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 10 Feb 2021 13:19:34 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11ADDcWI030905
	for <ocfs2-devel@oss.oracle.com>; Wed, 10 Feb 2021 13:19:33 GMT
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by userp2030.oracle.com with ESMTP id 36hh5j9x5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Wed, 10 Feb 2021 13:19:33 +0000
Received: by verein.lst.de (Postfix, from userid 2407)
	id E84686736F; Wed, 10 Feb 2021 14:19:28 +0100 (CET)
Date: Wed, 10 Feb 2021 14:19:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ruan Shiyang <ruansy.fnst@cn.fujitsu.com>
Message-ID: <20210210131928.GA30109@lst.de>
References: <20210207170924.2933035-1-ruansy.fnst@cn.fujitsu.com>
	<20210207170924.2933035-6-ruansy.fnst@cn.fujitsu.com>
	<20210208151920.GE12872@lst.de>
	<9193e305-22a1-3928-0675-af1cecd28942@cn.fujitsu.com>
	<20210209093438.GA630@lst.de>
	<79b0d65c-95dd-4821-e412-ab27c8cb6942@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <79b0d65c-95dd-4821-e412-ab27c8cb6942@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-PDR: PASS
X-Source-IP: 213.95.11.211
X-ServerName: verein.lst.de
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
	malwarescore=0 mlxscore=0
	adultscore=0 spamscore=0 lowpriorityscore=0 priorityscore=0
	suspectscore=0
	clxscore=280 bulkscore=0 mlxlogscore=726 impostorscore=0
	classifier=spam
	adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
	definitions=main-2102100127
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to quoted-printable by aserp3020.oracle.com id
	11ADFRR7175052
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, darrick.wong@oracle.com,
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100129
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1034
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100129

T24gVHVlLCBGZWIgMDksIDIwMjEgYXQgMDU6NDY6MTNQTSArMDgwMCwgUnVhbiBTaGl5YW5nIHdy
b3RlOgo+Cj4KPiBPbiAyMDIxLzIvOSDkuIvljYg1OjM0LCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToKPj4gT24gVHVlLCBGZWIgMDksIDIwMjEgYXQgMDU6MTU6MTNQTSArMDgwMCwgUnVhbiBTaGl5
YW5nIHdyb3RlOgo+Pj4gVGhlIGRheCBkZWR1cGUgY29tcGFyaXNvbiBuZWVkIHRoZSBpb21hcF9v
cHMgcG9pbnRlciBhcyBhcmd1bWVudCwgc28gbXkKPj4+IHVuZGVyc3RhbmRpbmcgaXMgdGhhdCB3
ZSBkb24ndCBtb2RpZnkgdGhlIGFyZ3VtZW50IGxpc3Qgb2YKPj4+IGdlbmVyaWNfcmVtYXBfZmls
ZV9yYW5nZV9wcmVwKCksIGJ1dCBtb3ZlIGl0cyBjb2RlIGludG8KPj4+IF9fZ2VuZXJpY19yZW1h
cF9maWxlX3JhbmdlX3ByZXAoKSB3aG9zZSBhcmd1bWVudCBsaXN0IGNhbiBiZSBtb2RpZmllZCB0
bwo+Pj4gYWNjZXB0cyB0aGUgaW9tYXBfb3BzIHBvaW50ZXIuICBUaGVuIGl0IGxvb2tzIGxpa2Ug
dGhpczoKPj4KPj4gSSdkIHNheSBqdXN0IGFkZCB0aGUgaW9tYXBfb3BzIHBvaW50ZXIgdG8KPj4g
Z2VuZXJpY19yZW1hcF9maWxlX3JhbmdlX3ByZXAgYW5kIGRvIGF3YXkgd2l0aCB0aGUgZXh0cmEg
d3JhcHBlcnMuICBXZQo+PiBvbmx5IGhhdmUgdGhyZWUgY2FsbGVycyBhbnl3YXkuCj4KPiBPSy4K
ClNvIGxvb2tpbmcgYXQgdGhpcyBhZ2FpbiBJIHRoaW5rIHlvdXIgcHJvcG9zYWwgYWN0YXVsbHkg
aXMgYmV0dGVyLApnaXZlbiB0aGF0IHRoZSBpb21hcCB2YXJpYW50IGlzIHN0aWxsIERBWCBzcGVj
aWZpYy4gIFNvcnJ5IGZvcgp0aGUgbm9pc2UuCgpBbHNvIEkgdGhpbmsgZGF4X2ZpbGVfcmFuZ2Vf
Y29tcGFyZSBzaG91bGQgdXNlIGlvbWFwX2FwcGx5IGluc3RlYWQKb2Ygb3BlbiBjb2RpbmcgaXQu
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1k
ZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mu
b3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
