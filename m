Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60D93C4332F
	for <ocfs2-devel@archiver.kernel.org>; Fri,  9 Dec 2022 17:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=u7McYSEJRsWmuksOs8QPhoLiUWMUUMaDdMqNoZItEPo=;
 b=RVjH8slNtx/1vl1yR+QdOACJ6U61kyXP+jFk41k0j65syCNrxnKeyAu33KsBqyk0QjSxwaEIhxGb
   g2dT5ZLj8xNwBPnDeGC6MkZ8hWo6yS2uFixImwE+H9+OWjHnJ5P3yDOVw0Ot9Bue0/HH4pJWGPJ9
   1weQJ2339IMJ0pFvr1GbvJAsH/fwNPa7lNDrqGHxesNt6rNExU3NTl/FEwoW7aRbLYGWwqDTBgYU
   kZK3n3JNGiatUQH9RZOv9suytGDz6NHVfq1ch6lrCGaA4iXL57t1ervQszcBxTEQiFQYWm2ZtqpY
   5aBrQTEj7KynqyHiwXNXAoS+xCBgBP37IPKnKw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=u7McYSEJRsWmuksOs8QPhoLiUWMUUMaDdMqNoZItEPo=;
 b=iaF/GTdheqovO984b+vRWjoJ062c5LnrQpfoY5pAvY4u8ZY4NsfAUeTIQxnQJZ9MJ5cVhL0b8bzM
   dsTTYbBNKgNnvqULAXI4ienV45Ht69ThAS/3nFP1Rib+bI2ZbPD6I/2+dy9DhOIWpXk4NFzkpvUF
   EXqmm7PbAPVYijQxgxgK+nQMq2C9Fe5oqgX9kVNbIlhwVcARXzqhG5gr6R7fhQxwN2VBXnxvd//o
   XfbCB9AaFCKd+oiv1FNm8dgBzRjee2TR6WGXOyeAmcJjj6zPcljQcdTbToTstNTJMjJmY3tHMmvs
   7z+SpDmAKZXvYqw+f9kH3X/xiDtBItCdaXpq6g==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221201 64bit (built Dec  1
 2022))
 with ESMTPS id <0RMM00H05VM2AN80@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 09 Dec 2022 17:08:26 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1670589437;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=kKcc7XQPg0UZn1AHNfQ4N2d5zF9JzBW3g3hPGFAB4Kc=;
 b=RCINuJTeUeYCQBakXyQRyndv7x1XrNzrnrgnlg0FDvX8mZo25A82W2gevS2LWyQllIBU+y
 7k9LO877LrTB7B2IRBYSIHv31p9z1rbwUZUVTQVXZgZy5s0zr5eduo1wqiER0jzbzicu6P
 zGpnWl1HeFVGeWphxrZzwJxgqsncqrk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112; h=content-transfer-encoding:mime-version:user-agent:references
 :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=kKcc7XQPg0UZn1AHNfQ4N2d5zF9JzBW3g3hPGFAB4Kc=;
 b=Z5LViKyrSrPEuZulwDrmvhM/5KDvM0hcJjjDa5IoSb5VKWHESnxFoa4x1Bo/DFiLD+
 NWlMhsbBFJYxFtITDfHNvg860cJps2hFEozqOgzc3WznEPCJb4o7TbAsLB6SELR9Oyep
 b7vw7tZ34qY0pgbAUrG8sbfSG9Wudt79W1ArtptJYD35mTh935SJcLsTVbs3ZZ/6733+
 p2qXiIQ5gG+FY4Q09CBg9waKARR0Vxd9XYIlsO6T8yB3RmDnBc4m5qcOw45dmPaRZ9A7
 HVnsTYe19bazzhJKXVLBJchb64feiK1odcJQFRMMrkNcnm8r9PDQkvhH1GMo7Z6fQxEY RNrQ==
X-Gm-Message-State: ANoB5pmdPvSD0Oxqe8P3SLgak1pD1RhbtPgBYvkFUVtwrwiKdciOhlbV
 ar+N9V0+HyLSF/WbLj3i+eDFdLNtOKbPPGOXIpLVOt8I3ngBwTznzTyx4YWb8g/AUncxS2WGZRp
 qd8kZnowTyDPx2RpZdjwVAg==
X-Received: by 2002:a05:600c:4fd0:b0:3d1:c0a1:4804 with SMTP id
 o16-20020a05600c4fd000b003d1c0a14804mr4752753wmq.17.1670589432843; Fri,
 09 Dec 2022 04:37:12 -0800 (PST)
X-Received: by 2002:a05:600c:4fd0:b0:3d1:c0a1:4804 with SMTP id
 o16-20020a05600c4fd000b003d1c0a14804mr4752714wmq.17.1670589432518; Fri,
 09 Dec 2022 04:37:12 -0800 (PST)
Message-id: <d220402a232e204676d9100d6fe4c2ae08f753ee.camel@redhat.com>
To: Benjamin Coddington <bcodding@redhat.com>, netdev@vger.kernel.org
Date: Fri, 09 Dec 2022 13:37:08 +0100
In-reply-to:
 <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
References: <cover.1669036433.git.bcodding@redhat.com>
 <c2ec184226acd21a191ccc1aa46a1d7e43ca7104.1669036433.git.bcodding@redhat.com>
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35)
MIME-version: 1.0
X-Source-IP: 170.10.129.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10555
 signatures=596816
Cc: Latchesar Ionkov <lucho@ionkov.net>, samba-technical@lists.samba.org,
 Dominique Martinet <asmadeus@codewreck.org>,
 Valentina Manea <valentina.manea.m@gmail.com>, linux-nvme@lists.infradead.org,
 Philipp Reisner <philipp.reisner@linbit.com>,
 David Howells <dhowells@redhat.com>, Eric Dumazet <edumazet@google.com>,
 linux-nfs@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
 Shuah Khan <shuah@kernel.org>, Mike Christie <michael.christie@oracle.com>,
 drbd-dev@lists.linbit.com, linux-cifs@vger.kernel.org,
 Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
 linux-afs@lists.infradead.org, cluster-devel@redhat.com,
 Christine Caulfield <ccaulfie@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 Ilya Dryomov <idryomov@gmail.com>, open-iscsi@googlegroups.com,
 Anna Schumaker <anna@kernel.org>, Eric Van Hensbergen <ericvh@gmail.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
 linux-block@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
 Keith Busch <kbusch@kernel.org>, ceph-devel@vger.kernel.org,
 Xiubo Li <xiubli@redhat.com>,
 Trond Myklebust <trond.myklebust@hammerspace.com>,
 Jens Axboe <axboe@kernel.dk>, Chris Leech <cleech@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org,
 Steve French <sfrench@samba.org>, Christoph =?ISO-8859-1?Q?B=F6hmwalder?=
 <christoph.boehmwalder@linbit.com>, Chuck Lever <chuck.lever@oracle.com>,
 Lee Duncan <lduncan@suse.com>, Lars Ellenberg <lars.ellenberg@linbit.com>,
 "David S. Miller" <davem@davemloft.net>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v1 2/3] Treewide: Stop corrupting socket's
	task_frag
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
From: Paolo Abeni via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Paolo Abeni <pabeni@redhat.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: lRU7vIU1Nh6QX-X3aVMLyA-1
X-Google-Smtp-Source:
 AA0mqf5DyMiYpWNcqaQueb0cVh7tJ5lH4JY75MZjLcmrbwYgfM+x/au0sr5C4m2hvq8cZrZMVyWo5g==
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 ip4:136.147.176.0/20 ip4:148.105.8.0/21 ip4:149.72.0.0/16 ip4:159.183.0.0/16
 include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 ip4:136.147.176.0/20 ip4:148.105.8.0/21 ip4:149.72.0.0/16 ip4:159.183.0.0/16
 include:spf1.redhat.com -all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: itvVhG04cVsiwmoyQ4E0q0Fhhi-GJ-9F
X-Proofpoint-ORIG-GUID: itvVhG04cVsiwmoyQ4E0q0Fhhi-GJ-9F
X-Mailman-Approved-At: Fri, 09 Dec 2022 17:08:25 +0000
Reporting-Meta:
 AAHslP3GxLhMM3zEY+2vuTVsuzqiGnmTDPgYIfP/2++tBPDgvsCwkfr/yH7fY5/S
 AIG3BfPNzujwl9Lda/BCyG5tQowFGbOkPAYdCZ6ASLTNqyZtKswCe7DROqJ3h6Sv
 cAOkKO33LJlBG2e4Iw/OwxMJFECZAyt7NJHoTsEqUhiFXKwsTmV/Jdanm0Vzd1sS
 z/tjR9WY35beUaf5F3Ss0MaZq4xzgFW6QmbkS1LaSfXX6Y3I7+T6qf2g77nEMaGR
 0D0rwv+2chdAo4vLsdEcVVwyiIBiGk2Jv7bL+2RjuA1PdK36jPBQPfb2DMcWj3HT
 WR5ZJ1u+y9ii8Rl+lPeUN6H/wfGPWtqPKS1gcuW6pSN+s4ZWlfRQtyzluu1t8aU/
 6kh6EgR+mhTWOYNneEIavPxYbj2WU9JZAlSuxCfXMQsD9hVLlx4N7lUIYGym61XC
 9YwWb0/4YWhl12Fb5yPTylB68i7i+D7+DEYEKcBPz/ksW/nptIwUjn9k1fJFoeLR
 2ub7902OZ9VddptYcULCYzj9GcyjC3Cngxim9R53fDdT

T24gTW9uLCAyMDIyLTExLTIxIGF0IDA4OjM1IC0wNTAwLCBCZW5qYW1pbiBDb2RkaW5ndG9uIHdy
b3RlOgo+IFNpbmNlIG1vdmluZyB0byBtZW1hbGxvY19ub2ZzX3NhdmUvcmVzdG9yZSwgU1VOUlBD
IGhhcyBzdG9wcGVkIHNldHRpbmcgdGhlCj4gR0ZQX05PSU8gZmxhZyBvbiBza19hbGxvY2F0aW9u
IHdoaWNoIHRoZSBuZXR3b3JraW5nIHN5c3RlbSB1c2VzIHRvIGRlY2lkZQo+IHdoZW4gaXQgaXMg
c2FmZSB0byB1c2UgY3VycmVudC0+dGFza19mcmFnLiAgVGhlIHJlc3VsdHMgb2YgdGhpcyBhcmUK
PiB1bmV4cGVjdGVkIGNvcnJ1cHRpb24gaW4gdGFza19mcmFnIHdoZW4gU1VOUlBDIGlzIGludm9s
dmVkIGluIG1lbW9yeQo+IHJlY2xhaW0uCj4gCj4gVGhlIGNvcnJ1cHRpb24gY2FuIGJlIHNlZW4g
aW4gY3Jhc2hlcywgYnV0IHRoZSByb290IGNhdXNlIGlzIG9mdGVuCj4gZGlmZmljdWx0IHRvIGFz
Y2VydGFpbiBhcyBhIGNyYXNoaW5nIG1hY2hpbmUncyBzdGFjayB0cmFjZSB3aWxsIGhhdmUgbm8K
PiBldmlkZW5jZSBvZiBiZWluZyBuZWFyIE5GUyBvciBTVU5SUEMgY29kZS4gIEkgYmVsaWV2ZSB0
aGlzIHByb2JsZW0gdG8KPiBiZSBtdWNoIG1vcmUgcGVydmFzaXZlIHRoYW4gcmVwb3J0cyB0byB0
aGUgY29tbXVuaXR5IG1heSBpbmRpY2F0ZS4KPiAKPiBGaXggdGhpcyBieSBoYXZpbmcga2VybmVs
IHVzZXJzIG9mIHNvY2tldHMgdGhhdCBtYXkgY29ycnVwdCB0YXNrX2ZyYWcgZHVlCj4gdG8gcmVj
bGFpbSBzZXQgc2tfdXNlX3Rhc2tfZnJhZyA9IGZhbHNlLiAgUHJlZW1wdGl2ZWx5IGNvcnJlY3Rp
bmcgdGhpcwo+IHNpdHVhdGlvbiBmb3IgdXNlcnMgdGhhdCBzdGlsbCBzZXQgc2tfYWxsb2NhdGlv
biBhbGxvd3MgdGhlbSB0byBjb252ZXJ0IHRvCj4gbWVtYWxsb2Nfbm9mc19zYXZlL3Jlc3RvcmUg
d2l0aG91dCB0aGUgc2FtZSB1bmV4cGVjdGVkIGNvcnJ1cHRpb25zIHRoYXQgYXJlCj4gc3VyZSB0
byBmb2xsb3csIHVubGlrZWx5IHRvIHNob3cgdXAgaW4gdGVzdGluZywgYW5kIGRpZmZpY3VsdCB0
byBiaXNlY3QuCj4gCj4gQ0M6IFBoaWxpcHAgUmVpc25lciA8cGhpbGlwcC5yZWlzbmVyQGxpbmJp
dC5jb20+Cj4gQ0M6IExhcnMgRWxsZW5iZXJnIDxsYXJzLmVsbGVuYmVyZ0BsaW5iaXQuY29tPgo+
IENDOiAiQ2hyaXN0b3BoIELDtmhtd2FsZGVyIiA8Y2hyaXN0b3BoLmJvZWhtd2FsZGVyQGxpbmJp
dC5jb20+Cj4gQ0M6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KPiBDQzogSm9zZWYgQmFj
aWsgPGpvc2VmQHRveGljcGFuZGEuY29tPgo+IENDOiBLZWl0aCBCdXNjaCA8a2J1c2NoQGtlcm5l
bC5vcmc+Cj4gQ0M6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+IENDOiBTYWdpIEdy
aW1iZXJnIDxzYWdpQGdyaW1iZXJnLm1lPgo+IENDOiBMZWUgRHVuY2FuIDxsZHVuY2FuQHN1c2Uu
Y29tPgo+IENDOiBDaHJpcyBMZWVjaCA8Y2xlZWNoQHJlZGhhdC5jb20+Cj4gQ0M6IE1pa2UgQ2hy
aXN0aWUgPG1pY2hhZWwuY2hyaXN0aWVAb3JhY2xlLmNvbT4KPiBDQzogIkphbWVzIEUuSi4gQm90
dG9tbGV5IiA8amVqYkBsaW51eC5pYm0uY29tPgo+IENDOiAiTWFydGluIEsuIFBldGVyc2VuIiA8
bWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20+Cj4gQ0M6IFZhbGVudGluYSBNYW5lYSA8dmFsZW50
aW5hLm1hbmVhLm1AZ21haWwuY29tPgo+IENDOiBTaHVhaCBLaGFuIDxzaHVhaEBrZXJuZWwub3Jn
Pgo+IENDOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPgo+
IENDOiBEYXZpZCBIb3dlbGxzIDxkaG93ZWxsc0ByZWRoYXQuY29tPgo+IENDOiBNYXJjIERpb25u
ZSA8bWFyYy5kaW9ubmVAYXVyaXN0b3IuY29tPgo+IENDOiBTdGV2ZSBGcmVuY2ggPHNmcmVuY2hA
c2FtYmEub3JnPgo+IENDOiBDaHJpc3RpbmUgQ2F1bGZpZWxkIDxjY2F1bGZpZUByZWRoYXQuY29t
Pgo+IENDOiBEYXZpZCBUZWlnbGFuZCA8dGVpZ2xhbmRAcmVkaGF0LmNvbT4KPiBDQzogTWFyayBG
YXNoZWggPG1hcmtAZmFzaGVoLmNvbT4KPiBDQzogSm9lbCBCZWNrZXIgPGpsYmVjQGV2aWxwbGFu
Lm9yZz4KPiBDQzogSm9zZXBoIFFpIDxqb3NlcGgucWlAbGludXguYWxpYmFiYS5jb20+Cj4gQ0M6
IEVyaWMgVmFuIEhlbnNiZXJnZW4gPGVyaWN2aEBnbWFpbC5jb20+Cj4gQ0M6IExhdGNoZXNhciBJ
b25rb3YgPGx1Y2hvQGlvbmtvdi5uZXQ+Cj4gQ0M6IERvbWluaXF1ZSBNYXJ0aW5ldCA8YXNtYWRl
dXNAY29kZXdyZWNrLm9yZz4KPiBDQzogIkRhdmlkIFMuIE1pbGxlciIgPGRhdmVtQGRhdmVtbG9m
dC5uZXQ+Cj4gQ0M6IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4KPiBDQzogSmFr
dWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4KPiBDQzogUGFvbG8gQWJlbmkgPHBhYmVuaUBy
ZWRoYXQuY29tPgo+IENDOiBJbHlhIERyeW9tb3YgPGlkcnlvbW92QGdtYWlsLmNvbT4KPiBDQzog
WGl1Ym8gTGkgPHhpdWJsaUByZWRoYXQuY29tPgo+IENDOiBDaHVjayBMZXZlciA8Y2h1Y2subGV2
ZXJAb3JhY2xlLmNvbT4KPiBDQzogSmVmZiBMYXl0b24gPGpsYXl0b25Aa2VybmVsLm9yZz4KPiBD
QzogVHJvbmQgTXlrbGVidXN0IDx0cm9uZC5teWtsZWJ1c3RAaGFtbWVyc3BhY2UuY29tPgo+IEND
OiBBbm5hIFNjaHVtYWtlciA8YW5uYUBrZXJuZWwub3JnPgo+IENDOiBkcmJkLWRldkBsaXN0cy5s
aW5iaXQuY29tCj4gQ0M6IGxpbnV4LWJsb2NrQHZnZXIua2VybmVsLm9yZwo+IENDOiBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnCj4gQ0M6IG5iZEBvdGhlci5kZWJpYW4ub3JnCj4gQ0M6IGxp
bnV4LW52bWVAbGlzdHMuaW5mcmFkZWFkLm9yZwo+IENDOiBvcGVuLWlzY3NpQGdvb2dsZWdyb3Vw
cy5jb20KPiBDQzogbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmcKPiBDQzogbGludXgtdXNiQHZn
ZXIua2VybmVsLm9yZwo+IENDOiBsaW51eC1hZnNAbGlzdHMuaW5mcmFkZWFkLm9yZwo+IENDOiBs
aW51eC1jaWZzQHZnZXIua2VybmVsLm9yZwo+IENDOiBzYW1iYS10ZWNobmljYWxAbGlzdHMuc2Ft
YmEub3JnCj4gQ0M6IGNsdXN0ZXItZGV2ZWxAcmVkaGF0LmNvbQo+IENDOiBvY2ZzMi1kZXZlbEBv
c3Mub3JhY2xlLmNvbQo+IENDOiB2OWZzLWRldmVsb3BlckBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQK
PiBDQzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZwo+IENDOiBjZXBoLWRldmVsQHZnZXIua2VybmVs
Lm9yZwo+IENDOiBsaW51eC1uZnNAdmdlci5rZXJuZWwub3JnCj4gCj4gU3VnZ2VzdGVkLWJ5OiBH
dWlsbGF1bWUgTmF1bHQgPGduYXVsdEByZWRoYXQuY29tPgo+IFNpZ25lZC1vZmYtYnk6IEJlbmph
bWluIENvZGRpbmd0b24gPGJjb2RkaW5nQHJlZGhhdC5jb20+CgpJIHRoaW5rIHRoaXMgaXMgdGhl
IG1vc3QgZmVhc2libGUgd2F5IG91dCBvZiB0aGUgZXhpc3RpbmcgaXNzdWUsIGFuZCBJCnRoaW5r
IHRoaXMgcGF0Y2hzZXQgc2hvdWxkIGdvIHZpYSB0aGUgbmV0d29ya2luZyB0cmVlLCB0YXJnZXRp
bmcgdGhlCkxpbnV4IDYuMi4KCklmIHNvbWVvbmUgaGFzIGRpc2FncmVlbWVudCB3aXRoIHRoZSBh
Ym92ZSwgcGxlYXNlIHNwZWFrISAKClRoYW5rcywKClBhb2xvCgoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9j
ZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9s
aXN0aW5mby9vY2ZzMi1kZXZlbA==
