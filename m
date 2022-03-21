Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92093C433F5
	for <ocfs2-devel@archiver.kernel.org>; Mon, 21 Mar 2022 16:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PEOaeYXxNZ7A2aHia/fugUp0ewvAIaTkGEbrBOirc2s=;
 b=B7DJeszJDg+EmQcQJ3FCGD0idmTo3MiiFolwdVd3i6QFssn5Hr4ue9UicFgzZaV5bmTTEmVUkm0a
   poQWei3Zjsqmxl53US0Oa+Gl0Qr77S7/KpMzZeg+f8+SaCOQeS2p7XbOB+X+pDoOC4hqRIEHoxBN
   YQGZqZ1d4bDuHiv3XAfiK7dp3/Rei0fBh+gpqJtLpWOw/l685imggo7L/bPYY2o09+Wm9I5PuolC
   4BC4Rlz5ZSs+ZqgcjsUO6BYANcINg7HQ66kccznGOcPlvOWr6vP3c+wDAuKBx5VdEVCC1K3UErWU
   xAS/BYa97uTb2akbVYRKsnQXbxBVflzjo9w3VA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=PEOaeYXxNZ7A2aHia/fugUp0ewvAIaTkGEbrBOirc2s=;
 b=fKT2zabXbPqtuTYhPqq3Sz6HVFMWuMyCbRpICegJJUw8eMzJ4/AxaFcXM7viawa9HEh1niczk30U
   0+JYAupjoFfcmg+n6vAtgN1kh2lKsrA51pxCej0JgR1n7HA4ooCe5zlz7okn1nQp7seR9rBHLKw1
   WvP7LD7/VWMUDbIMHh5BhoqJaqcavpD5ofNlDERbSifPnmaAit+XxU9PIYRD4r7oInxV8lMAzhCX
   UIfm1x+FsmtcW2axokLlD4WMipZnK3SeHPenn3l76KiwMMH/702ovmIRfIdQ1zjBcYqbLtQIelyx
   2GnNHk73eCmRriJK/Z2zjaBJRLl3Jmeq6vKBig==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R9300OBKS6BPP30@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 21 Mar 2022 16:22:59 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date :
 from : to : cc : subject : message-id : references : content-type :
 in-reply-to : mime-version; s=corp-2021-07-09;
 bh=vzP2PX4Bxyh4iVfWLKerqFKeOgyFti7tjqeRVPNrMRM=;
 b=PzeGvgm9Msb9e2cjdfQwnqe35Nsi8gOERcWNjmJzKcD/gbTBDgE/9WGYnfP+OkvhoHcU
 08HqG6WfTSzVh4TkAWorzHLuDOIymJm0txbLlCQRryiOTjS0Pbf5VG+ULaeUDAM9diJ8
 oz+GqZ4h8OqOk221Pi7h88mgnSIgizajfvar65STKwTzw9dMxtm+bRlanOaa5v5sm7i6
 Abt1XBMJY2pn+2lGwSA8UNVQmVahL6sRhmsC3B5/BS8wi0KGcp1Z4Y1or7dHJLSuoNEu
 +uNjYuqa/FogyNpp8Dk7emA707A4uOYDps5WmpkJ42dsphjqTILebi1ZPQnUKPNvLv01 WA==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=dan.carpenter@oracle.com; dkim=pass
 header.s=selector2-oracle-onmicrosoft-com header.d=oracle.onmicrosoft.com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvCUq50lk0n1chLLN0sJLUB4J7+YefLOCXkLmSroLcCXi4KnzA/lC1ccBi3rDstzDDDbdtMC48lJr8ZRRiMdXuwA0CMZrlBUQwis6+sFlx82Xw6WWzrlIFFdXZfvMML2RqzFlMFK2TzzeWuKxvnPRLuy4G9PMKCx/XK7tZnzL/PZZcT9tCY4Exzc2GuaXegd/trnuha2Csa+pWyLmoNi1Zb1hRvoAft+EdIdc1BfJ/O2nFYUeLSAj8abhfyE9uljfOqENbeS9xvIXPSYlKdrIQP/ZHvBm2Kd3uFUq6rLD9WqmkxJ2QUZAvcGYJHGOJhOtQa6R+A1FYXeZyfkJtQ+GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vzP2PX4Bxyh4iVfWLKerqFKeOgyFti7tjqeRVPNrMRM=;
 b=a8l4zEvpEgduxafqM1n3iI0j4oHjS1QVIc/M03vZ3nC0z8jAVTd+KN7/SXG+bgRNUgPVygR1ncbeg72Lap9WtJw1fSGN4tEb8gBoRv0nKLwkCCG0cdsBlcUMVVECyA2w66KtwUj/ZJ0rTxKegkPhgHSREgTwDdeqw8XGP9IWON0pN9Aix4KlSp1B3Z0vBsfmCCRKZNiND0qLiLNZXsj6m8njjyYq7YZeRArXjgrmOFOiaJ4Dbs9l+WsjF/cmj2qV4f4Unx3lq0EisqTgbQkiu89MczHUKjpaVjHF9YcszVo+s9NlE7vD8aZnPlPcL7bgnQu6jnOUtyuDnsrOlR9p8A==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzP2PX4Bxyh4iVfWLKerqFKeOgyFti7tjqeRVPNrMRM=;
 b=pMz140mPF6Ewk3Rr7zy6wdoxwzoX+lWXkk5hAkZAt+AkJei2ydXGutN/R71BYLdbEuu9iseGgW5w269AkLUcAv/6SnD4kpdxeelXNLD+TCcfSLHdPqWPL6amZ2uBNfmoCQsRqtafUAmeA99KIwauIFVu0+IT9dK6GnKb5dZn73k=
Date: Mon, 21 Mar 2022 19:22:21 +0300
To: David Laight <David.Laight@ACULAB.COM>
Message-id: <20220321162221.GQ336@kadam>
References: <20220319203106.2541700-1-jakobkoschel@gmail.com>
 <abcbf5d2-c348-7dc0-cfd3-9bcc6431bc64@linux.alibaba.com>
 <A7AA04AA-6B4C-4211-99A6-0D3C04ED7B26@gmail.com> <20220321135435.GL336@kadam>
 <75180dd18a3f460891cd93f7fcb3aa1c@AcuMS.aculab.com>
Content-disposition: inline
In-reply-to: <75180dd18a3f460891cd93f7fcb3aa1c@AcuMS.aculab.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:MWHPR1001MB2365.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 16:22:45.8599 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10293
 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210104
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 "Bos, H.J." <h.j.bos@vu.nl>, Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
 Cristiano Giuffrida <c.giuffrida@vu.nl>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Mike Rapoport <rppt@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>,
 "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
 Jakob Koschel <jakobkoschel@gmail.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix check if list iterator did	find
 an element
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
From: Dan Carpenter via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Dan Carpenter <dan.carpenter@oracle.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: JNXP275CA0039.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::27)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 731ca3f1-472a-4c4a-1967-08da0b57081f
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5568:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 EWRZoIwoXAzN60+jbO5du6y+vCAgC/wFxY+TtAv6Uu6dPEr633U7c2JiPSVps8ySD69hRx1hQaeVYpF4zR3zoebiv6vCeLo9FHgcoobKEvDzKcPp8Uty7trXY7RScrOsjuu80DnjAWXLQCKOnIRwbdyCZtPYxNs1GkQUw30drblvndoBOOsahOHi3bL76V4v++n771Vt7y/pHI+oSLDQvfk1x+xhr3oduPE+0sIOCF1LxuLa+aUg2VRukKKTpqHd9hHnjiMRND1+4JwPnc3SvU7Scr3+VvX1onaM/OKtAyaIDv3lpyhHh48pLKbTtrNvGyz3OYhsbkCwh5h7euNtCOtTtcTk45SbdSOak2yrkz2/XH/XWWXG8Igor4zCpIcYXA5Y3xpuLjkLvPa6lXs5h0gukXkllH6VEaXa+QSMhowi0tlhJneT4wbJoWuWARDQ4itvOCAcUsGuxpN6zdUXIWycldm/uJxFlO1N72NdTcWaZRX2aZxtm8yHzUErEGOPr5Y5vlMq/MyaLaR3UlKXyzzErxnXCYCCuZ32zSdt/Nbh6gp859Z/i8m9k1FWTF3TrgKo9Qa1DYRZE+4EWqhEVp8ztY231asHo904OETBWwI=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 731ca3f1-472a-4c4a-1967-08da0b57081f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 +Pfw1YbE6xsdSUccUpN41hqocWOLly5UXYXAO/RD7PxsIYKLczCy3wZsXzXNX2m2ysqS20EKeDZhEBuvqMxXPca34SGOURY9Qt8DUX7h1Bo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5568
X-MS-Exchange-CrossPremises-AuthSource:
 MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission:
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: Dan Carpenter <dan.carpenter@oracle.com>
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 62.8.65.185
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating; SFV:SKI;
 SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: SJ0PR10MB5568.namprd10.prod.outlook.com
X-Proofpoint-GUID: pjtEBzz1mEgTdHNe--Y852N0ytPJJeWQ
X-Proofpoint-ORIG-GUID: pjtEBzz1mEgTdHNe--Y852N0ytPJJeWQ
Reporting-Meta:
 AAFlfbocwkjkFEx8yanJA+99Y4n1+RVje9rfsvV6eJQfcf7loG8cg2W0VIiU4iJJ
 AaEfOtwjTH8LGytkFenhZb5/F5xCyj4SzI6MRPbdRXKNjozCLjzYTfcW8xfdUdoR
 m25PCMNJTyRrBjJNTrODGIhLNLxaoapK4lcV2o18I7SDVJvq2wc0bIvWplGKiVVH
 zxha8xOh8lXYiJWBBKl3M/UJoeBvv3OuN/j9D3zY5xeFCK0Jh3aC3J6EN49rZ3yr
 tJoySkfjqgodSTpDjO7vxPW+QxVxe8tJ0HWTaa6RnTV3ruTcvyzxXs4Xecus/w7z
 okPGha6huC+zrJnyo6FoQhsfp/e/zdYDtFvCdNC0GVL8NJwt6G83UDlwloBg7iSP
 q7UN01CLOEBzoQ7AsbRNr7YvKBNDGLdILl1o5LbD0b2nVyfKjet7WRQHc8oa2EOe
 bVMmrfG7MGfWCGbbknVC03Z0BSxyQHeZ6l8te6Cjcc4xGHbIioe99bIkXt3K2DLm
 1XzrX0v4TMRBbO2OzotmLhw9qxFX4dHTb04olUXcandl

On Mon, Mar 21, 2022 at 04:00:10PM +0000, David Laight wrote:
> From: Dan Carpenter
> > Sent: 21 March 2022 13:55
> > On Mon, Mar 21, 2022 at 02:34:34PM +0100, Jakob Koschel wrote:
> > > >> @@ -556,11 +556,11 @@ static void *lockres_seq_start(struct seq_file *m, loff_t *pos)
> > > >> 		}
> > > >> 	}
> > > >>
> > > >> -	list_for_each_entry(res, track_list, tracking) {
> > > >> -		if (&res->tracking == &dlm->tracking_list)
> > > >> -			res = NULL;
> > > >> -		else
> > > >> -			dlm_lockres_get(res);
> > > >> +	list_for_each_entry(iter, track_list, tracking) {
> > > >> +		if (&iter->tracking != &dlm->tracking_list) {
> > 
> > This is an open coded version of:
> > 
> > 	if (!list_entry_is_head(iter, &dlm->tracking_list, tracking)) {
> 
> Doesn't list_for_each_entry() terminate before that happens?
> So this code is probably still horribly broken.

There is ! in the condition.  It's just a complicated way of writing
if (!0) { so code works fine, it's just messy.

regards,
dan carpenter


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
