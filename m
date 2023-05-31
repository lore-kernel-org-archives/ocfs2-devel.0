Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90D9CC77B7A
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 May 2023 06:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MNwNthZHK3701vKFbe05njNmUl/CCxz4wrxT5kmbwrs=;
 b=ttNgfqNhb/xUeeO7hZu7YVS/3sQpYpULubSkEQeJsZIR39cexluNgdUOSZ9/ms2AjmRSNZfFKjbo
   BmQEqzlW61pcE5Ha0Qh3Ns6lanhJli+Iy0Hr/9QmZc3rKL62X8n4xlEVNC3BzFGRu24XSttjsnVp
   GNredtNizlCIejjcpjCDS8xCtV3GLNiFzSoaMlo1+PXhjyNk4QBs6FRqDndd46BesjgoNm/foCUG
   sgoq1V12sJ3gx1IHQBf/8CdOXNOiAawzLKSL3IHBFGTFOQMjhhcU1BxwhT0VGDa+7fdzUPhcHEHZ
   X+aph8j1Smn5ZHXBWQTQa0QHE+eg/Hp2TKyl8g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MNwNthZHK3701vKFbe05njNmUl/CCxz4wrxT5kmbwrs=;
 b=njFJSa9oNPb25jeTEpkdxNntiFxbYmZv+BRAKHcjLbQwy1JvuufqRw4dzV3/6KjjpS6SecLVYNH3
   71/8LB9Pqa2p/1Gi7bVGrPytckIDjGKj34+O+p+pbcJIuGPICVUrskkQXmxQEhJIZxv8KS34Ay5w
   Ma6i9ZxfeVbh0aQqSraU/YP/SamhrjFn+Yq2pA8E5Wk3QBOwE8Y9lXwXTE+oxRkXC4sm4hsFnLxT
   /xs1yaWaezQFaYwEVBT5gwrVs1ISJWykQgyhpdQBouMVorNA4m9kN4gkopo/5cJMlInUwbW0AF6O
   J23MuOoaZsUvW6CT4EL4osMp5+Wki+hwnDPQWA==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230522 64bit (built May 22
 2023))
 with ESMTPS id <0RVI00GIAE0ZRX30@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 31 May 2023 06:00:35 +0000 (GMT)
Message-id: <810630b9-2021-01b3-1473-aa759174205e@linux.alibaba.com>
Date: Wed, 31 May 2023 14:00:12 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Content-language: en-US
To: =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Heming Zhao <heming.zhao@suse.com>
References: <20230529152645.32680-1-lhenriques@suse.de>
In-reply-to: <20230529152645.32680-1-lhenriques@suse.de>
X-Source-IP: 115.124.30.113
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10726
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 clxscore=71 mlxlogscore=903 adultscore=0 priorityscore=115
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305310051 domainage_hfrom=8812
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: check new file size on fallocate	call
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R821e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046050;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
 TI=SMTPD_---0VjwLRao_1685512812;
X-ServerName: out30-113.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 1g4JCwCJrr-V9G8cdjQYoVk1DgvpTMTB
X-Proofpoint-GUID: 1g4JCwCJrr-V9G8cdjQYoVk1DgvpTMTB
Reporting-Meta:
 AAEJEY1dBVk1d883/+3Ike2ETp4yS+zibhvlAc4oFN0xI/JCa7tQMc6km9uyEv6R
 tIy4Kpu6jU5OpDsanAtzWQKVUMc372Vov19RmZNB6JdkYAzJCzd8/m5LTN1X8mvQ
 yIoiwlJcAkdek430KFxfIErtpzcN9dS4eMmkrLMhl3H0DGkAAvyWmHn4LrBXj4fT
 uz/0LNXF4HGqn+lwXPIlsmoARXzgRkcHQUXaYaW9UN7XQKqynCs62T/eM0rMaBYE
 khz04E2CYHfIFz5+a71oM6V6UKCRTakD0W5BSu4Vi5h4RwBGrve7hF9vopDOIwzw
 Y53ltqblo6PweLSkA7YSzX8gk4lYsafI0QqWYTex2e1NrJ9AANZvxATzwtB68l3h
 2l1C+0V5RcEmAGi3vimzDIP7pQoC5/10ftbQYHk6umxruM7RSOhF2qABwe31oJJ7
 NSJImoI158KNJvF8NAEikAOMbElAd3kG9dpEgzmpLh7tZW8ZRIe+JNPW3brGOWaf
 dbkrM9G90M2KXD48Qldegn3lbF1bxuj9buMqWGzr8eM=

CgpPbiA1LzI5LzIzIDExOjI2IFBNLCBMdcOtcyBIZW5yaXF1ZXMgd3JvdGU6Cj4gV2hlbiBjaGFu
Z2luZyBhIGZpbGUgc2l6ZSB3aXRoIGZhbGxvY2F0ZSgpIHRoZSBuZXcgc2l6ZSBpc24ndCBiZWlu
Zwo+IGNoZWNrZWQuICBJbiBwYXJ0aWN1bGFyLCB0aGUgRlNJWkUgdWxpbWl0IGlzbid0IGJlaW5n
IGNoZWNrZWQsIHdoaWNoIG1ha2VzCj4gZnN0ZXN0IGdlbmVyaWMvMjI4IGZhaWwuICBTaW1wbHkg
YWRkaW5nIGEgY2FsbCB0byBpbm9kZV9uZXdzaXplX29rKCkgZml4ZXMKPiB0aGlzIGlzc3VlLgo+
IAo+IFNpZ25lZC1vZmYtYnk6IEx1w61zIEhlbnJpcXVlcyA8bGhlbnJpcXVlc0BzdXNlLmRlPgo+
IC0tLQo+ICBmcy9vY2ZzMi9maWxlLmMgfCA4ICsrKysrKystCj4gIDEgZmlsZSBjaGFuZ2VkLCA3
IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKPiAKPiBkaWZmIC0tZ2l0IGEvZnMvb2NmczIv
ZmlsZS5jIGIvZnMvb2NmczIvZmlsZS5jCj4gaW5kZXggZWZiMDlkZTQzNDNkLi5iMTczYzM2YmNh
YjMgMTAwNjQ0Cj4gLS0tIGEvZnMvb2NmczIvZmlsZS5jCj4gKysrIGIvZnMvb2NmczIvZmlsZS5j
Cj4gQEAgLTIxMDAsMTQgKzIxMDAsMjAgQEAgc3RhdGljIGxvbmcgb2NmczJfZmFsbG9jYXRlKHN0
cnVjdCBmaWxlICpmaWxlLCBpbnQgbW9kZSwgbG9mZl90IG9mZnNldCwKPiAgCXN0cnVjdCBvY2Zz
Ml9zcGFjZV9yZXN2IHNyOwo+ICAJaW50IGNoYW5nZV9zaXplID0gMTsKPiAgCWludCBjbWQgPSBP
Q0ZTMl9JT0NfUkVTVlNQNjQ7Cj4gKwlpbnQgcmV0ID0gMDsKPiAgCj4gIAlpZiAobW9kZSAmIH4o
RkFMTE9DX0ZMX0tFRVBfU0laRSB8IEZBTExPQ19GTF9QVU5DSF9IT0xFKSkKPiAgCQlyZXR1cm4g
LUVPUE5PVFNVUFA7CgpUaGlzIG1lYW5zIHdlIG9ubHkgc3VwcG9ydCBrZWVwLXNpemUgYW5kIHBv
dWNoX2hvbGUuCkFuZCBpdCBzZWVtcyBwb3VjaF9ob2xlIHdpbGwgYWxzbyBpbXBseSBrZWVwLXNp
emUuCgo+ICAJaWYgKCFvY2ZzMl93cml0ZXNfdW53cml0dGVuX2V4dGVudHMob3NiKSkKPiAgCQly
ZXR1cm4gLUVPUE5PVFNVUFA7Cj4gIAo+IC0JaWYgKG1vZGUgJiBGQUxMT0NfRkxfS0VFUF9TSVpF
KQo+ICsJaWYgKG1vZGUgJiBGQUxMT0NfRkxfS0VFUF9TSVpFKSB7Cj4gIAkJY2hhbmdlX3NpemUg
PSAwOwo+ICsJfSBlbHNlIHsKClNlZW1zIHRoaXMgd2lsbCBiZSBhIGRlYWQgYnJhbmNoPwoKVGhh
bmtzLApKb3NlcGgKCj4gKwkJcmV0ID0gaW5vZGVfbmV3c2l6ZV9vayhpbm9kZSwgb2Zmc2V0ICsg
bGVuKTsKPiArCQlpZiAocmV0KQo+ICsJCQlyZXR1cm4gcmV0Owo+ICsJfQo+ICAKPiAgCWlmICht
b2RlICYgRkFMTE9DX0ZMX1BVTkNIX0hPTEUpCj4gIAkJY21kID0gT0NGUzJfSU9DX1VOUkVTVlNQ
NjQ7CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2Zz
Mi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9v
c3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
