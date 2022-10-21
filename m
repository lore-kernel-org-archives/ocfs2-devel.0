Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C36A6C4332F
	for <ocfs2-devel@archiver.kernel.org>; Fri, 21 Oct 2022 09:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=IVorKPQD2bw9P6WfnR3E3iJpnyzIicjf3lcSI9Dfoqw=;
 b=n0Roe6NKZYsnII7z0jxkwiimT46K7AQrc4avTuqRGBvYM1ZFMOXSSDqUBDGdtWbZwv9qeP2FXg6Z
   YK4tD908vYb4/9Hpo8o/T9vgFNopSU1WDLY2odon7ggswRu/gX8aoTMStFkqqLHaHSa+xT/5Qhl2
   9eETNOSoxHCpm7JZySFpKMdQ2xaX3IknKbH43mljZcRGNmxZxk1TRDhBQwaKX0cb783toi1jpNHx
   EEJLfW7Kur88JZquk5dU1HmoAA4X3srh+vSjEUbZAM33jlrn3u7zIzGcv9ELI/MTeTlR/2OaCXnM
   9HTw0vcz+Vn0k+bTkUQJ98EmPRQEOYwXVTHE1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=IVorKPQD2bw9P6WfnR3E3iJpnyzIicjf3lcSI9Dfoqw=;
 b=hEO3Iue5Jb9t8zZw2+rwPJ6N/u719vWAQS/ZMy6d2DHvQ0pQuIf1Tix9fncs+hgV5B3YamjaYIBc
   4ersq0suK+6KWzfjc+5k54zanJc6UeutqEZ/PKugUppPZLMQv1udbEdbghJRYlFohMLK8jc3+r/P
   EcYUkiYOdEeWzG2EK6m1NiAOcRMz5x5ba92Xs3FPuTufLSWOmgxWsf9kL7EdnWZAlRJAWMX/vQ6s
   VVnZEsNwN8JALJ25x0Qw3AuA8VUVtMqaO/ZAVJl7tHLvWel0bkh0/2P4IK9Qt9BcyhMRHi+JL/xq
   Fgy/U1NHs1qXtMlCCVzJchZq/5SNZ+hQwwThOQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK30060EJHB1400@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 21 Oct 2022 09:24:47 +0000 (GMT)
To: Greg KH <gregkh@linuxfoundation.org>
References: <20221021022102.2231464-1-yangyingliang@huawei.com>
 <d559793a-0ce4-3384-e74e-19855aa31f31@amd.com> <Y1IwLOUGayjT9p6d@kroah.com>
 <0591e66f-731a-5f81-fc9d-3a6d80516c65@huawei.com> <Y1JZ9IUPL6jZIQ8E@kroah.com>
Message-id: <1f3aa2ac-fba6-dc7a-d01d-7dd5331c8dc5@huawei.com>
Date: Fri, 21 Oct 2022 17:12:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-version: 1.0
In-reply-to: <Y1JZ9IUPL6jZIQ8E@kroah.com>
Content-language: en-US
X-Originating-IP: [10.174.178.174]
X-Source-IP: 45.249.212.188
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10506
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 bulkscore=0 adultscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=292
 clxscore=37 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210053 domainage_hfrom=8319
Cc: rafael@kernel.org, qemu-devel@nongnu.org, liushixin2@huawei.com,
 linux-mtd@lists.infradead.org, huangjianan@oppo.com, richard@nod.at,
 mst@redhat.com, amd-gfx@lists.freedesktop.org,
 Luben Tuikov <luben.tuikov@amd.com>, hsiangkao@linux.alibaba.com,
 somlo@cmu.edu, chao@kernel.org, jaegeuk@kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 alexander.deucher@amd.com, linux-erofs@lists.ozlabs.org,
 ocfs2-devel@oss.oracle.com
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
X-Proofpoint-GUID: ulcP2cI0xJFFgHiwLEdt-vHli1wDq7nC
X-Proofpoint-ORIG-GUID: ulcP2cI0xJFFgHiwLEdt-vHli1wDq7nC
Reporting-Meta:
 AAE0ge1TtTUf6vrUgg+kKlXjS9vhxzm5zbgBpbZpF9YjLe6QSZp4+1hk3B59ICmy
 yeJAevZ8V5zvjAo7/8Sg8kE4tlRJe2UALTWIV3eQFr/tYPK6M9ecX00eC5pjjJ+Y
 mA7LK0HY9Il35jeTaCxOfdURshb6SUbh2wfODK2BrksnK3IbVZ91i0ESQ7CcsIHd
 ZjD5twoZwvuG3TRe4gdQtV68FYM/AUKu0dbpud//EU/lQDiy1EXZ3uiXl127KjQd
 ykXdzLpW4ebsXVvTykoGIdAmwSiRG5GrdoXTDed7sX5RFw/kOKLBbuesqA6+w7zE
 gkPMhaK0oKylw2o/FUvG9LZpPU3KvJpN1CP2t1upvWor5ch7ltYcLcGF80S9SUiI
 5tHshVw0bx1PvA0+0JIVoMf+YDfGplbl3BRqXzmMVLHMw4M7CLbF3FrQmekBWI8s
 rvki6ZV6r8IPNx5MJg+6o6DlmNqlmM0xFdgkH/MjbfbDjPsJ3sKNYt+ejMrdjUz0
 NnIsm48Ry64ZX1Yd7CtbxHECg3Ksf0eZlylvRfPn91A=

Ck9uIDIwMjIvMTAvMjEgMTY6MzYsIEdyZWcgS0ggd3JvdGU6Cj4gT24gRnJpLCBPY3QgMjEsIDIw
MjIgYXQgMDQ6MjQ6MjNQTSArMDgwMCwgWWFuZyBZaW5nbGlhbmcgd3JvdGU6Cj4+IE9uIDIwMjIv
MTAvMjEgMTM6MzcsIEdyZWcgS0ggd3JvdGU6Cj4+PiBPbiBGcmksIE9jdCAyMSwgMjAyMiBhdCAw
MToyOTozMUFNIC0wNDAwLCBMdWJlbiBUdWlrb3Ygd3JvdGU6Cj4+Pj4gT24gMjAyMi0xMC0yMCAy
MjoyMCwgWWFuZyBZaW5nbGlhbmcgd3JvdGU6Cj4+Pj4+IFRoZSBwcmV2aW91cyBkaXNjdXNzaW9u
IGxpbms6Cj4+Pj4+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMGRiNDg2ZWItNjkyNy05
MjdlLTM2MjktOTU4ZjhmMjExMTk0QGh1YXdlaS5jb20vVC8KPj4+PiBUaGUgdmVyeSBmaXJzdCBk
aXNjdXNzaW9uIG9uIHRoaXMgd2FzIGhlcmU6Cj4+Pj4KPj4+PiBodHRwczovL3d3dy5zcGluaWNz
Lm5ldC9saXN0cy9kcmktZGV2ZWwvbXNnMzY4MDc3Lmh0bWwKPj4+Pgo+Pj4+IFBsZWFzZSB1c2Ug
dGhpcyBsaW5rLCBhbmQgbm90IHRoZSB0aGF0IG9uZSB1cCB0aGVyZSB5b3Ugd2hpY2ggcXVvdGVk
IGFib3ZlLAo+Pj4+IGFuZCB3aG9zZSBjb21taXQgZGVzY3JpcHRpb24gaXMgdGFrZW4gdmVyYmF0
aW0gZnJvbSB0aGUgdGhpcyBsaW5rLgo+Pj4+Cj4+Pj4+IGtzZXRfcmVnaXN0ZXIoKSBpcyBjdXJy
ZW50bHkgdXNlZCBpbiBzb21lIHBsYWNlcyB3aXRob3V0IGNhbGxpbmcKPj4+Pj4ga3NldF9wdXQo
KSBpbiBlcnJvciBwYXRoLCBiZWNhdXNlIHRoZSBjYWxsZXJzIHRoaW5rIGl0IHNob3VsZCBiZQo+
Pj4+PiBrc2V0IGludGVybmFsIHRoaW5nIHRvIGRvLCBidXQgdGhlIGRyaXZlciBjb3JlIGNhbiBu
b3Qga25vdyB3aGF0Cj4+Pj4+IGNhbGxlciBkb2luZyB3aXRoIHRoYXQgbWVtb3J5IGF0IHRpbWVz
LiBUaGUgbWVtb3J5IGNvdWxkIGJlIGZyZWVkCj4+Pj4+IGJvdGggaW4ga3NldF9wdXQoKSBhbmQg
ZXJyb3IgcGF0aCBvZiBjYWxsZXIsIGlmIGl0IGlzIGNhbGxlZCBpbgo+Pj4+PiBrc2V0X3JlZ2lz
dGVyKCkuCj4+Pj4gQXMgSSBleHBsYWluZWQgaW4gdGhlIGxpbmsgYWJvdmUsIHRoZSByZWFzb24g
dGhlcmUncwo+Pj4+IGEgbWVtb3J5IGxlYWsgaXMgdGhhdCBvbmUgY2Fubm90IGNhbGwga3NldF9y
ZWdpc3RlcigpIHdpdGhvdXQKPj4+PiB0aGUga3NldC0+a29iai5uYW1lIGJlaW5nIHNldC0ta29i
al9hZGRfaW50ZXJuYWwoKSByZXR1cm5zIC1FSU5WQUwsCj4+Pj4gaW4gdGhpcyBjYXNlLCBpLmUu
IGtzZXRfcmVnaXN0ZXIoKSBmYWlscyB3aXRoIC1FSU5WQUwuCj4+Pj4KPj4+PiBUaHVzLCB0aGUg
bW9zdCBjb21tb24gdXNhZ2UgaXMgc29tZXRoaW5nIGxpa2UgdGhpczoKPj4+Pgo+Pj4+IAlrb2Jq
X3NldF9uYW1lKCZrc2V0LT5rb2JqLCBmb3JtYXQsIC4uLik7Cj4+Pj4gCWtzZXQtPmtvYmoua3Nl
dCA9IHBhcmVudF9rc2V0Owo+Pj4+IAlrc2V0LT5rb2JqLmt0eXBlID0ga3R5cGU7Cj4+Pj4gCXJl
cyA9IGtzZXRfcmVnaXN0ZXIoa3NldCk7Cj4+Pj4KPj4+PiBTbywgd2hhdCBpcyBiZWluZyBsZWFr
ZWQsIGlzIHRoZSBtZW1vcnkgYWxsb2NhdGVkIGluIGtvYmpfc2V0X25hbWUoKSwKPj4+PiBieSB0
aGUgY29tbW9uIGlkaW9tIHNob3duIGFib3ZlLiBUaGlzIG5lZWRzIHRvIGJlIG1lbnRpb25lZCBp
bgo+Pj4+IHRoZSBkb2N1bWVudGF0aW9uLCBhdCBsZWFzdCwgaW4gY2FzZSwgaW4gdGhlIGZ1dHVy
ZSB0aGlzIGlzIGFic29sdmVkCj4+Pj4gaW4ga3NldF9yZWdpc3RlcigpIHJlZGVzaWduLCBldGMu
Cj4+PiBCYXNlZCBvbiB0aGlzLCBjYW4ga3NldF9yZWdpc3RlcigpIGp1c3QgY2xlYW4gdXAgZnJv
bSBpdHNlbGYgd2hlbiBhbgo+Pj4gZXJyb3IgaGFwcGVucz8gIElkZWFsbHkgdGhhdCB3b3VsZCBi
ZSB0aGUgY2FzZSwgYXMgdGhlIG9kZHMgb2YgYSBrc2V0Cj4+PiBiZWluZyBlbWJlZGRlZCBpbiBh
IGxhcmdlciBzdHJ1Y3R1cmUgaXMgcHJvYmFibHkgc2xpbSwgYnV0IHdlIHdvdWxkIGhhdmUKPj4+
IHRvIHNlYXJjaCB0aGUgdHJlZSB0byBtYWtlIHN1cmUuCj4+IEkgaGF2ZSBzZWFyY2ggdGhlIHdo
b2xlIHRyZWUsIHRoZSBrc2V0IHVzZWQgaW4gYnVzX3JlZ2lzdGVyKCkgLSBwYXRjaCAjMywKPj4g
a3NldF9jcmVhdGVfYW5kX2FkZCgpIC0gcGF0Y2ggIzQKPj4gX19jbGFzc19yZWdpc3RlcigpIC0g
cGF0Y2ggIzUswqAgZndfY2ZnX2J1aWxkX3N5bWxpbmsoKSAtIHBhdGNoICM2IGFuZAo+PiBhbWRn
cHVfZGlzY292ZXJ5LmMgLSBwYXRjaCAjMTAKPj4gaXMgZW1iZWRkZWQgaW4gYSBsYXJnZXIgc3Ry
dWN0dXJlLiBJbiB0aGVzZSBjYXNlcywgd2UgY2FuIG5vdCBjYWxsCj4+IGtzZXRfcHV0KCkgaW4g
ZXJyb3IgcGF0aCBpbiBrc2V0X3JlZ2lzdGVyKCkKPiBZZXMgeW91IGNhbiBhcyB0aGUga29iamVj
dCBpbiB0aGUga3NldCBzaG91bGQgTk9UIGJlIGNvbnRyb2xpbmcgdGhlCj4gbGlmZXNwYW4gb2Yg
dGhvc2UgbGFyZ2VyIG9iamVjdHMuClJlYWQgdGhyb3VnaCB0aGUgY29kZSB0aGUgb25seSBsZWFr
IGluIHRoaXMgY2FzZSBpcyB0aGUgbmFtZSwgc28gY2FuIHdlIApmcmVlIGl0CmRpcmVjdGx5IGlu
IGtzZXRfcmVnaXN0ZXIoKToKCi0tLSBhL2xpYi9rb2JqZWN0LmMKKysrIGIvbGliL2tvYmplY3Qu
YwpAQCAtODQ0LDggKzg0NCwxMSBAQCBpbnQga3NldF9yZWdpc3RlcihzdHJ1Y3Qga3NldCAqaykK
CiDCoMKgwqDCoMKgwqDCoCBrc2V0X2luaXQoayk7CiDCoMKgwqDCoMKgwqDCoCBlcnIgPSBrb2Jq
ZWN0X2FkZF9pbnRlcm5hbCgmay0+a29iaik7Ci3CoMKgwqDCoMKgwqAgaWYgKGVycikKK8KgwqDC
oMKgwqDCoCBpZiAoZXJyKSB7CivCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGtmcmVlX2Nv
bnN0KGstPmtvYmoubmFtZSk7CivCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGstPmtvYmou
bmFtZSA9IE5VTEw7CiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIGVycjsK
K8KgwqDCoMKgwqDCoCB9CiDCoMKgwqDCoMKgwqDCoCBrb2JqZWN0X3VldmVudCgmay0+a29iaiwg
S09CSl9BREQpOwogwqDCoMKgwqDCoMKgwqAgcmV0dXJuIDA7CiDCoH0KCm9yIHVuc2V0IGt0eXBl
IG9mIGtvYmplY3QsIHRoZW4gY2FsbCBrc2V0X3B1dCgpOgoKLS0tIGEvbGliL2tvYmplY3QuYwor
KysgYi9saWIva29iamVjdC5jCkBAIC04NDQsOCArODQ0LDExIEBAIGludCBrc2V0X3JlZ2lzdGVy
KHN0cnVjdCBrc2V0ICprKQoKIMKgwqDCoMKgwqDCoMKgIGtzZXRfaW5pdChrKTsKIMKgwqDCoMKg
wqDCoMKgIGVyciA9IGtvYmplY3RfYWRkX2ludGVybmFsKCZrLT5rb2JqKTsKLcKgwqDCoMKgwqDC
oCBpZiAoZXJyKQorwqDCoMKgwqDCoMKgIGlmIChlcnIpIHsKK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgay0+a29iai5rdHlwZSA9IE5VTEw7CivCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIGtzZXRfcHV0KGspOwogwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiBl
cnI7CivCoMKgwqDCoMKgwqAgfQogwqDCoMKgwqDCoMKgwqAga29iamVjdF91ZXZlbnQoJmstPmtv
YmosIEtPQkpfQUREKTsKIMKgwqDCoMKgwqDCoMKgIHJldHVybiAwOwogwqB9Cgo+Cj4gSWYgaXQg
aXMsIHBsZWFzZSBwb2ludCBvdXQgdGhlIGNhbGwgY2hhaW4gaGVyZSBhcyBJIGRvbid0IHRoaW5r
IHRoYXQKPiBzaG91bGQgYmUgcG9zc2libGUuCj4KPiBOb3RlIGFsbCBvZiB0aGlzIGlzIGEgbWVz
cyBiZWNhdXNlIHRoZSBrb2JqZWN0IG5hbWUgc3R1ZmYgd2FzIGFkZGVkIG11Y2gKPiBsYXRlciwg
YWZ0ZXIgdGhlIGRyaXZlciBtb2RlbCBoYWQgYmVlbiBjcmVhdGVkIGFuZCBydW5uaW5nIGZvciBh
IHdoaWxlLgo+IFdlIG1pc3NlZCB0aGlzIGVycm9yIHBhdGggd2hlbiBhZGRpbmcgdGhlIGR5bmFt
aWMga29iamVjdCBuYW1lIGxvZ2ljLAo+IHRoYW5rIGZvciBsb29raW5nIGludG8gdGhpcy4KPgo+
IElmIHlvdSBjb3VsZCB0ZXN0IHRoZSBwYXRjaCBwb3N0ZWQgd2l0aCB5b3VyIGVycm9yIGluamVj
dGlvbiBzeXN0ZW1zLAo+IHRoYXQgY291bGQgbWFrZSB0aGlzIGFsbCBtdWNoIHNpbXBsZXIgdG8g
c29sdmUuCj4KPiB0aGFua3MsCj4KPiBncmVnIGstaAo+IC4KCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2Zz
Mi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlz
dGluZm8vb2NmczItZGV2ZWw=
