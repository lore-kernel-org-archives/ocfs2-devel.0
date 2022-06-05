Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A453FC433EF
	for <ocfs2-devel@archiver.kernel.org>; Sun,  5 Jun 2022 00:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3Gn3OPbrSynVrmfk3AxAdyMsfcyJSAV0Pjvsngh8VTI=;
 b=UxvwZdNYJtKKPFN7kWdrSFZdISvOhK2w0ehlR0TEXFP5fuFwA/3bCybEX0DhAlClaRZnIXxps8fI
   RYfm+kaQ5k8W/wy5zP0Z5OPrz6J87tkylUp4JwuJ1mrQ/g3I1lxTBe+dG+yZ79LLDAwz1xGHQxGX
   ow7n+zogzJCWhw9TzJBjpW3DW+a6x6T5PbSihCrAp4oBWX6OZJkMe1Ikj0QOFtFerjs+pixBSOP/
   23ur4F4G2QqvwOB5F/60IZz3oI4/FsJxGIBZkH8+NPhmt54nMZo3tNjR8wGHL0o5aiGuJ8XVFJdR
   ETGesRG3fCKZlvuWya/BExqwZZ3sZnQ3vcDTgw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=3Gn3OPbrSynVrmfk3AxAdyMsfcyJSAV0Pjvsngh8VTI=;
 b=W9Es8WBky+jDbaTePbWM0bLByupEa/O9Rkq8fY697U4yW5uuaLs4jSWXDMjoquMUBCb90CsTEVRB
   8taVWtJFvEr8A4Z1XCpsUhso6R0IY8fMXWvoNsQnscf6ZSFe2qWxuYYopqBb/DlsD00fd5T6kw+B
   za//w2elDfLN4tOYJAU6NzE+IuVeJ50fiNfpJWe27sI7tsU9oudIaIxYGVQ85Jd9rxTDpXslpjtk
   e61uc7BDuq1buX1Ok1vqrZSPctTa3RSuuezJCSYtlOLaPFiz9D2zvISjIzy7F6F+enay1fQnOeJi
   rpZO0Vx4zPIsOrFf0PY4nDDLZ1puHOgJVZqbRQ==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RCZ00BNHBKXVQ90@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 05 Jun 2022 00:48:33 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to
 : cc : subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=D+qYdoVlBiMnKq9ismoNLf7lQSxJkf+vymSvA6DjcYg=;
 b=jFlNaOX9Fo8eYHFGM8KMvt6qoTIGkQwxaxE4o7vZmzyDAQMHjuDQTst/Uo1Y4PGCW10U
 /c8LrpTJ0axTt4hCPv/AXdOkvlDJT791yYEc0MPxMelBcJGhtZmpAVvhl4hSf5DyYwpF
 X3jRgJ9t6HaXqHOY5TqWgji0CQc4PILfrtZSPazZHN7/qGODBLCvkqUU6HvUTy2b+62T
 1MXa074ZKAkhuLUbWKHdPuVuClG77DAjlQaUB20nF1dHT2fecLsDFfhM+X4hc8Xz8opW
 5Dq7KulfkKNYRIbWwi7bskItYhM7B5iY/USvxiw9QWNdAE25XTuUjYBK9ZlN07jO9D4s Hg==
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LNQgmJg+mTUFE8Y9kVFYNkxA7E07vrK6qxlidA1w+AoRLDe7UQdkjgE6jkYtX1NeCvImuAitta/CUbRuZE0929N4C04EM1wHf6OH9k+kAuRfaFEV8IqaObgqQ0mOvOGAou/zNeZOqalbY52lly82DvxN5F+tImslIUWXVaWqAh4wiJIWB7a2KdVupU/jdfYr4MKZHPlM46jpOo6pfVjYEyUu0nDqanXdefsDih+hZYroHp7uuoakGuxXkeZ6OV3w+mgX134zHCtRQOsQmaMuqQ072CVdeOe2VcQVKXQGQcuvyl3ozS8jk9MI2GuOSVtlN1znL5i3yUTnC5eqlqMWCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D+qYdoVlBiMnKq9ismoNLf7lQSxJkf+vymSvA6DjcYg=;
 b=cOSq6DZcHiXIlCLI0Lv2iGiXUsrorMmTdiqalXp1lhMbXtDex6I/Z482CJeN314NSn3/ELydP26evNaeYVZzxD4fMDDHoezlz903wyW4ngm9Sb535fTHPF40lYz2vNo9RPFcJRQTgE7d6yC+jm6rakv8dLo482hc1+3KYGpTpkdGNhnhgUAmuI5qTYS1jotaAlqm3S2B9wTq/JEBXEcf1EWV1CJunerRmjwVM8g7U3EIvMOKjQdXm3b402lTIs9KjsK/E1yIbJC/OHdQSGZwUl7timH61KeqxsqpAmw6nFeF9xPp1ibBgI7QoqXBwildRMBVMhs9CIsCbVC9fcEPMA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D+qYdoVlBiMnKq9ismoNLf7lQSxJkf+vymSvA6DjcYg=;
 b=kc/hO3997TzCGhJdD+4HXKIdhXet3dew1l7lZ3XhpjNeC0HQ3h0myPYl1AQrM7gWz6ni5H2xjBkPslUZg49PHQnEpFagbJJgcj7RzvJbFQuhzW2vktCFdEkEi7Nx/6dZteuzVJfZ0yNMKTe0oifGdnCS1Oodj36T319Jt4HGxco=
To: "heming.zhao@suse.com" <heming.zhao@suse.com>
Thread-topic: [Ocfs2-devel] [PATCH] ocfs2: kill EBUSY from dlmfs_evict_inode
Thread-index: AQHYd5mnvmwlvKFcDUa0uBocuErHM60/B1MAgABYjICAAINHgIAAGYsy
Date: Sun, 5 Jun 2022 00:48:18 +0000
Message-id: <9A2E0C34-2D11-4D33-99B5-2A156C3E5AD0@oracle.com>
References: <20220603223122.43174-1-junxiao.bi@oracle.com>
 <0b6053a0-8417-7da0-78c7-bf23f6fccba3@suse.com>
 <0ff26197-1157-22ee-9399-4cc74ad376c2@oracle.com>
 <6795bb17-10dd-7e9a-462a-22f344b38cee@suse.com>
In-reply-to: <6795bb17-10dd-7e9a-462a-22f344b38cee@suse.com>
Accept-Language: en-US
Content-language: zh-CN
X-MS-Has-Attach:
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
MIME-version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2022 00:48:18.0171 (UTC)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,
 18.0.874 definitions=2022-06-04_06:2022-06-02, 2022-06-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206050001
Cc: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: kill EBUSY from dlmfs_evict_inode
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
From: Junxiao Bi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Junxiao Bi <junxiao.bi@oracle.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 156e2abd-c643-423f-5bf1-08da468d14de
x-ms-traffictypediagnostic: DM6PR10MB3833:EE_
x-oracle-tenancy: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 SLR9YivSEk3kfrm09/q8bbaqynklo914lXbnYMs3/DFI19l1iLWNavRd3BS1mmUxCZHI8FNFTjHsOY0NhxDd4QSJ3AiqtCGGPcNRFGRGE8Z7BfptLYbwuXr9MyPiq0czuPlrhKO4UvmhxmsG3tNmJCB9zo619hwOdCD0N7+0CoJTlEWkVn9XLacxjNJsmDvUk9Tfc6xkozqMpdX66WFIBsgaMmaAkgrLJ6Z6x4XmP8GGGPJdJEBLHIKCx3pu8B2iVJscuU8WW7jPv7RERoqpZIuhOR7ifeabtFVBPDR5z/2n6O2eF1eo+WezMcS/wX0x1y4l49d5KxsFXVbLVjb12gPU2leXyCYLOC9gcocfWhU+ZcpPBGaT9kPG62QOhyNrerWdrIBaC/ddjew0LiEuM9aq9vU44OxQxoVFQP6AwTbpfDgPvr1FJED0blHAURlNOZ8ySe1i+IPRx6CaY2z/2D25u7j/FExd4WrGXWnEt46TPMC/Q+EqKIozv0nzdrKOcb/hLmazUMeW8WZ6/05idBOnS2C5SP8dBIOBiWvBrMwe0IWD/fckYPtOH8NUPq2AmMdRoscAqC8N0eoKRio8csOJbk80Ea1Kn+mjDvYicT4=
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id:
 156e2abd-c643-423f-5bf1-08da468d14de
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname:
 PbyAVg13cjmBywzMPi9Eh/ErwyMvMyI0Fhv+dOOCIzHhhSv83Q0Ba+t5uYTsfXzn5JMBc1cinsJTrc96aUZxdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3833
X-Proofpoint-ORIG-GUID: -2LkYi8DaGkmGQ_3MHyp8_b3OdoAXm2K
X-Proofpoint-GUID: -2LkYi8DaGkmGQ_3MHyp8_b3OdoAXm2K
Reporting-Meta:
 AAHM5eNrUQB3DVUFlFKNZ2Pgmgtf7sUQHUTW05kBGBMKStzQW3wPC3svdRC52LGM
 l3oIiuIDDfOWpcfiBZkbgtMbhUUG6rv+3BpZoLTN/k+14WGeYvM3VOk+o4/AXEaz
 g4tqtBv9qam+Xs8oJByfAhtTBx38dFuTocz8Ff8qMcZtxMLKDfUz49J2fcelIljX
 +XK1OwL7fSVaqOdu7n6NWE8OkHrnJz8CKX9gCL6TTg478XbSIAUD6YgVUhmNfcjR
 pmRzfgx41wOoil42lHguu1hdMlQL5UQj69qBaZkE5OESYbdSXKw2tHPFH+K5Intp
 FyB3NDIr2rNLoehG2IhiRthWT+qnIsq89Uu05drERiHe3eWK25jRkkqh5wH3BtYX
 3NQzf4d3HgqH/W6/9/HlwJ88kK8vVghNtwKU5xwlWNff9ZzN5CkLUZooyFfuqjVe
 nJPQ9deWE7B096SEZULTaSyEvN0WkCM6z3mGa4uNW8wsrHNXxUxxkZ1vdeGwFre3
 LrIfzO/ge648G2ZohWEZN5NmY2ui36y+yFNus+Be7HjU

DQoNCj4g5ZyoIDIwMjLlubQ25pyINOaXpe+8jOS4i+WNiDQ6MTfvvIxoZW1pbmcuemhhb0BzdXNl
LmNvbSDlhpnpgZPvvJoNCj4gDQo+IO+7v09uIDYvNS8yMiAwNjoyNywgSnVueGlhbyBCaSB3cm90
ZToNCj4+PiBPbiA2LzQvMjIgMzoxMCBBTSwgaGVtaW5nLnpoYW9Ac3VzZS5jb20gd3JvdGU6DQo+
Pj4gSGVsbG8gSnVueGlhbywNCj4+PiANCj4+PiBPbiA2LzQvMjIgMDY6MzEsIEp1bnhpYW8gQmkg
dmlhIE9jZnMyLWRldmVsIHdyb3RlOg0KPj4+PiBXaGVuIHVubGluayBhIGRsbWZzLCBmaXJzdCBp
dCB3aWxsIGludm9rZSBkbG1mc191bmxpbmsoKSwgYW5kIHRoZW4gaW52b2tlDQo+Pj4+IGRsbWZz
X2V2aWN0X2lub2RlKCksIHVzZXJfZGxtX2Rlc3Ryb3lfbG9jaygpIGlzIGludm9rZWQgaW4gYm90
aCBwbGFjZXMsDQo+Pj4+IHRoZSBzZWNvbmQgb25lIGZyb20gZGxtZnNfZXZpY3RfaW5vZGUoKSB3
aWxsIGdldCBFQlVTWSBlcnJvciBiZWNhdXNlDQo+Pj4+IFVTRVJfTE9DS19JTl9URUFSRE9XTiBp
cyBhbHJlYWR5IHNldCBpbiBsb2NrcmVzLiBUaGlzIGRvZXNuJ3QgYWZmZWN0DQo+Pj4+IGFueSBm
dW5jdGlvbiwganVzdCB0aGUgZXJyb3IgbG9nIGlzIGFub255aW5nLg0KPj4+PiANCj4+Pj4gU2ln
bmVkLW9mZi1ieTogSnVueGlhbyBCaSA8anVueGlhby5iaUBvcmFjbGUuY29tPg0KPj4+PiAtLS0N
Cj4+Pj4gICBmcy9vY2ZzMi9kbG1mcy9kbG1mcy5jIHwgMTQgKysrKysrKysrKystLS0NCj4+Pj4g
ICAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4+Pj4g
DQo+Pj4+IGRpZmYgLS1naXQgYS9mcy9vY2ZzMi9kbG1mcy9kbG1mcy5jIGIvZnMvb2NmczIvZGxt
ZnMvZGxtZnMuYw0KPj4+PiBpbmRleCBlMzYwNTQzYWQ3ZTcuLmExMjA2MTBkZmY3ZSAxMDA2NDQN
Cj4+Pj4gLS0tIGEvZnMvb2NmczIvZGxtZnMvZGxtZnMuYw0KPj4+PiArKysgYi9mcy9vY2ZzMi9k
bG1mcy9kbG1mcy5jDQo+Pj4+IEBAIC0yOTYsMTcgKzI5NiwyNSBAQCBzdGF0aWMgdm9pZCBkbG1m
c19ldmljdF9pbm9kZShzdHJ1Y3QgaW5vZGUgKmlub2RlKQ0KPj4+PiAgIHsNCj4+Pj4gICAgICAg
aW50IHN0YXR1czsNCj4+Pj4gICAgICAgc3RydWN0IGRsbWZzX2lub2RlX3ByaXZhdGUgKmlwOw0K
Pj4+PiArICAgIHN0cnVjdCB1c2VyX2xvY2tfcmVzICpsb2NrcmVzOw0KPj4+PiArICAgIGludCBk
ZXN0cm95ZWQ7DQo+Pj4+ICAgICAgICAgY2xlYXJfaW5vZGUoaW5vZGUpOw0KPj4+PiAgICAgICAg
IG1sb2coMCwgImlub2RlICVsdVxuIiwgaW5vZGUtPmlfaW5vKTsNCj4+Pj4gICAgICAgICBpcCA9
IERMTUZTX0koaW5vZGUpOw0KPj4+PiArICAgIGxvY2tyZXMgPSAmaXAtPmlwX2xvY2tyZXM7DQo+
Pj4+ICAgICAgICAgaWYgKFNfSVNSRUcoaW5vZGUtPmlfbW9kZSkpIHsNCj4+Pj4gLSAgICAgICAg
c3RhdHVzID0gdXNlcl9kbG1fZGVzdHJveV9sb2NrKCZpcC0+aXBfbG9ja3Jlcyk7DQo+Pj4+IC0g
ICAgICAgIGlmIChzdGF0dXMgPCAwKQ0KPj4+PiAtICAgICAgICAgICAgbWxvZ19lcnJubyhzdGF0
dXMpOw0KPj4+PiArICAgICAgICBzcGluX2xvY2soJmxvY2tyZXMtPmxfbG9jayk7DQo+Pj4+ICsg
ICAgICAgIGRlc3Ryb3llZCA9ICEhKGxvY2tyZXMtPmxfZmxhZ3MgJiBVU0VSX0xPQ0tfSU5fVEVB
UkRPV04pOw0KPj4+PiArICAgICAgICBzcGluX3VubG9jaygmbG9ja3Jlcy0+bF9sb2NrKTsNCj4+
PiANCj4+PiBUaGlzIGFyZWEgY29kZSBkb2VzIHRoZSBzYW1lIHdvcmsgaW4gdXNlcl9kbG1fZGVz
dHJveV9sb2NrKCkuIFdoeSBub3QgdG8gZ2l2ZSBhbm90aGVyDQo+Pj4gZXJybm8gKGUuZyAtRUFH
QUlOKSBmb3IgdXNlcl9kbG1fZGVzdHJveV9sb2NrIHdoZW4gbF9mbGFncyBjb250YWlucyBVU0VS
X0xPQ0tfSU5fVEVBUkRPV04uDQo+Pj4gdGhlbiBjaGFuZ2UgJ2lmIChzdGF0dXMgPCAwKScgdG8g
J2lmIChzdGF0dXMgPCAwICYmIHN0YXR1cyAhPSAtRUFHQUlOKScNCj4+IEkgZG9uJ3QgdGhpbmsg
d2Ugc2hvdWxkIGRvIHRoYXQuIEl0J3MgcmVhc29uYWJsZSBmb3IgdXNlcl9kbG1fZGVzdHJveV9s
b2NrKCkgdG8gcmV0dXJuIEVCVVNZIGluIHRoYXQgY2FzZS4gRUFHQUlOIGlzIGZvciB0aGUgY2Fz
ZSwgeW91IGludm9rZSBpdCBzZWNvbmQgdGltZSB5b3UgbWF5IHN1Y2NlZWQuIFRoYXQncyBub3Qg
dGhlIGNhc2UgaGVyZS4NCj4gDQo+IEkgYWdyZWUgdGhlIEVBR0FJTiBpcyBub3QgZ29vZCwgYnV0
IGRvIHlvdSB0aGluayB0aGUgZXJybm8gaWRlYSBpcyByZWFzb25hYmxlPw0KPiB1c2VyX2RsbV9k
ZXN0cm95X2xvY2sgb25seSBoYXMgdHdvIGNhbGxlcnM6IGRsbWZzX2V2aWN0X2lub2RlICYgZGxt
ZnNfdW5saW5rLg0KPiB0aGUgY29kZSBsb2dpYyBpcyBjbGVhciwgd2UgY2FuIGNob29zZSBhbm90
aGVyIGVycm5vLCBvciBldmVuIGNyZWF0ZSBhIG5ldyBvbmUuDQo+IGl0IGNvc3RzIHRvbyBtdWNo
IHRvIHVzZSBzcGluX2xvY2sgdG8gYXZvaWQgcHJpbnQgYW4gZXJyb3IgbG9nLg0KUmVnYXJkaW5n
IGNvc3QsIHRoZSBzdWdnZXN0ZWQgd2F5IGhhcyBldmVuIGhpZ2hlciBjb3N0LCB0aGUgc3BpbiBs
b2NrIGNhbuKAmXQgYmUgYXZvaWRlZCB1bmxlc3MgeW91IGRvbuKAmXQgYWNjZXNzIHRoZSBsb2Nr
cmVzIGFuZCBhbiBleHRyYSBmdW5jdGlvbiBjYWxsIHdhcyBhbHNvIGFkZGVkLg0KQWN0dWFsbHkg
dGhhdCBmdW5jdGlvbiBzaG91bGRu4oCZdCBiZSBpbnZva2VkIGJlY2F1c2UgaXQgd2FzIGFscmVh
ZHkgaW52b2tlZCBvbmNlIGluIHRoaXMgZmxvdy4gSSBkb27igJl0IHRoaW5rIHdlIHNob3VsZCBj
aGFuZ2UgcmV0dXJuIHZhbHVlIG9mIHRoYXQgZnVuY3Rpb24sIEVCVVNZIGxvb2tzIG1vc3QgcmVh
c29uYWJsZSByZXR1cm4gdmFsdWUgZm9yIG1lLg0KDQpUaGFua3MsDQpKdW54aWFvDQo+IA0KPiBU
aGFua3MsDQo+IEhlbWluZw0KPiANCj4+PiANCj4+Pj4gKyAgICAgICAgaWYgKCFkZXN0cm95ZWQp
IHsNCj4+Pj4gKyAgICAgICAgICAgIHN0YXR1cyA9IHVzZXJfZGxtX2Rlc3Ryb3lfbG9jayhsb2Nr
cmVzKTsNCj4+Pj4gKyAgICAgICAgICAgIGlmIChzdGF0dXMgPCAwKQ0KPj4+PiArICAgICAgICAg
ICAgICAgIG1sb2dfZXJybm8oc3RhdHVzKTsNCj4+Pj4gKyAgICAgICAgfQ0KPj4+PiAgICAgICAg
ICAgaXB1dChpcC0+aXBfcGFyZW50KTsNCj4+Pj4gICAgICAgICAgIGdvdG8gY2xlYXJfZmllbGRz
Ow0KPj4+PiAgICAgICB9DQo+Pj4gDQo+IA0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9z
cy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2Zz
Mi1kZXZlbA==
