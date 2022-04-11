Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1092C433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon, 11 Apr 2022 18:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CyIXQ/AhWcqzs/ynoi47fJdOy+0IVTH4cwtij6zH6JU=;
 b=cHPWfOdAy3nNK2lJOXxbY6SWxGWPoKXtC6XdBSokanmRblCoFpg8LkZln7WAHQBxyESGgMEX5PGw
   /DwcRwAdPWQNtdpu7nHd+EnnUKKwop49iu3xkGGHiCzEmg5K3XyCE1JpHR2Llzk6mW2hlTSPQ/Tm
   mFPotX1AHu1py0r2+jGUwkxMyerLeyrFf90Y6w4CEbTgBmoxvbz6DwZ7qVMhI3vybPFzClx5Kn48
   mjKTCiVnJWUEHRAEf3jdzTxYPmps4f6EGTmNCMAeIGQdvV1mxJIBrUqVCeJeklWt5fCLOS7DqgcS
   87QWx6KTDhp6ytwdJvQG/8mBRa+VGnjAy8q19Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CyIXQ/AhWcqzs/ynoi47fJdOy+0IVTH4cwtij6zH6JU=;
 b=jEGLUU7207TyOb5kTAWLrDqySZTPEc+dSzsMY+biS9KRqBQFUr9bVo2iJJ7/JlDqvSgcG2MET9uH
   lOibvNOWdwq6AUkS3cXuirHwytIw9EPE0UVrYdQz+DiGeX6Y4ANTNYhcEWGy6GMCtFT/0+SJXtO/
   MqCpr8uZd8VeEoTf3P3KyAcvNtb4uP7Wdup+rbaweXMajcdEKHWt2OpCTbAjFSyCyot3hl1jxbkz
   OrhxJ90HpZRMRaAw0KDRnvCSCI3VMUBiHZgcl1+9/gIlpulr9jf1cn1Y/JZNknlDdh+UIrj+mJjA
   3BSrVgbIgg/Qjt5BniqPKwPRtXxohbX07P6cBg==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA6009WXVBUN2C0@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 11 Apr 2022 18:57:30 +0000 (GMT)
Message-id: <93529adf-73bf-5818-dbac-a9276512f177@linux.alibaba.com>
Date: Mon, 11 Apr 2022 09:56:09 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: "heming.zhao@suse.com" <heming.zhao@suse.com>, ocfs2-devel@oss.oracle.com
References: <20220408103012.1419-1-heming.zhao@suse.com>
 <20220408103012.1419-4-heming.zhao@suse.com>
 <4b574a02-626d-8cb8-6c2e-e8c824546c22@linux.alibaba.com>
 <4248f4f2-6212-247d-6d14-05a02d7bc249@suse.com>
In-reply-to: <4248f4f2-6212-247d-6d14-05a02d7bc249@suse.com>
X-Source-IP: 115.124.30.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10313
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 priorityscore=30 clxscore=131 lowpriorityscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204110008 domainage_hfrom=8397
Subject: Re: [Ocfs2-devel] [PATCH v1 3/5] ocfs2: ocfs2_initialize_super does
 cleanup job before return error
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R831e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=2; SR=0;
 TI=SMTPD_---0V9gB8zt_1649642169;
X-ServerName: out30-133.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: xhphD08hTPhgBtjXdVsf3V9yu3eF40Tt
X-Proofpoint-GUID: xhphD08hTPhgBtjXdVsf3V9yu3eF40Tt
Reporting-Meta:
 AAFIp2VJfBYR/Vsn5uSkeJDdaDuWTZVFaAUi+1X477exyfUY9FEm7SXQ3rGR9wHd
 Ww3LFBOSk5lCKP6sZl7ogAZhtlr1Mga21+Ze6RwtxElhm+NLBIuutP+t31VO0emf
 8ayGDDdzm7ne7QidwxMUkQWpjs3RGWWbWusRXvOvXWWMtiyYQNYtDLCnEhx8Ulkh
 eOwLYURJsAqJ6LnHUKvPJ6RgD9ATfqN9bWRgV38CkIr+GkUYS1iKxwjpRxaQqqTB
 e08fhHIit26Ugb24idN4y3mxdlv+0inG37AWYBqsn3oIECPbVRZL/nTjNKJLxZKR
 FVuZvy5B3sWniDm7frrvI2B46FBLd4HvK1NjGPNJmuVIgLWra6/x8NuaEYs2xE/J
 5gch4EeXVahnwVk4mJiUZEJ8yj3X6ldBn0KIfAyjuha9A+SpxvXo/Bwni7sNX4HT
 S0cZjpym9lCa8QcnTdh008KX6sPUadvBBJJwTMQonYRI7jlmyI9mgWH3dAvX49XW
 b0q7WwZLzv4EOF9ClEKPZjmdK3Fgw/9nMhatssnnwiWV

CgpPbiA0LzEwLzIyIDEyOjQ3IEFNLCBoZW1pbmcuemhhb0BzdXNlLmNvbSB3cm90ZToKPiBPbiA0
LzkvMjIgMjE6MzAsIEpvc2VwaCBRaSB3cm90ZToKPj4KPj4KPj4gT24gNC84LzIyIDY6MzAgUE0s
IEhlbWluZyBaaGFvIHdyb3RlOgo+Pj4gQWZ0ZXIgdGhpcyBwYXRjaCwgd2hlbiBlcnJvciwgb2Nm
czJfZmlsbF9zdXBlciBkb2Vzbid0IHRha2UgY2FyZSB0bwo+Pj4gcmVsZWFzZSByZXNvdXJjZXMg
d2hpY2ggYXJlIGFsbG9jYXRlZCBpbiBvY2ZzMl9pbml0aWFsaXplX3N1cGVyLgo+Pj4KPj4+IFNp
Z25lZC1vZmYtYnk6IEhlbWluZyBaaGFvIDxoZW1pbmcuemhhb0BzdXNlLmNvbT4KPj4+IC0tLQo+
Pj4gwqAgZnMvb2NmczIvc3VwZXIuYyB8IDU4ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKy0tLS0tLS0tLS0tLS0tLQo+Pj4gwqAgMSBmaWxlIGNoYW5nZWQsIDQwIGluc2VydGlvbnMo
KyksIDE4IGRlbGV0aW9ucygtKQo+Pj4KPj4+IGRpZmYgLS1naXQgYS9mcy9vY2ZzMi9zdXBlci5j
IGIvZnMvb2NmczIvc3VwZXIuYwo+Pj4gaW5kZXggZjkxYzU1MTBiYzdlLi44NDQzYmEwMzFkZWMg
MTAwNjQ0Cj4+PiAtLS0gYS9mcy9vY2ZzMi9zdXBlci5jCj4+PiArKysgYi9mcy9vY2ZzMi9zdXBl
ci5jCj4+PiBAQCAtMjAyMyw3ICsyMDIzLDcgQEAgc3RhdGljIGludCBvY2ZzMl9pbml0aWFsaXpl
X3N1cGVyKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsCj4+PiDCoMKgwqDCoMKgIGlmICghb3NiKSB7
Cj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgc3RhdHVzID0gLUVOT01FTTsKPj4+IMKgwqDCoMKgwqDC
oMKgwqDCoCBtbG9nX2Vycm5vKHN0YXR1cyk7Cj4+PiAtwqDCoMKgwqDCoMKgwqAgZ290byBiYWls
Owo+Pj4gK8KgwqDCoMKgwqDCoMKgIGdvdG8gb3V0Owo+Pj4gwqDCoMKgwqDCoCB9Cj4+PiAuLi4g
Li4uCj4+PiDCoCAtYmFpbDoKPj4+ICvCoMKgwqAgcmV0dXJuIHN0YXR1czsKPj4+ICsKPj4+ICtv
dXRfc2xvdF9pbmZvOgo+Pj4gK8KgwqDCoCBvY2ZzMl9mcmVlX3Nsb3RfaW5mbyhvc2IpOwo+Pj4g
K291dF9zeXN0ZW1faW5vZGVzOgo+Pj4gK8KgwqDCoCBvY2ZzMl9yZWxlYXNlX3N5c3RlbV9pbm9k
ZXMob3NiKTsKPj4+ICtvdXRfZGxtX291dDoKPj4+ICvCoMKgwqAgb2NmczJfcHV0X2RsbV9kZWJ1
Zyhvc2ItPm9zYl9kbG1fZGVidWcpOwo+Pj4gK291dF91dWlkX3N0cjoKPj4+ICvCoMKgwqAga2Zy
ZWUob3NiLT51dWlkX3N0cik7Cj4+PiArb3V0X2pvdXJuYWw6Cj4+PiArwqDCoMKgIGtmcmVlKG9z
Yi0+am91cm5hbCk7Cj4+PiArb3V0X29ycGhhbl93aXBlczoKPj4+ICvCoMKgwqAga2ZyZWUob3Ni
LT5vc2Jfb3JwaGFuX3dpcGVzKTsKPj4+ICtvdXRfc2xvdF9yZWNvdmVyeV9nZW46Cj4+PiArwqDC
oMKgIGtmcmVlKG9zYi0+c2xvdF9yZWNvdmVyeV9nZW5lcmF0aW9ucyk7Cj4+PiArb3V0X3ZvbF9s
YWJlbDoKPj4+ICvCoMKgwqAga2ZyZWUob3NiLT52b2xfbGFiZWwpOwo+Pj4gK291dF9yZWNvdmVy
eV9tYXA6Cj4+PiArwqDCoMKgIGtmcmVlKG9zYi0+cmVjb3ZlcnlfbWFwKTsKPj4+ICtvdXQ6Cj4+
PiArwqDCoMKgIGtmcmVlKG9zYik7Cj4+Cj4+IFNob3VsZCBzZXQgb3NiIHRvIE5VTEwgaGVyZSB0
byBwcmV2ZW50IFVBRiBpbiBvY2ZzMl9maWxsX3N1cGVyKCkuCj4+Cj4gCj4gWW91ciBjb25jZXJu
IG9ubHkgdmFsaWQgd2l0aCBwYXRjaCAxLzUrMi81KzMvNSwgYnV0IGFmdGVyIDUvNSwgdGhlIFVB
RiB3b24ndCBiZQo+IHRyaWdnZXJlZC4gb2NmczJfaW5pdGlhbGl6ZV9zdXBlcigpIGZhaWx1cmUg
d2lsbCBkaXJlY3RseSBqdW1wIChieSAiZ290byBvdXQiKQo+IHRvIHJldHVybi4KPiAKClJpZ2h0
LCBidXQgd2UnZCBiZXR0ZXIgbWFrZSB0aGlzIHBhdGNoIGxvb2sgbW9yZSBjb21wbGV0ZS4KClRo
YW5rcywKSm9zZXBoCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20K
aHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
