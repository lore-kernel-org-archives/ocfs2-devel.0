Received: from SY8PR01CU002.outbound.protection.outlook.com (mail-australiaeastazolkn19010022.outbound.protection.outlook.com [52.103.72.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E61535B655
	for <ocfs2-devel@lists.linux.dev>; Wed, 18 Mar 2026 05:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773811079; cv=fail; b=q+9LswvWKnKwihPy+Hko4+zrpeJhCVshkopeDMM7sf2deGid69MVYk+PHK8+NXo/9+Q7aLmWB4pnjS++zH1AJ9wBhWLLpnvKVCzB4KiHTy2qNlnEVJs9gJ1CVQ9MSxOmK8s+C9sn0m9Th1nO9CnXusDHx+ROB6JxShwzepx8sOw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773811079; c=relaxed/simple;
	bh=cYroNgJFyUjMzRPlgvtDw4BJoV2gWZZcSkA6whtKoK0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D5r9kx0+l7PlVoCAVNmEQ7pfyijpns8pAgcu3uxiPbAYvYCU4BOSD4rZAu0b+JfwhO4elwDW24vd8lmjZ58jnFEqiNKXHJeZRXYxQ1MLwpX/PPSLtp+qmGRoeNLaTftVYucusW6s2Hwwz0/QdewAIIT+S9dv9LJoPmAWhPB0Cg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=WUoEyDDS; arc=fail smtp.client-ip=52.103.72.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="WUoEyDDS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=peb0CV1G9R1N8aK6MlgpoDfCpwO76FwAjPtetibLuXB8wv9dKBuAADE4itXFb1ADqswemIEPNQBfaB9AAH8s1KfOZhI3jQVN2ZxVz9MXgaQTHyPy2LkoSJCmN+gxKWFUobHbFlgk2Qe1nkCi8hRQucHAy1QUa4bM0nSItBEBkijc5tfdgsy4f6Uj1iadFh1Ks0OhIF0JCnipE+MusFDf8nWN1uzp/23I+aCwqEprf3bo8FEye6NjixJTQYD37UK/AaI7FtUX4Yeryb98zk3G/adjaS8rKS2JRHUpTluYds+smQ/l0GaNfTTR6/H8DIE3BT6WPO0/snKD6GlxskIz1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GKwnZrleGZMQU55yr4NB0Jtrrue2LBN+eumm6STS9zc=;
 b=SPT/GgsxOUOezOQwTmFBhxO4XBEMoKZCrKPqV9IzzuqvAyT8TES5m25yOEX/QEpYi0OzkeGmrBjdNqgYHySqqEOxjLYHGXZcc4fPrKj96la2p3g0d9kZW0rp67d/iX9YLR5Ig7jceN5Lyzwg0JvM9Ruq13SG/1BEtK3pvzvLEN2zKYYtxjkpNhi1ffGwDEMKb72CnP8WHS5v9gM8l45dmDcX6+oZBU3fui9mfhAVe9trSgHX2AR0Iyi7NfzzQgxqNFwI9a8zK48jsJQ/GsblHZUOMBaNrL4PMFRIa9h6dnqbdM+j/E8hX1ecL4NupqzfEQzP6uER5Z6fjP+3+A0TCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GKwnZrleGZMQU55yr4NB0Jtrrue2LBN+eumm6STS9zc=;
 b=WUoEyDDSTE05eXlWqQsFz3TKuWlT1tqm8LJrEAbYpal78oOc8H6CW2nNQ1n4RYdF3yDV/rplrU+v4YEfmo8ZLaTpxhr5rTUYa8PWPjv9wOC42wnXxzBk1vzINJTmkBZTrmL53Y/lOzRI6LvUqDr12swPjzGqztQspD+ILJOMrjzz8KXowt9oW/JS0WWlpodv5hLI6ZtHgVaDAVgBv9Th/fQ4K/GOQYShn1dh9hASbZS8ibV+XJXzJM3Rqs2pOHakNc51zML/rnQfzh4E6VVIbpAPT1DOmOYg3mAQ69/DJb9+gHXrTQUefD0stmpAPlbNZf7f6+Tuz6HlvmWtZw6sYg==
Received: from SY4PR01MB7891.ausprd01.prod.outlook.com (2603:10c6:10:1b6::13)
 by ME0PR01MB9557.ausprd01.prod.outlook.com (2603:10c6:220:247::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 05:17:51 +0000
Received: from SY4PR01MB7891.ausprd01.prod.outlook.com
 ([fe80::e18d:343d:d2fe:878f]) by SY4PR01MB7891.ausprd01.prod.outlook.com
 ([fe80::e18d:343d:d2fe:878f%4]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 05:17:51 +0000
From: Junrui Luo <moonafterrain@outlook.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
CC: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, Yuhao Jiang
	<danisjiang@gmail.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker
	<jlbec@evilplan.org>, Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [PATCH] ocfs2/dlm: validate message payload length in query
 handlers
Thread-Topic: [PATCH] ocfs2/dlm: validate message payload length in query
 handlers
Thread-Index: AQHcsgeHVCMlWUSnGEi+e5NnEXCxVbWyrUkAgAEbsQA=
Date: Wed, 18 Mar 2026 05:17:50 +0000
Message-ID: <FC8B38A7-B251-4AB8-AC5D-B1352A1961A9@outlook.com>
References:
 <SYBPR01MB7881890B57945C79BC03F31EAF44A@SYBPR01MB7881.ausprd01.prod.outlook.com>
 <a7f7510b-652c-414b-a530-3aeda945c74a@linux.alibaba.com>
In-Reply-To: <a7f7510b-652c-414b-a530-3aeda945c74a@linux.alibaba.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SY4PR01MB7891:EE_|ME0PR01MB9557:EE_
x-ms-office365-filtering-correlation-id: 60ba860f-c89d-423f-22d5-08de84adb39d
x-microsoft-antispam:
 BCL:0;ARA:14566002|24121999003|22091999003|8060799015|8062599012|19110799012|8022599003|31061999003|461199028|15080799012|12121999013|3412199025|440099028|102099032;
x-microsoft-antispam-message-info:
	=?us-ascii?Q?U8YGa+kO21aMi2rglV2imA4CsZolQxa4rCsWTFZIMFbVqrkCg1k6/2hSdt0r?=
 =?us-ascii?Q?hrEvknNYz5aHCrrSVB5hQqlJT+0qKKJMj74V34G9BrPmtViuiPKMLPZEJ2vg?=
 =?us-ascii?Q?vPtGGflvn+TkVeg55xAQB2rSijec2cBOlnBKOQcEKF2AzOL4O4r0YZbuPJm+?=
 =?us-ascii?Q?VDxbEqxcNH4mNMi7M3XJ7XPCq4jp+KEbnlIPxab1LEt3l5u8YNx0Fyv3N0ev?=
 =?us-ascii?Q?t2uciqQILv9HH07qAT7cIpaxtmbw88A+GpXUme3e1XV1HCyt3kjGalQ+2sX+?=
 =?us-ascii?Q?eZbUZkuynk7Oz/yBiuau9VFVBitG5Brq6+/XPawjfjOGVfMdXN++6jePafkU?=
 =?us-ascii?Q?wlViGEqsLo5TjeGHWp+oKtQ3frp1x5zOLIBRVeVWbJfhlkELZrLvz9eHsFoq?=
 =?us-ascii?Q?i9DftXyy60eBjI18D/kZX22LwV/ybtNLLRM8C0MvB3CQb39kf2wTrqHwHWwv?=
 =?us-ascii?Q?cgPw1UFTEgiy7ukxQ4ivkglawxw1cWwMVdwm5njnliwZcdRIpA1wiG17Zr6G?=
 =?us-ascii?Q?Q2nE+Txj7meL7YBoaFiS6aq5fhnIyr/doQXtJwU2GDWWxAeSKzb3Ind2ttUC?=
 =?us-ascii?Q?2HdcCNGLE0z3OO6aYWNdJLGubB6F1wR4KVEc73g8ZYnXMGkWOtWUcssiQdtB?=
 =?us-ascii?Q?eTc3Rqpu+P6Hn1pXjJjNykbTE77zIO+dcsU1lKzbzASw0CKrUiMADs9GpTvX?=
 =?us-ascii?Q?Qpju7MSxiIq9iomDJ77+IFhJ37Mtu1282e8WqvSBcl36DXHeXeFGUO8c+Wg2?=
 =?us-ascii?Q?bcjmJjhUrtpfqhDDu2W0b8AEp6lSlYTzSeznqhRX8IBJRCp0t0XFag6RlyRh?=
 =?us-ascii?Q?InU2J1r+4iq0YzLfkN8Np0oddZNS1Bm72SKzZnmyJM3jhztVkBKPJuPD+sLL?=
 =?us-ascii?Q?9rsGYXX8YXwZKnAbGOvtRwqDr4p4U3++YEB0tLqqzgmDV0XbG272dk2PKL9y?=
 =?us-ascii?Q?5UcMTshMjgGeSeJX8QpvPw=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?XFqDVxgi3W72hBgm3RH7Qek6KKEtBXzThZAwVYxsP9WG0OmLea/ynaEppiTY?=
 =?us-ascii?Q?ae0oIvE1Pp7jtkyJTxn88/nrQHHgjb63dtHG3NpuuzsA8JZtGBYMQ/q1+tlU?=
 =?us-ascii?Q?STENEV8xegOaNhM8LtX/p6VBiF69ePuwtzkEtx18h0jvQ2CFIxlKp6KnuH2I?=
 =?us-ascii?Q?0nhTq8jICt0RLgMSuGVobBV06bLWCZ/N6o3HBA57HcRw5W9NvJUZiBndlcPG?=
 =?us-ascii?Q?vajbImer9UQyNv2u/DgkX48V2GRZrNuPDtHw8glD7S4ZM75YAwvAfjWXOfv7?=
 =?us-ascii?Q?Oz/wZPxWudt+EJCTytohMWSFp0iDKmdl8jixpN69FbvWlDVVRogl7YbwDUr4?=
 =?us-ascii?Q?qasQaSoCNf0GY87Bn1YkWyL8S+QTCrlBs099efF0iViPfidYfkrlNOk/ZwOX?=
 =?us-ascii?Q?DEEonHg2C5ohvsSKGu4cNOC3fd5qzqCsumb8AhRV7iiKtWTzpv6UTMjnoaSV?=
 =?us-ascii?Q?zq7m6/dDl68dTIiGbmUhCjmiXB0bs5JyOTecOeA+A1LJEBjQM7ubY8HCTdoF?=
 =?us-ascii?Q?zlOPHF6oT/l03WLk7Xm6A2807KAIhOZJA8kHfLd30GED6MZ3vJH2ij/qA0MD?=
 =?us-ascii?Q?MiCUmMlLojJvy977fyMOXgCMepdmSTRC/75sFtxTG6Ls+KWeolhxVIWaWNwh?=
 =?us-ascii?Q?Wviy89UJC4YHAzkesDK2WzUgmk5Nc/lbTOawQe/Y42HdiSvZ+cCg52jQz6Eg?=
 =?us-ascii?Q?yZZrRQfOit8e9H0bdTxO9eT1eY4kqcXQOuPlWurS9zs9NV/MNYLMC5zqZMHs?=
 =?us-ascii?Q?oE1uADv3o9oMLlKehnG1TJMR8omQJpX3H2z+TtH2AEYw1wWb4qLC+Ym1uTbB?=
 =?us-ascii?Q?NUcH30D77qr3mOVlzZpJbqnB4qgRbArWC9es8atDTW71MmCviiaWAKOfUsVY?=
 =?us-ascii?Q?1CDvsiDfN0WX65YHonKJKLynvNt9Czor8XSTF2DneCnAvsx3N+ozcdRHzt3b?=
 =?us-ascii?Q?krdh2KcOnOQRrKaR8hbl920dqbGH/mPFRIOneJ8Nz93W0y2NDZLGv6Yf6NB2?=
 =?us-ascii?Q?vUMNRnDMVmF0uD+xHGWqR1BhHjLG1fLKB4cqeS/T0RH5MMRLpvmFjhyUQ0XY?=
 =?us-ascii?Q?DQZv3MpznraB/NMY7HvDRi7YUG0jpwx1gXTdpAztop+Ab56iH97vMQRrRgC3?=
 =?us-ascii?Q?JM+ac/mVhGhBb1W8OBh9oSpWHedIpjlgmM0da2D6D6gzthzg3SN7FFXtWW8C?=
 =?us-ascii?Q?TYx8cfdFGh5KApmaG+mQ1d2KXlLocRKjtNE+PK6ZUS6oyuOsZbC9gP97F6PU?=
 =?us-ascii?Q?UDILFpZI2EeogueQKqgLQ+J4iWKsqB+g6+mbEvH/UjB/POdr/fpk9vIGQHt9?=
 =?us-ascii?Q?ZtZJzHrH1C0Oy+0z3z7Cr+310KWTt5IRBCuUMtZajZOILwCvNijadvA5t6Pp?=
 =?us-ascii?Q?calGWgT80tthoBtpNPIaU1tYZN8RboSwrIx7HtScGUGjN5F3dw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0E618F7353F1594CA5E1294A9EBAC00A@ausprd01.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SY4PR01MB7891.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 60ba860f-c89d-423f-22d5-08de84adb39d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2026 05:17:51.0170
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ME0PR01MB9557

On Tue, Mar 17, 2026 at 08:22:08PM +0800, Joseph Qi wrote:
> OCFS2 is always deployed in trusted network.
> So if not considering defensive programming, how does it happen in real
> environment?

I agree that OCFS2 clusters are typically deployed in trusted
networks, and this is not about a malicious attacker scenario.
It won't happen under normal operation.

There is a similar pattern in fs/dlm/midcomms.c:

	if (len < sizeof(struct dlm_message)) {

I was wondering if it would make sense to add a similar check in
OCFS2 as well?

Thanks,
Junrui Luo

