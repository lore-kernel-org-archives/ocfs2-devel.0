Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 213A5C77B73
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Jun 2023 01:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WrOb8k7Hq2kr6U3mqOSi/QEvtiq8VqoV0TQI02SU7R8=;
 b=dc800UYsOqn/dwCe+hXoWR2qKYDmhEmkJ4pigIYb4Yop21MKyPhtumJ8hXC3QXifrWGH+jqpHPK4
   LR7FFkXWtRY3FQcpVd3lSdkGWYtwbV2/ytdsuwMCW7cyuP3GuYMzHNG+xxJbAEENmI2IbiJBAZ+t
   25a5kcxjL1RIrxx62YP+ffB1ub7c3aPWTKORXYyfDIfP6nEzi9H+SFQobRVbgWG+S700fwwpEPZr
   lt8J8KlNz9yJf9AFm9PBNgqqtlaurgNFLEI/PdLgtovyRd2uGIRJhnNdT70qIKAYo+xtMqabanwS
   yuBTtejVFsmYkAg+FdHbso1o3++IhJGcX/Caqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=WrOb8k7Hq2kr6U3mqOSi/QEvtiq8VqoV0TQI02SU7R8=;
 b=QBYHIbHYZ8HIg7cRjEga6bowtnl7VJzL3v2slnEHMvIo42g2eIOzTqVswdGCc+YGwiVGM5p1ya5g
   FBvc2qvF0nTJhynXdxuapuOvAnGicxJ4MmKynUrzlh1mMQcrizT66RUVkQGeKlqOb0tUcSsk8fAI
   X8shYQBqfKjwBRjLYC8wj0GRyKMys/cAhKgbd7+uehMBGC+BBhnjaYJQ+qPxZBs4Jkqm0baHGMMi
   67Iw6iMmRGiHhby7UhnRDbV8FWrqWneCLqsSHlKqjYh1+07PD4X892ldXGVaTA2fbOrfpMPxvh0/
   dt3NIcH5jk/LL0F2aZgO60hKfwd3tz8VjlVuvA==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230522 64bit (built May 22
 2023))
 with ESMTPS id <0RVJ00G72VUZUQ50@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 01 Jun 2023 01:23:23 +0000 (GMT)
Message-id: <4e3eafe6-7f5d-6458-9d0f-f80ad93704dd@linux.alibaba.com>
Date: Thu, 1 Jun 2023 09:23:06 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Content-language: en-US
To: Andrew Morton <akpm@linux-foundation.org>,
 =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
References: <20230529152645.32680-1-lhenriques@suse.de>
 <20230531151147.3d98aa2fb1d7f659bccef37b@linux-foundation.org>
In-reply-to: <20230531151147.3d98aa2fb1d7f659bccef37b@linux-foundation.org>
X-Source-IP: 115.124.30.132
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10727
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 priorityscore=0 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 clxscore=152 mlxscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010009 domainage_hfrom=8813
Cc: linux-kernel@vger.kernel.org,
 =?UTF-8?Q?Lu=c3=ads_Henriques_via_Ocfs2-devel?= <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: check new file size on fallocate call
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R791e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046056;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VjzF489_1685582586;
X-ServerName: out30-132.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: X-XgOZdlfODzHFaiGD1lOkBfF1AH7xNP
X-Proofpoint-ORIG-GUID: X-XgOZdlfODzHFaiGD1lOkBfF1AH7xNP
Reporting-Meta:
 AAG3V8mA/+Jw2GzdYkYoU+ANvr6TRCpU+wyBMt/le67SNYnSs2Rr22nTsNFQaYB6
 gc5BeLrIALeoMSXaVUQVIMTN59QyF59Iz5VWZhN9zRNcpgLszbu8LcpPusmc8EZ2
 cr4xc6lYKQYvvxvHN0EzCWeT91Zonv3Hl7uahxUb0Mq8HzVgSQFZ9xIKnmJeuScN
 i3NDfp+5wpeRSH6lTsByNv3Xd40Vggu0WZIKh4mUO4kzkIM872EXUQDX9aSBUwBN
 uUEgctHTP+w1y3DetdRY3uTvXD8NiYEvHAv37Aa/eVTTH3MEl9Ec6AUSrHQR3FXk
 KSmKwv2ZSYxVP5SWPZ+Ou1f6hAQ0RaGwyGq3OjY+dIgLtV75LxhVo66wNgpDFsyy
 Obbd3g202arU62Pho/i+UWsWVAMeLLCVpTl+y+0qhys3O9VLW+1qr2sWlLha6qgy
 jR/y7eJ4GWy2SsdnZYBB550s7LsjOlIfoIRkXp1bu+PFBaEtVQ/9sq+0AKTT7lW5
 G9WW47QO5vgWLq1U/fNOPcbXGXhq3uA2LcZb7y0LeUaM

CgpPbiA2LzEvMjMgNjoxMSBBTSwgQW5kcmV3IE1vcnRvbiB3cm90ZToKPiBPbiBNb24sIDI5IE1h
eSAyMDIzIDE2OjI2OjQ1ICswMTAwIEx1w61zIEhlbnJpcXVlcyB2aWEgT2NmczItZGV2ZWwgPG9j
ZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tPiB3cm90ZToKPiAKPj4gV2hlbiBjaGFuZ2luZyBhIGZp
bGUgc2l6ZSB3aXRoIGZhbGxvY2F0ZSgpIHRoZSBuZXcgc2l6ZSBpc24ndCBiZWluZwo+PiBjaGVj
a2VkLiAgSW4gcGFydGljdWxhciwgdGhlIEZTSVpFIHVsaW1pdCBpc24ndCBiZWluZyBjaGVja2Vk
LCB3aGljaCBtYWtlcwo+PiBmc3Rlc3QgZ2VuZXJpYy8yMjggZmFpbC4gIFNpbXBseSBhZGRpbmcg
YSBjYWxsIHRvIGlub2RlX25ld3NpemVfb2soKSBmaXhlcwo+PiB0aGlzIGlzc3VlLgo+Pgo+PiAu
Li4KPj4KPj4gLS0tIGEvZnMvb2NmczIvZmlsZS5jCj4+ICsrKyBiL2ZzL29jZnMyL2ZpbGUuYwo+
PiBAQCAtMjEwMCwxNCArMjEwMCwyMCBAQCBzdGF0aWMgbG9uZyBvY2ZzMl9mYWxsb2NhdGUoc3Ry
dWN0IGZpbGUgKmZpbGUsIGludCBtb2RlLCBsb2ZmX3Qgb2Zmc2V0LAo+PiAgCXN0cnVjdCBvY2Zz
Ml9zcGFjZV9yZXN2IHNyOwo+PiAgCWludCBjaGFuZ2Vfc2l6ZSA9IDE7Cj4+ICAJaW50IGNtZCA9
IE9DRlMyX0lPQ19SRVNWU1A2NDsKPj4gKwlpbnQgcmV0ID0gMDsKPj4gIAo+PiAgCWlmIChtb2Rl
ICYgfihGQUxMT0NfRkxfS0VFUF9TSVpFIHwgRkFMTE9DX0ZMX1BVTkNIX0hPTEUpKQo+PiAgCQly
ZXR1cm4gLUVPUE5PVFNVUFA7Cj4+ICAJaWYgKCFvY2ZzMl93cml0ZXNfdW53cml0dGVuX2V4dGVu
dHMob3NiKSkKPj4gIAkJcmV0dXJuIC1FT1BOT1RTVVBQOwo+PiAgCj4+IC0JaWYgKG1vZGUgJiBG
QUxMT0NfRkxfS0VFUF9TSVpFKQo+PiArCWlmIChtb2RlICYgRkFMTE9DX0ZMX0tFRVBfU0laRSkg
ewo+PiAgCQljaGFuZ2Vfc2l6ZSA9IDA7Cj4+ICsJfSBlbHNlIHsKPj4gKwkJcmV0ID0gaW5vZGVf
bmV3c2l6ZV9vayhpbm9kZSwgb2Zmc2V0ICsgbGVuKTsKPj4gKwkJaWYgKHJldCkKPj4gKwkJCXJl
dHVybiByZXQ7Cj4+ICsJfQo+PiAgCj4gCj4gU28gdXNlcnNwYWNlIGNhbiBleGNlZWQgcmxpbWl0
KFJMSU1JVF9GU0laRSkuCj4gCj4gRG8gd2UgdGhpbmsgdGhpcyBmbGF3IGlzIHNlcmlvdXMgZW5v
dWdoIHRvIGp1c3RpZnkgYmFja3BvcnRpbmcgdGhlIGZpeAo+IGludG8gZWFybGllciAtc3RhYmxl
IGtlcm5lbHM/CgpJIHRoaW5rIGl0J3Mgd29ydGggY2Npbmcgc3RhYmxlIGtlcm5lbCBhcyB3ZWxs
LgoKVGhhbmtzLApKb3NlcGgKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xl
LmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
