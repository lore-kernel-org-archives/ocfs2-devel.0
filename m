Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67635C001DB
	for <ocfs2-devel@archiver.kernel.org>; Tue, 20 Jun 2023 14:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qhizIzIkOkBnrHo2tdFoU3lnCdd2YMz/cmk8Bmo4E90=;
 b=DUeoc36u9NdXDpWx5SW6uZIxpJS7npEfa8hp6km5WYaIipv9XdiJnPQ74mqKon/e9B5Aq9lsZhBy
   Hd+WdVqcfiXBCgdCzgp05CBICXXXxCky/c5UVyp+EiyRyDlOj65rqNfFzMYsKkDtL4R0irIkZqA+
   w+gACfBCQIOVn0N3LzuxfJkOCcDX0WZrHKMhUKxyxybNYxVpcyGZWL7brTTG5aWbvMJB/45RCO3B
   ucPJ64ZDli6tekbWedNBb7Vr4MaGsPqaJSDVhOsA/MbGESjBQzu1egDZugqB4Nv20srfsYlQKbyc
   b6vbOaFExrWpLfifDw1Qc5RQYpQv35ji3SXcOw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=qhizIzIkOkBnrHo2tdFoU3lnCdd2YMz/cmk8Bmo4E90=;
 b=WUDilo/9WMfUZWeent50PaMs1Rj09tWKzBk/knWk6xot3+k0/URpPJuPZKmr3XVyyRmcAotuX07u
   HXoLysYacdu1Zl4m/w6JEL5gohGGPU3V6phFb8PBrvrI0bb89IleNwjSnR5ivXYNPSy0yrbCeuFa
   /jdzmi61VWcgP/W0r7PVuQ5MG+lUiCbowwAwqUOCp1Chs4+WhRYit7nAsPac5S9sXPPmKSXoMY4X
   F1zpyNDWpZf/SrN65NLxWv0UFt25tYygEqa7K6FlkG5z2qEjK1slvZqsJV94CGuADMOpwT1tjvEw
   ar7TCY6Ktcf8jMA5umnCJdmQkvCD78y0E3pA7g==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWK004AB45YPU10@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 20 Jun 2023 14:56:22 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20221208;
 t=1687258784; x=1689850784;
 h=mime-version:user-agent:content-transfer-encoding:references
 :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
 :date:message-id:reply-to; bh=UsfpIs8ZbY4FsxMJVdC8ReyTwzdMIzbHG6xjYSNsBro=;
 b=cqx5XtAdAHDm10rjNY3fqjctrT7/AqesiOAO/ipraUwqmaTXxnPHxC+JRlYXU/Aoi2
 67417T9YwBQ7KtG6rvQ8KthI9LPo7T4poZsF5O+hNeU4E6NYhQ1QnGwxvFWF9vjJRWwG
 OBVTH7hgDU/IWyNQ00AnfxFnquSK6YZiNeLKCJ3PuDDKzl5BL40q3UM+Fj3risL5fAJs
 jFKbnizVa4Z7DQgVqNlTGrweW9efdJfmFjUU6plPGU4Mhf8Pr4g44J//OkTbetyD2DPf
 LkyrBduU6eoWEW0CtDCts3etVx/UlLNd4KneOrVcn25eYw2j4d1hzTLtC5swf+wOGb5g UOxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20221208; t=1687258784; x=1689850784;
 h=mime-version:user-agent:content-transfer-encoding:references
 :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=UsfpIs8ZbY4FsxMJVdC8ReyTwzdMIzbHG6xjYSNsBro=;
 b=BamugueSqFAGT01u8U/CWWB7w5u4ohKbItCDMC/hbVOwZ7PepaGlV5e/RtUpssqLgD
 vYM03i/gcXDiIn16PvxJyknqRIBqrdf6xcNbC2ijT/tfsT2AuGSNNFQgcECd//cJGQ2n
 ytIk8uAGE9CKkIsIfMYmaauySycrzi2otdy1PpKjyQHRJNN5AsxwC6MB8fwIB13TjyWW
 IILt15thiMCl11Qbull7KLI70h6Wmrf9eRma+GJy0KXjKQ3z8LvWLa+AeaZ67RMpf1Ap
 EDI2hH/AreK6zBxmPiTuNN4u3lT55xZ2N3WsTId2RZNgEvCCC97uMkxVJFR3sruULbIj ms8Q==
X-Gm-Message-State: AC+VfDwZIGEARQHqmhmheVpyV6h5fEln2DnQ7bD46fKM59QGSIRoQRiW
 8cBd4NQOQrg6SFHrAhX7Jsg=
X-Received: by 2002:a17:907:36c5:b0:978:acec:36b1 with SMTP id
 bj5-20020a17090736c500b00978acec36b1mr10764445ejc.17.1687258784226; Tue,
 20 Jun 2023 03:59:44 -0700 (PDT)
Message-id: <e30082535f1d7e92692718f1d25a08508f04fe0a.camel@gmail.com>
To: Christoph Hellwig <hch@infradead.org>, Bean Huo <beanhuo@iokpp.de>
Date: Tue, 20 Jun 2023 12:59:42 +0200
In-reply-to: <ZJEvi8CJddmpeluC@infradead.org>
References: <20230619211827.707054-1-beanhuo@iokpp.de>
 <20230619211827.707054-3-beanhuo@iokpp.de> <ZJEvi8CJddmpeluC@infradead.org>
User-Agent: Evolution 3.44.4-0ubuntu1
MIME-version: 1.0
X-Source-IP: 209.85.218.53
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10746
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=324 phishscore=0 adultscore=0 mlxlogscore=548 lowpriorityscore=0
 suspectscore=0 bulkscore=0 clxscore=143 impostorscore=0 spamscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306200098 domainage_hfrom=10173
Cc: brauner@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 beanhuo@micron.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
 jack@suse.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 2/5] ext4: No need to check return value
 of block_commit_write()
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
Reply-to: Bean Huo <huobean@gmail.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 ACHHUZ6nF0pp2ZRQkRSb1xXUWjmnMShWCcQHsA6Pbc+opfbPi2zM8yuaVjNg5nq9XYpkTu2Xx6QaAw==
X-ServerName: mail-ej1-f53.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-GUID: BuZcQp420As1C-HwjwjXzt6QyKQnmCUk
X-Proofpoint-ORIG-GUID: BuZcQp420As1C-HwjwjXzt6QyKQnmCUk
X-Mailman-Approved-At: Tue, 20 Jun 2023 14:56:20 +0000
Reporting-Meta:
 AAEmdgMBAEAP8qGQGTm2UMxULcQPjD4bGQ9MBk0jQmq+tVfixqm/+9Awh/VIUHev
 pCQ5SQwHEwJNzRxq4N37PnlKzg7x4ouo/4L7gtp1O7l7Q2aw+3MDWdyaW0ZSS5mc
 tKhzeS1YeRV89iVyHURVqflONmAiEibf8XXyV/oarb28QOu4lXIG3s5ED01ThGEP
 oy7cMp00gwhEB0OinmxHnVSgHS4nM0UBEhAU0+CcOVB0S5lg8GQEe2Szgd29jbpv
 VLsjYiMS6n2lpD44D9wdtOhCybvW2CkkbIjhu3F6Rt64jxuhkMpf2OTDTRi4/Ylb
 GLifVpnKVHq08F99h6tyn6mSwdAgCFQ+3sqfSAPr4/BeE/uQyE0m5+lfTeOxwiJo
 4zYBMZgNcZfqQ2p2lFpwXq7WAHfVcrfW/jv9es1K4Vm8rnfDOP+L2+pHwjQVH5ag
 XYbDEYkkUQNyNqyMXH2pqBDZXKjvCQsIRBWP7aDXwh5SWYlYaDQqzmyUVOD8euDl
 6eILTbU6wL/aJfNOM66cJhlfmCf0I8jEf+3/DBYVQB8=

T24gTW9uLCAyMDIzLTA2LTE5IGF0IDIxOjQ4IC0wNzAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToKPiBPbiBNb24sIEp1biAxOSwgMjAyMyBhdCAxMToxODoyNFBNICswMjAwLCBCZWFuIEh1byB3
cm90ZToKPiA+IEZyb206IEJlYW4gSHVvIDxiZWFuaHVvQG1pY3Jvbi5jb20+Cj4gPiAKPiA+IFJl
bW92ZSB1bm5lY2Vzc2FyeSBjaGVjayBvbiB0aGUgcmV0dXJuIHZhbHVlIG9mCj4gPiBibG9ja19j
b21taXRfd3JpdGUoKSwKPiA+IGJlY2F1c2UgaXQgYWx3YXlzIHJldHVybnMgMC4KPiAKPiBEcm9w
cGluZyB0aGUgZXJyb3IgY2hlY2sgYmVmb3JlIHRoZSBmdW5jdGlvbiBzaWduYXR1cmUgaXMgY2hh
bmdlcyBpcwo+IHJlYWxseSBvZGQuwqAgSSdkIHN1Z2dlc3QgdG8gbWVyZ2UgdGhpcyBhbmQgdGhl
IGZvbGxvd2luZyBwYXRjaGVzIGludG8KPiBhIHNpbmdsZSBvbmUuCgpObyBwcm9ibGVtLCBJIHdp
bGwgbWVyZ2UgdGhlbSB0b2dldGhlciwgdGhhbmtzLgoKS2luZCByZWdhcmRzLApCZWFuCgoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwg
bWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNs
ZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
