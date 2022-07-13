Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8248C433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed, 13 Jul 2022 11:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5PUDGw1oGiuvU5ojKolHBhdO26OdJD6rQslKk1glDWY=;
 b=DE+GeRXsYKO6rsVQLKgLCjOeF0QGZfbtuUzGkDAT/z75z8wM16RQzRTPM3cxBYD60Eabpj8heK6r
   3SEPE9AKw/s315bC3jLUIfpPtxu+QN8NmC+CStFI5JY2134DXIt/WT768Mz7owSGYY6+R4hZI5M0
   8oFHpoutum6oRypopINcOMvxYHYA3cH4VZrTOI1ShOBMd5P31HLad6Pbm+6viUvSQA3JPvMRRNeV
   2OCRiCb5cthpT/EGnyU2QhywtB6z5OdZjLFmVdpUHjDYaujKxk1VRKcL0CK6ALmXYrT+xDxIgdS0
   V3oNjL/rLoUjUe0Cq7oJ6vp7NH3LLHXzIJR91A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5PUDGw1oGiuvU5ojKolHBhdO26OdJD6rQslKk1glDWY=;
 b=MgM+3HkLJsjWVJjVu1EZxX0zbFBTREwXnjAaraEQL5Qehdvo63SU4Y+W1NqCbBLdKwi+IEKRWH5+
   Ed6uIvZG5FMbewAlB9fbM/4oiTPiepiyFDspBlvfL8YKFouFp8ZXNp/MmEKIYPUdi27cPE6toxOx
   oCUcgFKBxtOiNonW8bpEkrARv/W/ZFgAGHLJE3cLfV2+DBRMLS78iAdqcGS4mUlyFumsmUL5pJsu
   yugd8pYdX5vjOda9LsDWBieS015Y57Z1fSIfR7156ZBkAOUqKB3gW1F35JEgfEXnxdH85QJkj0fx
   MGu0PWwiIiXEnNnROK4MC3n3ZjWpG7iWu2YSuw==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220603 64bit (built Jun  3
 2022))
 with ESMTPS id <0REY00AYGHM5J210@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 13 Jul 2022 11:08:29 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=wdc.com; i=@wdc.com;
 q=dns/txt; s=dkim.wdc.com; t=1657697273; x=1689233273;
 h=from:to:cc:subject:date:message-id:references:
 content-transfer-encoding:mime-version;
 bh=/kMW6ONtDBqoSd7W/iLPpOsHAIliObM5Zf0xwkGrEac=;
 b=QvsfyDqPS4E0cgdjOYOvN3DO/GW1J3jgCJrFZiOlRT9GOLUofB46UAH7
 uSVFouzFqp/vN+LCkvwvdX7ytEXS+q7v9TCWkyNga18LM77P6Xy8ygwev
 /NethS7ALQ2so71w+KhBfxiZVTIONpHfDEQpPUk6RvwkdwKICQmNujjVR
 LkQ/1uisfY4ynKO5SjktM9g3oM4EKWa7BhpZZmy9y/ozAwtF0WZ4GRzuu
 G6Ekg8pcif+ZDB452N6XK6FPjFa23ZbgmwHAJBZ9uVLotwq1TL/ovGMEn
 Nkb3TpLa3kBwJl4O/TWzumjyyOuQy4x3qPzSTqRdB0wwMiDF0I6eAHx7M w==;
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJ2cWGb1PMHfIkefC8PlapLmobkb5ZQqID98TDq2Rx4O4kEukKu92QIyHLZiuAFH/u+PH/ft6wgRRfRJP7oxxCd1SmcTx2EhI2ToCCraK98QWtDemdPNRGGgJfZcYNAC89VnX0QD9WqAZNFy4KZnqTMoELct8VlBWfsZJ1Zu+aHD5R5YXZnoHATS5kQdcy25zMgWqxHpOplHsi8lTIp4whfX9YRiKGxcSTEvly709A+th3SHtlh6tOBGBYcmHXzL+FWuJJdPmqItD3hbs0ChjdCB7kGuijsJWDgnV2eGeYM6QpVCayAiDBsxnWp9hG0uDhuxe9f/tm9Cud8A2dsdmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/kMW6ONtDBqoSd7W/iLPpOsHAIliObM5Zf0xwkGrEac=;
 b=MDQvzwnJ5XvoeEOP/fFuI1zGKn4l8V9BbbjpuOco6W2RLqPz+dc9x/wf5xaED0nKg+fEA+aN1sYJvo8/dLgtP82/EXZG0aGm90lMqQhe7WqyiTnFsS4o7GSq2PZfUn43hucUuQjUw1WGJ6x8CskRxIn62TaRxldKM2BCIJajNI+aYsuM6A59a3aBLayzB+En+XugisPwvxtbAK9nhn9a3uXRhTgZLb+oLd4pBxjFxPpvQqjApDbouEuVXNgffMp2iQlodFCnicvLz/6X9/E1ya8tZ1zskBULj1YzzyynfqHKvMlFIEzyb0b8e3RS1b7adcXnpSSijb424ga0Df/RbQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/kMW6ONtDBqoSd7W/iLPpOsHAIliObM5Zf0xwkGrEac=;
 b=Tm/Bub9PDzQA9j2DbaH6JTqbFjqUvYJoYsarq14QWgUoPlFTLkJRG0RS9ZkgIoQnGGJYVBBG/08iilhJzWmbHXijsA45Zr6Z9+cvidmKzBuwI430E2NjCV1gpUPfSBaQasgtdcShDv+aGvqcktr8p+3KJsuxRA1HxOZd5xQ/G2Q=
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-topic: remove bdevname
Thread-index: AQHYlnzqMl5ChJweqEC+p/d22IGEHQ==
Date: Wed, 13 Jul 2022 07:27:47 +0000
Message-id:
 <PH0PR04MB74168A262A3A77D111C21B5D9B899@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220713055317.1888500-1-hch@lst.de>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach:
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(52536014)(4270600006)(33656002)(8936002)(19618925003)(558084003)(2906002)(64756008)(8676002)(55016003)(5660300002)(86362001)(110136005)(66556008)(91956017)(7416002)(66476007)(316002)(54906003)(4326008)(186003)(26005)(66946007)(122000001)(7116003)(76116006)(478600001)(41300700001)(82960400001)(3480700007)(71200400001)(38100700002)(6506007)(66446008)(38070700005)(7696005)(9686003); DIR:OUT; SFP:1102;
MIME-version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 07:27:47.9693 (UTC)
X-Source-IP: 216.71.154.42
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10406
 signatures=596000
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
 mlxscore=0 clxscore=182 lowpriorityscore=0 bulkscore=0 spamscore=0
 suspectscore=0 impostorscore=0 adultscore=0 phishscore=0 malwarescore=0
 mlxlogscore=601 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130030 domainage_hfrom=11016
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Theodore Ts'o <tytso@mit.edu>, Song Liu <song@kernel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 =?iso-8859-1?Q?Christoph_B=F6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
 Jack Wang <jinpu.wang@ionos.com>,
 "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
 "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>
Subject: Re: [Ocfs2-devel] remove bdevname
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Johannes Thumshirn via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-IronPort-AV: E=Sophos;i="5.92,267,1650902400"; d="scan'208";a="204216987"
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83e20a89-8b28-44f8-85e5-08da64a12fc0
x-ms-traffictypediagnostic: CY4PR0401MB3588:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 74QtiK2VztPyb+2yguS0HZ6jxKV62fTo3E7PygBFrfxeyY4F8W7CKaTcqTVS4HcO0+RVSjWbSEWQtx6+Eeh4isAtG/TjmCbsCF6TWKlrJhOl4qkx77K4h9ILqEgJdQAhPVydWuJx1ZsXsVZlpQ6Lz+kNzWkwIhcqKijWiWzX/NQzY7QWrA752ZJyVim98tDhD7neU/5fNPOF+YeTZhTxTOGF5LMtHijk6BeliBmx38Yk+xP7OwaliACCnXnstrxsJFoBG+eCzEQH6s7yQoGszRof6Eki7pE80fR8gqJ8eh3RCx0ExRI46tkHw5P3Y9e3rlESDDCo/HsJZJ2nYQlEnhLYoHvs168sr+P3Uri1TJVF1nzxjlLcglwf57PJv4f5tIIGALJxyNsiaRnxWr6FmV0wb9umlUKFuFW2UuFTpt7JQqteWBy5UhGVJqk888yR+PoJzshkc35eDtL5e7PkVOrRd8Pn77T5MgjMZD/A0ADImi3ml2QR/ih5swe+8QWX1gmuQkPBU8WGVMYD7qvtaZhDJcv/b2tjGPs3SUp0nZx9De1bARprZHoNP6Mew9OA6gGX5GSyawSOWY71aNyUMv/lX8Y0SWfdFEk9gGO4i+4rC2IhmjbXegR1oakfWdN7EmznZGHCrJja/QN4MnM5u7hiNAsJQ23qy6Y+FFM+TJXJ+gCQZqznAbPPsOkUAqfk6eYLf6QX3GROzhMnv718AU3nvZRCo4cJeI5nJ8SAhYaYwPw7GFn/GFgwTaZLrKOykkOsoL8sgBSOPGJ3xcMYxmhmcni3ysuJEf0aQfhZehGyUcr9fCT72GQCPluJsatT
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?3NdEf3BkWP4mPQ2KR0lCV9HNC8EhII1+/cneh4Y7+O9d14AG13/dLZpoq7?=
 =?iso-8859-1?Q?EBBJMXi9NXp/SkoUK9xpAp92jHZtRoxQs842PMjt8svbdzxpzi76RClRUH?=
 =?iso-8859-1?Q?Ofq14zTqNQ3GZW89G/Vqxcpe5Qz0pH6zUQUHyEdk+1giqEJB1ZdmSWmWPu?=
 =?iso-8859-1?Q?wek51Bd89QGBPHc9TuGqT7IBC6qauBn6XlD4sv3jREDL2Za7umQSXR4l9X?=
 =?iso-8859-1?Q?3PKbrumA7NtI7TPM/51j51ZG007gp38erZ702cyjvJTO0V3PUp4rPRbk3Y?=
 =?iso-8859-1?Q?qORajEkPZurJyKISPwij4zGpOpjLYgpppwxmh3E40lZGN9MkAEoSTd5SZc?=
 =?iso-8859-1?Q?G6nOZCIDyQWMJWRiVBEnNJoRyRwIxPOfP+F6Nf/cLgMoRP64HHumjuokKM?=
 =?iso-8859-1?Q?Dwy2Gyt0qbifvuDPyAcg36eIu251hfDpB7hugi03NkbhGOL3NLKcYJSn49?=
 =?iso-8859-1?Q?z4byfM05bnuAOS+d6jy5FBtTdm+G9VzZYIUhWkp89EsZaZbyc4o6hp3gOD?=
 =?iso-8859-1?Q?jeQzJA0pG7oqDudky7Q5j/kDYl3TzptvBT+vHG/2qQBVdmNtDC2q04Pnqg?=
 =?iso-8859-1?Q?pdkme60H4CWVnj0j75nqeIN+Lb097DlU7FQ56Mov7ezL+MIRyFswtgBTr6?=
 =?iso-8859-1?Q?4ZJtJO0p2WZwPoqiBbibmYJ4L3aBZvENATXS/+5cifDNacub0dp+t6yCsT?=
 =?iso-8859-1?Q?sMmVQKdW9PuNjQJ67fE78Tk5PalLxnqhepPIj2sKonhMYYlTwsAQ0BGYjZ?=
 =?iso-8859-1?Q?pvSABGtoySsgAL0JGL9gKpsn89azjvU8ClQN/lVJr0kcXTbwxWHzUU5l6Y?=
 =?iso-8859-1?Q?yHfvBNfRbQ7OioPSuV/dPgwfdVQdknkot363s/+bF8G9SGgJ1C3p2OzsIf?=
 =?iso-8859-1?Q?q4vi4oGGnDnATr5XZitBPNY2C9TqlFJrNMiQgheBFDVDV/PQY0goeJIsQJ?=
 =?iso-8859-1?Q?0esTcqwkPb+aPywmZyAtJCXLWCjm73YlOHQsLUwoQeNPgL5eHLriIBFfIb?=
 =?iso-8859-1?Q?SDoY2sY/8MfAp4dCym5GA9WmRdsjU0poFnAiChJITpPjP+hvDYFnxxKN2x?=
 =?iso-8859-1?Q?6R4rwCdpmRsGCpeHUcvmwxsPGbcapQb0Co6VMSDpnJFvKdp3Hy6SKu9Np6?=
 =?iso-8859-1?Q?oYFd4XjfP9+yBXXBjl89w2wk3rV3JG3KaNFX6LqpCJ6kaFvMjplcPZSTmo?=
 =?iso-8859-1?Q?XrB5q5A702IfCEdS2ZS3AbNNf+KUtxELrl9QU8AnJeKgStbSWfnOXTB2E4?=
 =?iso-8859-1?Q?SiUadUTF/Lz2F8bd/+7mbvF3lniyHY3PIN2qk261nV0PFvY3lxOVOTI4ug?=
 =?iso-8859-1?Q?vS2v2V36y0MYJfmwQXolSdTiixmqcTej7AIMd4im6SenyFMbV2cOrr5FBy?=
 =?iso-8859-1?Q?Ox1Zz1KaOxV96d0kLEpwyYrSRwY8WmBduwgj/w+tXUo54/6tTdg09NE6Iv?=
 =?iso-8859-1?Q?ydoWzKihZX50z+2X+pxLZY/j7aVehDq+6KKfZZIHa4eeEQ2jz8zPuwyIPX?=
 =?iso-8859-1?Q?A57H6rJYw3THMQ1xpCs1zhMhMmuzgMcKgVPgRjVs2IphrxP0M0iEODoOAO?=
 =?iso-8859-1?Q?S8/WVLB810IfVbFKc3qSciQbjo/IXF/orhmDCjz4GtjJCPilP9HTndu/hU?=
 =?iso-8859-1?Q?y21l3Wp5dTnjo4GaysDiXxvsu4psqIIg7I61LW/JxP57ixI8dSe9JvtruL?=
 =?iso-8859-1?Q?IOlfNPY+yjDADGcNV1c=3D?=
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id:
 83e20a89-8b28-44f8-85e5-08da64a12fc0
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname:
 W1USNg0u3m1sc/+bXfjQI5YyC5Lj2XibBhghmEgwW7vFv8K1dG6Z2h2ZIiUMNYMbT4NqHwtZrjkhnbGNcT0tI6ppFcg04XxTMXtFOZjpjDk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3588
X-ServerName: esa4.hgst.iphmx.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.wdc.com include:spf2.wdc.com
 include:spf3.wdc.com include:spf4.wdc.com include:amazonses.com
 include:spf5.wdc.com include:spf.mandrillapp.com ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: _iM-Ga42WBXABUzsbX0gnE_GA4yXJLDS
X-Proofpoint-GUID: _iM-Ga42WBXABUzsbX0gnE_GA4yXJLDS
Reporting-Meta:
 AAFDj80JSc/vi27x2KmM3B2PuCFyEu2MA989PQJ/UceGnUmG0Jb7kDTSwZJeQxQG
 CtO+yfJy6WvlA59/1630sO9QtoY71AxnQPM5ioHq5i2Dy4Hz9K1FRtcTw+W4YP73
 Ygd3jdfYsMe7Go98mMjboacFDJiFO28JoREXNjqgoYsW/9nW5K38mmuNr6tlkgSl
 fiXeGIYHihUAL+pv+Ja3L3tj+0h2eGKBMdM7VxExeOS4ZIfUN38FTKLYIx4d7rW2
 gFjzQi7mBdk6jEyPspIoriZqFw1RdXxpGDP6c70fXvn4vMwd7OrKtLpiLINr2GLr
 0xTEMmqGHEEfXKW+w1WLx6OC9eZ3Toq+aMYV7d2SmGP9hPHQhc7+XEJV3SGWU/Lu
 CxsSI939zSUsEv5nO7dE3Jq9gyQziU7KX0Xfulp4NrsvQ9x2/CYZtWfWpZ1N3ZMU
 8V6MJUan5vsQI2vfaYQQFUQpelTTi6m1bkDvVfCNcxt6XF0hdv2KDkEt9UPi/519
 3PNCIHtr4fvdj1KYXZ3gJLlKA12ziciUM/2sZhTlBazP
wdcipoutbound: EOP-TRUE

For the series:

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
