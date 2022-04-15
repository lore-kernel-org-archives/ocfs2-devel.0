Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F55AC43219
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Apr 2022 04:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9aFNLPpHQPJMK4gUBYGABn0jc4VVctpHVtKjtyXjbfQ=;
 b=vai+WrpEUuHoc9VQlSNoDrcdYFRKR11wMHF4JhF+carewrH07RmchmBQdJ2KpOwDkmoQwEH0mF5g
   LQ1LF82t6zRCFCGwDxorMdrptBJv1loLrY4frnZT07cYUDTHUw+3sS4vMyiaXarwiRkOPvxeoQO4
   5sdYYhJ3LVbOqkafJDg20QXHOC669lkBYq16zX67rlbmmM1PUBjvWYfofe4c09EMGN/qXIPEKw5T
   +Uf+QEO+z4l55mPs3b3pMnSwEqT2F4TdpTwS1XG3NPkiJ82HaPvlWZ6jf9QR273GZ/TE/GGALL1g
   zott9YpH4xiSJxu4S2NP2cBAcUjKYSt9DDOsDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9aFNLPpHQPJMK4gUBYGABn0jc4VVctpHVtKjtyXjbfQ=;
 b=VVlf8MBjwyalPYSOpoiClNUeXSNLVCJ1QOucz5SvfyJi/qaJmxX0LpZkEVfC/c+StjIalkpAjx4q
   AGj5sFGIVNRorr/T6EKJbnvhHu3JGPwamoeVItc3piXXLniE8y8YzgbF+QXHJpO7K3Z8+4H4YJLG
   bjrMEU9izQZd8Qv7en5wnsbosE+rw6EPrOX6l3VqDVkv2d7QoaO1ZzJjDMORADwEoDUNh2molT72
   dvAHuKeoqV0nUKaJ9naKAyFZbcem+UXgJ+bhi7lqrwf2HFRzl+N0X2D+MpCS1SMYa7rBHKJRIqDZ
   VgtiE+BJH4aR7etfEQ/yM2ImYEk5Fh89oaah0w==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAD003EK6YR2JF0@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 15 Apr 2022 04:54:27 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Sender:Reply-To:Content-ID:Content-Description;
 bh=be5XRqr6FpD/xPCRROQj1WW79ZNoTG4VrTyORPZGjVE=; b=zfdoWKjLNg8/93VMXMR/8dmem+
 WdvS+5iIu6uir1zneoGsW/PVn5k5msDFRP3cNUjzgk48HwXHEWdbPPQegdyt6x56ivnd6KhVFEdRn
 raW2CONj2YH3bKud1GU1IPcR9v/j6pw0pUmG9drywqIdz4cTw9frqxiK8uJ0qudjT7ff4EmR2zNpd
 iXKlU7IflKK7BZ1vMlEvBpbCIpEVLMDJnliSIXYAubrng3TWL7OH99pGfDALzISzxUUJefgBXG3V5
 WlBB+jh7r7m3TcfVeysrxVV3wHeAvYOUUoaQFeOXr6OBj0iU6tL7PMj+sYlQjUaSSJXCl4UqBVXnS
 NdWcSxoQ==;
To: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Apr 2022 06:52:35 +0200
Message-id: <20220415045258.199825-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220415045258.199825-1-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10317
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=833 bulkscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 clxscore=248 adultscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204150029
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 linux-um@lists.infradead.org, nbd@other.debian.org,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, =?UTF-8?q?Christoph=20B=C3=B6hmwalder?=
 <christoph.boehmwalder@linbit.com>, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 04/27] drbd: remove assign_p_sizes_qlim
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
From: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christoph Hellwig <hch@lst.de>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-ServerName: bombadil.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: i2ks-dtXBEYIMoCesOOg3_DnuoEiwR7i
X-Proofpoint-GUID: i2ks-dtXBEYIMoCesOOg3_DnuoEiwR7i
Reporting-Meta:
 AAGpG2Pbt6cSMX70OK/oCNRuGX548w49FuR1fDTZ8/km8ktUIqMB0LbJZhmhew7m
 F7qIUq6Gie3uYMx88wKMoiXVv2zoXqQErGd30thJP70ZxI2FqcTJHw841Jwkph3K
 9YBaPZrtlMfkMhoWLe96paK0yDU00m+w1O7h8/Dy8WHS57tHdDDSd4KTLYngTrUB
 XwX9jINh3B6NVt+cpGkjKupZXPnWrBmrhkzuPoogC0ponDP4rH7v89YZN7O6f2jy
 w6fLBIfQG0OdQ2F9PEhIPhXMyWjKnlOFinWEplKlXt1kgqLw/XrkVUccjYNKcmgr
 Zn9O8ic5g0nhKm7ElmxY+diWncySVAuac5247FKZjSALBU11KOpRjnTaw5q1Fe6/
 b5vj+j4475/ulP4UxZlpORmVd2K7hJ47GYlDqX2im4gMf3t/pabiJypoJJMtdqwX
 qd/oLv285aR7t5NFhhOLk6rO1v+LqgRjvJYEG3iCACS380mwzRpp2tJwaaV4ZYck
 PabI2t8IDoQQsCHvJwo7ST27MbnWpQQV7Mkpmllry4lm

Rm9sZCBlYWNoIGJyYW5jaCBpbnRvIGl0cyBvbmx5IGNhbGxlci4KClNpZ25lZC1vZmYtYnk6IENo
cmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgpBY2tlZC1ieTogQ2hyaXN0b3BoIELDtmhtd2Fs
ZGVyIDxjaHJpc3RvcGguYm9laG13YWxkZXJAbGluYml0LmNvbT4KLS0tCiBkcml2ZXJzL2Jsb2Nr
L2RyYmQvZHJiZF9tYWluLmMgfCA0NyArKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0t
CiAxIGZpbGUgY2hhbmdlZCwgMjAgaW5zZXJ0aW9ucygrKSwgMjcgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9ibG9jay9kcmJkL2RyYmRfbWFpbi5jIGIvZHJpdmVycy9ibG9jay9k
cmJkL2RyYmRfbWFpbi5jCmluZGV4IDRiMGIyNWNjOTE2ZWUuLjM2NzcxNTIwNWM4NjAgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvYmxvY2svZHJiZC9kcmJkX21haW4uYworKysgYi9kcml2ZXJzL2Jsb2Nr
L2RyYmQvZHJiZF9tYWluLmMKQEAgLTkwMywzMSArOTAzLDYgQEAgdm9pZCBkcmJkX2dlbl9hbmRf
c2VuZF9zeW5jX3V1aWQoc3RydWN0IGRyYmRfcGVlcl9kZXZpY2UgKnBlZXJfZGV2aWNlKQogCX0K
IH0KIAotLyogY29tbXVuaWNhdGVkIGlmIChhZ3JlZWRfZmVhdHVyZXMgJiBEUkJEX0ZGX1dTQU1F
KSAqLwotc3RhdGljIHZvaWQKLWFzc2lnbl9wX3NpemVzX3FsaW0oc3RydWN0IGRyYmRfZGV2aWNl
ICpkZXZpY2UsIHN0cnVjdCBwX3NpemVzICpwLAotCQkJCQlzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAq
cSkKLXsKLQlpZiAocSkgewotCQlwLT5xbGltLT5waHlzaWNhbF9ibG9ja19zaXplID0gY3B1X3Rv
X2JlMzIocXVldWVfcGh5c2ljYWxfYmxvY2tfc2l6ZShxKSk7Ci0JCXAtPnFsaW0tPmxvZ2ljYWxf
YmxvY2tfc2l6ZSA9IGNwdV90b19iZTMyKHF1ZXVlX2xvZ2ljYWxfYmxvY2tfc2l6ZShxKSk7Ci0J
CXAtPnFsaW0tPmFsaWdubWVudF9vZmZzZXQgPSBjcHVfdG9fYmUzMihxdWV1ZV9hbGlnbm1lbnRf
b2Zmc2V0KHEpKTsKLQkJcC0+cWxpbS0+aW9fbWluID0gY3B1X3RvX2JlMzIocXVldWVfaW9fbWlu
KHEpKTsKLQkJcC0+cWxpbS0+aW9fb3B0ID0gY3B1X3RvX2JlMzIocXVldWVfaW9fb3B0KHEpKTsK
LQkJcC0+cWxpbS0+ZGlzY2FyZF9lbmFibGVkID0gYmxrX3F1ZXVlX2Rpc2NhcmQocSk7Ci0JCXAt
PnFsaW0tPndyaXRlX3NhbWVfY2FwYWJsZSA9IDA7Ci0JfSBlbHNlIHsKLQkJcSA9IGRldmljZS0+
cnFfcXVldWU7Ci0JCXAtPnFsaW0tPnBoeXNpY2FsX2Jsb2NrX3NpemUgPSBjcHVfdG9fYmUzMihx
dWV1ZV9waHlzaWNhbF9ibG9ja19zaXplKHEpKTsKLQkJcC0+cWxpbS0+bG9naWNhbF9ibG9ja19z
aXplID0gY3B1X3RvX2JlMzIocXVldWVfbG9naWNhbF9ibG9ja19zaXplKHEpKTsKLQkJcC0+cWxp
bS0+YWxpZ25tZW50X29mZnNldCA9IDA7Ci0JCXAtPnFsaW0tPmlvX21pbiA9IGNwdV90b19iZTMy
KHF1ZXVlX2lvX21pbihxKSk7Ci0JCXAtPnFsaW0tPmlvX29wdCA9IGNwdV90b19iZTMyKHF1ZXVl
X2lvX29wdChxKSk7Ci0JCXAtPnFsaW0tPmRpc2NhcmRfZW5hYmxlZCA9IDA7Ci0JCXAtPnFsaW0t
PndyaXRlX3NhbWVfY2FwYWJsZSA9IDA7Ci0JfQotfQotCiBpbnQgZHJiZF9zZW5kX3NpemVzKHN0
cnVjdCBkcmJkX3BlZXJfZGV2aWNlICpwZWVyX2RldmljZSwgaW50IHRyaWdnZXJfcmVwbHksIGVu
dW0gZGRzX2ZsYWdzIGZsYWdzKQogewogCXN0cnVjdCBkcmJkX2RldmljZSAqZGV2aWNlID0gcGVl
cl9kZXZpY2UtPmRldmljZTsKQEAgLTk1NywxNCArOTMyLDMyIEBAIGludCBkcmJkX3NlbmRfc2l6
ZXMoc3RydWN0IGRyYmRfcGVlcl9kZXZpY2UgKnBlZXJfZGV2aWNlLCBpbnQgdHJpZ2dlcl9yZXBs
eSwgZW51CiAJCXFfb3JkZXJfdHlwZSA9IGRyYmRfcXVldWVfb3JkZXJfdHlwZShkZXZpY2UpOwog
CQltYXhfYmlvX3NpemUgPSBxdWV1ZV9tYXhfaHdfc2VjdG9ycyhxKSA8PCA5OwogCQltYXhfYmlv
X3NpemUgPSBtaW4obWF4X2Jpb19zaXplLCBEUkJEX01BWF9CSU9fU0laRSk7Ci0JCWFzc2lnbl9w
X3NpemVzX3FsaW0oZGV2aWNlLCBwLCBxKTsKKwkJcC0+cWxpbS0+cGh5c2ljYWxfYmxvY2tfc2l6
ZSA9CisJCQljcHVfdG9fYmUzMihxdWV1ZV9waHlzaWNhbF9ibG9ja19zaXplKHEpKTsKKwkJcC0+
cWxpbS0+bG9naWNhbF9ibG9ja19zaXplID0KKwkJCWNwdV90b19iZTMyKHF1ZXVlX2xvZ2ljYWxf
YmxvY2tfc2l6ZShxKSk7CisJCXAtPnFsaW0tPmFsaWdubWVudF9vZmZzZXQgPQorCQkJY3B1X3Rv
X2JlMzIocXVldWVfYWxpZ25tZW50X29mZnNldChxKSk7CisJCXAtPnFsaW0tPmlvX21pbiA9IGNw
dV90b19iZTMyKHF1ZXVlX2lvX21pbihxKSk7CisJCXAtPnFsaW0tPmlvX29wdCA9IGNwdV90b19i
ZTMyKHF1ZXVlX2lvX29wdChxKSk7CisJCXAtPnFsaW0tPmRpc2NhcmRfZW5hYmxlZCA9IGJsa19x
dWV1ZV9kaXNjYXJkKHEpOwogCQlwdXRfbGRldihkZXZpY2UpOwogCX0gZWxzZSB7CisJCXN0cnVj
dCByZXF1ZXN0X3F1ZXVlICpxID0gZGV2aWNlLT5ycV9xdWV1ZTsKKworCQlwLT5xbGltLT5waHlz
aWNhbF9ibG9ja19zaXplID0KKwkJCWNwdV90b19iZTMyKHF1ZXVlX3BoeXNpY2FsX2Jsb2NrX3Np
emUocSkpOworCQlwLT5xbGltLT5sb2dpY2FsX2Jsb2NrX3NpemUgPQorCQkJY3B1X3RvX2JlMzIo
cXVldWVfbG9naWNhbF9ibG9ja19zaXplKHEpKTsKKwkJcC0+cWxpbS0+YWxpZ25tZW50X29mZnNl
dCA9IDA7CisJCXAtPnFsaW0tPmlvX21pbiA9IGNwdV90b19iZTMyKHF1ZXVlX2lvX21pbihxKSk7
CisJCXAtPnFsaW0tPmlvX29wdCA9IGNwdV90b19iZTMyKHF1ZXVlX2lvX29wdChxKSk7CisJCXAt
PnFsaW0tPmRpc2NhcmRfZW5hYmxlZCA9IDA7CisKIAkJZF9zaXplID0gMDsKIAkJdV9zaXplID0g
MDsKIAkJcV9vcmRlcl90eXBlID0gUVVFVUVfT1JERVJFRF9OT05FOwogCQltYXhfYmlvX3NpemUg
PSBEUkJEX01BWF9CSU9fU0laRTsgLyogLi4uIG11bHRpcGxlIEJJT3MgcGVyIHBlZXJfcmVxdWVz
dCAqLwotCQlhc3NpZ25fcF9zaXplc19xbGltKGRldmljZSwgcCwgTlVMTCk7CiAJfQogCiAJaWYg
KHBlZXJfZGV2aWNlLT5jb25uZWN0aW9uLT5hZ3JlZWRfcHJvX3ZlcnNpb24gPD0gOTQpCi0tIAoy
LjMwLjIKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpP
Y2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6
Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
