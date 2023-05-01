Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BD88C77B7F
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 May 2023 03:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=B9asFNqmKn/ZYvnF4EpoQ0CbxRHM+HgSZ3gZ+nAsZVI=;
 b=V7EQuuQBy9u8pZN2V6zBPee9JqsO+GU4yICU7mokMEAjbGQ0VJlmhb5RfeEW7kuN3YmOJMsgDHCm
   ZpPrZpaHyr880smJu4TzLVvpOzyYAiCMtJlBCc8bNTQWoprdF7LIDnEn/s3+TaXgyBNV9kfyQ5Qz
   AynRk4DDWlkNiAhuoD/S2tRATTi33YhAHJdzB6Wt9/RSo/tSl6BuOqZp/4FBXWP7QYeZ8N5Ux4CZ
   TjAo4xYh5SF+TVohmIA4xigXvAyel21NT7UQwGjdq85e8NkODwuQRyy80LAaht3vC+I76gPbQUOT
   WjcR74wteuOGwfOOwUt7tM2dEruNBUSaaJvwvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=B9asFNqmKn/ZYvnF4EpoQ0CbxRHM+HgSZ3gZ+nAsZVI=;
 b=H3SDPHDXUBKg+tzeIr63pXf5gh7qYfH9YrwQUeFBvztbTsIS6rWR1lXF7YLIu60RFNg7B7cPTHkQ
   Bvhg41X4ixgp01hc44T9wMhAVM02zXjYiSJr3U6hD80o5BOM+w9oJdkVm9v0P/9Nvjr3mlAcX86E
   hkqVADmXt6Z/VEA241VHGcuywS20/xsldMNvNZWNmjJMgTXn9zqv2dEAwtF7KuQEIoFaopBGbmGP
   zlMA7NFEm8wGtoAwaoVdNP+q4p38jsrdjN1AQQv19ehJdh9qgU2sld+lAHSyItnqgi82nVgdOoQT
   RVV3IJ728mtRxnKDMsImouzgh7a73Tqbag+VdA==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RTY008DWMHXU970@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 01 May 2023 03:17:57 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hf6SD2ubvuaFzUEiETWGp3gS7irt5Gp5eqfT8X2cApW4zIG/VvT18rWkYTQOFt6IB/BdproG1kW3/12pBtwKX4PDBHvtII+CCAydWREmgOCwIXGJT0+5D70EjGGzuj6Y4EhQsCz2TcPcf8aATZpgNAJP0T4KfxG5xdzKuvyWlrSxJROJgj8ygBdRf7MTnUJCqOnrwB2zJEkL+wKGUs13nDxAgrN0D31fVLcqGHdtnfWmqZEBNGXq9YClO1gvnaQKZ22AoDhDn72aoL8vMt0Y19BSHgt5W1p4JvzLSAlT1dJDwgVy6VKdBqshRE7QcNf2oKfll5NsXMD5dDSeZYpndw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H72O3FnR5kmIl8u668+1ex7c0c9n4kVWP8kcWD8QZIc=;
 b=TpKnG+XhDgr22uRawAI793kVx3VCeDZvonPl+v1YrBvGThukKSD1N8qR0LtJllrtC/z6gWVUOUcUK8bSFvFvJQOYunfgka5pNFPJmnQlVzgaB9JMxnAZSSUMbMX4vSiLpwS2Ty3e5BGZLYS9+P0dt6X7tYDLwJmlC8Bkw6h3qd/iDh2ZL+ph3FFlZgpmXfNSqvve2nLZd/nXyHo18r1YVX8co+jvrEjHknHsSi+UANRKddxv35bbNOPqHfObmhgXaa9wMt7CxWyxahjlkeBsSU8ZAJQQeC6UB5FFU2Tq23Mghldfxg/qFjwscWsgip+l3DbcPbh+CzsPJM9L3Sm2rQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H72O3FnR5kmIl8u668+1ex7c0c9n4kVWP8kcWD8QZIc=;
 b=cEi1oAg1hq9DyvzvgXI7Y6OeXzvumXZfM/8+IZaL12u3GRuCEGps/f5/rOvWHr4YGtYWoB1SD9t6AiZlJwvb2Vn5fzULzpmOfkiQhLIemE1fQSW7euTl7A1Z9B9iZZENMHGOP+e3j9AXJe01gogiOpsmvwtU6vQdZzZSZCn3Lga/4u85GPoEft9iGHOJtQTWFCL4BfZrsENIikIZbYxBkBXAIiD8GScJePFipyA1KqVxr+bj2mja29/358RQshrylJdXc3E1Ap/qMZpVayWZUs2GKSbPNNBsfH1NkOdMYjzhEwxjLmf82rlDpDN60XIWIGnFuFra+UcY505slGWfRw==
Date: Mon, 1 May 2023 11:17:30 +0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20230501031730.sr2mp44najt5e5xk@c73>
References: <20230430031302.15597-1-heming.zhao@suse.com>
 <b2942f09-9797-220f-db72-3b49b0859277@linux.alibaba.com>
 <20230501022628.avrcx3exv3nev3fl@c73>
 <d9d1fc18-39d8-2888-c540-faac2d3f5628@linux.alibaba.com>
 <20230501030958.ps6xssjcvu6pnpnl@c73>
Content-disposition: inline
In-reply-to: <20230501030958.ps6xssjcvu6pnpnl@c73>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(136003)(39850400004)(366004)(396003)(346002)(376002)(451199021)(83380400001)(478600001)(6486002)(6666004)(6512007)(6506007)(1076003)(26005)(186003)(9686003)(53546011)(33716001)(44832011)(2906002)(30864003)(5660300002)(38100700002)(66476007)(66556008)(66946007)(4326008)(6916009)(41300700001)(8936002)(8676002)(86362001)(316002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 03:17:38.5862 (UTC)
X-Source-IP: 40.107.105.52
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10696
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 priorityscore=90 adultscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 clxscore=186
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305010025 domainage_hfrom=9715
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
X-ClientProxiedBy: SG2PR01CA0120.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::24) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|PA4PR04MB7695:EE_
X-MS-Office365-Filtering-Correlation-Id: ea05182b-5a2c-41df-928b-08db49f29de9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 wtPRGULWI4VQzPAussnaWYeXFGXoRTS+8UUcSF4ZAWDqFdncMPHj204zUkGuvSV33AhrKzupDQELmsz18AI0jkEnWlK2hNkvRoe/5PC1OIoDD+kVgZ1rmV2sn4RBWyzZaCoFuAQ1xzsLVRGtdF+DVB8X9lAvQ6wutjr1dSfauAO5CCz5obC1lQa/rlNfK2W21ZOtQMtvtelJDXmsw3yMjBv9xm/nwBKTwboidsoPuv4Uaey1dQKo5opEGIk38hS8dZAwHT2E1sDf4Mi45B8OU+cYeLdKUGCBtND7lHcjRqOQCQ9NBjzd7oppVuae1CHb+TJfvjrigztrYhbjRLCeWxzXP+K6Vaspz6xCwduGs5IS0flY2qiz6AScApXwQCq0D4ZimdYSFytxct3RptyzzKzPp6kNvz2sLuv07gpF8LgFOqylsNbezcYNdIOQ9pwEeq5kw0tRP122tdyjc0frcXp49ZHYykUIp8Uo3PFefex1cD5EjjxLD/uRHWuNawXmQANQCcMK52/4WzW0k6TowMaXjTZ3MsrceEoHS1mWmIAqg9ImZkwd5+/Lu1vPBGWL
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?TUGlMJN6wNdXS7r1X0o0HdOUvm5zBdFqT2fmkoUOcPkc8Y4GsBrBOV/ZUZSk?=
 =?us-ascii?Q?UjsPXCjqeRvSSMr4HSs9p/OqnG6q2ReEZyHeCKNXnM2gJ4y8ByNtDXZaCIcp?=
 =?us-ascii?Q?RQz0Eu1mKgfWIT+4ayTUnd+cRbOOW1Xd4X3xfCSV0buvyRMWjOzgNKsNShXn?=
 =?us-ascii?Q?fh6ZHn9iAUhRKcEfYKtQyb543v7bvIlXr5RQmEGDoZa/sb7FBJ/HiFo8JO9M?=
 =?us-ascii?Q?gPpNzPQYCAMPooYL+czI8fzisnSQM7z+q/HFAE1ViLsFT9ahdHqwteKkIZ6L?=
 =?us-ascii?Q?811S+dqnS9Co9Zz+516Kl9W28C/e6BTlbOlnj3VX0L8i+kgN42wKiR3Z/KBf?=
 =?us-ascii?Q?rd+swWsNlAIJfQWmuk/VMC3lnJDhpVFgsy4p8GIePtvqOAOBBsKtPCJ54Smx?=
 =?us-ascii?Q?S4smwpqjCxV3eLVhbhC2ylcvKVF7WpvBBFC8bB2f5vGwwGy0U8t7VZwSoEb+?=
 =?us-ascii?Q?xqGzWMnAmsWd+EYUAbvAET1VtTJhxIQMEimLksv1ycxHvcX9AQs8cvLgjXzO?=
 =?us-ascii?Q?M8vbnwlbgpf87JGK2TlGOTJhSf3bxkPoFig/1TCreC9cORth7hIAgpQxaf9f?=
 =?us-ascii?Q?BYzCNJe/fnYbb0HFZwna28oJDkESnzdDoMl90m6K+gFcSTTDKObZowK06mlO?=
 =?us-ascii?Q?rw6TwS1aNc8Mnf9n33WcBZ8NEmFpd1tLcLdCZku5/sO3aTV0u23xHf++Wg9x?=
 =?us-ascii?Q?9hUsHSBaUhL+kI0gHpJdGf3RrQ3ZjVOrNO4RW8sT84pXzscr1f2zmiKi4uI4?=
 =?us-ascii?Q?SrWw4SE5BNI7ErPiclDBYF94iN1oG9/bQyX+zf7lP202ef75E7arWop/9zC3?=
 =?us-ascii?Q?oE35in8pW804J2LupNFS5qeV2amT47Wkcbd96AcSpcV6EJevjoHlerqmayko?=
 =?us-ascii?Q?AxdFmSatkpdB08LpxaEOwAgtvK/SGpxulCKzRFUQu1jxhaPC4pen5Che4oKJ?=
 =?us-ascii?Q?3uDL014mp19JG4wCeNcHwPA8u99tcC6H8EOlAGtre2g1QzqLJe/MxaMExRzk?=
 =?us-ascii?Q?zJoa/vUKB/fhQuN9E+iDU6quTz25uVsUFkQyaMWfPPsoZZQypnbq3UAEeXbE?=
 =?us-ascii?Q?btZi7M44RkWCY9wXjaZ6c7v5slFYOejVeY3Q+RdMa3dmwpfHWWgx4/vm1Ca3?=
 =?us-ascii?Q?tnj0/QLKs8lUWGyWQR4LTZPdJENsI2Nc2gZPt7+h1S0Mfabo60k0/20FS287?=
 =?us-ascii?Q?Dc3aXPaTkD1eRbdcaeeDiYHHbdkRYmG3SQdrhX1ydDgS4U/Y5ljpDV1JUr5z?=
 =?us-ascii?Q?EasVZMSfKL0Sun7iyZThpSBGIBGl4T6MWyePcX1+MP8aW3setbnjvb9JxD+l?=
 =?us-ascii?Q?PbtgQnO+8XtFW+gaxcYO4jlTvXjj+nFcCAe8IxkSxcSGhipdDTeIvzzUePNi?=
 =?us-ascii?Q?qqHTmbxl6a9u225dwQ4PTfmiOdPeQ3aaXSgcco3i1JNeV/Kht2SxWFXcraRW?=
 =?us-ascii?Q?TZBKpFJqi3ZR3ujTouaatnl/cNXfpWGQPO37IduOxpuZLFpKrDBV6xLPVkRT?=
 =?us-ascii?Q?nWFPbPLOPQWihxtsddn/3ClxlBhT/oQFQhctxg1mGxivCTBvtR2Mm6uJiS7z?=
 =?us-ascii?Q?0YuFtbKKh4ICjR1eFU+z+dZGghOgT9w9KaLlTfIf?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 ea05182b-5a2c-41df-928b-08db49f29de9
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 AuaMYalglALywz+e1sKa4IjHqVEXW+D4oWbfUd9uUkMy+YWeKTHOxXrS9QdMdFCQaUooflmzMd817kq37Io5Zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7695
X-ServerName: mail-am7eur03on2052.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: 3BMpWxPokMwNdTC72cKec8uBWQQgB6ar
X-Proofpoint-ORIG-GUID: 3BMpWxPokMwNdTC72cKec8uBWQQgB6ar
Reporting-Meta:
 AAFQRohtcMUyXuGbXo6Njhd5NOv1xBRuYIZY72Z8scwZ1ve1RpEGyKRvqRf5SA+V
 CFrt4Gz+4ungiE3nAZjAtgXEk6I5Y3QHdxoJK44mQ6jUFqAlN2ZV2hDZ7fcwyNR/
 wX/iddZU5LbtEozHdzP8gwFwMks5kPz6w/xsVM9VM7I0QJDqOY7CIr8Wm2iT7D4u
 QiNwJ78+PIrt2pooxmaz6hz2xmDjm+jcHH923o7J/JRpwop54wDfvjiLvYeKU12v
 5DtI2T2vFtrbvPls7jQCuFg4/7xWyjbcQOEe6vGOiQQj8ZPBsu1I88mIlXQreg7s
 6WOt+pLh8Fh9z5Jc2dZXwCznjrOpNXGrbDX7TjZOVJZXq9n2epcg2ehNBbX14pzo
 ZOuvOTEsWoc1+w9PKM88rSoHcjXWkViDZdaQCZ/dBcRxFCXIvopTA31Q/7dbrbrK
 +YuXkUZy4FrHekOnH9dXjTb5524mhVdp4UKx4RdlFHk49HBNz1/qubhFnJL9cFrJ
 o/NSVvukitcdYwEb2sNudQOg7HlMtoOYAV5tp9OH7r3I

On Mon, May 01, 2023 at 11:10:06AM +0800, Heming Zhao wrote:
> On Mon, May 01, 2023 at 10:52:13AM +0800, Joseph Qi wrote:
> > 
> > 
> > On 5/1/23 10:26 AM, Heming Zhao wrote:
> > > On Mon, May 01, 2023 at 10:07:34AM +0800, Joseph Qi wrote:
> > >> Hi,
> > >>
> > >> What's the journal status in this case?
> > > jbd2 is marked with JBD2_ABORT
> > > 
> > >> I wonder why commit thread is not working, which should flush journal
> > >> and reset j_num_trans during commit cache.
> > > The reason is in my above answer.
> > > 
> > > below is the dmesg log for No. 266.
> > > 
> > > ```
> > > [  595.071807] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: joining the lockspace group...
> > > [  595.080950] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
> > > [  595.081091] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1
> > > [  595.081580] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: add member 1
> > > [  595.081886] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_members 1 nodes
> > > [  595.082173] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: generation 1 slots 1 1:1
> > > [  595.082420] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory
> > > [  595.082696] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 in 0 new
> > > [  595.082932] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 out 0 messages
> > > [  595.083188] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1 generation 1 done: 0 ms
> > > [  595.084721] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: join complete
> > > [  595.095436] kernel: ocfs2: Mounting device (253,16) on (node 1, slot 0) with ordered data mode.
> > > [  595.787078] systemd[1]: Started /usr/bin/bash -c exit 77.
> > > [  595.802650] systemd[1]: fstests-check.scope: Deactivated successfully.
> > > [  596.195734] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: joining the lockspace group...
> > > [  596.206310] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: group event done 0
> > > [  596.206350] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover 1
> > > [  596.209667] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: add member 1
> > > [  596.211433] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_members 1 nodes
> > > [  596.213942] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: generation 1 slots 1 1:1
> > > [  596.215668] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_directory
> > > [  596.217171] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_directory 0 in 0 new
> > > [  596.218253] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_directory 0 out 0 messages
> > > [  596.219401] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover 1 generation 1 done: 0 ms
> > > [  596.220628] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: join complete
> > > [  596.224616] kernel: JBD2: Ignoring recovery information on journal
> > > [  596.229686] kernel: ocfs2: Mounting device (253,32) on (node 1, slot 0) with ordered data mode.
> > > [  596.870008] systemd[1]: fstest-scratch.mount: Deactivated successfully.
> > > [  596.236135] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: leaving the lockspace group...
> > > [  596.237431] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: group event done 0
> > > [  596.239442] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: release_lockspace final free
> > > [  596.877286] ocfs2_hb_ctl[5436]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u 78CE18109AE44E6AA896722A5E25CFC0
> > > [  596.248299] kernel: ocfs2: Unmounting device (253,32) on (node 1)
> > > [  596.255888] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: leaving the lockspace group...
> > > [  596.905718] systemd[1]: fstest-test.mount: Deactivated successfully.
> > > [  596.280602] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
> > > [  596.281762] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: release_lockspace final free
> > > [  596.921672] ocfs2_hb_ctl[5448]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u 838DD74847E34AA1839D6C4AA31132F1
> > > [  596.299507] kernel: ocfs2: Unmounting device (253,16) on (node 1)
> > > [  596.481755] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: joining the lockspace group...
> > > [  596.484722] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1
> > > [  596.484729] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
> > > [  596.485361] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: add member 1
> > > [  596.485622] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_members 1 nodes
> > > [  596.485861] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: generation 1 slots 1 1:1
> > > [  596.486063] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory
> > > [  596.486293] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 in 0 new
> > > [  596.486498] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 out 0 messages
> > > [  596.486768] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1 generation 1 done: 0 ms
> > > [  596.487037] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: join complete
> > > [  596.491655] kernel: ocfs2: Mounting device (253,16) on (node 1, slot 0) with ordered data mode.
> > > [  597.139758] root[5475]: run xfstest generic/266
> > > [  596.505896] unknown: run fstests generic/266 at 2023-05-01 10:19:02
> > > [  597.186885] systemd[1]: Started /usr/bin/bash -c test -w /proc/self/oom_score_adj && echo 250 > /proc/self/oom_score_adj; exec ./tests/generic/266.
> > > [  597.566466] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: joining the lockspace group...
> > > [  597.579759] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: group event done 0
> > > [  597.579766] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1
> > > [  597.581004] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: add member 1
> > > [  597.581820] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_members 1 nodes
> > > [  597.582292] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: generation 1 slots 1 1:1
> > > [  597.582894] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory
> > > [  597.583423] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 in 0 new
> > > [  597.583991] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 out 0 messages
> > > [  597.584547] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1 generation 1 done: 4 ms
> > > [  597.585079] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: join complete
> > > [  597.590136] kernel: JBD2: Ignoring recovery information on journal
> > > [  597.594258] kernel: ocfs2: Mounting device (253,32) on (node 1, slot 0) with ordered data mode.
> > > [  598.239046] systemd[1]: fstest-scratch.mount: Deactivated successfully.
> > > [  597.606575] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: leaving the lockspace group...
> > > [  597.607446] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: group event done 0
> > > [  598.244507] ocfs2_hb_ctl[5680]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u AB0245F740984C25A9D0907D61DFCF8A
> > > [  597.607843] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: release_lockspace final free
> > > [  597.615474] kernel: ocfs2: Unmounting device (253,32) on (node 1)
> > > [  597.641624] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: joining the lockspace group...
> > > [  597.659435] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1
> > > [  597.659479] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: group event done 0
> > > [  597.661482] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: add member 1
> > > [  597.662340] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_members 1 nodes
> > > [  597.663211] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: generation 1 slots 1 1:1
> > > [  597.664150] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory
> > > [  597.665466] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 in 0 new
> > > [  597.666370] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 out 0 messages
> > > [  597.667235] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1 generation 1 done: 0 ms
> > > [  597.668428] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: join complete
> > > [  600.194974] systemd[1]: Started Daily Cleanup of Snapper Snapshots.
> > > [  600.207227] dbus-daemon[672]: [system] Activating via systemd: service name='org.opensuse.Snapper' unit='snapperd.service' requested by ':1.10' (uid=0 pid=5728 comm="/usr/lib/snapper/systemd-helper --cleanup")
> > > [  600.209151] systemd[1]: Starting DBus interface for snapper...
> > > [  600.217270] dbus-daemon[672]: [system] Successfully activated service 'org.opensuse.Snapper'
> > > [  600.217370] systemd[1]: Started DBus interface for snapper.
> > > [  600.218969] systemd[1]: snapper-cleanup.service: Deactivated successfully.
> > > [  599.608010] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: joining the lockspace group...
> > > [  599.611041] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1
> > > [  599.611127] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: group event done 0
> > > [  599.611813] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: add member 1
> > > [  599.612019] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_members 1 nodes
> > > [  599.612227] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: generation 1 slots 1 1:1
> > > [  599.612397] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory
> > > [  599.612559] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 in 0 new
> > > [  599.612712] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 out 0 messages
> > > [  599.612880] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1 generation 1 done: 0 ms
> > > [  599.613078] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: join complete
> > > [  599.615320] kernel: JBD2: Ignoring recovery information on journal
> > > [  599.619221] kernel: ocfs2: Mounting device (254,0) on (node 1, slot 0) with ordered data mode.
> > > [  600.392044] systemd[1]: fstest-scratch.mount: Deactivated successfully.
> > > [  599.780111] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: leaving the lockspace group...
> > > [  599.781949] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: group event done 0
> > > [  599.784235] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: release_lockspace final free
> > > [  600.426136] ocfs2_hb_ctl[5762]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u F06626AE7D754F11A0211679C145C8BF
> > > [  599.808566] kernel: ocfs2: Unmounting device (254,0) on (node 1)
> > > [  599.827803] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: joining the lockspace group...
> > > [  599.832848] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1
> > > [  599.832984] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: group event done 0
> > > [  599.833810] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: add member 1
> > > [  599.834272] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_members 1 nodes
> > > [  599.834663] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: generation 1 slots 1 1:1
> > > [  599.835030] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory
> > > [  599.835474] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 in 0 new
> > > [  599.835868] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 out 0 messages
> > > [  599.836365] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1 generation 1 done: 4 ms
> > > [  599.836829] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: join complete
> > > [  599.845790] kernel: ocfs2: Mounting device (254,0) on (node 1, slot 0) with ordered data mode.
> > > [  600.079285] kernel: Buffer I/O error on dev dm-0, logical block 2621424, async page read
> > > [  600.090845] kernel: (xfs_io,5785,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
> > > [  600.091387] kernel: (xfs_io,5785,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
> > > [  600.091924] kernel: (xfs_io,5785,0):ocfs2_statfs:1654 ERROR: status = -5
> > > [  600.092422] kernel: (xfs_io,5785,0):ocfs2_statfs:1686 ERROR: status = -5
> > > [  600.094252] kernel: (xfs_io,5785,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
> > > [  600.095029] kernel: (xfs_io,5785,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
> > > [  600.095891] kernel: (xfs_io,5785,0):ocfs2_statfs:1654 ERROR: status = -5
> > > [  600.096698] kernel: (xfs_io,5785,0):ocfs2_statfs:1686 ERROR: status = -5
> > > [  600.099071] kernel: (xfs_io,5785,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
> > > [  600.099957] kernel: (xfs_io,5785,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
> > > [  600.100798] kernel: (xfs_io,5785,0):ocfs2_statfs:1654 ERROR: status = -5
> > > [  600.101623] kernel: (xfs_io,5785,0):ocfs2_statfs:1686 ERROR: status = -5
> > > [  600.107094] kernel: (xfs_io,5785,1):ocfs2_get_refcount_tree:358 ERROR: status = -5
> > > [  600.107659] kernel: (xfs_io,5785,1):ocfs2_lock_refcount_tree:456 ERROR: status = -5
> > > [  600.108175] kernel: (xfs_io,5785,1):ocfs2_refcount_cow_hunk:3417 ERROR: status = -5
> > > [  600.108654] kernel: (xfs_io,5785,1):ocfs2_refcount_cow:3478 ERROR: status = -5
> > > [  600.109128] kernel: (xfs_io,5785,1):ocfs2_prepare_inode_for_write:2326 ERROR: status = -5
> > > [  600.109613] kernel: (xfs_io,5785,1):ocfs2_file_write_iter:2433 ERROR: status = -5
> > > [  600.118113] kernel: (umount,5789,3):ocfs2_inode_lock_update:2354 ERROR: status = -5
> > > [  600.118481] kernel: (umount,5789,3):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
> > > [  600.118898] kernel: (umount,5789,3):ocfs2_statfs:1654 ERROR: status = -5
> > > [  600.119364] kernel: (umount,5789,3):ocfs2_statfs:1686 ERROR: status = -5
> > > [  600.759255] systemd[1]: fstest-scratch.mount: Deactivated successfully.
> > > [  600.127135] kernel: Buffer I/O error on dev dm-0, logical block 529, lost sync page write
> > > [  600.127373] kernel: JBD2: I/O error when updating journal superblock for dm-0-24.
> > > [  600.127615] kernel: Aborting journal on device dm-0-24.
> > > [  600.127893] kernel: Buffer I/O error on dev dm-0, logical block 529, lost sync page write
> > > [  600.128137] kernel: JBD2: I/O error when updating journal superblock for dm-0-24.
> > > [  600.128362] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > > [  600.128591] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_thread:2346 ERROR: status = -5, journal is already aborted.
> > > [  601.147704] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > > [  602.171745] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > > [  603.195707] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > > [  604.219709] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > > [  605.243712] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > > [  606.267748] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > > [  607.291715] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > > [  608.315742] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > > [  609.339724] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > > [  610.363774] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > > [  611.387693] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > > [  612.411727] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > > [  613.435719] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > > [  614.459743] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > > [  615.483742] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > > [  615.484503] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_thread:2346 ERROR: status = -5, journal is already aborted.
> > > [  616.507742] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > > [  617.531751] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > > [  618.555743] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > > [  619.579702] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > > [  620.603758] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
> > > ^C
> > > tb-fstest1:/usr/src/linux/fs/ocfs2 #
> > > ```
> > 
> > So the case is, flush journal in commit thread will never end if journal
> > is abort, and then lead to umount hang since commit thread won't stop,
> > right?
> Yes.
> 
> > 
> > If so, I don't think your changes in sync fs is a right solution. It
> > seems it just for bypassing the testcase.
> No. 
> In my view, No. 266 shouldn't trigger jbd2 ABORT status. The 'sync' should
> tidy up all already issued write IOs. After sync & load dm-error, new write IOs
> fails on rw IOs, which shouldn't generate any journal IOs and shouldn't trigger
> jbd2 to enter ABORT status.
> 
> > 
> > If the expected behavior is to let umount ends even journal is abort,
> > it seems we have to make journal shutdown happy in this case.
> This is my [patch 2/2] job, which resolves fstest generaic NO. 347 361 628 629.
> 
> - Heming

The log after patching [1/2] (without patch [2/2])

```
[ 2252.964874] root[2991]: run xfstest generic/266
[ 2252.566084] unknown: run fstests generic/266 at 2023-05-01 10:58:37
[ 2253.006923] systemd[1]: Started /usr/bin/bash -c test -w /proc/self/oom_score_adj && echo 250 > /proc/self/oom_score_adj; exec ./tests/generic/266.
[ 2253.595670] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: joining the lockspace group...
[ 2253.598924] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: dlm_recover 1
[ 2253.598954] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: group event done 0
[ 2253.601184] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: add member 1
[ 2253.602340] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: dlm_recover_members 1 nodes
[ 2253.602624] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: generation 1 slots 1 1:1
[ 2253.602842] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: dlm_recover_directory
[ 2253.603010] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: dlm_recover_directory 0 in 0 new
[ 2253.603171] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: dlm_recover_directory 0 out 0 messages
[ 2253.603340] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: dlm_recover 1 generation 1 done: 0 ms
[ 2253.603619] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: join complete
[ 2253.606374] kernel: JBD2: Ignoring recovery information on journal
[ 2253.611239] kernel: ocfs2: Mounting device (253,32) on (node 1, slot 0) with ordered data mode.
[ 2254.020143] systemd[1]: fstest-scratch.mount: Deactivated successfully.
[ 2253.623800] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: leaving the lockspace group...
[ 2253.624720] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: group event done 0
[ 2253.626368] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: release_lockspace final free
[ 2254.027879] ocfs2_hb_ctl[3197]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u D9AC6C30527E4F8799E9BCDAC64F2F47
[ 2253.634342] kernel: ocfs2: Unmounting device (253,32) on (node 1)
[ 2253.659701] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: joining the lockspace group...
[ 2253.668134] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: group event done 0
[ 2253.668158] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: dlm_recover 1
[ 2253.668583] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: add member 1
[ 2253.668792] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: dlm_recover_members 1 nodes
[ 2253.669003] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: generation 1 slots 1 1:1
[ 2253.669211] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: dlm_recover_directory
[ 2253.669670] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: dlm_recover_directory 0 in 0 new
[ 2253.670034] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: dlm_recover_directory 0 out 0 messages
[ 2253.670610] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: dlm_recover 1 generation 1 done: 4 ms
[ 2253.671041] kernel: dlm: D9AC6C30527E4F8799E9BCDAC64F2F47: join complete
[ 2255.687006] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: joining the lockspace group...
[ 2255.689981] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: group event done 0
[ 2255.689993] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: dlm_recover 1
[ 2255.690435] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: add member 1
[ 2255.690688] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: dlm_recover_members 1 nodes
[ 2255.690897] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: generation 1 slots 1 1:1
[ 2255.691128] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: dlm_recover_directory
[ 2255.691354] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: dlm_recover_directory 0 in 0 new
[ 2255.691561] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: dlm_recover_directory 0 out 0 messages
[ 2255.691847] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: dlm_recover 1 generation 1 done: 0 ms
[ 2255.692446] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: join complete
[ 2255.695546] kernel: JBD2: Ignoring recovery information on journal
[ 2255.700152] kernel: ocfs2: Mounting device (254,0) on (node 1, slot 0) with ordered data mode.
[ 2256.230778] systemd[1]: fstest-scratch.mount: Deactivated successfully.
[ 2255.851082] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: leaving the lockspace group...
[ 2255.853187] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: group event done 0
[ 2255.855128] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: release_lockspace final free
[ 2256.260312] ocfs2_hb_ctl[3265]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u 0DCC4C24451D49CF918C2994FD09B36B
[ 2255.871911] kernel: ocfs2: Unmounting device (254,0) on (node 1)
[ 2255.885376] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: joining the lockspace group...
[ 2255.898789] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: dlm_recover 1
[ 2255.898801] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: group event done 0
[ 2255.899523] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: add member 1
[ 2255.899899] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: dlm_recover_members 1 nodes
[ 2255.900227] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: generation 1 slots 1 1:1
[ 2255.900544] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: dlm_recover_directory
[ 2255.900875] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: dlm_recover_directory 0 in 0 new
[ 2255.901153] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: dlm_recover_directory 0 out 0 messages
[ 2255.901516] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: dlm_recover 1 generation 1 done: 0 ms
[ 2255.901944] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: join complete
[ 2255.908503] kernel: ocfs2: Mounting device (254,0) on (node 1, slot 0) with ordered data mode.
[ 2256.139340] kernel: Buffer I/O error on dev dm-0, logical block 2621424, async page read
[ 2256.151624] kernel: (xfs_io,3288,1):ocfs2_inode_lock_update:2354 ERROR: status = -5
[ 2256.152027] kernel: (xfs_io,3288,1):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
[ 2256.152422] kernel: (xfs_io,3288,1):ocfs2_statfs:1652 ERROR: status = -5
[ 2256.152778] kernel: (xfs_io,3288,1):ocfs2_statfs:1684 ERROR: status = -5
[ 2256.154220] kernel: (xfs_io,3288,1):ocfs2_inode_lock_update:2354 ERROR: status = -5
[ 2256.154673] kernel: (xfs_io,3288,1):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
[ 2256.154995] kernel: (xfs_io,3288,1):ocfs2_statfs:1652 ERROR: status = -5
[ 2256.155272] kernel: (xfs_io,3288,1):ocfs2_statfs:1684 ERROR: status = -5
[ 2256.157120] kernel: (xfs_io,3288,1):ocfs2_inode_lock_update:2354 ERROR: status = -5
[ 2256.157425] kernel: (xfs_io,3288,1):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
[ 2256.157713] kernel: (xfs_io,3288,1):ocfs2_statfs:1652 ERROR: status = -5
[ 2256.157994] kernel: (xfs_io,3288,1):ocfs2_statfs:1684 ERROR: status = -5
[ 2256.160671] kernel: (xfs_io,3288,3):ocfs2_get_refcount_tree:358 ERROR: status = -5
[ 2256.160956] kernel: (xfs_io,3288,3):ocfs2_lock_refcount_tree:456 ERROR: status = -5
[ 2256.161205] kernel: (xfs_io,3288,3):ocfs2_refcount_cow_hunk:3417 ERROR: status = -5
[ 2256.161445] kernel: (xfs_io,3288,3):ocfs2_refcount_cow:3478 ERROR: status = -5
[ 2256.161680] kernel: (xfs_io,3288,3):ocfs2_prepare_inode_for_write:2326 ERROR: status = -5
[ 2256.161918] kernel: (xfs_io,3288,3):ocfs2_file_write_iter:2433 ERROR: status = -5
[ 2256.570033] systemd[1]: fstest-scratch.mount: Deactivated successfully.
[ 2256.166077] kernel: (umount,3292,3):ocfs2_inode_lock_update:2354 ERROR: status = -5
[ 2256.166494] kernel: (umount,3292,3):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
[ 2256.166745] kernel: (umount,3292,3):ocfs2_statfs:1652 ERROR: status = -5
[ 2256.166965] kernel: (umount,3292,3):ocfs2_statfs:1684 ERROR: status = -5
[ 2256.174011] kernel: (umount,3292,3):ocfs2_inode_lock_update:2354 ERROR: status = -5
[ 2256.174249] kernel: (umount,3292,3):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
[ 2256.174511] kernel: (umount,3292,3):ocfs2_shutdown_local_alloc:416 ERROR: status = -5
[ 2256.175558] kernel: Buffer I/O error on dev dm-0, logical block 70163, lost sync page write
[ 2256.176960] kernel: (umount,3292,3):ocfs2_write_block:78 ERROR: status = -5
[ 2256.177256] kernel: (umount,3292,3):ocfs2_update_disk_slot:199 ERROR: status = -5
[ 2256.177498] kernel: (umount,3292,3):ocfs2_put_slot:517 ERROR: status = -5
[ 2256.178604] kernel: Buffer I/O error on dev dm-0, logical block 24, lost sync page write
[ 2256.178933] kernel: (umount,3292,2):ocfs2_write_block:78 ERROR: status = -5
[ 2256.179215] kernel: (umount,3292,2):ocfs2_journal_toggle_dirty:984 ERROR: status = -5
[ 2256.179449] kernel: (umount,3292,2):ocfs2_journal_shutdown:1052 ERROR: status = -5
[ 2256.179881] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: leaving the lockspace group...
[ 2256.181581] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: group event done 0
[ 2256.182134] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: release_lockspace final free
[ 2256.583796] ocfs2_hb_ctl[3293]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u 0DCC4C24451D49CF918C2994FD09B36B
[ 2256.194870] kernel: ocfs2: Unmounting device (254,0) on (node 1)
[ 2256.202861] kernel: dm-0: detected capacity change from 20971520 to 0
[ 2256.241314] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: joining the lockspace group...
[ 2256.244424] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: dlm_recover 1
[ 2256.244431] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: group event done 0
[ 2256.245010] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: add member 1
[ 2256.245186] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: dlm_recover_members 1 nodes
[ 2256.245360] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: generation 1 slots 1 1:1
[ 2256.245527] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: dlm_recover_directory
[ 2256.245690] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: dlm_recover_directory 0 in 0 new
[ 2256.245848] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: dlm_recover_directory 0 out 0 messages
[ 2256.246015] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: dlm_recover 1 generation 1 done: 0 ms
[ 2256.246295] kernel: dlm: 0DCC4C24451D49CF918C2994FD09B36B: join complete
[ 2257.367729] kernel: ocfs2: Unable to create the lockspace 0DCC4C24451D49CF918C2994FD09B36B (-17), because a ocfs2-tools program is running on this file system with the same name lockspace
[ 2257.368058] kernel: (mount.ocfs2,3306,0):ocfs2_dlm_init:3355 ERROR: status = -17
[ 2257.368264] kernel: (mount.ocfs2,3306,2):ocfs2_mount_volume:1808 ERROR: status = -17
[ 2257.368596] kernel: (mount.ocfs2,3306,2):ocfs2_fill_super:1192 ERROR: status = -17
[ 2257.800975] systemd[1]: fstests-generic-266.scope: Deactivated successfully.
[ 2257.823311] systemd[1]: fstest-test.mount: Deactivated successfully.
[ 2257.424691] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: leaving the lockspace group...
[ 2257.426048] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
[ 2257.829022] ocfs2_hb_ctl[3323]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u 838DD74847E34AA1839D6C4AA31132F1
[ 2257.427000] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: release_lockspace final free
[ 2257.434399] kernel: ocfs2: Unmounting device (253,16) on (node 1)
[ 2337.361206] CRON[3392]: (root) CMD (run-parts /etc/cron.hourly)
[ 2337.367344] CRON[3391]: (root) CMDEND (run-parts /etc/cron.hourly)
[ 2365.960233] systemd[1]: Started Timeline of Snapper Snapshots.
[ 2365.967411] dbus-daemon[672]: [system] Activating via systemd: service name='org.opensuse.Snapper' unit='snapperd.service' requested by ':1.12' (uid=0 pid=3407 comm="/usr/lib/snapper/systemd-helper --timeline")
[ 2365.969446] systemd[1]: Starting DBus interface for snapper...
[ 2365.973698] dbus-daemon[672]: [system] Successfully activated service 'org.opensuse.Snapper'
[ 2365.973755] systemd[1]: Started DBus interface for snapper.
[ 2365.974893] systemd[1]: snapper-timeline.service: Deactivated successfully.
[ 2426.037566] systemd[1]: snapperd.service: Deactivated successfully.
^C
tb-fstest1:/usr/src/linux/fs/ocfs2 #
```

- Heming

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
