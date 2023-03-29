Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98002C6FD18
	for <ocfs2-devel@archiver.kernel.org>; Wed, 29 Mar 2023 07:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QHwvLZ5PagsZYbDPcNUYLINhd6N20vaRZVEsIx+rcpQ=;
 b=KuRhHbbIoCdsmsz8XLg3dfQeZ1cev2HWWgf7hl0uXQp40Xqh+GkbAp3l6IPzO522DbqOykBlyun9
   cxXRnjzoConXgkpFlDDp2TCgHZegzvs9IFwGlJrFJiOe1l28OZTsuL4bJSNL2InkTB/9/vK4fHyk
   nIy3lqsaENfV5agUqrpRy4ekrCnK2o6DAdq2NTjRg2Rw+aUT13Z5VUfibYNjQEG4DB20rDoA13/l
   jIrcP5ZLcTnzqJYiuho5pt+K33SHbCwI7wO54R2wYA95zqHeWbYTQcAEr1QVM4mpTcCfatnnaEm5
   W0QlnQjg/ik9JRUhYjZ5XeJ5UUiciacqm/f+aA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=QHwvLZ5PagsZYbDPcNUYLINhd6N20vaRZVEsIx+rcpQ=;
 b=N5qUzwV+X1GkIyzv/0K7boPY7s+rUisyZsQf6Cz4SOIn2ag5ETUM6X1Ze8dNem6CDtTn5+jhwYb7
   POU39OLqirFb5sngwWQBAih1zLNm4dtBTJkkW0DVt3fdoCpPOb9k6rG6wQqtBmBiqJitrAQO/iMn
   NGV8SPgBfQ6FFC07t8OyLcgXc15S5zc5H4qCCkRCj7PNmaHNiOk2xibaTwJCmkbWXMlsAPFMUDfi
   wd7dwgdtkVfYNSo9IU8fNwQW3BqhGraRyCWy1KiaLCBN/OQtEaZmVd/AoHZqCBmuDoi4/kGd8UWV
   pCL26mNreWxafVpNhf3AzIdidJwMeX/P+AwB5A==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RS900BTGTDMJH60@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 29 Mar 2023 07:12:58 +0000 (GMT)
Message-id: <e7faa6ebe2958184aeccadad51d18877577b225b.camel@huaweicloud.com>
To: Paul Moore <paul@paul-moore.com>
Date: Wed, 29 Mar 2023 09:11:59 +0200
In-reply-to:
 <CAHC9VhRNWeZtxain_Hi-EfS49Vac8_vg7KRRyV4a9Sq3XPhZsg@mail.gmail.com>
References: <20230314081720.4158676-1-roberto.sassu@huaweicloud.com>
 <20230314081720.4158676-5-roberto.sassu@huaweicloud.com>
 <CAHC9VhTD3EyDiJs9+NQrgp84JcUs_sx8WONtRk2YYH4m1C8nVw@mail.gmail.com>
 <939e6c88662ad90b963993c4cc1b702083e74a7a.camel@huaweicloud.com>
 <ffc86b3907f7b87d3c568ae62bea3cdb3275be4e.camel@huaweicloud.com>
 <CAHC9VhRNjvjMOF5KLM6BoGfk=QpEBs_ur_CgRdGL5R1bA-JAwg@mail.gmail.com>
 <8b63d00d8ac3f686e51889ea4fc8d83f8ecb300d.camel@huaweicloud.com>
 <CAHC9VhRaKtsM=CuNhDy0Kx0NGSUrVhG+MhwKnHiyJxfgUwx7nA@mail.gmail.com>
 <1e08006f9011efa48deaf656c358ca3d438b9768.camel@huaweicloud.com>
 <CAHC9VhRNWeZtxain_Hi-EfS49Vac8_vg7KRRyV4a9Sq3XPhZsg@mail.gmail.com>
User-Agent: Evolution 3.36.5-0ubuntu1
MIME-version: 1.0
X-Source-IP: 14.137.139.23
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10663
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 clxscore=-50 lowpriorityscore=0 mlxscore=0 adultscore=0 suspectscore=0
 mlxlogscore=793 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303290059
Cc: nicolas.bouchinet@clip-os.org, linux-kernel@vger.kernel.org,
 keescook@chromium.org, selinux@vger.kernel.org, dmitry.kasatkin@gmail.com,
 Roberto Sassu <roberto.sassu@huawei.com>, jmorris@namei.org,
 zohar@linux.ibm.com, reiserfs-devel@vger.kernel.org,
 linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
 eparis@parisplace.org, linux-integrity@vger.kernel.org,
 stephen.smalley.work@gmail.com, ocfs2-devel@oss.oracle.com, serge@hallyn.com
Subject: Re: [Ocfs2-devel] [PATCH v8 4/6] security: Allow all LSMs to provide
 xattrs for inode_init_security hook
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
X-CM-TRANSID: GxC2BwAX6F7D5CNk8fLYAQ--.17663S2
X-Coremail-Antispam: 1UD129KBjvJXoW7AF4UAr48AFyUJFy5ArWrXwb_yoW8trW5pF
 4Ut3Wqkr4vqr42yr92ya18G3yrK39xtr4UXwn8tr1UZ34qgryfCF1xKF43uryDGrn2k3s0
 vrWYgry3W3ZxAaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIEc7CjxV
 AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
 x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
 0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
 64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
 8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE
 2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
 xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
 c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UZ18PUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQALBF1jj4tHZgAAsV
X-CFilter-Loop: Reflected
X-ServerName: frasgout11.his.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.51 ip4:45.249.212.56
 ip4:185.176.79.53 ip4:14.137.139.23 ip4:14.137.139.154 ip4:14.137.139.46
 ip4:124.71.93.99 ip4:124.71.93.112 ip4:124.71.94.104
 include:spf.saas.huaweicloud.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 75gZquoD1q1-76PPJHSyG1dCojBu3FUY
X-Proofpoint-GUID: 75gZquoD1q1-76PPJHSyG1dCojBu3FUY
Reporting-Meta:
 AAFVK3Qw2he6X8ywWL5KnhpuuOseAD8cWrJy3i3LpjD7/mdyyXqmPZZubpGwoI0G
 nIUDs87mWMow15iow2EzTtiZhq9aHImkBWRY3uTzv213dkOlYUeA7T11Mm0gmyq+
 QeiA/jt9nR9RhNeHYJozv1ubhJ8IieMwbqFRwEgZzKfV3hHpLkRepFsKn5z4UAbW
 f0h5c+JvyyvmFmMl8D7DzP1JWmEqPfr+VQua+i/9RJNQBNHmeZzqY3WzKMXOGBmP
 ffN9qcSKBzuazDhWaVv2eaA89WgH3TFBxnWIouFzhCqzTPDCNav8pVg9Pjtcf1dj
 46ODb7XltVtS8NOoiuQOPyvYX7mLGd8//51yRBtzHMbamzXbTL5I/VbykzzCXEf2
 7EpjlCXrucj1aQwadnd2yD0J9KaCSU6mKqtCJtRFJW1UIRFHcGfshxG+TMJM9zRZ
 28lXsvoUsK294SUblQas8g7mqTOcMDdKnSA99pi0q1BZxY3D4aGZrjp7OEM/Dk2x
 fV5dFrWTDs+relcLzlUaV2cgvpKgEl0DkI2XPkgxKIcQog==

T24gVHVlLCAyMDIzLTAzLTI4IGF0IDE2OjE5IC0wNDAwLCBQYXVsIE1vb3JlIHdyb3RlOgo+IE9u
IFR1ZSwgTWFyIDI4LCAyMDIzIGF0IDM6NDfigK9BTSBSb2JlcnRvIFNhc3N1Cj4gPHJvYmVydG8u
c2Fzc3VAaHVhd2VpY2xvdWQuY29tPiB3cm90ZToKPiA+IE9uIE1vbiwgMjAyMy0wMy0yNyBhdCAx
NzowMiAtMDQwMCwgUGF1bCBNb29yZSB3cm90ZToKPiA+ID4gT24gTW9uLCBNYXIgMjcsIDIwMjMg
YXQgMzozMOKAr0FNIFJvYmVydG8gU2Fzc3UKPiA+ID4gPHJvYmVydG8uc2Fzc3VAaHVhd2VpY2xv
dWQuY29tPiB3cm90ZToKPiA+ID4gPiBPbiBGcmksIDIwMjMtMDMtMjQgYXQgMTc6MzkgLTA0MDAs
IFBhdWwgTW9vcmUgd3JvdGU6Cj4gPiA+ID4gPiBPbiBGcmksIE1hciAyNCwgMjAyMyBhdCA5OjI2
4oCvQU0gUm9iZXJ0byBTYXNzdQo+ID4gPiA+ID4gPHJvYmVydG8uc2Fzc3VAaHVhd2VpY2xvdWQu
Y29tPiB3cm90ZToKPiA+ID4gPiA+ID4gT24gRnJpLCAyMDIzLTAzLTI0IGF0IDExOjE4ICswMTAw
LCBSb2JlcnRvIFNhc3N1IHdyb3RlOgo+ID4gPiA+ID4gPiA+IE9uIFRodSwgMjAyMy0wMy0yMyBh
dCAyMDowOSAtMDQwMCwgUGF1bCBNb29yZSB3cm90ZToKPiA+ID4gPiA+ID4gPiA+IE9uIFR1ZSwg
TWFyIDE0LCAyMDIzIGF0IDQ6MTnigK9BTSBSb2JlcnRvIFNhc3N1Cj4gPiA+ID4gPiA+ID4gPiA8
cm9iZXJ0by5zYXNzdUBodWF3ZWljbG91ZC5jb20+IHdyb3RlOgo+ID4gPiA+ID4gPiA+ID4gPiBG
cm9tOiBSb2JlcnRvIFNhc3N1IDxyb2JlcnRvLnNhc3N1QGh1YXdlaS5jb20+Cj4gCj4gLi4uCj4g
Cj4gPiA+IE9rYXksIHRoYXQncyBmYWlyLCBidXQgd2UgY291bGQgc3RpbGwgcGFzcyB0aGUgZnVs
bCB4YXR0cnMgYXJyYXkgYW5kIGEKPiA+ID4gcmVmZXJlbmNlIHRvIHRoZSBjdXJyZW50IGNvdW50
IHdoaWNoIGNvdWxkIGJlIGJvdGggcmVhZCBhbmQgdXBkYXRlZCBieQo+ID4gPiB0aGUgaW5kaXZp
ZHVhbCBMU01zLCByaWdodD8KPiA+IAo+ID4gWWVzLCB3ZSBjb3VsZCBkby4KPiA+IAo+ID4gPiBU
aGUgaXNzdWUgaXMgdGhhdCB0aGUgc2VwYXJhdGUgY29tcGFjdGlvbiBzdGFnZSBpcyBub3Qgc29t
ZXRoaW5nIHdlCj4gPiA+IHdhbnQgdG8gaGF2ZSB0byBkbyBpZiB3ZSBjYW4gYXZvaWQgaXQuICBN
YXliZSB3ZSdyZSBzdHVjayB3aXRoIGl0LCBidXQKPiA+ID4gSSdtIG5vdCB5ZXQgY29udmluY2Vk
IHRoYXQgd2UgY2FuJ3QgbWFrZSBzb21lIG1pbm9yIGNoYW5nZXMgdG8gdGhlCj4gPiA+IExTTXMg
dG8gYXZvaWQgdGhlIGNvbXBhY3Rpb24gc3RlcC4KPiA+IAo+ID4gSSBsaWtlZCBtb3JlIHRoZSBp
ZGVhIHRoYXQgTFNNcyBkbyB3aGF0IHRoZXkgYXJlIG1vc3QgZmFtaWxpYXIgd2l0aCwKPiA+IGdl
dCBhbiBvZmZzZXQgaW4gYSBzZWN1cml0eSBibG9iIG9yLCBpbiB0aGlzIGNhc2UsIGEgc3RhcnRp
bmcgc2xvdCBpbgo+ID4gdGhlIG5ld194YXR0cnMgYXJyYXksIGFuZCB3cml0ZSB0aGVyZS4KPiA+
IAo+ID4gdjMgaGFkIHRoZSBsc21fZmluZF94YXR0cl9zbG90KCkgaGVscGVyLCB0byBnZXQgdGhl
IHN0YXJ0aW5nIHNsb3QsIGJ1dAo+ID4gc29tZWhvdyBJIGZpbmQgaXQgbGVzcyBpbnR1aXRpdmUu
Cj4gPiAKPiA+IE9rLCBpZiB5b3UgcHJlZmVyIHRvIGF2b2lkIHRoZSBjb21wYWN0aW9uIHN0YWdl
LCBJIHdpbGwgcmV3cml0ZSB0aGlzCj4gPiBwYXRjaC4KPiAKPiBNeSBjb25jZXJuIGlzIGhhdmlu
ZyB0byBsb29rIHRocm91Z2ggdGhlIHhhdHRyIGFycmF5IGFmdGVyIGVhY2ggTFNNCj4gaGFzIGJl
ZW4gcnVuIGFuZCBpbiBhdCBsZWFzdCBvbmUgY2FzZSBoYXZpbmcgdG8gdGhlbiBkbyBhIG1lbWNw
eSgpIHRvCj4ga2VlcCB0aGUgYXJyYXkgcGFja2VkLiAgVGhlcmUgYXJlIHNvbWUgY2FzZXMgd2hl
cmUgdGhlcmUgaXMgbm8gd2F5IHRvCj4gYXZvaWQgYWxsIHRoYXQgZXh0cmEgd29yaywgYnV0IGhl
cmUgSSB0aGluayB3ZSBoYXZlIHRoZSBMU01zIGRvIHRoZQo+IFJpZ2h0IFRoaW5nIHdpdGggcmVz
cGVjdCB0byBwYWNraW5nIHRoZSB4YXR0ciBhcnJheSB3aXRob3V0IG92ZXJseQo+IGJ1cmRlbmlu
ZyB0aGUgaW5kaXZpZHVhbCBMU01zLgo+IAo+IERvZXMgdGhhdCBtYWtlIHNlbnNlPyAgSXQgYmFz
aWNhbGx5IGNvbWVzIGRvd24gdG8gYmVpbmcgc21hcnQgYWJvdXQKPiBvdXIgYWJzdHJhY3Rpb25z
IGFuZCBib3RoIHNlbGVjdGl2ZWx5LCBhbmQgY2FyZWZ1bGx5LCBicmVha2luZyB0aGVtCj4gd2hl
biB0aGVyZSBpcyBhIHJlYXNvbmFibGUgcGVyZm9ybWFuY2UgZ2FpbiB0byBiZSBoYWQuCgpZZXMs
IG9rLCBpdCBpcyBhIGdvb2QgYXBwcm9hY2guCgpUaGFua3MKClJvYmVydG8KCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5n
IGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9t
YWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
