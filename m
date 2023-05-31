Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBE50C77B7A
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 May 2023 08:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rCQnO7+j1Mg/y7tzfB4d+F23E4QTljPxo1v+B05KraU=;
 b=PDa9Qn/gAt6ekAUhl91qLu5avaF6BVB3CmccQck57h8P+o44H1RISU69M41H4j7bV5cFlZDOnHr8
   0qqC/rKgARusCck6JPGKcJRvU9Yyn2ag9WxOhD1twXBX6+EjaKaLTAUWfrPryRFos1ScfzwFwAIs
   n/T3RWi/f8UhF6VfsovAT8HWYx0ryEw15i9bp7/eiaiQ0VW08d7SM1/NnGElyNcavpSY+NOIhNh2
   H3X4vU4cxiDoQABNlYhpj1zc0R9FewSsZPlX/jqRHCvjLfTL3oYuli6Du3pOIllEM15Y9ZpDFFiT
   +lQxqsVTquhfW2G0SMjv8R7fYR1KO+NoMKquxA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rCQnO7+j1Mg/y7tzfB4d+F23E4QTljPxo1v+B05KraU=;
 b=qiIj4EV/in0ID4dbgi22ppqmkGawTU4kDk/5BEZjmizJ/mpMJpoMi8UG7/FIdCm9Yy+qa9CmVhKs
   rbNdJsa0+taJTe9MyI1SAosU5s5s+yLrTLPsOdb3GKXQ4VyXbLUNX7cMgyEVfuewHOW3/3+vBDDO
   J4bZODXpclip34POFfQDGfe3zF4yy/4PnqsxhvKlST1hYYHIvDP+NiXQ2cg7slhuaxH7WJ1ox/NY
   lm2/B3cNRwxRy4z2WnN88wri9iOecR3A3P9cVKgL1A6HJdG5rSns+aTOMAr7HwiL0Pqr6jrI5uoO
   UYAJL64AkxN1K7nh73Y13tjJV2FQBkYANgDwow==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230522 64bit (built May 22
 2023))
 with ESMTPS id <0RVI00D63L2420E0@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 31 May 2023 08:32:28 +0000 (GMT)
Message-id: <a111bd89-df32-c88c-62c9-59b90b5fda9a@linux.alibaba.com>
Date: Wed, 31 May 2023 16:32:12 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Content-language: en-US
To: =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Heming Zhao <heming.zhao@suse.com>, akpm <akpm@linux-foundation.org>
References: <20230529152645.32680-1-lhenriques@suse.de>
In-reply-to: <20230529152645.32680-1-lhenriques@suse.de>
X-Source-IP: 115.124.30.119
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10726
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 phishscore=0 clxscore=85 adultscore=0 mlxlogscore=902 priorityscore=136
 spamscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305310073 domainage_hfrom=8812
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R151e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046060;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VjwzqAQ_1685521932;
X-ServerName: out30-119.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: bvBEicKKI7sv8Wcu29kYzZYavba_yLLz
X-Proofpoint-GUID: bvBEicKKI7sv8Wcu29kYzZYavba_yLLz
Reporting-Meta:
 AAGIbYPnrCgDEqJ3nWAkp05CaEM8Q5uMe+bNevlB89LAAa/HFAA9wRUKrAI6f/Df
 lljS9Hi5Zo8tW3VlYLEyIofh6Ug0n4gxG0+Kfk1TQ7wYjQoX4QKk9zF1d210+UwB
 dsekz4TQk8esbOszKs+ykOWEBdAzM5kw9ThAcsCR1wtMZ6xBnJKnasSn/UTfVHQG
 rs0BTPohNMMXt5fS8f8Kun9U47I2F/fkZ/K+PwZGoiSyV65CETnOR71KU87LGkgD
 zs2CdgHFPq6FEfZOSE4XA1if7lSJU814FXNwMqrS6Dh1n4zoLtXtDriFvVFU0MF9
 /jmIChZkb5wkcasjS9haFoOPqeqhKuEcsKBQYJhvnKCvqoCwp8nGNz6/sgWCD2it
 0lc//coZizP+bwYvpFq6OPlgkBh1LNvQgeix2hE+ix9iSShAB+OGSbLQWd7BGvfp
 V+eHbcuyA6/RoOvQRYTXF5zW8MbjKoV1ufCf3OC3GlFjBDybIBw8RgXxEw+yzaYW
 onIoHVUzjvw+ZsbzE2lyv4jUXxEhEUjd9Hamz8MT8BGk

CgpPbiA1LzI5LzIzIDExOjI2IFBNLCBMdcOtcyBIZW5yaXF1ZXMgd3JvdGU6Cj4gV2hlbiBjaGFu
Z2luZyBhIGZpbGUgc2l6ZSB3aXRoIGZhbGxvY2F0ZSgpIHRoZSBuZXcgc2l6ZSBpc24ndCBiZWlu
Zwo+IGNoZWNrZWQuICBJbiBwYXJ0aWN1bGFyLCB0aGUgRlNJWkUgdWxpbWl0IGlzbid0IGJlaW5n
IGNoZWNrZWQsIHdoaWNoIG1ha2VzCj4gZnN0ZXN0IGdlbmVyaWMvMjI4IGZhaWwuICBTaW1wbHkg
YWRkaW5nIGEgY2FsbCB0byBpbm9kZV9uZXdzaXplX29rKCkgZml4ZXMKPiB0aGlzIGlzc3VlLgo+
IAo+IFNpZ25lZC1vZmYtYnk6IEx1w61zIEhlbnJpcXVlcyA8bGhlbnJpcXVlc0BzdXNlLmRlPgoK
UmV2aWV3ZWQtYnk6IEpvc2VwaCBRaSA8am9zZXBoLnFpQGxpbnV4LmFsaWJhYmEuY29tPgo+IC0t
LQo+ICBmcy9vY2ZzMi9maWxlLmMgfCA4ICsrKysrKystCj4gIDEgZmlsZSBjaGFuZ2VkLCA3IGlu
c2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKPiAKPiBkaWZmIC0tZ2l0IGEvZnMvb2NmczIvZmls
ZS5jIGIvZnMvb2NmczIvZmlsZS5jCj4gaW5kZXggZWZiMDlkZTQzNDNkLi5iMTczYzM2YmNhYjMg
MTAwNjQ0Cj4gLS0tIGEvZnMvb2NmczIvZmlsZS5jCj4gKysrIGIvZnMvb2NmczIvZmlsZS5jCj4g
QEAgLTIxMDAsMTQgKzIxMDAsMjAgQEAgc3RhdGljIGxvbmcgb2NmczJfZmFsbG9jYXRlKHN0cnVj
dCBmaWxlICpmaWxlLCBpbnQgbW9kZSwgbG9mZl90IG9mZnNldCwKPiAgCXN0cnVjdCBvY2ZzMl9z
cGFjZV9yZXN2IHNyOwo+ICAJaW50IGNoYW5nZV9zaXplID0gMTsKPiAgCWludCBjbWQgPSBPQ0ZT
Ml9JT0NfUkVTVlNQNjQ7Cj4gKwlpbnQgcmV0ID0gMDsKPiAgCj4gIAlpZiAobW9kZSAmIH4oRkFM
TE9DX0ZMX0tFRVBfU0laRSB8IEZBTExPQ19GTF9QVU5DSF9IT0xFKSkKPiAgCQlyZXR1cm4gLUVP
UE5PVFNVUFA7Cj4gIAlpZiAoIW9jZnMyX3dyaXRlc191bndyaXR0ZW5fZXh0ZW50cyhvc2IpKQo+
ICAJCXJldHVybiAtRU9QTk9UU1VQUDsKPiAgCj4gLQlpZiAobW9kZSAmIEZBTExPQ19GTF9LRUVQ
X1NJWkUpCj4gKwlpZiAobW9kZSAmIEZBTExPQ19GTF9LRUVQX1NJWkUpIHsKPiAgCQljaGFuZ2Vf
c2l6ZSA9IDA7Cj4gKwl9IGVsc2Ugewo+ICsJCXJldCA9IGlub2RlX25ld3NpemVfb2soaW5vZGUs
IG9mZnNldCArIGxlbik7Cj4gKwkJaWYgKHJldCkKPiArCQkJcmV0dXJuIHJldDsKPiArCX0KPiAg
Cj4gIAlpZiAobW9kZSAmIEZBTExPQ19GTF9QVU5DSF9IT0xFKQo+ICAJCWNtZCA9IE9DRlMyX0lP
Q19VTlJFU1ZTUDY0OwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29t
Cmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
