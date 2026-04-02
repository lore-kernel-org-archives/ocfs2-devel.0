Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazolkn19013082.outbound.protection.outlook.com [52.103.43.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27B8311C27
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Apr 2026 03:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775099434; cv=fail; b=PVlDnmWojVXKxNdfBgO2QclqxM6ct521Izm68R/7gjTKw0DvuaKPPLo0kQQkYMeQLtTNj1BjVKg3OTP9PQexq+IC4+nlAUZ90kBKOtu9fcfCSfRAVjIS/nk5aebAg3eZJFlKGOfwvwcQx8bgBJ0/Jg8P2Ka8kATPoC+TrnIJeQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775099434; c=relaxed/simple;
	bh=D8IgHkCJe3wTSBuXO0UYsnByRLSY2qlmSgLG7h2GQYE=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=S9jgXQqkhUWnbndgErMhQuTGZKl0qeacmndNDqhlDgcssc16T9IUDZBwXfzb/jwowsWzy0lSfo+f+LuWrnPD6cdGY5TqIS+kNLVnGr+XgHL+2FrUIFTsJ4trEahRXsXnNnO1HG8bXxSgaVHCW3t7ANGmwT/EuIvHMPVMz9rzI+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=SVBEb1J7; arc=fail smtp.client-ip=52.103.43.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="SVBEb1J7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KljoWJjG0HSZ3DtpII0XAg+t5RqFzUvisagvAagjdTiqj0PqHUghpKozJbvODBCCRH+QbRDivZnerLhWteiTnvwGWQrSbQZogK5fMkVrJMPueY3W9vxheElVQbP0/BuHqa/4Wp1buAUqEWxM1Vez5KvRzpg4r6LFddm5G65j1mgWxkLuye71jyI8sdOjaR5LIxLyDqo62jsOaOxkSbCOxwrps9rkL6VdECqcOHpr4a5jWmMJcRaKuMuqG3CwQ5EmgFRZWVhPVIxnV612TGm9UHSR5Gj7CAlg8lZPiQBegLwliOTip29aF1BEFKzcg3hd7cpcxf2kFF6qz2mUBHJhxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rfgzwnbW7j7geyC+kDCuRzYoNR8kG75wA6Dn6NUmRqY=;
 b=ioKSwlzywm+Yc5eVKuMCG/4Rhh0jgtZFFgnM+jHxQxLvf38Peb9GSpeKacHV1IW4AefG9AAm69M7I2M4Vd/V/kaNndqGKB6xgjn6qHukwtO76FAukjzw0tRNvWi+tEFfcBivTs5ooG2ifiKaQ3jiUQsLrgdbohEQqFgVbohbxK9pLzTjvtsoVr3eyyXybu6FJ4iShXOvhHWCtLDhD7iFzMTtP2T714mqRSFsF+5TyZRc7Bbbk0xBucuhK+ZXxkTFrzfOcrdUnFBIvOy7azUymQ95QuylvtJjjwoTQ/vpAcCr0gTRHx15Qes1kTmGPVnmtGimn8GGqWKyC/9Zzko8ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rfgzwnbW7j7geyC+kDCuRzYoNR8kG75wA6Dn6NUmRqY=;
 b=SVBEb1J7R68+MxQLYyC+hG6cJASmZYxsFqqLEYZCSuT3SyY40EaVsbE2nl9eyy482y1O0SqZKsS6AMWhdxHioFK9xpHifXLYrOxHpaufc8vPxXGcu4U7FGo/vdh+3j2w0qs6hjvmgecEeoK4CtcugFfg/tCXkaCN0TTzL9bdUaun/h8SeaZkvFDOdnieDr9XLwFofpT2G8UcKfyQVHMhTp+0XafcBVkQeUOT77xXfEIw4ADR572yYtuBEWUrMmTRjHzhOXjSLxe2q3WGGaCYYYpwCTC6VPbl2hM0eE7Sjh83BFmttokBPswfCIg2F4uy75X0SkQoAlkxqRq/YqM8kw==
Received: from JH0PR06MB6632.apcprd06.prod.outlook.com (2603:1096:990:3f::11)
 by TYZPR06MB5734.apcprd06.prod.outlook.com (2603:1096:400:281::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Thu, 2 Apr
 2026 03:10:28 +0000
Received: from JH0PR06MB6632.apcprd06.prod.outlook.com
 ([fe80::4fa1:706f:f4e0:6bad]) by JH0PR06MB6632.apcprd06.prod.outlook.com
 ([fe80::4fa1:706f:f4e0:6bad%5]) with mapi id 15.20.9769.015; Thu, 2 Apr 2026
 03:10:28 +0000
From: tejas bharambe <tejas.bharambe@outlook.com>
To: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
CC: "mark@fasheh.com" <mark@fasheh.com>, "jlbec@evilplan.org"
	<jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com"
	<syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>
Subject: [PATCH v3] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
Thread-Topic: [PATCH v3] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
Thread-Index: AQHcwk4ovnsz2XyP5062ISgM4oDFSA==
Date: Thu, 2 Apr 2026 03:10:28 +0000
Message-ID:
 <JH0PR06MB663236841A642C2D058C1FD28951A@JH0PR06MB6632.apcprd06.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: JH0PR06MB6632:EE_|TYZPR06MB5734:EE_
x-ms-office365-filtering-correlation-id: 47c6e14e-be1d-4285-fb13-08de90656470
x-microsoft-antispam:
 BCL:0;ARA:14566002|8062599012|15030799006|15080799012|41001999006|31061999003|461199028|19110799012|51005399006|5062599005|37011999003|25031999004|8060799015|1602099012|40105399003|26121999003|3412199025|440099028|4302099013|10035399007|102099032|11031999003|12091999003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?iFl0Ngm175dHR/5bIuWTzJOX2RKYwOJhqSi7cN6QsgmRWiplTVbQs11eaz?=
 =?iso-8859-1?Q?4ehQCgNeSZvLJuFrdqZbFjA0Gx+1OHLFZcvAEefxp3mSZcDOdtxyCde660?=
 =?iso-8859-1?Q?zw5zQUsMcw1bWuS7BtzJ3CaTI2tI/98x+t9MmY/YeOwQf63HmTLcZUfHns?=
 =?iso-8859-1?Q?l7KYuO+3Hd4X3amjiL2BeEkSzYsdYWcwpxHhal55cFr6gAPHBwibjz/5Gt?=
 =?iso-8859-1?Q?qjVNkOhvQVL4csG2tpCkgUw+dM9Pzz2/Y3auhR55tDAf7OoCYi8Nz9ZXZz?=
 =?iso-8859-1?Q?uquzpoalaedJS/kRH0sgL01xjh5DN58z7/uNGL84uNr+pxSgVeIIlWIpTV?=
 =?iso-8859-1?Q?DKCgUyjLRYNyxkpgCaMCiuxoAynTSWYYJQ3VmUZlz+nvCXSezIPCs2f6pJ?=
 =?iso-8859-1?Q?U+BLvbKnJoEtb+6JA+JpxIeh+zqByVp1t/BXeWfwRbGJs5oU1sf+QiFVxX?=
 =?iso-8859-1?Q?Yh4NkPuD/N305yYP+vJvWqeIGQZctIdVV6CWz4KBGns8GCRwJRq5WVOeKl?=
 =?iso-8859-1?Q?kdutwFYCr8xCpVNp6d2+SKQ4xBtuOARYregEcQSkB4BHPD6I6ReuMWDWul?=
 =?iso-8859-1?Q?7GfsozNgppGzidxhV/C11LzJSMlHK6lGbvonMEVpUS5qCmlROEJjPN3ggB?=
 =?iso-8859-1?Q?noKW6Zuhu23PA7WOeGIInB3a+G/1Hb6UO7q7uk/vnEGE6nihIdys9xI7BA?=
 =?iso-8859-1?Q?QR0tjp5SX6oHaGJMEeBQe4Rj00W0bTvxxxQbiUnP2UNCQy/LUT2ukXkOaI?=
 =?iso-8859-1?Q?Cb13v0jL35g55DXz8BdOEHmnXGs6jvQve53/B/aqiaKNx6iXn2r+pKsz/y?=
 =?iso-8859-1?Q?b/7UTEuFecsNppRoD918zPu4cAdoLX2gkXcvrRJxB07SAMHYSHvXV4hNh1?=
 =?iso-8859-1?Q?m72PQm3nB/3CiICU0uHnuuE7VFQHI8X8TugYk5tgbjjy3ambv6HBOHqB5+?=
 =?iso-8859-1?Q?S+XwTIVFW2pefKEOAiUpZjajAIPD7/f8W+7mocJce7zG33IWjOE2sWS16W?=
 =?iso-8859-1?Q?T9iP0mknaDlv5Y4A5n4ncEY5U/IFfEddc7mNqyKWycfEKMg1DVSrmIMc8p?=
 =?iso-8859-1?Q?puCEIF27zaz1GMU4gA8WnI+7Dhw5RiR4mzDKF6+EKT1jLMpNVDYlMgf6pU?=
 =?iso-8859-1?Q?3qgQoOW9hv0eTBcAGhyl/0PJyjz1zfdUnj3alEOkXVBV4OUuCe7FYWSLXu?=
 =?iso-8859-1?Q?MOgv8XyIgnE9hcph7pwoKkQRm8jai/ftOK85DIVAdPMe3+sPPdxctU6rcZ?=
 =?iso-8859-1?Q?KRn/jmzNL3VoyRLDFwFQOGEGmXYUSakccB5XbzvtE=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?5ZYEb4TjMvIqbmT7BJKcwSw85taPcNNcgLqVjiw3UU4xd6eZEV6KJzPnbI?=
 =?iso-8859-1?Q?sGS+IDszSgUL6FQ64QCwU4QKchtjbCRZAcHoFeRkTAvSE92fS63Pyk5Crp?=
 =?iso-8859-1?Q?wNi3FHOPmREESLd3sQwQ206OWrzUdtfhH187k69d9eRdrOeAoyNS6S3JB1?=
 =?iso-8859-1?Q?a8MVQd/JNL12ZxX75vXZdSJUoB/i5iGmhLzNVm4S4tOTKRguDqrc1P9qwF?=
 =?iso-8859-1?Q?AI1mGgHe/43UXlo/PW87jSEh8k8siTsk/k6Uc8lqFySh2lNxNQljQBUert?=
 =?iso-8859-1?Q?jVPrxn6R0C4/3nZzyG6AJOhje8SGlABWmHjH+fTDnZjqMwJH2t3E5oWDD+?=
 =?iso-8859-1?Q?w+M05l55/AuqnblgJyttGBhid2lALwcktJy1cCh4AXREf4kAGZvrDuwySA?=
 =?iso-8859-1?Q?nxJ4PXC7co/ub39QrDCQFxKJWsT6/vaqfQyqWN2Ctatr91B04EQosvxwoD?=
 =?iso-8859-1?Q?v8+9kYbFEIqWV0qn1YpIDw6uLSn8duInRE7P/oJQRmZewx6xT8mbjZgk+W?=
 =?iso-8859-1?Q?1ay6G9q2/hNmh/TBLfWpff8pMq5wlk9jYpmhn2ET3+wVQ/1lkao4l1Wl+p?=
 =?iso-8859-1?Q?NXbsGHchjqGYbPDpCgqc+Y5iv2la/nYhJmksmGvV9CPn1duBhDJwWVvrYR?=
 =?iso-8859-1?Q?myIVkfsBfFBaVTjTDZzjRYwCjYXiXLrLb9Gd5koqLhpyynwQ4zWn0ZEDjQ?=
 =?iso-8859-1?Q?twCttlKiwLf7ApXTgQ81gwDxZN+f5LCWQ77TxtOfL2m3qmkrrruQE1lm4i?=
 =?iso-8859-1?Q?6G3uwT4hXhfSEhuvWwo9rcvnOaexyavC9Mgw4s2DmPUsTBeV51W1VvGPVu?=
 =?iso-8859-1?Q?025fMEkoYW4Utc1w4L25obbdR7I0jUd3j69980ALI2+xYXY3HX3uz8QJpf?=
 =?iso-8859-1?Q?xwvfoSvZROblRHKZTFWdH7k8akMDceGzfO84V2tarQyUDgEnyr+60iWt+d?=
 =?iso-8859-1?Q?CmMA6dJjV/skmAUIFRdx7XwcuMtjPQAM/JyVoiDu8r07YN0bchya8ygNO+?=
 =?iso-8859-1?Q?GeSIgROMPwd745Kzgt0TGaS8ONWUrooAhzpbFSIR+7DZyW24JPBcenHwvr?=
 =?iso-8859-1?Q?qAYvpIOQsPjPbo0kisO/VCo+VNfOCaz1xaBdJFmXPB2XRBKajQI4NWWRe8?=
 =?iso-8859-1?Q?xoKWRWc5uywh/1XWY9Nqo6CVTiVnJPjGO4WYM2j+HkoJqh6jpq3/fnxZu6?=
 =?iso-8859-1?Q?VbkLQxZBQvkxe2Sh7kMtpywO/Jjc7+I3k+cY/moEY/bNLBgFGx+5/06K+D?=
 =?iso-8859-1?Q?dL3qEt1f4fi+Sbbu5q8MhK1u7///udtRPRAJ40T3x0mn8X0Lu5+PAYMYpr?=
 =?iso-8859-1?Q?B78V88otjaJ0wN27mdjgdeP90UySwgSMa4fbfgMt2X3pippvmvlvnZ53I4?=
 =?iso-8859-1?Q?XYdea7BYQ8oHiqn4L4tnbcCv/Ot/VNCymA9npr/tPL1ADseKrmkubopO/8?=
 =?iso-8859-1?Q?NoBwJC5XJGqWP5FTcyqAL6VSjLS1rmKTdG/g1Q=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: JH0PR06MB6632.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 47c6e14e-be1d-4285-fb13-08de90656470
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2026 03:10:28.4186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB5734

filemap_fault() may drop the mmap_lock before returning VM_FAULT_RETRY,=0A=
as documented in mm/filemap.c:=0A=
=0A=
=A0 "If our return value has VM_FAULT_RETRY set, it's because the mmap_lock=
=0A=
=A0 may be dropped before doing I/O or by lock_folio_maybe_drop_mmap()."=0A=
=0A=
When this happens, a concurrent munmap() can call remove_vma() and free=0A=
the vm_area_struct via RCU. The saved 'vma' pointer in ocfs2_fault() then=
=0A=
becomes a dangling pointer, and the subsequent trace_ocfs2_fault() call=0A=
dereferences it -- a use-after-free.=0A=
=0A=
Fix this by saving the inode reference before calling filemap_fault(),=0A=
and removing vma from the trace event. The inode remains valid across=0A=
the lock drop since the file is still open, so the trace can fire in=0A=
all cases without dereferencing the potentially freed vma.=0A=
=0A=
Reported-by: syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com=0A=
Closes: https://syzkaller.appspot.com/bug?extid=3Da49010a0e8fcdeea075f=0A=
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>=0A=
Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>=0A=
---=0A=
=A0fs/ocfs2/mmap.c =A0 =A0 =A0 =A0| =A06 +++---=0A=
=A0fs/ocfs2/ocfs2_trace.h | 10 ++++------=0A=
=A02 files changed, 7 insertions(+), 9 deletions(-)=0A=
=0A=
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c=0A=
index 50e2faf64c..41c08c5a3d 100644=0A=
--- a/fs/ocfs2/mmap.c=0A=
+++ b/fs/ocfs2/mmap.c=0A=
@@ -30,7 +30,7 @@=0A=
=A0=0A=
=A0static vm_fault_t ocfs2_fault(struct vm_fault *vmf)=0A=
=A0{=0A=
-	struct vm_area_struct *vma =3D vmf->vma;=0A=
+	struct inode *inode =3D file_inode(vmf->vma->vm_file);=0A=
=A0	sigset_t oldset;=0A=
=A0	vm_fault_t ret;=0A=
=A0=0A=
@@ -38,8 +38,8 @@ static vm_fault_t ocfs2_fault(struct vm_fault *vmf)=0A=
=A0	ret =3D filemap_fault(vmf);=0A=
=A0	ocfs2_unblock_signals(&oldset);=0A=
=A0=0A=
-	trace_ocfs2_fault(OCFS2_I(vma->vm_file->f_mapping->host)->ip_blkno,=0A=
- =A0 =A0 vma, vmf->page, vmf->pgoff);=0A=
+	trace_ocfs2_fault(OCFS2_I(inode)->ip_blkno,=0A=
+ =A0 =A0 vmf->page, vmf->pgoff);=0A=
=A0	return ret;=0A=
=A0}=0A=
=A0=0A=
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h=0A=
index 4b32fb5658..6c2c97a980 100644=0A=
--- a/fs/ocfs2/ocfs2_trace.h=0A=
+++ b/fs/ocfs2/ocfs2_trace.h=0A=
@@ -1246,22 +1246,20 @@ TRACE_EVENT(ocfs2_write_end_inline,=0A=
=A0=0A=
=A0TRACE_EVENT(ocfs2_fault,=0A=
=A0	TP_PROTO(unsigned long long ino,=0A=
- =A0 void *area, void *page, unsigned long pgoff),=0A=
-	TP_ARGS(ino, area, page, pgoff),=0A=
+ =A0 void *page, unsigned long pgoff),=0A=
+	TP_ARGS(ino, page, pgoff),=0A=
=A0	TP_STRUCT__entry(=0A=
=A0 =A0__field(unsigned long long, ino)=0A=
- =A0__field(void *, area)=0A=
=A0 =A0__field(void *, page)=0A=
=A0 =A0__field(unsigned long, pgoff)=0A=
=A0	),=0A=
=A0	TP_fast_assign(=0A=
=A0 =A0__entry->ino =3D ino;=0A=
- =A0__entry->area =3D area;=0A=
=A0 =A0__entry->page =3D page;=0A=
=A0 =A0__entry->pgoff =3D pgoff;=0A=
=A0	),=0A=
-	TP_printk("%llu %p %p %lu",=0A=
- =A0 =A0__entry->ino, __entry->area, __entry->page, __entry->pgoff)=0A=
+	TP_printk("%llu %p %lu",=0A=
+ =A0 =A0__entry->ino, __entry->page, __entry->pgoff)=0A=
=A0);=0A=
=A0=0A=
=A0/* End of trace events for fs/ocfs2/mmap.c. */=0A=
--=0A=
2.53.0=0A=
=0A=
