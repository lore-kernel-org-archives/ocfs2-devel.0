Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 262A9C433EF
	for <ocfs2-devel@archiver.kernel.org>; Sat,  4 Jun 2022 23:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=kASrlDGEfMKswIhlTX3M7fwaKLZt31FSRl/Ncdb6fcg=;
 b=hapGfJHIGglkusAeJ0qW+S+Qxn5/59ZoXzBHzRCMHq5y+8QDQMshlIB6UVIvAr2/IX1FTsPR1oR9
   nM+vcJLDG9UqBoX/Ugbcx/CB42rxSA8Ja+c1swzmXvl9dSTSQBJOEpjo0KjcCdSV9ho1Yr2b2Wqe
   a9Lr+8kMpvlg4jWdkvVEenWZcd5hsdfL8wxx/g8tUyoLE1tMBShQoHsHf1GS64j5yGTaxq8S+Ivs
   Ou85WEGctp9WLj6Zb6xu/VXQslHNQATudhi+PaaFVsnMohUhubY+8RRBCKcutGZQCXEXHnQA9a0q
   yjxp9dmiTHHc3VmCWg0JE3mpnjveTZCBLZ2o0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=kASrlDGEfMKswIhlTX3M7fwaKLZt31FSRl/Ncdb6fcg=;
 b=cuKgr3mii+OhgarBFzhbdI+xlTynLvSyU9LzhOBYkiGFhNqiuRfLaqcGGPIkGfeCamFa6sBz3cBc
   TsGgoyyy3lnWJToIuT6lmocx6eUu8vSiJ1udwSiqiQja0SveIsxmvN869+J1gyBrKy0HxY7NuVBP
   O8Uv8wHVjNr0Vb/JADIzjAY8sMujhi3weSEv9ke1d+jzop6BQO63tH3hmjNwxyhxaZbUYQHqclRA
   7VM9kOUrnFpgE4DPEkTK4ZFPR2nHzakAP5cbzYLcLyn0fi1PHgjjEo0vit4DKu/OAb1cDvUT11GZ
   YAiamDlR6ZhYOq1VTv9r1QgHT5Z4Bf2hw5vQwg==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RCZ008GQ7D3YIE0@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 04 Jun 2022 23:17:27 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1654384631;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=svxQPaH4RY2aRijbbqL3qemqjodszeSmp8UE+95OtAY=;
 b=el46V5fTwt/RqvAr9BHO0mcmQiLKXqXeC+HmyR5pHnRwOZ9fbZIHIcLghJ2kPRhtogoJjT
 fWv+C0nreDr7fKgxkjJs/6zjRYGHLHOeQjF/pbW7hkcgAw6tBLZ1thtSyOUT6IF9KZ0IWB
 ASqKOZp5mPScMuT6netESZtqZy9DaJw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QrWOTKMBvyvazSE4VZGhxDSVrovtZ/DCwP0dXgVteqbGvwM0jJQ42mpiS88d6CNZhRfhMHf5WWB/IJ2hdzXLPNghoXoSY1L8J3qP4kOTYFugbMCkWs4ePFIRGcVkrZXgdMWTnOr+fZOaCWHaWgVMtEkElBPsc0kYLq3qA8e8gpt9NFQHQdb98ZwdccHar1T4wLWO+OgsOgJoRi/7JtN9i2yiFT7m9gGCIgybuv/pWULooVJ6OIr+o3Q94wHPqTOoUqVFdZCV5JDBw+6vVIdTOzAzqEQGnijMLbZxPc4SgvhqZSVyxY3Ymab5a3Fg+peYOIUgUwaHyuD3cRaSlessAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NnFkU2cZm9uQ5iTEQLCjCRWK3PugTY1VZ6q80l7LI3w=;
 b=VWWe92G2RK4g60r3y9CWhQ61OCYfIus52jeXWiQbqOUyCfwE5XaKNqlzjzpWJx+WaZ8nltv3b06uks2leac3vVGpMBFV8w2kKPziceVyoRhh7YXDVWLS6UDIZOVfkN703v3t8qaNwLXyH8OB9PnHBga3XmdPdNUo46Vtk0QA1jQhjGJag4VhtY0CRanx+J0MosnnBTxTusvevbJWa+oJs8je83fEJGKb+HBvaj9gksDx4INCr3OxnoF8vDcp4Rcd4/yyUtn6FrYbzqgXUwQam2zY2xUIQLs6NeTQBc9VwNTw9fzGNafUmoaIl7fxsCfCKjOof7CYVkWX5wyiEsJRQQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Message-id: <6795bb17-10dd-7e9a-462a-22f344b38cee@suse.com>
Date: Sun, 5 Jun 2022 07:16:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Junxiao Bi <junxiao.bi@oracle.com>, ocfs2-devel@oss.oracle.com
References: <20220603223122.43174-1-junxiao.bi@oracle.com>
 <0b6053a0-8417-7da0-78c7-bf23f6fccba3@suse.com>
 <0ff26197-1157-22ee-9399-4cc74ad376c2@oracle.com>
In-reply-to: <0ff26197-1157-22ee-9399-4cc74ad376c2@oracle.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(5660300002)(6486002)(38100700002)(186003)(316002)(2616005)(8676002)(2906002)(66946007)(66556008)(66476007)(508600001)(86362001)(26005)(31696002)(6512007)(31686004)(83380400001)(36756003)(6506007)(53546011)(6666004)(8936002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2022 23:17:08.5826 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10368
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 clxscore=173
 impostorscore=0 spamscore=0 phishscore=0 priorityscore=146 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206040104
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
X-MC-Unique: odYPazckMduVr30ypV4npg-1
X-ClientProxiedBy: SG2PR06CA0219.apcprd06.prod.outlook.com (2603:1096:4:68::27)
 To DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce64148a-c460-4ed5-0ceb-08da4680589e
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3537:EE_
X-Microsoft-Antispam-PRVS:
 <AM0PR0402MB3537CF91264B40FCC27B500497A09@AM0PR0402MB3537.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 A3HS78GeScl0hoKrrTh0NzrCfX9YaksiPV4EVPQGRr5nixH8C02GOT0YOLy1KxxkdzBS7WafwVsYMykg0FcC2ltSpQcQ4gyC8HsEftfxyWGeK02QADN1AXzeSFzpnELwE0mC5GVAlH6djxiJPg09F3vrjENmVCY3Zo+falkSbfF1NQGp85Z4PYoSxxB5J7b89vtnc8DWy9QQge8ZuGJvyl7p60V6J06dKvkITTs9FobXOub2CBUmx6iT7ux+nGfq7cgFHNSI9sjuqQULz2N36YiS+k4X2VVYqUu8FVzgv2PVR9xC6Oe7pWZ31WLbuZy3R1sC4Yi+0nQEkveBTzzOtDmUw9IL/0DJN24baPcDqM4CZVukjJy8BELApgEFkeGW/Ln6DPpKjCyT8SIJJP7B3Oe0FYHWiqaiDdNFGNG76m+yVB13bVhNNq7IU57D1cMxXlN/tiyrO2DVH83E4gkVbooK7dtuk0EUl2KLsieYJP6IyK+iiovfep2qrfYjR3qgdQ2dvihjwTlRWWRuLPB4AD3M8Yt3TwjlzHigD6faQHN3w8RH5RnZkwfrqdF2bsvV1L3t13f5NiKP3rFNJVQqRQOrJ0XIBp0CN5YVBUaj+7Gip67QV9S+5D05sdq3bx+wuIFn7cGfBHeLH9ROp+Sz1SEGysGo9vs98my4FMLXcoJqbAeBQbuLQrUSlRdvmAn1FE7eL+jZ3raB5sshDcEdUzuVhPjv7hf7LF0ffQG6QlM=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?K0A2fHqP/q4zvYu4LkRYeBPsI4fmTGlLxn4bDhmXSeCXXC0rO6PyTQZvx/KY?=
 =?us-ascii?Q?VZetSHpMUq+dTktZKVjTu15Xl87nlUClxJcuz2ahUWu4XligM2qISaNi2qxW?=
 =?us-ascii?Q?Uv46QIngzlwtLaAZ4JiEZvPkEj4x+6jb0zRnLIItpyLhESOnNmVaF2OSPHWM?=
 =?us-ascii?Q?/CuMLdHWLaOvohc/U6m2jN8eUd6jDu4izdm8ZRK9kBV6+5wVay4U1YOtcBkd?=
 =?us-ascii?Q?xYmITg0NgNO82cS6KlXQajWCkVUcqipBTwj4tz6geoRy8bUL11DxsJFABF/W?=
 =?us-ascii?Q?zNAKzxwJqANcImbAduu3CTtqf8+fhjc8te3tYRXlkfGVKelFM6+Mb6ID6saS?=
 =?us-ascii?Q?7qojFXuVJ7x/lde/nM/BgDIoHi55lmPNBrbrTpAF+QUgFlSTanmF8PJVkFuf?=
 =?us-ascii?Q?PGbVps3SO4Lji9AaO3xU62eKWSPRSSw7eosngQNLmDtlxFWCi9+LAPFmjjOb?=
 =?us-ascii?Q?D0H7hqjWbtcoA2eTZcw7tX1fh/xNkyE+Eb/0pDn3ao5/euYchzHtFKLPt3Q7?=
 =?us-ascii?Q?OziB1PKwOZVrSUohv5iIoSERkQQxVZHhw2vZpSx0YEXtqqAd7K2+NoIwKIEr?=
 =?us-ascii?Q?w1yd+7Sw2MKLYReAW/FLrr9j2G73/t+CPvReYIJRbHfFkVvzcby1wTah6iLX?=
 =?us-ascii?Q?NlIVMhO34Dp0O08jRicmItD0gnRtmmFJGn5ryqXlyFBEe+2ZDaKEK8ojZQyP?=
 =?us-ascii?Q?iXOBCzbl2RDNZkreL+ez2t/BNLzCDjxI1V8EI0uGQddxE+XVV9fxnkDlZoKr?=
 =?us-ascii?Q?Go+KOavMSpQ63WSnmWTCfWWpR/zBQcXMDSBTZSWIVFeB1fCT/8Em/nQSG+nI?=
 =?us-ascii?Q?qTuBfpoqnurgAhWQYMZLDezcSnqyPVPPuzqN15+KfTxHgYUS+g9LJf//9PAh?=
 =?us-ascii?Q?IqBAS7y8IeMUO8tS5cSFNqVejZn44If87xANhL/WY0SRz95IZ+zy6Fm7IvhZ?=
 =?us-ascii?Q?VbswlnsDds6UJvJ75XWQPe9kENkUnzaJRRAl5DBQo/6RlSNmxG+mv1a53se+?=
 =?us-ascii?Q?+AOQE9TqQGdq7M1ar4YWrwOOvJD+v+waLnavJpkV9GSA+W8NZNVYcqZWmzvH?=
 =?us-ascii?Q?qN8NoWtzmlJhwkaHJYNK72gu52X/ChCDFodPINAetBnt+SMHJ281KKqzd4Rx?=
 =?us-ascii?Q?FYdpEgKK1jiZoVwNiK025Yl16MaoYAmsJP3I2OcNXcXvbxjuxPtqo9BV3GK6?=
 =?us-ascii?Q?qdk/d53NzczAkocJhcg8sUCTjATcjIwPKGt0+/MleR/gVBHCXWYPt/tqI6zl?=
 =?us-ascii?Q?zgjAmSPwv5tsPg0B/h2/fLqLkmMp7nkKb0XqxlGB5Cs0rGninBZVkpyZosIA?=
 =?us-ascii?Q?Q7NEnwC/uPfvU/KZi7OVj5S+qtbXmv8wbiNQZwARUVGtttwj+pP0G5H/CqXC?=
 =?us-ascii?Q?Z0pmouP4XneaYhPwGSJQWLvcII1sHvQWqlSskn5XmpJxxvsEPXbOLU37wINh?=
 =?us-ascii?Q?4KZhbE94Prycm9p+jUULuzOsgvO36vEIM6FwQVq1BOLtbw7Zhd7ZmYSInczL?=
 =?us-ascii?Q?l7B3porqTYqATz2JBD2nGMbf7lVOJ8+R1+CMs9TqdK4eDeBtweARMQU8LrqE?=
 =?us-ascii?Q?BtoMCS2hLps0hZdHmwGWdOz8Q2z2QI+7AUwTil073of7jVG7gYeee05wO2Lj?=
 =?us-ascii?Q?oCmMmqNEMmhG2XxP9fZ+u2bezSU7vnvufXyUMV1N+hTZ1cAN/AeNqJIJtpZU?=
 =?us-ascii?Q?jLacNluXshcuScolu92M13iaKRVKH9SLXVhaFf0Wo9geSVpSKYj0i31UAclC?=
 =?us-ascii?Q?xXUY9+lJzQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 ce64148a-c460-4ed5-0ceb-08da4680589e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 iyd2COqpgTMpMC70ZGqm/SRLaSOr91qqgHri2KqG5R8r2NdH3T/L8EaIEJBWhQOC8cJkkwsn987Q2Mf0qP0kog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3537
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: M6zN07FuAllJxq232R5QsFuS070dCvZV
X-Proofpoint-GUID: M6zN07FuAllJxq232R5QsFuS070dCvZV
Reporting-Meta:
 AAH0JTRqhJH4MHun3XpQ8LKMfucb9dRqgpq9mMUpMS3sRI2OP00YBd2yEeTqnIiP
 xO3uaX9eJH8MGw8DaUSS1Jd7caxaIC48hH6Lyqr3ScGLVL5uI7MXviXGvjU+3yKu
 +5EHSYPjOQDbsw2KnjC/ONS85c2Utp4J8kEDBifhoPeLwB2LP2mGzb3WkN/qoKp7
 T6xQzcZ1TUyHFzkcfiaoyvUCaW2O+Mm/MwbYeS/Mrgt2vYQ8sLQovnlMA948+Ntv
 2BvrBicEkZQHZMGVVi2FrnAR6SW/0OQrjdKhGtdQjzNZy0AUSmBrkOxtnqtX+vt7
 nH9WkGf5T/R1CpVpZhJUBxeuDKd0Va3ZqRPxCXttXMM66LrpIXsBcrLbNaNzamiF
 7Wwx++VAqfJEkZCoP6AXVJpGA1KCr2xGOyyRt1yG5mP2ikdDSFEAeZ78zPY+ZC8T
 5gjxucqxn3AM2NOGGGg5anXt8wjq4hO1gM/J4XgfssduonH6WpMtuhgms2unTQxN
 ziR+bkWs+5sFlBiQyRHe9DhhyfB8CU/KQj9VM0x2Yck=

T24gNi81LzIyIDA2OjI3LCBKdW54aWFvIEJpIHdyb3RlOgo+IAo+IE9uIDYvNC8yMiAzOjEwIEFN
LCBoZW1pbmcuemhhb0BzdXNlLmNvbSB3cm90ZToKPj4gSGVsbG8gSnVueGlhbywKPj4KPj4gT24g
Ni80LzIyIDA2OjMxLCBKdW54aWFvIEJpIHZpYSBPY2ZzMi1kZXZlbCB3cm90ZToKPj4+IFdoZW4g
dW5saW5rIGEgZGxtZnMsIGZpcnN0IGl0IHdpbGwgaW52b2tlIGRsbWZzX3VubGluaygpLCBhbmQg
dGhlbiBpbnZva2UKPj4+IGRsbWZzX2V2aWN0X2lub2RlKCksIHVzZXJfZGxtX2Rlc3Ryb3lfbG9j
aygpIGlzIGludm9rZWQgaW4gYm90aCBwbGFjZXMsCj4+PiB0aGUgc2Vjb25kIG9uZSBmcm9tIGRs
bWZzX2V2aWN0X2lub2RlKCkgd2lsbCBnZXQgRUJVU1kgZXJyb3IgYmVjYXVzZQo+Pj4gVVNFUl9M
T0NLX0lOX1RFQVJET1dOIGlzIGFscmVhZHkgc2V0IGluIGxvY2tyZXMuIFRoaXMgZG9lc24ndCBh
ZmZlY3QKPj4+IGFueSBmdW5jdGlvbiwganVzdCB0aGUgZXJyb3IgbG9nIGlzIGFub255aW5nLgo+
Pj4KPj4+IFNpZ25lZC1vZmYtYnk6IEp1bnhpYW8gQmkgPGp1bnhpYW8uYmlAb3JhY2xlLmNvbT4K
Pj4+IC0tLQo+Pj4gwqAgZnMvb2NmczIvZGxtZnMvZGxtZnMuYyB8IDE0ICsrKysrKysrKysrLS0t
Cj4+PiDCoCAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkK
Pj4+Cj4+PiBkaWZmIC0tZ2l0IGEvZnMvb2NmczIvZGxtZnMvZGxtZnMuYyBiL2ZzL29jZnMyL2Rs
bWZzL2RsbWZzLmMKPj4+IGluZGV4IGUzNjA1NDNhZDdlNy4uYTEyMDYxMGRmZjdlIDEwMDY0NAo+
Pj4gLS0tIGEvZnMvb2NmczIvZGxtZnMvZGxtZnMuYwo+Pj4gKysrIGIvZnMvb2NmczIvZGxtZnMv
ZGxtZnMuYwo+Pj4gQEAgLTI5NiwxNyArMjk2LDI1IEBAIHN0YXRpYyB2b2lkIGRsbWZzX2V2aWN0
X2lub2RlKHN0cnVjdCBpbm9kZSAqaW5vZGUpCj4+PiDCoCB7Cj4+PiDCoMKgwqDCoMKgIGludCBz
dGF0dXM7Cj4+PiDCoMKgwqDCoMKgIHN0cnVjdCBkbG1mc19pbm9kZV9wcml2YXRlICppcDsKPj4+
ICvCoMKgwqAgc3RydWN0IHVzZXJfbG9ja19yZXMgKmxvY2tyZXM7Cj4+PiArwqDCoMKgIGludCBk
ZXN0cm95ZWQ7Cj4+PiDCoCDCoMKgwqDCoMKgIGNsZWFyX2lub2RlKGlub2RlKTsKPj4+IMKgIMKg
wqDCoMKgwqAgbWxvZygwLCAiaW5vZGUgJWx1XG4iLCBpbm9kZS0+aV9pbm8pOwo+Pj4gwqAgwqDC
oMKgwqDCoCBpcCA9IERMTUZTX0koaW5vZGUpOwo+Pj4gK8KgwqDCoCBsb2NrcmVzID0gJmlwLT5p
cF9sb2NrcmVzOwo+Pj4gwqAgwqDCoMKgwqDCoCBpZiAoU19JU1JFRyhpbm9kZS0+aV9tb2RlKSkg
ewo+Pj4gLcKgwqDCoMKgwqDCoMKgIHN0YXR1cyA9IHVzZXJfZGxtX2Rlc3Ryb3lfbG9jaygmaXAt
PmlwX2xvY2tyZXMpOwo+Pj4gLcKgwqDCoMKgwqDCoMKgIGlmIChzdGF0dXMgPCAwKQo+Pj4gLcKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgbWxvZ19lcnJubyhzdGF0dXMpOwo+Pj4gK8KgwqDCoMKgwqDC
oMKgIHNwaW5fbG9jaygmbG9ja3Jlcy0+bF9sb2NrKTsKPj4+ICvCoMKgwqDCoMKgwqDCoCBkZXN0
cm95ZWQgPSAhIShsb2NrcmVzLT5sX2ZsYWdzICYgVVNFUl9MT0NLX0lOX1RFQVJET1dOKTsKPj4+
ICvCoMKgwqDCoMKgwqDCoCBzcGluX3VubG9jaygmbG9ja3Jlcy0+bF9sb2NrKTsKPj4KPj4gVGhp
cyBhcmVhIGNvZGUgZG9lcyB0aGUgc2FtZSB3b3JrIGluIHVzZXJfZGxtX2Rlc3Ryb3lfbG9jaygp
LiBXaHkgbm90IHRvIGdpdmUgYW5vdGhlcgo+PiBlcnJubyAoZS5nIC1FQUdBSU4pIGZvciB1c2Vy
X2RsbV9kZXN0cm95X2xvY2sgd2hlbiBsX2ZsYWdzIGNvbnRhaW5zIFVTRVJfTE9DS19JTl9URUFS
RE9XTi4KPj4gdGhlbiBjaGFuZ2UgJ2lmIChzdGF0dXMgPCAwKScgdG8gJ2lmIChzdGF0dXMgPCAw
ICYmIHN0YXR1cyAhPSAtRUFHQUlOKScKPiAKPiBJIGRvbid0IHRoaW5rIHdlIHNob3VsZCBkbyB0
aGF0LiBJdCdzIHJlYXNvbmFibGUgZm9yIHVzZXJfZGxtX2Rlc3Ryb3lfbG9jaygpIHRvIHJldHVy
biBFQlVTWSBpbiB0aGF0IGNhc2UuIEVBR0FJTiBpcyBmb3IgdGhlIGNhc2UsIHlvdSBpbnZva2Ug
aXQgc2Vjb25kIHRpbWUgeW91IG1heSBzdWNjZWVkLiBUaGF0J3Mgbm90IHRoZSBjYXNlIGhlcmUu
Cj4gCgpJIGFncmVlIHRoZSBFQUdBSU4gaXMgbm90IGdvb2QsIGJ1dCBkbyB5b3UgdGhpbmsgdGhl
IGVycm5vIGlkZWEgaXMgcmVhc29uYWJsZT8KdXNlcl9kbG1fZGVzdHJveV9sb2NrIG9ubHkgaGFz
IHR3byBjYWxsZXJzOiBkbG1mc19ldmljdF9pbm9kZSAmIGRsbWZzX3VubGluay4KdGhlIGNvZGUg
bG9naWMgaXMgY2xlYXIsIHdlIGNhbiBjaG9vc2UgYW5vdGhlciBlcnJubywgb3IgZXZlbiBjcmVh
dGUgYSBuZXcgb25lLgppdCBjb3N0cyB0b28gbXVjaCB0byB1c2Ugc3Bpbl9sb2NrIHRvIGF2b2lk
IHByaW50IGFuIGVycm9yIGxvZy4KClRoYW5rcywKSGVtaW5nCgo+Pgo+Pj4gK8KgwqDCoMKgwqDC
oMKgIGlmICghZGVzdHJveWVkKSB7Cj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdGF0dXMg
PSB1c2VyX2RsbV9kZXN0cm95X2xvY2sobG9ja3Jlcyk7Cj4+PiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBpZiAoc3RhdHVzIDwgMCkKPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
bWxvZ19lcnJubyhzdGF0dXMpOwo+Pj4gK8KgwqDCoMKgwqDCoMKgIH0KPj4+IMKgwqDCoMKgwqDC
oMKgwqDCoCBpcHV0KGlwLT5pcF9wYXJlbnQpOwo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8g
Y2xlYXJfZmllbGRzOwo+Pj4gwqDCoMKgwqDCoCB9Cj4+CgoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMy
LWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0
aW5mby9vY2ZzMi1kZXZlbA==
