Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazolkn19012062.outbound.protection.outlook.com [52.103.66.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DD233ADA9
	for <ocfs2-devel@lists.linux.dev>; Wed,  8 Apr 2026 03:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.66.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775620224; cv=fail; b=rfqUXP09fHyxbdYbxt/y44RwY94UM9fwyslY82ok5TWyJtGLDln1P2n/KIpB2M7pUEz8DzBBu+kXWB+YhqF+K4mjjuAc4DAp+fG3BU074LrxqoUHDNsFHaUAWk/rRuJHB1KI3rBWE0QS+upopfzXeXF6OBB7dx9cIsKN+JoqvHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775620224; c=relaxed/simple;
	bh=Xxef5uB9w3oyiE/xlAZIjL/aj1hLkv3JcSmW4r1PJNs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CZteip3BnQcqFq5WxlZAj5s8ic+/RNJDRidchdxGLPOxrJIA3NOcjkibZmOazyxwdWR1HEbG5ZKbDs1VCbK5ibb8CkjXWU1zJIENgvCPfaouUMpcMXx51w8V0+yxOi3zl8dU4zP/18FIQQU4ATJIXekHDdBmDdwNk4al15SE928=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=UeH03qFu; arc=fail smtp.client-ip=52.103.66.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="UeH03qFu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MPS/PusLqnJTK6sawn+6ZzsD1E/LJz5YNnqoZuTPGzWnPD+C2iNR4dFnnAYjV3D7mkueeyHinvInHv5M4bEfajxJ/Yla3bQ/cQK77RDTt0j4iOpq5sikB6kk1KhsT1JFqTgeaQ7nGPzbMLd2wvpkB1Q/rBNPNpnSzCKpuMFCS8sOQJsH2Pf/QxvrlOyfx+a1Iax5GqzOURWYxtLMdo1SlTAXbUdrBeXNme7joK/Au2yOGPttr0CnrCX8Q9JwicNWtZa+tb1a2YZO5mRvX/QrFouwSK1KYkjQwKVvHEe5ERCeFPn6RHQF47/D+j5wUXLX2wEAzVUaQg59RL9oOfLG+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=780gFnrW5wDym6wHom4UpokvF6zOlbePbui2Q7Tv/hs=;
 b=l4Z1nF7/QLch4H7suNQZWq17RXSbyw19QkDwoikKv2OXFt9uw8fLcBJhObWfu5oVjlmMrWT8neyYsbrJpyAWFh5LfcTGAwdxu9RU54QqJlvuw1re+/kQYnawLiE1avAPigIk16xFLxHGqtghaXMUmqjGUYRNv5vnvzpAKU1Nog4bzYPWIet31C9JTPfu+TfATX0fY2+dluHCSXRCXMs22axB2IEiLou8vmGQU9Q9rcHMI03A3RXARZq+xor3e4m+JzVOemW07xy3kuYo40E6cO5+1DeBujWJxYtrSW2HVx269QqwSU8Z6aGA+xU9Q15pa3w8+DRHI90wZoK+v+Dtvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=780gFnrW5wDym6wHom4UpokvF6zOlbePbui2Q7Tv/hs=;
 b=UeH03qFuPvu31FUscvDhY7AuViAbKLUS3njddZ5+WtSPRJeLfoJewjbw79xmLKSf4OKvZ315DSgyhKCErZMeWy+mdH1ImpLjvFdZIk5slvLb/dyKiaD7A7OdUNKyJGKjyE4xZKIITkcDth499NKT79dfyEBlxUc31z3K04esL9Y7XiJVfJc8y8Pn5EoZEhd/uyQQ5c2DvsKN5pRDGMiPlsgMBtXmEkD3NTxzzzLb96zOkvk1p5SAnNsKPP814KAiSp74AdRYWQsGHXiIhVvoUm1rK7ZngMCdYhwOlplVpjDXgzWCFHD0rqjqX/sEyvvZyWCetQ4cXmh7V/5l11pTxg==
Received: from JH0PR06MB6632.apcprd06.prod.outlook.com (2603:1096:990:3f::11)
 by SEZPR06MB5440.apcprd06.prod.outlook.com (2603:1096:101:ce::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.16; Wed, 8 Apr
 2026 03:50:18 +0000
Received: from JH0PR06MB6632.apcprd06.prod.outlook.com
 ([fe80::4fa1:706f:f4e0:6bad]) by JH0PR06MB6632.apcprd06.prod.outlook.com
 ([fe80::4fa1:706f:f4e0:6bad%5]) with mapi id 15.20.9769.020; Wed, 8 Apr 2026
 03:50:17 +0000
From: tejas bharambe <tejas.bharambe@outlook.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejas Bharambe <thbharam@gmail.com>, "ocfs2-devel@lists.linux.dev"
	<ocfs2-devel@lists.linux.dev>, "mark@fasheh.com" <mark@fasheh.com>,
	"jlbec@evilplan.org" <jlbec@evilplan.org>, "joseph.qi@linux.alibaba.com"
	<joseph.qi@linux.alibaba.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
	"syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com"
	<syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
Thread-Topic: [PATCH v4] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
Thread-Index: AQHcwx17cmhMfo3kA0mL+J1eeqhSmbXNujuAgAHl5amAAAYXAIAE5zpn
Date: Wed, 8 Apr 2026 03:50:17 +0000
Message-ID:
 <JH0PR06MB6632F1A4381AB798FED980CE895BA@JH0PR06MB6632.apcprd06.prod.outlook.com>
References: <20260403035333.136824-1-tejas.bharambe@outlook.com>
	<20260403122947.2afc337b5333fb1990a78a65@linux-foundation.org>
	<JH0PR06MB66320ABCFAD8F239FE5112B2895CA@JH0PR06MB6632.apcprd06.prod.outlook.com>
 <20260404175040.40a746040ddb0cb5ce347fe3@linux-foundation.org>
In-Reply-To: <20260404175040.40a746040ddb0cb5ce347fe3@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: JH0PR06MB6632:EE_|SEZPR06MB5440:EE_
x-ms-office365-filtering-correlation-id: d9f85966-aca6-4af4-70d3-08de9521f2e6
x-ms-exchange-slblob-mailprops:
 ZOmchpTZWj7EiqO5sUxnwxQJEzYxLB6hpdz5OqKnE4mwatCPwsHIN/UjuqrZBUPfI4vgov08ftVtn8JUaLNGbck+NbIzcYr6yOxNk6SfCDdxgZmxwFmhijxBMJlXCvnYoyje0GcmHJGcy+f3/Q1WlHyE34ui4PZhkj6mOUMWtzOBr1TuvJU0lQFGM4WzOXQ0aiRxxx8wpQdeHideLWURHhHhJtyDYBg4ttx2KbNbiWTSvEPuawXusq7SCzXpcBYZbUOHP3FlLiS9d4v7NS76MwMpOw2rlTuWYdIyHF1cmLqrTjOej9rO+QdFwceVTFjC4i4wHua5MceCawPPikOB6zTcVMsNKMfmgRlOyXy67gOndnZQbXh7PadBFcHiy/LNF9UIKaW9vGGGd7q/YHT/XladYHjsG+wTP1V8j4maGM3b5jhKTlfXs3oxlGVfeq1jgXmZKU40d3PV1o5y5WbMCxa7iuf9alkMbUX70NTkshyYyftEWscXHTsgrDEIdcGipx3yEyN1iUK0JKl4x2VJ8Yju0HDo2OTCXniRyp6XSnFNbnjq4qJuJq+IrU8FCbItJj/j6HiD5TQFscTEXXeDUQI704aTt8uOU9U7WCKbfmjPrMSMMevNU0uc4H9+FRDbVnE0GYwjl8ABoc+qmmHSnMTTXqk0NPNqkoRhdwbj8lTU/7g6tJVbNl6cTJKATH9ZxbGRcrXTH9w4dDYkaf2XxzDkRznYrY3/ATPltyVfBDxPEPcZmVIgm84DQj9uDPxD+ahhjZav7TRzfyvJQAch51NiqOw2TfKlV1fFg61NIucv1z4D5PDCT6zjDSNyr5hqAg80qEML+6zRTc+mWEPTJW6roRyr0C7jxtuIXk4mZJWVtko2+HRjG67SNTLs6HKBQFfc/8ne0Eg=
x-microsoft-antispam:
 BCL:0;ARA:14566002|8060799015|37011999003|51005399006|15030799006|15080799012|461199028|31061999003|19110799012|8062599012|25031999004|102099032|40105399003|1602099012|26121999003|3412199025|4302099013|10035399007|440099028|11031999003|12091999003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?9Oz64RnHmgFbUIg1DYBzd2eimGQrhRq3HW0nFguBgEAzZFQTcPuqvxeRjs?=
 =?iso-8859-1?Q?xQK2kmNRuwM0sw6oFZPrlqWQvVpqHW/mvJOtcWgpgtlb0S1uOuebMnLjUE?=
 =?iso-8859-1?Q?ZjRZPo0sHmo6sO1MBoSlQjuOaKsAaKHYLxgyC3+U/jgh8m3kzyw8+kVBab?=
 =?iso-8859-1?Q?gHLND4G64Py9oOgOqWkDeSkpTUmjzQvb4Zkij4DiTseJmWfJaeqoelbP7d?=
 =?iso-8859-1?Q?GtdpMJyeTnPoynQKIvZfttzWu4KdGGHySPDC7+GbV3o0WSmIO3J799mzE+?=
 =?iso-8859-1?Q?YxPo+DjQWnljV3n9JzpPQ4pmdbcLv6YpAgQPPvVGFoa/+pmOGycohg4dkQ?=
 =?iso-8859-1?Q?D0PZEetv+AGJwcG72FqXYF9+iwcPKhNmh8nq0LvdLGgJ36BfL1tGxZzVWU?=
 =?iso-8859-1?Q?yU9P8ZLfLWflYcrESsHWxZmGC+r8th4QelycZEo5deZExlIJiuy1oH+XoH?=
 =?iso-8859-1?Q?bizPs3c2ktzd8oGgsYkf/VJcTthTq3Mzk+OewtX/DfKFmL76TcJh2Va+at?=
 =?iso-8859-1?Q?rQSavNXh84gXUtESqH8d3ZbNxSPQBsp1stCJ36wdo+3nQc6nKrzrDMi9CF?=
 =?iso-8859-1?Q?JBbGrmURWy4WwLPXdVbRhFfbHvQRtMIi02RFUzLYd0d5xCo6H3ljF5dCIQ?=
 =?iso-8859-1?Q?ddwxM0JhORCjHTZd3S2FTfayNisqlWbZE/fbBtYVCmO66+O3/IHMD6o8yt?=
 =?iso-8859-1?Q?qDhOM3Aj4IH+KKAXVObZ/ReAnR4ybn0B/8ryTfOaV1Ae96kgb7idKoi5nx?=
 =?iso-8859-1?Q?VKa8kXfhYedyTiQ0TZXBpBhU2vKQ26d0NK732Srd/JaYeaI6VwwwHsjdzj?=
 =?iso-8859-1?Q?okPgn9RuhJ+i+VMVtjDFfPWrUT9ezfZ5wcLLGOVosLkPr5qMRr2GvBsjom?=
 =?iso-8859-1?Q?uep1+2xjGEycdxxNzYS34z4351zDVZGCjLg2YFWZ4qW0qeat4bx8N6DsHU?=
 =?iso-8859-1?Q?MGsevJyVk+BOrCTjoMq2HLQI/dkEIAPiGOI3W1kE6xiMNELWylR6ka6eH/?=
 =?iso-8859-1?Q?beN0QZ3cGEi5hTOPsYaXbTh1OwduGBO1Bhw5O67A0bTvPPf9dWroGvD0c9?=
 =?iso-8859-1?Q?cmXc+x+/NO7TofLo104D7qugR8L0LJlETOTVtVOo+hevTxOvA/PMg/LxhP?=
 =?iso-8859-1?Q?vJE6Dz64Ks6/LDSbNkbHGIHDyWuNFC01DUI8AehHuxlIENdHPmcmkiw+BK?=
 =?iso-8859-1?Q?AGMR1S3mkySlJpP5AuIL4gxBlD1cfMiCfNI=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?h1hBEmJILiJk5um5OcdMz8TtFkkR6fJdYStAnYA2lXw2AI8Mr3F9RBjFdP?=
 =?iso-8859-1?Q?l8L0QIlqHqJrmBghJoUxel8BLAFnPJSKZCPI9FnO6heydZ2NfakYPHSmru?=
 =?iso-8859-1?Q?6+/0AJrNTjRC79WaDHHeHit+d9UPwM8sqjgUi20fWBiP4R5Y7ukUZXsfg5?=
 =?iso-8859-1?Q?bDac5R8or26j/ZU3q9fYse5ufo2C0a9KUwR14ULIoAL1vFHUX884oDsjYr?=
 =?iso-8859-1?Q?sOJzcBO9BzGIEkQtVOtxr5CWtKzsP5CZtFjlAN/c9uvyowvpJkjMLfnwaz?=
 =?iso-8859-1?Q?bjxRb9hYkkxWqcQmd83irf7PMIP/gaMwWabzx6b9OQffnXr5EfgHUS5TQb?=
 =?iso-8859-1?Q?Wfn+oao6APmyyiopJtx01JWp2sEs66OIXeSvR7G5/PMGj8qxy2zv7v26Xi?=
 =?iso-8859-1?Q?+GVnIqAW2vC6MOrol+vODV4B8nMjqpjCfTg4iApjLdjw0aWQMSetlak2eg?=
 =?iso-8859-1?Q?TuwMqJ5z5Oi+kzs+wR/v8L/0k+91SLhMqKs4fHH/fLqU6ndm9PBKu6QbC7?=
 =?iso-8859-1?Q?ror/693FO4uPpJwzgixlfI+ufCt/Ww7aBliZYlFEfZG9P/R4oHRPGA7SEs?=
 =?iso-8859-1?Q?nj26S/Mvg8KmpPzssod+tnPj9knQ1xy8QeMSSCZGWZo1mLd2fyBFWMunoo?=
 =?iso-8859-1?Q?wefWniiwL7kKhUdyL1slBWyWiqeP08Ld5G8VahrDiQnuNMSUJ6c6QgYwZ0?=
 =?iso-8859-1?Q?2SnxQX2UPJKC35G4mg1DknYJ/leWYuU80iak+/UIt4EFL8yR6L4DvJ5boq?=
 =?iso-8859-1?Q?F66+CL8BcGOnESfpR/SolaeT6AfrBtCrG3Kj3zDjZk613HcQEDjjjjrAWm?=
 =?iso-8859-1?Q?GwXC7EYFdswDaOZUOtH7kVhH/aPMXwL7Ad2XCa7+wwrfIIn2RSybsbO+T2?=
 =?iso-8859-1?Q?HuBwOXzy7YeDLeCAZiVIlvHhWXl2mCBMytJUObOQFSqLDNod6DSs0hIH7w?=
 =?iso-8859-1?Q?iGCPIqHdbCyJtaTyoU8laGIhD3zyJKNMkrCc3tkk2Vaph/cWDmJcXRFHv6?=
 =?iso-8859-1?Q?a3YuIqYt2Eb8dAZFLQWSyTV/nUaSLrJ8ZSim51iX4cyf9FtGyF3KX4M594?=
 =?iso-8859-1?Q?hC0h+zpUJj/lj8JPSKnacU28tMWgWuiCpnMxPJLfE4t74xVxauDTiofQK4?=
 =?iso-8859-1?Q?lV8ZQt41mJkIxgRV7EQLszn+VbUOwiOtS6/lVBanBgBQ1hlhzt6H3iCua1?=
 =?iso-8859-1?Q?CoT+UTed0i2L5ihGfaxCf2QdLj2WB+x2zTmVEnbXD7HEdkrqzkr7ffD4kF?=
 =?iso-8859-1?Q?c5kEEDfNj0/tqAFaWUJNDt/BozMYBMlLOk0j+82e7ZQjRZiOg0c9KYbsDh?=
 =?iso-8859-1?Q?+YH1HKj2LAmYO5nuryuUIuCi3b/XoINQu5Cr849byyTpfcJLuX4sIKddBb?=
 =?iso-8859-1?Q?IesLb29keI/xw2+OqixyYD8r4oC1R23RbEqSRIP6UDmKOWC7HBhFyDth84?=
 =?iso-8859-1?Q?Jb2eYmuqrt0f71OqmJD87KdwWjEjwM9bTZCzkA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d9f85966-aca6-4af4-70d3-08de9521f2e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2026 03:50:17.4398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB5440

Hi Andrew,

You're right, I missed that scenario.

The inode can be freed if the file descriptor is closed after mmap() and mu=
nmap() races with the fault handler.

I can do one of the following:
1. I can skip the trace firing when VM_FAULT_RETRY is set as I did in v1. I=
t was changed to v4 after Joseph's suggestion to keep traces.
2. If we want to keep traces, we can use ihold()/iput() as shown below:

ihold(inode);   //pin inode
ret =3D filemap_fault(vmf);
trace_ocfs2_fault(OCFS2_I(inode)->ip_blkno, ...);  // safe, refcount held
iput(inode);  //release inode


Which approach do you prefer?

Thanks,
Tejas
________________________________________
From: Andrew Morton <akpm@linux-foundation.org>
Sent: Saturday, April 4, 2026 5:50 PM
To: tejas bharambe <tejas.bharambe@outlook.com>
Cc: Tejas Bharambe <thbharam@gmail.com>; ocfs2-devel@lists.linux.dev <ocfs2=
-devel@lists.linux.dev>; mark@fasheh.com <mark@fasheh.com>; jlbec@evilplan.=
org <jlbec@evilplan.org>; joseph.qi@linux.alibaba.com <joseph.qi@linux.alib=
aba.com>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>; syzb=
ot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com <syzbot+a49010a0e8fcdeea0=
75f@syzkaller.appspotmail.com>; stable@vger.kernel.org <stable@vger.kernel.=
org>
Subject: Re: [PATCH v4] ocfs2: fix use-after-free in ocfs2_fault() when VM_=
FAULT_RETRY

On Sun, 5 Apr 2026 00:30:14 +0000 tejas bharambe <tejas.bharambe@outlook.co=
m> wrote:

> Following is my response for question posted on https://sashiko.dev/#/pat=
chset/20260403035333.136824-1-tejas.bharambe%40outlook.com
>
>
> No. For ocfs2_fault() to be executing, the file must be open and
> the process holds an active file descriptor. The inode's lifetime
> is tied to the file's reference count, which remains held by the
> file descriptor for the duration of the fault handler. munmap()
> can free the VMA (decrementing vm_file's refcount) but cannot
> free the inode as long as the file descriptor is open. The faulting
> thread cannot call close() while it is inside the fault handler,
> so the inode is guaranteed to outlive the trace call.

I don't think that's the scenario which Sashiko is suggesting.

Suppose userspace does

        fd =3D open(...);
        p =3D mmap(fd, ...);
        close(fd);

Now, that mmap is the only ref against fd.

Now, suppose that userspace does munmap() while another thread is in
the fault handler.
