Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C7CEC4321E
	for <ocfs2-devel@archiver.kernel.org>; Sun, 27 Nov 2022 12:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=DgCwIBCcN05IrJK5PMmGBKa8U5rFJYoKD4QRxjC4dJQ=;
 b=PY8ztQ1r6PGwBtVw5Qom4A2pCGzvxTp+BTlF2wfiNHv7GJbqgCAh6ZKJGTk12OpGns3ici4dWM8C
   7lOU5OL08HfNk+KgKxMscydWd1f6PCkDnLUwwJ0jOdW2VWh14j7Nvo4hPVZN1ZKFFmpVxj85+Qgr
   7jl7WzlZQvM7SbWV6mqiBLA6shMWIXJWcOvMR59F9KYebZwSrs1c7mHWxZRQLmYphhm+MN7gE8qg
   jJyqrCJRgH4hhnAdA7bdy8TEFeU69EnnE2UThifLfjsX5uV6E/4c+6gMRyY68fCV5p3vTCtFuui6
   PuPQC/2gudSpo1asTdLFEphrfwnf5QO4VVci5g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=DgCwIBCcN05IrJK5PMmGBKa8U5rFJYoKD4QRxjC4dJQ=;
 b=VEDwBAWVwMt8cpoo1TbMb/fwZUgCSbou0gZxpHKvIR47yywa+mz5R7E6vlCY7Z6VWFH+KyDYh7DV
   DiIbB5MwfMZo9aRKsm886R+wFMf0BjW34BZFMApqxUrh91iGOeT7VbucWGArsSOuNN8kJHJEQRv5
   xsCQe3NgttJ8v8dX/n1lIZMIVrVL14ADuaTwwSgEAiuZpA07cbzEm4mwXDQbkhhsG844aCO0M8Wi
   wV8HLir4OvAQaXNHSP5fN/c1vJMK8yMSjbiatnCr9WGZpKeXwf5awUigSQCXaHOwAxbTwW+Ov1La
   bwkq28hUSik9gPFF7l7J/Xq3P7NMvVMWVWq/Pg==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RM0003J9C181XA0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 27 Nov 2022 12:58:20 +0000 (GMT)
Message-id: <7c1d7089-dc35-719c-b9cf-b0092e984cfc@linux.alibaba.com>
Date: Sun, 27 Nov 2022 20:57:55 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Content-language: en-US
To: "Alexey Asemov (Alex/AT)" <alex@alex-at.net>, ocfs2-devel@oss.oracle.com,
 akpm <akpm@linux-foundation.org>
References: <cbfca02b-b39f-89de-e1a8-904a6c60407e@alex-at.net>
In-reply-to: <cbfca02b-b39f-89de-e1a8-904a6c60407e@alex-at.net>
X-Source-IP: 115.124.30.132
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10543
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 unknownsenderscore=20 malwarescore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 clxscore=13 adultscore=0
 priorityscore=100 phishscore=0 spamscore=0 suspectscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211270108 domainage_hfrom=8627
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: always read both high and low parts
 of dinode link count
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R661e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045176;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VVlg-a3_1669553875;
X-ServerName: out30-132.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 3Fv0cARMQcXSpy66z3o6TBdU9EiUgE2L
X-Proofpoint-GUID: 3Fv0cARMQcXSpy66z3o6TBdU9EiUgE2L
Reporting-Meta:
 AAH29yIBDNtnhwpPQADKSMK0mUeTSWwPYYqYX9gJ65ZSGxxahjyNY5BWvwp5SSlH
 PemlQ4r382HoEqD9wlcQNn7eQsJ8GvWv96kFA1ILbFubutT4s8VLQxUHJVlZB6bP
 +hOFzVA75HYzVf9GS3XXYXcsYmiPUK/Z6La/DpQrVVd2WCNfQOGT3SA8UcKymqkB
 QwiiGYEQDohwCo07VkbYGY0H6R8rgQYZIhtO/+1Hc+K/bKuIV0rGy/l+rt4MFSLW
 43YKJ48w0HcMdMrbyt1qsMwkRO9Hf4K1zfdC9/5i2Gpj4faL7HH5k/lxodmd3D/Q
 CD96e64tM7VLq9HnRE6aSNrXhl+Ch3VYufbmVvdZKbQ1xkp/wY5Q89zP3l6h7kWv
 mUTLvwFx+tZi3dKbzFYMi/RhfB5NWlfDCiZQvGfZULyO5z9VjWceIIKTYvyyGb1E
 KCcnAFPjDKxIv53qeRUoTzP9WzWe+9OF688Cm5cAz6KchKl9uU9t8od4qeiIfkpT
 95MYGaS/oakiGurPCWwH4E5cJ9jyNVxGNlUgJYE/a+g2dA==

CgpPbiAxMS8yNy8yMiAyOjQ2IFBNLCBBbGV4ZXkgQXNlbW92IChBbGV4L0FUKSB3cm90ZToKPiBX
aGVuIGZpbGVzeXN0ZW0gaXMgdXNpbmcgaW5kZXhlZC1kaXJzIGZlYXR1cmUsIG1heGltdW0gbGlu
ayBjb3VudCB2YWx1ZXMKPiBjYW4gc3BpbGwgb3ZlciB0byBpX2xpbmtzX2NvdW50X2hpLCB1cCB0
byBPQ0ZTMl9EWF9MSU5LX01BWCBsaW5rcy4KPiBvY2ZzMl9yZWFkX2xpbmtzX2NvdW50KCkgY2hl
Y2tzIGZvciBPQ0ZTMl9JTkRFWEVEX0RJUl9GTCBmbGFnIGluIGRpbm9kZSwKPiBidXQgdGhpcyBm
bGFnIGlzIG9ubHkgdmFsaWQgZm9yIGRpcmVjdG9yaWVzIHNvIGZvciBmaWxlcyB0aGUgY2hlY2sK
PiBjYXVzZXMgaGlnaCBwYXJ0IG9mIHRoZSBsaW5rIGNvdW50IG5vdCBiZWluZyByZWFkIGJhY2sg
ZnJvbSBmaWxlCj4gZGlub2RlcyByZXN1bHRpbmcgaW4gd3JvbmcgbGluayBjb3VudCB2YWx1ZSB3
aGVuIGZpbGUgaGFzID42NTUzNSBsaW5rcy4KPiAKPiBBcyBvY2ZzMl9zZXRfbGlua3NfY291bnQo
KSBhbHdheXMgd3JpdGVzIGJvdGggaGlnaCBhbmQgbG93IHBhcnRzIG9mIGxpbmsKPiBjb3VudCwg
dGhlIGZsYWcgY2hlY2sgb24gcmVhZGluZyBtYXkgYmUgcmVtb3ZlZC4KPiAKPiBTaWduZWQtb2Zm
LWJ5OiBBbGV4ZXkgQXNlbW92IDxhbGV4QGFsZXgtYXQubmV0PgoKUmV2aWV3ZWQtYnk6IEpvc2Vw
aCBRaSA8am9zZXBoLnFpQGxpbnV4LmFsaWJhYmEuY29tPgo+IC0tLQo+IAo+IMKgZnMvb2NmczIv
b2NmczIuaCB8IDMgKy0tCj4gwqAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVs
ZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2ZzL29jZnMyL29jZnMyLmggYi9mcy9vY2ZzMi9v
Y2ZzMi5oCj4gaW5kZXggNzQwYjY0MjM4MzEyLi5hNTAzYzU1M2JhYjIgMTAwNjQ0Cj4gLS0tIGEv
ZnMvb2NmczIvb2NmczIuaAo+ICsrKyBiL2ZzL29jZnMyL29jZnMyLmgKPiBAQCAtNTYwLDggKzU2
MCw3IEBAIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50IG9jZnMyX3JlYWRfbGlua3NfY291bnQo
c3RydWN0IG9jZnMyX2Rpbm9kZSAqZGkpCj4gwqDCoMKgwqDCoMKgwqAgdTMyIG5saW5rID0gbGUx
Nl90b19jcHUoZGktPmlfbGlua3NfY291bnQpOwo+IMKgwqDCoMKgwqDCoMKgIHUzMiBoaSA9IGxl
MTZfdG9fY3B1KGRpLT5pX2xpbmtzX2NvdW50X2hpKTsKPiAKPiAtwqDCoMKgwqDCoMKgIGlmIChk
aS0+aV9keW5fZmVhdHVyZXMgJiBjcHVfdG9fbGUxNihPQ0ZTMl9JTkRFWEVEX0RJUl9GTCkpCj4g
LcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbmxpbmsgfD0gKGhpIDw8IE9DRlMyX0xJTktT
X0hJX1NISUZUKTsKPiArwqDCoMKgwqDCoMKgIG5saW5rIHw9IChoaSA8PCBPQ0ZTMl9MSU5LU19I
SV9TSElGVCk7Cj4gCj4gwqDCoMKgwqDCoMKgwqAgcmV0dXJuIG5saW5rOwo+IMKgfQoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFp
bGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5j
b20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
