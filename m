Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazolkn19013085.outbound.protection.outlook.com [52.103.74.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336A92BEC23
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Apr 2026 03:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.74.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775099340; cv=fail; b=pY8sqqOWK1Qet0DOI+1eY/nXrVX7YbFnphhM0lQcNdYRGehy5jn0IM2ZZ8n+NuV4Z3cNeYnZPgqqe6eSrb4xpoa0/rG0ZB7SVdmzHP6RtUiIZWEJoOZL0ekhe4SBSqdloXTjFCnncWrO8uEedgN5dfymb0hOAeLzV2q+SmMj8oo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775099340; c=relaxed/simple;
	bh=0M+xqBw0iAgor0UCIz9Fk8o5s3bNztVG+B+pFH3P2Zk=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=DyMgtXv5vigY/ELY6BA0JT/+sI1fH0MPKAkDAgquvGNMqjXD/48LM+12c4iWQd8vYm6Kj1gaTOIZBqdZyS0nne+EE1WwLKSs43Rb11c+DWcYFcrtO77ffwsyBoIbxt2109ZeDPlraBylVc2rRv5vpARWbOmt2MNYoOgXfi9ux8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=OkVAFcBT; arc=fail smtp.client-ip=52.103.74.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="OkVAFcBT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QIXACeQ1cgDVu4UcnuGCPU2KzXXgv9AVE781McUUqWf5otEbeZJde3QET4I1XaJIi1oGsjktl9TqkMMTZR+tflghKDRnAWOVURGonzMPTuSYNBN6gbnjR/KXadRCiP3Kl9R25wMdRf45fuhzmIqWeCkEa5qn8Iw0kG2YVG97M5xOOlXHO+wrXWJgDIh6EejHRsSdr/hpDsc9em7SxY2mTkLJlgY0yGsSBdTepJ3jj0h5wiaUkdgquEjnMJYk/XDA4jY0gu9h/Y7WUpGjdYRHO1jttcjf3rXCSLRo+b2jCBJz7ew+vOpduIPEj4v4rqiSPPfy0wkWpn3BvRu7haE/cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bFdVvoExysA2UX6re1FFWjjqu0tRsaelKT+wmxrhy6c=;
 b=qjTDfqrYV2R0OHAKssFGPlg4c/EbKXeZk/EzsNc8TBmPM7iTCP9deAVM0pLz9Ldbc1SOgftI8pSdUMlPW3/7akzhWuEj1aZSKEuOfUzp1ep8rc/HIkM664p3tZSaduUoUfHioZjO6ps7qLgr4HB7+fTzwCkzlIO2zeBAQ3nsMYdzrRcEDNrrG8fLzut/RO6ltCkuG3QpyhpgOzom3jpUG2rGOQ1cf3TSx1sJqctNoY9TwD99XyyA2ZLJ59BDHf+XYRsirts0tNxLJxwgbpaBVmo9Bco1B4T404oswN7d+73kfSAAbAVepd4oC4N4B7sI7S2nxM8Fz0x0A3sXbwXSIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFdVvoExysA2UX6re1FFWjjqu0tRsaelKT+wmxrhy6c=;
 b=OkVAFcBTx1wzyex188ELIPeBtVX1cxcxJ9HHKp1ch1EDBzAwefciz4zeC295QDIf3I4tCDg38XJKrmY8hkTHGhp9LKDoaUcsu5iu7Pze6+GbMQunvpOt+sMSQpIglWX9IUF4PhFtMjerhnVYjKdldgj1S10SpizXTibCtcn4CcgNP07oDI54x848CWo949CmInTfbAVVvYFAsXm815yTfJaO9YwJEXQWLUzCY0MdktubJINPj/m1Dx5sV8owj5zonzp9BJD5CT/NtE+83INGsSpDZrgPOHIZ8B9TPcHfKxpZjjJBj6AMhVtQB4Cgu3sWLig89AMVFLnVz79wI4NOdA==
Received: from JH0PR06MB6632.apcprd06.prod.outlook.com (2603:1096:990:3f::11)
 by SE3PR06MB8260.apcprd06.prod.outlook.com (2603:1096:101:2ed::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Thu, 2 Apr
 2026 03:08:54 +0000
Received: from JH0PR06MB6632.apcprd06.prod.outlook.com
 ([fe80::4fa1:706f:f4e0:6bad]) by JH0PR06MB6632.apcprd06.prod.outlook.com
 ([fe80::4fa1:706f:f4e0:6bad%5]) with mapi id 15.20.9769.015; Thu, 2 Apr 2026
 03:08:53 +0000
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
Thread-Index: AQHcwk2+EclYOp2cPEOXKDHUcTJ6MQ==
Date: Thu, 2 Apr 2026 03:08:53 +0000
Message-ID:
 <JH0PR06MB6632E1E416539AAF508ECAB28951A@JH0PR06MB6632.apcprd06.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: JH0PR06MB6632:EE_|SE3PR06MB8260:EE_
x-ms-office365-filtering-correlation-id: 881e26d5-ce84-461e-bc59-08de90652bfa
x-ms-exchange-slblob-mailprops:
 ZpxNddEKiWwjxFydBHdiBgab8YGVqH/WyGCt2oQWatw07cMBKTIj15J/90SvZWUFC8SFydZblAw/ipZREHI3QuTkdSduEt6ZR4UmHyF81s1dcdrm8CyWiHb6dWsD0VB/fLOIP4us6pssnKLz65zhcfxuqPTplNvf7Wmx/+VFQMRKLGPyh+EvnhkoWUwsfq32FWdwOJ7xqRMGxUgrhCEsJIyr9etmoqyz2w97wNYxdSZFJ60nNezs/84eXoYtyLyYaXfpU490u2b/Nyeildmvcg2ty7D5zWgPb06D4ZvyKdNfUcHvnRZpMeb6V2hJcIrxwXHYcB+F4eCw3Vo1gvs3sQmsykcbIwOU91hvHywStxmDVByIK67oYc15OdmvE083AskHV1eK3VBoTvJ6aGqFX707xPk+KmNqj369h/Nz4JwMAf0h3qRwRNXU5s8iUBrHDLTsN/Wk0tg4WE/wz9M8G/YaDdknYW3OUglJIs+Y2u96+XjUqZ3Vh6+Bzi7HbvRZq50RmnmDc2y8KCXHgWwwjIcZ/iSgvebFwAQvnqvnWFvI04cN6Mjc9EPV4hOrC8nq8FFKFQtDds2l6m5mDXQietlU0bmnQavROMCi+RhLoxmAecXcLrweWNKP2rpU0jOTWJTk3torJwbZcOVvbD7ejZ13nHeg7VNsQm4BSQuiWhVvlyULDZT/oF5xdWnNejBezjSb4i3XwkHmdX+U91uueDv1iY2RSyGM8D1zvv2PAT4Qz9ZE4p4DUg0E2WeHIW1mRGUd9HZuNrgTB1nCUpl4GpOc6B1IjMaMvhtxNIGX3WmlSaY5AW90f0DBQxlQ9OQy3fcUywqvjteckAFUyyCmQg==
x-microsoft-antispam:
 BCL:0;ARA:14566002|15030799006|8060799015|41001999006|31061999003|461199028|8062599012|25031999004|15080799012|19110799012|51005399006|5062599005|37011999003|1602099012|40105399003|102099032|4302099013|26121999003|10035399007|440099028|3412199025|11031999003|12091999003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?68KGJuki07JJDLPu6KhA4LTodPQN4M+G4xUJZiDBtUS7OYoAnmQb2FBOJU?=
 =?iso-8859-1?Q?PIcTe+DHC7l3qk15fZjQstlCOkc2AV0NQF4UYs2VTxrLzh4BuUcMyVMXUV?=
 =?iso-8859-1?Q?3wPS6ojbgfTXSdyyfrRlyNR3cT6ryDq3YuzSdusr8/0syN3Yzg5gImMyZ9?=
 =?iso-8859-1?Q?pkUY4pcmqEu54dYcX7JwdQC6tuVj9GSYELqxaQ+D5b+qSEJEEXDvqWdgwF?=
 =?iso-8859-1?Q?hQKEl5LMemj5UCgDpP+b5H9PleneHhuBLmF26NyHCikQ5naky8d7DNScFh?=
 =?iso-8859-1?Q?fbFPJ7fX8rSthbiLZpPpC0QeYBcBtaid+pmwgMGZNPu1vWMNhtpDnmiouF?=
 =?iso-8859-1?Q?xbxKTfCgxSGDLwyxDdTSp3shmkmsSqVX0owHyT4r613OChufnJRfQph++P?=
 =?iso-8859-1?Q?uv9saX74SsXl57HKzAk/CM3ttoapkROhfPg6aUeb1U/yBNuLnBb/wxkPeO?=
 =?iso-8859-1?Q?p578BKyAN+QBlLIe2vGYXR164kRB3uBHzocxenao/XrZmgtmJ6HLpnf5db?=
 =?iso-8859-1?Q?RDt98sGzTE4FrYQLIAKsCJzjGC6bANghNRsdzvrKzJJhv/Te01dwBlewqO?=
 =?iso-8859-1?Q?kQZkfNPocMdVYkuNHCyadj4SuA/D4h7hAWIek4bYF1I0kM0tTyCosoyjRl?=
 =?iso-8859-1?Q?svHQ9gsYf3MTWE+vZJhK9nE0wxf1bBdeMI+pnQW/bi8+SjYQCodQ/jD+rv?=
 =?iso-8859-1?Q?6pCoR2ymfg1DfSJ9F7nIlx9ArXzDSdlwSDbxkvOgSxrPP092MdlmSg27Oe?=
 =?iso-8859-1?Q?TVfTLbq2BFay7Mxy2vvjGapIjuCJKJbmbeWNSn37Hzp/5SMQA55iObqZ2T?=
 =?iso-8859-1?Q?P2QYBLlnH+y02Cu/7h/xABkiN5Q3OTcwP+cDqsvK5T8yvpx8vdoRpVIjeI?=
 =?iso-8859-1?Q?M5yqunDKRb/xKnGXyKEvrUgnw5BZq2uBlu3OwIbaI+xFuC7HyOc5Z+RbJb?=
 =?iso-8859-1?Q?iIyRHHRP59acCo+LdmW29UktCmpKXun+rL1qD+pyz1tMHNiBuMCKr7SljW?=
 =?iso-8859-1?Q?0LFkRL+cKKSDLa1YTXMGz0mmzQnYInHHccDL/dHjTPggqrMuU+fnXQu9Hn?=
 =?iso-8859-1?Q?cq5FyLXmUmLA16XiAJFwSs1Ctf/CGeGBdVxLgt4AlXPtS85gcyfzst0jaD?=
 =?iso-8859-1?Q?4NN5nIEOjP256d8cdfVjUr2VZ0AvKheoWdnU9MlCnO35jwtK88IX1QjVm6?=
 =?iso-8859-1?Q?/c/DFlWwZtJlN1EKpiXjZ24haaW9j0pbdAX+XFXWHpIa0xaFdUJlvUxQxz?=
 =?iso-8859-1?Q?H1jL9B8m2dPFhqR1Q2EhdjJQBU1PN2TQ13NTsZjfo=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?XtQxRjHqI2u6NHhv4LYo8PCuXKSBKpQZQeiEOhlR+hBtIsxD3mydC+oQuq?=
 =?iso-8859-1?Q?Qqoa3DlLCvSE7ZHp3CkyVs+PnwQc+E6/+g1AFwjoxGCuSLbUP6KCkXCX0Y?=
 =?iso-8859-1?Q?ty1T7EO4g5Z3zxV3bVW+GzkkZq1z3fgvTZHeRP9yrW0A3PoV4j24W3u2bb?=
 =?iso-8859-1?Q?hzM2YUDKE+JCaSndimNVBJuiTVr8TKwcqQsF/ySK6FAZ9BZgs4+VenJAXQ?=
 =?iso-8859-1?Q?l8nyW8l9WS3nHSEhiTQnP9BcQPpcy8ZekgHGIEuZysmvyoN4UD2umkIT2G?=
 =?iso-8859-1?Q?bf+KUrcM/Q/U8iQiu7wkm61s58FADhxCeXcQVEUjYQUTr74GbEKsd0rBiz?=
 =?iso-8859-1?Q?e9V+maWsJBCxjjjNBZO3caj1F9+U6bppfRfShq7dPITbJ557Rlphl+QJvf?=
 =?iso-8859-1?Q?b0NhXkaoPvXWUWjadyGcEFfQs3Gw5v3h4+b/q2pL2y3YJ8ZIpl/276I2Jv?=
 =?iso-8859-1?Q?aCbLFXuFaMVcoZOpFFLAazRwNMczFLn9isyPLpuYD9VOSHkafAm0+dZRSI?=
 =?iso-8859-1?Q?BWYq0BzQ5oYFr1/ejk077+VtaWMAJrgP9LgIpl1lHFHjvaBSGqJ3AQwZId?=
 =?iso-8859-1?Q?z5RafmecTY6Okwv9X1ug3y6IP4SPWXk3fhyVUsTwxGnE9UO6DsIiE1nIq1?=
 =?iso-8859-1?Q?GvjkGg4q2Mp7UtOSy3qUYwAYDyKRdhG8ixX8dKYfuOVNLtW6WWtaMjwAwn?=
 =?iso-8859-1?Q?PIIIoa4hgfreoF5hbqBlaVgARspvofJ1gBlY9uwQ/ssbYPq2NZCnVu2hzJ?=
 =?iso-8859-1?Q?ooAs46K/9uL6LtdMqHoPsTMs37XYucUUsvQa0xPxzQxsgAyECC8i0klByR?=
 =?iso-8859-1?Q?8oiinkja/jftL2tCTD1xOylZgMjETJ2TrA0vXQILCCYPTRta90s7PZHD6o?=
 =?iso-8859-1?Q?DjhwrIKlfOPcNt0EfzDJ4W3rV9x6mi8hWbrGzuuqTfnp1j9mAXnUdxlhhO?=
 =?iso-8859-1?Q?stb2CFONInd3gMH6tHIPJIEpNlbMR1JMxCv8p8BBB3MrQ0pOlzOsgsF4Q+?=
 =?iso-8859-1?Q?h8ifj0awBo9BGeFaHyaKgyzFGRofOsDzjVRYZTCYCTMDT9kY7q8zP8m8sC?=
 =?iso-8859-1?Q?m87D4KslopgaOibaWzLybuDfvjZ2eOpWFGsV63nB+rckBqNx/3BWDxAMxY?=
 =?iso-8859-1?Q?bdWRVy8u0Xo2htn5tgPedwVsVFrKEJAiWiGdA3Xe9iadqZuUDevwwO9LeS?=
 =?iso-8859-1?Q?Z/rUBqOFbfIf8pxnJX3VxmSbntQ3nMIAuZyZ60kE2uILjaSr4FURctWicu?=
 =?iso-8859-1?Q?IS1smsJ5MtEVJhydDHplxmJ9cCFrPyHyM8vxOJn5xj5E+MePyvPieG0tZV?=
 =?iso-8859-1?Q?ZwOeaiBzTRgImTG3Yava3PW5yt+GkYtc51Yx3s6xBHcjFs1CXGi7KwK/fx?=
 =?iso-8859-1?Q?VqaHs0VfmgpZhU/rD6EJp4djMJ6SC3aRe9t7md20JfRhHTZt4ueCXxpRNX?=
 =?iso-8859-1?Q?JD3TvgDyck7PxkepMkceKCKv/274AI0EAW0UmQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 881e26d5-ce84-461e-bc59-08de90652bfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2026 03:08:53.7029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE3PR06MB8260

filemap_fault() may drop the mmap_lock before returning VM_FAULT_RETRY,=0A=
as documented in mm/filemap.c:=0A=
=0A=
  "If our return value has VM_FAULT_RETRY set, it's because the mmap_lock=
=0A=
  may be dropped before doing I/O or by lock_folio_maybe_drop_mmap()."=0A=
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
 fs/ocfs2/mmap.c        |  6 +++---=0A=
 fs/ocfs2/ocfs2_trace.h | 10 ++++------=0A=
 2 files changed, 7 insertions(+), 9 deletions(-)=0A=
=0A=
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c=0A=
index 50e2faf64c..41c08c5a3d 100644=0A=
--- a/fs/ocfs2/mmap.c=0A=
+++ b/fs/ocfs2/mmap.c=0A=
@@ -30,7 +30,7 @@=0A=
 =0A=
 static vm_fault_t ocfs2_fault(struct vm_fault *vmf)=0A=
 {=0A=
-	struct vm_area_struct *vma =3D vmf->vma;=0A=
+	struct inode *inode =3D file_inode(vmf->vma->vm_file);=0A=
 	sigset_t oldset;=0A=
 	vm_fault_t ret;=0A=
 =0A=
@@ -38,8 +38,8 @@ static vm_fault_t ocfs2_fault(struct vm_fault *vmf)=0A=
 	ret =3D filemap_fault(vmf);=0A=
 	ocfs2_unblock_signals(&oldset);=0A=
 =0A=
-	trace_ocfs2_fault(OCFS2_I(vma->vm_file->f_mapping->host)->ip_blkno,=0A=
-			  vma, vmf->page, vmf->pgoff);=0A=
+	trace_ocfs2_fault(OCFS2_I(inode)->ip_blkno,=0A=
+			  vmf->page, vmf->pgoff);=0A=
 	return ret;=0A=
 }=0A=
 =0A=
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h=0A=
index 4b32fb5658..6c2c97a980 100644=0A=
--- a/fs/ocfs2/ocfs2_trace.h=0A=
+++ b/fs/ocfs2/ocfs2_trace.h=0A=
@@ -1246,22 +1246,20 @@ TRACE_EVENT(ocfs2_write_end_inline,=0A=
 =0A=
 TRACE_EVENT(ocfs2_fault,=0A=
 	TP_PROTO(unsigned long long ino,=0A=
-		 void *area, void *page, unsigned long pgoff),=0A=
-	TP_ARGS(ino, area, page, pgoff),=0A=
+		 void *page, unsigned long pgoff),=0A=
+	TP_ARGS(ino, page, pgoff),=0A=
 	TP_STRUCT__entry(=0A=
 		__field(unsigned long long, ino)=0A=
-		__field(void *, area)=0A=
 		__field(void *, page)=0A=
 		__field(unsigned long, pgoff)=0A=
 	),=0A=
 	TP_fast_assign(=0A=
 		__entry->ino =3D ino;=0A=
-		__entry->area =3D area;=0A=
 		__entry->page =3D page;=0A=
 		__entry->pgoff =3D pgoff;=0A=
 	),=0A=
-	TP_printk("%llu %p %p %lu",=0A=
-		  __entry->ino, __entry->area, __entry->page, __entry->pgoff)=0A=
+	TP_printk("%llu %p %lu",=0A=
+		  __entry->ino, __entry->page, __entry->pgoff)=0A=
 );=0A=
 =0A=
 /* End of trace events for fs/ocfs2/mmap.c. */=0A=
-- =0A=
2.53.0=0A=
=0A=
