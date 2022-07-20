Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB7B3C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 20 Jul 2022 02:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nX5NqmimOT4iIibZptib9LkwnajQadF1cb2C4Q1mniA=;
 b=zAWRiWOiPzHF5Zb/BcrXIQiQ6OnmgSZqJDUrwn9y5qI8Ykz5/jyTCdMtjNMjueerhzcs5sJcCbWd
   UOP1XTsmrteRRuW5OfIS8S+HPQag2kVyQzepILOiY/LxeC6WBKmQJACD8UJN8rCPR9MZsIhZcJXP
   b0/H9r21/n/SY9T1fqOjflvMeMcSWP+AuU2DEeG93pV7DJPJBBnvslGZZDjXrbqYDgmu2MtPTOtK
   oRcGvQFbngUBNB3yIjTrq9PoiDekBAmkmPH+egOuvZGtF+9ZPZ0+0Pw3/qSPzBpaKvTkmMMyTRUD
   nCVw2FgbNrUfLI0iOi6PMz/CYkhlnMN6jnR8/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=nX5NqmimOT4iIibZptib9LkwnajQadF1cb2C4Q1mniA=;
 b=p+Qa9s7utjI5H1/gA7szLkQG9TWGnKUNy3xtG1FAQCnHdnKknurzSuWzI+j1B00wS5W4eRf7TjN9
   LjvuxFVMkBmAkm+O24zZ1L6+Y84oNBv2m0N045MmP8GW1kQ/1hK6cJGBfTKJFfbJu0x7Tf2dzwI2
   xwk4lr5urjgNDDuixqHLigH/AurkKyp7aFkyA6M7WooM2MQBIrb1ahXeqnPwSlF+kcJsVcN628up
   aN62LR+hVbFLcYijAM+Rh0bB6aIPpr1X3EheTvwR2pbd9/8zQ3I5IYT163c6Wpdbo3T9F6KYJzYa
   XA6BO+67j/YWlKWFRgyZis6Us0cKrrcxbsRE5A==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RFA0035NQW80UA0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 20 Jul 2022 02:00:10 +0000 (GMT)
Message-id: <07c924de-78bf-c993-ce73-635af71f4edd@linux.alibaba.com>
Date: Wed, 20 Jul 2022 09:59:47 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-language: en-US
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 David Laight <David.Laight@ACULAB.COM>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
References:
 <bd6796635e58f9c47cf857573c3b9474a00ce26a.1658224839.git.christophe.jaillet@wanadoo.fr>
 <8ba7004d330cbe5f626539a8a3bff696d0c4285e.1658224839.git.christophe.jaillet@wanadoo.fr>
 <7b644e5d32d74d3d90dfc5b1786ae5b9@AcuMS.aculab.com>
 <29c3fbdd-7695-46c5-bb75-fe358c574ab3@wanadoo.fr>
In-reply-to: <29c3fbdd-7695-46c5-bb75-fe358c574ab3@wanadoo.fr>
X-Source-IP: 47.90.199.17
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10413
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=975
 clxscore=188 bulkscore=0 lowpriorityscore=0 phishscore=0 priorityscore=0
 malwarescore=0 spamscore=0 suspectscore=0 impostorscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207200006 domainage_hfrom=8497
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 2/3] ocfs2: Remove a useless spinlock
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R961e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046059;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VJuiYTA_1658282387;
X-ServerName: out199-17.us.a.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: xpuvQ12CQzPvKz-Ojnf9fTn8icr4dtiV
X-Proofpoint-ORIG-GUID: xpuvQ12CQzPvKz-Ojnf9fTn8icr4dtiV
Reporting-Meta:
 AAF/bPsR7xWVRCmxDjAoYhIR4gmYxWIIRK5Z+HuC7exgLiXPMwsEXU1QDU7ffhO6
 RxYJKCjP71HYLD7KeKVWA/FZ9zdiTxboXgUW/d3VkC63zsR2sMotgJXVFguq8wjl
 iDjcHvWoSBMm6M92rTTXkPmWd02CMqGhG7MlZlWvlXcRvuzXtP8N/h8vT7hPGedf
 c3SUikXthOn8RhHJfOSTVm7mIYLybQUy9k+eE2WPkbo13Gti/lsmvhjFNjdsFrKL
 qGR5wwzkcD06/5Cl7G+15oox+qom7UZ0hsegy2FNtr1kartTNYgbJies5lWfsIsF
 Ue3rHuINvBYjhLM5/L5yOl1wdNY4ieJKIoAkhbj/WMPeF7AXRlvANDoHB8ZHAPjh
 ZLPaMEZEHnt/GyrBn5aON9nY8vZRa0ejMp1jFbBr4XSVMpYLfP+4C/zhUCx668v+
 A+uiRa3iRwIpYVdTD7s8ulnGZj4RciW/4UVCpA6uVrl6WDD+bRHQQQPgQkFjyBu8
 R74XdPJ+BVvApptM1lpD+3MgYZAcCa/dGAa6Fl/ftJhT

CgpPbiA3LzE5LzIyIDk6MjUgUE0sIENocmlzdG9waGUgSkFJTExFVCB3cm90ZToKPiBMZSAxOS8w
Ny8yMDIyIMOgIDEyOjI0LCBEYXZpZCBMYWlnaHQgYSDDqWNyaXTCoDoKPj4gRnJvbTogQ2hyaXN0
b3BoZSBKQUlMTEVUCj4+PiBTZW50OiAxOSBKdWx5IDIwMjIgMTE6MDIKPj4+Cj4+PiAnbm9kZV9t
YXBfbG9jaycgaXMgYSBzcGlubG9jayBvbmx5IHVzZWQgdG8gcHJvdGVjdCBjYWxscyB0byBzZXRf
Yml0KCksCj4+PiBjbGVhcl9iaXQoKSBhbmQgdGVzdF9iaXQoKS4KPj4+Cj4+PiB7c2V0fGNsZWFy
fV9iaXQoKSBhcmUgYWxyZWFkeSBhdG9taWMgYW5kIGRvbid0IG5lZWQgdGhpcyBleHRyYSBzcGlu
bG9jay4KPj4+IHRlc3RfYml0KCkgb25seSByZWFkcyB0aGUgYml0bWFwIGZvciBhIGdpdmVuIGJp
dC4KPj4+Cj4+PiBSZW1vdmUgdGhpcyB1c2VsZXNzIHNwaW5sb2NrLgo+Pgo+PiBJdCBsb29rcyB0
byBtZSBsaWtlIHRoZSBjYWxsaW5nIGNvZGUgaXMgcmFjeQo+PiB1bmxlc3MgdGhlcmUgaXMgYW5v
dGhlciBsb2NrIGluIHRoZSBjYWxsZXJzLgo+IAo+IFRoZSBjYWxsIGNoYWlucyBhcmU6Cj4gwqAg
b2NmczJfcmVjb3Zlcl9vcnBoYW5zKCkKPiDCoMKgwqAgb2NmczJfbWFya19yZWNvdmVyaW5nX29y
cGhhbl9kaXIoKQo+IMKgwqDCoMKgwqAgc3Bpbl9sb2NrKCZvc2ItPm9zYl9sb2NrKTvCoMKgwqDC
oMKgwqDCoCA8LS0gb3NiX2xvY2sgc3BpbmxvY2sKPiDCoMKgwqDCoMKgIG9jZnMyX25vZGVfbWFw
X3NldF9iaXQoKcKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgPC0tIHVzZXMgbm9kZV9tYXBfbG9jawo+
IMKgwqDCoMKgwqAgLi4uCj4gwqDCoMKgwqDCoCBzcGluX3VubG9jaygmb3NiLT5vc2JfbG9jayk7
Cj4gwqDCoMKgIC4uLgo+IMKgwqDCoCBvY2ZzMl9jbGVhcl9yZWNvdmVyaW5nX29ycGhhbl9kaXIo
KQo+IMKgwqDCoMKgwqAgb2NmczJfbm9kZV9tYXBfY2xlYXJfYml0KCnCoMKgwqDCoMKgwqDCoCA8
LS0gdXNlcyBub2RlX21hcF9sb2NrCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIG9zYl9sb2NrIGlzIE5PVCB0YWtlbgo+IAo+IAo+IMKgIG9j
ZnMyX2NoZWNrX29ycGhhbl9yZWNvdmVyeV9zdGF0ZSgpCj4gwqDCoMKgIHNwaW5fbG9jaygmb3Ni
LT5vc2JfbG9jayk7wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA8LS0gb3NiX2xvY2sgc3BpbmxvY2sK
PiDCoMKgwqAgLi4uCj4gwqDCoMKgIG9jZnMyX25vZGVfbWFwX3Rlc3RfYml0KCnCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIDwtLSB1c2VzIG5vZGVfbWFwX2xvY2sKPiDCoMKgwqAgLi4uCj4gwqDCoMKg
IHNwaW5fdW5sb2NrKCZvc2ItPm9zYl9sb2NrKTsKPiAKPiAKPiBTbyB0aGUgY29kZSBsb29rcyBh
bHJlYWR5IHByb3RlY3RlZCBieSB0aGUgJ29zYl9sb2NrJyBzcGlubG9jaywgYnV0IEkgZG9uJ3Qg
a25vdyB0aGlzIGNvZGUgYW5kIG9jZnMyX21hcmtfcmVjb3ZlcmluZ19vcnBoYW5fZGlyKCkgbG9v
a3MgdHJpY2t5IHRvIG1lLiAoc28gc29tZSBvdGhlciBleWVzIGFyZSBtdWNoIHdlbGNvbWUpCiAK
b3NiX2xvY2sgaXMgdG8gcHJvdGVjdCBvc2IgZmlsZWQgc3VjaCBhcyAnb3NiX29ycGhhbl93aXBl
cycsIHdoaWxlCm5vZGVfbWFwX2xvY2sgaXMgdG8gcHJvdGVjdCB0aGUgbm9kZSBtYXAgJ29zYl9y
ZWNvdmVyaW5nX29ycGhhbl9kaXJzJwpzcGVjaWZpY2FsbHkuCgpUaGFua3MsCkpvc2VwaAoKCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVs
IG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFj
bGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
