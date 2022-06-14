Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62577C43334
	for <ocfs2-devel@archiver.kernel.org>; Tue, 14 Jun 2022 03:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=STUoJvcxgzsha8c38EcESdMZcyc4mmgqu6I5L0qkLik=;
 b=PxxgJCWk+7ZYIZArar5CMWWyWIOyD6zpf1SuHojmP7dPlFUzMFZ+DGSSqflRPLUbp/nT2Oek1rQr
   nOSWZQ3sEZdMk4Q0eInjRaTkwr0VZzPfu3lKeV7rmWHGxMY3WUO8fxd2sMLXvxF2L4lAq88dM/Lt
   P7yYXVDxVPASg4olqfJgFZx5wkNUep68GsSfuavdax0d8qST4dfGLf3z5wZpWhDrP9R1R9s3Alwu
   n2wo8hUKFdJNuRHQQ5bT11kmUfpsVphA9MzxCilTjS3BX6ImAHaqJqJP2TbdkFdVsrETCYJG3aDR
   +s5PvpuFzNC04hcwFMlJig1Ko3MO3NFiC4n3dQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=STUoJvcxgzsha8c38EcESdMZcyc4mmgqu6I5L0qkLik=;
 b=WVH4gn045oVbQyil6qQkfzOLNmaMUZLVSN32FW4zJItaxYt8tNKRmFbs59kUVd69McvgEsU/dMPN
   +SPDz4YrUCOSYg1Oyiuk4bzniacPuE8067J+jCSdBLKlb4O9Q5GdxT4SsQkPz4vOwXdqFzuVJ6OS
   ZHBh93B5uCpDGEq4K6DayXZJjCDJ5+vWCJGso7ec1CP5cRJVt+aRIkd6uyh0mErNI45QNSn5oXsK
   Jr97YqoHxUlBMC5TzAkGkT+eZvrw6lP1h0aTFI5Gxj+H6VUq956++77aVe9J7gAeRFu/rqfUh/V8
   kHwqOoet7D+4AQ0wSDOmQY+5ux4+ivU3Pyp9gg==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220531 64bit (built May 31
 2022))
 with ESMTPS id <0RDG00PFW6XW05C0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 14 Jun 2022 03:27:32 +0000 (GMT)
Message-id: <ea848935-abf6-90d6-9313-852cf8344852@linux.alibaba.com>
Date: Tue, 14 Jun 2022 11:27:08 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Content-language: en-US
To: "heming.zhao@suse.com" <heming.zhao@suse.com>,
 Junxiao Bi <junxiao.bi@oracle.com>
References: <20220608104808.18130-1-heming.zhao@suse.com>
 <20220608104808.18130-2-heming.zhao@suse.com>
 <09b33ef3-b93a-5b50-d87d-8667ed993e5d@linux.alibaba.com>
 <faee689f-7a04-2042-636c-80fb48bc30ed@suse.com>
 <8dd30c4e-d572-bfd0-f261-b9cfcd8b5b4d@linux.alibaba.com>
 <28b5b33b-1942-b128-d3f0-5e3592338dad@suse.com>
 <FFE0CF5B-76C7-49E0-B9AC-02C7FC21BADD@oracle.com>
 <8b01df99-4690-92a6-c37b-5226a9222d51@suse.com>
In-reply-to: <8b01df99-4690-92a6-c37b-5226a9222d51@suse.com>
X-Source-IP: 115.124.30.132
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10377
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 suspectscore=0 bulkscore=0 clxscore=235 priorityscore=85 mlxscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206140012 domainage_hfrom=8461
Cc: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 1/1] ocfs2: fix ocfs2_find_slot repeats alloc
 same slot issue
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R151e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046049;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VGLR284_1655177228;
X-ServerName: out30-132.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: la-mB7SK11BZts6EMgtZuvc_ozWm130j
X-Proofpoint-ORIG-GUID: la-mB7SK11BZts6EMgtZuvc_ozWm130j
Reporting-Meta:
 AAFDXKCJzE3+ymjzCO73SFxWAAGRxC1iE0LABuSn6oFoXngQueXCVw5tvhdlPeNY
 DiVmvdhwweVnewQ43suZysjnXXMkbNfa7+v1ry6puRwvymsT+bukl8P54Zpy1Ug/
 t/7UNsb+EhF7/wrOMC7tA5ve/vs4dy6HcHm9awlw0AxQF7ZRGyJQgGwDTOf68KTJ
 d+51RB83JUKmFDxtpM9VugGSzVGPdfTYiXARSgiDXIUkKRsnAc7bsIX7mOUaGin9
 dfgkMhKV/DhiY0SOmb0INg7TrV6gVHY6KUEF7w35x3rQwDiPpUbMieORMIrqgRfW
 26lAK9xoQdR2RGzlr/ZuVLzzuNYe4qyBMwjLjZ37EL4sC4wxIkNR6dK1/moyRkXh
 EIqyD9suAYyrnqnfS9QBnmq1A7gBZln5WqxYpxNl1ihpIm5HjykclbvThLDyU7eA
 PXsV7pjSbdxUROnsozbHSYcvqYvgxjWOxCqjeroPQX2+CxzG7y5/qpJkd2ObKuGS
 lWijXiQ8k3YPpkyweWk6NjSiXBjAxOmdtyn2Ywka0+c=

CgpPbiA2LzE0LzIyIDEwOjU5IEFNLCBoZW1pbmcuemhhb0BzdXNlLmNvbSB3cm90ZToKPiBPbiA2
LzEzLzIyIDIzOjQzLCBKdW54aWFvIEJpIHdyb3RlOgo+Pgo+Pj4g5ZyoIDIwMjLlubQ25pyIMTPm
l6XvvIzkuIrljYgxOjQ477yMaGVtaW5nLnpoYW9Ac3VzZS5jb20g5YaZ6YGT77yaCj4+Pgo+Pj4g
77u/T24gNi8xMy8yMiAxNjoyMSwgSm9zZXBoIFFpIHdyb3RlOgo+Pj4+PiBPbiA2LzEzLzIyIDM6
NTkgUE0sIGhlbWluZy56aGFvQHN1c2UuY29tIHdyb3RlOgo+Pj4+PiBPbiA2LzEyLzIyIDIyOjE2
LCBKb3NlcGggUWkgd3JvdGU6Cj4+Pj4+PiBIaSwKPj4+Pj4+Cj4+Pj4+PiBXaHkgY2FuJ3QgdXNl
IGxvY2FsIG1vdW50PyBJIGRvbid0IHJlbWVtYmVyIGlmIHdlIGRpc2N1c3MgYWJvdXQgdGhpcy4K
Pj4+Pj4+Cj4+Pj4+IFNvcnJ5LCBJIGNhbid0IGZvbGxvdyB5b3VyIHF1ZXN0aW9uLgo+Pj4+PiBE
byB5b3UgbWVhbiB3aHkgcmV2ZXJ0IGNvbW1pdCA5MTJmNjU1ZDc4YzU/Cj4+Pj4+Cj4+Pj4+IG9y
IHlvdSBhcmUgaW50ZXJlc3Qgd2l0aCB0aGUgZmVhdHVyZSBsb2NhbCBtb3VudD8KPj4+Pj4gdGhl
IGxvY2FsIG1vdW50IGlzIGNyZWF0ZWQgYnkgbWtmcy5vY2ZzMiwgd2hpY2ggY2FuJ3QgYmUgY29u
dmVydGVkIHRvIGNsdXN0ZXJlZC4KPj4+Pj4gc2VlIG1rZnMub2NmczIoOCkgJy1NJyBvcHRpb24u
Cj4+Pj4+Cj4+Pj4gV2hhdCBKdW54aWFvJ3MgbWFpbiBjb25jZXJuIGlzIGRhdGEgY29ycnVwdGlv
biwgc28gSSdtIGFmcmFpZCB3ZSBoYXZlIHRvCj4+Pj4gaW50cm9kdWNlIGFuIG9uZGlzayBmZWF0
dXJlIGJpdCB0byBwcmV2ZW50IG1peGVkIG5vY2x1c3RlciBhbmQgY2x1c3Rlcgo+Pj4+IG1vdW50
LCBzaW1pbGFyIHRvIGxvY2FsIG1vdW50Lgo+Pj4KPj4+IHRoaXMgcGF0Y2ggZGVmaW5lZCB0d28g
bmV3IHZhcmlhbnRzL2ZsYWdzOgo+Pj4gI2RlZmluZSBPQ0ZTMl9TTE9UTUFQX0NMVVNURVLCoMKg
IDEKPj4+ICNkZWZpbmUgT0NGUzJfU0xPVE1BUF9OT0NMVVNURVIgMgo+Pj4KPj4+IChJIGV4cGVj
dCkgVW5kZXIgT0NGUzJfU0xPVE1BUF9DTFVTVEVSLCBmb3IgY2x1c3RlcmVkIG1vdW50IG1vZGUg
YW5kIGZvciBjb21wYXRpYmlsaXR5LAo+Pj4gYW55dGhpbmcgZG9lc24ndCBuZWVkIHRvIGJlIGNo
YW5nZWQuCj4+Pgo+Pj4gT0NGUzJfU0xPVE1BUF9OT0NMVVNURVIgd2lsbCBpbnRyb2R1Y2UgYSBu
ZXcgdmFsdWUgZm9yIHNsb3RtYXAgYXJlYS4KPj4+IHRoaXMgbmV3IHZhbHVlIG9ubHkgdGFrZSBl
ZmZlY3QgYWZ0ZXIgYSBzdWNjZXNzZnVsbHkgbm9jbHVzdGVyIG1vdW50Lgo+Pj4gKHBscyBmaXgg
bWUpLCBleGlzdGVkIGtlcm5lbC91c2VyIHNwYWNlIGNvZGUgZG9uJ3QgZG8gYW55IHNwZWNpYWwg
aGFuZGxlIGZvcgo+Pj4gbm9jbHVzdGVyZWQgbW91bnQgbW9kZSBpbiBzbG90bWFwIGFyZWEuIFNv
IHRoZSBuZXcgdmFsdWUgaXMgYWxzbyBjb21wYXRpYmlsaXR5Lgo+Pj4KPj4+IEFuZCB0aGUgcGF0
Y2ggY2FuIGFsc28gcHJldmVudCBtaXhlZCBtb3VudCwgdGhlIHJlbGF0ZWQgY29kZSBpcyBpbiBv
Y2ZzMl9maW5kX3Nsb3QoKS4KPj4+IGNvZGUgbG9naWM6Cj4+PiAtIG5vY2x1c3RlcmVkIG1vdW50
IGNvbmRpdGlvbjogc2xvdG1hcCBpcyBlbXB0eSBvciBhbHJlYWR5IG1vdW50ZWQgd2l0aCBub2Ns
dXN0ZXJlZAo+Pj4gLSBjbHVzdGVyZWQgbW91bnQgY29uZGl0aW9uOiBzbG90bWFwIGlzIGVtcHR5
IG9yIGFscmVhZHkgbW91bnRlZCB3aXRoIGNsdXN0ZXJlZC4KPj4+IC0gYWxsIG90aGVyIGNvbmRp
dGlvbnMgd2lsbCBiZSBkZW5pZWQuCj4+IEZpbmRpbmcgc2xvdCByZXF1aXJlZCByZWFkaW5nIHNs
b3QgbWFwIGFuZCB0aGVuwqAgdXBkYXRlIHNsb3QgbWFwLiBJdCBpcyBub3QgYXRvbWljICwgeW91
IGNhbuKAmXQgcHJldmVudCBtaXhlZCBtb3VudCB1bnRpbCB5b3UgaGF2ZSBhIGNsdXN0ZXIgbG9j
ay4KPiAKPiBDb3VsZCBJIHNheSB5b3VyIG1lbnRpb25lZCB1c2UgY2FzZSBpcyBpbnZhbGlkLgo+
IEkgYmVsaWV2ZSBhbGwgKHllcywgKmFsbCopIHRoZSBvY2ZzMiB1c2VycyB1c2UgdGhpcyBmcyB1
bmRlciBjbHVzdGVyIG1vZGUgaW4KPiB0aGVpciBwcm9kdWN0IGVudi4KPiBUaGUgbm9jbHVzdGVy
IG1vdW50IGlzIG9ubHkgdXNlZCBvbiBtYWludGFpbmVkIGVudiAoZWcuIGJhY2t1cCwgZnNjayku
Cj4gCj4gV2Ugb25seSBjb25jZXJuIHR3byB3YXlzOgo+IDEuIHVzZXIgZm9yZ2V0cyB0byB1bm1v
dW50IChlZyBjcmFzaCkgYmVmb3JlIHVzaW5nIGFub3RoZXIgbW91bnQgbW9kZS4KPiAyLiB3aGVu
IG9jZnMyIHZvbHVtZSBpcyB3b3JraW5nLCB3aGljaCBzaG91bGQgZGVueSB2b2x1bWUgaXMgbW91
bnRlZCBieSBhbm90aGVyIG1vZGUuCj4gwqDCoCB0aGlzIG1heSBoYXBwZW5lZCB1c2VyIG1pc3Rh
a2VubHkgcnVucyBjb21tYW5kIG9yIHNjcmlwdC4KPiAKPiBCYXNlIG9uIGFib3ZlIDEgJiAyLCBK
dW54aWFvIGFib3ZlIG1lbnRpb25lZCB1c2UgY2FzZSBvbmx5IGhhcHBlbnMgb24gb25lIHNjZW5h
cmlvOgo+IHRoZSB2b2x1bWUgZG9lc24ndCBiZSBtb3VudGVkIGJ5IGFueSBub2RlLCB0aGVuIHVz
ZXIgbWlzdGFrZW5seSBtb3VudHMgdm9sdW1lCj4gd2l0aCBbbm9dY2x1c3RlciBtb2RlIGF0IHNh
bWUgdGltZS4gSSBiZWxpZXZlIHRoaXMgdXNlIGNhc2UgaXMgaW52YWxpZC4gQW5kIEkgZ3Vlc3MK
PiBnZnMyIG1heSBhbHNvIGhhcyB0aGUgc2FtZSBpc3N1ZS4KPiAKPiBXaXRoIHRoaXMgcGF0Y2gs
IG9jZnMyIGhhcyBtb3JlIHNhbml0eSBjaGVjayBhYmlsaXR5IHRoYW4gb3RoZXIgZnMsIGVnOiB4
ZnMsIGV4dDQuCj4gU1VTRSBIQSBzdGFjayB3aXRoIGNvcm9zeW5jK3BhY2VtYWtlciBhbHNvIHN1
cHBvcnRzIHJ1bm5pbmcgeGZzL2V4dDQgd2l0aCBBL1AgbW9kZS4KPiBUaGUgeGZzL2V4dDQgbmV2
ZXIgaGF2ZSBkZXRlY3RpbmcgbW91bnQgc3RhdHVzIGNvZGUsIEp1bnhpYW8gbWVudGlvbmVkIG1p
eGVkIG1vdW50Cj4gY2FuIGFsc28gaGFwcGVucyBvbiB0aGVzZSBmcy4gSG93IGRvIHhmcy9leHQ0
L0hBIG1haW50YWluZXJzIGhhbmRsZSBpdD8gVW5kZXIgdGhlc2UKPiBmcyBtb3VudGluZyBiZWhh
dmlvciwgdGhlc2UgZmllbGRzIG1haW50YWluZXJzIGFsc28gdHJlYXQgdGhlIG1peGVkIG1vdW50
IGFzCj4gaW52YWxpZCB1c2UgY2FzZSBhbmQgaWdub3JlIGhhbmRsZSBpdC4KCkV4dDQgaGFzIGEg
ZmVhdHVyZSBtbXAgKG11bHRpcGxlIG1vdW50IHByb3RlY3Rpb24pIHRvIGRvIHRoaXMuCk1vcmUg
ZGV0YWlscyBwbGVhc2UgcmVmZXIgdG86Cmh0dHBzOi8vZXh0NC53aWtpLmtlcm5lbC5vcmcvaW5k
ZXgucGhwL0V4dDRfRGlza19MYXlvdXQKClRoYW5rcywKSm9zZXBoCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QK
T2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFu
L2xpc3RpbmZvL29jZnMyLWRldmVs
