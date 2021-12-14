Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FD87C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue, 14 Dec 2021 07:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=aDTNOmFWE3iTe2qR6j3Py1mQkmdzLbVHJ0qSzMALlFs=;
 b=gF0nBpQ2NRVHW4XOSAYS6+l3QiJzHelpB7/p+kNf7m1wtMYRkmXorCENU40CLbe/JLzDGqZ1UI/Q
   OtGu024X4+t0EK+mTEuVC1dR7a3hmk60cmI+guAYZ33psrTOhvlGIwU/8lHjL5gDxXBmXofuASMj
   AtsrbUPq4bijG4oyWrHISOLZBSU3gAFlTd+k7P/Ge1R2OJj5Hstprwb4m47sFLtwYeYFr0p2WJcL
   bc1jmY2nk2ajxaahFrlDnNxeJY67pW+5cFd1CtVuYgoCNPFeoX6wDWk0ccWkUxi2kHNESx1qxoN2
   4+F/4fZlpnepVuhEBJaxxEkgBb87f48F80eIQw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=aDTNOmFWE3iTe2qR6j3Py1mQkmdzLbVHJ0qSzMALlFs=;
 b=bLm7Wxc6C9+TG0PxACe1PMUo/s7ra8/njmWa5LOkoDIa4f3NwzV3pI1SuqYd5Z6JrzZpnmB7KSyC
   x+2hpLh6kzs8pZ1WzFh87oMK7tDrcv4wCVB+47YL9d7ubv0IR2sjty24p7swQH6XZaT4nKj44LzQ
   iQy7IvLhB1iDEhbii07lw0yXeqrDVFnCAsBIklex9VWhnyxUvdmWO/MaT3qD84b69QPwcJdnyJJi
   GHNJsOjzR2j+KVWi0J7chCrWYDwh2trdjdaDIeyTnFmExl90+99LKDjtzfusTXVne1ZaFqQz2sVe
   3Q17zGG7lVKsIFFD12iPRmXadW9pqxqzOPyfjg==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20211202 64bit (built Dec  2
 2021))
 with ESMTP id <0R43000XFFUYYH20@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 14 Dec 2021 07:08:58 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <bd6dfb63-6d3d-c8f6-f401-8bdd5334afed@linux.alibaba.com>
Date: Tue, 14 Dec 2021 15:08:39 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Content-language: en-US
To: Jia-Ju Bai <baijiaju1990@gmail.com>, mark@fasheh.com, jlbec@evilplan.org
References: <8ae1bb9c-3e58-c8b6-8823-3d2ea8b241e2@gmail.com>
In-reply-to: <8ae1bb9c-3e58-c8b6-8823-3d2ea8b241e2@gmail.com>
X-Source-IP: 115.124.30.54
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 clxscore=163 phishscore=0
 bulkscore=0 priorityscore=60 impostorscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140040 domainage_hfrom=8279
Cc: linux-kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [BUG] fs: ocfs2: possible ABBA deadlock in
 ocfs2_dio_end_io_write() and ocfs2_move_extents()
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R201e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
 TI=SMTPD_---0V-bWsut_1639465719;
X-ServerName: out30-54.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: BD4IDh7bJN-IlcwDaHOGHSw_xoq9fzRo
X-Proofpoint-ORIG-GUID: BD4IDh7bJN-IlcwDaHOGHSw_xoq9fzRo
Reporting-Meta:
 AAHVOuYghjmEeFcoN7rag/bx4qW/B2EULyCdg/Rev3GXDcoeb/VjNlt28verxUXN
 DYHE27yn7ySWGea8ZslGFitZDD6W6JQumK5zkJ5vFvKHlnNS0XqQciPA7efIbT3l
 2HVkjA6ww34JMUpTMeirPQ4hU+79WwBWXmIBwFTbB5Xn45a8g2GfgCIpnTx+vYOb
 VauJVAoT05vOYfXFvneH0gmvh9tRQuNxAEU8Z/OhLKgJDLzoKTQAoF7+zgJ+Rm5N
 1wXmdCR/1I9dE9Tsl72AAHdRyY1mPvoRxdB/93P4Yy0pAOG5JHaOP0U6iqdUJxyP
 XccerePgfxJIHwyvBH0I0S2YEpXbkhEFGwTfVSQStBn+52X1v6o6P8obYRt7ZDXO
 Op/Yl17QSHbAwTpJc/zTU9PbTK/rCtyvhYRcdhnMIw9Wch/NIUtGccMLLu2gTISb
 kgCJW1ITwJAURb9uYNF9lJedutLrQF8F8r/sx5cgnL6PrAsV97P64NHmoHojXrD3
 6zDRu5IRp3rXRbWzPMlBQ0e2AXC4YNfs2ofYw+dKoxQ=

SGksCgpUaGFua3MgZm9yIHRoZSByZXBvcnQuIEJ1dCBJIGRvbid0IHRoaW5rIHRoaXMgaXMgYSBw
b3NzaWJsZSBkZWFkbG9jayBpbgpwcmFjdGljZS4gUGxlYXNlIHNlZSBteSBjb21tZW50cyBiZWxv
dy4KCk9uIDEyLzEwLzIxIDQ6MzggUE0sIEppYS1KdSBCYWkgd3JvdGU6Cj4gSGVsbG8sCj4gCj4g
TXkgc3RhdGljIGFuYWx5c2lzIHRvb2wgcmVwb3J0cyBhIHBvc3NpYmxlIEFCQkEgZGVhZGxvY2sg
aW4gdGhlIG9jZnMyIG1vZHVsZSBpbiBMaW51eCA1LjEwOgo+IAo+IG9jZnMyX2Rpb19lbmRfaW9f
d3JpdGUoKQo+IMKgIGRvd25fd3JpdGUoJm9pLT5pcF9hbGxvY19zZW0pOyAtLT4gTGluZSAyMzIy
IChMb2NrIEEpCj4gwqAgb2NmczJfZGVsX2lub2RlX2Zyb21fb3JwaGFuKCkKPiDCoMKgwqAgaW5v
ZGVfbG9jayhvcnBoYW5fZGlyX2lub2RlKTvCoCAtLT4gTGluZSAyNzAxIChMb2NrIEIpCgpKdXN0
IGFzIHRoZSB2YXJpYWJsZSBuYW1lIGluZGljYXRlcywgaXQgaXMgb3JwaGFuIGRpciBpbm9kZSwg
d2hpY2ggaXMgYQpzeXN0ZW0gZmlsZSAoc29tZXRoaW5nIGhpZGRlbiBpbnNpZGUgdGhlIGZpbGVz
eXN0ZW0pIGFuZCBub3QgdmlzaWJsZSBmb3IKZW5kIHVzZXIuCgo+IAo+IG9jZnMyX21vdmVfZXh0
ZW50cygpCj4gwqAgaW5vZGVfbG9jayhpbm9kZSk7IC0tPiBMaW5lIDkxNiAoTG9jayBCKQoKVGhp
cyBpcyBjYWxsZWQgZnJvbSBhIGlvY3RsIGZyb20gdXNlciwgaXQgYSBub3JtYWwgZmlsZSBpbm9k
ZS4KClRoYW5rcywKSm9zZXBoCgo+IMKgIGRvd25fd3JpdGUoJk9DRlMyX0koaW5vZGUpLT5pcF9h
bGxvY19zZW0pOyAtLT4gTGluZSA5MzYgKExvY2sgQSkKPiAKPiBXaGVuIG9jZnMyX2Rpb19lbmRf
aW9fd3JpdGUoKSBhbmQgb2NmczJfbW92ZV9leHRlbnRzKCkgYXJlIGNvbmN1cnJlbnRseSBleGVj
dXRlZCwgdGhlIGRlYWRsb2NrcyBjYW4gb2NjdXIuCj4gCj4gSSBhbSBub3QgcXVpdGUgc3VyZSB3
aGV0aGVyIHRoaXMgcG9zc2libGUgZGVhZGxvY2sgaXMgcmVhbCBhbmQgaG93IHRvIGZpeCBpdCBp
ZiBpdCBpcyByZWFsLgo+IEFueSBmZWVkYmFjayB3b3VsZCBiZSBhcHByZWNpYXRlZCwgdGhhbmtz
IDopCj4gCj4gUmVwb3J0ZWQtYnk6IFRPVEUgUm9ib3QgPG9zbGFiQHRzaW5naHVhLmVkdS5jbj4K
PiAKPiAKPiBCZXN0IHdpc2hlcywKPiBKaWEtSnUgQmFpCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczIt
ZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL29jZnMyLWRldmVs
