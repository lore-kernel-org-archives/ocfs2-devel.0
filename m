Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9C15C7EE2C
	for <ocfs2-devel@archiver.kernel.org>; Mon, 29 May 2023 20:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vyqmMn/9r7e+AVefsy4jL0eh67bX5mZBGTD0nt8nR/c=;
 b=uHmhMn7WMt8yc0xTrjpVXEgtfk70kyPp8VqTHC36gpZ0OOjhvO5lCa6EPvDGVmwKName3sfhHd67
   g7zXdCm/vn2u9khC0Q0f9NMkiIbQ4IYfTSmZS+85pvbzJ7xKvrdxlb5TzCr2ss5+eu4btdi6sVHt
   c8PJ4DRb/aA9CXyoXRpmg61WK0NADlFUs0CY7WPLgXvystsNVxc+BPYRj4JoTCwAaRoagH/wbqlF
   tRiSwHKjSkTokkVqdebt3Xohpt1oveuJshE9EPDSQHxh/ZXAGbvRaj1pi9K65eo1AsTkMbHQmWzz
   /+M9iPLlMqo3GXQOlwbU7Vaz+P5HJmivJvkWiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vyqmMn/9r7e+AVefsy4jL0eh67bX5mZBGTD0nt8nR/c=;
 b=THe4relyiaGXkhzedRDNCXiGA9o8TwIrZ+3DArHeJBa7Kegt5xFPEFfXw41jXEh/1xpZMQ7jG3V3
   ZAy4EDmnOzy8w252NM7ok+KTUxmjiCQY9ZOwi9R3hlDreX94KmJd2Mj/7mQy/ju03nsyeZ+BSmhf
   LKcKzUXxvR17iyoS3EPnGPqbe62lZTDzibfKFDfDFPp1CTdYWCam/HW5GWnbVD1cPO2LCFsM+cQr
   R2Q49ETZ5KoflMnFyFkNja8UoG9SAIovyz5seoKvBe1M7qaV02FHENFe5RAYJiIklc6JEpbdYmu1
   gCGclqoaO7gvyyAahf01kAPFD7BRYcI9ctWocQ==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230522 64bit (built May 22
 2023))
 with ESMTPS id <0RVF00NAOSI06N20@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 29 May 2023 20:20:24 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
 t=1685374006;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=9LThTdNc3l0TTfcqKHMZIFh55bGZbjKiI/0a+5Ltvg0=;
 b=Kw3Hx4Cw+ZLE4wLRr0B8J/5bebN+MgZiyXz0l64lvJWZKfXbfET9SGYyeKxwuTRMW3jHMg
 w5aVMp3s85avm5mAvvfRkNJY7M3mIn8uOg8AQ6Fex031QYbhbl7eQh3HDlbxcWNX21XhcO
 VjpivPLoYAgB6qYPfMHP5iIjqrfF4Gc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
 s=susede2_ed25519; t=1685374006;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=9LThTdNc3l0TTfcqKHMZIFh55bGZbjKiI/0a+5Ltvg0=;
 b=B6ic1MO724bMQ4Ipm8jiEo4Uw9SO23DnqV1lKHbwVuf3A3nsbgK8pM/MfqY/xC1gZz2T2P
 6KvrMhcXHeOSGgCQ==
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, Heming Zhao <heming.zhao@suse.com>
Date: Mon, 29 May 2023 16:26:45 +0100
Message-id: <20230529152645.32680-1-lhenriques@suse.de>
MIME-version: 1.0
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10725
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 bulkscore=0 impostorscore=0 malwarescore=0 clxscore=-11
 spamscore=0 mlxlogscore=483 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305290129
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH] ocfs2: check new file size on fallocate call
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
From: =?UTF-8?q?Lu=C3=ADs=20Henriques?= via Ocfs2-devel
 <ocfs2-devel@oss.oracle.com>
Reply-to: =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out1.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:195.135.220.0/27
 ip6:2001:67c:2178:6::/120 ~all
X-Spam: Clean
X-Proofpoint-GUID: KmXlYs6kbTzViXzgw5eCDAyNbzigWv_l
X-Proofpoint-ORIG-GUID: KmXlYs6kbTzViXzgw5eCDAyNbzigWv_l
X-Mailman-Approved-At: Mon, 29 May 2023 20:20:22 +0000
Reporting-Meta:
 AAHEG0dH2d4mfiuxv9DEDl9WeYTYZ9q2fFNkZOipNRNjKW7W0D8rVx3Fk8vK9Skd
 IV8vKjMStGmBkKVZbPh1URcX6QWKXRm9x+A8EnRxjoZ5es4JmUpTtDMFe9VoTnfx
 JWh6tlm8DAZZLrdeQwMdyr4Tt/AmG/Byo9lEvKQ4Gpj2ZRNb3cJsqIQF9qCkW7/5
 DlhAHJQzq8DaK4ZXoC1ulYUSHn4MNbBtUinrKQEv66m45tPCD4BN1CzqVm3fBW5/
 AqjiOPdPClrM/j5dSdGeYvjawk7IRG+WyNWwaC5Gj3IURluy3XtxsRSlFlH9rZZ/
 AJvrtnX5Y24xK2SeRNkrDwiD9HctslDsAasmT7DRklWLoUhWfcXyrO4p+ncHeOjW
 SBkIrDhbDdtzU26/bR8vajw4R9/VjFGsVNKBMPU/OHNhWhup4On+JxZGODaCbk0V
 E8XIi7Qs9z+cQRJlWOna+y4Gny3DqsHqrIqQwXIpN25P5bg/ln88J5YGtAiI4Vz9
 HO7vXVtDjBHlF2ZwDUHF++J5sGQz/dpHaB1141uD3q7w

V2hlbiBjaGFuZ2luZyBhIGZpbGUgc2l6ZSB3aXRoIGZhbGxvY2F0ZSgpIHRoZSBuZXcgc2l6ZSBp
c24ndCBiZWluZwpjaGVja2VkLiAgSW4gcGFydGljdWxhciwgdGhlIEZTSVpFIHVsaW1pdCBpc24n
dCBiZWluZyBjaGVja2VkLCB3aGljaCBtYWtlcwpmc3Rlc3QgZ2VuZXJpYy8yMjggZmFpbC4gIFNp
bXBseSBhZGRpbmcgYSBjYWxsIHRvIGlub2RlX25ld3NpemVfb2soKSBmaXhlcwp0aGlzIGlzc3Vl
LgoKU2lnbmVkLW9mZi1ieTogTHXDrXMgSGVucmlxdWVzIDxsaGVucmlxdWVzQHN1c2UuZGU+Ci0t
LQogZnMvb2NmczIvZmlsZS5jIHwgOCArKysrKysrLQogMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0
aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL29jZnMyL2ZpbGUuYyBiL2Zz
L29jZnMyL2ZpbGUuYwppbmRleCBlZmIwOWRlNDM0M2QuLmIxNzNjMzZiY2FiMyAxMDA2NDQKLS0t
IGEvZnMvb2NmczIvZmlsZS5jCisrKyBiL2ZzL29jZnMyL2ZpbGUuYwpAQCAtMjEwMCwxNCArMjEw
MCwyMCBAQCBzdGF0aWMgbG9uZyBvY2ZzMl9mYWxsb2NhdGUoc3RydWN0IGZpbGUgKmZpbGUsIGlu
dCBtb2RlLCBsb2ZmX3Qgb2Zmc2V0LAogCXN0cnVjdCBvY2ZzMl9zcGFjZV9yZXN2IHNyOwogCWlu
dCBjaGFuZ2Vfc2l6ZSA9IDE7CiAJaW50IGNtZCA9IE9DRlMyX0lPQ19SRVNWU1A2NDsKKwlpbnQg
cmV0ID0gMDsKIAogCWlmIChtb2RlICYgfihGQUxMT0NfRkxfS0VFUF9TSVpFIHwgRkFMTE9DX0ZM
X1BVTkNIX0hPTEUpKQogCQlyZXR1cm4gLUVPUE5PVFNVUFA7CiAJaWYgKCFvY2ZzMl93cml0ZXNf
dW53cml0dGVuX2V4dGVudHMob3NiKSkKIAkJcmV0dXJuIC1FT1BOT1RTVVBQOwogCi0JaWYgKG1v
ZGUgJiBGQUxMT0NfRkxfS0VFUF9TSVpFKQorCWlmIChtb2RlICYgRkFMTE9DX0ZMX0tFRVBfU0la
RSkgewogCQljaGFuZ2Vfc2l6ZSA9IDA7CisJfSBlbHNlIHsKKwkJcmV0ID0gaW5vZGVfbmV3c2l6
ZV9vayhpbm9kZSwgb2Zmc2V0ICsgbGVuKTsKKwkJaWYgKHJldCkKKwkJCXJldHVybiByZXQ7CisJ
fQogCiAJaWYgKG1vZGUgJiBGQUxMT0NfRkxfUFVOQ0hfSE9MRSkKIAkJY21kID0gT0NGUzJfSU9D
X1VOUkVTVlNQNjQ7CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20K
aHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
