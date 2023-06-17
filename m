Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71551EB64DB
	for <ocfs2-devel@archiver.kernel.org>; Sat, 17 Jun 2023 08:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wB6O/LwKdwUr3K1W+Ulf+7Zpl/Zb4Ftq8JOjGR6Cxcc=;
 b=wdQb4KH400ljxLp+9LxY9/7wr94RFBTsqp2QXVzXUzxHQ6Y/5wuiQF6zOObxlSGE3YQuZf0nSH++
   CqM310KvTJkOQdTnf+EY2U5Izk+PZovQnQ8vWymAJVcOZgiBjzVuchCSdloOqzOinwiJ7wAWd3bE
   0IyIkuLXQC7lQSmiEjVPkrd58XE9nJ+gSapfcbJuzOodFoSNyEwZP/Igq/p9q85cs5Z/Mf5Vp6SD
   4VX71cchEtKCDGOEl4brB0H5A7xSpPlyN6tF3AFHBeXVRZnY2UReu84XjvnGemvI7tDUzyr+dr2g
   YIRqPGYjVMuDDDTbV2h58kxR4fTnCCakXaglqw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wB6O/LwKdwUr3K1W+Ulf+7Zpl/Zb4Ftq8JOjGR6Cxcc=;
 b=AdDTqpGZF6Tb3XXQznTOQNNsx6rLmzq6FzzsqybqfYjLB2vNUkSDrsygn0oy6OBld8NrPXYVbcjW
   USBi8L1Nk90AwT9QGORXcStWJzeeuvmqFTH7B7KDzBSHsxNx31FmNYH+YUDK6PgZdBsee+G1VnwN
   o9LV93GtcYGVLqpLVO/XhV/hpjb9pVswvKnNYMzbcmjd2TETELqQ1qw2qYQD65W4UkHgBBGAz1Xg
   8FybFJ1dP5emIHWPPFz8CL+bUf97P4oZdavgKkOqrBTieEZmxMsAJHDyoiRiIsf57nE69uNZcaot
   vsJBZoGarLN5FCq+Lj47rnyng2SA5R6NXIOqoA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWE007R92GKH730@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 17 Jun 2023 08:33:56 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1686990824; bh=+zMYEENkgP+vrqlLAmX0zqffpPNGRhhybPiTVNCrHcQ=;
 h=Subject:To:Cc:From:Date:From;
 b=X8O9x6Lq4VdEfi1O6Ok3TPcNqIS3TtOxCwL+w8mxhvPka4FmqKbAL9dHt/MPAi2zr
 Iroz6MoafirEkWrYg4Hz2NNMcCQUuGXGeYkutnXfyQeQfmuESi5PxtNWsBrANmGnH0
 IM4MGKHcIkgdNjAd89vNvSRGwLfDLPM4UhAUcM/U=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 junxiao.bi@oracle.com, lhenriques@suse.de, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Sat, 17 Jun 2023 10:32:28 +0200
Message-id: <2023061728-craftwork-regally-9953@gregkh>
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10743
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 bulkscore=0 clxscore=258
 priorityscore=48 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306170077 domainage_hfrom=7830
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch "ocfs2: check new file size on fallocate call"	has
 been added to the 5.15-stable tree
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
X-Proofpoint-GUID: 9hmwHK1iqUanHIjJMsa46kXdNcYtQLEO
X-Proofpoint-ORIG-GUID: 9hmwHK1iqUanHIjJMsa46kXdNcYtQLEO
Reporting-Meta:
 AAG45RdELGiu8jLpHkNV7TTxum5jTS62NKd6jo5CgqarYbxX1hd8LyIazpaymw6T
 pm5oYdlX9dyoPVSGQq9jUPn7/QqxtJ6fBvsPNkfsgeBePLGahMIi+Yqh6RnbWsiR
 VVmVC4I8Rc9/f1xnf2N+DEmOIgSs/KbtOvv81LgK0qFF/x/0KndHCrIY+RINLM+Z
 dBsLzbnhMrNN6GdT/FDOHq7cXp6VSi2xTDZ0jKTLhitNe8/L+m1WO/eANKvMgSU+
 UqTaXamROPOtvfGtM29oONBk8n2XgyokcHO95IMj8rDYPSysVjPYdZfKd0ImXXpC
 qSHvUYfJSDwC30ZiYgq1rwxJkqlN+woyKigvr+EZQ8bMpdLmdUYhmUkbXjdcMo4E
 rMvtfLDd8YDMwT9tdkBMI+uG9aSJOfqYxaIuqaVErA8uRLJYEbkYHr9CfnGghjwj
 hNCyNlD3eAmZRgs0eWU7ECw7QeVXoZ/HDznIY0nN+M5FH1dG4CTUCO5MJqG0OQ6/
 EM7eP45YZDCp2Z57GQx94QnkIfCROJdF+oyeLk1rAvoT7A==

ClRoaXMgaXMgYSBub3RlIHRvIGxldCB5b3Uga25vdyB0aGF0IEkndmUganVzdCBhZGRlZCB0aGUg
cGF0Y2ggdGl0bGVkCgogICAgb2NmczI6IGNoZWNrIG5ldyBmaWxlIHNpemUgb24gZmFsbG9jYXRl
IGNhbGwKCnRvIHRoZSA1LjE1LXN0YWJsZSB0cmVlIHdoaWNoIGNhbiBiZSBmb3VuZCBhdDoKICAg
IGh0dHA6Ly93d3cua2VybmVsLm9yZy9naXQvP3A9bGludXgva2VybmVsL2dpdC9zdGFibGUvc3Rh
YmxlLXF1ZXVlLmdpdDthPXN1bW1hcnkKClRoZSBmaWxlbmFtZSBvZiB0aGUgcGF0Y2ggaXM6CiAg
ICAgb2NmczItY2hlY2stbmV3LWZpbGUtc2l6ZS1vbi1mYWxsb2NhdGUtY2FsbC5wYXRjaAphbmQg
aXQgY2FuIGJlIGZvdW5kIGluIHRoZSBxdWV1ZS01LjE1IHN1YmRpcmVjdG9yeS4KCklmIHlvdSwg
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
cmUKCnF1ZXVlLTUuMTUvb2NmczItY2hlY2stbmV3LWZpbGUtc2l6ZS1vbi1mYWxsb2NhdGUtY2Fs
bC5wYXRjaApxdWV1ZS01LjE1L29jZnMyLWZpeC11c2UtYWZ0ZXItZnJlZS13aGVuLXVubW91bnRp
bmctcmVhZC1vbmx5LWZpbGVzeXN0ZW0ucGF0Y2gKCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZl
bEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8v
b2NmczItZGV2ZWw=
