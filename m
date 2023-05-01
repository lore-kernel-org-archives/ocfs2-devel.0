Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99B47C77B61
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 May 2023 04:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lhK918vzq39Rvd36CJlJDqeHjR/m2QKodjaUU3U4oQM=;
 b=fZCQpmYLCvxT/8E6i/e/jJPboVllCxPU/3XkSglz3TMuc1mSppGhabqwjndGaout7MqLSExVx8yQ
   +1FX9RTSAGrTz4nv0aPwYUfFWyxixW/569M25kxQWSriM/fV75lHjLDcqgO+oTjSDaXOKf/PB6iW
   MfmH2zhKYEHJUotUvIMkXwbLe0P8/R/+CPADirFi1X81u1FKHfyNoQWRHFkt/xF/5OSC8YX9ek3w
   kVfU4KN8VntRwfbmvIGC6+M9SmSFeBiIJ4y/4D7QdxieAe5jvfgaIWxA6UMeiTMs7u5dWy7sa6qj
   1FPcPmCSIzfB5nIjb/BY69Loct4dJg7ul6EiXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lhK918vzq39Rvd36CJlJDqeHjR/m2QKodjaUU3U4oQM=;
 b=bG5pJIeh4y6nltLHxp8ePFCIxSduO0fhuROmYV6qCwnu7xUUyXDXpozk0F/ppSg+GT0rrcTuVjB1
   HUxN797YuACBNYk6JZFcaHMGFsaRHIkPpiK2n6/AhI/Ad98G32qsFebJ32/FPmxSfQSF/phHx9pN
   SxkyUnMs2aWdwgEEbxQ/+QJ1yMtDU0DTbuZiZgZFlIl2FRF8x4SCk4NM/xUgtH/tn6YNVdsvQjAh
   7F9hLXoMMZ6NDzIjZ6IJuoQMHoKceWiZcMZKiuJPN/04JM/p6thPku7e3vx3T9cAOuIze2z+23tm
   +HzXfGTNZtGPjWmjv4dCuLtWnmIxX7lJLsYz3Q==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RTY00JLCQV93480@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 01 May 2023 04:52:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IyZbZi9sIgFm5T6wY5HlfdEFFjg3angD9WPyuypZBrzaHpqpdW3+V1HpfhLW7jK258G/yu6DUiZb/+vCc+C5UTyZtDvBJ/Ubz7CbkAkZtZu94GuMKLL2muxdLICRAYaEIGNQR0BStT07tabMvZSAbilTGA+tQFzUKIPNzlAV3yK873D4o8XIMEbIP7P8l80lSlNZsQb0h0OpKYGqGuHD1oTHKmEo1KE8N3eI9btZRQ+GnqSvh7xCaOL0WlM/aTU7+5AjatRctEfjbJMc8+bMi4M48xiNSIoQcMIqCDuubwSFIZk8R7s4XByYwj4WHLSm7f3jQe+kQKEvUyaqcZFiaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/TkEnOMwvbQbEmgZQsDNi/0RPjMs5Yjx0ieqo++Hbr0=;
 b=RfAJiA+UPXAgklQEvqrT06CdFc653gH9y0a7Xh5PCaJUqapctSvEpZMm00Zdx/21TqYQTRV0lG75Lh8VDdnmZcWKJTM6hAu/+SJSJG2z7yWEIpilB5nszE66DDsm5odGl83WsDJwtTjKWlV0chwIsBF2B1FBXjaVtdsyvu2BPFdYYvjSbvlQVLGVgDe3Hobl7sSEb72JcpDoh0SUmg5f7N1vM2b3NCtFY9O+XFoI7lG5eeV3NjS/Jdn7cjD5AS0SWJ8d11Bk1JfK7C2a+lrL2X5sQDyXTM3ZxOQenY8rcaEvr+tEnxgTUAILvOjK+lT9627XoVdToCxUcESg6JFD5w==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/TkEnOMwvbQbEmgZQsDNi/0RPjMs5Yjx0ieqo++Hbr0=;
 b=N3wG7uezSF2mN6hUir6+p0edGNq3iwupcBhp/r5INJLUKS8QZBdsfK5q+n/Za2jL1j91R3yk9K+T/nitdKzmJGSJPN4Q574zbDTJqlOnJmbL9MNku1x+0EdRMeVs5i63trjO3Xkh570AxjM1pMv+M+g9cTqfMDjS/P+QCv1cOK4Mx6nIxS9iBPW+ZE/En0lIr/IBPYmbR+kEbR24MrHrfplbYvDFOXdxRIyUro6K9bM2/hJThMKLWpgB036iZQOFpfjlFwLa9RiEdr6qOepbO/PBU1C+R9DRt5xD7aLKOIs0J5eFwG7/KMFSsuCG3S/i6+y9yAPzuxPHXZC+1fHikw==
Date: Mon, 1 May 2023 12:51:53 +0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20230501045153.h5co2zn66q2unlsw@c73>
References: <20230430031302.15597-1-heming.zhao@suse.com>
 <b2942f09-9797-220f-db72-3b49b0859277@linux.alibaba.com>
 <20230501022628.avrcx3exv3nev3fl@c73>
 <d9d1fc18-39d8-2888-c540-faac2d3f5628@linux.alibaba.com>
 <20230501030958.ps6xssjcvu6pnpnl@c73>
 <2254db82-10cc-50a7-6cb9-5344e294a3eb@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <2254db82-10cc-50a7-6cb9-5344e294a3eb@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(136003)(376002)(39860400002)(366004)(396003)(346002)(451199021)(316002)(53546011)(9686003)(6512007)(6506007)(4326008)(33716001)(8936002)(44832011)(8676002)(86362001)(5660300002)(66946007)(26005)(478600001)(186003)(83380400001)(1076003)(41300700001)(2906002)(30864003)(38100700002)(6916009)(6486002)(66476007)(6666004)(66556008);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 04:52:04.0012 (UTC)
X-Source-IP: 40.107.15.81
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10696
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=90
 bulkscore=0 adultscore=0 spamscore=0 clxscore=180 malwarescore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305010039 domainage_hfrom=9715
Cc: ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 1/2] ocfs2: fix missing reset j_num_trans	for
 sync
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
X-ClientProxiedBy: TY2PR01CA0005.jpnprd01.prod.outlook.com
 (2603:1096:404:a::17) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|AS8PR04MB7720:EE_
X-MS-Office365-Filtering-Correlation-Id: 99251b7c-575e-4ff2-4819-08db49ffceae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 4mFiE8soQLca7Ooi8G+dqtcW32rnJRGfyR+npS83bnd5EI0/UpP+5plE6i5x7KUba6891HXBptpK35iXW7n5ClQDfH3F7Jc2lp7k4IyD3pauVKB/NnuxrczsiN4Xy5kTdG7FHoj9sE7hwAAUi4Jq+Ebfhz4RtIsG77IQ6dlRh8fWbeXsrEhkoMrd83qLIFFpAKehmDKElscl/QP/muhJXO562XL2TmPxf+giFJwXaiZIvBZHbfXf73fPQ4NZfS+zj+rgmfO2yBISqBlcQsM/V2iXUIpLMMsS278kwcBL4gUmIyLlFtXvel1uQKeE+DRXbKZDoGg29DWORIYcNBK66OvDeQemeAC4kD0j2tDENZoRhe6yeh+23DtZOFnZNXVJQuCs98ZZZC0xbTI6E1+NhW6z8zGxhg+7ZWKkhwjLzVKvD2PlTYZ/no1s63wouOR7T2cYDG8pvWNPCha0hh08HWqKo97RWi8fQRGPFyHBzaadgG2sftmv/JUTS+cjELhUBroG/q/BLp1kKiAZoxWey0V/HeFWx/o+qV6qXyQhnlrmrhYsNvpgYoyU/vOILVfv
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?uo8XDg/fcVlrM5/uJsZlftL6bSqNVNJ+oZPosIJfIxQUd2pQb3tJrmc9uzt1?=
 =?us-ascii?Q?ViEaLK2I90yV9oEK9Z5MNYWD9z6+aN8jfZT1VuzXkZmbHCi076kHceQS4Xbg?=
 =?us-ascii?Q?MaIwSXlMnBuq0kDquGApFV1e0UM+gVOnY46cuuKo/b/9sysLvr8KnEfEjTYa?=
 =?us-ascii?Q?kw9NLN2jXtYKvu1NIbD5NuRB1RIhCmadrVgrX0/GGvPzxxjCl2WFgbBjvjUk?=
 =?us-ascii?Q?fbn0pLIgsoQlXToTn5b7MFIkKXyaSQBx3rqsVhdSKy/Z0Cy82g2Go8aYoFM9?=
 =?us-ascii?Q?GvcXP6LxhUEeiZfTX7G6rS/QUxpmG80H2h5GLygt6J2jZ6hmqg0yvL09KZfv?=
 =?us-ascii?Q?E1eH27k4K5Jgy44SJ5+Yzc2b0DkBTcWFifFGMAV4uDoANhILm29UnlXD4Gwi?=
 =?us-ascii?Q?ybe8RNeQDbRk8am9tmBWVtumKKf5ej0e5l9RLNV8Xni70mjn0iPlI00h7RP5?=
 =?us-ascii?Q?1wfQJYo123k44RYQm4Y6fr6lHNnrIFY44re2sWhxbwZ1i3x0bD60nosxRl7L?=
 =?us-ascii?Q?lATlFcD2np+XhMXaY826ZsRR7dMAR6tN6vZWz6tOsyU1BgekHLWZXcPWlW/+?=
 =?us-ascii?Q?5T4ZHZYK4WEukHYdpQ4pl1cyDkn5WIxZkpMlV+V2i9pbi1FeUn474tcT4uaA?=
 =?us-ascii?Q?j+w0AW8/fgW3K9KILnlPDhuxpVRcxgOk3A9R49BPEr63Bczws8ZuTbayRAIr?=
 =?us-ascii?Q?FOxuzu19ztmIF+s1aBRpDRQevkq6AH/20Cs/POiq2LSRJm65jE2rvYB36r6L?=
 =?us-ascii?Q?PmLVEkphH1Cf5WYAOpU9HNwpR5asGSZsufAAKnWYyksWX5tkB4QXORQtpwMw?=
 =?us-ascii?Q?rsEEbWNWRqAI2M5Q7B37jRUGwkAOMsahohMamS7iVCU19BCJfbgwqgHi0wUF?=
 =?us-ascii?Q?q6ldc0pl5XiZ9255MSb0Fo5tZZ4Oktgj+lIpuHYl4fWW/UX6DiWIVGm8zy6x?=
 =?us-ascii?Q?sUqEBpnJlHXP1rNx4+TxVDNNDeIqDptCuxzGRAd9Hz+09uBqPNsv1Nhw2Hi0?=
 =?us-ascii?Q?bmC+IRgxxGRNbZYm0DD9O4b/GgsU1UzmZEwUgR7dZiKS1CWlsVFZ27lQKugt?=
 =?us-ascii?Q?a6aqCf5HyXS4g70M5p9W3RPSsX4rp7v5KkWRH6Bwtt9cs0QSYN1EUEi/aVgK?=
 =?us-ascii?Q?aHef9eQpOasL/QFV+zXM2I5/2VU1Gv8hIAnWk+uknbhKOwckTPXSU8jWqUWV?=
 =?us-ascii?Q?BagLsP8/vuZJwTTbiDuGm8MLAxweemnmuatEUmmpH9f1T0s9rIk2cRagB+5J?=
 =?us-ascii?Q?hswfOrCA71McvQHaQLVyVPBq2U6suu37pkG/hHDoDWmXVoQYRJlmnghav7Vk?=
 =?us-ascii?Q?8xvsvG307l2JdMPHRD+dtRAW6NdYbGfkYliLwYcUXUWHWjj1n9ayt3uIekQY?=
 =?us-ascii?Q?JgZPRZOPAYr2dUtM8Rjwghfj0VXtYGH3d0BUUMuV1upJQFumGv4rPaO+L3FH?=
 =?us-ascii?Q?mwUvw/c3ZMMPtv1OilpL6FAmG9pJXz9OyKpIcY2g2WGzFLQl9DRIMxWZFLG6?=
 =?us-ascii?Q?e0sx1PMSNH/DGTcZhm96agEeoeRQQ0n+kGj5utQUgSXVHOLxwXE3vneLbxL0?=
 =?us-ascii?Q?ERUXiDp0finhb1IpehO8kfy49mWYAEavzR7ED0cN?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 99251b7c-575e-4ff2-4819-08db49ffceae
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 sww6wk0jVVRDGybEtdJamJDwk8zZLJh/iBGwlkmvU/8xOIIKpWX63Sm8GUQ+HTFvLTePE6C3Lsh4iSDezHLb8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7720
X-ServerName: mail-db5eur01on2081.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: L1j7aDu66uvnvpbEP9z28-Suic2yNEx6
X-Proofpoint-ORIG-GUID: L1j7aDu66uvnvpbEP9z28-Suic2yNEx6
Reporting-Meta:
 AAGG+8L4TP2VFa3Rq6FYe18eo/fsFW3gsPb7+px+eSj6IS6n9RS6WTeM0qZR2B8B
 dWGccV3RjycLZUknmd4wf0sMqLPlu6n6z45Q9KH2PHK24oLfc/9oMHQrwCgQvlTH
 G1PwCNl6/QGORi2ogQH0anGcta3JEOOZWzdu7ZqOTP4YF5uCedA1RheuiHxUk2hs
 XzI1G3qEDQ8OKvNp0LgudLI7vKjbowMZd3FkPGvE0/Iy6okkrKsPM8CrapB0U6KP
 aXemmqEMVTSL/PpvpcTBPLgD1UziiFc1n/WAz8bw3kCgIdYxYoGjCFAm+HfXmXYI
 xkvBFR/ExjXH9+wBzW1Xunxldo9SthXg3aCw/135jgkg4ekbhwBFFsYDD89BMiYL
 E47lB+N1rs51P8CcVA/et90sZjngpUgEfgUfceEwuMxTuyRa8MEDB7ylQ0UtgQm3
 EMg9eh2nPsii2Dqd54TPfN0vkh3roT/fdtyVE6RKDZv0LgRuGrOBt6U/LXiHT/Wg
 86bGB/2OYA/5PO8Gj4lYc8h+1Qbm8OBhJWyB+c/9dULh

On Mon, May 01, 2023 at 11:21:15AM +0800, Joseph Qi wrote:
> 
> 
> On 5/1/23 11:09 AM, Heming Zhao wrote:
> > On Mon, May 01, 2023 at 10:52:13AM +0800, Joseph Qi wrote:
> >>
> >>
> >> On 5/1/23 10:26 AM, Heming Zhao wrote:
> >>> On Mon, May 01, 2023 at 10:07:34AM +0800, Joseph Qi wrote:
> >>>> Hi,
> >>>>
> >>>> What's the journal status in this case?
> >>> jbd2 is marked with JBD2_ABORT
> >>>
> >>>> I wonder why commit thread is not working, which should flush journal
> >>>> and reset j_num_trans during commit cache.
> >>> The reason is in my above answer.
> >>>
> >>> below is the dmesg log for No. 266.
> >>>
> >>> ```
> >>> [  595.071807] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: joining the lockspace group...
> >>> [  595.080950] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
> >>> [  595.081091] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1
> >>> [  595.081580] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: add member 1
> >>> [  595.081886] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_members 1 nodes
> >>> [  595.082173] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: generation 1 slots 1 1:1
> >>> [  595.082420] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory
> >>> [  595.082696] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 in 0 new
> >>> [  595.082932] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 out 0 messages
> >>> [  595.083188] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1 generation 1 done: 0 ms
> >>> [  595.084721] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: join complete
> >>> [  595.095436] kernel: ocfs2: Mounting device (253,16) on (node 1, slot 0) with ordered data mode.
> >>> [  595.787078] systemd[1]: Started /usr/bin/bash -c exit 77.
> >>> [  595.802650] systemd[1]: fstests-check.scope: Deactivated successfully.
> >>> [  596.195734] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: joining the lockspace group...
> >>> [  596.206310] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: group event done 0
> >>> [  596.206350] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover 1
> >>> [  596.209667] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: add member 1
> >>> [  596.211433] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_members 1 nodes
> >>> [  596.213942] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: generation 1 slots 1 1:1
> >>> [  596.215668] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_directory
> >>> [  596.217171] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_directory 0 in 0 new
> >>> [  596.218253] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_directory 0 out 0 messages
> >>> [  596.219401] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover 1 generation 1 done: 0 ms
> >>> [  596.220628] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: join complete
> >>> [  596.224616] kernel: JBD2: Ignoring recovery information on journal
> >>> [  596.229686] kernel: ocfs2: Mounting device (253,32) on (node 1, slot 0) with ordered data mode.
> >>> [  596.870008] systemd[1]: fstest-scratch.mount: Deactivated successfully.
> >>> [  596.236135] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: leaving the lockspace group...
> >>> [  596.237431] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: group event done 0
> >>> [  596.239442] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: release_lockspace final free
> >>> [  596.877286] ocfs2_hb_ctl[5436]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u 78CE18109AE44E6AA896722A5E25CFC0
> >>> [  596.248299] kernel: ocfs2: Unmounting device (253,32) on (node 1)
> >>> [  596.255888] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: leaving the lockspace group...
> >>> [  596.905718] systemd[1]: fstest-test.mount: Deactivated successfully.
> >>> [  596.280602] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
> >>> [  596.281762] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: release_lockspace final free
> >>> [  596.921672] ocfs2_hb_ctl[5448]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u 838DD74847E34AA1839D6C4AA31132F1
> >>> [  596.299507] kernel: ocfs2: Unmounting device (253,16) on (node 1)
> >>> [  596.481755] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: joining the lockspace group...
> >>> [  596.484722] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1
> >>> [  596.484729] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
> >>> [  596.485361] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: add member 1
> >>> [  596.485622] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_members 1 nodes
> >>> [  596.485861] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: generation 1 slots 1 1:1
> >>> [  596.486063] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory
> >>> [  596.486293] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 in 0 new
> >>> [  596.486498] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 out 0 messages
> >>> [  596.486768] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1 generation 1 done: 0 ms
> >>> [  596.487037] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: join complete
> >>> [  596.491655] kernel: ocfs2: Mounting device (253,16) on (node 1, slot 0) with ordered data mode.
> >>> [  597.139758] root[5475]: run xfstest generic/266
> >>> [  596.505896] unknown: run fstests generic/266 at 2023-05-01 10:19:02
> >>> [  597.186885] systemd[1]: Started /usr/bin/bash -c test -w /proc/self/oom_score_adj && echo 250 > /proc/self/oom_score_adj; exec ./tests/generic/266.
> >>> [  597.566466] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: joining the lockspace group...
> >>> [  597.579759] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: group event done 0
> >>> [  597.579766] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1
> >>> [  597.581004] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: add member 1
> >>> [  597.581820] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_members 1 nodes
> >>> [  597.582292] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: generation 1 slots 1 1:1
> >>> [  597.582894] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory
> >>> [  597.583423] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 in 0 new
> >>> [  597.583991] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 out 0 messages
> >>> [  597.584547] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1 generation 1 done: 4 ms
> >>> [  597.585079] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: join complete
> >>> [  597.590136] kernel: JBD2: Ignoring recovery information on journal
> >>> [  597.594258] kernel: ocfs2: Mounting device (253,32) on (node 1, slot 0) with ordered data mode.
> >>> [  598.239046] systemd[1]: fstest-scratch.mount: Deactivated successfully.
> >>> [  597.606575] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: leaving the lockspace group...
> >>> [  597.607446] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: group event done 0
> >>> [  598.244507] ocfs2_hb_ctl[5680]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u AB0245F740984C25A9D0907D61DFCF8A
> >>> [  597.607843] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: release_lockspace final free
> >>> [  597.615474] kernel: ocfs2: Unmounting device (253,32) on (node 1)
> >>> [  597.641624] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: joining the lockspace group...
> >>> [  597.659435] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1
> >>> [  597.659479] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: group event done 0
> >>> [  597.661482] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: add member 1
> >>> [  597.662340] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_members 1 nodes
> >>> [  597.663211] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: generation 1 slots 1 1:1
> >>> [  597.664150] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory
> >>> [  597.665466] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 in 0 new
> >>> [  597.666370] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 out 0 messages
> >>> [  597.667235] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1 generation 1 done: 0 ms
> >>> [  597.668428] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: join complete
> >>> [  600.194974] systemd[1]: Started Daily Cleanup of Snapper Snapshots.
> >>> [  600.207227] dbus-daemon[672]: [system] Activating via systemd: service name='org.opensuse.Snapper' unit='snapperd.service' requested by ':1.10' (uid=0 pid=5728 comm="/usr/lib/snapper/systemd-helper --cleanup")
> >>> [  600.209151] systemd[1]: Starting DBus interface for snapper...
> >>> [  600.217270] dbus-daemon[672]: [system] Successfully activated service 'org.opensuse.Snapper'
> >>> [  600.217370] systemd[1]: Started DBus interface for snapper.
> >>> [  600.218969] systemd[1]: snapper-cleanup.service: Deactivated successfully.
> >>> [  599.608010] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: joining the lockspace group...
> >>> [  599.611041] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1
> >>> [  599.611127] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: group event done 0
> >>> [  599.611813] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: add member 1
> >>> [  599.612019] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_members 1 nodes
> >>> [  599.612227] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: generation 1 slots 1 1:1
> >>> [  599.612397] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory
> >>> [  599.612559] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 in 0 new
> >>> [  599.612712] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 out 0 messages
> >>> [  599.612880] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1 generation 1 done: 0 ms
> >>> [  599.613078] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: join complete
> >>> [  599.615320] kernel: JBD2: Ignoring recovery information on journal
> >>> [  599.619221] kernel: ocfs2: Mounting device (254,0) on (node 1, slot 0) with ordered data mode.
> >>> [  600.392044] systemd[1]: fstest-scratch.mount: Deactivated successfully.
> >>> [  599.780111] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: leaving the lockspace group...
> >>> [  599.781949] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: group event done 0
> >>> [  599.784235] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: release_lockspace final free
> >>> [  600.426136] ocfs2_hb_ctl[5762]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u F06626AE7D754F11A0211679C145C8BF
> >>> [  599.808566] kernel: ocfs2: Unmounting device (254,0) on (node 1)
> >>> [  599.827803] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: joining the lockspace group...
> >>> [  599.832848] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1
> >>> [  599.832984] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: group event done 0
> >>> [  599.833810] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: add member 1
> >>> [  599.834272] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_members 1 nodes
> >>> [  599.834663] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: generation 1 slots 1 1:1
> >>> [  599.835030] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory
> >>> [  599.835474] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 in 0 new
> >>> [  599.835868] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 out 0 messages
> >>> [  599.836365] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1 generation 1 done: 4 ms
> >>> [  599.836829] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: join complete
> >>> [  599.845790] kernel: ocfs2: Mounting device (254,0) on (node 1, slot 0) with ordered data mode.
> >>> [  600.079285] kernel: Buffer I/O error on dev dm-0, logical block 2621424, async page read
> >>> [  600.090845] kernel: (xfs_io,5785,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
> >>> [  600.091387] kernel: (xfs_io,5785,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
> >>> [  600.091924] kernel: (xfs_io,5785,0):ocfs2_statfs:1654 ERROR: status = -5
> >>> [  600.092422] kernel: (xfs_io,5785,0):ocfs2_statfs:1686 ERROR: status = -5
> >>> [  600.094252] kernel: (xfs_io,5785,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
> >>> [  600.095029] kernel: (xfs_io,5785,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
> >>> [  600.095891] kernel: (xfs_io,5785,0):ocfs2_statfs:1654 ERROR: status = -5
> >>> [  600.096698] kernel: (xfs_io,5785,0):ocfs2_statfs:1686 ERROR: status = -5
> >>> [  600.099071] kernel: (xfs_io,5785,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
> >>> [  600.099957] kernel: (xfs_io,5785,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
> >>> [  600.100798] kernel: (xfs_io,5785,0):ocfs2_statfs:1654 ERROR: status = -5
> >>> [  600.101623] kernel: (xfs_io,5785,0):ocfs2_statfs:1686 ERROR: status = -5
> >>> [  600.107094] kernel: (xfs_io,5785,1):ocfs2_get_refcount_tree:358 ERROR: status = -5
> >>> [  600.107659] kernel: (xfs_io,5785,1):ocfs2_lock_refcount_tree:456 ERROR: status = -5
> >>> [  600.108175] kernel: (xfs_io,5785,1):ocfs2_refcount_cow_hunk:3417 ERROR: status = -5
> >>> [  600.108654] kernel: (xfs_io,5785,1):ocfs2_refcount_cow:3478 ERROR: status = -5
> >>> [  600.109128] kernel: (xfs_io,5785,1):ocfs2_prepare_inode_for_write:2326 ERROR: status = -5
> >>> [  600.109613] kernel: (xfs_io,5785,1):ocfs2_file_write_iter:2433 ERROR: status = -5
> >>> [  600.118113] kernel: (umount,5789,3):ocfs2_inode_lock_update:2354 ERROR: status = -5
> >>> [  600.118481] kernel: (umount,5789,3):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
> >>> [  600.118898] kernel: (umount,5789,3):ocfs2_statfs:1654 ERROR: status = -5
> >>> [  600.119364] kernel: (umount,5789,3):ocfs2_statfs:1686 ERROR: status = -5
> >>> [  600.759255] systemd[1]: fstest-scratch.mount: Deactivated successfully.
> >>> [  600.127135] kernel: Buffer I/O error on dev dm-0, logical block 529, lost sync page write
> >>> [  600.127373] kernel: JBD2: I/O error when updating journal superblock for dm-0-24.
> >>> [  600.127615] kernel: Aborting journal on device dm-0-24.
> >>> [  600.127893] kernel: Buffer I/O error on dev dm-0, logical block 529, lost sync page write
> >>> [  600.128137] kernel: JBD2: I/O error when updating journal superblock for dm-0-24.
> >>> [  600.128362] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>> [  600.128591] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_thread:2346 ERROR: status = -5, journal is already aborted.
> >>> [  601.147704] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>> [  602.171745] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>> [  603.195707] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>> [  604.219709] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>> [  605.243712] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>> [  606.267748] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>> [  607.291715] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>> [  608.315742] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>> [  609.339724] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>> [  610.363774] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>> [  611.387693] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>> [  612.411727] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>> [  613.435719] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>> [  614.459743] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>> [  615.483742] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>> [  615.484503] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_thread:2346 ERROR: status = -5, journal is already aborted.
> >>> [  616.507742] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>> [  617.531751] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>> [  618.555743] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>> [  619.579702] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>> [  620.603758] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> >>> ^C
> >>> tb-fstest1:/usr/src/linux/fs/ocfs2 #
> >>> ```
> >>
> >> So the case is, flush journal in commit thread will never end if journal
> >> is abort, and then lead to umount hang since commit thread won't stop,
> >> right?
> > Yes.
> > 
> >>
> >> If so, I don't think your changes in sync fs is a right solution. It
> >> seems it just for bypassing the testcase.
> > No. 
> > In my view, No. 266 shouldn't trigger jbd2 ABORT status. The 'sync' should
> > tidy up all already issued write IOs. After sync & load dm-error, new write IOs
> > fails on rw IOs, which shouldn't generate any journal IOs and shouldn't trigger
> > jbd2 to enter ABORT status.
> > 
> 
> What if there is no 'sync' in this case?

It is same with issuing 'sync' case. Please differ:
'after [  600.079285] in above log' vs. 'after [  207.623776] in below log'

(The output of 'journalctl -f' when comment out 'sync' in NO. 266)
```
[  204.125234] root[2136]: run xfstest generic/266
[  203.943897] unknown: run fstests generic/266 at 2023-05-01 12:40:37
[  204.179159] systemd[1]: Started /usr/bin/bash -c test -w /proc/self/oom_score_adj && echo 250 > /proc/self/oom_score_adj; exec ./tests/generic/266.
[  205.000897] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: joining the lockspace group...
[  205.006914] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: dlm_recover 1
[  205.006919] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: group event done 0
[  205.007771] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: add member 1
[  205.008251] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: dlm_recover_members 1 nodes
[  205.008641] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: generation 1 slots 1 1:1
[  205.009043] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: dlm_recover_directory
[  205.009305] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: dlm_recover_directory 0 in 0 new
[  205.009640] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: dlm_recover_directory 0 out 0 messages
[  205.010061] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: dlm_recover 1 generation 1 done: 0 ms
[  205.010399] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: join complete
[  205.016329] kernel: JBD2: Ignoring recovery information on journal
[  205.020398] kernel: ocfs2: Mounting device (253,32) on (node 1, slot 0) with ordered data mode.
[  205.213841] systemd[1]: fstest-scratch.mount: Deactivated successfully.
[  205.218581] ocfs2_hb_ctl[2342]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u F8E488BAE771460B89ABD355D42B0264
[  205.033443] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: leaving the lockspace group...
[  205.034046] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: group event done 0
[  205.034296] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: release_lockspace final free
[  205.040937] kernel: ocfs2: Unmounting device (253,32) on (node 1)
[  205.066896] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: joining the lockspace group...
[  205.077350] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: dlm_recover 1
[  205.077419] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: group event done 0
[  205.078070] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: add member 1
[  205.078298] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: dlm_recover_members 1 nodes
[  205.078579] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: generation 1 slots 1 1:1
[  205.078823] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: dlm_recover_directory
[  205.079081] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: dlm_recover_directory 0 in 0 new
[  205.079276] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: dlm_recover_directory 0 out 0 messages
[  205.079493] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: dlm_recover 1 generation 1 done: 0 ms
[  205.079728] kernel: dlm: F8E488BAE771460B89ABD355D42B0264: join complete
[  207.150959] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: joining the lockspace group...
[  207.154653] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: group event done 0
[  207.154724] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: dlm_recover 1
[  207.155282] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: add member 1
[  207.155587] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: dlm_recover_members 1 nodes
[  207.155935] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: generation 1 slots 1 1:1
[  207.156220] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: dlm_recover_directory
[  207.156584] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: dlm_recover_directory 0 in 0 new
[  207.156860] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: dlm_recover_directory 0 out 0 messages
[  207.157130] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: dlm_recover 1 generation 1 done: 0 ms
[  207.157453] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: join complete
[  207.161303] kernel: JBD2: Ignoring recovery information on journal
[  207.165650] kernel: ocfs2: Mounting device (254,0) on (node 1, slot 0) with ordered data mode.
[  207.492458] systemd[1]: fstest-scratch.mount: Deactivated successfully.
[  207.334595] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: leaving the lockspace group...
[  207.338685] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: group event done 0
[  207.342262] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: release_lockspace final free
[  207.530465] ocfs2_hb_ctl[2410]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u 0304961B816D4F5CA1E793BD4655E027
[  207.365106] kernel: ocfs2: Unmounting device (254,0) on (node 1)
[  207.394907] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: joining the lockspace group...
[  207.408281] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: dlm_recover 1
[  207.408344] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: group event done 0
[  207.409397] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: add member 1
[  207.409826] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: dlm_recover_members 1 nodes
[  207.410239] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: generation 1 slots 1 1:1
[  207.410699] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: dlm_recover_directory
[  207.411147] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: dlm_recover_directory 0 in 0 new
[  207.411579] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: dlm_recover_directory 0 out 0 messages
[  207.412579] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: dlm_recover 1 generation 1 done: 4 ms
[  207.413093] kernel: dlm: 0304961B816D4F5CA1E793BD4655E027: join complete
[  207.420774] kernel: ocfs2: Mounting device (254,0) on (node 1, slot 0) with ordered data mode.
[  207.623776] kernel: Buffer I/O error on dev dm-0, logical block 2621424, async page read
[  207.627307] kernel: (xfs_io,2432,2):ocfs2_inode_lock_update:2354 ERROR: status = -5
[  207.627487] kernel: (xfs_io,2432,2):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
[  207.627635] kernel: (xfs_io,2432,2):ocfs2_statfs:1654 ERROR: status = -5
[  207.627771] kernel: (xfs_io,2432,2):ocfs2_statfs:1686 ERROR: status = -5
[  207.628009] kernel: (xfs_io,2432,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
[  207.628275] kernel: (xfs_io,2432,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
[  207.628521] kernel: (xfs_io,2432,0):ocfs2_statfs:1654 ERROR: status = -5
[  207.628786] kernel: (xfs_io,2432,0):ocfs2_statfs:1686 ERROR: status = -5
[  207.629079] kernel: (xfs_io,2432,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
[  207.629356] kernel: (xfs_io,2432,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
[  207.629628] kernel: (xfs_io,2432,0):ocfs2_statfs:1654 ERROR: status = -5
[  207.629868] kernel: (xfs_io,2432,0):ocfs2_statfs:1686 ERROR: status = -5
[  207.632449] kernel: (xfs_io,2432,0):ocfs2_get_refcount_tree:358 ERROR: status = -5
[  207.632807] kernel: (xfs_io,2432,0):ocfs2_lock_refcount_tree:456 ERROR: status = -5
[  207.633186] kernel: (xfs_io,2432,0):ocfs2_refcount_cow_hunk:3417 ERROR: status = -5
[  207.633467] kernel: (xfs_io,2432,0):ocfs2_refcount_cow:3478 ERROR: status = -5
[  207.633736] kernel: (xfs_io,2432,0):ocfs2_prepare_inode_for_write:2326 ERROR: status = -5
[  207.634022] kernel: (xfs_io,2432,0):ocfs2_file_write_iter:2433 ERROR: status = -5
[  207.634437] kernel: Buffer I/O error on dev dm-0, logical block 529, lost sync page write
[  207.634636] kernel: JBD2: I/O error when updating journal superblock for dm-0-24.
[  207.634788] kernel: Aborting journal on device dm-0-24.
[  207.634942] kernel: Buffer I/O error on dev dm-0, logical block 529, lost sync page write
[  207.635097] kernel: JBD2: I/O error when updating journal superblock for dm-0-24.
[  207.635339] kernel: (xfs_io,2432,0):ocfs2_sync_file:201 ERROR: status = -5
[  207.638738] kernel: (umount,2436,2):ocfs2_inode_lock_update:2354 ERROR: status = -5
[  207.638939] kernel: (umount,2436,2):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
[  207.639112] kernel: (umount,2436,2):ocfs2_statfs:1654 ERROR: status = -5
[  207.639281] kernel: (umount,2436,2):ocfs2_statfs:1686 ERROR: status = -5
[  207.823818] systemd[1]: fstest-scratch.mount: Deactivated successfully.
[  207.642501] kernel: (ocfs2cmt-030496,2419,0):ocfs2_commit_cache:321 ERROR: status = -5
[  207.642689] kernel: (ocfs2cmt-030496,2419,0):ocfs2_commit_thread:2346 ERROR: status = -5, journal is already aborted.
[  208.648030] kernel: (ocfs2cmt-030496,2419,0):ocfs2_commit_cache:321 ERROR: status = -5
[  209.672049] kernel: (ocfs2cmt-030496,2419,0):ocfs2_commit_cache:321 ERROR: status = -5
[  210.696057] kernel: (ocfs2cmt-030496,2419,0):ocfs2_commit_cache:321 ERROR: status = -5
[  211.720064] kernel: (ocfs2cmt-030496,2419,0):ocfs2_commit_cache:321 ERROR: status = -5
[  212.744068] kernel: (ocfs2cmt-030496,2419,0):ocfs2_commit_cache:321 ERROR: status = -5
[  213.768081] kernel: (ocfs2cmt-030496,2419,0):ocfs2_commit_cache:321 ERROR: status = -5
[  214.792079] kernel: (ocfs2cmt-030496,2419,0):ocfs2_commit_cache:321 ERROR: status = -5
[  215.816079] kernel: (ocfs2cmt-030496,2419,0):ocfs2_commit_cache:321 ERROR: status = -5
[  216.840090] kernel: (ocfs2cmt-030496,2419,0):ocfs2_commit_cache:321 ERROR: status = -5
[  217.863993] kernel: (ocfs2cmt-030496,2419,0):ocfs2_commit_cache:321 ERROR: status = -5
[  218.888057] kernel: (ocfs2cmt-030496,2419,0):ocfs2_commit_cache:321 ERROR: status = -5
[  219.912099] kernel: (ocfs2cmt-030496,2419,0):ocfs2_commit_cache:321 ERROR: status = -5
[  220.936106] kernel: (ocfs2cmt-030496,2419,0):ocfs2_commit_cache:321 ERROR: status = -5
[  221.960112] kernel: (ocfs2cmt-030496,2419,0):ocfs2_commit_cache:321 ERROR: status = -5
[  222.984116] kernel: (ocfs2cmt-030496,2419,0):ocfs2_commit_cache:321 ERROR: status = -5
[  222.984857] kernel: (ocfs2cmt-030496,2419,0):ocfs2_commit_thread:2346 ERROR: status = -5, journal is already aborted.
[  224.008130] kernel: (ocfs2cmt-030496,2419,0):ocfs2_commit_cache:321 ERROR: status = -5
[  225.032123] kernel: (ocfs2cmt-030496,2419,0):ocfs2_commit_cache:321 ERROR: status = -5
[  226.056075] kernel: (ocfs2cmt-030496,2419,0):ocfs2_commit_cache:321 ERROR: status = -5
^C
```

- Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
