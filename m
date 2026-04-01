Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012061.outbound.protection.outlook.com [52.103.43.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2C21F875A
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Apr 2026 03:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775013870; cv=fail; b=a8f3QJc+au/19qIN/J3jcoa69V06mP+mz84aKXQyDJ9wY2HFbkTuE8s2JyXP5/B9HWeLh1cQb/I+1f7jChIR8UPhrhLNU3+BSbl7yd9V1XCuht4y4T/Z5edVLb0nFz6s3YXE0KiO7JYStrOS/wzoCMph9llXImTpWK1x/OA1XUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775013870; c=relaxed/simple;
	bh=0mQ3HBsqyh3H1SF3Fu5UUebr1Ixz1Z3cAxXiAo5v77Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kWyOkXkCTN9tDD2dwW4p9UoX2KugoaY8bjJCFHNHtOc0swFMXGGpYki9S3n4qBeNztjgHIzY4hHBTk2K9+aHK3xaWy8VLbaWE80ayHKTG7n//blmAUNW/CwaBo685f5kAYGV0aabxBS6x/dyM3Sas9mUXJS9ZD36hsOSKgLskY0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=JLleAhuT; arc=fail smtp.client-ip=52.103.43.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="JLleAhuT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jkdcHug53C5dGHVI6rYWMcNFquEnuO9cUKGgwcEWu7o+uMnGl72qdgUbwHkpJXblJw1ExUaHnCYdA+WlC0Oek6Jy3EQrdBw40xMghRO63IIod/zD1NvIagCkoBpKlV0AktFriewbHfTO+b1g1BsU/IdSsNL1rbz7Ogg2hn/8iD/hgYs5FOR8mD0xOjEpyk1pVF4AOF+lzw6pdoawA+t1UlsyehXmJmmGvRTdKGIlvkJxqvXRoZXhPgfvXmQjPlK+39SzScCmioQ1EUpEYMYkzchWqSZKBhFZilYyZRkOBIxyQZn/g3mn2LpUpx8pNfmGglIRunutNaQdy6y0aZAwQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XOJIywl6x4qNWSOg7twhCP3oS3GhpHXhH6bDbnHOqEA=;
 b=tMGMAOgnRfKmDL/1OnwN4Tzx9ReNqdwzBfheXBBQvcr9tEsC2YqkyFrp87AKCGlPvRj/yqlMG1Pb3HiHeGiahNWjI1qmMjJT6k550WmD0SIoLztJEragNCI4S21qT8hqfcmg9E+X+gvPyB6GrdNSJcyp82IpIgZzv+DywhzxoXwGw9EM2UO05qOQCyVknbLy+RDt6ozaTIivueNvzABad/BwyY6TnkTwldAt/ZsTdtrn55hsNXlvwIMm/iVfwwRPvfZpOVnk0wVvJF0xc6Kwy9Yas6XQStsJXM9ItIeVwj/Agtx7uFzOZdetFQwUfng7w99BBdvIhEVDXLKiFj0j3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOJIywl6x4qNWSOg7twhCP3oS3GhpHXhH6bDbnHOqEA=;
 b=JLleAhuTDxWVLVp1DPF7bnkGoqSdFRZkOQdM2cC/617HWRcmuYEcPTzVlhms+KofZo9GUrSD8z2EzZFdNqFlqaP14PR9huHb7UQPNJo+wS7+2q+R5vp9/JD4wlpdrD1c8uMoJ2nqzcgzn85QSS5EsgvsXtrMfsHU36tYoxGHO9sjmIXPTsmBKbIWn+6aAMXmrKFVsEXdfF4904omCRYMovvqEPeZ9JE1z76votkx/UF0ibhv2Qtby/tYaFxJkJVQewKJGM4uhoi/0Jr2Zvf9goa0DiO2YkTkOssyl8XYb8Lk/tWu1n2jT7OHjoyQRQ0STJ473P6BZledEDX7XiDX7Q==
Received: from JH0PR06MB6632.apcprd06.prod.outlook.com (2603:1096:990:3f::11)
 by KUZPR06MB8240.apcprd06.prod.outlook.com (2603:1096:d10:5a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.16; Wed, 1 Apr
 2026 03:24:23 +0000
Received: from JH0PR06MB6632.apcprd06.prod.outlook.com
 ([fe80::4fa1:706f:f4e0:6bad]) by JH0PR06MB6632.apcprd06.prod.outlook.com
 ([fe80::4fa1:706f:f4e0:6bad%5]) with mapi id 15.20.9769.015; Wed, 1 Apr 2026
 03:24:23 +0000
From: tejas bharambe <tejas.bharambe@outlook.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
CC: "mark@fasheh.com" <mark@fasheh.com>, "jlbec@evilplan.org"
	<jlbec@evilplan.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
	"syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com"
	<syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>, Heming Zhao
	<heming.zhao@suse.com>, "ocfs2-devel@lists.linux.dev"
	<ocfs2-devel@lists.linux.dev>
Subject: Re: [PATCH] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
Thread-Topic: [PATCH] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
Thread-Index: AQHcwNXs5iD53wTE0kiEVqiw2/R8ELXIZ2qAgAEcSRg=
Date: Wed, 1 Apr 2026 03:24:23 +0000
Message-ID:
 <JH0PR06MB66326B03AB7ABB7E40C0A2398950A@JH0PR06MB6632.apcprd06.prod.outlook.com>
References:
 <JH0PR06MB663281D3B927A61AAA2BDAA08953A@JH0PR06MB6632.apcprd06.prod.outlook.com>
 <5f7200f6-41b6-438b-bd22-461ea651ebf6@linux.alibaba.com>
In-Reply-To: <5f7200f6-41b6-438b-bd22-461ea651ebf6@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: JH0PR06MB6632:EE_|KUZPR06MB8240:EE_
x-ms-office365-filtering-correlation-id: 79840e0f-ffe5-47d7-86c5-08de8f9e2bc0
x-microsoft-antispam:
 BCL:0;ARA:14566002|25031999004|51005399006|19110799012|461199028|31061999003|8060799015|41001999006|8062599012|15030799006|15080799012|1602099012|40105399003|440099028|4302099013|3412199025|10035399007|102099032|11031999003|12091999003|26121999003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?d72uKOvjrVHJHWuRtHvymzDmwCRKzJs7XBW19rYhnbflm30eM5w7nm9B/d?=
 =?iso-8859-1?Q?BzXzI0o5wGfQmN5U/YTjuBkS6+KlS5tTvsbpA4hNZ1iOZXhyvfV78IJckX?=
 =?iso-8859-1?Q?KwLdh4QUB5L62k5CLGxaGU7W+JWxKpsT26iAnOXay6U87aUZBeier1lya6?=
 =?iso-8859-1?Q?oNhTK2xP3BNJ4uZbdXkmySksFrTiGvASRpVBzR2zh+E0w5QvNtQCxVMUEN?=
 =?iso-8859-1?Q?aSfeCjJVoLGGpZjNv8z/8qVFzNtKSlZSw9y+6skWo8IyR3zdYp6dilDxDj?=
 =?iso-8859-1?Q?MHJmyCuD3K0GhsWxqDmIjH71/jrtH5Q48XJgXlIIP0dv2U8V+GWqgsfxma?=
 =?iso-8859-1?Q?RAlmVrrMtJU9RhqmIlFID8/IVdFcX+Q8OCLjQviM+y/0WQl1g4/RAnuyeG?=
 =?iso-8859-1?Q?II18mr2Mwn/xrEf8IunEUJhgqOmzgTkFck/HnbGtSXKKDqH7oybf0NWSp9?=
 =?iso-8859-1?Q?F3iiLUxa2azClxCfRIDKxOBMsRIc0s2nthxqbVkxl48V1LG2P7nmOnKHAf?=
 =?iso-8859-1?Q?XLauXd1WXrmjFAxpgGRNExT92qPyOAsV95AhqV3RJ0KGombdRehkkoyM7B?=
 =?iso-8859-1?Q?25A3hf8lWDo+SThWCZP4RPHWcWbLcW9uHspcFNOtKV+RwqHCc/nhGMUt72?=
 =?iso-8859-1?Q?l9A1SL0yNIRAqHAi0VJezHUFCa6vNTufe2KVFAav2DRlCxlpPwAxnwAwwn?=
 =?iso-8859-1?Q?ci2WMASdLMTttNhmKLWoDaZbKF+uW+QUfzr3t1+7b9P3U1vOgV8dlYCaxK?=
 =?iso-8859-1?Q?pDFVs2aVov0WHk55/PS1G+yZ+wSgFfLKAs03ZTgKZCDYz+P2P5akRPBG8h?=
 =?iso-8859-1?Q?YYzoxSR/2i9U93tAY/cTyJF61iYXXfKUcf9Pu5kDDJmvby2PnzVX41XRiS?=
 =?iso-8859-1?Q?Z4veQcIGvhY6wVexNys4XyjSPE6TwpH7juYW648EJZBVJnCzT7d+pDF/U+?=
 =?iso-8859-1?Q?H4IFfPCXkZzF9bSHij9jItNHI1KjqfdGZFBh66lA4COjlTB1lWWDufrUXA?=
 =?iso-8859-1?Q?xZu3n6aTd43LDR/s7jaKeVmkOhxFpl1B/uWaA073zar4A4gjDjZCrqA/cN?=
 =?iso-8859-1?Q?YhshOV6doxmsw9171lbLxKnnu5Aylg2mjAU+Nd53/fwDJTu1JglH1LxMGE?=
 =?iso-8859-1?Q?Gwo+tNPFjbbIoYkppAhEBon1Qs5Jd+S2O4OFTu5Syupw9GLQEfIThri57U?=
 =?iso-8859-1?Q?SYfRl9YCFJPtuVNhSeBt4PTQ47X51UnuyPo=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?93mfw4RZjRVRuuwJZAM5YctiZczPzEW805h07Y5vP+ntp2aJbvA4CES1z6?=
 =?iso-8859-1?Q?Mg7agErNmwVdMBTg/2b6H2YN7UKLVXlJUJ/e6mxIV1rl9cfxOMtslip7iL?=
 =?iso-8859-1?Q?lMtQ0tzEt3IITCDEOmi3UQeHjIRwWZLtQu5uwInj67fcG5iPZ6UWVLDBMi?=
 =?iso-8859-1?Q?v3UzpfCB0xB84pJMtjSgvU8dBctsVK5cm7A3BnRTQUce5Og6TsgFjRhobX?=
 =?iso-8859-1?Q?QhoQDKIrmGaPm5N3iZ67adk2nk+fn+H+uLA1ngkW2o3Ik3i0G0O3locfVF?=
 =?iso-8859-1?Q?zZlkO0vbosBI8XYHEMhDc9VTMEUwTBIqDW4A2IqxKAq0pUSSBbVGhKINYw?=
 =?iso-8859-1?Q?wP/RHqajhEs8dVQ3SPIYh0tsYiEs6rgbHhtVdeP7NKy7encf0ZrXmnmi0d?=
 =?iso-8859-1?Q?ZYfatNJ0SMOYx5MPgL2CIWKQlfXmvyGgKlmgKyCfkUHEIIyi+rKcD9eMF7?=
 =?iso-8859-1?Q?fWvdEpLXd4hbIYrfXXTmLSN8GRG0GK6tl6G1HIIP9R7sVfSO4nTseDgH66?=
 =?iso-8859-1?Q?yithuyAQVv/MoQaKrppToUA+w56JNHceGwpNBjoxzXqIt898ZT4YhofP+6?=
 =?iso-8859-1?Q?ye3aOMyIwNyGlLrAMrHUA6DVK3zuugqzBoBHG0SqNMCE1zYz3IPYCBHoYv?=
 =?iso-8859-1?Q?wjeI6N4kkXz0s1hiuG28C1+/WpweT0WvomPOHylosti4Cg90vO3JMcLUgf?=
 =?iso-8859-1?Q?xPglyx4AKH2ebzBCxuTGgWKgc/nJezOVMcdmgnr6byA5dPQ9pTSXr7x0Et?=
 =?iso-8859-1?Q?K0mY//xke4qEF2wv3lPO6hLktGb15EfJo2Rb7EMJdT6QV0spXGixJtnE4m?=
 =?iso-8859-1?Q?i9m3zmZqh6uwUURCKyJ4EEVjDgAzjiqiHH7aBcLqAbcB6sqVI/iJOno/sD?=
 =?iso-8859-1?Q?OiKYAyH8ltOsdkCEu5j9Lto7l71VptymhZUNANo6i3Zb/pysO0ISNGF0f8?=
 =?iso-8859-1?Q?SZDA82deM8OerEwqkVXIlhG1vrSPi3I3w3CVPGp/n4rJjfmHZE3D8x5GWp?=
 =?iso-8859-1?Q?Npwakp1Wp7TQYGgSuZDOTg20raODUgAPAG3Au4e+sgcNeF4LRElx/+RE8/?=
 =?iso-8859-1?Q?Y//F1DqjrHdrHyRHN/52WluXR47zcmBscc1OnptF40Kv1KRCRL6XxIJ2oB?=
 =?iso-8859-1?Q?t6XisALKlaMEFFWY2cynaCKw+sx4vEfln5SxLW68IlFSOTNqdNaJbTVZVW?=
 =?iso-8859-1?Q?6dEBxrd4VRlnipY/Q+MLIvBEGfNgQTJz7HD42nriiWbXVbpgOHRJl34MA0?=
 =?iso-8859-1?Q?ZqHN+Q8HaKdqFLeSL/o8IQINuHZfP0Teow00sL1C7y3Zh+btw6tfxxHe8Z?=
 =?iso-8859-1?Q?FfoOkCvHhC0htDlYOOugUEuHRrLpdG9CLmspQpclf6/W+SlJ8sIYiQiHG1?=
 =?iso-8859-1?Q?fmpC+bPmEAnyMabwlGVSfQ8AgKHLOh6rTI0cHNOtvkmhemcdYbykK3o9yB?=
 =?iso-8859-1?Q?jGYNAhSB9bhE+TdrUkGZ8b5MeML2wdrSX0/72Q=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 79840e0f-ffe5-47d7-86c5-08de8f9e2bc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2026 03:24:23.3946
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUZPR06MB8240

Hi Joseph, =0A=
=0A=
That is nice.  =0A=
Did the following:=0A=
1. Using inode=0A=
2. Removed vma (had to update the ocfs2_trace.h as well)=0A=
=0A=
Thank you for the suggestion=0A=
=0A=
Please find v2 below:=0A=
=0A=
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
 fs/ocfs2/mmap.c        | 14 +++-----------=0A=
 fs/ocfs2/ocfs2_trace.h | 10 ++++------=0A=
 2 files changed, 7 insertions(+), 17 deletions(-)=0A=
=0A=
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c=0A=
index adf6423ae9..41c08c5a3d 100644=0A=
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
@@ -38,16 +38,8 @@ static vm_fault_t ocfs2_fault(struct vm_fault *vmf)=0A=
 	ret =3D filemap_fault(vmf);=0A=
 	ocfs2_unblock_signals(&oldset);=0A=
 =0A=
-	/*=0A=
-	 * filemap_fault() may drop the mmap_lock and return VM_FAULT_RETRY.=0A=
-	 * In that case the vma may have been freed by a concurrent munmap(),=0A=
-	 * so we must not dereference it.=0A=
-	 */=0A=
-	if (ret & VM_FAULT_RETRY)=0A=
-		return ret;=0A=
-=0A=
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
________________________________________=0A=
From:=A0Joseph Qi <joseph.qi@linux.alibaba.com>=0A=
Sent:=A0Tuesday, March 31, 2026 2:55 AM=0A=
To:=A0tejas bharambe <tejas.bharambe@outlook.com>=0A=
Cc:=A0mark@fasheh.com <mark@fasheh.com>; jlbec@evilplan.org <jlbec@evilplan=
.org>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>; syzbot+=
a49010a0e8fcdeea075f@syzkaller.appspotmail.com <syzbot+a49010a0e8fcdeea075f=
@syzkaller.appspotmail.com>; Heming Zhao <heming.zhao@suse.com>; ocfs2-deve=
l@lists.linux.dev <ocfs2-devel@lists.linux.dev>=0A=
Subject:=A0Re: [PATCH] ocfs2: fix use-after-free in ocfs2_fault() when VM_F=
AULT_RETRY=0A=
=A0=0A=
=0A=
=0A=
On 3/31/26 2:20 PM, tejas bharambe wrote:=0A=
> filemap_fault() may drop the mmap_lock before returning VM_FAULT_RETRY,=
=0A=
> as documented in mm/filemap.c:=0A=
>=0A=
>=A0=A0 "If our return value has VM_FAULT_RETRY set, it's because the mmap_=
lock=0A=
>=A0=A0 may be dropped before doing I/O or by lock_folio_maybe_drop_mmap().=
"=0A=
>=0A=
> When this happens, a concurrent munmap() can call remove_vma() and free=
=0A=
> the vm_area_struct via RCU. The saved 'vma' pointer in ocfs2_fault() then=
=0A=
> becomes a dangling pointer, and the subsequent trace_ocfs2_fault() call=
=0A=
> dereferences it -- a use-after-free.=0A=
>=0A=
> Fix this by returning early when VM_FAULT_RETRY is set, skipping the=0A=
> trace that dereferences the potentially freed vma.=0A=
>=0A=
> Reported-by: syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com=0A=
> Closes: https://syzkaller.appspot.com/bug?extid=3Da49010a0e8fcdeea075f=0A=
> Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>=0A=
> ---=0A=
>=A0 fs/ocfs2/mmap.c | 8 ++++++++=0A=
>=A0 1 file changed, 8 insertions(+)=0A=
>=0A=
> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c=0A=
> index 50e2faf64c..adf6423ae9 100644=0A=
> --- a/fs/ocfs2/mmap.c=0A=
> +++ b/fs/ocfs2/mmap.c=0A=
> @@ -38,6 +38,14 @@ static vm_fault_t ocfs2_fault(struct vm_fault *vmf)=0A=
>=A0=A0=A0=A0=A0=A0=A0 ret =3D filemap_fault(vmf);=0A=
>=A0=A0=A0=A0=A0=A0=A0 ocfs2_unblock_signals(&oldset);=0A=
>=A0=0A=
> +=A0=A0=A0=A0 /*=0A=
> +=A0=A0=A0=A0=A0 * filemap_fault() may drop the mmap_lock and return VM_F=
AULT_RETRY.=0A=
> +=A0=A0=A0=A0=A0 * In that case the vma may have been freed by a concurre=
nt munmap(),=0A=
> +=A0=A0=A0=A0=A0 * so we must not dereference it.=0A=
> +=A0=A0=A0=A0=A0 */=0A=
> +=A0=A0=A0=A0 if (ret & VM_FAULT_RETRY)=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return ret;=0A=
> +=0A=
=0A=
How about change it like this:=0A=
=0A=
Remove vma from ocfs2_fault trace event. Then=0A=
=0A=
struct inode *inode =3D file_inode(vmf->vma->vm_file);=0A=
...=0A=
ret =3D filemap_fault(vmf);=0A=
...=0A=
trace_ocfs2_fault(OCFS2_I(inode)->ip_blkno, vmf->page, vmf->pgoff);=0A=
=0A=
This can keep trace event in all cases.=0A=
=0A=
Thanks,=0A=
Joseph=0A=
=0A=
>=A0=A0=A0=A0=A0=A0=A0 trace_ocfs2_fault(OCFS2_I(vma->vm_file->f_mapping->h=
ost)->ip_blkno,=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 vma, vmf->page, vmf->pgoff);=0A=
>=A0=A0=A0=A0=A0=A0=A0 return ret;=0A=
