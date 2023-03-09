Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F07C4C64EC4
	for <ocfs2-devel@archiver.kernel.org>; Thu,  9 Mar 2023 07:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=F+lJhaJrZrhxcnCQeZ3QkryxSL8AodY+z38I7jr9eVA=;
 b=DaFsBcDo2sE8YAgvc4ugtNpVtuC9nh6AFyjHNeWOF5WKpbwVAXo73ut2MRQ8EUqjXLE40a49+aWF
   DyzhW/mkDg8aUFxYaL8+nWXM/LWCiQ2uyH2piHWcAar50MhMf5HbGgo7M3hTpbTUgkp3mTdl5/ea
   kpNcbS79HaBOHfVBnuC6j/6BHvTBxlsVhb6oZxH//72z55HBAfCF4TcqgDGv2FH3Dv9AXVR8i8K6
   N10PSpKYwzgLYJpnG95f3M6znQvHrAhomTdz1t4QjXFoe4Js24C7E+pIZlBYnOXT+YR6QXBaK1m1
   vtMc1XYkzyuQ7VuSUOMstyINBwaUpKiPQuMOWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=F+lJhaJrZrhxcnCQeZ3QkryxSL8AodY+z38I7jr9eVA=;
 b=etAbU7G3zRN1oseEpOwc4c+QABQH9+dLYHRqz9YAdkY/rUe5TW6MHWD526nbLLxHlsHOUnc6FoBP
   yfO+tGG72xAsYv0nVnt+ChWEYYYqXTbEqGkmQ07rbxXuoqvmIoWbub3k3fv8YP5P8GnZWjL023gc
   0kDnh7yPhz4EU1N9s33FtdwCWT/G5qTjDSBSfOFItFQDG7AmTAfw8JkNmv0TJuzHoO3pCLvDj1X0
   iko2Gx7HWB6Dspn7mk7ZCmmSxnl6DIxcS6V1Jq1OQg87nzBZiRcwZMDnv0U46xOqmL+PNJDIsCQP
   6Of64qoFu/dXkqUeZ14VJh2IUGXibiG/UJmVQg==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR800NLNTZG62A0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 09 Mar 2023 07:54:52 +0000 (GMT)
Message-id: <250fe1947dd3fea27d8f4aa86fdb9980954b5425.camel@huaweicloud.com>
To: Paul Moore <paul@paul-moore.com>
Date: Thu, 09 Mar 2023 08:53:48 +0100
In-reply-to:
 <CAHC9VhTRT=o9Rv+EhZ4aab1FDCyTNa7XEYuhuOiSEkWh0Cdrnw@mail.gmail.com>
References: <20221201104125.919483-1-roberto.sassu@huaweicloud.com>
 <CAHC9VhTRT=o9Rv+EhZ4aab1FDCyTNa7XEYuhuOiSEkWh0Cdrnw@mail.gmail.com>
User-Agent: Evolution 3.36.5-0ubuntu1
MIME-version: 1.0
X-Source-IP: 14.137.139.46
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10643
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=0 mlxlogscore=534
 mlxscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 clxscore=217 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303090061
Cc: nicolas.bouchinet@clip-os.org, linux-kernel@vger.kernel.org,
 keescook@chromium.org, selinux@vger.kernel.org, dmitry.kasatkin@gmail.com,
 Roberto Sassu <roberto.sassu@huawei.com>, jmorris@namei.org,
 zohar@linux.ibm.com, reiserfs-devel@vger.kernel.org,
 linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
 eparis@parisplace.org, linux-integrity@vger.kernel.org,
 stephen.smalley.work@gmail.com, ocfs2-devel@oss.oracle.com, serge@hallyn.com
Subject: Re: [Ocfs2-devel] [PATCH v7 0/6] evm: Do HMAC of multiple per LSM
 xattrs for new inodes
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
From: Roberto Sassu via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Roberto Sassu <roberto.sassu@huaweicloud.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-CM-TRANSID: GxC2BwB3Rl2OkAlkp2OBAQ--.23244S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZw4kGFy8uryfCFWDJw47Jwb_yoWkZFg_u3
 WUt3s7Gws8X3WkGa13tr1agry0g3ykZF1jvryqgr13Xw18JaykAFs7CFsavw15Jay7X3sI
 kr9rZ342y3sIgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
 9fnUUIcSsGvfJTRUUUb78YFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
 Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
 A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x02
 67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r1j6r4UM28EF7xvwVC2z280aVCY1x0267
 AKxVW8JVW8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
 j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
 kEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCF04k20xvY0x0E
 wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
 80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0
 I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04
 k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
 1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU13rcDUUUUU==
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQALBF1jj4pbjgACsi
X-CFilter-Loop: Reflected
X-ServerName: frasgout13.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-GUID: Jif1wK398ICOrsdK-zJMRSWen7KQJ0RR
X-Proofpoint-ORIG-GUID: Jif1wK398ICOrsdK-zJMRSWen7KQJ0RR
Reporting-Meta:
 AAGrRPaFIGkEoxObAvKjoyORODDyGGO+IHXHb+lEQPa2ESWpJy+iuRNQmFsT1nbq
 AycKrZGSIJCrj9mHAcgeM7P4XMx7/D3oVQBLGfsoRx6beMRgY6gbJ512w9zUbLaJ
 rtst+XljJOTeFsrhzpJMx9VctvzxPYoTYBR9D9E7BZTs+6XZCFKCWgPkAUWcajke
 bL8zdndzeUrli/ZeKPuaVyRnkQ/LxxcYcLe0BghmsmRjAa+r1Y9pwqudv0qjC49W
 lT7UF126Oy64jV3XI5YOHBfUs3/ukYGstgnWUOMnrtbdR1Nc4JFEfDV9BlmN7Taj
 fAHU4sHhj7eJ9CBf2zzQsFu2NkJ8jX810wYDQHdMR9uSQMW5pSEf4xAyiT+flBI7
 +VLQlIWFoxOqMMCc29IgqxoY7jCBFpulcKncfQn5HeVYjOl3zxYqRCHopPa7i2+q
 d97j1pglYqFm3L8HUs+gufu5HatIrc7TPuySN7QnzhNLfjx0ALLKKoIttE8oQXoA
 pRub+hGlCXhu6+L72MTt2D1PCZpXzXEcXI0c1VpU/wmi

T24gV2VkLCAyMDIzLTAzLTA4IGF0IDE3OjE2IC0wNTAwLCBQYXVsIE1vb3JlIHdyb3RlOgo+IE9u
IFRodSwgRGVjIDEsIDIwMjIgYXQgNTo0MuKAr0FNIFJvYmVydG8gU2Fzc3UKPiA8cm9iZXJ0by5z
YXNzdUBodWF3ZWljbG91ZC5jb20+IHdyb3RlOgo+ID4gRnJvbTogUm9iZXJ0byBTYXNzdSA8cm9i
ZXJ0by5zYXNzdUBodWF3ZWkuY29tPgo+ID4gCj4gPiBPbmUgb2YgdGhlIG1ham9yIGdvYWxzIG9m
IExTTSBzdGFja2luZyBpcyB0byBydW4gbXVsdGlwbGUgTFNNcyBzaWRlIGJ5IHNpZGUKPiA+IHdp
dGhvdXQgaW50ZXJmZXJpbmcgd2l0aCBlYWNoIG90aGVyLiBUaGUgdWx0aW1hdGUgZGVjaXNpb24g
d2lsbCBkZXBlbmQgb24KPiA+IGluZGl2aWR1YWwgTFNNIGRlY2lzaW9uLgo+ID4gCj4gPiBTZXZl
cmFsIGNoYW5nZXMgbmVlZCB0byBiZSBtYWRlIHRvIHRoZSBMU00gaW5mcmFzdHJ1Y3R1cmUgdG8g
YmUgYWJsZSB0bwo+ID4gc3VwcG9ydCB0aGF0LiBUaGlzIHBhdGNoIHNldCB0YWNrbGVzIG9uZSBv
ZiB0aGVtOiBnaXZlcyB0byBlYWNoIExTTSB0aGUKPiA+IGFiaWxpdHkgdG8gc3BlY2lmeSBvbmUg
b3IgbXVsdGlwbGUgeGF0dHJzIHRvIGJlIHNldCBhdCBpbm9kZSBjcmVhdGlvbgo+ID4gdGltZSBh
bmQsIGF0IHRoZSBzYW1lIHRpbWUsIGdpdmVzIHRvIEVWTSB0aGUgYWJpbGl0eSB0byBhY2Nlc3Mg
YWxsIHRob3NlCj4gPiB4YXR0cnMgYW5kIGNhbGN1bGF0ZSB0aGUgSE1BQyBvbiB0aGVtLgo+IAo+
IEhpIFJvYmVydG8sCj4gCj4gVGhlIHY3IGRyYWZ0IG9mIHRoaXMgcGF0Y2hzZXQgaGFkIHNvbWUg
Z29vZCBkaXNjdXNzaW9uLCBhbmQgYmFzZWQgb24gYQo+IHF1aWNrIHJlYWQgb2YgdGhlIGNvbW1l
bnRzIGl0IGxvb2tzIGxpa2UgZXZlcnlvbmUgd2FzIGV2ZW50dWFsbHkKPiBzYXRpc2ZpZWQgdGhh
dCB0aGUgdjcgZHJhZnQgd2FzIGdvb2QgYW5kIG5vIGZ1cnRoZXIgY2hhbmdlcyB3ZXJlCj4gbmVj
ZXNzYXJ5LCBpcyB0aGF0IGNvcnJlY3Qgb3IgZG8geW91IGhhdmUgYW4gdXBkYXRlZCBkcmFmdCBv
ZiB0aGlzCj4gcGF0Y2hzZXQ/CgpIaSBQYXVsCgpJIGFkZHJlc3NlZCBmZXcgbW9yZSBjb25jZXJu
cyBmcm9tIE1pbWkgYW5kIENhc2V5LiBJIHRoaW5rIHY4IHNob3VsZCBiZQpnb29kIHRvIHNlbmQg
KHVubGVzcyB5b3UgaGF2ZSBtb3JlIGNvbW1lbnRzL3N1Z2dlc3Rpb25zKS4KClRoYW5rcwoKUm9i
ZXJ0bwoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCk9j
ZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczov
L29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
