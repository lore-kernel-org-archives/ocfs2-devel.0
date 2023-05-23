Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D565C77B75
	for <ocfs2-devel@archiver.kernel.org>; Tue, 23 May 2023 02:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=H5bZ+n18IpBXUsnKoFs8tXG/woekJZKfFwqSm3rSd6A=;
 b=rgY9uFrEtXM9CGrPYryNOIESBTCTYmHJKLGuZMxB4mK6l0+pjCidgygXlzx8Io2p//PNsMb3qc1w
   77yOASZINlpaQqsU8qzN+/0nKpa21ZVw4ZX2hAhBaZGOSCEu/J9xNRNNcHq2wAFkWqTtQOjU1JQi
   qho5WiPDbD5o9aGdrRq0MiarYG9xAGK6jEPniLpkuSTGz1EeKPdcJEp93Rj8XuKtXfwhFPz5oTbZ
   vhc84Qx9+cjqZ7vY2VGP4wQItmxtJP99DW37bJqGtcXGxRr0CeIEkYeYltYTR0oa7y7DGFCr4SiC
   /rvAgcXZiaxTtCSCl/LtqBjibMdL4z3hxn3o5w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=H5bZ+n18IpBXUsnKoFs8tXG/woekJZKfFwqSm3rSd6A=;
 b=OTU1uhgmrhx3wFa4ETv7vJFrsILN1DdB30vq7aSUNPTRey/rWKZMsFDxnWbY4fYrAfsy9YGmg5Yd
   fkRCz4t+utkEL37Vr2TepmDn29BPzH6PRqK65QPTcBqpTTyjSmje9YRv8qodnTJvM26zUOtEpOnc
   +pM30HK1e+qvFmSfsvkb/FwCPX1PghdmcfQrV2hOLmpBoaoQ467PO3H82Q28y42q0cP0AwslqsvH
   9BssotyuRYfuw8P90l6TxI1uWF3gYoXh4bZSwnSG47mu+prlfPwXuYOYaFieNgn80ioYQ7CT5P2w
   CkzVwxGGMQAJA6+YKUXV/c2j21Ud1Nb1nIlAvA==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RV300MFCBHXTXB0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 23 May 2023 02:41:57 +0000 (GMT)
Message-id: <846d9e88-2b66-1941-a791-6b3e286bdb66@linux.alibaba.com>
Date: Tue, 23 May 2023 10:41:33 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Content-language: en-US
To: =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
References: <20230522102506.9205-1-lhenriques@suse.de>
 <a57047d6-8f57-3dde-f15f-b24f63d675cd@linux.alibaba.com>
 <87h6s47dxw.fsf@brahms.olymp>
In-reply-to: <87h6s47dxw.fsf@brahms.olymp>
X-Source-IP: 115.124.30.101
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10718
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 bulkscore=0 spamscore=0 clxscore=140 malwarescore=0 phishscore=0
 priorityscore=70 impostorscore=0 mlxlogscore=991 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305230020 domainage_hfrom=8804
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix use-after-free when unmounting
 read-only filesystem
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
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046049;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
 TI=SMTPD_---0VjI7qTY_1684809693;
X-ServerName: out30-101.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: va0T-O_YdnMgHUv5nYCyb8qjS1SlZuT9
X-Proofpoint-GUID: va0T-O_YdnMgHUv5nYCyb8qjS1SlZuT9
Reporting-Meta:
 AAFTl6ZeylrmwFgwfSYJle2+jGUnZ19dzlUZ/VzPFgB74rvwJ0asR/u/Xb1zIbPQ
 wE+YREv9P+R5yBjWGtQFRCzQoDi6gXFA5zpq9iCupfPOZ/r1NRhoO7EjTGGResGo
 fRllQRePUEUkz0cF93O0cwp5aTULWKh37qujjJOdD9Q6Zw7q1+O0jOiwi50lMvxU
 c8rhjC7Z86eLvL418h1gY0yfky0dLEGlmYuEqfbQlY69jg/FM1ZKbCoEbTn6rKw8
 xW1G4qLFMzCUpRa1PtfBhcin8HxSSn+Uao5BDqhH9Ylydv1mLOGTgvGyoCzcJgka
 LN+TOgoKappHypajMYPFLgo84gTrCnTXz+WmwnGdZP3A297C1Up+8wYw6al/kqVd
 pziXvJKNeJn8jxOS7QodXYiBf64pE8VNJBEHCCEHHmVN5QrBRcjV2Hb9HiJTOxA8
 qZ31jINzSXYIOt9y32JFzbIuPF/pqzv6ka0zieSEPPSCOISehRPwUxS0g+5c5L60
 84B0Ypb4ll0fk4H/EPyFNaM5MBi0BRGDH0Na0/9elLau2Q==

CgpPbiA1LzIyLzIzIDg6MjMgUE0sIEx1w61zIEhlbnJpcXVlcyB3cm90ZToKPiBKb3NlcGggUWkg
PGpvc2VwaC5xaUBsaW51eC5hbGliYWJhLmNvbT4gd3JpdGVzOgo+IAo+PiBPbiA1LzIyLzIzIDY6
MjUgUE0sIEx1w61zIEhlbnJpcXVlcyB3cm90ZToKPj4+IEl0J3MgdHJpdmlhbCB0byB0cmlnZ2Vy
IGEgdXNlLWFmdGVyLWZyZWUgYnVnIGluIHRoZSBvY2ZzMiBxdW90YXMgY29kZSB1c2luZwo+Pj4g
ZnN0ZXN0IGdlbmVyaWMvNDUyLiAgQWZ0ZXIgbW91bnRpbmcgYSBmaWxlc3lzdGVtIGFzIHJlYWQt
b25seSwgcXVvdGFzIGFyZQo+Pgo+PiBnZW5lcmljLzQ1MiBpcyBmb3IgdGVzdGluZyBleHQ0IG1v
dW50ZWQgd2l0aCBkYXggYW5kIHJvLgo+PiBCdXQgb2NmczIgZG9lc24ndCBzdXBwb3J0IGRheCB5
ZXQuCj4gCj4gUmlnaHQsIGJ1dCBJIHRoaW5rIGl0J3Mgc3RpbGwgdXNlZnVsIHRvIHJ1biB0aGUg
J2dlbmVyaWMnIHRlc3Qtc3VpdGUgaW4gYQo+IGZpbGVzeXN0ZW0uICBXZSBjYW4gYWx3YXlzIGZp
bmQgaXNzdWVzIGluIHRoZSB0ZXN0IGl0c2VsZiBvciwgaW4gdGhpcwo+IGNhc2UsIGEgYnVnIGlu
IHRoZSBmaWxlc3lzdGVtLgo+IAo+Pj4gc3VzcGVuZGVkIGFuZCBvY2ZzMl9tZW1fZHFpbmZvIGlz
IGZyZWVkIHRocm91Z2ggLT5vY2ZzMl9sb2NhbF9mcmVlX2luZm8oKS4gIFdoZW4KPj4+IHVubW91
bnRpbmcgdGhlIGZpbGVzeXN0ZW0sIGFuIFVBRiBhY2Nlc3MgdG8gdGhlIG9pbmZvIHdpbGwgZXZl
bnR1YWxseSBjYXVzZSBhCj4+PiBjcmFzaC4KPj4KPj4gSW4gb2NmczJfZmlsbF9zdXBlcigpLCBp
dCB3b24ndCBlbmFibGUgcXVvdGEgaWYgaXMgYSByZWFkb25seSBtb3VudC4KPj4gRG8geW91IG1l
YW4gcmVtb3VudCBhcyByZWFkb25seT8KPiAKPiBZZXMsIHNvcnJ5LiBJbnN0ZWFkIG9mICJtb3Vu
dGluZyIsIHRoZSBwYXRjaCBjaGFuZ2Vsb2cgc2hvdWxkIHNheQo+IAo+ICAgIkFmdGVyIHJlbW91
bnRpbmcgYSBmaWxlc3lzdGVtIGFzIHJlYWQtb25seS4uLiIKPiAKPiBDaGVlcnMsCgpPa2F5LCBs
b29rIGludG8gdGhlIGNvZGUgZmxvdywgaXQgZG9lcyBoYXZlIHByb2JsZW0gd2hlbiByZW1vdW50
IHdpdGgKcmVhZC1vbmx5LgpCVFcsIGl0IHNlZW1zIHRoYXQgd2UgY2FuJ3QgY2FsbCBpbnRvIHF1
b3RhX2Rpc2FibGUoKSBhZ2Fpbiwgd2hpY2ggd2lsbApjYWxsIGZyZWVfZmlsZV9pbmZvKCkuCgpU
aGFua3MsCkpvc2VwaAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29t
Cmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
