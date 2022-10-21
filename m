Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD8CBC4332F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 08:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7FABMvUejLnNZoFoLUU/H7AHUMzrKxkB8WhEnidhHkI=;
 b=Iy6StSk0Wbfgo24xbbsIZg9bs+V1hjKOi9VHWS74kN8MNGql6qd8V1ee0abKkRTLgOYIHVE3vX00
   bQQ/vlhkAdkFpZhWcMygZPmuBa6LLtp/WMv/O114m7e6bTW/Farc99LeZnnzoB/dAPkAPt5GRquB
   gXWTzCO6NfRzeaJwszq8fxFpQ2vJR8NNk47Xs1VzJ0RyFoZcsaZavTS6mDx1MzG16oKz4TpL7gp7
   F356ac7npUqRIPC8wqtu0MUxd90Jdpkirv52TrfqobNCg9WmfqjFtqHxwaS9sff6jXh7x0zeQrCK
   a/uJ6IY6MPoxsJ9LGhDXjBZhwhR1mFGrr/lFQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7FABMvUejLnNZoFoLUU/H7AHUMzrKxkB8WhEnidhHkI=;
 b=U4ekVRqxVSNUrUv6vnhdhNY15OLEooh1saAk9CI2I19hg2rhuqp+9Z1F6w5jz6jC1Bu9wbHlovC/
   HADxGUDKT8zt93tQvxCXhMQ18lJD+fqCeR1PPemjGUWldewI3uP2JJRQND1HbN7Oaj2t1F3EHjrT
   JPWd55laYzC3DzxuwAgZ8eMciftoBUBuW/fi9wduA068n/WnyynL0kyTL28+ZpLfTmWuinOyODPt
   VLAyti0oTWb8CxPESjtD9FV5YnJKYlLMPnhe6frR9QPK4SM2AqGWaJ+0ENiEqlVL+cvQTSC85WzJ
   tJvY15u0A19wSbfNWfGMjsC3k6z4PazCMLlDdg==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK300LI2GPUWT40@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 08:25:06 +0000 (GMT)
To: Greg KH <gregkh@linuxfoundation.org>, Luben Tuikov <luben.tuikov@amd.com>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
 <d559793a-0ce4-3384-e74e-19855aa31f31@amd.com> <Y1IwLOUGayjT9p6d@kroah.com>
Message-id: <0591e66f-731a-5f81-fc9d-3a6d80516c65@huawei.com>
Date: Fri, 21 Oct 2022 16:24:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-version: 1.0
In-reply-to: <Y1IwLOUGayjT9p6d@kroah.com>
Content-language: en-US
X-Originating-IP: [10.174.178.174]
X-Source-IP: 45.249.212.188
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=823 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 clxscore=-58 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210048 domainage_hfrom=8319
Cc: chao@kernel.org, rafael@kernel.org, qemu-devel@nongnu.org, richard@nod.at,
 somlo@cmu.edu, mst@redhat.com, linux-kernel@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, linux-f2fs-devel@lists.sourceforge.net,
 liushixin2@huawei.com, linux-mtd@lists.infradead.org,
 hsiangkao@linux.alibaba.com, alexander.deucher@amd.com, jaegeuk@kernel.org,
 huangjianan@oppo.com, linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 00/11] fix memory leak while	kset_register()
 fails
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
From: Yang Yingliang via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Yang Yingliang <yangyingliang@huawei.com>
Content-transfer-encoding: base64
Content-type: text/plain; charset="utf-8"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-ServerName: szxga02-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: nLiVsnyakXfCTuSbnwAE8Agc8MPVCep4
X-Proofpoint-GUID: nLiVsnyakXfCTuSbnwAE8Agc8MPVCep4
Reporting-Meta:
 AAH/dmtHzaGBepgVYvGLjuhtMZcHFPiBaMkDWvW1FTJO3BzOHd77ZWoI1/IZRYqv
 gIQ43WUSpCtX25QuVW8AAVPQREIRGaIkkZHDLqvB6Xa5vDNs3xbaHyIIec30hdJq
 lJiAaIQxnpFjKoGiAH4GRCwWW0cY9MotWTQtVO2/l2WgszB9qVaEFu30o7y+YoQ2
 Q56T3UKeTprH4XR9/D0lbJLq/2Tcy0afx7nugAUB71rvq9Xoy50tVH34/0H+KqbS
 wHY0eKvVUbcl8QLLTpeUOP1fPQ8R2kmLv7wG5zxoqgG1o6wSYfwAeDRufmxxLFM6
 S9gcnEMdxT25tIVIdwzgRBEhPsgKApTOK+4dUwvd92tfUQcBOoflBgqpaxWA70IK
 OcrLQ01X79ENKw1vthNbmvu6j3goBDCP2mDP3EVYDIryZ8u9IuVrbkZFUxD3IvQ0
 qFICxZYEOdbafiZ8e1ovCW2sDxRB0oTDQeqUw4bLTWyQ5M+0RGZwhFaf7MAEgIjr
 l29fgW0A/mGTTVJVNT4M2D+/K/JORKDpT2VuU5wHEDQ=

Ck9uIDIwMjIvMTAvMjEgMTM6MzcsIEdyZWcgS0ggd3JvdGU6Cj4gT24gRnJpLCBPY3QgMjEsIDIw
MjIgYXQgMDE6Mjk6MzFBTSAtMDQwMCwgTHViZW4gVHVpa292IHdyb3RlOgo+PiBPbiAyMDIyLTEw
LTIwIDIyOjIwLCBZYW5nIFlpbmdsaWFuZyB3cm90ZToKPj4+IFRoZSBwcmV2aW91cyBkaXNjdXNz
aW9uIGxpbms6Cj4+PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzBkYjQ4NmViLTY5Mjct
OTI3ZS0zNjI5LTk1OGY4ZjIxMTE5NEBodWF3ZWkuY29tL1QvCj4+IFRoZSB2ZXJ5IGZpcnN0IGRp
c2N1c3Npb24gb24gdGhpcyB3YXMgaGVyZToKPj4KPj4gaHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQv
bGlzdHMvZHJpLWRldmVsL21zZzM2ODA3Ny5odG1sCj4+Cj4+IFBsZWFzZSB1c2UgdGhpcyBsaW5r
LCBhbmQgbm90IHRoZSB0aGF0IG9uZSB1cCB0aGVyZSB5b3Ugd2hpY2ggcXVvdGVkIGFib3ZlLAo+
PiBhbmQgd2hvc2UgY29tbWl0IGRlc2NyaXB0aW9uIGlzIHRha2VuIHZlcmJhdGltIGZyb20gdGhl
IHRoaXMgbGluay4KPj4KPj4+IGtzZXRfcmVnaXN0ZXIoKSBpcyBjdXJyZW50bHkgdXNlZCBpbiBz
b21lIHBsYWNlcyB3aXRob3V0IGNhbGxpbmcKPj4+IGtzZXRfcHV0KCkgaW4gZXJyb3IgcGF0aCwg
YmVjYXVzZSB0aGUgY2FsbGVycyB0aGluayBpdCBzaG91bGQgYmUKPj4+IGtzZXQgaW50ZXJuYWwg
dGhpbmcgdG8gZG8sIGJ1dCB0aGUgZHJpdmVyIGNvcmUgY2FuIG5vdCBrbm93IHdoYXQKPj4+IGNh
bGxlciBkb2luZyB3aXRoIHRoYXQgbWVtb3J5IGF0IHRpbWVzLiBUaGUgbWVtb3J5IGNvdWxkIGJl
IGZyZWVkCj4+PiBib3RoIGluIGtzZXRfcHV0KCkgYW5kIGVycm9yIHBhdGggb2YgY2FsbGVyLCBp
ZiBpdCBpcyBjYWxsZWQgaW4KPj4+IGtzZXRfcmVnaXN0ZXIoKS4KPj4gQXMgSSBleHBsYWluZWQg
aW4gdGhlIGxpbmsgYWJvdmUsIHRoZSByZWFzb24gdGhlcmUncwo+PiBhIG1lbW9yeSBsZWFrIGlz
IHRoYXQgb25lIGNhbm5vdCBjYWxsIGtzZXRfcmVnaXN0ZXIoKSB3aXRob3V0Cj4+IHRoZSBrc2V0
LT5rb2JqLm5hbWUgYmVpbmcgc2V0LS1rb2JqX2FkZF9pbnRlcm5hbCgpIHJldHVybnMgLUVJTlZB
TCwKPj4gaW4gdGhpcyBjYXNlLCBpLmUuIGtzZXRfcmVnaXN0ZXIoKSBmYWlscyB3aXRoIC1FSU5W
QUwuCj4+Cj4+IFRodXMsIHRoZSBtb3N0IGNvbW1vbiB1c2FnZSBpcyBzb21ldGhpbmcgbGlrZSB0
aGlzOgo+Pgo+PiAJa29ial9zZXRfbmFtZSgma3NldC0+a29iaiwgZm9ybWF0LCAuLi4pOwo+PiAJ
a3NldC0+a29iai5rc2V0ID0gcGFyZW50X2tzZXQ7Cj4+IAlrc2V0LT5rb2JqLmt0eXBlID0ga3R5
cGU7Cj4+IAlyZXMgPSBrc2V0X3JlZ2lzdGVyKGtzZXQpOwo+Pgo+PiBTbywgd2hhdCBpcyBiZWlu
ZyBsZWFrZWQsIGlzIHRoZSBtZW1vcnkgYWxsb2NhdGVkIGluIGtvYmpfc2V0X25hbWUoKSwKPj4g
YnkgdGhlIGNvbW1vbiBpZGlvbSBzaG93biBhYm92ZS4gVGhpcyBuZWVkcyB0byBiZSBtZW50aW9u
ZWQgaW4KPj4gdGhlIGRvY3VtZW50YXRpb24sIGF0IGxlYXN0LCBpbiBjYXNlLCBpbiB0aGUgZnV0
dXJlIHRoaXMgaXMgYWJzb2x2ZWQKPj4gaW4ga3NldF9yZWdpc3RlcigpIHJlZGVzaWduLCBldGMu
Cj4gQmFzZWQgb24gdGhpcywgY2FuIGtzZXRfcmVnaXN0ZXIoKSBqdXN0IGNsZWFuIHVwIGZyb20g
aXRzZWxmIHdoZW4gYW4KPiBlcnJvciBoYXBwZW5zPyAgSWRlYWxseSB0aGF0IHdvdWxkIGJlIHRo
ZSBjYXNlLCBhcyB0aGUgb2RkcyBvZiBhIGtzZXQKPiBiZWluZyBlbWJlZGRlZCBpbiBhIGxhcmdl
ciBzdHJ1Y3R1cmUgaXMgcHJvYmFibHkgc2xpbSwgYnV0IHdlIHdvdWxkIGhhdmUKPiB0byBzZWFy
Y2ggdGhlIHRyZWUgdG8gbWFrZSBzdXJlLgpJIGhhdmUgc2VhcmNoIHRoZSB3aG9sZSB0cmVlLCB0
aGUga3NldCB1c2VkIGluIGJ1c19yZWdpc3RlcigpIC0gcGF0Y2ggCiMzLCBrc2V0X2NyZWF0ZV9h
bmRfYWRkKCkgLSBwYXRjaCAjNApfX2NsYXNzX3JlZ2lzdGVyKCkgLSBwYXRjaCAjNSzCoCBmd19j
ZmdfYnVpbGRfc3ltbGluaygpIC0gcGF0Y2ggIzYgYW5kIAphbWRncHVfZGlzY292ZXJ5LmMgLSBw
YXRjaCAjMTAKaXMgZW1iZWRkZWQgaW4gYSBsYXJnZXIgc3RydWN0dXJlLiBJbiB0aGVzZSBjYXNl
cywgd2UgY2FuIG5vdCBjYWxsIAprc2V0X3B1dCgpIGluIGVycm9yIHBhdGggaW4ga3NldF9yZWdp
c3RlcigpCml0c2VsZi4KClRoYW5rcywKWWFuZwo+Cj4gdGhhbmtzLAo+Cj4gZ3JlZyBrLWgKPiAu
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1k
ZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mu
b3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
