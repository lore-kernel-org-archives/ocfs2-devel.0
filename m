Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazolkn19013075.outbound.protection.outlook.com [52.103.74.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3939301493
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Apr 2026 04:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.74.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775017248; cv=fail; b=KgMuzXsQj1ICKZGHnO2XkZWaxdu1ww9GaME442DMXDMcka5VRjAeqDzdtgiGtfFI9Xyx+zyv4YRt/WR9WrKgYbLGgMaW5M+vFUt1PAc8TaSPnSZ+8VETux4OIBEHbZUqIZhuTpovhPUmZH1Hom0DLC29HEf+Si/Zj32fppP9fxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775017248; c=relaxed/simple;
	bh=ieOQzvne2cqXvGWirTF22APK/R46Pld/pdgBHgYrP1k=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ufo7WVu0nRfPa7vH1qybSpfGIjKTptoyS9A1aT4gTXNipgnPCq3fH4QaltoIJIqPRxLSHDuFU0jnt96RUh5WPPUPC/4wsoZ02HlFDV0oyOqOPHCwpQvqiuCeHZOqkt+S8JZF710sZBsatVuXNc3WfmtnuvFnH0/a86yje/PLOsY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=uLW3Sglm; arc=fail smtp.client-ip=52.103.74.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="uLW3Sglm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tYbIiT/K5q0kIfS/oF86mtDAt2Ud4/3sI+tiU+py4YZPtlWngatl7oyLUe5zOL/m4QxMM95/xr28q7uc5LcZ16iy4tsEo2wM9xFZshP1HUjgL1Js1Wur0nV0+oONMPtLY/9bJ23YaKTWKCUKyFA56L2gR4wQ/0EYVTdcBiaCEKn6VXba5JIalXWsN/E2AkvBxJ4CQpe0Cof/f5Kb+bU2Iur2lA0MTF+Vx0EBkzm4Pr8nWaC/OEN0FDV9pjJXrfmm0C5p4CBeG1lyv56uHFCUj8TtwEO1fcFE7bqx31iTghzaT+zbSuAFbYNJwpFjKEQKCB5cwIfmki1AiOSFNhQiGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c5/vQJY0vXKKWHwjBN6k/i3OVZEzETHVjE0zX+ESQcY=;
 b=rViSuJ+WKMWLfoAKEigd1WdXUj5nur91reQE5sgL3zpG0xOMboRDVzpSdBYoJcDaaxDxI9mVsZPJo+pLz4auEndkuBdxNN/Mvb4yXUPPBL+YNVxuQcrfoMWLudBvqna9Ua7gV29kqR0kmnD3bkzJc/OItaL3hjdJKkH/KXz6klgjTHyQGhgc5jzoWYORil1gyJjWQmNoiCqKujeN/HkLR5pF6Fpvv75cVA2c0Tjub5GcHWRHHKyh7uOmaF2EpED8ueau0ZuA4yQq1BQC45mBW9Izsnk04OHpCINixjEx5w2ldyvK9no0X2NNUdiExNpdkaaETjW3dCI65x6hHzpuFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c5/vQJY0vXKKWHwjBN6k/i3OVZEzETHVjE0zX+ESQcY=;
 b=uLW3SglmsjR5xU+yC6ojI54Es4uFM1Edd1KYXQ9OxwPz4zoca5zR5RGet2sSeXOlihVfQvS3JqdPrac6eTD9ljd47UMQXYv8sEJGDt2vqYU/fWJPW7bIDnj5u2UV8HUQdBaTJYjbo5XXdUCCnyAaIwwNDHwXuYAP5LvbusFRQtypOGSKigNCIQNTN1YHLo6doQIaZhgDv0S/DDEr9qJ0bdo9nRNaHqHxIPdzBUjJtV9PjvfCoRi0C4zGkLcU0i0qyhcUdDdRTDCtAtqY8GFfpxdsP/VleCu12O88npkVvfjXZL+/Hs/X8+MamtCHoZ1tWTH8Wqk4V2wSPT+RML7iOw==
Received: from JH0PR06MB6632.apcprd06.prod.outlook.com (2603:1096:990:3f::11)
 by SEZPR06MB6038.apcprd06.prod.outlook.com (2603:1096:101:e7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 1 Apr
 2026 04:20:42 +0000
Received: from JH0PR06MB6632.apcprd06.prod.outlook.com
 ([fe80::4fa1:706f:f4e0:6bad]) by JH0PR06MB6632.apcprd06.prod.outlook.com
 ([fe80::4fa1:706f:f4e0:6bad%5]) with mapi id 15.20.9769.015; Wed, 1 Apr 2026
 04:20:40 +0000
From: tejas bharambe <tejas.bharambe@outlook.com>
To: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
CC: "mark@fasheh.com" <mark@fasheh.com>, "jlbec@evilplan.org"
	<jlbec@evilplan.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
	"syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com"
	<syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>, Joseph Qi
	<joseph.qi@linux.alibaba.com>
Subject: [PATCH v2] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
Thread-Topic: [PATCH v2] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
Thread-Index: AQHcwY58FbmOqLOOb02Bm5GmLd0FEQ==
Date: Wed, 1 Apr 2026 04:20:40 +0000
Message-ID:
 <JH0PR06MB66325344CF84BBC38B2973C38950A@JH0PR06MB6632.apcprd06.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: JH0PR06MB6632:EE_|SEZPR06MB6038:EE_
x-ms-office365-filtering-correlation-id: 9c3cf0f9-e26c-4d8a-1ffc-08de8fa608b4
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199028|5062599005|41001999006|8060799015|15080799012|15030799006|8062599012|31061999003|25031999004|51005399006|19110799012|10035399007|440099028|4302099013|3412199025|11031999003|12091999003|26121999003|102099032|1602099012|40105399003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?jNFkDXABsWN3+v+NT3WDhUjJOvSyeuqUlBNpBH3rqR+tBDPLDI6x6wJr9K?=
 =?iso-8859-1?Q?niolt6sbXHy1stSnCBUwYtDyg5HhpNo7G80hDEa4kL1mOnsJXOpQDRo6EM?=
 =?iso-8859-1?Q?3ChsPqJlfKw8bd1I+HDf3FBPYoyY/xi1bHSX0xWXROG5vnuO2FCymXF7mS?=
 =?iso-8859-1?Q?tBnowCbFAq5sEOQg+jMqDXiYjxh5V34pqAivybbD0RP6f7bKfkBjWDeMHi?=
 =?iso-8859-1?Q?pqXdmPHUdkrQYHQB2s1R98ozUb7/gIiEFenfiFZ3CBobee7yY1Z5igg71h?=
 =?iso-8859-1?Q?2XJNrYZ3QfSXhW/SzKB2B+VKfS4NxknUi7CdpLAb1536wZ1TRkscOsn79U?=
 =?iso-8859-1?Q?Yu5Rg4dCbzkFeIv7I+KW82Y6dRqeTPrBRiVqjkf0aNH+faAXDebmGziRWR?=
 =?iso-8859-1?Q?tRjeNf94fQWn6vjK5BRG3qdKaO2FDYbLBke1nJKRL7wVE3E1z26ALKBTTU?=
 =?iso-8859-1?Q?LNKRNfw32XOZID6SXjzFRLKCB0yLl+SX7AVSU+D07iy3rB5kpf05H3Rixf?=
 =?iso-8859-1?Q?60sRUTnmwV91XhmZSxDDhjnroQNpbsxQUCcyerED6XFMY26jb65ni/7C0p?=
 =?iso-8859-1?Q?qbz+MidM79xBX49/tXzTbOinVt+rKvVs5yWWr0j/S6EmE9+s1SFuj/b9E5?=
 =?iso-8859-1?Q?j34QTFYN2iq8v2XQ5tzhSKr8lStFA1dfBNdNz8TvIBanUCTa27OYVShKOA?=
 =?iso-8859-1?Q?eDscXK0700AdE2TJejxLHv7hbZoo8wW4i24X+28cg0re7U7UCRnh7UBeXE?=
 =?iso-8859-1?Q?jPCzx/LtvxAS8eqpMZh2RWRDGHxAzR6gUvTZSjQ+eetSPB3c45HgbajOHe?=
 =?iso-8859-1?Q?v1MJ1nh3ND08rmquEJ87LNOLHxXxNt2NpD7ZaGyUv58ZwAUYRB69LYRCvD?=
 =?iso-8859-1?Q?C2jBx0eyjoJgkuoRCOpeBuYEiN9cqo9JWnbGlXQSsO0MfcpjZNyAaNhUa5?=
 =?iso-8859-1?Q?vJMijzyXSblTJ63XayU+GogodUV4UAqB+m9rwfVKxLDmPy6vlkLLoKlICW?=
 =?iso-8859-1?Q?/6f1NPV9dFMz4YiW//E55zoyN7RnR5JvbeJ0pvY03afrQtidJFjY3g0txr?=
 =?iso-8859-1?Q?lYwvCPm88UOJ/jr7fU27jG1yLQyYmh4zMofCQytigAOhB/fb6roLsuqoo1?=
 =?iso-8859-1?Q?unPjppFxrW7TSlxZ1suq681BmbZMLO40eWmzBXJYHkEgg22mIMgtf+FrJo?=
 =?iso-8859-1?Q?U5c3WKFcH9XXINOpQ2mIHDBg1vIf3PvQlDv+j6nnjDaKbnLYu5oZbEKfnH?=
 =?iso-8859-1?Q?M4hj9hGqPdzUQXONLO6w=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?3Z3WFDrm9dCRxGpk7V+DuZaVM6MG9u5h+QJAll8BnKLcfziP4F6eDPdvqh?=
 =?iso-8859-1?Q?ZV+EhNmUtsCnZ0CrZF11qdRwwsicT/88HmmbiSEPDms+YdF+hRn2eVkSWx?=
 =?iso-8859-1?Q?VJY53T85zNv4ryT14IX2lvYRL0Ao5A15/sEFb5JFs6gypxmb2tKebPiVVw?=
 =?iso-8859-1?Q?qLSsYnNnUechvjd8rHagFk6zdustU5Tz8Hjq/N+ktZPJJnHDWvsej9PSxN?=
 =?iso-8859-1?Q?UMk9MC59rzJW5W38P54mtrd7yH0/NvZFceLCbvCpzLObkBOlk1BtTMqf1J?=
 =?iso-8859-1?Q?IeFtTDfpRjy/KSwn/EBQfihie6e00TtRha5LaBpmUInUjcJkcBu9Dmx7gw?=
 =?iso-8859-1?Q?uokbLp/EdEWAhfNYnFM5l4Z1ExUGqT+wV2FO02PeLDKO8599DN6LR9t6fN?=
 =?iso-8859-1?Q?20bK/hsHmXl21Pl/SWP+4+y7EztBwsNTTmCaSfJrWUK9x5NvsSpcokQidM?=
 =?iso-8859-1?Q?KVtMnYZWza4oUOz6ECgJpSTFXzzRbhIxCm+FizhaIFQueewxi+HOqAI8fH?=
 =?iso-8859-1?Q?8Dn5pbVGzjWPu+JJHzyC0o2lHKvyWS8SvfniPJgF6BtbyscaNxTgpxGOsN?=
 =?iso-8859-1?Q?h5D75cLPo56zScMRMXmEtYQ2rezWn3Ikzr6peBnKtTTU3LsO+2/Fow2lUR?=
 =?iso-8859-1?Q?FUI8ZtjmTeg6C+aIP3FqLNlvo4AYQLQoSdso9pKbN5AH3ZWWH/Szk3/0fY?=
 =?iso-8859-1?Q?pccOEx0obTGNtGn/8h+5ZXRgCQHoQ2I/8q5MwMwxw8SzUR1HHyjMcGtz9/?=
 =?iso-8859-1?Q?QQLyx/d11hzKKCRKx5bmfDkkSKTNJpTrWawi8622Y+KnLVcRlxzlL/3J8k?=
 =?iso-8859-1?Q?spmcQ4vFgmqcSrelNNw2xSqlHGHy9CBWbYFe3Kr9ftdhdBNCtMD05UrXqO?=
 =?iso-8859-1?Q?Ys/FiGIU0sctHmNWyWVX8qIiybCrEjTSvteacNPIOOJWvf/8WlFPXt4Vj5?=
 =?iso-8859-1?Q?LxNZTJ72G7ckWb/a5juGvkZUHY9IFyqEu1KbZ7a6qTpBfQPuA8cPLvciKa?=
 =?iso-8859-1?Q?OTbCVen4z7/4d1HK3gKo1wur4YC+gvznnHQOOU5ggH1SHaIpcb3ceRt28p?=
 =?iso-8859-1?Q?GzKecASkv56KHO3qq/oP4uySWbxi6L7gmmOIksuOVuqHgm+hWA1kbxzut3?=
 =?iso-8859-1?Q?4B4Z3DunBLwNxozkvXk3pWyI8DF3+H9hfAUYMUe0QSLmKwe2i5QHwdNR/5?=
 =?iso-8859-1?Q?xJb6zicMq0JJEZ80GAyzK1Etzaop5ycyjS4gKtSAFuOskdpJ0/QTBoWC7a?=
 =?iso-8859-1?Q?CwtmJMTpmPskUXSSVBlfCwYiHWxbu3KJcjuXQFKvmjTjDFWt0cA+gwiql/?=
 =?iso-8859-1?Q?p5U14/WKbAj1DCwbAaEcKcVZImQjCNCk1mfM7HE4Bq4tZRLqRiPk5cCzDe?=
 =?iso-8859-1?Q?HqIgw4wMAEjLq/eHbUPETq4eV4TnpXLI7iy0CPSRx7vOuqzC87HtQCFxQC?=
 =?iso-8859-1?Q?HoS8WDYtOjEExDxgBmy/K5OQanc9kh3ukryqEw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c3cf0f9-e26c-4d8a-1ffc-08de8fa608b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2026 04:20:40.6359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB6038

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
 fs/ocfs2/mmap.c        |  4 ++--=0A=
 fs/ocfs2/ocfs2_trace.h | 10 ++++------=0A=
 2 files changed, 6 insertions(+), 8 deletions(-)=0A=
=0A=
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c=0A=
index 50e2faf64c..7a4be91d6a 100644=0A=
--- a/fs/ocfs2/mmap.c=0A=
+++ b/fs/ocfs2/mmap.c=0A=
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
2.53.0=
