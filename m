Received: from CP4P284CU005.outbound.protection.outlook.com (mail-brazilsouthazon11021120.outbound.protection.outlook.com [40.107.202.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5896236453
	for <ocfs2-devel@lists.linux.dev>; Wed,  7 Oct 2026 20:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.202.120
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791404215; cv=fail; b=iztq7xvWBkqiWKjP1J+9/IN6eAZYW57PGN5hP5t+TBKs+x52yg7VlkfdwyJjJj93nbcr0Zjs+IndBt6LHGkXmiMiQ3AsxIuuPjalFSj+g2gUwV519yBpG/eoZKSEgAezLi8Fzgo99qlrr9v01ayxrMiuVajjv8XKWZkyoFL1lwI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791404215; c=relaxed/simple;
	bh=5x30l09Rn1CgQflElyA8Yqt96jlvdJjaFNHLpDvpGSc=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=an5Qq+6MrJ3C+2t1udancaQqHD+jQiH53GsRcqlyTH4BnkNf1EP6LNFUrDwJhWJKVqshtQw7mfQFcIocS4EZ1Vmg3kMBI7WwPMytTWQHVSsEI0vtCjJ0hsY27/agLgVhW3yFgUUptFpklmJNzQOLpDRxsvwyOf6cudsdpPUWS7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=braza.com.br; spf=pass smtp.mailfrom=braza.com.br; dkim=pass (2048-bit key) header.d=braza.com.br header.i=@braza.com.br header.b=a51LyI16; arc=fail smtp.client-ip=40.107.202.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=braza.com.br
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=braza.com.br
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=braza.com.br header.i=@braza.com.br header.b="a51LyI16"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R+TvSWRf1nVIzx4twyiiXyvGCJ1vupIbWxCG7SFVnmX2H9kJpXsHGhFOxsz75tNFPX8qh7/P9P4R6RNVXfghHIEUOYcYGqEY6sqVhmc5cqxMsFxx+TWXk1EpeiVKuOgKDBdM06PWDnRIaJglWDflyDCNWYyT9f1HvIrUixZByfkY1uEigyQYKM9dwbD6ynKnD9F1m9AZN+wE23x6fgLFc7KqHbCXZ0bXIrF6LZuVoT3ahVrehxBTvQ70Bhj7jqR2ISaTWb4YDk7l6wmGyEbF7QDLSal/0R0RgeZZbXd0trTi0qFmRbXqNxrjC0pNwPSpfNqYwViIX5Bm+K5+k8WxtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5x30l09Rn1CgQflElyA8Yqt96jlvdJjaFNHLpDvpGSc=;
 b=XadJEmR4snChXuD3Mieg6BiwtCD3SFgJDjuI3AQKB2Eu741IwqbCClMkX5i0pCjKyEUh9cPfEtjd59kfD+WXNVAE1yrBl02vwTXjlJSk1l5JvKk50O/cZH6XtX1a+uWuOlck8pZT/kXYVfB2469lm3MBn67P1ntkl2tBiUbx2aDZVYJAAp/FhVoV2WlPdBWx+A09XFyWDJtYFcue6OX5dnWc37J3YUg0AZI3q6Qcf0kMbpTOqBVC6yV91gCK4ATKprBpxh5W53ng3uLeH9PkV9N7GkU0/f0mFT9cPINyUz+9glrbR9WLlZIaQinzuG6rej5OIBka+I2mp1iExe7S+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=braza.com.br; dmarc=pass action=none header.from=braza.com.br;
 dkim=pass header.d=braza.com.br; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=braza.com.br;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5x30l09Rn1CgQflElyA8Yqt96jlvdJjaFNHLpDvpGSc=;
 b=a51LyI16Pe0gfnnLPmJYl1ot0iI2d4f/gN7f+2bLxcQWj9fovK0dL5wX9YLc+g8UzlQ2VHuiYpiM3VUS7BIUJX/QTDzjBDqrj/GKBLpntkwSbaJi8WHC0Hh9VT3WH3/7kx3DEUmVgRbmUQMZnJerDshfWzmcFX2opY2qDOjvYIslznwiO/Mr1zdzk4PLlEuupRHbUZ9zU7SllZ79VhI3yl9QSFnZREY4npEGgYXATa2AHfrTPFE+GYXwGUjjKP88RD/Ce3gwei6PVrTvXfKyTFWxQl5mBjBYCKd+zazyY9h4Bv49gc2bihr3W3bM9LWPkiIllCdNelwpITSJMGknUg==
Received: from CP5P284MB2780.BRAP284.PROD.OUTLOOK.COM (2603:10d6:103:2a2::11)
 by CP9P284MB3595.BRAP284.PROD.OUTLOOK.COM (2603:10d6:103:381::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.16; Wed, 7 Oct
 2026 20:16:49 +0000
Received: from CP5P284MB2780.BRAP284.PROD.OUTLOOK.COM
 ([fe80::f8f5:4c39:3039:b3ca]) by CP5P284MB2780.BRAP284.PROD.OUTLOOK.COM
 ([fe80::f8f5:4c39:3039:b3ca%5]) with mapi id 15.21.0496.015; Wed, 7 Oct 2026
 20:16:49 +0000
From: Anderson Ferneda <anderson.ferneda@braza.com.br>
To: "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
Subject: ocfs2: lookup fails with ENOENT for filenames containing bytes >=
 0x80 on 6.12 (works on 6.1 and 4.9); readdir and debugfs.ocfs2 show entries
 correctly
Thread-Topic: ocfs2: lookup fails with ENOENT for filenames containing bytes
 >= 0x80 on 6.12 (works on 6.1 and 4.9); readdir and debugfs.ocfs2 show
 entries correctly
Thread-Index: AQHdVphf94sreNCJh0yBrgwdczAwFQ==
Date: Wed, 7 Oct 2026 20:16:49 +0000
Message-ID:
 <CP5P284MB2780AC2C3C2AB2CF2B6CB7AFBE942@CP5P284MB2780.BRAP284.PROD.OUTLOOK.COM>
Accept-Language: pt-BR, en-US
Content-Language: pt-BR
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=braza.com.br;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CP5P284MB2780:EE_|CP9P284MB3595:EE_
x-ms-office365-filtering-correlation-id: f486f2e6-6604-4fdf-85b1-08df24afeb28
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|6133799003|18002099003|10067099003|3023799007|38070700021|5023799004|56012099006;
x-microsoft-antispam-message-info:
 lIP/iNNWSiSti8o9RwsUJ3xQfkou6tUOCBr6HQzhpv6b/cWh+WYNO9IW70Q30a2lpRM6+MMkoeGoGHhyDTnQFC2of4qdh4Qdazd/W4vv+l+pj79e1xnZjMClk+G5PLANv9wMn5+knC/uUu11AhLSViGyXz1eW0xpLLsk3bMiLk+EFew+q2iYeBv1tjB0L1UG91Q6tUA18ECYa2qddKYgAlc2xKA9KgBm6ftsvLJWY6RRhe2BZRwp8Gr3wekY8N6Cfan7yB/JVuRVlSqZPeK67cdY/C2Q14A8213jMPvjAV+R3Hq8PH6pJHFgmoXfuOTNxjHrE5ulDz226fcB3O/JdbNdc/J0lEsznJObrhu7BgHo5a4CVBjWLHBx8rbL5Qw8mxLozP1+Y1igQLKGkAz/BLS7HgDJyfa0btmg/SPtj/kUfEhh6NzQ8y6yIDt+8Qrtcwhe1IlcqDgjWG3xhz+7/RO2BSrQZseDJFd6XKeEOpdQxQdmr0016+A/qMV6CXWHYbA9zzDGKakdTE3a2SjN+DnOpGCIl+15CQlwC0hBeHeJmqO8qP8P+0F9ChltXHyV73Jm0XAllOzZThFVTMRetIpOU5/OkUH3PULYGc6H0tQ5bFW/IxbURXr8qM8npLVLncf2Tqwnt1u/UyOgpxOuAnr1i8I430VZ/nX/UNISMqY=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CP5P284MB2780.BRAP284.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(6133799003)(18002099003)(10067099003)(3023799007)(38070700021)(5023799004)(56012099006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?wIvo8ZT0xI2nzc0tuygxtF/hXUjOg482YWVP21ymD2moM0r+Gs1QhqJqB9?=
 =?iso-8859-1?Q?aqxV5LSuzHKsO1xGOgt3gKVPjfueN0VkP0XiH0tU9DUB3rN/edYHFm1YNY?=
 =?iso-8859-1?Q?IemeA85KOO16BspIe5CADSgL+NcfgfL1f16UQvfeo2tJE/YLtn3CWX+HZe?=
 =?iso-8859-1?Q?UwQJD6T1/IrADcKQ7Z3QjzbyLllKxYVsya3WFrkBVKhIQ3NhXKeBLftaTs?=
 =?iso-8859-1?Q?B73rDEAiHxJ/pbhxDfHk3xNMLYbKlzSsegz14XU9xX6yaJfdRHy6TsL7WF?=
 =?iso-8859-1?Q?6GCPNN2JcbEdjOGuyFGLWcf1AmN+NYlbolydntVAnH7vLnJScZCdQCxQQL?=
 =?iso-8859-1?Q?LQipFY7NxC41KYP4cPywUs1w59TtRZhWvol97NB4ESDOudFdDEVwkSXaqL?=
 =?iso-8859-1?Q?y1u3XzYQU1G4P8AXaQamufQKtF3OKqLF/t+H1bhappMM9m2reSZ3nyn3RF?=
 =?iso-8859-1?Q?piTvyDQLIbWWXIhnSnn+7INBEDPD/2LbhzPlgYnp1f6efLmHLkODnIMfAc?=
 =?iso-8859-1?Q?42oorduXjdb8HQtyAfC75bJG5qx0IC7GfOuXR7nv8w11RQPpP011LFszO+?=
 =?iso-8859-1?Q?FzetcL5z6UpkXYNq++SXpasJKalr47Xzp2aYZggty0UGdzUYcshfvKxXCj?=
 =?iso-8859-1?Q?ODI4Z5a058c4DuYWQoguYLGYER4ztgkiHyQMCA9hUciRz2QFY733JzJk+A?=
 =?iso-8859-1?Q?I9GsKBMrzvqiKy2tbz9pwLLWYlcrFxGw45vNP0wAPrslHL+N6l2WsWlsUg?=
 =?iso-8859-1?Q?3iXIEtmSu8PSWotBWRNYmJlJ0d9VTYUbL7IntlR7r/0ZUryjE3sWZdjeNl?=
 =?iso-8859-1?Q?YZnmDceTJLrgf1EU6xDFJtkcohHml1c9qEEyECOe/IV7cQY/2MkNiWPDTW?=
 =?iso-8859-1?Q?vNomf48SxHL/ZpCP6GMURGPd1Qfu/erfkegcg4F1xPk+Swg6k7hykhIg51?=
 =?iso-8859-1?Q?V1t0XKI0eKE7fR1rNTKuPUcuhrxEI+Ja1psVUOEm2dTsGDdma4yuusOwVZ?=
 =?iso-8859-1?Q?6CIgNaFpm1NXk4UhXTAXKZmae4DxsQ2vG4HLJYI62LdHgPuNJ/6MbuM+rm?=
 =?iso-8859-1?Q?/CjFj+R53VIrY4IXQjXVUFqAvH4FnN9T2Via/gUz/SqQYVyxV1zbw2TVvt?=
 =?iso-8859-1?Q?sTZVmBoZlTsOatN8lmveHNG/mv4cb+QpwNXQlffvjPoi6i9tLopxtzjnVC?=
 =?iso-8859-1?Q?3T2xAvGtLuuJCU3D4QhpuvxNLK5XCzisqTWM3NS3S6fZsR0IbaXkeN7D3h?=
 =?iso-8859-1?Q?sG6Ha7Qk/8ZMJOKIj2RfAX26xe48YyBwqRFsP2KMC/+E/rXJVTDB+35rNC?=
 =?iso-8859-1?Q?2T7OkD2bBJgN3vh4yTeZCLCllhfEOThnQsqDG0odeOZURu3kClrrSFXx7r?=
 =?iso-8859-1?Q?nXfxM82UumYKfItZ6Wsk4i27EnH8nzzP0GtkPsFJ3296tZsdarVh31/R/i?=
 =?iso-8859-1?Q?gXcQZurYKKqH88y3zkAPEZTPQ7QxlICC9j5E/HkClSpyI5hrPwP6tx/Xxj?=
 =?iso-8859-1?Q?MKjsnpRsFiiC9H48UZ/1uG6O5kcUfRqG4axayuJmW7q+n+BVVO2NqBsUsx?=
 =?iso-8859-1?Q?kM3VINPqFB59Y2Nb82qJLYh9/O9ITVqnGK5wmarEjXZY5nubxyZMch89cz?=
 =?iso-8859-1?Q?42BqxkRbrZADsdS081zSyR3PrQAqJT/jbtQCv//t+cR4cg9yrFcKhlGHaw?=
 =?iso-8859-1?Q?eWLRIZGrpe0EusT6NfwkS6fbfgXOWTh1m8OgXuX0c3DkQ95YNUkPX8KyIb?=
 =?iso-8859-1?Q?UpChgpeqspWgL4pYfz8LktnYhWPdl4dU8fE4xYcm19qRLj9A6k5Kf3PdqU?=
 =?iso-8859-1?Q?KtzDt2/Lng=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: braza.com.br
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CP5P284MB2780.BRAP284.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f486f2e6-6604-4fdf-85b1-08df24afeb28
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2026 20:16:49.2780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8f8a6b12-17bb-41f8-8a27-70d4bd232428
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8OQkKMBQaH4IFdQzhTlz6IFbvIC5cAVtR8Qm/Nt7uLsHcxFTnskO2vZopfspbVmtxm1r8Cje7fSTH0ZJvEJiz6fSfs9bciigQIH4soONbCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CP9P284MB3595

Hi,=0A=
I'm seeing what looks like a regression (or an incompatibility) in ocfs2 lo=
okup on kernel 6.12 for filenames containing non-ASCII bytes. The same volu=
me works fine on older kernels.=0A=
SUMMARY=0A=
On a shared ocfs2 volume, files whose names contain bytes >=3D 0x80 (Latin-=
1 encoded names, e.g. "a\xe3o") are listed by readdir but cannot be looked =
up (stat/open/ls -l return ENOENT) on a node running kernel 6.12. ASCII-onl=
y names work normally. The same files are accessed without any problem from=
 nodes running older kernels.=0A=
ENVIRONMENT=0A=
Failing node: Debian 13 (trixie), kernel 6.12.111+deb13-amd64, x86_64, VMwa=
re guest, ocfs2-tools 1.8.8-3=0A=
Working nodes: Debian 12 (kernel 6.1.0-38) and Debian 9 (kernel 4.9.0-18), =
same volume, same cluster=0A=
Cluster stack: o2cb, mounted with "ordered data mode"=0A=
Storage: shared LUN via multipath, device-mapper device=0A=
Volume features (tunefs.ocfs2 -Q "%M %H=0A=
"):=0A=
backup-super strict-journal-super sparse extended-slotmap inline-data xattr=
 indexed-dirs refcount discontig-bg=0A=
The files were created over time by applications running on the older nodes=
 (names are in ISO-8859-1, not UTF-8; the kernel should treat them as opaqu=
e bytes).=0A=
SYMPTOMS=0A=
ls in the directory prints one error per affected file:=0A=
ls: cannot access 'Jo'$'\343''o ...': No such file or directory=0A=
and, without -l, lists the names correctly.=0A=
LC_ALL=3DC stat $'a\xe3o.xls' -> "No such file or directory"=0A=
Names with only ASCII characters in the same directory are fine.=0A=
Locale makes no difference (same result with LANG=3Den_US.UTF-8, LC_ALL=3DC=
 and POSIX).=0A=
No related errors in dmesg after the volume is mounted (the only errors wer=
e -107 from earlier mount attempts, before the o2cb port was opened in the =
firewall).=0A=
WHAT I HAVE RULED OUT=0A=
Locale/charset: the failure happens with LC_ALL=3DC and with raw byte names=
.=0A=
On-disk data: debugfs.ocfs2 run from the failing node ("ls -l <dir>") shows=
 all entries with correct names and inodes.=0A=
Name integrity: the same files copied via tar from a 6.1 node and extracted=
 on a local filesystem on the 6.12 node work fine.=0A=
Same volume on 6.1 and 4.9 kernels: all names resolve correctly.=0A=
Multipath/block layer: no I/O errors, and readdir returns the correct entri=
es from the same blocks.=0A=
HYPOTHESIS=0A=
Since the volume has indexed-dirs enabled, I suspect the directory index (d=
x) lookup, e.g. the name hash computation or comparison for bytes >=3D 0x80=
, behaves differently on 6.12 than on older kernels, so the index lookup mi=
sses entries that the linear readdir finds. I have not looked at the code o=
r bisected this, so this is only a guess.=0A=
QUESTIONS=0A=
Is this a known issue or a known change in dx hash / lookup handling betwee=
n 6.1 and 6.12?=0A=
Is there something I can run (debugfs.ocfs2 commands, tracing) to confirm w=
hether the index lookup is what fails?=0A=
Is it safe to assume that a 6.12 node must not write to directories contain=
ing such names while other nodes run older kernels?=0A=
I can provide more output (debugfs.ocfs2 stat of the directory, dx root inf=
o, kernel config) and test patches or other kernel versions if useful.=0A=
Thanks,=0A=
=0A=
Anderson Ferneda=0A=
Analista de Infraestrutura=0A=
#somosbraza #daquipromundo =0A=
=0A=
=0A=
=0A=
=0A=
anderson.ferneda@braza.com.br=0A=
www.braza.com.br=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=A0=0A=
Confidencialidade. As mensagens e informa=E7=F5es trocadas, enviadas e ou r=
ecebidas por meio deste e-mail s=E3o todas de car=E1ter confidencial, inclu=
indo seus anexos.=0A=
 Seus conte=FAdos s=E3o restritos ao(s) destinat=E1rio(s) da(s) mensagem(ns=
). Caso voc=EA tenha recebido esta mensagem por engano, queira, por favor, =
retorn=E1-la ao remetente e delet=E1-la de seus arquivos, de forma permanen=
te. Qualquer uso n=E3o autorizado, replica=E7=E3o=0A=
 ou dissemina=E7=E3o desta mensagem, total ou parcial, =E9 expressamente pr=
oibido, sendo pass=EDvel de responsabiliza=E7=E3o nos termos da lei.=0A=
=0A=
=0A=
