Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B10BBC7EE23
	for <ocfs2-devel@archiver.kernel.org>; Wed, 31 May 2023 15:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MmjmomFoKFfCjQmVVG62m+MZZv+tbyV+iERVfNHj/N0=;
 b=0Qb5XYc1p9oEMj5wBbFD/JMtMeOUbpB1HblEKSJDDM9XIHH4hAnMdScxqT7r5DAk7+RyZL2earTj
   rH3d4c6/XTnB+f+3d1gcCwyo77pKXX+8O9G5wH+dPzXciQLkA3cR1lUZsFGh7TtfwixsIq2VjDy0
   uTSD7bgBLal9e1C/sJIZb10s2LaFQnHOJywRcBrBvOKNCPHyl4lizB72Fga9Aj+MTZT19w3xb8gS
   IFysqFrUeJZm/Zk6fm/a973JHCiDDgBcQ2/Aj9emMs85+f2DsZMGGXnKb97KtF/gEZUfwAi2tA4W
   lgo3ch+HxvbZppq2L237nnlAzed2+usxNsg1zQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MmjmomFoKFfCjQmVVG62m+MZZv+tbyV+iERVfNHj/N0=;
 b=trMAGHWWlyGRUAaXkRAhjTw1ltHT73tSP2Se6KF16KCsDIhyiIpQks82v/kjK6JmGAqg9hMR6Gnr
   DUcaXgUfqRCtOVoQVrzQnnNMo/O2Iv/wXL+P9f3T2NNr77jhRfE+UP7JqqRelx8YlkPnL5QBtkNT
   wzCNLg0anLhK5pjzUCbEdQBcD5JdvAUYoD+HxBAcKqDWqVnI8CShGrP2vPGvwDLrMEMuLoB+vmQ6
   oY6T9QDM93JmJXgN0BAY63x5p4x4yv0GtsRByagSTmrxCe+Z+GB7nEjfzyvsMUHzb7JNTMXnupz1
   p4M34Mt3621Bc7j3ypLZykWbwMV+ZkOYx4CJ+g==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230522 64bit (built May 22
 2023))
 with ESMTPS id <0RVJ00GPF4NBWU40@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 31 May 2023 15:35:35 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
 t=1685521764;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=jURzmeyEuYooQh/U4B38nFvx+WNhymEAqUYSpuRZwN8=;
 b=dwWQ0qfDzg83xo2Ggs8eARaFApu5CdAHC9izhUX3aEfnXam0fkYgGbYUYUpzLH4/xIVbWQ
 OWdQbIO5D2o9DIs/1VquMlOxysfM8AZl9B2AyGMVeLqeVkFwxUuiBlYVKoImSPEE5dXSI+
 asYTe2qAYFuws4qN+nhMuVryizueYxc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
 s=susede2_ed25519; t=1685521764;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=jURzmeyEuYooQh/U4B38nFvx+WNhymEAqUYSpuRZwN8=;
 b=8Mt+128mUFtzweJgPE1nZDPQaLgFRGqrWw0qrq/HtbCZ0C1Lp6uM5wi/AQwpjlHTv/IAlC
 Mudh+FFPoCF9JkBg==
To: Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20230529152645.32680-1-lhenriques@suse.de>
 <810630b9-2021-01b3-1473-aa759174205e@linux.alibaba.com>
Date: Wed, 31 May 2023 09:29:18 +0100
In-reply-to: <810630b9-2021-01b3-1473-aa759174205e@linux.alibaba.com>
 (Joseph Qi's message of "Wed, 31 May 2023 14:00:12 +0800")
Message-id: <87fs7c3nvl.fsf@suse.de>
MIME-version: 1.0
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10726
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 priorityscore=108 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 clxscore=109 mlxscore=0 mlxlogscore=697 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305310073
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
From: =?utf-8?Q?Lu=C3=ADs_Henriques?= via Ocfs2-devel
 <ocfs2-devel@oss.oracle.com>
Reply-to: =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out2.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:195.135.220.0/27
 ip6:2001:67c:2178:6::/120 ~all
X-Spam: Clean
X-Proofpoint-GUID: 1M5dtsvEGtaq9SeqMA1PB3nKd2i0sxrQ
X-Proofpoint-ORIG-GUID: 1M5dtsvEGtaq9SeqMA1PB3nKd2i0sxrQ
X-Mailman-Approved-At: Wed, 31 May 2023 15:35:33 +0000
Reporting-Meta:
 AAHq/EGcEBYAQ0QgRqcrCqRJQkwkywMUlHhd6vl73JarP3WJfuFWOBjenpI7It/1
 W+KEbV5ckHL6z5xZpkt7opWHsdB5q6G+NPbXi2AylHptmKvPl8FnG5egNMPcUGFu
 CAdqor4xmQ9EPOuF3UWqy1oj34m4FRBxcxvPouGrx2+xt78PcPcZQw1lUkRJwgp+
 2U/WcrLvKClr0kcHgOc+XwgwIwgOwUcFC7iVkkGohWB0UB03vJDfBhrn2FpmWGOF
 Yx+xnYGfx9zKIzihWaaSsJ/cjAXDsn6Qofd4bkOuG5hXRzktVmEfomNJHohWrFBi
 SRloRwzBLTkmS8wiRHGBOuingD57WlD9YfFIPacmpgQiSYckaJ11gWAmNsesQ4Wb
 Lw7ZRUP4unJyE0uMorOe+/7CHL61qMXFZNxwGSoeaOXv445zN2eUSVHAnrVCKaEw
 b9yujKUNTgOaYfF6wD/i47I4fIufKY9XxDpNJeNBYdEpD/gpKTmmn48kvht3wBj0
 TSzsZYA3ZXx4o3tQG3eOZpMCu7LKltz4bbIl39CsFls=

Sm9zZXBoIFFpIDxqb3NlcGgucWlAbGludXguYWxpYmFiYS5jb20+IHdyaXRlczoKCj4gT24gNS8y
OS8yMyAxMToyNiBQTSwgTHXDrXMgSGVucmlxdWVzIHdyb3RlOgo+PiBXaGVuIGNoYW5naW5nIGEg
ZmlsZSBzaXplIHdpdGggZmFsbG9jYXRlKCkgdGhlIG5ldyBzaXplIGlzbid0IGJlaW5nCj4+IGNo
ZWNrZWQuICBJbiBwYXJ0aWN1bGFyLCB0aGUgRlNJWkUgdWxpbWl0IGlzbid0IGJlaW5nIGNoZWNr
ZWQsIHdoaWNoIG1ha2VzCj4+IGZzdGVzdCBnZW5lcmljLzIyOCBmYWlsLiAgU2ltcGx5IGFkZGlu
ZyBhIGNhbGwgdG8gaW5vZGVfbmV3c2l6ZV9vaygpIGZpeGVzCj4+IHRoaXMgaXNzdWUuCj4+IAo+
PiBTaWduZWQtb2ZmLWJ5OiBMdcOtcyBIZW5yaXF1ZXMgPGxoZW5yaXF1ZXNAc3VzZS5kZT4KPj4g
LS0tCj4+ICBmcy9vY2ZzMi9maWxlLmMgfCA4ICsrKysrKystCj4+ICAxIGZpbGUgY2hhbmdlZCwg
NyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4+IAo+PiBkaWZmIC0tZ2l0IGEvZnMvb2Nm
czIvZmlsZS5jIGIvZnMvb2NmczIvZmlsZS5jCj4+IGluZGV4IGVmYjA5ZGU0MzQzZC4uYjE3M2Mz
NmJjYWIzIDEwMDY0NAo+PiAtLS0gYS9mcy9vY2ZzMi9maWxlLmMKPj4gKysrIGIvZnMvb2NmczIv
ZmlsZS5jCj4+IEBAIC0yMTAwLDE0ICsyMTAwLDIwIEBAIHN0YXRpYyBsb25nIG9jZnMyX2ZhbGxv
Y2F0ZShzdHJ1Y3QgZmlsZSAqZmlsZSwgaW50IG1vZGUsIGxvZmZfdCBvZmZzZXQsCj4+ICAJc3Ry
dWN0IG9jZnMyX3NwYWNlX3Jlc3Ygc3I7Cj4+ICAJaW50IGNoYW5nZV9zaXplID0gMTsKPj4gIAlp
bnQgY21kID0gT0NGUzJfSU9DX1JFU1ZTUDY0Owo+PiArCWludCByZXQgPSAwOwo+PiAgCj4+ICAJ
aWYgKG1vZGUgJiB+KEZBTExPQ19GTF9LRUVQX1NJWkUgfCBGQUxMT0NfRkxfUFVOQ0hfSE9MRSkp
Cj4+ICAJCXJldHVybiAtRU9QTk9UU1VQUDsKPgo+IFRoaXMgbWVhbnMgd2Ugb25seSBzdXBwb3J0
IGtlZXAtc2l6ZSBhbmQgcG91Y2hfaG9sZS4KPiBBbmQgaXQgc2VlbXMgcG91Y2hfaG9sZSB3aWxs
IGFsc28gaW1wbHkga2VlcC1zaXplLgoKSSB0aGluayB5b3UncmUgZm9yZ2V0dGluZyBhYm91dCBt
b2RlID0gMCwgd2hpY2ggaXMgYWxzbyB2YWxpZC4gIEFuZCB0aGUKZGVmYXVsdCAnMCcgd2lsbCBh
bGxvdyBzaXplIHRvIGJlIGNoYW5nZWQuCgo+PiAgCWlmICghb2NmczJfd3JpdGVzX3Vud3JpdHRl
bl9leHRlbnRzKG9zYikpCj4+ICAJCXJldHVybiAtRU9QTk9UU1VQUDsKPj4gIAo+PiAtCWlmICht
b2RlICYgRkFMTE9DX0ZMX0tFRVBfU0laRSkKPj4gKwlpZiAobW9kZSAmIEZBTExPQ19GTF9LRUVQ
X1NJWkUpIHsKPj4gIAkJY2hhbmdlX3NpemUgPSAwOwo+PiArCX0gZWxzZSB7Cj4KPiBTZWVtcyB0
aGlzIHdpbGwgYmUgYSBkZWFkIGJyYW5jaD8KCkFnYWluLCB5b3UgbmVlZCB0byBjb25zaWRlciAn
MCcgYXMgYSB2YWxpZCBtb2RlIHZhbHVlLiAgSWYgeW91IHJ1bgpnZW5lcmljLzIyOCB3aXRob3V0
IHRoaXMgcGF0Y2ggeW91J2xsIHNlZSB0aGF0IHRlc3QgZmFpbGluZyBiZWNhdXNlIGl0Cipkb2Vz
KiBoaXQgdGhpcyBicmFuY2guCgpDaGVlcnMsCi0tIApMdcOtcwoKPgo+IFRoYW5rcywKPiBKb3Nl
cGgKPgo+PiArCQlyZXQgPSBpbm9kZV9uZXdzaXplX29rKGlub2RlLCBvZmZzZXQgKyBsZW4pOwo+
PiArCQlpZiAocmV0KQo+PiArCQkJcmV0dXJuIHJldDsKPj4gKwl9Cj4+ICAKPj4gIAlpZiAobW9k
ZSAmIEZBTExPQ19GTF9QVU5DSF9IT0xFKQo+PiAgCQljbWQgPSBPQ0ZTMl9JT0NfVU5SRVNWU1A2
NDsKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2Zz
Mi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9v
c3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
