Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazolkn19013080.outbound.protection.outlook.com [52.103.43.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4270F1F936
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Apr 2026 03:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775102308; cv=fail; b=VVN0fmXutXuJKup+H4o7VdD381Pc5saoRhhcj8u2l9hfvZqFuIxgT4ClZNTjxFY7hQc4H/A3kw9k3PmLU7zHIqX/0i1LtS5N7GGe96XVoVS4dHfv1rGGFw5U2+DZhYzDVWWIsQjWr2Cbaaxk1aDA/8ZO0FJhN7JwFTZLUXfN7yo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775102308; c=relaxed/simple;
	bh=fOHI7YlxLF/nI9NPFYSaqdMOaWStNOO5AWVsg2MJ7M0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AV+bxdaepSm/5qDxTCDEhZ66vg1t6RxybDfY0I0sw5HnPwoPlcddU0mme4z/2EKn+S9pG3KYwjkJ23vffQbDwqDEnXli7wU9iAxCP7szPgvc13qxzg3NURYkFFc51O+GuV9AMYiyXvxqlxspj5DzudyNMKWGEw/04m4zE/ovp4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=PeaDi/FE; arc=fail smtp.client-ip=52.103.43.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="PeaDi/FE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I57ZcX+YqbACTFMTbq5jAMyCz5UhBlp6cpKtAWDbkI65LF7U69DLO+Z7L7UGZNWxetwNlhitsdfY2E+eGxwFEu4oom/cf7x+FOcm+V0ZzbkzrEAwoD2OACUXFkD21MYWj5b6lUiAVTG2NFNbS+84sxKCgvFKOK7vyKgtuXJRhJiPtV+luwoyQHDNuvm8XFc1RDLccDsfXf+La/1MOW18JHbMsVxt8MTXcOP5xpfFojIBqEi+qo3JtUhDudX5Ni91zBt1UGbg4uUGYt5fKF5tSWlODf9p9ubds6po6k5AfY7aAsPWVR7wk1fvtJCJwR5+OU+p0o0FOssKeECRiX48gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qghgTbYVI9WfvF+oJMd62QZ65MmHETsMRb/iMzeebp0=;
 b=Q7ggcVu0o4l91RCf00IzT7EzyPz0KUjizU81RWgjyYqNRkdwAOhEL0dVxiboVIYHb6sgwS6EElGpXYyreiBo3C4GsLB++YtV/EbNWHnyuR6PMx1V75xzyaGAOgp8BOuhSmGbbQEDEVaYFwwYW78s/Xo3e2e96Xptuc82/3Cgb99p0rJoRzhEbW4BfS71mCvc83DSbcEeNaXaC+pKJED7NBky+wvW3kmdXh0odLUopUAMzULvXtdMDWxjBd/htVKGsnKHUa+YeRNwbG6GluIZuNPFOXd5SIJz81OXPSrEYVpcgzHpvHfYiMUZ+kWEfIFWPC7uhgroczniik++tV/2FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qghgTbYVI9WfvF+oJMd62QZ65MmHETsMRb/iMzeebp0=;
 b=PeaDi/FETG4JLnJGHgt9X/KcR4jrvF3E8RDgJ9dnNfer65JKPW/RZYyhu8oeTcAZ9IhRJrMfOa94XTi8vBHf3EHmcUUObxTtU/2CdUsTlrJM+lUpjFcXe/IkzUpBUm0qvIVweqgQXjOZir2EcyXRAmpqOxCKi6RgrbaG1d7Z9Hu2EpqzpggND1vUbdBOnbcfFVmx5hPMs6EdAhqSGhbu2QZ9sw4V0x2d98G/3/fKIYRL/OcDoju5hpXADjMpWW7YfLu2OtDDAqFmtKj1C6uPUvSyi3c7g2gyPsrrlUXBGPg4LgMoF5iGtP7FGNBLdxoDnwelAHTY5z8zjM4jscGOgw==
Received: from JH0PR06MB6632.apcprd06.prod.outlook.com (2603:1096:990:3f::11)
 by SI3PR06MB8563.apcprd06.prod.outlook.com (2603:1096:4:2a5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Thu, 2 Apr
 2026 03:58:20 +0000
Received: from JH0PR06MB6632.apcprd06.prod.outlook.com
 ([fe80::4fa1:706f:f4e0:6bad]) by JH0PR06MB6632.apcprd06.prod.outlook.com
 ([fe80::4fa1:706f:f4e0:6bad%5]) with mapi id 15.20.9769.015; Thu, 2 Apr 2026
 03:58:20 +0000
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
Thread-Index: AQHcwk4ovnsz2XyP5062ISgM4oDFSLXLHgmAgAAG61M=
Date: Thu, 2 Apr 2026 03:58:20 +0000
Message-ID:
 <JH0PR06MB663286ADA4003A3F070C17D38951A@JH0PR06MB6632.apcprd06.prod.outlook.com>
References:
 <JH0PR06MB663236841A642C2D058C1FD28951A@JH0PR06MB6632.apcprd06.prod.outlook.com>
 <df2da2fb-c222-430e-83d6-1855ab34272d@linux.alibaba.com>
In-Reply-To: <df2da2fb-c222-430e-83d6-1855ab34272d@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: JH0PR06MB6632:EE_|SI3PR06MB8563:EE_
x-ms-office365-filtering-correlation-id: c835b4ba-bb1f-43e5-bd45-08de906c1478
x-ms-exchange-slblob-mailprops:
 F478AcySxEfD/A1IeZA0573Y5of9rszretrLmbJ7yLKrIIoSbpf3Z58UqxaCgE71PZJFcP+zCVJWVs5nrULilyFcDv6YyVo71KboK2XBw5I66ggFnreGu9/J+pF6v21PQfT1JMTOz11d8stlIy3TZvL6F+5tf9IKLeBGDEF/i6TPzZbxwkJ2+HlmTjx/u46SdpRfZjlUpNq1iVYcBm+4s9t1A3Ea6znlR4vl71vXgXm4Ou2HekV+05isY7zL80DTFovmdU8KJpcLdCuhxd03RqRCn849cst73eWxZ9fp8wLmoYXKiFyy9vC6FTu8Xls3ZkEsGWCxDaE30JmMP9TRKpP/bk9YwzqdwjXu/Xi/fsIDo3WhnVqKU+3ko3fxkh0wfQLxZlsYtf/gl751ClazZ4NNmygG0Z+BeujSUuTgSmUNZCNZuehk6LJQc7yThVk5AxyYO2UabUHTeuU1o5D36K+SlDeUpjxW9XsY3kRkI/XgM3gYwDGeBjokD5A2ExEbbt5mX9WRS+ipfC6jAlQzlIPN/CET6DAfFY8thxrZlRw67Yuem9dTa5AHet2iLBYdMyGxWJBtMw4y7VAEIIxu+aOsdgIqiPiPK82piPjRoawoYCoyA8NGb42L9MuB0Wkpath26ncUSnWr4MmWLaeWvL3L/EzoUsAnmdeBeiIbZQ083l6WscHPVpHWj3Rg5lwqhMryyFsC27Be64yLvZvCns18g8V6YNJIlPXGtr8UL/nf4D47tyLnLHAiUmH9gSRaEroeuOQB2ALR/BPZY+LqhbL91lxqsYBwOLV5OWxL32N9cVP7l6f/qNrKnkUBP9CBCnd1KyZOSMXZhtT6GmqDn4mKAt+SMcM/TY2K2DDn/AE=
x-microsoft-antispam:
 BCL:0;ARA:14566002|25031999004|19110799012|12121999013|15080799012|15030799006|8060799015|31061999003|51005399006|37011999003|41001999006|8062599012|461199028|102099032|1602099012|40105399003|26121999003|440099028|4302099013|3412199025|10035399007|11031999003|12091999003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?uncNH77yNmyi7uxna2CtsKjNI0LqeN1Hk4h+jnDfohqVHiGuukVC6gZ+GH?=
 =?iso-8859-1?Q?T8VD0HEzHwEnMdCSKXoMrrJjJWqMzT+wYvH5ErCOSCFo3kWucMIlf/qrHy?=
 =?iso-8859-1?Q?kGnEQdzqpSKtf+ltbN1v/R5KdO5Q5fiADHCzxKwiBGpyxhrizHByHK78Mw?=
 =?iso-8859-1?Q?aEH/VTDrSefaI+cFCUrKNAdpmrAtk1GPJ80n8upxAyzX5h8nIF7jf/xqiv?=
 =?iso-8859-1?Q?XxP9UkB4wzAjhRlKyHksyqTCk2Fa2boARYlF49CIERi/9f6uuGEIRdGKkm?=
 =?iso-8859-1?Q?ux9NcZ13DOPKByvmssEiWe5Kp8wLa0UoNIJrcv52oNp6FSQhyhicNcP8BF?=
 =?iso-8859-1?Q?0uEdeWvCU4zXqI5N19sR/W3f8KLf5OL4ZW0RZFPXDKDOMXO5TG+bulK72Z?=
 =?iso-8859-1?Q?IBEqNakhBYP4I7kOIQLfLbhshMrME/lfAKQqSaX1joLkLTDd5zb52eL+2u?=
 =?iso-8859-1?Q?ofCcAniBId24CxL1zhOggTVbqwUsZjy6yZcbsK069wytbfRGNfCzhf/ZDK?=
 =?iso-8859-1?Q?C7r8jHyiV3OFfCijg2bzu2bhPw50eo22xXeiSIowrV92O45x8NASRgzWu4?=
 =?iso-8859-1?Q?LxJpepvFpQtz0/jCSeBTvy+BT1xXclUxnb1+YCJed3+SB9dgVN65Tnr/Ai?=
 =?iso-8859-1?Q?xvXcuP8QEzikf2lM5/ghFFIvxP8+NrKOb2trDZ8qkNlHSSVLXwm3WhJkFb?=
 =?iso-8859-1?Q?qo6sOyp9d3ZDKOZX0JrS3kzKsIzhh3LN8UGuSYtxFz9bn8EGkFs9Yrd1kY?=
 =?iso-8859-1?Q?ua8Z/5bO8CpLBaxN5RSb0Fo19TN5sze3DkQhVpUI5Jqh4963Ll8vnOxUEm?=
 =?iso-8859-1?Q?hsdQVsDb18uLpfHPFWhG9ShovSV1ktfCkY6goD+NJhCxIePdtsyue520Ei?=
 =?iso-8859-1?Q?gvwbdnV0LEONa2zt14Qap3vNbh9NebB1olb53R/lwrDi7WvFJ9LyjmKwOu?=
 =?iso-8859-1?Q?4Q5M9Vi3Bazwwqu+JIJY1X1Aw7PD3DK+KcOOGamJ3xVzpby431gDUbKX/c?=
 =?iso-8859-1?Q?dAdrSBeN3BRmdVPpcwWBfFeH2Aai0jcP6gM1Ou4GsOrecC+6gGVOBsnwFR?=
 =?iso-8859-1?Q?SooIt0NZkQ5uvm3Tz6sOEHNkMkigBcNyEucwmmVU3zTs5/lAvkVat9uOE0?=
 =?iso-8859-1?Q?kpkQgSWTfS4ZdQpgNljpd8PgUzlYLUW+L8og2n2cmKdEXjOPlFEU660V6n?=
 =?iso-8859-1?Q?KNGLZbhDb4UBYiZyaRWmH6txRAMd+yrzYpeo9yychnFL3xpppPljGvpjMp?=
 =?iso-8859-1?Q?OS/uQ+rjpW6kdQQe/gUiMDJVW6Ht/1BDq1sUOwUiQ=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?R+vNO93q34jqpP6PJkb99LdikwDbB74vDaIV5ok0rtA1MGJR/t2om+yNN0?=
 =?iso-8859-1?Q?tY9fu7cP72IzT1XhiAxfnOlkJ4N5Dj2Se/g5u4t/ti1SiMSM62N83k0DlZ?=
 =?iso-8859-1?Q?gyCOKvLigvO1OrScx2f/kLw2U03ZteM2YqsFU4UOwwEBkCU89Njo1VH0e2?=
 =?iso-8859-1?Q?6T4A/Z6dhy0iihh9K7dQfsb4jpNK00i1fSiiqFy/4VCWG/AlHhViGMWV/V?=
 =?iso-8859-1?Q?JAtBWtr+YkuY9RbMWCp2GaQ+jawBE5LG7WoD8autgL6gTymrkvspwqXsRa?=
 =?iso-8859-1?Q?vTykUf4j2uL5SXl4DNXH1r+J4itMgLhQKY5a4Z1u79PvtRDs6WeZ9V9Js8?=
 =?iso-8859-1?Q?dKIORWC4ObsG7N5IBDUqeCOtoseTwyE+tZI9aXIN7tSDzKiJiDYTS8D74w?=
 =?iso-8859-1?Q?CQJk3K70vFH5RGwh2OxOgnm+uiA2sYBmo/GqoJ9H8rBHcRA2XQxz/jcOeD?=
 =?iso-8859-1?Q?WGv9ayilWso+mAlNLg2/WWAbXK0wgC8ip2nF9ELOJdMzVFte8FvoK5m9dz?=
 =?iso-8859-1?Q?+qtp2GliHqq3WElmmdtCer8en4/yTjLvKhPGpcGeuGjnKim7Z05eMlA6OM?=
 =?iso-8859-1?Q?yRepB3pjJST3G+lLdiaKEVg6qGDjuLaSYl5wmxpB6U8TKtv91n8pYKtiHH?=
 =?iso-8859-1?Q?i1o/as1YtODo9tVJ1FFKnE/6QZ/f8bNMguHLrH/Loiq+CJC8dAuC+1alrd?=
 =?iso-8859-1?Q?Ews7VFAZ+8QGJVz/k1rjKV79tIzGBgm4nI4Bx+QWCyJLYc/99tSwUaYlPh?=
 =?iso-8859-1?Q?qJ9/TEireAg5u2zQeGppSOkegDAKUrtX4b6qDMjG3/tgYdmK8n1ndxmiPO?=
 =?iso-8859-1?Q?JhBAYrd03OSxqj6PwXidQO1oFivfvY66NMnRdL6w92bdhOeCYP5zw+nq42?=
 =?iso-8859-1?Q?6UEhtD77nlfF8p4nDXTCSvXdm8iM7mwHDF+QOYR+HOsVjTq+JTzzMRzzZy?=
 =?iso-8859-1?Q?Sw6AEVJXqmUweZAmGb4HnWlN9pHj9SqHzq/7kcc7FFVQPqKxVoZYK3bfDh?=
 =?iso-8859-1?Q?CeaOs9FynLsTq4zqRZ1yA27dXTxtB+RvJMI+IT4xmsHnHzmeWNF/vcCgV/?=
 =?iso-8859-1?Q?QG0KF5KIc5yEBcLYm/nLD2Q19VN+fs3tRfr8r8GptKo2SL121KOUhNzWIO?=
 =?iso-8859-1?Q?UUiA1ryVXEISGjCEj6Ppba+TbHSXBxbhgNyuuVuZBQZBosRa8QASWUMU5J?=
 =?iso-8859-1?Q?F0HsVJDFTSCJP0stYSbVmey/iIcApXX5pZhYdNAkE1Rv8dh62cbqRWvXSl?=
 =?iso-8859-1?Q?+UBjoC42rhO/PfcLx90OSfTTeeYEZcak9+NlT/Uut5ohZDQ6b7uvcaIR6y?=
 =?iso-8859-1?Q?5u0ULpkLIbj+AVQl+MxEE8D2YhEgCC4DA6O0rF8i5+rDyC27OnYGMFs9nm?=
 =?iso-8859-1?Q?vMjjatec4LRHji/cfSyVQ13lcSJz5q6LipUBFQxUfY+4zUbF929FTEEIls?=
 =?iso-8859-1?Q?Tjd1fHxtxmNBuqtUPSWPaMeHv0HAQhxCfG9Fkw=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c835b4ba-bb1f-43e5-bd45-08de906c1478
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2026 03:58:20.7392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI3PR06MB8563


Well!!! outlook issues. I am resending it from gmail account using git send=
-email.
________________________________________
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Sent: Wednesday, April 1, 2026 8:32 PM
To: tejas bharambe <tejas.bharambe@outlook.com>
Cc: mark@fasheh.com <mark@fasheh.com>; jlbec@evilplan.org <jlbec@evilplan.o=
rg>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>; syzbot+a4=
9010a0e8fcdeea075f@syzkaller.appspotmail.com <syzbot+a49010a0e8fcdeea075f@s=
yzkaller.appspotmail.com>; ocfs2-devel@lists.linux.dev <ocfs2-devel@lists.l=
inux.dev>
Subject: Re: [PATCH v3] ocfs2: fix use-after-free in ocfs2_fault() when VM_=
FAULT_RETRY



On 4/2/26 11:10 AM, tejas bharambe wrote:
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
>  fs/ocfs2/mmap.c        |  6 +++---
>  fs/ocfs2/ocfs2_trace.h | 10 ++++------
>  2 files changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
> index 50e2faf64c..41c08c5a3d 100644
> --- a/fs/ocfs2/mmap.c
> +++ b/fs/ocfs2/mmap.c
> @@ -30,7 +30,7 @@
>
>  static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
>  {
> -     struct vm_area_struct *vma =3D vmf->vma;
> +     struct inode *inode =3D file_inode(vmf->vma->vm_file);
>       sigset_t oldset;
>       vm_fault_t ret;
>
> @@ -38,8 +38,8 @@ static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
>       ret =3D filemap_fault(vmf);
>       ocfs2_unblock_signals(&oldset);
>
> -     trace_ocfs2_fault(OCFS2_I(vma->vm_file->f_mapping->host)->ip_blkno,
> -     vma, vmf->page, vmf->pgoff);
> +     trace_ocfs2_fault(OCFS2_I(inode)->ip_blkno,
> +     vmf->page, vmf->pgoff);

Seems malformed?

>       return ret;
>  }
>
> diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
> index 4b32fb5658..6c2c97a980 100644
> --- a/fs/ocfs2/ocfs2_trace.h
> +++ b/fs/ocfs2/ocfs2_trace.h
> @@ -1246,22 +1246,20 @@ TRACE_EVENT(ocfs2_write_end_inline,
>
>  TRACE_EVENT(ocfs2_fault,
>       TP_PROTO(unsigned long long ino,
> -   void *area, void *page, unsigned long pgoff),
> -     TP_ARGS(ino, area, page, pgoff),
> +   void *page, unsigned long pgoff),
> +     TP_ARGS(ino, page, pgoff),
>       TP_STRUCT__entry(
>    __field(unsigned long long, ino)
> -  __field(void *, area)
>    __field(void *, page)
>    __field(unsigned long, pgoff)
>       ),
>       TP_fast_assign(
>    __entry->ino =3D ino;
> -  __entry->area =3D area;
>    __entry->page =3D page;
>    __entry->pgoff =3D pgoff;
>       ),
> -     TP_printk("%llu %p %p %lu",
> -    __entry->ino, __entry->area, __entry->page, __entry->pgoff)
> +     TP_printk("%llu %p %lu",
> +    __entry->ino, __entry->page, __entry->pgoff)

Ditto.

>  );
>
>  /* End of trace events for fs/ocfs2/mmap.c. */
> --
> 2.53.0
>
