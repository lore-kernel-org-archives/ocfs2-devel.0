Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E41EBC433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 15 Jun 2022 02:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hLB51oqxEUe7I9cPcKfy5Wpy3gDYoyS/WkGUb67g9cA=;
 b=pZ+DmhNTFokWX9bJwGRKy0XwJvglvAi4JTPqPy0J1JFVv0MdLg9FjtVJMZyktJyhEZL0jnB6pHjm
   ZowSs7CnBFlFW06frC9m5MwTcVzgVEXtMHg5UBDm28yJ4/1yJHgdks4lWPzMraHNXhLDmYa4Rlpa
   ro3quG6qF1NKLWNav0cyJX6fie3qG8XAncNNRm4hMU2qVEJ83dFYLNQZ4HDLtBpUfWloPgVlhyw/
   iG3HNQd1Ifj+4AKybf3X0GJ1bC2ly3Ov9nQXqYRe+D/jA52sMHHDIl6eXw1FbXo3Z+m3Bh/g6pOa
   0JT8DeLEpGqyRfHFP9HPrALH85T4B6bCj/GZ4g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hLB51oqxEUe7I9cPcKfy5Wpy3gDYoyS/WkGUb67g9cA=;
 b=KYZOMRa5PIIUCMYXReMp4l/69dKZ/quiB+FcxhMiZi6550DvawFhEj5GhqdPROQCIPXfr2zjKem3
   4nEq8Dd+AXBhSrhFZlNZCowMEH/bf0kOHfmVy3a/XQ1K2jNIO2iHL8/44rPM0zFJsQgXRTmcq7Am
   Wg2y1DpNe3I76lpwVAjvgc0EpmPSPZoYogYWa384uNc6v2pp5FdF88QqgSB0iKE6XO+fpw/q7Rg6
   eiDYTumnrTArUFwXGWw+5ThgUpHG4/uVSDQJRXvnYl2KyKGXi6Vcnnnl4roCjizczumIbESsTXpE
   oZXSinl0f0Oua4vht+QIlqtSTQl6Ugyyg6nMug==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220531 64bit (built May 31
 2022))
 with ESMTPS id <0RDH00B9VXPKHF70@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 15 Jun 2022 02:03:20 +0000 (GMT)
Message-id: <eab76c68-2dfa-bead-ece9-4baa6cb82ef6@linux.alibaba.com>
Date: Wed, 15 Jun 2022 10:03:04 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Content-language: en-US
To: "heming.zhao@suse.com" <heming.zhao@suse.com>,
 Junxiao Bi <junxiao.bi@oracle.com>
References: <20220608104808.18130-1-heming.zhao@suse.com>
 <20220608104808.18130-2-heming.zhao@suse.com>
 <09b33ef3-b93a-5b50-d87d-8667ed993e5d@linux.alibaba.com>
 <faee689f-7a04-2042-636c-80fb48bc30ed@suse.com>
 <8dd30c4e-d572-bfd0-f261-b9cfcd8b5b4d@linux.alibaba.com>
 <28b5b33b-1942-b128-d3f0-5e3592338dad@suse.com>
 <FFE0CF5B-76C7-49E0-B9AC-02C7FC21BADD@oracle.com>
 <8b01df99-4690-92a6-c37b-5226a9222d51@suse.com>
 <ea848935-abf6-90d6-9313-852cf8344852@linux.alibaba.com>
 <633910e3-83f0-23e1-0b85-78a1a2fbdb91@suse.com>
In-reply-to: <633910e3-83f0-23e1-0b85-78a1a2fbdb91@suse.com>
X-Source-IP: 47.90.199.11
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10378
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 bulkscore=0 priorityscore=0 spamscore=0 impostorscore=0 mlxscore=0
 phishscore=0 clxscore=165 mlxlogscore=999 adultscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206150003 domainage_hfrom=8462
Cc: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 1/1] ocfs2: fix ocfs2_find_slot repeats alloc
 same slot issue
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R211e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046051;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VGQOu3I_1655258584;
X-ServerName: out199-11.us.a.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: hyE4-L4tTAUbFWhanvl13bRVViSsGTsH
X-Proofpoint-ORIG-GUID: hyE4-L4tTAUbFWhanvl13bRVViSsGTsH
Reporting-Meta:
 AAHN/Ml1cRj5WN4u5qlGHTtFNaAwh1Xdv9aWlSDOm9vGQ0NdMrfh6ZZpKt9to3tE
 C5cJTwsDypZuvzQjoUXEL76B34DtMjjcDGe0jOqbO8bVdKqgXZWeaXEzGeF3kEW3
 MvpsJr+fQ9c+ln0C0wsxUY0G/sEzqJSxvi1c8Ce+uc4lSIpFxSTufe7EJHj/ywN1
 lTSvoJ6yj6eYENTByHyGjyVIPTyh6nmrmkkuUfItv2Kmj6hu0j5Rbe4guk3ewMEz
 9ijtk/QpFoEdGiAe3pChjY8e+kRHdNx1iJkNkzi8+VnwLTv4XHNHNcJPqmHoZwLC
 iY8mn07n587eMED6Vu3Eiop+Zu2p4vIDJnVldv92H8fj2ZlQxEN5GCsYAhK/cqNS
 Eh1KiJnTHO3F3xssjSY+LDRpwpQ8U21cYAhMETiVlKH9M6Cfb3IeMRNgEmHpx10x
 jZD7Fn62fZT32MXdQnSy8BmEYFRlujiGlofp4EKwxSW/xiVPRaFc5UZLnE4bUR5d
 +HhSxFQ6JG0oBjB0stcpOLcIjoQtwxF0rqQo2qpouAct

CgpPbiA2LzE0LzIyIDg6MTMgUE0sIGhlbWluZy56aGFvQHN1c2UuY29tIHdyb3RlOgo+IE9uIDYv
MTQvMjIgMTE6MjcsIEpvc2VwaCBRaSB3cm90ZToKPj4KPj4KPj4gT24gNi8xNC8yMiAxMDo1OSBB
TSwgaGVtaW5nLnpoYW9Ac3VzZS5jb20gd3JvdGU6Cj4+PiBPbiA2LzEzLzIyIDIzOjQzLCBKdW54
aWFvIEJpIHdyb3RlOgo+Pj4+Cj4+Pj4+IOWcqCAyMDIy5bm0NuaciDEz5pel77yM5LiK5Y2IMTo0
OO+8jGhlbWluZy56aGFvQHN1c2UuY29tIOWGmemBk++8mgo+Pj4+Pgo+Pj4+PiDvu79PbiA2LzEz
LzIyIDE2OjIxLCBKb3NlcGggUWkgd3JvdGU6Cj4+Pj4+Pj4gT24gNi8xMy8yMiAzOjU5IFBNLCBo
ZW1pbmcuemhhb0BzdXNlLmNvbSB3cm90ZToKPj4+Pj4+PiBPbiA2LzEyLzIyIDIyOjE2LCBKb3Nl
cGggUWkgd3JvdGU6Cj4+Pj4+Pj4+IEhpLAo+Pj4+Pj4+Pgo+Pj4+Pj4+PiBXaHkgY2FuJ3QgdXNl
IGxvY2FsIG1vdW50PyBJIGRvbid0IHJlbWVtYmVyIGlmIHdlIGRpc2N1c3MgYWJvdXQgdGhpcy4K
Pj4+Pj4+Pj4KPj4+Pj4+PiBTb3JyeSwgSSBjYW4ndCBmb2xsb3cgeW91ciBxdWVzdGlvbi4KPj4+
Pj4+PiBEbyB5b3UgbWVhbiB3aHkgcmV2ZXJ0IGNvbW1pdCA5MTJmNjU1ZDc4YzU/Cj4+Pj4+Pj4K
Pj4+Pj4+PiBvciB5b3UgYXJlIGludGVyZXN0IHdpdGggdGhlIGZlYXR1cmUgbG9jYWwgbW91bnQ/
Cj4+Pj4+Pj4gdGhlIGxvY2FsIG1vdW50IGlzIGNyZWF0ZWQgYnkgbWtmcy5vY2ZzMiwgd2hpY2gg
Y2FuJ3QgYmUgY29udmVydGVkIHRvIGNsdXN0ZXJlZC4KPj4+Pj4+PiBzZWUgbWtmcy5vY2ZzMig4
KSAnLU0nIG9wdGlvbi4KPj4+Pj4+Pgo+Pj4+Pj4gV2hhdCBKdW54aWFvJ3MgbWFpbiBjb25jZXJu
IGlzIGRhdGEgY29ycnVwdGlvbiwgc28gSSdtIGFmcmFpZCB3ZSBoYXZlIHRvCj4+Pj4+PiBpbnRy
b2R1Y2UgYW4gb25kaXNrIGZlYXR1cmUgYml0IHRvIHByZXZlbnQgbWl4ZWQgbm9jbHVzdGVyIGFu
ZCBjbHVzdGVyCj4+Pj4+PiBtb3VudCwgc2ltaWxhciB0byBsb2NhbCBtb3VudC4KPj4+Pj4KPj4+
Pj4gdGhpcyBwYXRjaCBkZWZpbmVkIHR3byBuZXcgdmFyaWFudHMvZmxhZ3M6Cj4+Pj4+ICNkZWZp
bmUgT0NGUzJfU0xPVE1BUF9DTFVTVEVSwqDCoCAxCj4+Pj4+ICNkZWZpbmUgT0NGUzJfU0xPVE1B
UF9OT0NMVVNURVIgMgo+Pj4+Pgo+Pj4+PiAoSSBleHBlY3QpIFVuZGVyIE9DRlMyX1NMT1RNQVBf
Q0xVU1RFUiwgZm9yIGNsdXN0ZXJlZCBtb3VudCBtb2RlIGFuZCBmb3IgY29tcGF0aWJpbGl0eSwK
Pj4+Pj4gYW55dGhpbmcgZG9lc24ndCBuZWVkIHRvIGJlIGNoYW5nZWQuCj4+Pj4+Cj4+Pj4+IE9D
RlMyX1NMT1RNQVBfTk9DTFVTVEVSIHdpbGwgaW50cm9kdWNlIGEgbmV3IHZhbHVlIGZvciBzbG90
bWFwIGFyZWEuCj4+Pj4+IHRoaXMgbmV3IHZhbHVlIG9ubHkgdGFrZSBlZmZlY3QgYWZ0ZXIgYSBz
dWNjZXNzZnVsbHkgbm9jbHVzdGVyIG1vdW50Lgo+Pj4+PiAocGxzIGZpeCBtZSksIGV4aXN0ZWQg
a2VybmVsL3VzZXIgc3BhY2UgY29kZSBkb24ndCBkbyBhbnkgc3BlY2lhbCBoYW5kbGUgZm9yCj4+
Pj4+IG5vY2x1c3RlcmVkIG1vdW50IG1vZGUgaW4gc2xvdG1hcCBhcmVhLiBTbyB0aGUgbmV3IHZh
bHVlIGlzIGFsc28gY29tcGF0aWJpbGl0eS4KPj4+Pj4KPj4+Pj4gQW5kIHRoZSBwYXRjaCBjYW4g
YWxzbyBwcmV2ZW50IG1peGVkIG1vdW50LCB0aGUgcmVsYXRlZCBjb2RlIGlzIGluIG9jZnMyX2Zp
bmRfc2xvdCgpLgo+Pj4+PiBjb2RlIGxvZ2ljOgo+Pj4+PiAtIG5vY2x1c3RlcmVkIG1vdW50IGNv
bmRpdGlvbjogc2xvdG1hcCBpcyBlbXB0eSBvciBhbHJlYWR5IG1vdW50ZWQgd2l0aCBub2NsdXN0
ZXJlZAo+Pj4+PiAtIGNsdXN0ZXJlZCBtb3VudCBjb25kaXRpb246IHNsb3RtYXAgaXMgZW1wdHkg
b3IgYWxyZWFkeSBtb3VudGVkIHdpdGggY2x1c3RlcmVkLgo+Pj4+PiAtIGFsbCBvdGhlciBjb25k
aXRpb25zIHdpbGwgYmUgZGVuaWVkLgo+Pj4+IEZpbmRpbmcgc2xvdCByZXF1aXJlZCByZWFkaW5n
IHNsb3QgbWFwIGFuZCB0aGVuwqAgdXBkYXRlIHNsb3QgbWFwLiBJdCBpcyBub3QgYXRvbWljICwg
eW91IGNhbuKAmXQgcHJldmVudCBtaXhlZCBtb3VudCB1bnRpbCB5b3UgaGF2ZSBhIGNsdXN0ZXIg
bG9jay4KPj4+Cj4+PiBDb3VsZCBJIHNheSB5b3VyIG1lbnRpb25lZCB1c2UgY2FzZSBpcyBpbnZh
bGlkLgo+Pj4gSSBiZWxpZXZlIGFsbCAoeWVzLCAqYWxsKikgdGhlIG9jZnMyIHVzZXJzIHVzZSB0
aGlzIGZzIHVuZGVyIGNsdXN0ZXIgbW9kZSBpbgo+Pj4gdGhlaXIgcHJvZHVjdCBlbnYuCj4+PiBU
aGUgbm9jbHVzdGVyIG1vdW50IGlzIG9ubHkgdXNlZCBvbiBtYWludGFpbmVkIGVudiAoZWcuIGJh
Y2t1cCwgZnNjaykuCj4+Pgo+Pj4gV2Ugb25seSBjb25jZXJuIHR3byB3YXlzOgo+Pj4gMS4gdXNl
ciBmb3JnZXRzIHRvIHVubW91bnQgKGVnIGNyYXNoKSBiZWZvcmUgdXNpbmcgYW5vdGhlciBtb3Vu
dCBtb2RlLgo+Pj4gMi4gd2hlbiBvY2ZzMiB2b2x1bWUgaXMgd29ya2luZywgd2hpY2ggc2hvdWxk
IGRlbnkgdm9sdW1lIGlzIG1vdW50ZWQgYnkgYW5vdGhlciBtb2RlLgo+Pj4gwqDCoMKgIHRoaXMg
bWF5IGhhcHBlbmVkIHVzZXIgbWlzdGFrZW5seSBydW5zIGNvbW1hbmQgb3Igc2NyaXB0Lgo+Pj4K
Pj4+IEJhc2Ugb24gYWJvdmUgMSAmIDIsIEp1bnhpYW8gYWJvdmUgbWVudGlvbmVkIHVzZSBjYXNl
IG9ubHkgaGFwcGVucyBvbiBvbmUgc2NlbmFyaW86Cj4+PiB0aGUgdm9sdW1lIGRvZXNuJ3QgYmUg
bW91bnRlZCBieSBhbnkgbm9kZSwgdGhlbiB1c2VyIG1pc3Rha2VubHkgbW91bnRzIHZvbHVtZQo+
Pj4gd2l0aCBbbm9dY2x1c3RlciBtb2RlIGF0IHNhbWUgdGltZS4gSSBiZWxpZXZlIHRoaXMgdXNl
IGNhc2UgaXMgaW52YWxpZC4gQW5kIEkgZ3Vlc3MKPj4+IGdmczIgbWF5IGFsc28gaGFzIHRoZSBz
YW1lIGlzc3VlLgo+Pj4KPj4+IFdpdGggdGhpcyBwYXRjaCwgb2NmczIgaGFzIG1vcmUgc2FuaXR5
IGNoZWNrIGFiaWxpdHkgdGhhbiBvdGhlciBmcywgZWc6IHhmcywgZXh0NC4KPj4+IFNVU0UgSEEg
c3RhY2sgd2l0aCBjb3Jvc3luYytwYWNlbWFrZXIgYWxzbyBzdXBwb3J0cyBydW5uaW5nIHhmcy9l
eHQ0IHdpdGggQS9QIG1vZGUuCj4+PiBUaGUgeGZzL2V4dDQgbmV2ZXIgaGF2ZSBkZXRlY3Rpbmcg
bW91bnQgc3RhdHVzIGNvZGUsIEp1bnhpYW8gbWVudGlvbmVkIG1peGVkIG1vdW50Cj4+PiBjYW4g
YWxzbyBoYXBwZW5zIG9uIHRoZXNlIGZzLiBIb3cgZG8geGZzL2V4dDQvSEEgbWFpbnRhaW5lcnMg
aGFuZGxlIGl0PyBVbmRlciB0aGVzZQo+Pj4gZnMgbW91bnRpbmcgYmVoYXZpb3IsIHRoZXNlIGZp
ZWxkcyBtYWludGFpbmVycyBhbHNvIHRyZWF0IHRoZSBtaXhlZCBtb3VudCBhcwo+Pj4gaW52YWxp
ZCB1c2UgY2FzZSBhbmQgaWdub3JlIGhhbmRsZSBpdC4KPj4KPj4gRXh0NCBoYXMgYSBmZWF0dXJl
IG1tcCAobXVsdGlwbGUgbW91bnQgcHJvdGVjdGlvbikgdG8gZG8gdGhpcy4KPj4gTW9yZSBkZXRh
aWxzIHBsZWFzZSByZWZlciB0bzoKPj4gaHR0cHM6Ly9leHQ0Lndpa2kua2VybmVsLm9yZy9pbmRl
eC5waHAvRXh0NF9EaXNrX0xheW91dAo+Pgo+IAo+IEhpIEpvc2VwaCwKPiAKPiBJIGNoZWNrZWQg
bW1wIGZlYXR1cmUgcmVsYXRlZCBjb2RlLCBpdCBjYW4gaGVscCBleHQ0IHRvIGF2b2lkIG11bHRp
cGxlIG1vdW50IGlzc3VlLgo+IAo+IEZyb20gbXkgY29kZSByZWFkaW5nOgo+IC0gdGhlIG1tcCBm
ZWF0dXJlIGRpZCBtbXAgY2hlY2sgd2hlbiBtb3V0aW5nLgo+IC0gdGhlIG1tcCBmZWF0dXJlIHdp
bGwgc3RhcnQgYSBrZXJuZWwgdGhyZWFkIChrbW1wZCkgdG8gbW9uaXRvciBtb3VudCBzdGF0dXMu
Cj4gLSBrbW1wZCBkb2VzIGRldGVjdGluZyB1bmRlcmx5aW5nIGRldiBJT3MgdGFzay4KPiAKPiBX
ZSBjb3VsZCByZS11c2UgbW1wIGZlYXR1cmUgaWRlYSBmb3Igb2NmczIsIGRvIHlvdSBwbGFuIHRv
IGFkZCBpdD8KPiBJZiB5ZXMsIEkgY291bGQgdGFrZSB0aGlzIGZlYXR1cmUgcG9ydGluZyBqb2Iu
Cj4gClVtbS4uLiBJIHJlZmVyIGl0IGp1c3QgZm9yIHlvdXIgaW5mb3JtYXRpb24uCm9jZnMyIGlz
IGNsdXN0ZXIgZmlsZXN5c3RlbSwgZm9yIG5vcm1hbCB1c2VyIHNjZW5hcmlvcywgd2UgaW50ZW5k
IHRvCm1vdW50IG9uIG11bHRpcGxlIG5vZGVzLgpGb3IgdXNlIGl0IGFzIGxvY2FsIGZpbGVzeXN0
ZW0sIHdlIGhhdmUgbG9jYWwgbW91bnQgbW9kZS4KU28gaXQgc2VlbXMgJ25vY2x1c3RlcicgbW9k
ZSBsb29rcyBhIGJpdCB3ZWlyZC4gSSdtIG5vdCBzdXJlIGlmIHRoaXMgaXMKYSBmcmVxdWVudGx5
IGhhcHBlbmVkIHVzZXIgY2FzZS4gT3IgY2FuIHdlIGRvIGl0IGluIGNsdXN0ZXIgc3RhY2sgYXMK
SnVueGlhbyBzdWdnZXN0ZWQ/IE9yYWNsZSBhbmQgSSAoYmVmb3JlKSBvbmx5IHVzZSBvMmNiLCBz
byB3ZSBkb24ndCBoYXZlCm11Y2ggZXhwZXJpZW5jZSBvbiBjb3Jvc3luYyArIHBhY2VtYWtlci4K
ClRoYW5rcywKSm9zZXBoCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5j
b20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
