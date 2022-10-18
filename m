Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53EDAC4332F
	for <ocfs2-devel@archiver.kernel.org>; Tue, 18 Oct 2022 14:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=YuLPBsAFwKFgwPUv5stn5z2C8mWsoI1/JgsuR12oqfE=;
 b=PxhqZMTP8JDPegGC1/CIhoQWAVXLdDMxlsGLozSWuMxl4BKw4nrdrilfl6SQZXLfAgLlY8VPle9L
   LYKQ6EYPrOYaosl2vpnaSpXbfLHJeL5zQbk28ixdtxiCW0jXWOvqGRINO0bS2PPYCttGp5irj0vQ
   /63HGAfKR4jOiLTCw/+0iGewootCAMNpUYajm2NJCEv5Hxx4MwCPlE0uSM9mlf+rfDcC8x1v7N1t
   jWhgu9oLo0HjcsJ1eAqfW2YbzslIe28N079VItOKMo6poUz294nGPTMd6qSVBqDd7f0qngyl6dEo
   0MGQ+fxs8CfnekVQMgwX0YIrMSdvTBXGwtHiUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=YuLPBsAFwKFgwPUv5stn5z2C8mWsoI1/JgsuR12oqfE=;
 b=RmlU2Lg6Xq+Zp3BmexP4n0Y+xhbt65mhhkHxNmjREtRyXfGt3d7PVc0U0CvdMQk1Kudst8AucwAE
   EPnO/y47l/SksjBkiLWbDFE5teSSr4StbAdT8KcGK4a8RGnekq1H6lxh6RUV54pbYsRpHuQh172G
   UfLRGSqiJhIf5XCS1P5VCQBAz81PZuRTma/fHmUB0hs1cTM5jzcOPFL+WRMBWIIRbt4y1MYhbj0c
   NTG/zGOVj1F6bPqNyYXWlC3qBJKGZ2A1tKmRz4oGzIGFrsgJf8qk1LT086ViFqI0IcaJ4j6QhXSh
   RjjmFolj+qGLJ0HhEozCPj6QBVCBEdgwrcnW1w==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RJY003V0DK3FX70@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 18 Oct 2022 14:28:51 +0000 (GMT)
To: Joseph Qi <joseph.qi@linux.alibaba.com>, <linux-kernel@vger.kernel.org>,
 <ocfs2-devel@oss.oracle.com>
References: <20221018075213.736562-1-yangyingliang@huawei.com>
 <bf27f347-5ced-98e5-f188-659cc2a9736f@linux.alibaba.com>
 <09bb2844-e20a-98e8-c2af-5b6c4795d48e@huawei.com>
 <c7a3bdac-3ed6-e695-5c45-e7007615a4d9@linux.alibaba.com>
Message-id: <0db486eb-6927-927e-3629-958f8f211194@huawei.com>
Date: Tue, 18 Oct 2022 22:28:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-version: 1.0
In-reply-to: <c7a3bdac-3ed6-e695-5c45-e7007615a4d9@linux.alibaba.com>
Content-language: en-US
X-Originating-IP: [10.174.178.174]
X-Source-IP: 45.249.212.255
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10504
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=-101
 priorityscore=1501 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210180082 domainage_hfrom=8316
Cc: gregkh@linuxfoundation.org
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: possible memory leak in
	mlog_sys_init()
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
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-ServerName: szxga08-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-GUID: pQ542ZEVGaPa_n3DZ_AwRFMiQHydnT4J
X-Proofpoint-ORIG-GUID: pQ542ZEVGaPa_n3DZ_AwRFMiQHydnT4J
Reporting-Meta:
 AAEkaJs3TA8LwpGFPCgo6X/tCZfX1p0B1OouXmoTT/H5PIJ23BTRmRgVCfy2nNMv
 EdD7sbbcQcJhCK3zDRokZvA0zVm9rNUtBp3eHev3cssbwxOWc9a30tVO5w1aZKrV
 OXahOBHrrP5CIIQbxuSUnpEv2ZPru4dMzGssev3PsQkeBbITp0wdEkT5WcPA0C8W
 hlHqaQ4iQblk4pvvRVEQkjN49xGBVyzlKNXGxCncEZ0l/4SNuoOcsHi3aCmrx9uZ
 CiotiXC9+XhB7JDPBcQg7RPsAic9crND4BJU7M5S1Z+VbDzXRAEBR4ouC5SbEvgb
 p0iCo3N1ZrfElZoDfJL9rpWJ+kdmL0Wl+s4rfLyfjJtAFNIsTdakEJtC6K1mMywF
 d2OxMLB/Lqzek1BEdMuwgo/fqtVzmoI+IRhKHa81DD9s6H7WoyP03GJ9cnjd+GBD
 gQDCxsEF90SV13WeUaLHyJ7scifBppkYYdz07vgJU7FFm+as1H/ATg/s22StzTOm
 AORgKB6tqmvCE8o2GtX1D5OgZgrskw704fUexKq0CM4=

Ck9uIDIwMjIvMTAvMTggMjE6MzksIEpvc2VwaCBRaSB3cm90ZToKPgo+IE9uIDEwLzE4LzIyIDY6
MzMgUE0sIFlhbmcgWWluZ2xpYW5nIHdyb3RlOgo+PiBIaSwKPj4KPj4gT24gMjAyMi8xMC8xOCAx
NzowMiwgSm9zZXBoIFFpIHdyb3RlOgo+Pj4gSGksCj4+Pgo+Pj4gT24gMTAvMTgvMjIgMzo1MiBQ
TSwgWWFuZyBZaW5nbGlhbmcgd3JvdGU6Cj4+Pj4gSW5qZWN0IGZhdWx0IHdoaWxlIHByb2Jpbmcg
bW9kdWxlLCBrc2V0X3JlZ2lzdGVyKCkgbWF5IGZhaWwsCj4+Pj4gaWYgaXQgZmFpbHMsIGJ1dCB0
aGUgcmVmY291bnQgb2Yga29iamVjdCBpcyBub3QgZGVjcmVhc2VkIHRvCj4+Pj4gMCwgdGhlIG5h
bWUgYWxsb2NhdGVkIGluIGtvYmplY3Rfc2V0X25hbWUoKSBpcyBsZWFrZWQuIEZpeAo+Pj4+IHRo
aXMgYnkgY2FsbGluZyBrc2V0X3B1dCgpLCBzbyB0aGF0IG5hbWUgY2FuIGJlIGZyZWVkIGluCj4+
Pj4gY2FsbGJhY2sgZnVuY3Rpb24ga29iamVjdF9jbGVhbnVwKCkuCj4+Pj4KPj4+PiB1bnJlZmVy
ZW5jZWQgb2JqZWN0IDB4ZmZmZjg4ODEwMGRhOTM0OCAoc2l6ZSA4KToKPj4+PiAgwqDCoCBjb21t
ICJtb2Rwcm9iZSIsIHBpZCAyNTcsIGppZmZpZXMgNDI5NDcwMTA5NiAoYWdlIDMzLjMzNHMpCj4+
Pj4gIMKgwqAgaGV4IGR1bXAgKGZpcnN0IDggYnl0ZXMpOgo+Pj4+ICDCoMKgwqDCoCA2YyA2ZiA2
NyA2ZCA2MSA3MyA2YiAwMMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGxvZ21hc2suCj4+Pj4gIMKgwqAgYmFja3RyYWNlOgo+Pj4+ICDCoMKgwqDCoCBb
PDAwMDAwMDAwMzA2ZTQ0MWM+XSBfX2ttYWxsb2Nfbm9kZV90cmFja19jYWxsZXIrMHg0NC8weDFi
MAo+Pj4+ICDCoMKgwqDCoCBbPDAwMDAwMDAwN2M0OTFhOWU+XSBrc3RyZHVwKzB4M2EvMHg3MAo+
Pj4+ICDCoMKgwqDCoCBbPDAwMDAwMDAwMTU3MTlhM2I+XSBrc3RyZHVwX2NvbnN0KzB4NjMvMHg4
MAo+Pj4+ICDCoMKgwqDCoCBbPDAwMDAwMDAwODRlNDU4ZWE+XSBrdmFzcHJpbnRmX2NvbnN0KzB4
MTQ5LzB4MTgwCj4+Pj4gIMKgwqDCoMKgIFs8MDAwMDAwMDA5MTMwMmI0Mj5dIGtvYmplY3Rfc2V0
X25hbWVfdmFyZ3MrMHg1Ni8weDE1MAo+Pj4+ICDCoMKgwqDCoCBbPDAwMDAwMDAwNWY0OGVlYWM+
XSBrb2JqZWN0X3NldF9uYW1lKzB4YWIvMHhlMAo+Pj4+Cj4+Pj4gRml4ZXM6IDM0OTgwY2E4ZmFl
YiAoIkRyaXZlcnM6IGNsZWFuIHVwIGRpcmVjdCBzZXR0aW5nIG9mIHRoZSBuYW1lIG9mIGEga3Nl
dCIpCj4+Pj4gU2lnbmVkLW9mZi1ieTogWWFuZyBZaW5nbGlhbmcgPHlhbmd5aW5nbGlhbmdAaHVh
d2VpLmNvbT4KPj4+PiAtLS0KPj4+PiAgwqAgZnMvb2NmczIvY2x1c3Rlci9tYXNrbG9nLmMgfCA3
ICsrKysrKy0KPj4+PiAgwqAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMSBkZWxl
dGlvbigtKQo+Pj4+Cj4+Pj4gZGlmZiAtLWdpdCBhL2ZzL29jZnMyL2NsdXN0ZXIvbWFza2xvZy5j
IGIvZnMvb2NmczIvY2x1c3Rlci9tYXNrbG9nLmMKPj4+PiBpbmRleCA1NjM4ODFkZGJmMDAuLjdm
OWJhODE2ZDk1NSAxMDA2NDQKPj4+PiAtLS0gYS9mcy9vY2ZzMi9jbHVzdGVyL21hc2tsb2cuYwo+
Pj4+ICsrKyBiL2ZzL29jZnMyL2NsdXN0ZXIvbWFza2xvZy5jCj4+Pj4gQEAgLTE1Niw2ICsxNTYs
NyBAQCBzdGF0aWMgc3RydWN0IGtzZXQgbWxvZ19rc2V0ID0gewo+Pj4+ICDCoCBpbnQgbWxvZ19z
eXNfaW5pdChzdHJ1Y3Qga3NldCAqbzJjYl9rc2V0KQo+Pj4+ICDCoCB7Cj4+Pj4gIMKgwqDCoMKg
wqAgaW50IGkgPSAwOwo+Pj4+ICvCoMKgwqAgaW50IHJldDsKPj4+PiAgwqAgwqDCoMKgwqDCoCB3
aGlsZSAobWxvZ19hdHRyc1tpXS5hdHRyLm1vZGUpIHsKPj4+PiAgwqDCoMKgwqDCoMKgwqDCoMKg
IG1sb2dfZGVmYXVsdF9hdHRyc1tpXSA9ICZtbG9nX2F0dHJzW2ldLmF0dHI7Cj4+Pj4gQEAgLTE2
NSw3ICsxNjYsMTEgQEAgaW50IG1sb2dfc3lzX2luaXQoc3RydWN0IGtzZXQgKm8yY2Jfa3NldCkK
Pj4+PiAgwqAgwqDCoMKgwqDCoCBrb2JqZWN0X3NldF9uYW1lKCZtbG9nX2tzZXQua29iaiwgImxv
Z21hc2siKTsKPj4+PiAgwqDCoMKgwqDCoCBtbG9nX2tzZXQua29iai5rc2V0ID0gbzJjYl9rc2V0
Owo+Pj4+IC3CoMKgwqAgcmV0dXJuIGtzZXRfcmVnaXN0ZXIoJm1sb2dfa3NldCk7Cj4+Pj4gK8Kg
wqDCoCByZXQgPSBrc2V0X3JlZ2lzdGVyKCZtbG9nX2tzZXQpOwo+Pj4gSWYgcmVnaXN0ZXIgZmFp
bHMsIGl0IHdpbGwgY2FsbCB1bnJlZ2lzdGVyIGluIG8yY2Jfc3lzX2luaXQoKSwgd2hpY2gKPj4+
IHdpbGwgcHV0IGtvYmplY3QuCj4+IFRoZXkgYXJlIGRpZmZlcmVudCBrc2V0cywgdGhlIGtzZXQg
dW5yZWdpc3RlcmVkIGluIG8yY2Jfc3lzX2luaXQoKSBpcyAnbzJjYl9rc2V0JywgdGhlCj4+IGtz
ZXQgdXNlZCB0byByZWdpc3RlcmVkIGluIG1sb2dfc3lzX2luaXQoKSBpcyAnbWxvZ19rc2V0Jywg
YW5kIHRoZXkgaG9sZCBkaWZmZXJlbmNlCj4+IHJlZmNvdW50cy4KPj4gWWVzLCB5b3UgYXJlIHJp
Z2h0LiBJJ3ZlIG1peGVkIHRoZSB0d28ga3NldHMgdXAuCj4gSW4gdGhlb3J5LCBrc2V0X3JlZ2lz
dGVyKCkgbWF5IHJldHVybiBlcnJvciBiZWNhdXNlIG9mIGEgTlVMTCBrc2V0LCBzbwo+IGhlcmUg
d2UgbWF5IG5vdCBjYWxsIGtzZXRfcHV0KCkgZGlyZWN0bHksIEknbSBub3Qgc3VyZSBpZiBhIHN0
YXRpYwo+IGNoZWNrZXIgd2lsbCBoYXBweS4KPiBUaG91Z2ggdGhpcyBjYW4ndCBoYXBwZW4gc2lu
Y2UgaXQncyBhbHJlYWR5IHN0YXRpY2FsbHkgYWxsb2NhdGVkLi4uCmtzZXRfcmVnaXN0ZXIoKSBt
YXkgZmFpbCBpZiBrb2JqZWN0X2FkZF9pbnRlcm5hbCgpIHJldHVybiBlcnJvciAoY2FuJ3QgCmFs
bG9jYXRlIG1lbW9yeSksIHRoZSBuYW1lCiJsb2dtYXNrIiBpcyBkeW5hbWljYWxseSBhbGxvY3Rh
dGVkIHdoaWxlIG9jZnMyIGlzIGNvbXBpbGUgYXMgbW9kdWxlIGFuZCAKaW5zZXJ0IGl0IChpZiBv
Y2ZzMiBpcwpidWlsdCBpbiBrZXJuZWwsIHRoZSBuYW1lIGlzIGNvbnN0YW50LCBpdCB3b24ndCBj
YXVzZSBhIGxlYWspLCBzbyB0aGUgCm5hbWUgY2FuIGJlIGxlYWtlZC4KClRoYW5rcywKWWFuZwo+
Cj4gVGhhbmtzLAo+IEpvc2VwaAo+Cj4gLgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9z
cy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2Zz
Mi1kZXZlbA==
