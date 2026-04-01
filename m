Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazolkn19012053.outbound.protection.outlook.com [52.103.66.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376283C9ED6
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Apr 2026 12:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.66.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775048120; cv=fail; b=RjVv2p2JoaCACyYwH6yPa5pnsDdG4XI5GxaVT5Juz1pdBCVTX3tQPrnnonOai9EHEQXoC2bes7tvbwQLUD7/siTOZXHaxRMyuLZNcVBGQ3hP5ARd0ryarZDBaMK+/eRyv8VQkffLQBs6x8UC5B54NSJ+jPOaBUca5e6nijoKS5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775048120; c=relaxed/simple;
	bh=ui45o5IgwMRQcJIHiVvkWwypGbpVZ7SRZHfYXNJdZIQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n2cEADH6zttMjkSbVr4mCS/w/752KsUei40JwzmMSd6JAUbOqQeN+OFO+ZN2ada3OqHbR+MvvhGK3fTZrHLx99KYBUpiXnNKswM994AytyPlLLGgjuGNSJeezBkcl6AvofCkBb5PkL0Phpg7PPoyM3CcRKWdTQdBIyGelV3tkiE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=A6gEg16x; arc=fail smtp.client-ip=52.103.66.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="A6gEg16x"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GHyY1ZJyFLHyZhGWqmmqOZUhumdM3zqEEgzpyLdAlm4lliMUJO7vSOTrt/jc3x0ZZdCj8qg7GV40VeM28Cy1lIcGt84ZAYcTqjRKx/D6qFFFFP3Ju2Dp80TPwap70lVvtrHz5utyfi5zHZ7MMr0Izlw/yodIOlyMNXWTUpXGoojw/MNIXk7E1V74celTxCvEh+/+TDI6kCh6/oVINprPGEzGrejTTeQDW7aq2ZqJ6L8yFyPi8cH4vaynDVL+rxaURBf3wdkccmWufhRSHSO1jxNbDUMx4A8I6P552G4KQQ6YXe0wnmCuzJCzNTsjlsT6DNaDSAABGSccTSvFQpLiAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ioxIhBlPYwBA+vwhOkwtwV3ZpOutik3Cw1FqRaT4XiE=;
 b=a0JxFRHobmmRt5V6Pl1LF0E6n04igjhqLkQrHzqCbU+9VmTj85O85T+wMWuYLbihqxXg26EuH79nX+3xYyA07rmYQrpV3qnMl/fPbRFTvB29VNHdv3/dMYYprAxAcLw+cBzj2Tvenl0hzP1p5vibM+ySwkwwshJifI/3Vim4fnlwe36MKidm2xbvrC78UtWqCyZjsrs5EEAxuwN5RY2sqHqrXBGXVxnNRqw0qoIRXqmJYdJXI9Q2o5e38YaF/J+q1wg1bqhoatJPmYLBTYURPfEHAeJiIS+ka0JqzUmu3B4nYOvhByZvTl4HYg1kJoqGPDtlaB1ka2PgRWKgJYWWLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ioxIhBlPYwBA+vwhOkwtwV3ZpOutik3Cw1FqRaT4XiE=;
 b=A6gEg16xc+mHtUPXoPgqoG0+nWEPgMwa4Dr+RPjJZ5W3f+Umv42rxyDk/B8zMzKjAN60EE+xQddrxU9aRFN4UFyyH3il7zoXS/MwanVuMNUUJRV56suAn3Xnxakdmk0KvlDFGzR8KLVpthQOgwrDdmHq8D67ztCNw8+ELsh6Cu+aPBRszB1Hf0HrCWnUrViGELXx1r/I0NOQh0S+ib/8wXk28O6hhgdF2NOcgMdMwQSWDCy76IuMcurtjQdYDbeSOsmX3cujynVHu6JWYYOVW14y38rsJoXyZy355T3BNvkcCtv/gBR3pMSQjSlQ+jW26FU7VchJ7/nV91SY6JtFDg==
Received: from JH0PR06MB6632.apcprd06.prod.outlook.com (2603:1096:990:3f::11)
 by OSNPR06MB8138.apcprd06.prod.outlook.com (2603:1096:604:45b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.16; Wed, 1 Apr
 2026 12:55:15 +0000
Received: from JH0PR06MB6632.apcprd06.prod.outlook.com
 ([fe80::4fa1:706f:f4e0:6bad]) by JH0PR06MB6632.apcprd06.prod.outlook.com
 ([fe80::4fa1:706f:f4e0:6bad%5]) with mapi id 15.20.9769.015; Wed, 1 Apr 2026
 12:55:14 +0000
From: tejas bharambe <tejas.bharambe@outlook.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
CC: "mark@fasheh.com" <mark@fasheh.com>, "jlbec@evilplan.org"
	<jlbec@evilplan.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
	"syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com"
	<syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>,
	"ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
Subject: Re: [PATCH v3] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
Thread-Topic: [PATCH v3] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
Thread-Index: AQHcwdbIuF4xtupvUUW01Kk7+DlUcA==
Date: Wed, 1 Apr 2026 12:55:14 +0000
Message-ID:
 <JH0PR06MB66324761413DC90A93CDAC718950A@JH0PR06MB6632.apcprd06.prod.outlook.com>
References:
 <JH0PR06MB66325344CF84BBC38B2973C38950A@JH0PR06MB6632.apcprd06.prod.outlook.com>
 <46416617-8956-4e60-8e38-2d3337adef64@linux.alibaba.com>
In-Reply-To: <46416617-8956-4e60-8e38-2d3337adef64@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: JH0PR06MB6632:EE_|OSNPR06MB8138:EE_
x-ms-office365-filtering-correlation-id: 8c92adb0-af42-4a32-806f-08de8fedeafa
x-ms-exchange-slblob-mailprops:
 F478AcySxEfD/A1IeZA0573Y5of9rszretrLmbJ7yLKrIIoSbpf3Z58UqxaCgE71PZJFcP+zCVJWVs5nrULilyFcDv6YyVo7rjpplxwZz2cqSv4igu0S0LS9wCg1aWYKjibkVkMcd4yw3EChXmPcZb+g7EnJq5U7jr9wUq0IRi3U8RXcHsOH4zK03zQZJFRMLYvJGLy9vYMmZbesGu6tmf9WVDsTjaLmjQOpiDFunEbHqmiCmGPIfnZaQOj6DXUd0K/k98fEwJIsH2BkWaA/OfEwLX2GYq3R4vuW1EX1Xwxtw0RM9nPFfWEtLKtad0KEkqKvZD0AmTm9lwikarnzTUN/f6Qa6fjRJaN30qjuHV10J4qBXiPgaQxAyiVWfr2xaDWOEJMKePZ9Chght61FaLoMvI7ZdugLBY4mmDZVeFKbzWGcd5Gxzcomd99FVPJlq34XKNJ0wnolGExRDhwzp7GzlAKwVuPQ0pDfKRthPABzAAO1z6HNmM0InSq5gG1PXo7XyE7/sN9v5hEwZs9rOdHhM4V6ijHkZatHAr3IOI++cPsYSku+bBMuMVlkKlYGz2ppcLCSr8cy0KBCVbMAhKJw2F3mKqss9Lh4wdQIKMVXM56mXWft/ohIQ13duiPZd/OknTmKBDuweusADxJnlIhP9MeDF5y7r7SZGFV35bq/20iXpc5ohK4kuV0omfsngireuVzq9RddIjrQYeYGdKm43rmfpCRLtOlWxIzvT8b6/9oOrGE79kRqjJ1jftAa5Co2+5jHoWzcTlP39mpAxmmUqB/U3yS5UwovFd00yuxD7pTlX8qwipdMr+KDY+US9O2t/Wo0dICQhcKhX7mmbG1w34DFP5F5aSYQjXW/ivs=
x-microsoft-antispam:
 BCL:0;ARA:14566002|19110799012|37011999003|31061999003|25031999004|41001999006|15080799012|15030799006|8062599012|8060799015|461199028|51005399006|10035399007|440099028|4302099013|3412199025|12091999003|11031999003|26121999003|102099032|1602099012|40105399003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?gOzXYTIePT2ZsLFRvPYRahq/O5aPbefc8y1ZEyA7Kk39SZq1oL3tgO7i6m?=
 =?iso-8859-1?Q?F+HGwsVY4ZRePbkxdxG6UfOn8hE6rHLW0FL63wIB1VKkS+xPdSJUJelJ1Z?=
 =?iso-8859-1?Q?ESoIlbUfL1StPLh7e6IZfy6GutE6ef2yk8bGaoT3QO4ZmciKPPCtNr6qcg?=
 =?iso-8859-1?Q?aMhzi/wMw4bznZzWZcrwJjcX7hEAOv/00+jg+QIKDq/Zd4srDhnuk4/BK8?=
 =?iso-8859-1?Q?yXPtDi4qsEGXF8wVCht7q442UZcEM268Zzq3EpY5rUm0bSZHrvKnACSlvg?=
 =?iso-8859-1?Q?8etsTlv1UFFOX9aetmmRvyISIV1+Y5SOxKbAzntH1BOexSmfw/EP0m7ieP?=
 =?iso-8859-1?Q?44yBkazvnw/mSoW52+FNIAXL9mpQA0h/vOGauykT3wRH72bmSkMz7IWpDt?=
 =?iso-8859-1?Q?Nj0SIdM1YIB98mcxfQJE5Arx6tJPi45hETSieMT4MM8hOY1JuH8+NI4TJi?=
 =?iso-8859-1?Q?y/Kjwo4RtnMEo4YipZSKjUEKHnngDkEv0aYT6WbSTObvk7xayq9dXlluO8?=
 =?iso-8859-1?Q?9PWBS3Rh5ysBRiTsVdu99kUULeUuXXPMLdrAz//HaTTMGcAcOeypdvLCy5?=
 =?iso-8859-1?Q?xVRzTvYWxtOsSVtc0pBfK74PA0ltZNlfpjBwn7ti1pPKjt+DnliLYjraQU?=
 =?iso-8859-1?Q?3PR+K7boQps3VwlyCaMrYbchBIy0hUmlJi1ZQfrE3qEU0gTvOCZIVoA6qo?=
 =?iso-8859-1?Q?cMvuL5Iq/xFM/oUsbiWuVGYs1YOP5VGBnp+RLRuu5ruQJCWq1aH2DsFT5u?=
 =?iso-8859-1?Q?vw1ZdHksXZOwYQu7LFgxWcHMUbR01/5tD6ytP4idk8bDV409L0tl32WVTp?=
 =?iso-8859-1?Q?P/rMOIHKAgZE6KTqGYOdEn+9ubSuMW76e2d4G0siQtj0ognoYrfXrRVnmO?=
 =?iso-8859-1?Q?cdLBl1hlq0nkpIXGXtNjKn5ddiHk67Dn++HJXwka//T4OJj/eRcOKdeXAp?=
 =?iso-8859-1?Q?PkiYemk9WsqlTfW/DLQXrNdg0aF3ZaJyormfyzZ/mN82Gqgz5MwdGYAJS3?=
 =?iso-8859-1?Q?lfHyh45Ir0NEvVrxRrxfa4ihwbXR5Xo/rlUuS+iuHLgiyr8xyaq98eoRYE?=
 =?iso-8859-1?Q?svsuwpneQyHccdN7DfnRSSl9WOHPT/gD60x3fBKf46f0ZwqkWPz4af41zq?=
 =?iso-8859-1?Q?B6OT/vK5tyUytq2NOpMkmqwDAQRVpxCfWokF+RUuPP9Rcy4AbfjIU5dGVG?=
 =?iso-8859-1?Q?syZS8UVzUU95ud2Fz0UnaIGG9LmMuQ0CduqYpWHndk4ssgtEFn/9XOgx03?=
 =?iso-8859-1?Q?DhlgK2dL+MPyY9YsslVw=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?TAIj0vGyswCqHoD50BMY25wS9pVMJAx1/ZFgPiLOVecgohsN/KYDBY00Xi?=
 =?iso-8859-1?Q?nFVO+Wxi481VZ0D0o1X9FW8Icer6BFbTSwxt4iz3T2wD52RZF2VbDt8fcB?=
 =?iso-8859-1?Q?02k/nx8EGKqIrAisd9vq/S2RNzJ62uScAZUhyNQuLa+e2CB8FTBCE3bYKR?=
 =?iso-8859-1?Q?RE3hcVbHLyc2hhvZcpCRdSPaMeX4pfYj03bz8Qt5HUMCYmDcR58krryWzl?=
 =?iso-8859-1?Q?4iCObCe0EJZYmkAPtvZfpwC5RZ2wZrPDfhv+qblzL3Effw3DbSFwJ2znRC?=
 =?iso-8859-1?Q?yiUJ1s7zf90buEAOZU/hYL4PnJgkJoorYWrt/X+UGkXIRFqM1z2D7goyx2?=
 =?iso-8859-1?Q?JRMIn9c9osJBVqXC/TFIOER7GwqDn7A4ZU43R0RCx2qdjbl+ul8GiMLk0x?=
 =?iso-8859-1?Q?I1jt1RylD5CwGKWhD4gPQLOpBZqv+Q2gEtKWQzNsy3R7kxymYVJnWdzifS?=
 =?iso-8859-1?Q?4prjEk5PCTt0Rq0/9B5WwbIT0rNPjhy4Tf9xWC9J/Khei28CEf98lhrcDS?=
 =?iso-8859-1?Q?vYHY+FwGos2qZ+yc5xlTSLPjdUL+DM2tLpP24ZFNrsEdorOhQ9xid9d+Wr?=
 =?iso-8859-1?Q?6QLDlX11owMYqR+v+pqG1OoCjN16wAW5XTwyhieMojVSmyMUd29dvEFhv1?=
 =?iso-8859-1?Q?Y9k12dOrK3qLKIh+3j/3ZekfYHyeCnLjOLYQizaIhat/C9J621EarwZAi6?=
 =?iso-8859-1?Q?kpqvwQdNI8VJLsji9H7VNm5iZiFnKCgT9uu58LymrSA9fQoDSyjbLmpnOm?=
 =?iso-8859-1?Q?x+2h0EnkkzkDJfYsA948dt25yj2blJTHDF8kMzAuE+2kERdASQ8Egvn3uL?=
 =?iso-8859-1?Q?bHpTrdbkpNInrOttroVWjwPAr0wWjsY3dW0pQPxpM8ihjJIWHUvwPOARsW?=
 =?iso-8859-1?Q?PQK+08oo1BkJUQo2BscFa1yuJePNwnUpRVP3FKiVMvrkgc7vSWCLimAury?=
 =?iso-8859-1?Q?fmSxJkyFIozOPNu/DdsJSLS2heaoCM8vYs4hO4VTPP5pY2tujna7yg0sRw?=
 =?iso-8859-1?Q?3v1KBJdAgu+PhQFjllJz3cg7NxUwpHl/4lpCtSSnJDIDT6aFndqurvM+yD?=
 =?iso-8859-1?Q?6b+55TRz2Ayi/ZvDoW4UJJyvTYmdmHrOzF3iLgYBff4cM73CWzh4k/+sJP?=
 =?iso-8859-1?Q?Cyp4vOchIURY6jjHBt/bpFCPksuokmEuV0Psn0lWYl9KN8/j+Si4fVIAxS?=
 =?iso-8859-1?Q?HjCZ2hkJPJNG2DrY0rFt6QFD81U50M/AaFBHB+0PdMUg0o558dghwDPxG0?=
 =?iso-8859-1?Q?B3q0YuC6RwUExmh7C852f2WHqXtYIJGkhsHU7wcyIqEc4SYzP2D3IKb71g?=
 =?iso-8859-1?Q?SQCzVzgZN2vm840VDhEZjjQVSR463m0R+f+BkppPxewqH+z7Nwy3CBxV6r?=
 =?iso-8859-1?Q?/3u9O6+TX0Ku9nNQID9E/w43fXMvv+LB3xQPSm2yMIvpkpyYAUH4hNOlZg?=
 =?iso-8859-1?Q?Jh8m3DkjCyeEuGyqOESTqsD+caYDKzmiUFAvaQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c92adb0-af42-4a32-806f-08de8fedeafa
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2026 12:55:14.4777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSNPR06MB8138

Hi Joseph,

Sorry missed the inode declaration during rebasing. Here is v3:

From b316cc0fdfa4e6a3702b8402bd613863226e1561 Mon Sep 17 00:00:00 2001
From: Tejas Bharambe <tejas.bharambe@outlook.com>
Date: Tue, 31 Mar 2026 20:45:28 -0700
Subject: [PATCH v3] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY

filemap_fault() may drop the mmap_lock before returning VM_FAULT_RETRY,
as documented in mm/filemap.c:

  "If our return value has VM_FAULT_RETRY set, it's because the mmap_lock
  may be dropped before doing I/O or by lock_folio_maybe_drop_mmap()."

When this happens, a concurrent munmap() can call remove_vma() and free
the vm_area_struct via RCU. The saved 'vma' pointer in ocfs2_fault() then
becomes a dangling pointer, and the subsequent trace_ocfs2_fault() call
dereferences it -- a use-after-free.

Fix this by saving the inode reference before calling filemap_fault(),
and removing vma from the trace event. The inode remains valid across
the lock drop since the file is still open, so the trace can fire in
all cases without dereferencing the potentially freed vma.

Reported-by: syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3Da49010a0e8fcdeea075f
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>
---
 fs/ocfs2/mmap.c        |  6 +++---
 fs/ocfs2/ocfs2_trace.h | 10 ++++------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 50e2faf64c..41c08c5a3d 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -30,7 +30,7 @@

 static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
 {
-       struct vm_area_struct *vma =3D vmf->vma;
+       struct inode *inode =3D file_inode(vmf->vma->vm_file);
        sigset_t oldset;
        vm_fault_t ret;

@@ -38,8 +38,8 @@ static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
        ret =3D filemap_fault(vmf);
        ocfs2_unblock_signals(&oldset);

-       trace_ocfs2_fault(OCFS2_I(vma->vm_file->f_mapping->host)->ip_blkno,
-                         vma, vmf->page, vmf->pgoff);
+       trace_ocfs2_fault(OCFS2_I(inode)->ip_blkno,
+                         vmf->page, vmf->pgoff);
        return ret;
 }

diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 4b32fb5658..6c2c97a980 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -1246,22 +1246,20 @@ TRACE_EVENT(ocfs2_write_end_inline,

 TRACE_EVENT(ocfs2_fault,
        TP_PROTO(unsigned long long ino,
-                void *area, void *page, unsigned long pgoff),
-       TP_ARGS(ino, area, page, pgoff),
+                void *page, unsigned long pgoff),
+       TP_ARGS(ino, page, pgoff),
        TP_STRUCT__entry(
                __field(unsigned long long, ino)
-               __field(void *, area)
                __field(void *, page)
                __field(unsigned long, pgoff)
        ),
        TP_fast_assign(
                __entry->ino =3D ino;
-               __entry->area =3D area;
                __entry->page =3D page;
                __entry->pgoff =3D pgoff;
        ),
-       TP_printk("%llu %p %p %lu",
-                 __entry->ino, __entry->area, __entry->page, __entry->pgof=
f)
+       TP_printk("%llu %p %lu",
+                 __entry->ino, __entry->page, __entry->pgoff)
 );

 /* End of trace events for fs/ocfs2/mmap.c. */
--
2.53.0


Thanks,
Tejas




________________________________________
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Sent: Wednesday, April 1, 2026 1:29 AM
To: tejas bharambe <tejas.bharambe@outlook.com>
Cc: mark@fasheh.com <mark@fasheh.com>; jlbec@evilplan.org <jlbec@evilplan.o=
rg>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>; syzbot+a4=
9010a0e8fcdeea075f@syzkaller.appspotmail.com <syzbot+a49010a0e8fcdeea075f@s=
yzkaller.appspotmail.com>; ocfs2-devel@lists.linux.dev <ocfs2-devel@lists.l=
inux.dev>
Subject: Re: [PATCH v2] ocfs2: fix use-after-free in ocfs2_fault() when VM_=
FAULT_RETRY



On 4/1/26 12:20 PM, tejas bharambe wrote:
> filemap_fault() may drop the mmap_lock before returning VM_FAULT_RETRY,
> as documented in mm/filemap.c:
>
>   "If our return value has VM_FAULT_RETRY set, it's because the mmap_lock
>   may be dropped before doing I/O or by lock_folio_maybe_drop_mmap()."
>
> When this happens, a concurrent munmap() can call remove_vma() and free
> the vm_area_struct via RCU. The saved 'vma' pointer in ocfs2_fault() then
> becomes a dangling pointer, and the subsequent trace_ocfs2_fault() call
> dereferences it -- a use-after-free.
>
> Fix this by saving the inode reference before calling filemap_fault(),
> and removing vma from the trace event. The inode remains valid across
> the lock drop since the file is still open, so the trace can fire in
> all cases without dereferencing the potentially freed vma.
>
> Reported-by: syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Da49010a0e8fcdeea075f
> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>
> ---
>  fs/ocfs2/mmap.c        |  4 ++--
>  fs/ocfs2/ocfs2_trace.h | 10 ++++------
>  2 files changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
> index 50e2faf64c..7a4be91d6a 100644
> --- a/fs/ocfs2/mmap.c
> +++ b/fs/ocfs2/mmap.c
> @@ -38,8 +38,8 @@ static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
>        ret =3D filemap_fault(vmf);
>        ocfs2_unblock_signals(&oldset);
>
> -     trace_ocfs2_fault(OCFS2_I(vma->vm_file->f_mapping->host)->ip_blkno,
> -                       vma, vmf->page, vmf->pgoff);
> +     trace_ocfs2_fault(OCFS2_I(inode)->ip_blkno,

It seems you've missed defining 'inode' at first.

Joseph

> +                       vmf->page, vmf->pgoff);
>        return ret;
>  }
>
> diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
> index 4b32fb5658..6c2c97a980 100644
> --- a/fs/ocfs2/ocfs2_trace.h
> +++ b/fs/ocfs2/ocfs2_trace.h
> @@ -1246,22 +1246,20 @@ TRACE_EVENT(ocfs2_write_end_inline,
>
>  TRACE_EVENT(ocfs2_fault,
>        TP_PROTO(unsigned long long ino,
> -              void *area, void *page, unsigned long pgoff),
> -     TP_ARGS(ino, area, page, pgoff),
> +              void *page, unsigned long pgoff),
> +     TP_ARGS(ino, page, pgoff),
>        TP_STRUCT__entry(
>                __field(unsigned long long, ino)
> -             __field(void *, area)
>                __field(void *, page)
>                __field(unsigned long, pgoff)
>        ),
>        TP_fast_assign(
>                __entry->ino =3D ino;
> -             __entry->area =3D area;
>                __entry->page =3D page;
>                __entry->pgoff =3D pgoff;
>        ),
> -     TP_printk("%llu %p %p %lu",
> -               __entry->ino, __entry->area, __entry->page, __entry->pgof=
f)
> +     TP_printk("%llu %p %lu",
> +               __entry->ino, __entry->page, __entry->pgoff)
>  );
>
>  /* End of trace events for fs/ocfs2/mmap.c. */
