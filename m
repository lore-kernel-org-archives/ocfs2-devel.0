Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA659C43334
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Jun 2022 01:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=dvLxAFLCMnqPmQTSvnAUxPB761DpxdiGdBoPVd7u3xk=;
 b=njPoxkFdIM8uUaop8h47uttCvcAdRHiKcIyoi0y9R9SXuGACs+wymlS5FjnPRVMQp8PjPtI68Mw1
   dX/TnsLdLihHH61IA7W4Hqim9b/CZCsDGM4T1irbpZ33VtkTsaTLLitNN2RbuGAJ9Eic5+B4PlbG
   zxji7DBIeXEYoeD5mCVD+5wh0NQH22RoNuTo89rU9apc+mqE7a/uXTSD1yYjFqE1UsXEO6nyeOIl
   4YE5fJEOo9gMz2L2lOQwI92sPj+fZAfcrZJZ7pbWpbvyPQjcke/z3uDzBOdrsoMjMRxP84hHw4zo
   FcodYEiTyaEUW8z3/PAkB1Qs6aEPt5yz3N4OLw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=dvLxAFLCMnqPmQTSvnAUxPB761DpxdiGdBoPVd7u3xk=;
 b=tW/cIrVT35slDeP+puhp1HXbpku+IMeb498QERlkjTNB9hjzUjIxSR56v6LKQ8E9mHXY77lcSZz7
   X+9P6H1+Y9o0boFzsRQflhhFnUg1z/EQDe7ctLWUxF+GBiMVXczQMhIOi3kPplM7T3r31yLt6TtM
   HZcKAmfE6GsnYPKcpO6wO3m8ks3N2pXB/GwSOsmgs0luen57xuDAb9q5SwJE35u38PCikRLv9mtU
   Uu+AjVNy/zIhJfoGp55DlRM0OttZ56PUNzCIrM6QpXWxl8nfV96A2Mb6h5+PtL5vUwDe1G9s2Vbg
   mLFq7SoalTri+Y+zyzloyIiXMlEbO1Ti4aWynw==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD300L6R3BZP8E0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Jun 2022 01:40:47 +0000 (GMT)
Message-id: <a6821b90-6d09-852e-2c45-795cd368c7e8@linux.alibaba.com>
Date: Tue, 7 Jun 2022 09:40:31 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Content-language: en-US
To: Junxiao Bi <junxiao.bi@oracle.com>, ocfs2-devel@oss.oracle.com
References: <20220603223122.43174-1-junxiao.bi@oracle.com>
 <ba010e81-5ac8-79f5-61c0-5aac46068388@linux.alibaba.com>
 <c0902ca6-e6d1-a8fa-cb9c-4474a636bd18@oracle.com>
In-reply-to: <c0902ca6-e6d1-a8fa-cb9c-4474a636bd18@oracle.com>
X-Source-IP: 47.90.199.18
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 clxscore=118 suspectscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=0 phishscore=0 spamscore=0 impostorscore=0 malwarescore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206070005 domainage_hfrom=8454
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: kill EBUSY from dlmfs_evict_inode
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R211e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04423;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0VFbHY2x_1654566031;
X-ServerName: out199-18.us.a.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: jEpc547f2gCEjmHcnwlBEPCuCby7QDso
X-Proofpoint-GUID: jEpc547f2gCEjmHcnwlBEPCuCby7QDso
Reporting-Meta:
 AAGyQSU2S0hsWzbCAFeOs6VKfWgPcrgKVq7oP55gSyl2gQv5zshzWaJaL0BJszeR
 K5s/zZuFRSBwLcF93cTohE39+5v2wKuFiXsQn2qo3vbpwncXn9UDxTSobznL6Qau
 B4IitA5AFvaIsDdC74lxTS7HFKXdBjXfqixoaoxANJJFRuofyW0ktfKqX4juF58X
 zVoil+lfXIo5r8u6mNUFjSgDa9IjvZtvLM7l2xy81TUz1NVSbGK9dsGT0Uhv2l1q
 alVXj2+p+gOltHdeJU2Za+r7uAIGUYsIJZS5RpzJvFTlBRnEhzTlPYpuj2A+j1X8
 HX8rKEEcl6dy5BteQfUJL1ARmulEKI44cGQDCUW4lEbxYr24Cok8dl3pqYDDucp9
 y8hdHNGNP4C8r47rR2zU/3/pAa1d+kQMtA015XAIlG8puUJC/pXw3ufPHoE5WqK2
 GeMiWVuVVYUAPLleyeZssYX92/He3CZXBSczoWqFME/Rxq28GaAjGLryZfZDuhLB
 nq+9VM+xuiSQ7lASRxO9gK7+Nx/DitWTFsIOvC/JWDFP

CgpPbiA2LzYvMjIgMTE6MzMgUE0sIEp1bnhpYW8gQmkgd3JvdGU6Cj4gT24gNi81LzIyIDY6NDYg
QU0sIEpvc2VwaCBRaSB3cm90ZToKPiAKPj4KPj4gT24gNi80LzIyIDY6MzEgQU0sIEp1bnhpYW8g
Qmkgd3JvdGU6Cj4+PiBXaGVuIHVubGluayBhIGRsbWZzLCBmaXJzdCBpdCB3aWxsIGludm9rZSBk
bG1mc191bmxpbmsoKSwgYW5kIHRoZW4gaW52b2tlCj4+PiBkbG1mc19ldmljdF9pbm9kZSgpLCB1
c2VyX2RsbV9kZXN0cm95X2xvY2soKSBpcyBpbnZva2VkIGluIGJvdGggcGxhY2VzLAo+Pj4gdGhl
IHNlY29uZCBvbmUgZnJvbSBkbG1mc19ldmljdF9pbm9kZSgpIHdpbGwgZ2V0IEVCVVNZIGVycm9y
IGJlY2F1c2UKPj4+IFVTRVJfTE9DS19JTl9URUFSRE9XTiBpcyBhbHJlYWR5IHNldCBpbiBsb2Nr
cmVzLiBUaGlzIGRvZXNuJ3QgYWZmZWN0Cj4+PiBhbnkgZnVuY3Rpb24sIGp1c3QgdGhlIGVycm9y
IGxvZyBpcyBhbm9ueWluZy4KPj4gcy9hbm9ueWluZy9hbm5veWluZwo+Pj4gU2lnbmVkLW9mZi1i
eTogSnVueGlhbyBCaSA8anVueGlhby5iaUBvcmFjbGUuY29tPgo+Pj4gLS0tCj4+PiDCoCBmcy9v
Y2ZzMi9kbG1mcy9kbG1mcy5jIHwgMTQgKysrKysrKysrKystLS0KPj4+IMKgIDEgZmlsZSBjaGFu
Z2VkLCAxMSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQo+Pj4KPj4+IGRpZmYgLS1naXQg
YS9mcy9vY2ZzMi9kbG1mcy9kbG1mcy5jIGIvZnMvb2NmczIvZGxtZnMvZGxtZnMuYwo+Pj4gaW5k
ZXggZTM2MDU0M2FkN2U3Li5hMTIwNjEwZGZmN2UgMTAwNjQ0Cj4+PiAtLS0gYS9mcy9vY2ZzMi9k
bG1mcy9kbG1mcy5jCj4+PiArKysgYi9mcy9vY2ZzMi9kbG1mcy9kbG1mcy5jCj4+PiBAQCAtMjk2
LDE3ICsyOTYsMjUgQEAgc3RhdGljIHZvaWQgZGxtZnNfZXZpY3RfaW5vZGUoc3RydWN0IGlub2Rl
ICppbm9kZSkKPj4+IMKgIHsKPj4+IMKgwqDCoMKgwqAgaW50IHN0YXR1czsKPj4+IMKgwqDCoMKg
wqAgc3RydWN0IGRsbWZzX2lub2RlX3ByaXZhdGUgKmlwOwo+Pj4gK8KgwqDCoCBzdHJ1Y3QgdXNl
cl9sb2NrX3JlcyAqbG9ja3JlczsKPj4+ICvCoMKgwqAgaW50IGRlc3Ryb3llZDsKPj4+IMKgIMKg
wqDCoMKgwqAgY2xlYXJfaW5vZGUoaW5vZGUpOwo+Pj4gwqAgwqDCoMKgwqDCoCBtbG9nKDAsICJp
bm9kZSAlbHVcbiIsIGlub2RlLT5pX2lubyk7Cj4+PiDCoCDCoMKgwqDCoMKgIGlwID0gRExNRlNf
SShpbm9kZSk7Cj4+PiArwqDCoMKgIGxvY2tyZXMgPSAmaXAtPmlwX2xvY2tyZXM7Cj4+PiDCoCDC
oMKgwqDCoMKgIGlmIChTX0lTUkVHKGlub2RlLT5pX21vZGUpKSB7Cj4+PiAtwqDCoMKgwqDCoMKg
wqAgc3RhdHVzID0gdXNlcl9kbG1fZGVzdHJveV9sb2NrKCZpcC0+aXBfbG9ja3Jlcyk7Cj4+PiAt
wqDCoMKgwqDCoMKgwqAgaWYgKHN0YXR1cyA8IDApCj4+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBtbG9nX2Vycm5vKHN0YXR1cyk7Cj4+PiArwqDCoMKgwqDCoMKgwqAgc3Bpbl9sb2NrKCZsb2Nr
cmVzLT5sX2xvY2spOwo+Pj4gK8KgwqDCoMKgwqDCoMKgIGRlc3Ryb3llZCA9ICEhKGxvY2tyZXMt
PmxfZmxhZ3MgJiBVU0VSX0xPQ0tfSU5fVEVBUkRPV04pOwo+Pj4gK8KgwqDCoMKgwqDCoMKgIHNw
aW5fdW5sb2NrKCZsb2NrcmVzLT5sX2xvY2spOwo+Pj4gK8KgwqDCoMKgwqDCoMKgIGlmICghZGVz
dHJveWVkKSB7Cj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdGF0dXMgPSB1c2VyX2RsbV9k
ZXN0cm95X2xvY2sobG9ja3Jlcyk7Cj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoc3Rh
dHVzIDwgMCkKPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbWxvZ19lcnJubyhz
dGF0dXMpOwo+Pj4gK8KgwqDCoMKgwqDCoMKgIH0KPj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBpcHV0
KGlwLT5pcF9wYXJlbnQpOwo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8gY2xlYXJfZmllbGRz
Owo+Pj4gwqDCoMKgwqDCoCB9Cj4+IEFzIHlvdSBkZXNjcmliZXMsIGl0IGZpcnN0bHkgaW52b2tl
cyB1bmxpbmsgYW5kIHRoZW4gZXZpY3QsIGJ1dCBzdHJpY3RseQo+PiBzcGVha2luZywgZmxhZyBV
U0VSX0xPQ0tfSU5fVEVBUkRPV04gZG9lc24ndCBtZWFuICdkZXN0cm95ZWQnLCBpdCBjb3VsZAo+
PiBiZSBkZXN0cm95aW5nLCBkZXN0cm95ZWQsIG9yIGV2ZW4gdW5hdHRhY2hlZC4KPj4KPj4gU28g
aG93IGFib3V0IGp1c3QgY2hlY2tpbmcgdGhlIGZsYWcgbGlrZSBvdGhlciBwbGFjZXM/Cj4+IFNv
bWV0aGluZyBsaWtlOgo+Pgo+PiDCoMKgwqDCoC8qIERvbid0IGRlc3Ryb3kgbG9ja3JlcyB0d2lj
ZSAqLwo+PiDCoMKgwqDCoHNwaW5fbG9jaygmbG9ja3Jlcy0+bF9sb2NrKTsKPj4gwqDCoMKgwqAo
bG9ja3Jlcy0+bF9mbGFncyAmIFVTRVJfTE9DS19JTl9URUFSRE9XTikgewo+PiDCoMKgwqDCoMKg
wqDCoCBzcGluX3VubG9jaygmbG9ja3Jlcy0+bF9sb2NrKTsKPj4gwqDCoMKgwqDCoMKgwqAgZ290
byBza2lwOwo+PiDCoMKgwqDCoH0KPj4gwqDCoMKgwqBzcGluX3VubG9jaygmbG9ja3Jlcy0+bF9s
b2NrKTsKPj4gwqDCoMKgwqBzdGF0dXMgPSB1c2VyX2RsbV9kZXN0cm95X2xvY2sobG9ja3Jlcyk7
Cj4+IMKgwqDCoMKgLi4uCj4+IHNraXA6Cj4+IMKgwqDCoMKgaXB1dChpcC0+aXBfcGFyZW50KTsK
Pj4gwqDCoMKgwqAuLi4KPiAKPiBTb3VuZCBsaWtlIHRoZSBjb25jZXJuIGlzIGFib3V0IHRoZSB2
YXJpYWJsZSBuYW1lLCBob3cgYWJvdXQgcy9kZXN0cm95ZWQvdGVhcmluZ2Rvd24gPwo+IApZZXMs
IHRlYXJkb3duIHdvdWxkIGJlIGJldHRlci4KClRoYW5rcywKSm9zZXBoCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxp
c3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWls
bWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
