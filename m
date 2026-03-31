Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazolkn19012053.outbound.protection.outlook.com [52.103.66.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A365A36AB6B
	for <ocfs2-devel@lists.linux.dev>; Tue, 31 Mar 2026 06:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.66.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774938037; cv=fail; b=PB00UUYQEwb/3NMcpD/jGNlrDZ5e9xkmfNDDFlJlCuhVhcblVnEkZuY8KImhXidTLPGj/AoyIlRVlSmyzPF91yJBQYL0r5XN4hctF2Xm6pZXzzXmHT7R5LecU7K7BrCcvwCyNM1W79MoD/tunVnncGNKENFr0NDTS88o8P/A3lI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774938037; c=relaxed/simple;
	bh=F5WVksLVPyIuhpjsu2nb3D+BGvHl3wV5xwjSrry4zJE=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=OY+t8R5hpxpRv4BSj/STagd7TLQDg4d2qAqIq/zsn73lFT7MyVqKR+X2CJW1LhftbHJXqzDUy3vRSzPFH4yU+WCBM/JYRUnVntNvJjoSlvsrDMSk4eWAL5C+Uee862ZClDWBPYPF5XPPbOMti6h92nlt6M7SkmSKT545P7cm9/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=MtApCOK8; arc=fail smtp.client-ip=52.103.66.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="MtApCOK8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V7GKXTOI2E/+r1GfgyOvBnTLIiglhe0DN/HvkwsnouBPyavKNVuyghZEn1v67YOnzJthAguIo3PhDUr3T2AoyN8rzE2QsD72U43vlhFEuLq3Gxw0NRlJPQhKEcNzLld1BfSuG4u0X/8irOwDT1t/PqBo6tMYDMPfphAgu7vSoJLbCAwJLfymR8EHLbNN2kC7IzmgwO13goZXsAUKxRqFg7oLHS9Imfmhm73LBhnZ5J7zF/EQG5QcS0yJCkmIKVnuyiScsU9FfqamwxI2i9G/cRJ7MNVCM8wis/Z0L2f/7cGaYEYRZc7w9MZa4SUL3J5Ik1s7K7QUkpChGovfyklX5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s6pSvqoj8/Ys/gbpdfkjbjV208rbcpm6Hovi7SUkk0s=;
 b=mtQw5U2oNS01xaaRu5MieyI58XtDaZvzFuDd54c2SSveslmJNycW7nKxFi2zwZ4oLdtaMEkql3xxXxnCfreIfXubyKVVkEjg7ZBtac/lO+9WFp14pzaohSzauyX+rkPdMqE8sB8OoG+sRIiM+0ZqJmwVilwGBc7Jx/IY4y6tCVP9FRoaK0BL0S+138pEdCV6Wf/P7e6pln0S8wOGWkFFhxeYRe4mc0VT+JzIuTrKF9qSczKquHh0gNBRc3X+e3qDgt/OYJ5HM9kFVMrNIu440Nfs34iJSK2TJt4R8bTs0+fWT4IAOMu/Rdvyn/Ep7YG5JdjGCViWJGEkCNrawGr2cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6pSvqoj8/Ys/gbpdfkjbjV208rbcpm6Hovi7SUkk0s=;
 b=MtApCOK839pwm+FJna61hz8TJlZaW6Eqi3cAu5P9BscUXMbckaHyfc1xiFZCrp6U9IGSgK7lamlOaGU4t4waaR7s4MlOLBNhjkX2Ym5Ob5LZcRKHMPEVcpw9iSVQc2I5I8tMNu7gj/61DQK++0i0YjC3uVWcJl6kitqUznqjtPrbpjTA4zUi0muKucLbz32DAYuGPfFoFrQM4xWdVuNZMeGoAZbsdi4kf31LQpPsCfDzKPEjZHiH9elGt/Lpbg2oA/diVM2xBbOgwlKcyXuzRBb0rQrXIxtpy2dHPldg1+giggMxpC6//bzKD/aK71X0mvyp2vwMnnnb/jQ3/LMu0A==
Received: from JH0PR06MB6632.apcprd06.prod.outlook.com (2603:1096:990:3f::11)
 by KUXPR06MB8750.apcprd06.prod.outlook.com (2603:1096:d10:a0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Tue, 31 Mar
 2026 06:20:32 +0000
Received: from JH0PR06MB6632.apcprd06.prod.outlook.com
 ([fe80::4fa1:706f:f4e0:6bad]) by JH0PR06MB6632.apcprd06.prod.outlook.com
 ([fe80::4fa1:706f:f4e0:6bad%5]) with mapi id 15.20.9745.027; Tue, 31 Mar 2026
 06:20:31 +0000
From: tejas bharambe <tejas.bharambe@outlook.com>
To: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
CC: "mark@fasheh.com" <mark@fasheh.com>, "jlbec@evilplan.org"
	<jlbec@evilplan.org>, "joseph.qi@linux.alibaba.com"
	<joseph.qi@linux.alibaba.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
	"syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com"
	<syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>
Subject: [PATCH] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
Thread-Topic: [PATCH] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
Thread-Index: AQHcwNXs5iD53wTE0kiEVqiw2/R8EA==
Date: Tue, 31 Mar 2026 06:20:31 +0000
Message-ID:
 <JH0PR06MB663281D3B927A61AAA2BDAA08953A@JH0PR06MB6632.apcprd06.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: JH0PR06MB6632:EE_|KUXPR06MB8750:EE_
x-ms-office365-filtering-correlation-id: 8aa1f2e6-0a0c-4799-ae95-08de8eed9c35
x-ms-exchange-slblob-mailprops:
 ZpxNddEKiWwjxFydBHdiBgab8YGVqH/WANFR+Zq7lh9VBHFfyYHBVVji6/lYcTg2V/aL+j43boqiuhy3VyR/L9Npxr4VHj3SULJ96SRxcJNI9lKUY3CGlbLDmy6SQdN2pMuhbQ9PtQXNXmExUZwKIR5UogqTAk0kYObmT37ZX7bZlMhT/v9VVrsQf3mV9n5EZp6eTyvImUxEy1cIWhnEcCnRFwp9ykTz1fsDhcQZalR+cz9X4WDZDjlKP4zyFrdsvB+tQzDXxULippVG8wLyY5pQNCkA++JG9EstQyg6ALQeVqLT1oWy1nt4QFzQwvaQbmVw2N/EmkbmnkEEmxdA6KAGOIbXC8BW0bBK5b8B4lJmqAsbVADw26uM0e+Y6tGJzm5WBg0kuko3DY/sedSieH1X6eYoFQU+ONNhHKu2vlssqSQhaBvt7z5Xvhx0ZR/cK2iXRExNk7+6AWht962aJp+IkVw6cecVYlWS7w5CMdrd7upgTSko+NwzV8euVnYcJoJT1xHW9aWYnD6FTygifP7ALH8TIt05pb4vt3l6kMU5RrAvXd7Olr6GUMc6yr6q0EqqBE5i6EqQZAgA3fJw0y4WsmifeUI65fYzJxNlz9jJ6iJbM1CjozjWjY0Q4lELSNNJGJ7OK2VwhiXmEYDG59bZ6kURcoye57HxkCPDvU1OuDzdRc4YAt4W9N4EfNxySHZDpSImSSe9XFmgaq4CxyP2eVx7wkvNq8vaWZaOTTMEpQlDneJ4XYoRwjh9zw5eX24myjRXFQ0xYSwJpdAEpg43t+ybC176VFL2uL6amFO7tkvTeHd8FIPo4H3cCULKf3pyewe3w684brIDPh0S2w==
x-microsoft-antispam:
 BCL:0;ARA:14566002|8060799015|15080799012|19110799012|461199028|31061999003|41001999006|39105399006|25031999004|8062599012|15030799006|5062599005|1602099012|40105399003|440099028|3412199025|4302099013|26121999003|10035399007|102099032|11031999003|12091999003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?zEdPiFjShJv6SuZPiwGW4BDycFvgXaoGR3W/Y8UIWzQiGc559pdU/UvC3r?=
 =?iso-8859-1?Q?TaKr+k4YnhzAWY/eH5pBNHXw7QuYk/Ek7luqlejmLBwfU/Y+sBC8iJc6k7?=
 =?iso-8859-1?Q?TcqUQcAf+7qAmsBETApB0CVWcSuWMbCYCGYHa+FLLN2Yk1NSNwuhOlKkFy?=
 =?iso-8859-1?Q?Kt66dMOBqRs47tWyBdKmj1ybs61g3gK1ch7EPsTVK7/pDYJLUfr6HUZ/6H?=
 =?iso-8859-1?Q?pVMggDDFxQv7zHaEQyGap0xR9FFasBPc2pge6O3r9uw9RJ/o66VPjoFwwi?=
 =?iso-8859-1?Q?riO2Y6NaBUB/0+va7d8rrKLHPmRd25GV7bMj3B1kHCIk5D4eMyHyN57nxL?=
 =?iso-8859-1?Q?gyvVLTL+0M9L/IWhuOZGd8btwO/lhPnT+zlJ2dXdVWBnaFfP0vvpYfQqd0?=
 =?iso-8859-1?Q?7zNYGlFj69qYIUxEcT4ZaOSr/2lUyFWHf6jkwlVluxK7kolmcuST7AgkQK?=
 =?iso-8859-1?Q?vKa7f1Dddq6EyX00EevnzAPY4nZ9iZbJ4eDsOyecleUHB4s13NQ7ycdith?=
 =?iso-8859-1?Q?AZ1s0Mj9/UqBxvgAoBmtDskrMgqBtP5vC7Ro8t6ahT7trFA8111hL0TMEc?=
 =?iso-8859-1?Q?Fn9uawRVPIH7zF3cis7hxCfBSBa5eyHESuzQvgfe6ViVpXSOX9knx75B3e?=
 =?iso-8859-1?Q?56xTev9B7MnWFYNWQQvWXDyHVkrPMV38KVbcHDjlSGUkivf0NyTw/C5tuL?=
 =?iso-8859-1?Q?q4Gsn2iv+yGdGfnTKcgCL6nMcIN8ThhSa/6ycRWEpvHkw7UHb17SMZ9O/8?=
 =?iso-8859-1?Q?c7xI8+cs/pUTjCJuDtqSLmfZRJnwvnHLbfzHtCuHVYQovQoYBbjgLyM6nL?=
 =?iso-8859-1?Q?85EzcOeK7r9l3+DNyZvcd8gaX7pstNaGsjToHgiUNOReBY6xngllfuc+FG?=
 =?iso-8859-1?Q?ey0c6pTGzC+JIObfLJU4upViYlHIIIRP0p6BbB763avqOj5StiGTm9Y8zR?=
 =?iso-8859-1?Q?dIJcI/sMJ0Q8ODp8rdJwIIerQXI05IsAQs3IKMjpPIvm/0a/fF847su2TX?=
 =?iso-8859-1?Q?J3ZEOcs/ixniDMWOioRvzgYo+LKKNTN7R1dHqbq//fUX09nJy9jes8EAeg?=
 =?iso-8859-1?Q?sfJxTE+dg3bo4HHdysmtH+YFw+dGOdhNnSCBBE4SdxEgfC07H90A6Yq4eR?=
 =?iso-8859-1?Q?adX79NE3HEuts4zOZ03H2fHVaXhIT5umBHLDxGTMSe0SoHDgCwoeBa1Fyb?=
 =?iso-8859-1?Q?h6M9dpSY0XGuvj315UJrWk/ntULUAYvVopagjLbn7SllEhKuke0XxtHCar?=
 =?iso-8859-1?Q?e+rhXjqT/43iCtx5/jzw=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Eddy3m4ZorjgbKcr/9gm4E586Hf9OnHCuuhQnneq5UiRQ/SoQvVsZqDHcT?=
 =?iso-8859-1?Q?EPlHMYsCRsTm5M/kgpb9XfSwWlMXKFo0SnCfjikW2HHikYnBlPe/VrL5jT?=
 =?iso-8859-1?Q?RHK1j+/q07nkjJoHQwIK1rDMlE4q1EDj4SkybJaH0p6CPOBGtea6l0es+4?=
 =?iso-8859-1?Q?YSrmAV+DzakvEoORe5oLQaEcUDcw1cdCC1kRYRv6yS8m0W3krQiOyuXnnF?=
 =?iso-8859-1?Q?6Z29GRAsbtpQsRl5laqRXgNNzkR5/bwYJqfe9bi3Z8HJsR/7taYUENDQik?=
 =?iso-8859-1?Q?LVFAlGSQS+ARMt2egMkQqQbDONk6khjZdCBqz+0VL1QO+X/9KJ8KQNigY5?=
 =?iso-8859-1?Q?sQhhD86yd0MLXomJnxu3ZsQcial5/VtO+lHpA1THwp0D2l2f46sJ/ulIvW?=
 =?iso-8859-1?Q?2njganXWCJ6qaZVCPLsPN4xqg0w34jitkwM/zG5s4esiRcNW4ZaTSlj1YW?=
 =?iso-8859-1?Q?1gXsSSRD6mQ69RFpM6qayI+OpxrihpeEUPXWDcoEoq34XHHzTy1bG9VA0O?=
 =?iso-8859-1?Q?/bdCct6fRQQ+vlTpvxcpb/lDvxfFfQ3JE8Q9aTX7Tg87j3VZAMby9layq8?=
 =?iso-8859-1?Q?HdiDalxIuA0WYJnVdXD1RaJw5Mm/ZAKuCer/ufbtusci1y6bDs8vIE/kRP?=
 =?iso-8859-1?Q?ZR+C4zZNCsYp+0NlqJhN+TvLSI69lK5WVY6qPXueBgnnbS7LTVnmG8gtDp?=
 =?iso-8859-1?Q?BjGCOuMW1HEvWRhCJvdP2nu3DpQJp7LfW8Spu2AeWbiXG1B5244i1/2fMv?=
 =?iso-8859-1?Q?WA7dS7GuKvDYR9rglVrbcR6PZ9cpvysuXAeteka/MuVT3hJlyTCnNop4OH?=
 =?iso-8859-1?Q?EaOj+Ra2Bp1Me2Em48CAnaUI6xBqHkyev7EZQ4CddQKC5DxlgKc5RH+01i?=
 =?iso-8859-1?Q?t2+2PWBGP8Pa9CVHUocYSmnXifOiL08oz7BMitWIQ+ogxou+WfCmL4fo2W?=
 =?iso-8859-1?Q?FxTbThveeXhR5OEIzWfVBO9LfsKmKfQSfG3D3ohW0jM/vUTu85kjAWzHM3?=
 =?iso-8859-1?Q?65BKV3ge4aXH1402VvSli7PAWa9AhkQMz84cF3H3oBR4tEDYdh+/dNbfos?=
 =?iso-8859-1?Q?gYxuKsknDlbWEQbgKSb4Gh0JlgUZlXVuzUNXcUiGtLR8gKqbVPEbljgLhi?=
 =?iso-8859-1?Q?H+B61n0trcgLZdUQWT7rFLpg3BZbeQ9DPDf0RoIxMTSJiTgdXG2PAQgImJ?=
 =?iso-8859-1?Q?LXMdpEKDQZZH71MPnyjf13Nh6th2PL3tIbmyGRioMPjG3CpQ3qeKK7v5ed?=
 =?iso-8859-1?Q?vXAcqMp6RvL2t01mYes20nnojJmUwwqwu30y8z0DPHKby3DFNcaemu/qqV?=
 =?iso-8859-1?Q?qOJm1pbceUp9qiWemsabxjSizHYon6mMat+5qXHKh5hsCOatBK7mk6OJa9?=
 =?iso-8859-1?Q?4H1PDeeG1WnsKiOa5C1lsjpzsaBRogHq4R47WQFBknvAImCmTCn1TBIXEt?=
 =?iso-8859-1?Q?uk/7Tt4sx/d8QjWakYzUn3nuWXy5d8QoZPck+Q=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aa1f2e6-0a0c-4799-ae95-08de8eed9c35
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2026 06:20:31.1729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUXPR06MB8750

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
Fix this by returning early when VM_FAULT_RETRY is set, skipping the=0A=
trace that dereferences the potentially freed vma.=0A=
=0A=
Reported-by: syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com=0A=
Closes: https://syzkaller.appspot.com/bug?extid=3Da49010a0e8fcdeea075f=0A=
Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>=0A=
---=0A=
 fs/ocfs2/mmap.c | 8 ++++++++=0A=
 1 file changed, 8 insertions(+)=0A=
=0A=
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c=0A=
index 50e2faf64c..adf6423ae9 100644=0A=
--- a/fs/ocfs2/mmap.c=0A=
+++ b/fs/ocfs2/mmap.c=0A=
@@ -38,6 +38,14 @@ static vm_fault_t ocfs2_fault(struct vm_fault *vmf)=0A=
 	ret =3D filemap_fault(vmf);=0A=
 	ocfs2_unblock_signals(&oldset);=0A=
 =0A=
+	/*=0A=
+	 * filemap_fault() may drop the mmap_lock and return VM_FAULT_RETRY.=0A=
+	 * In that case the vma may have been freed by a concurrent munmap(),=0A=
+	 * so we must not dereference it.=0A=
+	 */=0A=
+	if (ret & VM_FAULT_RETRY)=0A=
+		return ret;=0A=
+=0A=
 	trace_ocfs2_fault(OCFS2_I(vma->vm_file->f_mapping->host)->ip_blkno,=0A=
 			  vma, vmf->page, vmf->pgoff);=0A=
 	return ret;=0A=
-- =0A=
2.53.0=
