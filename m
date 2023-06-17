Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 779EDEB64D9
	for <ocfs2-devel@archiver.kernel.org>; Sat, 17 Jun 2023 08:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=jf2T8gY2PAZPJD7FXt3OOnCgf7ZUA3N6IWhmnfe0Qa8=;
 b=KVqAsIqL1/6BKYxEaEZj/v0PjCkz8yUy5kQ2ifR8N/h+tK+uEZy9Qs2WVINWVuJdQrVITcYq9Vcw
   37cVvhsL0zYmUIQxTdXb8NP/DBfKuoUn3advst0VS2VfpAG1OW91CGk0N+mh0+VfZ+K6HiF2JdjZ
   bC7TwhZWbRGcvLa/+S4DLPSEy2c1A1DO9bSyNrsWGJpkDqGPJBGZ8u6I/nk9wK7ZHf/NS+hbCubG
   iAJokQ7A1T62RbjKb9fenrZ7XJ1s5hXMkh2B+LM0Ek+waMYS4E7kCHbsxKDQ8PxtNR5neT3f9e+m
   +uIxSUcJzcRJQV8zsUtVC4RKF5C2j6OSCsgraA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=jf2T8gY2PAZPJD7FXt3OOnCgf7ZUA3N6IWhmnfe0Qa8=;
 b=mVox9ZJNc69DxCuSrv7QY2xuGhg6q3HMVCibLb3du1wir73eRmLYFy98RNQ8K5PnUInUjyV2Uqyi
   ib+kOWbactpw6jnG/VwGKgvDrHkIVOtrUciX1KqSgoF4JRbRxHKPstGSEHTGEAiVNebIT8RVliEQ
   HCCP531nS0xdLMd1sm0DPb/2aQ5o6UhsbBKPytNRXv221Tib5if2XpcDHO2xVg8gIrofju4FqhNS
   uCTEuA/BypmAhtD/mEeobzB5DJm1v6+FffstlQJxq9tAAaQwVyUNl8yycaUHqclCjaWz5pWTx4uP
   2YDeVFUVDhuUEpK6CucbzkHbTc0mPvaKmKtkBQ==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWE002242F9ZP80@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 17 Jun 2023 08:33:09 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1686990778; bh=3mdE4luZLmdJHy6yf2RAps3rcIAZbBhQQOyWTEHt3ik=;
 h=Subject:To:Cc:From:Date:From;
 b=hCL1egae+XcRpAI6qwmOZaOMCE5xT/2Gvv3rlFvgqC2HxNS5DvIYaapzIZkdLSfGZ
 CfZ/H4HMj0i1/aREqrh09Atn+fHkyiGMi7O+WiUxYhiChyFmspkboMszys7FZ6Zzhf
 Rgv9pQSktQF8Djb0hk7gA9zSmr2rNfKNZ17anruE=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 junxiao.bi@oracle.com, lhenriques@suse.de, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Sat, 17 Jun 2023 10:32:13 +0200
Message-id: <2023061712-relocate-geiger-444b@gregkh>
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10743
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 mlxlogscore=999 mlxscore=0 priorityscore=0 impostorscore=0 suspectscore=0
 spamscore=0 bulkscore=0 clxscore=269 adultscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306170077 domainage_hfrom=7830
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch "ocfs2: check new file size on fallocate call"	has
 been added to the 5.10-stable tree
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
From: gregkh--- via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: gregkh@linuxfoundation.org
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-stable: commit
X-Patchwork-Hint: ignore
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: erjSl9ccvR_xy6WDcKWr_bpukHa3N6cZ
X-Proofpoint-ORIG-GUID: erjSl9ccvR_xy6WDcKWr_bpukHa3N6cZ
Reporting-Meta:
 AAFUbcvXEO5EYO4fE7rHPQAfXmkmAorkbMtfh7esktVWNeINyDro85vMf2O2ogK2
 w+OaBCbo8Tt0zlJ4uKDXobBmFSKQwFE0e6aOO6Hod0ER9HcABTeBtSSr8mDWTWw7
 11xsgeR8VVBzwvMNXiMIqWLkV9ey2vPHyFlbCwxNjURwOfvs8ywVqJdewg2xPQxl
 YDWD6C3Qo5kDnfKmUBDAV6g+Iz3z2L3twm7P3nft7YiImI05BVlpuLxLPZ6RDFhx
 IdNHQFxLPumnXOcMu9O9DnAg3GkdmUPq9WK4nblEmMwVWYJiRoXJz2aL84N55wHi
 +wHwLiNHDA/fzvOGpx2qKWklvWnVtBb08ThUTKDKtjXuI3r3U+c9rhDHCjMCtV9t
 5ydb16PqPrcNLQKkDi+5VvaZZ2PxVztPoqFqdvlJFIyvhxWeDuQ2qubNHiU2pagb
 u+OgAr2QZH7Wf2TkJwGvaRA2iORUb9mZ7zxXs0xYM3z84eSYWMVAQlD9dFpUnQsc
 HEp3SVAhn7gL73DaBgr1/5adKAH2jvXwIfKYILHNH5yg4A==

ClRoaXMgaXMgYSBub3RlIHRvIGxldCB5b3Uga25vdyB0aGF0IEkndmUganVzdCBhZGRlZCB0aGUg
cGF0Y2ggdGl0bGVkCgogICAgb2NmczI6IGNoZWNrIG5ldyBmaWxlIHNpemUgb24gZmFsbG9jYXRl
IGNhbGwKCnRvIHRoZSA1LjEwLXN0YWJsZSB0cmVlIHdoaWNoIGNhbiBiZSBmb3VuZCBhdDoKICAg
IGh0dHA6Ly93d3cua2VybmVsLm9yZy9naXQvP3A9bGludXgva2VybmVsL2dpdC9zdGFibGUvc3Rh
YmxlLXF1ZXVlLmdpdDthPXN1bW1hcnkKClRoZSBmaWxlbmFtZSBvZiB0aGUgcGF0Y2ggaXM6CiAg
ICAgb2NmczItY2hlY2stbmV3LWZpbGUtc2l6ZS1vbi1mYWxsb2NhdGUtY2FsbC5wYXRjaAphbmQg
aXQgY2FuIGJlIGZvdW5kIGluIHRoZSBxdWV1ZS01LjEwIHN1YmRpcmVjdG9yeS4KCklmIHlvdSwg
b3IgYW55b25lIGVsc2UsIGZlZWxzIGl0IHNob3VsZCBub3QgYmUgYWRkZWQgdG8gdGhlIHN0YWJs
ZSB0cmVlLApwbGVhc2UgbGV0IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPiBrbm93IGFib3V0IGl0
LgoKCkZyb20gMjZhNmZmZmY3ZGU1ZGQzNjljZGIxMmUzOGJhMTFkYjY4MmYxZGVjMCBNb24gU2Vw
IDE3IDAwOjAwOjAwIDIwMDEKRnJvbTogPT9VVEYtOD9xP0x1PUMzPUFEcz0yMEhlbnJpcXVlcz89
IDxvY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbT4KRGF0ZTogTW9uLCAyOSBNYXkgMjAyMyAxNjoy
Njo0NSArMDEwMApTdWJqZWN0OiBvY2ZzMjogY2hlY2sgbmV3IGZpbGUgc2l6ZSBvbiBmYWxsb2Nh
dGUgY2FsbApNSU1FLVZlcnNpb246IDEuMApDb250ZW50LVR5cGU6IHRleHQvcGxhaW47IGNoYXJz
ZXQ9VVRGLTgKQ29udGVudC1UcmFuc2Zlci1FbmNvZGluZzogOGJpdAoKRnJvbTogTHXDrXMgSGVu
cmlxdWVzIDxvY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbT4KCmNvbW1pdCAyNmE2ZmZmZjdkZTVk
ZDM2OWNkYjEyZTM4YmExMWRiNjgyZjFkZWMwIHVwc3RyZWFtLgoKV2hlbiBjaGFuZ2luZyBhIGZp
bGUgc2l6ZSB3aXRoIGZhbGxvY2F0ZSgpIHRoZSBuZXcgc2l6ZSBpc24ndCBiZWluZwpjaGVja2Vk
LiAgSW4gcGFydGljdWxhciwgdGhlIEZTSVpFIHVsaW1pdCBpc24ndCBiZWluZyBjaGVja2VkLCB3
aGljaCBtYWtlcwpmc3Rlc3QgZ2VuZXJpYy8yMjggZmFpbC4gIFNpbXBseSBhZGRpbmcgYSBjYWxs
IHRvIGlub2RlX25ld3NpemVfb2soKSBmaXhlcwp0aGlzIGlzc3VlLgoKTGluazogaHR0cHM6Ly9s
a21sLmtlcm5lbC5vcmcvci8yMDIzMDUyOTE1MjY0NS4zMjY4MC0xLWxoZW5yaXF1ZXNAc3VzZS5k
ZQpTaWduZWQtb2ZmLWJ5OiBMdcOtcyBIZW5yaXF1ZXMgPGxoZW5yaXF1ZXNAc3VzZS5kZT4KUmV2
aWV3ZWQtYnk6IE1hcmsgRmFzaGVoIDxtYXJrQGZhc2hlaC5jb20+ClJldmlld2VkLWJ5OiBKb3Nl
cGggUWkgPGpvc2VwaC5xaUBsaW51eC5hbGliYWJhLmNvbT4KQ2M6IEpvZWwgQmVja2VyIDxqbGJl
Y0BldmlscGxhbi5vcmc+CkNjOiBKdW54aWFvIEJpIDxqdW54aWFvLmJpQG9yYWNsZS5jb20+CkNj
OiBDaGFuZ3dlaSBHZSA8Z2VjaGFuZ3dlaUBsaXZlLmNuPgpDYzogR2FuZyBIZSA8Z2hlQHN1c2Uu
Y29tPgpDYzogSnVuIFBpYW8gPHBpYW9qdW5AaHVhd2VpLmNvbT4KQ2M6IDxzdGFibGVAdmdlci5r
ZXJuZWwub3JnPgpTaWduZWQtb2ZmLWJ5OiBBbmRyZXcgTW9ydG9uIDxha3BtQGxpbnV4LWZvdW5k
YXRpb24ub3JnPgpTaWduZWQtb2ZmLWJ5OiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51
eGZvdW5kYXRpb24ub3JnPgotLS0KIGZzL29jZnMyL2ZpbGUuYyB8ICAgIDggKysrKysrKy0KIDEg
ZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCi0tLSBhL2ZzL29j
ZnMyL2ZpbGUuYworKysgYi9mcy9vY2ZzMi9maWxlLmMKQEAgLTIxMDMsMTQgKzIxMDMsMjAgQEAg
c3RhdGljIGxvbmcgb2NmczJfZmFsbG9jYXRlKHN0cnVjdCBmaWxlCiAJc3RydWN0IG9jZnMyX3Nw
YWNlX3Jlc3Ygc3I7CiAJaW50IGNoYW5nZV9zaXplID0gMTsKIAlpbnQgY21kID0gT0NGUzJfSU9D
X1JFU1ZTUDY0OworCWludCByZXQgPSAwOwogCiAJaWYgKG1vZGUgJiB+KEZBTExPQ19GTF9LRUVQ
X1NJWkUgfCBGQUxMT0NfRkxfUFVOQ0hfSE9MRSkpCiAJCXJldHVybiAtRU9QTk9UU1VQUDsKIAlp
ZiAoIW9jZnMyX3dyaXRlc191bndyaXR0ZW5fZXh0ZW50cyhvc2IpKQogCQlyZXR1cm4gLUVPUE5P
VFNVUFA7CiAKLQlpZiAobW9kZSAmIEZBTExPQ19GTF9LRUVQX1NJWkUpCisJaWYgKG1vZGUgJiBG
QUxMT0NfRkxfS0VFUF9TSVpFKSB7CiAJCWNoYW5nZV9zaXplID0gMDsKKwl9IGVsc2UgeworCQly
ZXQgPSBpbm9kZV9uZXdzaXplX29rKGlub2RlLCBvZmZzZXQgKyBsZW4pOworCQlpZiAocmV0KQor
CQkJcmV0dXJuIHJldDsKKwl9CiAKIAlpZiAobW9kZSAmIEZBTExPQ19GTF9QVU5DSF9IT0xFKQog
CQljbWQgPSBPQ0ZTMl9JT0NfVU5SRVNWU1A2NDsKCgpQYXRjaGVzIGN1cnJlbnRseSBpbiBzdGFi
bGUtcXVldWUgd2hpY2ggbWlnaHQgYmUgZnJvbSBvY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbSBh
cmUKCnF1ZXVlLTUuMTAvb2NmczItY2hlY2stbmV3LWZpbGUtc2l6ZS1vbi1mYWxsb2NhdGUtY2Fs
bC5wYXRjaApxdWV1ZS01LjEwL29jZnMyLWZpeC11c2UtYWZ0ZXItZnJlZS13aGVuLXVubW91bnRp
bmctcmVhZC1vbmx5LWZpbGVzeXN0ZW0ucGF0Y2gKCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZl
bEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8v
b2NmczItZGV2ZWw=
