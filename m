Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012049.outbound.protection.outlook.com [52.103.43.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C10158DA3
	for <ocfs2-devel@lists.linux.dev>; Sun,  5 Apr 2026 00:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775349022; cv=fail; b=UXL4m34dqCFKjghng5yITx4Ml0XEMLpSuS1Rr6xqcZQgl/BICGYZ2coLWFOf+d70DT2qVGM6itMkc97o62vfIz43pBOmGG7HPyl9QQOZEz9LiVTqakpabVutqyk+/DXvio2nU3C5tH2jCVrfYjto9rgZXJFKhB+PKNkpmh1K5jY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775349022; c=relaxed/simple;
	bh=DV0wzPYUlbfVp8ZzdnidWyvf/tEaY1sC4ChJ8FQyyaQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aBf2LOCFGuL7b/Lg8IfktpRr2wBd/qPqI4yd0NvrY+/vgJiURAn1WihHBINY900g82f7sAmkzVEGs6EbPnXzck+tbrDnDaesDYwdP/o0f5YZsS9HiQNErACKf5O4gfgypB1j/xFTqGK00QI24uUZV2UvdyK8WO9nkqf5d1JtmdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=ZOTu3oKR; arc=fail smtp.client-ip=52.103.43.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="ZOTu3oKR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oTtqQm4zH57NTTtWU2RBRRW43gQPwu4KxuM/UveX55y9t/aFxDElVV7rA+r+9cMk4WtUbx2j0OlCl1idmVnut8ob1LpSgdixr1oLM/ruMjtdgKdriZWEoWlL9ezAaFYX7DsSp4zBnLrbirkrKplJreqsajN8xSIzawMiKOM2KMCFFABsf3NDYbh6RBqpG3mZ3i+obgkWK0suVyGipQMPEWIj6KLsHm3+SFMRGCESov3hcLtOO9xPSJqf76+TVot5bOLjduMnmnUfKxmk+n2Oq0xafkLbyR7d+1aIbElrE85n/PaWfGLNOEiqL9vogBPxevVp+qSxf8TmWUEIB6Rg1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YtJCB0A+cHdlDA2gKwi3TEfrDb5i6alqqEPEioLPFyE=;
 b=nC/rxL4XJG7QStOqrNl5YPASHQu+5aO5dPNoudOPN9dFi0Qa/cYDjZOhw9ibK7wzLCmVP3uV+xk2SIfhRbgM8M7WWeJHHsb2Ofgn5TKaBlSSpiEVzfsYiph0HaafPXKVL2wFM3WDUSgFXhMaDEbp/jrrHqljR/MGuTkrpCUIU3n4gTH/6NgsbG87DBMXmeLmoWjmnobSg6j+bOA5rt7XjBay+efEPweIrhWdQGX0mN3ERDR2c+NLwqLD4+aUevWzb73dD9KH/vTshlB4WJSJbCJOSlb4shysgRot7yCgxW870/OaQs8Ox1KL9mf2ZXEp0+Mf6KIkqqR6Tn2JpTKrTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YtJCB0A+cHdlDA2gKwi3TEfrDb5i6alqqEPEioLPFyE=;
 b=ZOTu3oKRS28+CmCuOg1dzDGn0jnRqI3SK5CYW7FCTvc1HIxGuOhVwXVq58eO4BWXLODjnhcsmpyaNqmhO7s8SnYPkzpo0N1y1zxd9gA9Qi61lsljFZGGe4zW4D4KgyKZj+OtOAg7EgiusoCzLuRIPH/fWwoBaNUfgubiNpKpFJ2nn9Ol8Cm6WRDVjP1b7UmwWCQ8A9Srh1amupcPRMvzS3B9xvYE3ez5j6QldSxjMS9B9RRt/8r08nXB5HxPDyCvC5WK+kuvsgQR2S8PlO1QTxJc5CM87D/ozmp2vwcxAnT8I/Vy6QyD62SYsQ4MfDRjsAxySeT2nJQt2ZzgqSFaTg==
Received: from JH0PR06MB6632.apcprd06.prod.outlook.com (2603:1096:990:3f::11)
 by SI3PR06MB8635.apcprd06.prod.outlook.com (2603:1096:4:2a2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.21; Sun, 5 Apr
 2026 00:30:15 +0000
Received: from JH0PR06MB6632.apcprd06.prod.outlook.com
 ([fe80::4fa1:706f:f4e0:6bad]) by JH0PR06MB6632.apcprd06.prod.outlook.com
 ([fe80::4fa1:706f:f4e0:6bad%5]) with mapi id 15.20.9769.020; Sun, 5 Apr 2026
 00:30:15 +0000
From: tejas bharambe <tejas.bharambe@outlook.com>
To: Andrew Morton <akpm@linux-foundation.org>, Tejas Bharambe
	<thbharam@gmail.com>
CC: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
	"mark@fasheh.com" <mark@fasheh.com>, "jlbec@evilplan.org"
	<jlbec@evilplan.org>, "joseph.qi@linux.alibaba.com"
	<joseph.qi@linux.alibaba.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
	"syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com"
	<syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
Thread-Topic: [PATCH v4] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
Thread-Index: AQHcwx17cmhMfo3kA0mL+J1eeqhSmbXNujuAgAHl5ak=
Date: Sun, 5 Apr 2026 00:30:14 +0000
Message-ID:
 <JH0PR06MB66320ABCFAD8F239FE5112B2895CA@JH0PR06MB6632.apcprd06.prod.outlook.com>
References: <20260403035333.136824-1-tejas.bharambe@outlook.com>
 <20260403122947.2afc337b5333fb1990a78a65@linux-foundation.org>
In-Reply-To: <20260403122947.2afc337b5333fb1990a78a65@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: JH0PR06MB6632:EE_|SI3PR06MB8635:EE_
x-ms-office365-filtering-correlation-id: 3592a29c-ed07-4a67-4e55-08de92aa815b
x-ms-exchange-slblob-mailprops:
 f3ElpFvzDvbd+xQ5tkgEernUWapCSLIAkorE0XDEEWP+CayG2k0BTHoeiHmKEUu3esgbkq6Muvs6JHvnv5zRUD4CuQlR8ofzmNC8m85+ikG45Xg2uXJTo8DarRkHqJDzhmpShdyVmY+dWrkxs8MQMA0Ji07E6AuOl5HMQGVGdZsEoddYs+anxEGfyV1Mmx+m3WOOm6dobMpQXtx+1RQuaoESK+R7vMdTpC0P4oa7WliKDbG4aOkShRjyqq584hHUW3gkBJBkUlcwo9/jKN9kMF/fcckfZjuCRX2Mm3twV5EauXOW6zfL0M0GJ29VucR8EoC2xXQHf4UzzOHm9kKqwfrmi5MQC3i55k5WxLQQaAckXEkxqAIGUm5r7tL4S1TnEfDctAz/TYVMF4FuyiFK29L66WuSQR4HvEFqeMuQvslbfsdzTzdaSrLPwtGT9TuA6O/3J+vpZTdzf09IU2TVYtgMC+R0Eko+rXaMMFB9opHknIszD9XAtpC5kKuapYh5QP4oaLmi/WahV1K/Z6eicSWpArhOImrOyZfp6W2RcAh5+APBYWKw+ECZ1P/V4XoJ8p/v/Eu/pPGbnGpZ3ye3yAGpCwrllYoLBn4PDIeB5lfdvlAfeb64bSMEKM90pvP1Pifv6PdqbMB0zcpREtNcW0chfi5J4v4K6Txh+CVxT9s5AP2d8HCz5cZrIUsiXuAdBxOIy6icwDj4bzn/WYJp2RYL31ykuw2e5WTDNwsKSe2scOvs626YwB7JfTzozjvYNC4KEIoRtrViMffMTexe2BMqG5fGCdNX+z67ZxFsZwhQLOax59+jFIlXiriYTpGmBDhdzPMA6Wl02mfjjZeH9fw3NXtAF6LmxzEbZAE3/+qyHaF6gWOKYDDg8zKOb91IgmUcVwrg1Aw=
x-microsoft-antispam:
 BCL:0;ARA:14566002|41001999006|51005399006|19110799012|31061999003|25031999004|37011999003|15080799012|461199028|8062599012|8060799015|15030799006|10035399007|1602099012|40105399003|3412199025|440099028|4302099013|102099032|11031999003|12091999003|26121999003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?RER3/w8qOVunpA1JgcdggUU8xoD0rQsBksLLAt/N4jRv+3sYveGk+yeYLn?=
 =?iso-8859-1?Q?vIUHniX0XQKAhjICOEfJpVLV51jFnHnsKU7udosHDgcSzsi69cUNCkdKob?=
 =?iso-8859-1?Q?zziqLssPtxj0K12JCjiLU3zTtZP2NjyLA6Db1eZomgDlVRk22/IoIyT82U?=
 =?iso-8859-1?Q?Rd+db71dx0Gz/XzdF4ShnXJdgDskrjTeICyNMqtnVvZUapvbsR2abtS3rW?=
 =?iso-8859-1?Q?IJVfvI7EhWiSm80UxP49rjsT64xlK9tzuGVjAoD5MZXp9Is0vMe05nasMH?=
 =?iso-8859-1?Q?eLpH9mjizTJ7mA2Zt+kqmtgVyUSyuBPydNEoc9mXqlglg4C1lpFKNXYXXo?=
 =?iso-8859-1?Q?cT6AdtiUBukmoVM2BfzNneA61Fv53DBQEUglKi8nHn1u5zE1V7RT278LfG?=
 =?iso-8859-1?Q?RRcbKStBEAMqMRM/9IfhQLi7udF1ZUc6ILBRxG+xzFqDGHxEfO1bNj7wpM?=
 =?iso-8859-1?Q?o1PiI8nB2CKgqOg8mMg43Qv6/cEXBg53A8qMmUvlC54/Fvm0lbZrKA2Gnt?=
 =?iso-8859-1?Q?YiURT3vle19hofaQANALnfQm8Z6f93xVe2/wqNPY24UJ9x6kQitiiLuyOC?=
 =?iso-8859-1?Q?R7IGqBMrFOPEuUDnem97fEp5HZFQOTF1YqgAhrWKGkShmZEUXk0auW81MB?=
 =?iso-8859-1?Q?rcMnKLqCg7qa5LTBTFCd2NiJ2tB7tKhAg1PHf1baJExuvhx5axmFxw+T+7?=
 =?iso-8859-1?Q?HuQKrVLG/LQkv7G1BaJLtmrG9B7udZiwbx3mw8a1DiY+1+fLPlMOUfbyHT?=
 =?iso-8859-1?Q?11QUz9J6rMDqPBSLGriXCtq38DKCOK6xdQmEpgUEp8nPNr0IN/Uk4qskWA?=
 =?iso-8859-1?Q?t3YZ3D94Fbe88e6hCY51C1u2uLSdp0w/3h67ieyZ3Hxn2n55lN0b/3KHtR?=
 =?iso-8859-1?Q?HALF/yc5ka/1G3bhqzK3mBvnKxoXsLgfzx5AtgJc8MMVIU6eicwFoD5U9q?=
 =?iso-8859-1?Q?a8qdspjE+dXZQMIiQxtprQWNrDJrhNVKMf9xuxnhWbAsVLL7HVikQ+zTxU?=
 =?iso-8859-1?Q?f2+iEfTzShrD6T2mMybSxlm2Nvica07FoB3sWi7IWturHMZjTsK835Kb1+?=
 =?iso-8859-1?Q?THjpkzvBec2bWLb/w7SWRN9A0uV4MQYKtlQx+FVtbhpixzVqAjoVpaFdn9?=
 =?iso-8859-1?Q?Erv9zCuft+VcXInIhv2wNVtpnWcyIBmvC1kWCzyWmrDrcgP8EXKDWc93pE?=
 =?iso-8859-1?Q?kX3veJFrIwpYpz7X1WIaTY3hJ9/lEIFSg8eaum92foFfK2WCmQQHMhH87r?=
 =?iso-8859-1?Q?Clm3ubVg6nPeTirXEnfA=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?LMITae5Ix2QU7oanMKLlQ0Fa8NHYpKErOrt2UZeGaju/G/H2Ufxleqldxa?=
 =?iso-8859-1?Q?mjcSQGvODjM+ttUXtMr1E9EyoaxygJIHOLMiSHqu63TtU7xj4KgrSU2ljC?=
 =?iso-8859-1?Q?pa0CiikTlsZ0MJwbRgsb8rVYP2A/WDZvsX5U2KcMSQ1187+jWCuBUoMdH6?=
 =?iso-8859-1?Q?PirfoVklKgtM8mEnWx1y69CicvKSrUOmLLpDAr4wImc2Pk54JbW/T8ijF6?=
 =?iso-8859-1?Q?eTNqCKbENt8mc/1fwFSUn7bozwm2vTa+BC/txcm0Ra30NhkPA6eQbXvcHL?=
 =?iso-8859-1?Q?bPHKQBCvR1Sz2HrVlaDLrwd5JHhpW5Ks1SMjen4poA5E0X+dCX2vsjsGrZ?=
 =?iso-8859-1?Q?ZeZ8S/DQZeFFTQ4c5p5m4JNuxs6qRZ05wZbg+htWJFzl6TRmhS26Jxji3D?=
 =?iso-8859-1?Q?hLih/s9Ithm3uFZP66HigGqKZvbWuY25DEt9Q2ENT9JTcz4B4u6C5vOHJF?=
 =?iso-8859-1?Q?FbbsJK2WMIvAmarpTdKoQeAN8Br1/MQRNi+YDN2DmRWHOrI2dwVuxRPrzE?=
 =?iso-8859-1?Q?kZpqG0cxGsi2yqOnuMeZlwBX1+jlRNpXLiiI8p7QB7EhjcVmuubc3M1KZD?=
 =?iso-8859-1?Q?e+L6bVqDrqGySuPqaZZCovAXaZ8nZDQl7JkGJg7re5fpzNQq6qi0UU4Hmv?=
 =?iso-8859-1?Q?iTW1h8tGgaSXXZYGojq8VgAq8EC3zR1WNSU/KKN6BafnxVIQccmZ8VRlvV?=
 =?iso-8859-1?Q?Sx/t4x2xf4wJnWP4B6V7a6BYTOCD6TMgPFN0qomZ4hyq1KlZCtgsTT8eEZ?=
 =?iso-8859-1?Q?WpIIayJZWr7KRy3PM/OibrUzYgPvE4iL6GsctOs3GHjqSkVAsgfeCskRhy?=
 =?iso-8859-1?Q?VXwcg3XnqHG70Pg6/HBWuK5Hh8HcldELLk1sS8njUtYdfhSpm3w25JbEbn?=
 =?iso-8859-1?Q?huL+OXTRQNHK1KEhe40rGkhMPGV6vk4IPCzfAxBd2OEHnVDb+yzBW0JtfM?=
 =?iso-8859-1?Q?UWp04pFL5D3Ecy3m0T9yJas604V8lBAIHXky38L001otbSSX7tdP6P5WzC?=
 =?iso-8859-1?Q?1lQocY1bksaJT6wRIlYSnHIuIvMfyDiypTlpmH3NktETXQfA8rt82USk8P?=
 =?iso-8859-1?Q?cnE50LM+EeobbqzMK2f1qy1nYzs3hYgngeKD/Sc52i3SpixOx/0D9iouHy?=
 =?iso-8859-1?Q?bqB2/Dsnr2zeX866qgfTnHcEo2/eB3enSnC2xPY6Wmk5BFxMI76O2OtK+M?=
 =?iso-8859-1?Q?GAIA1wDPQva5+VsFeqEniAGUsdWgDWGRsCqc1qP5XPKSpwu3NLV4X0CMNn?=
 =?iso-8859-1?Q?W0QcUSxtUc/0tjOXv/IhlcBNxeRxD7KGam/k3DWwG8NaKy/g9bF9H1F+tI?=
 =?iso-8859-1?Q?xJE12yBiu86Ii7IwnSXy/7+QrlBzKrpU5eE8dRfUGamsn42A+NTSCn5PAN?=
 =?iso-8859-1?Q?K3fwGSOfdHYPTh3YVRBeGU1lQYd5uNXJaccjMkIT3YUnLcgGsRq+7fyYvm?=
 =?iso-8859-1?Q?IY26WV5U6q2u6Q8kfqM68nxz4YCGUiK98YSKmQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3592a29c-ed07-4a67-4e55-08de92aa815b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2026 00:30:14.5213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI3PR06MB8635

Following is my response for question posted on https://sashiko.dev/#/patch=
set/20260403035333.136824-1-tejas.bharambe%40outlook.com


No. For ocfs2_fault() to be executing, the file must be open and
the process holds an active file descriptor. The inode's lifetime
is tied to the file's reference count, which remains held by the
file descriptor for the duration of the fault handler. munmap()
can free the VMA (decrementing vm_file's refcount) but cannot
free the inode as long as the file descriptor is open. The faulting
thread cannot call close() while it is inside the fault handler,
so the inode is guaranteed to outlive the trace call.

________________________________________
From: Andrew Morton <akpm@linux-foundation.org>
Sent: Friday, April 3, 2026 12:29 PM
To: Tejas Bharambe <thbharam@gmail.com>
Cc: ocfs2-devel@lists.linux.dev <ocfs2-devel@lists.linux.dev>; mark@fasheh.=
com <mark@fasheh.com>; jlbec@evilplan.org <jlbec@evilplan.org>; joseph.qi@l=
inux.alibaba.com <joseph.qi@linux.alibaba.com>; linux-kernel@vger.kernel.or=
g <linux-kernel@vger.kernel.org>; syzbot+a49010a0e8fcdeea075f@syzkaller.app=
spotmail.com <syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>; Tejas=
 Bharambe <tejas.bharambe@outlook.com>; stable@vger.kernel.org <stable@vger=
.kernel.org>
Subject: Re: [PATCH v4] ocfs2: fix use-after-free in ocfs2_fault() when VM_=
FAULT_RETRY

On Thu,  2 Apr 2026 20:53:33 -0700 Tejas Bharambe <thbharam@gmail.com> wrot=
e:

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

There's one question from the Sashiko AI reviewbot:
        https://sashiko.dev/#/patchset/20260403035333.136824-1-tejas.bharam=
be@outlook.com
