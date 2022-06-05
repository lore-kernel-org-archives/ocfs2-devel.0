Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 328B5C43334
	for <ocfs2-devel@archiver.kernel.org>; Sun,  5 Jun 2022 01:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=K7YFWPV3PvgV0lB2ekd2QtxjpEFE0OmE93uQ6IsdgZw=;
 b=aiCTgIdXmtoTJm5BSyoIdtPEgRbckBK7nWy7WfhOs/vZf3HQHLJeqYNxvYbuPBSQbgvI5CvZBsNv
   n7ostW1Jjkn3W8KjgsIfpGY/0qCULWG7ZMx5DJPZREouEXU9j7m/P0V2+smlVqdsimjmu2dIZ5yn
   uLcONGbNqEyJj/m3CZnnlFwgjhhb/jGe/BToym2FSO9dzh/tDlsZQbhd+/6gpbMw+t3fd8rrRqOu
   z0Hlw+JfRsQn1vFGL5MP5vC54YUBrtyl2GCkZr77i4hvvCWyd8zC9rkLd/BtyJu01/NTb5PnTmY3
   06kPnKftx9SWjbkSDZrK9Ne4cR7EozLV6DsXwg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=K7YFWPV3PvgV0lB2ekd2QtxjpEFE0OmE93uQ6IsdgZw=;
 b=oXJQdmwK8q+leiDhJvHZAd3mbrHxNLonDXbKhneGdU8le4RH5wkxNahMC4kfdRtDJZNzct5qbo9h
   oh3zQsy4BirD/DvVZ9AlKkIO3v8bJCUu+tyyflHM/c/u/AvqWh+lGe/eiywmPKfVALPOnCo8tQsG
   ZmVShBd4GHGRwx2q8HKFfou4TPwjagRvcsMo0Ov1bx5HDr1Qw04jp7iquXdIFGSTZ/Wzvgq506xM
   BP+WExmlFHqGQCOSdz7c/bu+c5svqyFg1d4K5N6ixI4VnhsNih/3zQEEMZeQP13quOvOuYxOXWyr
   OW64ASiNWAUH2YWa+OcZzNpFT1eDSTod8L/6zA==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RCZ007YICPAYI20@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 05 Jun 2022 01:12:46 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1654391552;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=zAas6D8v8SfxQOeKYs2kF6grEiccuD3IWkXAo71WgVc=;
 b=N9Jw5uPyzP/JyP7nfxNev2xRLzEoeaC00LedHMO4ytOkC/rDsLyY7IkOx7QNgszBsJ+giq
 c5pOGk5hxzbUtq7WZ+WnX29KsSoxzIsyj8cz2iF3m+lbEddpMg7NaOEmMV8wHZsukHKrGP
 2b/h1AqGqvgKQA6uojmUDhpMQIa/zeQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MYAH/yeLTGkKs/k7kylrvm7yLBU155K8Ae9y+nWZeGC2yjxV7HQ842qG+i1tLWmC9FpCL8INGPHyhGKjc9LYCx0ZrN9xh1jAtgMZR6tHViYa5iZP82Pbkm0U/UOK3pJ1pMM0nY+Fou+ze6KwCr1T6DaZJyxTdPLor7ZHeA683Pf7T9IYiU67JzqTQNEbJeZwZdnqfj2qV21g3iwFV+yNFO/X8DwrYDtD5EqulUzk/awM3yb2JxpJdVT4Mbv3KHai2m9zIvstu4n/q8NV1F/dZkLLu5XqjUDrMstP6jwLBsMKlcoXVKniq38k+SJX18L9p33wnwLZbDj7KA8Chbqwiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gb3019uhtVySuAshiGA0DKzgXmESTVynwNDclvQp1T0=;
 b=NN+mEleClMc3aYMaFW8RXPlsXD59nV4iCS5wEYC//cNMhJxi6aOIMfxPSoVSYVR+GZwUmTNMbUl9lcy44XE1dPKCRJkC4OzkOyg4ZxV77hmdrtcb4Jt5nWYnP5z8duZvm5qGz3tuzLdXe+l9OqPOargnII9cbWGZhXKze3vZ9jmpqQHmsBqqAb1lNtSNyypVIaAgpOzThxIH1bCVFdiEofM0FTloVAqhAT1RUb4hdRh4Ch7wSXbxL1CRS76iVVNV4OfXW0uCEc8KW4xYDM7R5oDT9tuf3imaiEcgoQoEx3O0JNLxoNCNmBo5fdjYIx3Y03lefTVxpx2+n4Ur/TxPYA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Message-id: <dad65d48-93de-06bb-e1ef-1205f0a49e46@suse.com>
Date: Sun, 5 Jun 2022 09:12:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Junxiao Bi <junxiao.bi@oracle.com>
References: <20220603223122.43174-1-junxiao.bi@oracle.com>
 <0b6053a0-8417-7da0-78c7-bf23f6fccba3@suse.com>
 <0ff26197-1157-22ee-9399-4cc74ad376c2@oracle.com>
 <6795bb17-10dd-7e9a-462a-22f344b38cee@suse.com>
 <9A2E0C34-2D11-4D33-99B5-2A156C3E5AD0@oracle.com>
In-reply-to: <9A2E0C34-2D11-4D33-99B5-2A156C3E5AD0@oracle.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(8936002)(6486002)(83380400001)(508600001)(6506007)(2616005)(31696002)(86362001)(53546011)(6916009)(5660300002)(26005)(186003)(38100700002)(6512007)(6666004)(316002)(31686004)(8676002)(4326008)(66556008)(36756003)(66946007)(66476007)(2906002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2022 01:12:27.7778 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10368
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 spamscore=0 clxscore=265
 priorityscore=176 lowpriorityscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206050002
Cc: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: kill EBUSY from dlmfs_evict_inode
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
From: "heming.zhao--- via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "heming.zhao@suse.com" <heming.zhao@suse.com>
Content-transfer-encoding: base64
Content-type: text/plain; charset="utf-8"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: 7fm9ms1nP9ekETMTEzOhyw-1
X-ClientProxiedBy: SG2PR01CA0172.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::28) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84d061c7-46bd-4453-7445-08da469074c7
X-MS-TrafficTypeDiagnostic: VI1PR04MB4877:EE_
X-Microsoft-Antispam-PRVS:
 <VI1PR04MB4877BC43C64C7F4F1C9634E097A39@VI1PR04MB4877.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 9bl8I13iilf++HJgv5yNJaRPRM9ZsPfUwJOz5hnRoZQ9LA8MfR5QJ6ruuJI3LrHcbY6p3B838aXacMlmcxhR/5OY1e/6s2clAYxzxGlvZBsuaROd2vQV52j8pSNV5fdM51QD3l6hYd1GYLQgv1D6sYhWXc8X906swkqd0NsBpGKIFSRpE3s2hEJIXjLR35dApx7P6eWhamOiaInH9Qw7wP4XB1hvrIqjHz0Fl73gXF/iDnfKNfGJy5BX//+5skwdtsY7LbHltLdbXJQQWGyfMx7aVkzP1JRouUpaOy+0/z1Fo4LaxbSV9KpkuDhyXutnhPlLY+7pjjov5AHIoXVgOfkxsJ9LdTie3UggGkbO8PxMZj+Qp7f0nhDCAVOrEvxqYEC86OhDaXHoMh3lsH9z1TbaMKNly7z0D4y9Tw1TznOOngalUfY+OEAzUng/mwW1Apr5xsjs1XR4Ex9gLY/Vzg7V3QFE6AEEiYc9Bi1/2JawESC1cRSnMweuknCMgKHz6Saz16dWXlK58n+3V1kDjU+063Pd9vEq5n6uA00DIMClnf3vbgtRnYhXJAAbUEpGp49wSd1BrV1qw0FGW+th2BBKxd+rNWX/XAY0qDrVuDoNDxoJ81ww7dS3GBnkNCqYq4cF8qsTqNiqYsgy3OiuROr/Rs78gRycbaBlq81dc/Kbbj396BVPO5TtE8QN72jWJ7qNpgV1zcjzXaGIPqozN1uK6R9c4+E1Qe+M9tum+mo=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?jQOU4wpJ8EYg1W+bqsZw1p7j7xs8WRUichbzPtPvMLrWJSOedvYpH4IvLOMm?=
 =?us-ascii?Q?E4pefoO/pXBZxKeM/RhlBvLpBZWQPr7vHM40T0DPoM0qLrAt9XgIQok4fYB9?=
 =?us-ascii?Q?yu6c8lMCUO1nT9MkFg01OPgrr2uILUM+tbXradw/d+RWB57YZTcdYXS79P2I?=
 =?us-ascii?Q?IaGubie8zwudAorOShiOSAalv/RhVTOBm8vBfdByOGwOo2hVyr5+QbKUb9d4?=
 =?us-ascii?Q?TD/2zRT2eR0MSlL2bjfDeYsxl6VJd/9EYJdOta/UGum0BrYvGycK0/xyMfbr?=
 =?us-ascii?Q?c3HmE1sGQ+osDqMaveL4kYtmg9DRty4ut8XWyn96cS4IMjMWGILJ9fuUsVQw?=
 =?us-ascii?Q?9lh/5Id43lPnZlMTXgweeXoZJWyt6eI26bvJRqMoIOl90pfYIpo6Ecv7sS4R?=
 =?us-ascii?Q?Ub3iBVmLBe6ONHn7galHJdZA27LYbqvMlTVfx/4fCHUOpGjSXJe5If8AzK4S?=
 =?us-ascii?Q?tc+EEMKzdNb5woH+DZYwrw/BdgOKR4YN1TZzlhmdyjnZPX+DgVpGBl2zruEm?=
 =?us-ascii?Q?h7WcFDDObh3n7W8UZl5ro80veimiw6GUBf599FP19NF2MuSOZWhkAtlJRGN7?=
 =?us-ascii?Q?/g8+J11CdlB/eox41SmtchX1/pdbx2y9VbHmTyb/Ut+tCPgJ8e9xg9zTrmDE?=
 =?us-ascii?Q?LjnmMCAFSPj85ijvj9JMA3Ts9LgJ1CK44/D9q83aTpYaTVX7EZqaRTNAR1li?=
 =?us-ascii?Q?oTktgBO5ITNiT3zmhV299+CvQy+M0HzGOcu1fHSmdIXzjOYorX2+ol5uvw5e?=
 =?us-ascii?Q?+aXYhzt1yz+pbJflqHAFLWe9jD7bM6+nm7/rtPdCOwVutzNwFiXU+FjMFTcs?=
 =?us-ascii?Q?ucKP78Q2bRuV9AtgwZCtRNf6+v7Ny+IF8Ke3wtXPHsXSzz5pLGXScRsJ3965?=
 =?us-ascii?Q?9FYUTrtder6OpB0ztHmcoCkeLiKhns5FyO+4gv5IbisgKMaAhYSreaQJoudf?=
 =?us-ascii?Q?YoF7GDpTTtQRrQUDMR0Y+nBfWOZEdsKk6ojothosTyZ+r1aRb9S8D9OTdY/8?=
 =?us-ascii?Q?drmARRtX91j3myZfLqGVTddpPWLZKOd4pTltY71dZ5X5eFmg+9cQGZlHBx3k?=
 =?us-ascii?Q?f/Y//ocsFkvIf6osrT5PClC403F1TtuCXyCrrNIsF3VOokLpT2xNaw9LwHU+?=
 =?us-ascii?Q?uXFXv4Rv8SZ2Ws4WFPRRLrRAXzwRcL3FkD/FGzIl1jEaD7de8bvcec42XhSt?=
 =?us-ascii?Q?jmst07dtSNgiNFxCyr/2te5TdV/cx34rOjMxL0rrq819gCa7ApKnxP4+6pt+?=
 =?us-ascii?Q?3l5BhL1X61mUxiD6Bu95mmL256xugGCZeSucO0weJoEEWWP8P7xBnKj2enPw?=
 =?us-ascii?Q?TUUetaBSahuhjQ7yX5iEsUJOc0CyjzQbrD375L1NOY1ynhp89PXogOhx6Yj3?=
 =?us-ascii?Q?x++SLEY8xiG6VlbdFThk6tJimyp58i/uo9dXKce9E1LPkJSE7J6XJqzuZZm1?=
 =?us-ascii?Q?TxWPYyVygjfZSf0he3su6TlWxOorqvJsqZSaXh5tYRgCD7O9hIgC1JXovFWg?=
 =?us-ascii?Q?1AZWma4nVss7wcq2KnWf2JwI+d/XqmU94EC1sw/MPFbOFgulSSiDMrvoCArH?=
 =?us-ascii?Q?nvdGGqHi7KgjApzZ9wZUBSP39OSDKwAiC9h9Yppl9UdMPkVPLqCgF1F+A0XP?=
 =?us-ascii?Q?dYsO85j7TJ9TWhiguXTZtkRvy3VJxE15vUbAZscCDFn9r1PUddc3ik5cRlb6?=
 =?us-ascii?Q?9m/vpH3j+3ifq0ljYGxxr3NBS0LEPOsZLPKppYhjvOFwJVK/JdUi81Bqu8K4?=
 =?us-ascii?Q?kSCFcsDrBg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 84d061c7-46bd-4453-7445-08da469074c7
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 DIm3SeJYCizG9J2MV4p/bZdjauZL+H03m6uatDIfgRmgSTTNwQtD/svS5h6ITbCtQ0TZ2VOwtAzR4Fptwppyeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4877
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: l029O46LJw4_3O0ZTRGQjGm3BuTDreMo
X-Proofpoint-ORIG-GUID: l029O46LJw4_3O0ZTRGQjGm3BuTDreMo
Reporting-Meta:
 AAEb4AC/zCXaukFQ+7XtBxYHIqHhdBJ3p24R45dXazdBLcU1tvZHnE+CJ6HINx1k
 oaFK2VMRvMruJZSYN3cNO4hhV0fbJVcOxScnaS1qzj+gtgoTKXpFzB4vZkWPuMwt
 /iFycEqzRvJj4z91DOGjgiwcyrfR55V8sOK3smjd6SNRd1RF9onZQC6PgWj9iysn
 Km6nqKFyK2CrtRIpH5qwaRvdTKRf7/zXCNSKMx2FevnWPfi9PhIYmYsxgMXA/R0t
 bCWRREpjJ/JiVTtdRU/zTHL+5BbMYRENJ5t6qrOd+6Pqul5cOLGQEisBJKzBtMDB
 DqrPGvXCRn+9nda6Z+b+/KVMXklhIzXqBZPwMT3xSbhUG6jJRP6PLfxqa6GptR/k
 yw/VRvFIAFp9EYeu6XJP/YNV1zxwPRJ4tl4Gc10uS5OrnOvQNacCRu41NNMD1SSr
 qwBQM7xxBW6y1vdSSfMHxjKuDb9YEXv/i4A3IQSUGsv7Pgi1SUWAdPJZHGouIOhC
 MpBwa98pKhXTeShqy9qEoZTTjrmxiDlZ/9rONX/iNVU=

T24gNi81LzIyIDA4OjQ4LCBKdW54aWFvIEJpIHdyb3RlOgo+IAo+IAo+PiDlnKggMjAyMuW5tDbm
nIg05pel77yM5LiL5Y2INDoxN++8jGhlbWluZy56aGFvQHN1c2UuY29tIOWGmemBk++8mgo+Pgo+
PiDvu79PbiA2LzUvMjIgMDY6MjcsIEp1bnhpYW8gQmkgd3JvdGU6Cj4+Pj4gT24gNi80LzIyIDM6
MTAgQU0sIGhlbWluZy56aGFvQHN1c2UuY29tIHdyb3RlOgo+Pj4+IEhlbGxvIEp1bnhpYW8sCj4+
Pj4KPj4+PiBPbiA2LzQvMjIgMDY6MzEsIEp1bnhpYW8gQmkgdmlhIE9jZnMyLWRldmVsIHdyb3Rl
Ogo+Pj4+PiBXaGVuIHVubGluayBhIGRsbWZzLCBmaXJzdCBpdCB3aWxsIGludm9rZSBkbG1mc191
bmxpbmsoKSwgYW5kIHRoZW4gaW52b2tlCj4+Pj4+IGRsbWZzX2V2aWN0X2lub2RlKCksIHVzZXJf
ZGxtX2Rlc3Ryb3lfbG9jaygpIGlzIGludm9rZWQgaW4gYm90aCBwbGFjZXMsCj4+Pj4+IHRoZSBz
ZWNvbmQgb25lIGZyb20gZGxtZnNfZXZpY3RfaW5vZGUoKSB3aWxsIGdldCBFQlVTWSBlcnJvciBi
ZWNhdXNlCj4+Pj4+IFVTRVJfTE9DS19JTl9URUFSRE9XTiBpcyBhbHJlYWR5IHNldCBpbiBsb2Nr
cmVzLiBUaGlzIGRvZXNuJ3QgYWZmZWN0Cj4+Pj4+IGFueSBmdW5jdGlvbiwganVzdCB0aGUgZXJy
b3IgbG9nIGlzIGFub255aW5nLgo+Pj4+Pgo+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBKdW54aWFvIEJp
IDxqdW54aWFvLmJpQG9yYWNsZS5jb20+Cj4+Pj4+IC0tLQo+Pj4+PiAgICBmcy9vY2ZzMi9kbG1m
cy9kbG1mcy5jIHwgMTQgKysrKysrKysrKystLS0KPj4+Pj4gICAgMSBmaWxlIGNoYW5nZWQsIDEx
IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCj4+Pj4+Cj4+Pj4+IGRpZmYgLS1naXQgYS9m
cy9vY2ZzMi9kbG1mcy9kbG1mcy5jIGIvZnMvb2NmczIvZGxtZnMvZGxtZnMuYwo+Pj4+PiBpbmRl
eCBlMzYwNTQzYWQ3ZTcuLmExMjA2MTBkZmY3ZSAxMDA2NDQKPj4+Pj4gLS0tIGEvZnMvb2NmczIv
ZGxtZnMvZGxtZnMuYwo+Pj4+PiArKysgYi9mcy9vY2ZzMi9kbG1mcy9kbG1mcy5jCj4+Pj4+IEBA
IC0yOTYsMTcgKzI5NiwyNSBAQCBzdGF0aWMgdm9pZCBkbG1mc19ldmljdF9pbm9kZShzdHJ1Y3Qg
aW5vZGUgKmlub2RlKQo+Pj4+PiAgICB7Cj4+Pj4+ICAgICAgICBpbnQgc3RhdHVzOwo+Pj4+PiAg
ICAgICAgc3RydWN0IGRsbWZzX2lub2RlX3ByaXZhdGUgKmlwOwo+Pj4+PiArICAgIHN0cnVjdCB1
c2VyX2xvY2tfcmVzICpsb2NrcmVzOwo+Pj4+PiArICAgIGludCBkZXN0cm95ZWQ7Cj4+Pj4+ICAg
ICAgICAgIGNsZWFyX2lub2RlKGlub2RlKTsKPj4+Pj4gICAgICAgICAgbWxvZygwLCAiaW5vZGUg
JWx1XG4iLCBpbm9kZS0+aV9pbm8pOwo+Pj4+PiAgICAgICAgICBpcCA9IERMTUZTX0koaW5vZGUp
Owo+Pj4+PiArICAgIGxvY2tyZXMgPSAmaXAtPmlwX2xvY2tyZXM7Cj4+Pj4+ICAgICAgICAgIGlm
IChTX0lTUkVHKGlub2RlLT5pX21vZGUpKSB7Cj4+Pj4+IC0gICAgICAgIHN0YXR1cyA9IHVzZXJf
ZGxtX2Rlc3Ryb3lfbG9jaygmaXAtPmlwX2xvY2tyZXMpOwo+Pj4+PiAtICAgICAgICBpZiAoc3Rh
dHVzIDwgMCkKPj4+Pj4gLSAgICAgICAgICAgIG1sb2dfZXJybm8oc3RhdHVzKTsKPj4+Pj4gKyAg
ICAgICAgc3Bpbl9sb2NrKCZsb2NrcmVzLT5sX2xvY2spOwo+Pj4+PiArICAgICAgICBkZXN0cm95
ZWQgPSAhIShsb2NrcmVzLT5sX2ZsYWdzICYgVVNFUl9MT0NLX0lOX1RFQVJET1dOKTsKPj4+Pj4g
KyAgICAgICAgc3Bpbl91bmxvY2soJmxvY2tyZXMtPmxfbG9jayk7Cj4+Pj4KPj4+PiBUaGlzIGFy
ZWEgY29kZSBkb2VzIHRoZSBzYW1lIHdvcmsgaW4gdXNlcl9kbG1fZGVzdHJveV9sb2NrKCkuIFdo
eSBub3QgdG8gZ2l2ZSBhbm90aGVyCj4+Pj4gZXJybm8gKGUuZyAtRUFHQUlOKSBmb3IgdXNlcl9k
bG1fZGVzdHJveV9sb2NrIHdoZW4gbF9mbGFncyBjb250YWlucyBVU0VSX0xPQ0tfSU5fVEVBUkRP
V04uCj4+Pj4gdGhlbiBjaGFuZ2UgJ2lmIChzdGF0dXMgPCAwKScgdG8gJ2lmIChzdGF0dXMgPCAw
ICYmIHN0YXR1cyAhPSAtRUFHQUlOKScKPj4+IEkgZG9uJ3QgdGhpbmsgd2Ugc2hvdWxkIGRvIHRo
YXQuIEl0J3MgcmVhc29uYWJsZSBmb3IgdXNlcl9kbG1fZGVzdHJveV9sb2NrKCkgdG8gcmV0dXJu
IEVCVVNZIGluIHRoYXQgY2FzZS4gRUFHQUlOIGlzIGZvciB0aGUgY2FzZSwgeW91IGludm9rZSBp
dCBzZWNvbmQgdGltZSB5b3UgbWF5IHN1Y2NlZWQuIFRoYXQncyBub3QgdGhlIGNhc2UgaGVyZS4K
Pj4KPj4gSSBhZ3JlZSB0aGUgRUFHQUlOIGlzIG5vdCBnb29kLCBidXQgZG8geW91IHRoaW5rIHRo
ZSBlcnJubyBpZGVhIGlzIHJlYXNvbmFibGU/Cj4+IHVzZXJfZGxtX2Rlc3Ryb3lfbG9jayBvbmx5
IGhhcyB0d28gY2FsbGVyczogZGxtZnNfZXZpY3RfaW5vZGUgJiBkbG1mc191bmxpbmsuCj4+IHRo
ZSBjb2RlIGxvZ2ljIGlzIGNsZWFyLCB3ZSBjYW4gY2hvb3NlIGFub3RoZXIgZXJybm8sIG9yIGV2
ZW4gY3JlYXRlIGEgbmV3IG9uZS4KPj4gaXQgY29zdHMgdG9vIG11Y2ggdG8gdXNlIHNwaW5fbG9j
ayB0byBhdm9pZCBwcmludCBhbiBlcnJvciBsb2cuCj4gUmVnYXJkaW5nIGNvc3QsIHRoZSBzdWdn
ZXN0ZWQgd2F5IGhhcyBldmVuIGhpZ2hlciBjb3N0LCB0aGUgc3BpbiBsb2NrIGNhbuKAmXQgYmUg
YXZvaWRlZCB1bmxlc3MgeW91IGRvbuKAmXQgYWNjZXNzIHRoZSBsb2NrcmVzIGFuZCBhbiBleHRy
YSBmdW5jdGlvbiBjYWxsIHdhcyBhbHNvIGFkZGVkLgo+IEFjdHVhbGx5IHRoYXQgZnVuY3Rpb24g
c2hvdWxkbuKAmXQgYmUgaW52b2tlZCBiZWNhdXNlIGl0IHdhcyBhbHJlYWR5IGludm9rZWQgb25j
ZSBpbiB0aGlzIGZsb3cuIEkgZG9u4oCZdCB0aGluayB3ZSBzaG91bGQgY2hhbmdlIHJldHVybiB2
YWx1ZSBvZiB0aGF0IGZ1bmN0aW9uLCBFQlVTWSBsb29rcyBtb3N0IHJlYXNvbmFibGUgcmV0dXJu
IHZhbHVlIGZvciBtZS4KCkkgY2FuJ3Qgc2VlIHdoeSBteSBpZGVhIGNvc3QgbW9yZS4gdGhlIHBh
dGNoICgnTkVXX0VSUk5PJyBzaG91bGQgYmUgY2hhbmdlZCkgd2l0aCBteSBpZGVhOgoKZGlmZiAt
LWdpdCBhL2ZzL29jZnMyL2RsbWZzL2RsbWZzLmMgYi9mcy9vY2ZzMi9kbG1mcy9kbG1mcy5jCgpp
bmRleCBlMzYwNTQzYWQ3ZTcuLmRkNDc1NTZiMDdmYSAxMDA2NDQKCi0tLSBhL2ZzL29jZnMyL2Rs
bWZzL2RsbWZzLmMKCisrKyBiL2ZzL29jZnMyL2RsbWZzL2RsbWZzLmMKCkBAIC0zMDUsNyArMzA1
LDcgQEAgc3RhdGljIHZvaWQgZGxtZnNfZXZpY3RfaW5vZGUoc3RydWN0IGlub2RlICppbm9kZSkK
CiAgCgogICAgICBpZiAoU19JU1JFRyhpbm9kZS0+aV9tb2RlKSkgewoKICAgICAgICAgIHN0YXR1
cyA9IHVzZXJfZGxtX2Rlc3Ryb3lfbG9jaygmaXAtPmlwX2xvY2tyZXMpOwoKLSAgICAgICAgaWYg
KHN0YXR1cyA8IDApCgorICAgICAgICBpZiAoc3RhdHVzIDwgMCAmJiBzdGF0dXMgIT0gTkVXX0VS
Uk5PKQoKICAgICAgICAgICAgICBtbG9nX2Vycm5vKHN0YXR1cyk7CgogICAgICAgICAgaXB1dChp
cC0+aXBfcGFyZW50KTsKCiAgICAgICAgICBnb3RvIGNsZWFyX2ZpZWxkczsKCmRpZmYgLS1naXQg
YS9mcy9vY2ZzMi9kbG1mcy91c2VyZGxtLmMgYi9mcy9vY2ZzMi9kbG1mcy91c2VyZGxtLmMKCmlu
ZGV4IDYxN2M5MmU3YjkyNS4uOTNiOGQ3YmFkOTZlIDEwMDY0NAoKLS0tIGEvZnMvb2NmczIvZGxt
ZnMvdXNlcmRsbS5jCgorKysgYi9mcy9vY2ZzMi9kbG1mcy91c2VyZGxtLmMKCkBAIC02MDAsNiAr
NjAwLDcgQEAgaW50IHVzZXJfZGxtX2Rlc3Ryb3lfbG9jayhzdHJ1Y3QgdXNlcl9sb2NrX3JlcyAq
bG9ja3JlcykKCiAgICAgIHNwaW5fbG9jaygmbG9ja3Jlcy0+bF9sb2NrKTsKCiAgICAgIGlmIChs
b2NrcmVzLT5sX2ZsYWdzICYgVVNFUl9MT0NLX0lOX1RFQVJET1dOKSB7CgogICAgICAgICAgc3Bp
bl91bmxvY2soJmxvY2tyZXMtPmxfbG9jayk7CgorICAgICAgICBzdGF0dXMgPSAtTkVXX0VSUk5P
OwoKICAgICAgICAgIGdvdG8gYmFpbDsKCiAgICAgIH0KCnlvdXIgcGF0Y2ggYWRkZWQgbWFueSBj
b2RlcyBhbmQgYWRkIGFub3RoZXIgJ2lmJyBicmFuY2guCi0gdGhlIG1hbnkgY29kZXM6IGNwdSB3
aWxsIHNwZW5kIG1vcmUgdGltZSB0byBjb21wbGV0ZSB0aGUgc2FtZSB3b3JrLgotIHRoZSBuZXcg
YWRkZWQgJ2lmJyBicmFuY2ggd2lsbCBicmVha3MgY3B1IHBpcGVsaW5lLgoKbXkgcGF0Y2ggb25s
eSBjaGFuZ2VzIDIgbGluZXMsIG1heWJlIGFkZCAyIGxpbmVzIGNwdSBpbnN0cnVjdCB3aXRob3V0
IGFkZGluZwpuZXcgYnJlYWtpbmcgY3B1IHBpcGVsaW5lIGNhc2UuCgovSGVtaW5nCgo+Pgo+Pj4+
Cj4+Pj4+ICsgICAgICAgIGlmICghZGVzdHJveWVkKSB7Cj4+Pj4+ICsgICAgICAgICAgICBzdGF0
dXMgPSB1c2VyX2RsbV9kZXN0cm95X2xvY2sobG9ja3Jlcyk7Cj4+Pj4+ICsgICAgICAgICAgICBp
ZiAoc3RhdHVzIDwgMCkKPj4+Pj4gKyAgICAgICAgICAgICAgICBtbG9nX2Vycm5vKHN0YXR1cyk7
Cj4+Pj4+ICsgICAgICAgIH0KPj4+Pj4gICAgICAgICAgICBpcHV0KGlwLT5pcF9wYXJlbnQpOwo+
Pj4+PiAgICAgICAgICAgIGdvdG8gY2xlYXJfZmllbGRzOwo+Pj4+PiAgICAgICAgfQo+Pj4+Cj4+
CgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczIt
ZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3Nz
Lm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
