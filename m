Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 578F3EB64DC
	for <ocfs2-devel@archiver.kernel.org>; Tue, 20 Jun 2023 14:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=YW4G8Voxog814596DrY/ZmOkitkVxmO3MUQr23Kk+wI=;
 b=NzIkrtG6LcNIUKkcXW+SnaQB0AI+v2s0Ts4WWrJhF5iNu5Hl0D1UPQaTKXdCFLl12YEQW1FsZiLN
   BRG2oGhS+5PHUWc+IV4uctYcSnxphZciU9hMeSv6zqBTEchZZGJ+EQLJWYmxRN1GK29AmGxE+T63
   OsAXCzF+vBHVHJDJbc9ZGZ07PcUFKpbxb14CueFNcFAF/Em3ttDSag9Fjx+L5FiG33bS0v7ZmT+V
   dkIHPWuRIsATH0WLVr27sWMHXqU5142ds1+qrLqX6+rqMmIe8EnibQRmcNgH5+kqIinPgM/p1goz
   A1d2XvedkAjCLz9+UkkupOtOOrCmI+iNc85uuQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=YW4G8Voxog814596DrY/ZmOkitkVxmO3MUQr23Kk+wI=;
 b=NGxXaDeEyCj3K3HZ2lMiXfPYwzrApo1joDYxMRTPg/9ospZLuOFi4vf1cOkxmZNTSeINwM6shgC4
   NLeS8gwQqe7QKKnReQZG9CzZ6gRm+MhWzbQ7MwxIPkHb108rcFzOu/seSLuWwUnauIk3LIqgxcWz
   99kTpSc7fAdlXOKXRUGSXqUbWnerpLLdDwX77SL7ziSNl4l/8YpQPzg5Z3EX2+tkDDfIGFAfrxEd
   wZ/kFdkrr6z5VL1F2ZXQwdkHpBtB1qXz+xHYfDi2lvDv7lJ/pLotOGdYvro9E7AOKOtKOHnsbSxg
   x1CynQfawWCHL2pQA7NBgnO+ocufQSONsGQ1Ww==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWK00G8K45YZ2D0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 20 Jun 2023 14:56:22 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20221208;
 t=1687258633; x=1689850633;
 h=mime-version:user-agent:content-transfer-encoding:references
 :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
 :date:message-id:reply-to; bh=3O+Bnjxxx0szcdEOMgNn8iZcHNEXXIsPlro4HGaBB6o=;
 b=aIWa1nXGNFgmtzFIBA1RqWdd8m52b+jvDm3A4V/u+05m/hAmX/0tZU9iyWAHFDN5Hb
 BspNl1+bwRjG2f60MjkRD81qMsjE1kSoD0f7dN8XBOrNrG69sa5B4WxtCkv/eQX9wAwE
 KRfuAoub+Wf3wXYRhtHk/C238QnAmSnzinmq/g8NlaagE3zegKs5TbJVUYTfZ1O5MVz/
 qBFtkHw30Uc5D+rWEPL+kLodz3ZS845mn6y2K8rkJQ/9xwv7ySEVZ4lmkEyIqR5JYLaS
 jo/ginTbyVqH/CCSG0kYljwrLR4SpSGmUtJtI//LGkaPnrg2P65yv3cIdd3h4Z0kYQFf EqiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20221208; t=1687258633; x=1689850633;
 h=mime-version:user-agent:content-transfer-encoding:references
 :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=3O+Bnjxxx0szcdEOMgNn8iZcHNEXXIsPlro4HGaBB6o=;
 b=M9+WvmFXfTJv9wmVrE+Hbc7YyZgDKNG3WAVZa66bTp4V/qw45PNRFTwAkfhqyIv4oe
 kZUbbzCXnx49WGCLdTWJ1WX0pDuCmZ8f/50ul6uOQqhZAO+kuyd5cqGbLq38IXODsU1t
 o26AOb5xOPXehjij0KvgQDMbLL4N0K09ziRwGv3mQU54/A7kP4jUmyMyn35XdFcoeA/L
 PAta2mPRdvJab2qHSLfzs1Z7QuKZlfapbRzYsvtXme3y29vjZvfkuip8fgGyyhwZ17hg
 6WYLpz5CMkyGiyrE1sTJoNVdltq5DlUDooSxqqGwoA0IAfmGGADq+wqSTZz2BX/xGgVR cbWw==
X-Gm-Message-State: AC+VfDzgt/cSJ/SgVlIpAgHOmh7mzUrNEHsI2Y/gN+pUs4l80cuRIESV
 RcX/fY+Gqjn8E4bfJB/C/Ow=
X-Received: by 2002:a17:907:1c9c:b0:965:6aff:4f02 with SMTP id
 nb28-20020a1709071c9c00b009656aff4f02mr12375780ejc.41.1687258633089; Tue,
 20 Jun 2023 03:57:13 -0700 (PDT)
Message-id: <9513017b07522373d9e886478f889867b7cae54d.camel@gmail.com>
To: Matthew Wilcox <willy@infradead.org>, Bean Huo <beanhuo@iokpp.de>
Date: Tue, 20 Jun 2023 12:57:11 +0200
In-reply-to: <ZJE6Nf6XmeHIlFJI@casper.infradead.org>
References: <20230619211827.707054-1-beanhuo@iokpp.de>
 <20230619211827.707054-2-beanhuo@iokpp.de>
 <ZJE6Nf6XmeHIlFJI@casper.infradead.org>
User-Agent: Evolution 3.44.4-0ubuntu1
MIME-version: 1.0
X-Source-IP: 209.85.218.51
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10746
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=724
 spamscore=0 suspectscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 priorityscore=323 clxscore=160
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306200098 domainage_hfrom=10173
Cc: brauner@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 beanhuo@micron.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
 jack@suse.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
 linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 1/5] fs/buffer: clean up	block_commit_write
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
 ACHHUZ7/IxL+j4tMhMmtnE6mA76gQ7qCMC3vtfvWh/rIklR4GzXcN84K4iRqi4lH0JifLvzTy8Mh7g==
X-ServerName: mail-ej1-f51.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-GUID: XZP35UQ4YKsZ8Wgn1_5ohXa7f0Z3sdUX
X-Proofpoint-ORIG-GUID: XZP35UQ4YKsZ8Wgn1_5ohXa7f0Z3sdUX
X-Mailman-Approved-At: Tue, 20 Jun 2023 14:56:20 +0000
Reporting-Meta:
 AAHNECSWBi79Wv0RNZv7GQQmv0noYfTp38F0F9yBFCFU8Fd6qZbTSJRwoqSt+X/8
 EJ1GMbD8xVjoRj3JHSFwNyGWGvE5DytYF1MjnzFN5NGCVavjpoQbZVa6TvdggMC+
 2rMmruj/lZYzrnPC8uqOSgCEhxU7xpiTuO9z3NdDymFy2996GhJ8LOu/Xw+JwbIt
 Yu/0odhu+5zXoeIB/KGlsd7DLJvEf18DienM+LuukUgETFHJ0TtE5ztLpzNPndKX
 eohSM5Al4Lu0RPx1sdMnvkGcK9hLSYGkZ5uZy8Lno1/VxUFOtA6B6edTHeYsNQpg
 8NEjTLO7rkW1cGPt14vyaHpViU99sxNaCcXtMWMnH97sbiNw+yRogQttjEgWeVA9
 gq1q4X4XllmKYDTm5fozo5hpf2eRrezTFe0dvgv6do+DMLuHyGzBkoqIZE+YV7YN
 lrreC8GLa9teEDhxKnDXPhngpL79YI7xHeQ8WLjOHSmZ2OBbWP/EGuvTkeEf0ACR
 xOq42oPHUXbLSRCr8c2qI1L3+vmfWU87uzV452eE35I=

T24gVHVlLCAyMDIzLTA2LTIwIGF0IDA2OjMzICswMTAwLCBNYXR0aGV3IFdpbGNveCB3cm90ZToK
PiBZb3UncmUgZ29pbmcgdG8gbmVlZCB0byByZWRvIHRoZXNlIHBhdGNoZXMsIEknbSBhZnJhaWQu
wqAgQSBzZXJpZXMgb2YKPiBwYXRjaGVzIEkgd3JvdGUganVzdCB3ZW50IGluIHRoYXQgY29udmVy
dCBfX2Jsb2NrX2NvbW1pdF93cml0ZSAoYnV0Cj4gbm90IGJsb2NrX2NvbW1pdF93cml0ZSkgdG8g
dGFrZSBhIGZvbGlvIGluc3RlYWQgb2YgYSBwYWdlLgoKRG8geW91IGtub3cgd2hpY2ggZ2l0IHJl
cG8gbWVyZ2VkIHdpdGggeW91ciBwYXRjaGVzPyAKCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZl
bEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8v
b2NmczItZGV2ZWw=
