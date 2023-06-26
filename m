Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20D60EB64DC
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jun 2023 05:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Dx2sqHBB2kEPEO2SrrJkDJ9RGA/3RgwQpKVY/QQe+F8=;
 b=3XlEU5UOuzHRiciFFlnaXEfBoF7mn3jN908eR2qxyPG7St+TEZhCliJKUVJVOLEZsZ6gDwxWmWAa
   nM4reidpEmpwqjnysPsjlZIXTeZCyU0DvWbHX+cqp6RXSXj2lG33pjhPd63LlE2KsXx72j6CBH3A
   1zBqzSdrRl2x+GDJ/ph4QL4L7Xw0j7AInUzIcqXYAV+EHiTz2X+2ePK8ULcLTiRiyTWMnsqGLk7E
   TKd5E80V92NwFVbHVagB4uuQdolKBolk2FENjqmwgJ5+spEdLI6Zx5i2FXxxLot59Gjc6UhDhKe9
   4Ki9QedILNXHbOhO7xsPaqnLwNLg5nbkKHQhTw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Dx2sqHBB2kEPEO2SrrJkDJ9RGA/3RgwQpKVY/QQe+F8=;
 b=nBURlJSC30aixJoE2HtbGvdo0vvqZO5u9YN0UaBz9GF99iaKppLr21IPuXs3/YIWDLdy4WGDPq1d
   q0tZm0WqVsfL8cM0Y+yWMHxVKe2W/Q0YvPFxRFBTnTkdj6AIpfKYH3PvmKJiPTvdRaMG4gdT9V8W
   bQ7Mjsk/yuEQCnTuvdPw/DI80PseT5zHI2usZ4IGmDIDFZIX253Wcnbdq87OMmEe5e5ueQRdydJ6
   2bSmF4zHyNLEg/uFZASjYLuR2WXTOoy7BNrjqEP8ZgGBWPupETpM4nPNrB6PGTsCyaP6rCzpkiCc
   NyY0gNHqxQ7bgwsYfSeZPrMZXBsVDDgH4O4QsA==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWU00ECWJ9B7G70@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 26 Jun 2023 05:58:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; t=1687759083; cv=none; d=strato.com;
 s=strato-dkim-0002;
 b=CKl1kh/BAo8d4ZITFElBVOa7nULJxQUj+1zu7sgx8RnsjXYS7Kg34BuvBL+rComCRS
 aMGOks5RLRWadlBZXcSc9XDADGTNGm5eNnyRr1Wz+HxlAmrpnvphCpvZ4MCtT7LPoU5D
 qx71XPsJxrTvU8wR8/+6u59g1EKQTaJBz6qqOeQx9KOSnFnZ1pv5FWfptncP4A3Cs/GY
 uD6HEjlzR5QA0mbdVGFgB4KxjfyzQMpuvM5MHd/OuTSdthW7dBS3JkCv1mueGUDN0YxV
 jvSJbjSew0u/JNio13fvpAYuNpJHpSiYJ5InCIy+gtOqucalu7lW7WusfBNAJRrLVnh+ chcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1687759083;
 s=strato-dkim-0002; d=strato.com;
 h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
 From:Subject:Sender; bh=gtZH8ZTdPgSNVa9t73EYpG+kD5sFVs9BHW85u23zt7A=;
 b=U3zR43BAy+2862GYTaL8CbIwmByKzu/qJhAZFFlU4mmglbWkFUUA+SvUxH36wUPZGM
 NwL0wzjgb0zzcnvo20de2w7lqvRoPBBnl5q2W9T1diEfZntHm6pGuAYpWKXvie0dFc4a
 f/xwXr3PO+pSU0fbXmCM8RIfRCPsVzNk5x/yvJl1iCPl2gvQgYG0fXtlf/4t7ZHLd5lP
 EGfGlGeHaSGxLA7ULXmVCfXYTtNzw33PlABbAc7F/8PPcOk1BZ1UF3FyI7dHCX5ZWSuV
 y/gEaUOgjkmXmcsTh5cU2A7QiskIXX+tW1NkaS8AWlEiVv6eABYfrhXSwayBk7cP2p8e LQAw==
ARC-Authentication-results: i=1; strato.com;    arc=none;    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1687759083;
 s=strato-dkim-0002; d=iokpp.de;
 h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
 From:Subject:Sender; bh=gtZH8ZTdPgSNVa9t73EYpG+kD5sFVs9BHW85u23zt7A=;
 b=EytPGVy5tJcBww5TmIqfQKwbLj6LpCgbie3fHuss36xwufWhHvwO8F0lrb05wVylJJ
 N9h3lrw/LG9z3WU56mGfOOiz/zCn1+rLOUKGl8EYpC9ioKfl1A4jTcodu1QJRavA8QSf
 hI0vh1zXTswZFbbXmTRemf56kYr/WRl/8/ZfX5L1Vtc7Witj99QSi3996ej+5xV8zUkR
 DbdHCsc/zUQIDMDhSLuPGJDy3RRmosnJUOW9mFqdoV+JPQO65hxJ0TndBpE3l5czAZrg
 lYdk3NlYy0q4dOYSJfdD2KjfJgmQq+/yhW9AiDp/GTVQj2ySC+2KpnO94XJuI9L1hPTo sGeQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1687759083;
 s=strato-dkim-0003; d=iokpp.de;
 h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
 From:Subject:Sender; bh=gtZH8ZTdPgSNVa9t73EYpG+kD5sFVs9BHW85u23zt7A=;
 b=+dkd0g4VvbVAa8otyU5vCOoKWxvRGOx1DJoFaL5XGNR4XZ6HXdeSRscXSDiV3rfivn
 Fsj0fqiZq82BU1Bc/WDw==
Message-id: <4ced64b8089232ea94b697dec1c3595c8bf427ad.camel@iokpp.de>
To: viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 jack@suse.cz, jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 willy@infradead.org, hch@infradead.org
Date: Mon, 26 Jun 2023 07:58:02 +0200
In-reply-to: <20230626054153.839672-1-beanhuo@iokpp.de>
References: <20230626054153.839672-1-beanhuo@iokpp.de>
User-Agent: Evolution 3.44.4-0ubuntu1
MIME-version: 1.0
X-Source-IP: 85.215.255.104
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10752
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=572 suspectscore=0
 spamscore=0 impostorscore=0 mlxscore=0 bulkscore=0 priorityscore=191
 clxscore=131 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306260053
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, beanhuo@micron.com
Subject: Re: [Ocfs2-devel] [PATCH v3 0/2] clean up block_commit_write
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
From: Bean Huo via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Bean Huo <beanhuo@iokpp.de>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-RZG-CLASS-ID: mo03
X-RZG-AUTH:
 ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSeBwhhSxarlUcu05JyMI1zXvWpofGAfnFnDgkM44n56QuhmdHnY0RKOxJL4CsSg7xJ0="
X-ServerName: mo4-p03-ob.smtp.rzone.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: y8isjQ_upKmLFKIBuY6DyQh_SPO4NGdY
X-Proofpoint-ORIG-GUID: y8isjQ_upKmLFKIBuY6DyQh_SPO4NGdY
Reporting-Meta:
 AAFZal5GOeckqfmMUS1j/Xzagh9UeWYR4HCKkn0DBrUCwy4mquKYilHtnLuRzI5m
 /iueKyD27S8HP0focNowF69To+LH6GdvpnmiUlnsENLQdJGGl9UOlOluIkXBgs7C
 CxM5iEB1/9omiRTW3uQossexy4/X07QBs2NHHjLgKK+uewB0I50EuNWxyEAx7j5g
 XR5ozKtKYgaMkc5hXwaW/hOOApE7aRAO0U2LqzJ1JK5UFpJqZoEyazDQ7o52oT9n
 5Vdb8UGkBW8iz+wCZNekd3P7K0ZHwW9yj1jMaaB+nqPPDbKNRg/xTyKAbpEOc1vT
 L9LAn+rQBANJ3nf5+7oHlNo73Czvph7sFtlZLqcP5K97Y+Ai9LkgDS7Oih9vj9iJ
 eQ6hmomZu3ALqengnY8fEgXX651pb1K/bINlLfdsmnA4OylnI5rgHs/gg5vbAM/2
 VRJ0FaexkQNv4nWnIawHDd19cnCB1rm/GRd5TwAfzM+eiQ7NpR4HUpU4xZ8Z8X8i
 066oxbzZir14IPo2uRwgrxuyGqy3+jTtFAItsetebs2D

CgpwbGVhc2UgaWdub3JlIHRoaXMgc2VyaWVzIHBhdGNoIHNpbmNlIGl0IGhhcyBhIHBhdGNoLXNp
Z25lZCBpc3N1ZSwgScKgCmhhdmUgUkVTRU5UIGl0LiAKCgoKT24gTW9uLCAyMDIzLTA2LTI2IGF0
IDA3OjQxICswMjAwLCBCZWFuIEh1byB3cm90ZToKPiBjaGFuZ2UgbG9nOgo+IMKgwqDCoCB2MS0t
djI6Cj4gwqDCoMKgwqDCoMKgwqAgMS4gcmVvcmRlcmVkIHBhdGNoZXMKPiDCoMKgwqAgdjItdjM6
Cj4gwqDCoMKgwqDCoMKgwqAgMS4gcmViYXNlZCBwYXRjaGVzIHRvCj4gZ2l0Oi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L25leHQvbGludXgtbmV4dAo+IAo+IAo+IEJl
YW4gSHVvICgyKToKPiDCoCBmcy9idWZmZXI6IGNsZWFuIHVwIGJsb2NrX2NvbW1pdF93cml0ZQo+
IMKgIGZzOiBjb252ZXJ0IGJsb2NrX2NvbW1pdF93cml0ZSB0byByZXR1cm4gdm9pZAo+IAo+IMKg
ZnMvYnVmZmVyLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDIwICsrKysrKysr
LS0tLS0tLS0tLS0tCj4gwqBmcy9leHQ0L21vdmVfZXh0ZW50LmPCoMKgwqDCoMKgwqAgfMKgIDcg
KystLS0tLQo+IMKgZnMvb2NmczIvZmlsZS5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCA3
ICstLS0tLS0KPiDCoGZzL3VkZi9maWxlLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzC
oCA2ICsrKy0tLQo+IMKgaW5jbHVkZS9saW51eC9idWZmZXJfaGVhZC5oIHzCoCAyICstCj4gwqA1
IGZpbGVzIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDI3IGRlbGV0aW9ucygtKQo+IAoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwg
bWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNs
ZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
