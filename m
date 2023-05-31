Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B734C77B73
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 May 2023 08:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0tYkJhYtuKAOSVoJL0j+ZD54lzvTHCHQu8I6+WKO46U=;
 b=oZFeA/+NYE5/Hb3lHfRq3XyZ9PJWv4hoqt2SI+oKs+lOzB0iX15S6YSo/p2ZwVo97P0owd0bz4F3
   xOggJS9yXDilxViwpQAcOd0JooK4LmRcyUNlQHoEtslnB1K4nQNMOIQIavT6YTbkH4De02gvmnCS
   4hTBjzOJ7lck+HcAOLd4A+n4bSpkSK4MgfsTlkg9XhlBBysxMEpKbb1lCEb6xMQxbBFVbUMOu9L8
   ugaUlwncylLwJzd0m5KKko1Y4G/HcgPd6hCGMdv1Tunuutc/MMc3RDzZGsrcynuVG257zvNrCaeE
   xAWTUpYEhBXgcKbRv3nR+T9NWjLvArBxCXtf1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0tYkJhYtuKAOSVoJL0j+ZD54lzvTHCHQu8I6+WKO46U=;
 b=B5+rClWmfuzA4SeP6sgTeO8ZFSoaMK6m2RZQGEhTUiPIZ790WiNAb2yC+T/M+W3V2T7MXBe+poih
   X2IqsjsFetKVTURgHTtRGyBQEA34JE3MgM1wwl1iBbZigdtITt6FQiPmr92IlT7mYY2788VzwpDA
   ZTDr1fBz658sEK9PMPGAt0T+2ljidc3130jdhbF3L7K7tjm50cDbGK8+e20qd+jQ25/0bsxEuFHt
   jPLcUnDbT9XnokFv2sjWuC28WjBu48EBQoIWy8FECGvYYoX22sm3JPdou2BAi1xox1mdWz0E/Bdq
   aLjd5GNBQRUURsvNtP2U2cYEF7eSp8rVMUNrQw==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230522 64bit (built May 22
 2023))
 with ESMTPS id <0RVI00EIDL0WAJ30@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 31 May 2023 08:31:44 +0000 (GMT)
Message-id: <301cdaee-0b73-67b5-75d8-0cbad93b9736@linux.alibaba.com>
Date: Wed, 31 May 2023 16:31:19 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Content-language: en-US
To: =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
References: <20230529152645.32680-1-lhenriques@suse.de>
 <810630b9-2021-01b3-1473-aa759174205e@linux.alibaba.com>
 <87fs7c3nvl.fsf@suse.de>
In-reply-to: <87fs7c3nvl.fsf@suse.de>
X-Source-IP: 115.124.30.110
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10726
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 spamscore=0 mlxscore=0 priorityscore=179 adultscore=0 impostorscore=0
 phishscore=0 malwarescore=0 mlxlogscore=891 suspectscore=0 clxscore=165
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R361e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046056;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
 TI=SMTPD_---0VjwvB-q_1685521879;
X-ServerName: out30-110.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: EmEauBreMClPnAlP7gFqOQ0IbwzjRLi6
X-Proofpoint-GUID: EmEauBreMClPnAlP7gFqOQ0IbwzjRLi6
Reporting-Meta:
 AAGkBMExDWAI5LUs2u8QSeEb5GJsXVzVlTtYBSzgAq7jqpDWlGj0mDlC2HrSm2RP
 MiDBBP2Cp7SOwGTzGG9K+3Fq/uN6KrTythy5+GtPA70zYboR1HMp12NBRdiGChKI
 HoeRaH0IRoB1oojmgI57Lx6BHhPLYgqnwAmTrU4jXMApXFIvyqayHn7ftbYIAk9Z
 Gfha/Nm6cNwmzyGcEqUCkTK6qr4TJfPLX8XP7PWFokxGvVLUbB5tkV4SKhLq4m3q
 YgTkV9i1Rzt6aAWEvPvfgtP6Efjn+DFGvt4Oao31JYms9NlWkpr2B+94elxRCodD
 7dhRubCGQvoypX7Agogiy81nRP1yWm3mE245VHayxjDuuxGyECAZQtXjRcf3eRyz
 bUKl/Bczb6cwwP1i0ZA152WtJgw0EWIU0BIAFEM2c4vCYZnsnirskQ/9V/SdBsXR
 Y4vxPzArbd5puXDycn1+1pFcEWCDRoIiyHLH1Vwmh9iSOVi73BsHCSShYAuc7/iQ
 ss9c0OLa4iRkkCA45iGUiTbxOkPqq0Oq5K58HhB+h7hx8g==

CgpPbiA1LzMxLzIzIDQ6MjkgUE0sIEx1w61zIEhlbnJpcXVlcyB3cm90ZToKPiBKb3NlcGggUWkg
PGpvc2VwaC5xaUBsaW51eC5hbGliYWJhLmNvbT4gd3JpdGVzOgo+IAo+PiBPbiA1LzI5LzIzIDEx
OjI2IFBNLCBMdcOtcyBIZW5yaXF1ZXMgd3JvdGU6Cj4+PiBXaGVuIGNoYW5naW5nIGEgZmlsZSBz
aXplIHdpdGggZmFsbG9jYXRlKCkgdGhlIG5ldyBzaXplIGlzbid0IGJlaW5nCj4+PiBjaGVja2Vk
LiAgSW4gcGFydGljdWxhciwgdGhlIEZTSVpFIHVsaW1pdCBpc24ndCBiZWluZyBjaGVja2VkLCB3
aGljaCBtYWtlcwo+Pj4gZnN0ZXN0IGdlbmVyaWMvMjI4IGZhaWwuICBTaW1wbHkgYWRkaW5nIGEg
Y2FsbCB0byBpbm9kZV9uZXdzaXplX29rKCkgZml4ZXMKPj4+IHRoaXMgaXNzdWUuCj4+Pgo+Pj4g
U2lnbmVkLW9mZi1ieTogTHXDrXMgSGVucmlxdWVzIDxsaGVucmlxdWVzQHN1c2UuZGU+Cj4+PiAt
LS0KPj4+ICBmcy9vY2ZzMi9maWxlLmMgfCA4ICsrKysrKystCj4+PiAgMSBmaWxlIGNoYW5nZWQs
IDcgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQo+Pj4KPj4+IGRpZmYgLS1naXQgYS9mcy9v
Y2ZzMi9maWxlLmMgYi9mcy9vY2ZzMi9maWxlLmMKPj4+IGluZGV4IGVmYjA5ZGU0MzQzZC4uYjE3
M2MzNmJjYWIzIDEwMDY0NAo+Pj4gLS0tIGEvZnMvb2NmczIvZmlsZS5jCj4+PiArKysgYi9mcy9v
Y2ZzMi9maWxlLmMKPj4+IEBAIC0yMTAwLDE0ICsyMTAwLDIwIEBAIHN0YXRpYyBsb25nIG9jZnMy
X2ZhbGxvY2F0ZShzdHJ1Y3QgZmlsZSAqZmlsZSwgaW50IG1vZGUsIGxvZmZfdCBvZmZzZXQsCj4+
PiAgCXN0cnVjdCBvY2ZzMl9zcGFjZV9yZXN2IHNyOwo+Pj4gIAlpbnQgY2hhbmdlX3NpemUgPSAx
Owo+Pj4gIAlpbnQgY21kID0gT0NGUzJfSU9DX1JFU1ZTUDY0Owo+Pj4gKwlpbnQgcmV0ID0gMDsK
Pj4+ICAKPj4+ICAJaWYgKG1vZGUgJiB+KEZBTExPQ19GTF9LRUVQX1NJWkUgfCBGQUxMT0NfRkxf
UFVOQ0hfSE9MRSkpCj4+PiAgCQlyZXR1cm4gLUVPUE5PVFNVUFA7Cj4+Cj4+IFRoaXMgbWVhbnMg
d2Ugb25seSBzdXBwb3J0IGtlZXAtc2l6ZSBhbmQgcG91Y2hfaG9sZS4KPj4gQW5kIGl0IHNlZW1z
IHBvdWNoX2hvbGUgd2lsbCBhbHNvIGltcGx5IGtlZXAtc2l6ZS4KPiAKPiBJIHRoaW5rIHlvdSdy
ZSBmb3JnZXR0aW5nIGFib3V0IG1vZGUgPSAwLCB3aGljaCBpcyBhbHNvIHZhbGlkLiAgQW5kIHRo
ZQo+IGRlZmF1bHQgJzAnIHdpbGwgYWxsb3cgc2l6ZSB0byBiZSBjaGFuZ2VkLgo+IAoKT29wcy4u
LiBZb3UgYXJlIHJpZ2h0LgoKPj4+ICAJaWYgKCFvY2ZzMl93cml0ZXNfdW53cml0dGVuX2V4dGVu
dHMob3NiKSkKPj4+ICAJCXJldHVybiAtRU9QTk9UU1VQUDsKPj4+ICAKPj4+IC0JaWYgKG1vZGUg
JiBGQUxMT0NfRkxfS0VFUF9TSVpFKQo+Pj4gKwlpZiAobW9kZSAmIEZBTExPQ19GTF9LRUVQX1NJ
WkUpIHsKPj4+ICAJCWNoYW5nZV9zaXplID0gMDsKPj4+ICsJfSBlbHNlIHsKPj4KPj4gU2VlbXMg
dGhpcyB3aWxsIGJlIGEgZGVhZCBicmFuY2g/Cj4gCj4gQWdhaW4sIHlvdSBuZWVkIHRvIGNvbnNp
ZGVyICcwJyBhcyBhIHZhbGlkIG1vZGUgdmFsdWUuICBJZiB5b3UgcnVuCj4gZ2VuZXJpYy8yMjgg
d2l0aG91dCB0aGlzIHBhdGNoIHlvdSdsbCBzZWUgdGhhdCB0ZXN0IGZhaWxpbmcgYmVjYXVzZSBp
dAo+ICpkb2VzKiBoaXQgdGhpcyBicmFuY2guCj4gCj4gQ2hlZXJzLAoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0
Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1h
bi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
