Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE860C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 20 Jul 2022 08:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=C+4tEp2zySQXb4AUBuHMGck2VdNF/oOrb+8jq9ypHr4=;
 b=JB5IA4mZiL9O2WrTjEKl+ifkM0ScE0MIPx9d5pKoFW7wHGcPZfG+jr3BRoopoIYoDtFy/d4diEH0
   zifW8Dl2503rOoxWUODuCbuNDkQfyh0Zakk41LiD6LUpqgUzJaI4KNPN/QfnkRPJ6fjhS+QZhWYP
   rVh2cWZ6g80+SRxHbNUMXFI3V2yTh2g8EZnuX6ksXp0cAphwdIzreZbYDI78QPywv9ZFdkBYCT2g
   JV9UDuM5tfdn3AhMShDhaRFzeZMKftsKuILgM+AguPp97Zlt9qvMTWviyb2bihyNQNNp9jFzqnVP
   wcy4AJwbDZssCljWTKj6mshw6G8r9RaZrg3L2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=C+4tEp2zySQXb4AUBuHMGck2VdNF/oOrb+8jq9ypHr4=;
 b=o7kmPlU0OtfLWbBESe+heICdkb8cjOvztYytD1e/fA0cAswKkzAryPWa5G487QPspMfIhhPtvPfx
   Q5Lk/h7njqhbyxUJH0er7028rb29z9q6yU014GdXcE7q2b4nXQ5Yj511brvF26Qsv41cTDa4ofxZ
   EzfYWebFVlhGu8loU2xzSVoNKDf8s7AuNM7gLQWvmZvZKY41S25K73JncrhIGEzAedu6nRPgywG1
   Z/lZ5Re+oWAS0pTV8g0fcqPDnlDaCudGJMR5tmsAx83tk+lJkNXzn7xbq/hukmWXRFVeULno/cx1
   9TnvqEkBvyoBbpHU3iqqhcEqgugl7jWexBCdRA==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220621 64bit (built Jun 21
 2022))
 with ESMTPS id <0RFB00HFY8SSV100@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 20 Jul 2022 08:26:52 +0000 (GMT)
Message-id: <f313cb6f-de75-2447-eebc-5c240bc243a2@wanadoo.fr>
Date: Wed, 20 Jul 2022 10:26:35 +0200
MIME-version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>
References:
 <bd6796635e58f9c47cf857573c3b9474a00ce26a.1658224839.git.christophe.jaillet@wanadoo.fr>
 <8ba7004d330cbe5f626539a8a3bff696d0c4285e.1658224839.git.christophe.jaillet@wanadoo.fr>
 <7b644e5d32d74d3d90dfc5b1786ae5b9@AcuMS.aculab.com>
 <29c3fbdd-7695-46c5-bb75-fe358c574ab3@wanadoo.fr>
 <07c924de-78bf-c993-ce73-635af71f4edd@linux.alibaba.com>
In-reply-to: <07c924de-78bf-c993-ce73-635af71f4edd@linux.alibaba.com>
X-Source-IP: 80.12.242.130
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10413
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=106
 suspectscore=0 mlxscore=0 spamscore=0 malwarescore=0 bulkscore=0
 priorityscore=221 mlxlogscore=761 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207200035
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
 David.Laight@ACULAB.COM, christophe.jaillet@wanadoo.fr,
 ocfs2-devel@oss.oracle.com
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
From: Marion & Christophe JAILLET via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Content-transfer-encoding: base64
Content-type: text/plain; charset="utf-8"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ME-Helo: [192.168.1.18]
X-ME-Auth:
 YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Wed, 20 Jul 2022 10:26:38 +0200
X-ME-IP: 90.11.190.129
X-ServerName: smtp08.smtpout.orange.fr
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf_gp.wanadoo.fr
 include:spf.email-control.orange-business.com include:_spf_gpf.wanadoo.fr
 include:_spf_other.wanadoo.fr ?all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: Yg4cSoEG4ZWCd_jIw0Ov73RY06-Gvf66
X-Proofpoint-GUID: Yg4cSoEG4ZWCd_jIw0Ov73RY06-Gvf66
Reporting-Meta:
 AAEhac7PmBCYma3W3SGtw1ov8dvVCKBv9PEZgDowz2M06HtIx2OyivR8N8cLWBd9
 1HIph5NY5ukEezNOhSkMh3nVdCW6+wakfWDN4S9WKuw/8c4hxR+6wdh3AB2sx19G
 mpL25Z008vTf0iVNnF0K3AHEyyzZpO6mZa1hyPTnkV91G/GHJETYN6ns8sEmTbmD
 bxFyMdJOXDDc3vBGMKRVGmY5gEPIgOBynQmBJkH4hWmL9liWQh4lSsWyxglDOnF3
 HKa8egM+Jq0mEvVKkodi7XuXGUhwDNe8irapEFqZR9RsDgOBbMmi5Y1v6F6qhode
 CIyTbA7KiuoqP4AaMZPnZg2w2PMtcb+v2MaFNMGkWkgM4E/avE+ObIeAMXmEIiKO
 Ygqwp87G+D5nsjg5qBaJCKwYwaWIY85QM6XtNqCwgOc5m6RPWgMFXB5z4tUb11PC
 IHfxOK5s1GsFquaW2uj2pc/Bp0uDy6wNa51m17upZn9+Xc5pH6lsiQIG/ZEkFB4o
 YOwRSH3hWpZx9CxUFDvBG75/jcidj37eZjVarebMObHW

CkxlIDIwLzA3LzIwMjIgw6AgMDM6NTksIEpvc2VwaCBRaSBhIMOpY3JpdMKgOgo+Cj4gT24gNy8x
OS8yMiA5OjI1IFBNLCBDaHJpc3RvcGhlIEpBSUxMRVQgd3JvdGU6Cj4+IExlIDE5LzA3LzIwMjIg
w6AgMTI6MjQsIERhdmlkIExhaWdodCBhIMOpY3JpdMKgOgo+Pj4gRnJvbTogQ2hyaXN0b3BoZSBK
QUlMTEVUCj4+Pj4gU2VudDogMTkgSnVseSAyMDIyIDExOjAyCj4+Pj4KPj4+PiAnbm9kZV9tYXBf
bG9jaycgaXMgYSBzcGlubG9jayBvbmx5IHVzZWQgdG8gcHJvdGVjdCBjYWxscyB0byBzZXRfYml0
KCksCj4+Pj4gY2xlYXJfYml0KCkgYW5kIHRlc3RfYml0KCkuCj4+Pj4KPj4+PiB7c2V0fGNsZWFy
fV9iaXQoKSBhcmUgYWxyZWFkeSBhdG9taWMgYW5kIGRvbid0IG5lZWQgdGhpcyBleHRyYSBzcGlu
bG9jay4KPj4+PiB0ZXN0X2JpdCgpIG9ubHkgcmVhZHMgdGhlIGJpdG1hcCBmb3IgYSBnaXZlbiBi
aXQuCj4+Pj4KPj4+PiBSZW1vdmUgdGhpcyB1c2VsZXNzIHNwaW5sb2NrLgo+Pj4gSXQgbG9va3Mg
dG8gbWUgbGlrZSB0aGUgY2FsbGluZyBjb2RlIGlzIHJhY3kKPj4+IHVubGVzcyB0aGVyZSBpcyBh
bm90aGVyIGxvY2sgaW4gdGhlIGNhbGxlcnMuCj4+IFRoZSBjYWxsIGNoYWlucyBhcmU6Cj4+ICDC
oCBvY2ZzMl9yZWNvdmVyX29ycGhhbnMoKQo+PiAgwqDCoMKgIG9jZnMyX21hcmtfcmVjb3Zlcmlu
Z19vcnBoYW5fZGlyKCkKPj4gIMKgwqDCoMKgwqAgc3Bpbl9sb2NrKCZvc2ItPm9zYl9sb2NrKTvC
oMKgwqDCoMKgwqDCoCA8LS0gb3NiX2xvY2sgc3BpbmxvY2sKPj4gIMKgwqDCoMKgwqAgb2NmczJf
bm9kZV9tYXBfc2V0X2JpdCgpwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA8LS0gdXNlcyBub2RlX21h
cF9sb2NrCj4+ICDCoMKgwqDCoMKgIC4uLgo+PiAgwqDCoMKgwqDCoCBzcGluX3VubG9jaygmb3Ni
LT5vc2JfbG9jayk7Cj4+ICDCoMKgwqAgLi4uCj4+ICDCoMKgwqAgb2NmczJfY2xlYXJfcmVjb3Zl
cmluZ19vcnBoYW5fZGlyKCkKPj4gIMKgwqDCoMKgwqAgb2NmczJfbm9kZV9tYXBfY2xlYXJfYml0
KCnCoMKgwqDCoMKgwqDCoCA8LS0gdXNlcyBub2RlX21hcF9sb2NrCj4+ICDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgb3NiX2xvY2sgaXMgTk9U
IHRha2VuCj4+Cj4+Cj4+ICDCoCBvY2ZzMl9jaGVja19vcnBoYW5fcmVjb3Zlcnlfc3RhdGUoKQo+
PiAgwqDCoMKgIHNwaW5fbG9jaygmb3NiLT5vc2JfbG9jayk7wqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCA8LS0gb3NiX2xvY2sgc3BpbmxvY2sKPj4gIMKgwqDCoCAuLi4KPj4gIMKgwqDCoCBvY2ZzMl9u
b2RlX21hcF90ZXN0X2JpdCgpwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA8LS0gdXNlcyBub2RlX21h
cF9sb2NrCj4+ICDCoMKgwqAgLi4uCj4+ICDCoMKgwqAgc3Bpbl91bmxvY2soJm9zYi0+b3NiX2xv
Y2spOwo+Pgo+Pgo+PiBTbyB0aGUgY29kZSBsb29rcyBhbHJlYWR5IHByb3RlY3RlZCBieSB0aGUg
J29zYl9sb2NrJyBzcGlubG9jaywgYnV0IEkgZG9uJ3Qga25vdyB0aGlzIGNvZGUgYW5kIG9jZnMy
X21hcmtfcmVjb3ZlcmluZ19vcnBoYW5fZGlyKCkgbG9va3MgdHJpY2t5IHRvIG1lLiAoc28gc29t
ZSBvdGhlciBleWVzIGFyZSBtdWNoIHdlbGNvbWUpCj4gICAKPiBvc2JfbG9jayBpcyB0byBwcm90
ZWN0IG9zYiBmaWxlZCBzdWNoIGFzICdvc2Jfb3JwaGFuX3dpcGVzJywgd2hpbGUKPiBub2RlX21h
cF9sb2NrIGlzIHRvIHByb3RlY3QgdGhlIG5vZGUgbWFwICdvc2JfcmVjb3ZlcmluZ19vcnBoYW5f
ZGlycycKPiBzcGVjaWZpY2FsbHkuCgpUaGFua3MgZm9yIHRoaXMgZXhwbGFuYXRpb24uCgpCdXQg
ZG9lcyAibm9kZV9tYXBfbG9jayIgcmVhbGx5IHByb3RlY3RzIGFueXRoaW5nPwpJdCBpcyBqdXN0
IGFyb3VuZCBzb21lIGF0b21pYyBmdW5jdGlvbiBjYWxscyB3aGljaCBzaG91bGRuJ3QgbmVlZCBh
bnksIApyaWdodD8KCnRlc3RfYml0KCkgaXMgbm90IGRvY3VtZW50ZWQgYXMgYXRvbWljLCBidXQg
e2NsZWFyfHNldH1fYml0KCkgY291bGQgYmUgCmV4ZWN1dGVkIGp1c3QgYmVmb3JlIG9yIGp1c3Qg
YWZ0ZXIgaXQgd2l0aCB0aGUgY3VycmVudCBsb2NraW5nIAptZWNoYW5pc20sIHNvIEkgZG9uJ3Qg
cmVhbGx5IHNlZSBob3cgaXQgd291bGQgbWFrZSBhIGRpZmZlcmVuY2UuCgpJIGRvbid0IHVuZGVy
c3RhbmQgdGhlIGxvZ2ljIG9mIHRoaXMgbG9jayBoZXJlLgoKQ2FuIHlvdSBlbGFib3JhdGU/CgpD
SgoKCj4gVGhhbmtzLAo+IEpvc2VwaAo+CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3Nz
Lm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMy
LWRldmVs
