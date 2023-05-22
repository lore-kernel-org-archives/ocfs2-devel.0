Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93704C7EE26
	for <ocfs2-devel@archiver.kernel.org>; Mon, 22 May 2023 16:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XBB6j0Iteoehs4zdNXxbH+K6kfzFep+x+euA8c5vABU=;
 b=XBbirZ2dAnwv9p6MIR0Ly9hCGLPbwoJvxejnTMU3dmw5399YR9X8Pr3geMJCIDGL0XMl2WmCYF5L
   X4TFm1QNGVKdsKY1alhzxUAtyI/jHh3YSza25UgP4QpCBPjS1EVwrwtfZy1HDkv0A0tEDcAnkZqv
   dZcVy+dIfoKUUG0XgT18fayXxRNXnGn62Axoev7M76xsMYBFXixEN5xb7ilWMT+bKk2bonWRHj8j
   Af8GmAW3PfGet0CLim6ilR43aksgcz+bjtzqxyxsSGWhZ/PT6s2egkteBNRf3WIUEYn1goP7Bsfn
   rRMUzLJw6XlA845hFZxBsTov66+8x7tX/Lbtkw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XBB6j0Iteoehs4zdNXxbH+K6kfzFep+x+euA8c5vABU=;
 b=MQdb4kbAetHQt8+QCaXssQP8/v5rrpDWZ4FkpNkBneYEGDxQqBoX75ZEPCqgGG0AmnwEz66a5SX5
   +TDQ8dZaWc8EswSnkhKqqZwLBpAwnC9x1QDJsZ/RkQFDpJoiGik7qSLJjqeKAnt6jH7thE/QKCGe
   mn5DBhs4k3o6NCtya9Cx0VsZ9oOSt99PYXOzBQ2LrzCfYXSzGx4dgOo311ti2W3a8dDBuLZTSNGX
   Xtk+F134Vy6gyufr2BR0WcOTIP42HZn8d4laOnzkCI1xdbpYXK+e0k8Sc4uimqRq1IwzlVEK6sBW
   PQXdqq7Ppm1h16XHIGsi1KZb6jMxPECUJfo5Kg==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RV200JRNJ240Q60@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 22 May 2023 16:27:40 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
 t=1684758189;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=wpaiiqodyKy0vQ1DhJtYpCanuFOXvyTgR3AKKTwRaDM=;
 b=1N85ewdi4T9Tm9iCnKgBN2/WNHtI2Fovs3uH5EEgLrmN8PtMwY7ValscNVeP3GzL8o9+WE
 Pso+ue0qnbWOpIPgujIJ8oCYqiRj8OuF58ENmsJZ0W/3j6rJcFpAK6kFI0x97ikCVFEcsx
 0aOIcusfJPR6zSbO86DKNz03hV5ZxzY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
 s=susede2_ed25519; t=1684758189;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=wpaiiqodyKy0vQ1DhJtYpCanuFOXvyTgR3AKKTwRaDM=;
 b=kwg3NWWGvU1kuSwZ01cagoVlLeAnlFVrO/XpxD5GIpy8ngPTIzfzUKT3G1zgfleboHb/6d
 RBJ4P+vpvZ4SwKAA==
To: Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20230522102506.9205-1-lhenriques@suse.de>
 <a57047d6-8f57-3dde-f15f-b24f63d675cd@linux.alibaba.com>
Date: Mon, 22 May 2023 13:23:07 +0100
In-reply-to: <a57047d6-8f57-3dde-f15f-b24f63d675cd@linux.alibaba.com>
 (Joseph Qi's message of "Mon, 22 May 2023 20:01:25 +0800")
Message-id: <87h6s47dxw.fsf@brahms.olymp>
MIME-version: 1.0
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10717
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 priorityscore=108 lowpriorityscore=0
 clxscore=84 malwarescore=0 mlxscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305220103
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
From: =?utf-8?Q?Lu=C3=ADs_Henriques?= via Ocfs2-devel
 <ocfs2-devel@oss.oracle.com>
Reply-to: =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out1.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:195.135.220.0/27
 ip6:2001:67c:2178:6::/120 ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 9KJJxsRwE6CJEEY2FeHN3zpvcWBW_FqD
X-Proofpoint-GUID: 9KJJxsRwE6CJEEY2FeHN3zpvcWBW_FqD
X-Mailman-Approved-At: Mon, 22 May 2023 16:27:39 +0000
Reporting-Meta:
 AAFq1fnXOjLCU1bFjse/PMCHyhOnR7g3r3ICr5KCiExwUNiSmg9I/Nuj7BwQ/VFa
 zTki9nElL9qUlhDvjZX6rfoLTMVHYyiNtDl03szkEa6o9Qw3ZnoedEvmuD46Y7bP
 XG7fIwu/c5ULkH1qrE9TqGC18GDnqbKqr6bv06FNszqmyMDyHcW41IKPU8K0UonX
 kTx+iAA2bJvIzWGM6osRU3cc0TcJereXISBnCddLcCqGHFBKtMw1rctJuxol0EuO
 pl8nVw/dq8yY7Rk9wSNg6atS3ygjoaK845IbOXJWZZ1g8w6a8Cb9iUN2YGp5ZFul
 e6daXIED+rUyf51HwweQTn280+vR4gTtbxjzM1yGFssliMO0+VaS6oKiPMT1mHKm
 pIePQ3oXYCKllYmRVgY3z2Z7PNdV/46J+LOnzTLU5VQIlheR+DgjyD/JIbY/52Q6
 W/+lbapSbcuPnZKIadLIk1Ja+0DNmvx4UpVM++jtt2uAPt+P3CJrB5/VQ9rAg8BP
 7chXOkihtF9xiQEJUc7+DYMmCGyehy+4ZWURDNZV4zyR

Sm9zZXBoIFFpIDxqb3NlcGgucWlAbGludXguYWxpYmFiYS5jb20+IHdyaXRlczoKCj4gT24gNS8y
Mi8yMyA2OjI1IFBNLCBMdcOtcyBIZW5yaXF1ZXMgd3JvdGU6Cj4+IEl0J3MgdHJpdmlhbCB0byB0
cmlnZ2VyIGEgdXNlLWFmdGVyLWZyZWUgYnVnIGluIHRoZSBvY2ZzMiBxdW90YXMgY29kZSB1c2lu
Zwo+PiBmc3Rlc3QgZ2VuZXJpYy80NTIuICBBZnRlciBtb3VudGluZyBhIGZpbGVzeXN0ZW0gYXMg
cmVhZC1vbmx5LCBxdW90YXMgYXJlCj4KPiBnZW5lcmljLzQ1MiBpcyBmb3IgdGVzdGluZyBleHQ0
IG1vdW50ZWQgd2l0aCBkYXggYW5kIHJvLgo+IEJ1dCBvY2ZzMiBkb2Vzbid0IHN1cHBvcnQgZGF4
IHlldC4KClJpZ2h0LCBidXQgSSB0aGluayBpdCdzIHN0aWxsIHVzZWZ1bCB0byBydW4gdGhlICdn
ZW5lcmljJyB0ZXN0LXN1aXRlIGluIGEKZmlsZXN5c3RlbS4gIFdlIGNhbiBhbHdheXMgZmluZCBp
c3N1ZXMgaW4gdGhlIHRlc3QgaXRzZWxmIG9yLCBpbiB0aGlzCmNhc2UsIGEgYnVnIGluIHRoZSBm
aWxlc3lzdGVtLgoKPj4gc3VzcGVuZGVkIGFuZCBvY2ZzMl9tZW1fZHFpbmZvIGlzIGZyZWVkIHRo
cm91Z2ggLT5vY2ZzMl9sb2NhbF9mcmVlX2luZm8oKS4gIFdoZW4KPj4gdW5tb3VudGluZyB0aGUg
ZmlsZXN5c3RlbSwgYW4gVUFGIGFjY2VzcyB0byB0aGUgb2luZm8gd2lsbCBldmVudHVhbGx5IGNh
dXNlIGEKPj4gY3Jhc2guCj4KPiBJbiBvY2ZzMl9maWxsX3N1cGVyKCksIGl0IHdvbid0IGVuYWJs
ZSBxdW90YSBpZiBpcyBhIHJlYWRvbmx5IG1vdW50Lgo+IERvIHlvdSBtZWFuIHJlbW91bnQgYXMg
cmVhZG9ubHk/CgpZZXMsIHNvcnJ5LiBJbnN0ZWFkIG9mICJtb3VudGluZyIsIHRoZSBwYXRjaCBj
aGFuZ2Vsb2cgc2hvdWxkIHNheQoKICAiQWZ0ZXIgcmVtb3VudGluZyBhIGZpbGVzeXN0ZW0gYXMg
cmVhZC1vbmx5Li4uIgoKQ2hlZXJzLAotLSAKTHXDrXMKCj4KPiBUaGFua3MsCj4gSm9zZXBoCj4K
Pj4gCj4+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4KPj4gU2lnbmVkLW9mZi1ieTogTHXD
rXMgSGVucmlxdWVzIDxsaGVucmlxdWVzQHN1c2UuZGU+Cj4+IC0tLQo+PiAgZnMvb2NmczIvc3Vw
ZXIuYyB8IDYgKysrKy0tCj4+ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAyIGRl
bGV0aW9ucygtKQo+PiAKPj4gZGlmZiAtLWdpdCBhL2ZzL29jZnMyL3N1cGVyLmMgYi9mcy9vY2Zz
Mi9zdXBlci5jCj4+IGluZGV4IDBiMGU2YTEzMjEwMS4uOTg4ZDFjMDc2ODYxIDEwMDY0NAo+PiAt
LS0gYS9mcy9vY2ZzMi9zdXBlci5jCj4+ICsrKyBiL2ZzL29jZnMyL3N1cGVyLmMKPj4gQEAgLTk1
Miw4ICs5NTIsMTAgQEAgc3RhdGljIHZvaWQgb2NmczJfZGlzYWJsZV9xdW90YXMoc3RydWN0IG9j
ZnMyX3N1cGVyICpvc2IpCj4+ICAJZm9yICh0eXBlID0gMDsgdHlwZSA8IE9DRlMyX01BWFFVT1RB
UzsgdHlwZSsrKSB7Cj4+ICAJCWlmICghc2JfaGFzX3F1b3RhX2xvYWRlZChzYiwgdHlwZSkpCj4+
ICAJCQljb250aW51ZTsKPj4gLQkJb2luZm8gPSBzYl9kcWluZm8oc2IsIHR5cGUpLT5kcWlfcHJp
djsKPj4gLQkJY2FuY2VsX2RlbGF5ZWRfd29ya19zeW5jKCZvaW5mby0+ZHFpX3N5bmNfd29yayk7
Cj4+ICsJCWlmICghc2JfaGFzX3F1b3RhX3N1c3BlbmRlZChzYiwgdHlwZSkpIHsKPj4gKwkJCW9p
bmZvID0gc2JfZHFpbmZvKHNiLCB0eXBlKS0+ZHFpX3ByaXY7Cj4+ICsJCQljYW5jZWxfZGVsYXll
ZF93b3JrX3N5bmMoJm9pbmZvLT5kcWlfc3luY193b3JrKTsKPj4gKwkJfQo+PiAgCQlpbm9kZSA9
IGlncmFiKHNiLT5zX2RxdW90LmZpbGVzW3R5cGVdKTsKPj4gIAkJLyogVHVybiBvZmYgcXVvdGFz
LiBUaGlzIHdpbGwgcmVtb3ZlIGFsbCBkcXVvdCBzdHJ1Y3R1cmVzIGZyb20KPj4gIAkJICogbWVt
b3J5IGFuZCBzbyB0aGV5IHdpbGwgYmUgYXV0b21hdGljYWxseSBzeW5jZWQgdG8gZ2xvYmFsCgoK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2
ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9y
YWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
