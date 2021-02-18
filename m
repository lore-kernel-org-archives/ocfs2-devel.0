Return-Path: <SRS0=7w/S=H4=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645B1C433E0
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 Feb 2021 16:55:36 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 00B7F64E85
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 Feb 2021 16:55:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00B7F64E85
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QGsp07097339;
	Fri, 26 Feb 2021 16:55:35 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 36vr62d0wm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Feb 2021 16:55:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QGoJi2004875;
	Fri, 26 Feb 2021 16:55:34 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36uc6w48se-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 26 Feb 2021 16:55:33 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lFgOq-0000YO-PJ; Fri, 26 Feb 2021 08:55:32 -0800
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <djwong@kernel.org>) id 1lCm2P-00019h-Sw
	for ocfs2-devel@oss.oracle.com; Thu, 18 Feb 2021 08:20:21 -0800
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11IGA8ac127324
	for <ocfs2-devel@oss.oracle.com>; Thu, 18 Feb 2021 16:20:21 GMT
Received: from userp2040.oracle.com (userp2040.oracle.com [156.151.31.90])
	by userp3030.oracle.com with ESMTP id 36prq0p86a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 18 Feb 2021 16:20:21 +0000
Received: from pps.filterd (userp2040.oracle.com [127.0.0.1])
	by userp2040.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11IGE8xq028676
	for <ocfs2-devel@oss.oracle.com>; Thu, 18 Feb 2021 16:20:20 GMT
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by userp2040.oracle.com with ESMTP id 36qrn26nn0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Thu, 18 Feb 2021 16:20:20 +0000
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51A6C61606;
	Thu, 18 Feb 2021 16:20:18 +0000 (UTC)
Date: Thu, 18 Feb 2021 08:20:18 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ruan Shiyang <ruansy.fnst@cn.fujitsu.com>
Message-ID: <20210218162018.GT7193@magnolia>
References: <20210207170924.2933035-1-ruansy.fnst@cn.fujitsu.com>
	<20210207170924.2933035-6-ruansy.fnst@cn.fujitsu.com>
	<20210208151920.GE12872@lst.de>
	<9193e305-22a1-3928-0675-af1cecd28942@cn.fujitsu.com>
	<20210209093438.GA630@lst.de>
	<79b0d65c-95dd-4821-e412-ab27c8cb6942@cn.fujitsu.com>
	<20210210131928.GA30109@lst.de>
	<b00cfda5-464c-6161-77c6-6a25b1cc7a77@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b00cfda5-464c-6161-77c6-6a25b1cc7a77@cn.fujitsu.com>
X-PDR: PASS
X-Source-IP: 198.145.29.99
X-ServerName: mail.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx a:vger.kernel.org
	a:mail.wl.linuxfoundation.org ~all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898
	signatures=668683
X-Proofpoint-Spam-Details: rule=tap_safe policy=tap score=0 classifier=
	adjust=0 reason=safe
	scancount=1 engine=8.12.0-2009150000 definitions=main-2102180140
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-MIME-Autoconverted: from 8bit to quoted-printable by userp3030.oracle.com id
	11IGA8ac127324
X-Mailman-Approved-At: Fri, 26 Feb 2021 08:55:31 -0800
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260124
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1011 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260125

T24gV2VkLCBGZWIgMTcsIDIwMjEgYXQgMTE6MjQ6MThBTSArMDgwMCwgUnVhbiBTaGl5YW5nIHdy
b3RlOgo+IAo+IAo+IE9uIDIwMjEvMi8xMCDkuIvljYg5OjE5LCBDaHJpc3RvcGggSGVsbHdpZyB3
cm90ZToKPiA+IE9uIFR1ZSwgRmViIDA5LCAyMDIxIGF0IDA1OjQ2OjEzUE0gKzA4MDAsIFJ1YW4g
U2hpeWFuZyB3cm90ZToKPiA+ID4gCj4gPiA+IAo+ID4gPiBPbiAyMDIxLzIvOSDkuIvljYg1OjM0
LCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiA+ID4gPiBPbiBUdWUsIEZlYiAwOSwgMjAyMSBh
dCAwNToxNToxM1BNICswODAwLCBSdWFuIFNoaXlhbmcgd3JvdGU6Cj4gPiA+ID4gPiBUaGUgZGF4
IGRlZHVwZSBjb21wYXJpc29uIG5lZWQgdGhlIGlvbWFwX29wcyBwb2ludGVyIGFzIGFyZ3VtZW50
LCBzbyBteQo+ID4gPiA+ID4gdW5kZXJzdGFuZGluZyBpcyB0aGF0IHdlIGRvbid0IG1vZGlmeSB0
aGUgYXJndW1lbnQgbGlzdCBvZgo+ID4gPiA+ID4gZ2VuZXJpY19yZW1hcF9maWxlX3JhbmdlX3By
ZXAoKSwgYnV0IG1vdmUgaXRzIGNvZGUgaW50bwo+ID4gPiA+ID4gX19nZW5lcmljX3JlbWFwX2Zp
bGVfcmFuZ2VfcHJlcCgpIHdob3NlIGFyZ3VtZW50IGxpc3QgY2FuIGJlIG1vZGlmaWVkIHRvCj4g
PiA+ID4gPiBhY2NlcHRzIHRoZSBpb21hcF9vcHMgcG9pbnRlci4gIFRoZW4gaXQgbG9va3MgbGlr
ZSB0aGlzOgo+ID4gPiA+IAo+ID4gPiA+IEknZCBzYXkganVzdCBhZGQgdGhlIGlvbWFwX29wcyBw
b2ludGVyIHRvCj4gPiA+ID4gZ2VuZXJpY19yZW1hcF9maWxlX3JhbmdlX3ByZXAgYW5kIGRvIGF3
YXkgd2l0aCB0aGUgZXh0cmEgd3JhcHBlcnMuICBXZQo+ID4gPiA+IG9ubHkgaGF2ZSB0aHJlZSBj
YWxsZXJzIGFueXdheS4KPiA+ID4gCj4gPiA+IE9LLgo+ID4gCj4gPiBTbyBsb29raW5nIGF0IHRo
aXMgYWdhaW4gSSB0aGluayB5b3VyIHByb3Bvc2FsIGFjdGF1bGx5IGlzIGJldHRlciwKPiA+IGdp
dmVuIHRoYXQgdGhlIGlvbWFwIHZhcmlhbnQgaXMgc3RpbGwgREFYIHNwZWNpZmljLiAgU29ycnkg
Zm9yCj4gPiB0aGUgbm9pc2UuCj4gPiAKPiA+IEFsc28gSSB0aGluayBkYXhfZmlsZV9yYW5nZV9j
b21wYXJlIHNob3VsZCB1c2UgaW9tYXBfYXBwbHkgaW5zdGVhZAo+ID4gb2Ygb3BlbiBjb2Rpbmcg
aXQuCj4gPiAKPiAKPiBUaGVyZSBhcmUgdHdvIGZpbGVzLCB3aGljaCBhcmUgbm90IHJlZmxpbmtl
ZCwgbmVlZCB0byBiZSBkaXJlY3RfYWNjZXNzKCkKPiBoZXJlLiAgVGhlIGlvbWFwX2FwcGx5KCkg
Y2FuIGhhbmRsZSBvbmUgZmlsZSBlYWNoIHRpbWUuICBTbywgaXQgc2VlbXMgdGhhdAo+IGlvbWFw
X2FwcGx5KCkgaXMgbm90IHN1aXRhYmxlIGZvciB0aGlzIGNhc2UuLi4KPiAKPiAKPiBUaGUgcHNl
dWRvIGNvZGUgb2YgdGhpcyBwcm9jZXNzIGlzIGFzIGZvbGxvd3M6Cj4gCj4gICBzcmNsZW4gPSBv
cHMtPmJlZ2luKCZzcmNtYXApCj4gICBkZXN0bGVuID0gb3BzLT5iZWdpbigmZGVzdG1hcCkKPiAK
PiAgIGRpcmVjdF9hY2Nlc3MoJnNyY21hcCwgJnNhZGRyKQo+ICAgZGlyZWN0X2FjY2VzcygmZGVz
dG1hcCwgJmRhZGRyKQo+IAo+ICAgc2FtZSA9IG1lbWNweShzYWRkciwgZGFkZHIsIG1pbihzcmNs
ZW4sZGVzdGxlbikpCj4gCj4gICBvcHMtPmVuZCgmZGVzdG1hcCkKPiAgIG9wcy0+ZW5kKCZzcmNt
YXApCj4gCj4gSSB0aGluayBhIG5lc3RlZCBjYWxsIGxpa2UgdGhpcyBpcyBuZWNlc3NhcnkuICBU
aGF0J3Mgd2h5IEkgdXNlIHRoZSBvcGVuCj4gY29kZSB3YXkuCgpUaGlzIG1pZ2h0IGJlIGEgZ29v
ZCBwbGFjZSB0byBpbXBsZW1lbnQgYW4gaW9tYXBfYXBwbHkyKCkgbG9vcCB0aGF0CmFjdHVhbGx5
IC9kb2VzLyB3YWxrIGFsbCB0aGUgZXh0ZW50cyBvZiBmaWxlMSBhbmQgZmlsZTIuICBUaGVyZSdz
IG5vdwp0d28gdXNlcnMgb2YgdGhpcyBpZGlvbS4KCihQb3NzaWJseSBzdHJ1Y3R1cmVkIGFzIGEg
ImdldCBuZXh0IG1hcHBpbmdzIGZyb20gYm90aCIgZ2VuZXJhdG9yCmZ1bmN0aW9uIGxpa2UgTWF0
dGhldyBXaWxjb3gga2VlcHMgYXNraW5nIGZvci4gOikpCgotLUQKCj4gCj4gLS0KPiBUaGFua3Ms
Cj4gUnVhbiBTaGl5YW5nLgo+ID4gCj4gCj4gCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxA
b3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29j
ZnMyLWRldmVs
