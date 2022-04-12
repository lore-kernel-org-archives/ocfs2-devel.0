Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F30CAC433FE
	for <ocfs2-devel@archiver.kernel.org>; Tue, 12 Apr 2022 09:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XgXdH5+jQGPyUEsuGtZFDmsvBVV7eRhrO6tL54kCzDk=;
 b=rYcH3Z5LpDrLo8ybjZCIqfZChpmxuDscHPdtk/obnb03U6zlcgmKaYr1mMQc59u8an3MlJC99FG0
   0EIjXCde8MgSB7vEIDMpOYyKOhpL/2Psz9TEJQH55mslvSEfncAyHwbctPEpWbTcXvb/oufTGiQS
   MwWh7G4/N9aupiR+ZUSpw/rVdsCpsVETSCVudwh06FG+LOn7VXcb65nP62ULxoKv5YjUJn3Sbpe3
   BVneNTnsu18sUV7cI92MTUcsN6MJElIWBLv0Vo8fqZhnPMhlJRSXjbmKntCh96dLBQEgmvWncYls
   oi5FM5DpkNPn9Qy0N+jBYbkBXfp1PQwx6a9Dhw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=XgXdH5+jQGPyUEsuGtZFDmsvBVV7eRhrO6tL54kCzDk=;
 b=HNtCXwGZ9nXouZfZx4kpc2Fz6XQsvEu303a3GPobgNG75CH5JyjBwTVbAfxWsdeL/KngC9Ols1Ug
   AXshV4jRrtHxfQOVYHGrzJ8rX0Z6xwfYZ9/LcWdRr60slSII4cw/i6CuYPiXnPUYNNA8RF3UEnPg
   t49otgWeY8zq+iXL7/8zNXSKSAnZ1Dx/OcNu6Or19qZCFtf6nV+Sw+p3WN/qWBVW8bAcMhumMXIS
   Qe8LghBNgqd/K+0BmAh5DkarlkEH+QqOvN8MLe4NYh879sg7mvKGKqg/o7C5KBpaiYO9JeH6gay0
   GfM3yof9l3Bxn/PYeP9tI4h+q0xJ4adqpedc3A==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA80093C0NGS060@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 12 Apr 2022 09:50:04 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649753402;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=+xOBbqKRX33zXamfXU6DtAKEJ7mWpbSPT/BnYGPuXvE=;
 b=Gvdc7Dq695s6e2u++f8F7Q4zEDkAoB70nk0tq44J+UAR3EYxkiXYSvFEwnIjIxfQqbX3AC
 AIPvCewVn0TLtB/vdRKl9VjzpdjfJ2P21CUHHx/5kh/r3HpsDy+xSoOx9XF9vKaLdmIPgs
 M3thznsausqZRBLnNiqK+b1CP7DQ4uI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPJrM/mLpNjJtqkUlWyqn2au2fO4b0C5ZTyw1MjYUtiLCA/nJHfdTOiiKbeTrTLNfp94jG8B04m579c36w7EAbx6s7cx420hJSP5jLioDovkIA/sikNAgiUFpOBHvSfpt8JUHyT6mW1+gj2SzqvQIN2deNp92SUdvSwM1KEf+VOH2ePzHrame2aOfYkkeJ395oavVM5nM2gNBrC+f2jhIirgbGuM5iL9y39TyFpuNJcYThnbeED9wrR8eM8WbAi4yXSv284+Ac+dlivme8JFnDfwHgEGMtgf+pSeSaJeNF8gDx6sSiysZzfz+e5cxPvHGM9ncnzoqcIUtyvYYvC5CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+xOBbqKRX33zXamfXU6DtAKEJ7mWpbSPT/BnYGPuXvE=;
 b=ExdrVd7CPbHzjZkfRqUzaRxQ8l8mB4Y/1WQFgdqDgZskHYfqcJ9rPJucWTzeI+yoe69VcLZSCuyZRTPUwnJq+hG5UGDMUvifNHJ1FB/ImYtGDy1HK3r6ZfhoVQZstKcTInLdQn96pYLyC3Qd8FGRZfTTJywYf7ts3voOEehgn97PEnwGGRwP5A2xUI3EXUHDpiAQK5HSUTqZy1VdPuapIuN8oojMGS8+NAjY0h9cikSgFB5aAOxsyO5aBkl0g/+8qIoWYa/iPtpUUAZaS4EuOfOxP6YGy+VkAcJc7bRWca/hvD8sPXqwVyJMLlM2pojYlM0IUxn1AjGbB3iGhuGNHQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Date: Tue, 12 Apr 2022 16:49:44 +0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
Message-id: <20220412084944.kv2uu42cqpj6fpfx@c73>
References: <20220408103012.1419-1-heming.zhao@suse.com>
 <20220408103012.1419-6-heming.zhao@suse.com>
 <c917d4bf-3405-08b5-41a3-60579733fde1@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <c917d4bf-3405-08b5-41a3-60579733fde1@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(7916004)(366004)(6486002)(38100700002)(9686003)(6512007)(5660300002)(6666004)(6506007)(508600001)(1076003)(86362001)(316002)(33716001)(83380400001)(2906002)(53546011)(44832011)(66476007)(26005)(66946007)(66556008)(186003)(8676002)(8936002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 08:49:57.9836 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10314
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=132 phishscore=0 clxscore=163
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120041
Subject: Re: [Ocfs2-devel] [PATCH v1 5/5] ocfs2: rewrite error handling of
	ocfs2_fill_super
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
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Heming Zhao <heming.zhao@suse.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: F6uGDA52M2K6f28sXHM-gA-1
X-ClientProxiedBy: TYAPR01CA0189.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::33) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3711741f-c45f-41dc-df77-08da1c616c1d
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3349:EE_
X-Microsoft-Antispam-PRVS:
 <AM6PR0402MB3349C978BB086D2893E20FA397ED9@AM6PR0402MB3349.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 umPzaKykGMyb4sMn9a69TPrysY4fcd9yVlMp6Zv2HL/Ea4MgB0QhWYMIFuxX67HD0Kt+k3o3ONUfvRrsUOobXHqP9SDj88L1G8qq74J32TshYtfbJmXql6VYF+g0DkIfMKZ+septBTATidpRso7Msank1xFh3PBDVNozqBmrByfOnubu8YfGK6LWVkJwJLDJN2jPIzwNwWQ+1r13mAn60ow7uvtV//yUp2VA2iuLXeCZuCYsleD/LwJ4jjM53YfgbyTXtqP2W5AUhHt2RFBRDx9RbUQTQLkGVto+3ucUh1yTAun4tm2rS2ejDnbtbevRY+O1pq9OVz7PYgVSMxmoK9V/AHzVnoA1Dsc0W3tBV4Knw5esy5NYDT9e+H61u0utFzYIaD8qbhO+jjTpzg+0mGHSwCvHDMhFzyaVaaZredDJoB4C061JehmyZaG5v2SBN0xZ9G++o+a8lKmNq29GvszmcEJ0Kqp75YsoTrkJqoU+kUIgkL2nEejwv9HHB4sKrVH7UT/taXNLJaHQaOQC9JbH1Si+PJEdStUOc8UCNztf5zxHZ5avMopg9yZLGtuVuSlUXMNRqm60I6cakuj/q56b0hhayHyrOWl5sS1c7K5RPq7mnU8t1ZEfUoGjiH3Jq2y0MnLmVIlCf0BA7B26qw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?I7+7K4ZO8o6bAGslJLedRB4dtqfH7NUPJBwen9cz0OQqbzxdEGHVm3tAhvHS?=
 =?us-ascii?Q?yaQUrkxNcS/KphhjwHH6BrXJa5r7zZGy3Wh1+b1VI5sXFC3JqYDIcBPL6+0j?=
 =?us-ascii?Q?ZeNvquQ1Z1gRQikZst9bPcQvK5wwzLA+PY3WDpryYTzupoxdhUutswmMIYu5?=
 =?us-ascii?Q?JZpJpa/Au7an/qWr0UKu8VEUdzGnx2aQVmgaaPjyC4u40Z+5eWj09FNjH33m?=
 =?us-ascii?Q?oEDA1LprSQPz6TvMkY1+NYjowpSFpqrSLM5iCajKZ6zDv/KWq7/e5gJQdf3x?=
 =?us-ascii?Q?Zaj3NF2ZQjvdXcmNv1hlykX1CM/NStZktAUVARR//hD2Jr5UPQEstliDV36X?=
 =?us-ascii?Q?9Y/QjwU9Xpl+jtAtSKgudh6YILjSw1JI7LD3QGcNYCPPBmYtXi3KoFeUwVKg?=
 =?us-ascii?Q?VFIDP/uRo965hnYEuIDc9qFdvjz8Ax5FHoWR1xEaAR9i9R4Js+DZXuXY7mQ6?=
 =?us-ascii?Q?1uEzBJyf16W8DKL8zxU69gkRi5wUnil6TZwkrk++tmZJ42dtiXpK4weedBql?=
 =?us-ascii?Q?zB0a0v9VmHZ3IunZxXZHktmwfEpR8yYNbgB9pwiEON6c4CuwcT3rzPPKBlRR?=
 =?us-ascii?Q?B3xur2omWtBbfifNDV5Ms/6/pbiWkWXOYe0fp/HKpgSWI7kYf9qNEWc4Kbk7?=
 =?us-ascii?Q?730QDQhR64Od4yGAzKjIpSYqcQzNZVlNYuJ8XblgZg/pQ0zfUrje8M8Zh2gx?=
 =?us-ascii?Q?B5s3SleSwtc4fHO7iPu8PLTUiaZJZ58hipETXMsHR83UppPZE5xjUxuf6u0U?=
 =?us-ascii?Q?1229P3MA7uwkNqZ9O/1LKLAckL3Si2XV3ds9GiPm29sg3kNpkszFB4hER7uG?=
 =?us-ascii?Q?OgOiDf42KysYVfHRw4WW+K/Qnf6wmfY1rNGJ3ZXHPx+HbKa80AT/avZpLTNL?=
 =?us-ascii?Q?nChYjroxEj6RtIjuwx0f3gtzqTkR4rSWvCbd1HMRHX+eh5+fZ/x/6otGD0t/?=
 =?us-ascii?Q?w76WIJibv+jfCLkOffP3ID7cn61dVxYMUowt8tPybC0bXE27qJ0ojST4zgEM?=
 =?us-ascii?Q?nJCewGpYZs0Yq0q7ojwQR2TLEV/GTkVnbOUr33/NIZSNZ8FLoyrju1CF0q/W?=
 =?us-ascii?Q?T6jVL2BmBxD8s7Z71wojKsBcR9cTOiukymRNo8xg5XXX8R2oOlYbkkqVwnpL?=
 =?us-ascii?Q?qNnb6ht861/L6EP/rTrc8fIrges58FP8pqDEBqZ2Vduv7Mbmj7pEb/aEWWyd?=
 =?us-ascii?Q?8qQ673Ex7Aofj42oqWXkvqxK4VQZj1v+SydNs3SlSF5l4huQRBuf/wrx/Wpj?=
 =?us-ascii?Q?caPQdVGpr/wfABHNylz3Vw/irurkCz8PS3emO9EGDXSvsLGD12Tyvj3Uj5YN?=
 =?us-ascii?Q?t1S58Ai2/M4Ha8KVw30wiKE+xYdAMi3nZBORxpGeBkm8DUwwXOBcEGkTLgfm?=
 =?us-ascii?Q?NaG4swhj5/hjwfTcic5Ax1RD0+0cA4lNVeh1O/ktGYcLeGClGDFGi7rPJGi4?=
 =?us-ascii?Q?t15aiHdoJa1VKPOrErvP14MTrluC4Falf8WzCmuikM16UNuinmLNaCWHD+M3?=
 =?us-ascii?Q?PvRCY9KnIIgnnMnnvhhoo0s/4M9hJjresqadx3OVB3cztTzP8t9kzNACqBIq?=
 =?us-ascii?Q?IMQwNQWCp2ophzmuZ/27kYwTjSnwa/O+4BXjjapInrECtmlBTCcFQAhp8CHY?=
 =?us-ascii?Q?Qec6sWogCc+Q0ESZ1KvU2paOPi3tdiqn7PSJ3F3n/ygKfzjHlX42y7KS/Y6M?=
 =?us-ascii?Q?svIKnxWx+a0MxdaAeD8YO0s+nA5K6bop2LVMOIGd63XjA8zsnoetwcojMaDs?=
 =?us-ascii?Q?ZPYkcMyr6A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 3711741f-c45f-41dc-df77-08da1c616c1d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 30o47anVQh4EVn9Y3tIAY9zG1d3+YetQOwWokJzW1iQIAzQwO+mipx5b96GtdEQLKu5iPTLBBoN3Mu40b7exeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3349
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: ao7YCE_R8Q7M4u2aKg4tIB69DKyUR-yc
X-Proofpoint-GUID: ao7YCE_R8Q7M4u2aKg4tIB69DKyUR-yc
Reporting-Meta:
 AAEK0TjmceQ+ZUVFruPxETfvBl5zeggDEwfsmpV4EvBzQ822RsSAiok7Pnwv+mvt
 R55CVgkyNnpb6mRYHha0Af98EinuOaIagke+3e/uuPNxYYS/yt5a6bFqlpjdYPaS
 GSVBYKnlQkjRXM+8lH8c8IkYKTWuwKICF7hYFqedaozXtlXgZ8bZC0c8ObJkV3Gc
 cvL9RRmoxRna5AqGhmv5F9bvCAae/cCtg+qzhu7euUXoYDbG6Pw2vsV5TK9iHIAH
 uxZw5LcoiwHka2BK5zDePrbJDujb8qYU2IfRPddNdrwD1m2typQNMVDOvgzg4TTT
 n77wqeHUQQDIf2oqjLNJcuTF1+6in8gAtf4TzCamWMuYZcYB92RoAnIfWWWAEBlF
 h6y+VHfAcqYFi5kDVW2bg6qFEjNeis/RJPPDRTgOGqfnPf7S8FiovLX4S4kLgqe3
 vXLrmdkWOBN4XWFSnwIeeLYy/W97WhCcOSbxHXHKAPlKDzyNqF+fAqUKFtSECWvJ
 4Wq7dqqYKD5aFy5DX4Xvt6NRjrNh2ZwbHky9J4UdsS12

Resend my reply for easy review.

On Sat, Apr 09, 2022 at 10:02:16PM +0800, Joseph Qi wrote:
> 
> 
> On 4/8/22 6:30 PM, Heming Zhao wrote:
> > current ocfs2_fill_super error handling is very simple, and includes
> > kernel crash possibility.
> > 
> > e.g.
> > 
> > ocfs2_fill_super
> >   ocfs2_initialize_super // fails in check max_slots & return
> > 
> > Then osb->osb_mount_event is not properly initialized, and then will
> > crash at wake_up(&osb->osb_mount_event) in goto label read_super_error.
> > 
> With patch 3, this case won't exist any more.

Agree. After patch 3, ocfs2_initialize_super() will free osb before returning
failure, and this issue won't be triggered.
I will change the commit log in next version.

> 
> > For fixing the issue and enhancing error handling, we rewrite error
> > handling of ocfs2_fill_super.
> > 
> > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> > ---
> >  fs/ocfs2/super.c | 67 ++++++++++++++++++++++++------------------------
> >  1 file changed, 33 insertions(+), 34 deletions(-)
> > 
> > diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> > index d4b7a29cb364..c3efd9ad49ac 100644
> > --- a/fs/ocfs2/super.c
> > +++ b/fs/ocfs2/super.c
> > @@ -989,28 +989,27 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  
> >  	if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {
> >  		status = -EINVAL;
> > -		goto read_super_error;
> > +		goto out;
> >  	}
> >  
> >  	/* probe for superblock */
> >  	status = ocfs2_sb_probe(sb, &bh, &sector_size, &stats);
> >  	if (status < 0) {
> >  		mlog(ML_ERROR, "superblock probe failed!\n");
> > -		goto read_super_error;
> > +		goto out;
> >  	}
> >  
> >  	status = ocfs2_initialize_super(sb, bh, sector_size, &stats);
> > -	osb = OCFS2_SB(sb);
> > -	if (status < 0) {
> > -		mlog_errno(status);
> > -		goto read_super_error;
> > -	}
> >  	brelse(bh);
> >  	bh = NULL;
> > +	if (status < 0)
> > +		goto out;
> > +
> > +	osb = OCFS2_SB(sb);
> >  
> >  	if (!ocfs2_check_set_options(sb, &parsed_options)) {
> >  		status = -EINVAL;
> > -		goto read_super_error;
> > +		goto out_super;
> >  	}
> >  	osb->s_mount_opt = parsed_options.mount_opt;
> >  	osb->s_atime_quantum = parsed_options.atime_quantum;
> > @@ -1027,7 +1026,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  
> >  	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
> >  	if (status)
> > -		goto read_super_error;
> > +		goto out_super;
> >  
> >  	sb->s_magic = OCFS2_SUPER_MAGIC;
> >  
> > @@ -1041,7 +1040,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  			status = -EACCES;
> >  			mlog(ML_ERROR, "Readonly device detected but readonly "
> >  			     "mount was not specified.\n");
> > -			goto read_super_error;
> > +			goto out_super;
> >  		}
> >  
> >  		/* You should not be able to start a local heartbeat
> > @@ -1050,7 +1049,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  			status = -EROFS;
> >  			mlog(ML_ERROR, "Local heartbeat specified on readonly "
> >  			     "device.\n");
> > -			goto read_super_error;
> > +			goto out_super;
> >  		}
> >  
> >  		status = ocfs2_check_journals_nolocks(osb);
> > @@ -1059,9 +1058,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  				mlog(ML_ERROR, "Recovery required on readonly "
> >  				     "file system, but write access is "
> >  				     "unavailable.\n");
> > -			else
> > -				mlog_errno(status);
> > -			goto read_super_error;
> > +			goto out_super;
> >  		}
> >  
> >  		ocfs2_set_ro_flag(osb, 1);
> > @@ -1077,10 +1074,8 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  	}
> >  
> >  	status = ocfs2_verify_heartbeat(osb);
> > -	if (status < 0) {
> > -		mlog_errno(status);
> > -		goto read_super_error;
> > -	}
> > +	if (status < 0)
> > +		goto out_super;
> >  
> >  	osb->osb_debug_root = debugfs_create_dir(osb->uuid_str,
> >  						 ocfs2_debugfs_root);
> > @@ -1094,15 +1089,14 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  
> >  	status = ocfs2_mount_volume(sb);
> >  	if (status < 0)
> > -		goto read_super_error;
> > +		goto out_debugfs;
> >  
> >  	if (osb->root_inode)
> >  		inode = igrab(osb->root_inode);
> >  
> >  	if (!inode) {
> >  		status = -EIO;
> > -		mlog_errno(status);
> > -		goto read_super_error;
> > +		goto out_journal;
> >  	}
> >  
> >  	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
> > @@ -1110,7 +1104,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  	if (!osb->osb_dev_kset) {
> >  		status = -ENOMEM;
> >  		mlog(ML_ERROR, "Unable to create device kset %s.\n", sb->s_id);
> > -		goto read_super_error;
> > +		goto out_journal;
> >  	}
> >  
> >  	/* Create filecheck sysfs related directories/files at
> > @@ -1119,14 +1113,13 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  		status = -ENOMEM;
> >  		mlog(ML_ERROR, "Unable to create filecheck sysfs directory at "
> >  			"/sys/fs/ocfs2/%s/filecheck.\n", sb->s_id);
> > -		goto read_super_error;
> > +		goto out_journal;
> >  	}
> >  
> >  	root = d_make_root(inode);
> >  	if (!root) {
> >  		status = -ENOMEM;
> > -		mlog_errno(status);
> > -		goto read_super_error;
> > +		goto out_journal;
> >  	}
> >  
> >  	sb->s_root = root;
> > @@ -1178,17 +1171,23 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> >  
> >  	return status;
> >  
> > -read_super_error:
> > -	brelse(bh);
> > +out_journal:
> 
> rename it to out_dismount?

agree.

> 
> > +	mlog_errno(status);
> > +	atomic_set(&osb->vol_state, VOLUME_DISABLED);
> > +	wake_up(&osb->osb_mount_event);
> > +	ocfs2_dismount_volume(sb, 1);
> >  
> > -	if (status)
> > -		mlog_errno(status);
> > +	return status;
> 
> Or remove mlog_errno() before and then just goto out?

Your mean: at the end of lable "out_journal", call "goto out"?
If yes, no problem for me.

> 
> >  
> > -	if (osb) {
> > -		atomic_set(&osb->vol_state, VOLUME_DISABLED);
> > -		wake_up(&osb->osb_mount_event);
> > -		ocfs2_dismount_volume(sb, 1);
> > -	}
> > +out_debugfs:
> > +	debugfs_remove_recursive(osb->osb_debug_root);
> > +out_super:
> > +	ocfs2_release_system_inodes(osb);
> > +	kfree(osb->recovery_map);
> > +	ocfs2_delete_osb(osb);
> > +	kfree(osb);
> 
> Seems we have to take care all resources in ocfs2_initialize_super()?

Yes, I checked every line.

for ocfs2_initialize_super(), I lists all my found resources:
(list in time order):

  osb, osb->recovery_map, osb->vol_label, osb->slot_recovery_generations,
  osb->osb_orphan_wipes, osb->journal, osb->uuid_str
  - all above have itselves out_xx label.
  
  osb->osb_dlm_debug & dlm sysfs stuffs.
  - release by out_dlm_out label
  
  system inodes (by ocfs2_init_global_system_inodes)
  - release by out_system_inodes label
  
  osb->slot_info, osb->slot_info->si_bh
  - release by out_slot_info label
  
  workqueue:osb->ocfs2_wq
  - will be freed in ocfs2_fill_super label "out_super": ocfs2_delete_osb().
    or be freed in ocfs2_dismount_volume => ocfs2_delete_osb(). 

> 
> > +out:
> > +	mlog_errno(status);
> >  
> As I described in your previous mail, ocfs2_sb_probe() may return error
> with non-NULL bh, so we should brelse here.
> 

I also explained why I dropped the brelse(bh), maybe anti-spam system
ate my mail.  (I found my emails also disappeared in other mailling lists.)

I re-explain here. Below code based on patch 5/5.  Please note <2> & <4>.

```
static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
{
	... ...

	if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {
		status = -EINVAL;
		goto out;
	} 

	//hm: <1> bh is alloced/created from here.
	/* probe for superblock */
	status = ocfs2_sb_probe(sb, &bh, &sector_size, &stats);
	if (status < 0) {
		mlog(ML_ERROR, "superblock probe failed!\n");

		//hm: <2> if error, ocfs2_sb_probe() will release bh. So "out" label
		//        doesn't need to call brelse(bh).
		goto out;
	}

	status = ocfs2_initialize_super(sb, bh, sector_size, &stats);
	brelse(bh); //hm: <3> release bh before assessment status.
	bh = NULL;
	if (status < 0)
		goto out; //hm: <4> if error, bh is already released before "if()",
	              //        So "out" label does't need to call brelse(bh)

	osb = OCFS2_SB(sb);

	...  ...

out: //hm: no need to call brelse(bh)
	mlog_errno(status);
	return status;
}
```

Thanks,
Heming


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
