Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BAFEC77B60
	for <ocfs2-devel@archiver.kernel.org>; Mon,  1 May 2023 02:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pCwSuaC5atzXsZQyUCjfYDwpTa0LcUChlOaNWRbBrEU=;
 b=Vg1LimBQH+APTFfQD9CwggfT7vKdnbXAzH59n7wzv0XlmSkx/8H4iKQHb/8ScgigCivBFLzQ3aIo
   gWqaNPQ8lZY1u5OnyJaUb6SitWv/yfxNzuynDe9Y9nI4QnWyRnleQfsSBiPqeMO1wNJb/eqfJEE9
   xYVKXVYd5Ps7fTBZ9JJA1y9x4I2Gfk8UNLTPLgUYdu1jnaaqPIR1EJCjy2RSo+2b6QiG9UIsFq+u
   RnvBCPuEcipHqeM3vG5t33KYL/LzIWTe0olTXybaTQeTxq9ZXauKiQCvuNvDmAUvOdv+yeU5q9iI
   ZdyqlobwenO9dh+PIZ9T6PnuU+j9YNWUwXqr9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pCwSuaC5atzXsZQyUCjfYDwpTa0LcUChlOaNWRbBrEU=;
 b=qvxDYxgsqgveCIZ1N7pbfKSvknkv9KPWK7I1zi4QBe3FR9YkogMPbg1ztIUaIuFpmoZe9UXgJ1my
   gZw4pR/SyF1idD08g1lcdyG2KmWYKTMU++83g+A1nsPdWfUiAZ8Imws7ap9hX8E6mD3Jk9ac9PLI
   z5ylXRbFBpeKQMOo+Q0vVJbxClkecmCDyW+N1TRMl0pdbu2xNY3mF/tuiQdD/qWzg3hApZN3llW7
   kMkq7w8ma7KuaJcTf3sLDTifTBHkh77W6LA95zkj8ib+AVpRGZzkJ7oIB4VXrdq0X2bB8eDiCjK3
   3AAjeO117sTSvslNI4x2dS8glNpNlQoAUdS0uw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RTY0088HK53U960@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 01 May 2023 02:27:03 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fn2dLE3FZEKpPS62SYl/Kq3rlj/jmmoagkv44asxQ1heOs6ZaKn4R2PlnEj58BFkAywj0GnkN/CULGPk6pHmiltmgY3q2G3rbcslQDbyc/gjBm+3ZyJ6fGqx+vDtQN9N6okkemvxIJi9EvrfiyiLGgVLn/5HR8OUATb4KTzESyU1vL9NJoidzWBjAee6dORI/fojO/CEWcaDfStkrgl8wyMy5eG99nlNi05zvf3HXnEwemf+tfA0oxBpzcGCMiY5+9II7fYHmnTx5s6LKhYLbG+R5cjKp35sO2hgz70RhBudZX+273A806ZT6xPK43rPKlH4p+2jRj1wtPWqe2uVZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2SXsBF2l0g3vWXmpP3zGuzuofJWbocz5iEGdDrhLA3U=;
 b=j3kNkCtyei7c9kWonQzfV/4QejULEKO+/hLdo/P18pkEYOEOl2Dm0IqN1KcyxZQyv5NtzX9B3GtHYE2MnVaLcrpaax2GfmmHq6RSV4HT82KpBvW9AniNW9GsTkPZPVqn5nlryn0ukgYGNzifoR10pzxTf0xz9eAM9PSDOCGTPPrGH23Oi5A+5NK/ruFzERTHFFmc5UC9xgucugMRc118iQ7SNugARSdrkV9N/jBgDJtim7yj1xd4S6xRMDpMKj23K5IA3ynbMEaSYQAKxk/UsTEU8uqgTUPB/3DRektWNlVyA4YToUB5gr9PVknvQYHbIRqr7GVUqwc/XOYAFwqVQQ==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2SXsBF2l0g3vWXmpP3zGuzuofJWbocz5iEGdDrhLA3U=;
 b=wWjcaGan19ADZj5kzrJk2DCQ3QGRNgekh3Yympvuhr6M2Ud7Jf+GXdvNXQLc5ykMIT0CXiJWeVFZp5udnsw2Ji09G7aXy9AP3tEhvo2Yov6C5kdeiYgDaScj+2onOuDhDbRTK7PBXZQ6B9ou278uJulH3B2TMWvEE/ebWFWmsLPhqJ7vLBeST6fFEYf6W2CCa+I/CeRZgKWLyHiArzDFQeYcl/oQS5vO+nhorK/6KF7c85XkhRBmgHFd9l0Wct8rcvA4Qygm7fXb6RZ/YMiFF0gDQPPFRLGt7PJ85GfEetZdwFMJIEBu0hyBTHPDG3Mji91Q6RTtqiU0DcMbopSnQw==
Date: Mon, 1 May 2023 10:26:28 +0800
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-id: <20230501022628.avrcx3exv3nev3fl@c73>
References: <20230430031302.15597-1-heming.zhao@suse.com>
 <b2942f09-9797-220f-db72-3b49b0859277@linux.alibaba.com>
Content-disposition: inline
In-reply-to: <b2942f09-9797-220f-db72-3b49b0859277@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB7997.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(366004)(39850400004)(136003)(346002)(396003)(376002)(451199021)(478600001)(83380400001)(186003)(6916009)(4326008)(66556008)(66476007)(66946007)(6506007)(6512007)(9686003)(53546011)(6486002)(6666004)(26005)(1076003)(316002)(8936002)(8676002)(44832011)(5660300002)(41300700001)(2906002)(30864003)(38100700002)(33716001)(86362001);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 02:26:39.0309 (UTC)
X-Source-IP: 40.107.22.59
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10696
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 mlxscore=0 clxscore=208 bulkscore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 impostorscore=0 priorityscore=95 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305010018 domainage_hfrom=9715
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
X-ClientProxiedBy: TYAPR01CA0161.jpnprd01.prod.outlook.com
 (2603:1096:404:7e::29) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|DU0PR04MB9418:EE_
X-MS-Office365-Filtering-Correlation-Id: f8a9a316-d1f5-4eb9-3e06-08db49eb7e42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 FnuMK/T/iMExIcyuMoaSAVaBxefQjJ4aYHHdK1Um3two8jCu3p6SLhSp7/Hjstt6rfr4ZN2+Uw+M4YBHyKcEQX1aydykX+w4vR+Jmg3PMKAnJs0rcqH4K4HuONectO+iQPfhouCGUzglutVFaMFRwklEvmUuVXoWFeUcw0vdvb4lX28lSa42oV/PKHYwF+jkLozLIUvf0eEjHRO0slvjscYZ7p+zYJaJbPnyEz2n4O8WzJx8K7zDG4qrFsmqIKtDsZKShNfgks14fGcnPzHOhVRfHyZs58xqJ8WuMuIaJPryGvAd8pVA52PCfNc7krupEr4ucd5wTfRUCckKmMd8H4EQMvkn2BipBwjej+qWUvDJUxqNiZyPrhei4bobFyi1D004IxYkgTPaHJmu+xLujoL9z47IPvErarNYSVHn1ub2d6e8sjvMKX0kNPHlwpPoIEG+YYcMTQWauOfQLN4egzMW2a6jRcquCHQagFdZmodACe8YxpGjc6YxYoHEGwvyRv6DlHrGZxxKZvk6Q+1eqtzJPV9XRnRX30EZWQAFyHfGgvvgGEeIuvkkpc1JJOYY
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?IOyJ1WMJqnGAGBdAdQ5n7JoPiJA4IeEkomvit6KIlVs8wGqGXoxJgTdru6wv?=
 =?us-ascii?Q?vxWP3SzpZA2wjmcHP4YSotTHO01q1rK+JYVpHBr/AEPd9VO2SpUr038tIvv4?=
 =?us-ascii?Q?7Zkn9oIbl2sJf23fJ37CPANTIJrnikiChMP3hjhnqCmUj44GT6HrHYx9uURA?=
 =?us-ascii?Q?sGno4ni/IextxLJaMKraqY/1LS01sVwv42d2vsg5a0wlV6v65HSL9rXHo7Pk?=
 =?us-ascii?Q?mUCnmYKQJaKQY83iS8v6u5K8EGMmPskEkQ6U8C86qZvU2yRNrBRS/zfvrC5K?=
 =?us-ascii?Q?E7G8Z+F4imYzTf1cglwgptMjjIUZTvQ3NGlHJSvnJFKu5SxGGIzNgvTiLDq2?=
 =?us-ascii?Q?HxjnohRAxtgAKQxWV/iFwSVvtUvuRL7ZIJGraXOJU2bsBQgiz94iO/BLVTTf?=
 =?us-ascii?Q?D9QbX/Dqr7CWrmHtyeZaSOT3qr8y+Nuou51xMm2ce7XlFTP+2RrvHkD5fveR?=
 =?us-ascii?Q?pOKVFtaqzXU8Ulti5tkrLHnWbN7gHvwi7fmZLRDhR9ikcP7coSVfYN5+dpGi?=
 =?us-ascii?Q?e4gdeRyuOhD7VUAVqNhqjLpUnk9QNdprW77ryvb0po2Vf8SKtQmKvdNgklMT?=
 =?us-ascii?Q?INV+cdh+dR0XUnV3ioJkfb5FIGEJ9kPZc1kKaTcAmUQsOvtVMts+qRP9EDSg?=
 =?us-ascii?Q?PZ9qtbZm3KIdr3QKAuV4BJSowkVOEtA9285amjeyomdguuaowV+3LbGRjK7f?=
 =?us-ascii?Q?kUQs0WLwys4hUtbNZWaZNm0luY1JDP0F9apY4J1wCtrG+6M0B2n56ICN6HM8?=
 =?us-ascii?Q?lwBt2QehG81vytZZ3b1tZWmz/vqERD7u4f4Nv5GsxwfO2hWzo6EznsjIZk0U?=
 =?us-ascii?Q?SBTLLTVGiiI3QXF1nVHlZOzCyUpkIEDZdaSsr30DMOH7T+cAsNE31m3wLLDv?=
 =?us-ascii?Q?D+YKskl6N47rnB8UfVK41LPJNILmEPBAYXrKSrSpFlYbZUtyjPvtoGDuMAiH?=
 =?us-ascii?Q?krcMeC8pdOR0fKjStDJKW+BesMFuzeUYwkYnamUntmWsZDk3rnQqAlIZGw2K?=
 =?us-ascii?Q?em2LwuDmNitcinQPxdqEbHNdW4SSStZ9eY++IYXZphGzeVPsIu4Ne/zxsuQy?=
 =?us-ascii?Q?A8Ol8W+HYPc8664QSTAMMu7UUp2G8bxi+UlH8HF0eYSNPfd55HQ/EysqdiDr?=
 =?us-ascii?Q?s6NMojANsq+PEnjGTx8kZzy4rBYA2Zg6wbEvj/FFjv7GpuO/agOClTzQ203g?=
 =?us-ascii?Q?t7tRLyHkhwPHbfsnRMCaxXdBcTUXqhgCbe+bcafOKA980zW1BGkGTcrbCIej?=
 =?us-ascii?Q?07+S6d4WdRfU8yF0ZCZT31nwzPARXgVDuLdbdgYeM84vx2mCE57hmMDOZRQp?=
 =?us-ascii?Q?LsprehuDpGO0RiGjgImbN3gMJaF1am4f0Ob6sLl3kZiKWMeLG8iQaneYAFXl?=
 =?us-ascii?Q?4UiIMQiVc6vp74xmCSR3WYOvb1OEJu+s/SStPYIS9+6kfAoON/0BvhsfjeID?=
 =?us-ascii?Q?O3e4j3XrskOYoUkHU263RIbBjl70VrOsdIL61WchT8m6SjO4sNIOj+Qr5S1A?=
 =?us-ascii?Q?5FQaw7BUoUXWh12vi4zBCc9PakATfo+nIN1nY6ABAxOeczXw64mNO4R879Ta?=
 =?us-ascii?Q?ImKnRcxsQV0SMLNkQabaqqcjk50reAT+n9VaRtzA?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 f8a9a316-d1f5-4eb9-3e06-08db49eb7e42
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 e54CBSRGftW1bgo9+b2HO8mMZRz9O5ozgSyKiUtzl9ohmoDz1epNdtHfe+jo0M/72LwAwT7sWzuaIl0rM0S2Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9418
X-ServerName: mail-am6eur05on2059.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: SbV2Q3DQ5J7fjKcNXY4Sh3Y1cqjhBkRf
X-Proofpoint-ORIG-GUID: SbV2Q3DQ5J7fjKcNXY4Sh3Y1cqjhBkRf
Reporting-Meta:
 AAGcUYav1pZCwLi1WFtWiajddg9ev5ryz3YMV1p+QWYSB2gDRlsyCbioeqD0tRJ9
 IVpKOc0QhIUCiMM+tIJxX3I82vCUPaQEfB1jg+TFi0PA/Buo2V8iqdtHob6Z2BEn
 xEnbDBF3fd6Tox2116DecdfxUub7qIrxcRsb0/+HtbdQBMuqQYqRkdMilPtYOTEK
 wzXup51F8ptzf7mo5+OAYz74UTBtYrrieKquyDY3OjYn/DohJuWiTRYv0MkUIKEn
 Q8st4WT2q3pPGjF0R5KBcBCfFUoIr817je/le8YvR/5rDLSX6jqKDdkDPQSV/Bt2
 Z78t2N+pXTNSOCB7gHNus7edgmd5bYvh0XfAp/iew7zvMxLtYu5M7ON4qFMs4J7P
 jAN4c+gTntIqhVa0R3RUifK4usGk4cbXaPFt0Ndf+8c1rBLusXmobhxd977ERGyk
 kMAAxcnNk5084273QG1Jv7M68VkdoAwVSbf/aZXCIhWTAtyUpwVwCLM2WEAU5Hyo
 ax7bFsW0/9l+aIzSIpmUyZ2YszBDPc2MwuDsCORcNm50

On Mon, May 01, 2023 at 10:07:34AM +0800, Joseph Qi wrote:
> Hi,
> 
> What's the journal status in this case?
jbd2 is marked with JBD2_ABORT

> I wonder why commit thread is not working, which should flush journal
> and reset j_num_trans during commit cache.
The reason is in my above answer.

below is the dmesg log for No. 266.

```
[  595.071807] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: joining the lockspace group...
[  595.080950] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
[  595.081091] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1
[  595.081580] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: add member 1
[  595.081886] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_members 1 nodes
[  595.082173] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: generation 1 slots 1 1:1
[  595.082420] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory
[  595.082696] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 in 0 new
[  595.082932] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 out 0 messages
[  595.083188] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1 generation 1 done: 0 ms
[  595.084721] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: join complete
[  595.095436] kernel: ocfs2: Mounting device (253,16) on (node 1, slot 0) with ordered data mode.
[  595.787078] systemd[1]: Started /usr/bin/bash -c exit 77.
[  595.802650] systemd[1]: fstests-check.scope: Deactivated successfully.
[  596.195734] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: joining the lockspace group...
[  596.206310] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: group event done 0
[  596.206350] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover 1
[  596.209667] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: add member 1
[  596.211433] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_members 1 nodes
[  596.213942] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: generation 1 slots 1 1:1
[  596.215668] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_directory
[  596.217171] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_directory 0 in 0 new
[  596.218253] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover_directory 0 out 0 messages
[  596.219401] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: dlm_recover 1 generation 1 done: 0 ms
[  596.220628] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: join complete
[  596.224616] kernel: JBD2: Ignoring recovery information on journal
[  596.229686] kernel: ocfs2: Mounting device (253,32) on (node 1, slot 0) with ordered data mode.
[  596.870008] systemd[1]: fstest-scratch.mount: Deactivated successfully.
[  596.236135] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: leaving the lockspace group...
[  596.237431] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: group event done 0
[  596.239442] kernel: dlm: 78CE18109AE44E6AA896722A5E25CFC0: release_lockspace final free
[  596.877286] ocfs2_hb_ctl[5436]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u 78CE18109AE44E6AA896722A5E25CFC0
[  596.248299] kernel: ocfs2: Unmounting device (253,32) on (node 1)
[  596.255888] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: leaving the lockspace group...
[  596.905718] systemd[1]: fstest-test.mount: Deactivated successfully.
[  596.280602] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
[  596.281762] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: release_lockspace final free
[  596.921672] ocfs2_hb_ctl[5448]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u 838DD74847E34AA1839D6C4AA31132F1
[  596.299507] kernel: ocfs2: Unmounting device (253,16) on (node 1)
[  596.481755] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: joining the lockspace group...
[  596.484722] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1
[  596.484729] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: group event done 0
[  596.485361] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: add member 1
[  596.485622] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_members 1 nodes
[  596.485861] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: generation 1 slots 1 1:1
[  596.486063] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory
[  596.486293] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 in 0 new
[  596.486498] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover_directory 0 out 0 messages
[  596.486768] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: dlm_recover 1 generation 1 done: 0 ms
[  596.487037] kernel: dlm: 838DD74847E34AA1839D6C4AA31132F1: join complete
[  596.491655] kernel: ocfs2: Mounting device (253,16) on (node 1, slot 0) with ordered data mode.
[  597.139758] root[5475]: run xfstest generic/266
[  596.505896] unknown: run fstests generic/266 at 2023-05-01 10:19:02
[  597.186885] systemd[1]: Started /usr/bin/bash -c test -w /proc/self/oom_score_adj && echo 250 > /proc/self/oom_score_adj; exec ./tests/generic/266.
[  597.566466] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: joining the lockspace group...
[  597.579759] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: group event done 0
[  597.579766] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1
[  597.581004] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: add member 1
[  597.581820] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_members 1 nodes
[  597.582292] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: generation 1 slots 1 1:1
[  597.582894] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory
[  597.583423] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 in 0 new
[  597.583991] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 out 0 messages
[  597.584547] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1 generation 1 done: 4 ms
[  597.585079] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: join complete
[  597.590136] kernel: JBD2: Ignoring recovery information on journal
[  597.594258] kernel: ocfs2: Mounting device (253,32) on (node 1, slot 0) with ordered data mode.
[  598.239046] systemd[1]: fstest-scratch.mount: Deactivated successfully.
[  597.606575] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: leaving the lockspace group...
[  597.607446] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: group event done 0
[  598.244507] ocfs2_hb_ctl[5680]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u AB0245F740984C25A9D0907D61DFCF8A
[  597.607843] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: release_lockspace final free
[  597.615474] kernel: ocfs2: Unmounting device (253,32) on (node 1)
[  597.641624] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: joining the lockspace group...
[  597.659435] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1
[  597.659479] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: group event done 0
[  597.661482] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: add member 1
[  597.662340] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_members 1 nodes
[  597.663211] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: generation 1 slots 1 1:1
[  597.664150] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory
[  597.665466] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 in 0 new
[  597.666370] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover_directory 0 out 0 messages
[  597.667235] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: dlm_recover 1 generation 1 done: 0 ms
[  597.668428] kernel: dlm: AB0245F740984C25A9D0907D61DFCF8A: join complete
[  600.194974] systemd[1]: Started Daily Cleanup of Snapper Snapshots.
[  600.207227] dbus-daemon[672]: [system] Activating via systemd: service name='org.opensuse.Snapper' unit='snapperd.service' requested by ':1.10' (uid=0 pid=5728 comm="/usr/lib/snapper/systemd-helper --cleanup")
[  600.209151] systemd[1]: Starting DBus interface for snapper...
[  600.217270] dbus-daemon[672]: [system] Successfully activated service 'org.opensuse.Snapper'
[  600.217370] systemd[1]: Started DBus interface for snapper.
[  600.218969] systemd[1]: snapper-cleanup.service: Deactivated successfully.
[  599.608010] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: joining the lockspace group...
[  599.611041] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1
[  599.611127] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: group event done 0
[  599.611813] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: add member 1
[  599.612019] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_members 1 nodes
[  599.612227] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: generation 1 slots 1 1:1
[  599.612397] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory
[  599.612559] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 in 0 new
[  599.612712] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 out 0 messages
[  599.612880] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1 generation 1 done: 0 ms
[  599.613078] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: join complete
[  599.615320] kernel: JBD2: Ignoring recovery information on journal
[  599.619221] kernel: ocfs2: Mounting device (254,0) on (node 1, slot 0) with ordered data mode.
[  600.392044] systemd[1]: fstest-scratch.mount: Deactivated successfully.
[  599.780111] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: leaving the lockspace group...
[  599.781949] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: group event done 0
[  599.784235] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: release_lockspace final free
[  600.426136] ocfs2_hb_ctl[5762]: ocfs2_hb_ctl /sbin/ocfs2_hb_ctl -K -u F06626AE7D754F11A0211679C145C8BF
[  599.808566] kernel: ocfs2: Unmounting device (254,0) on (node 1)
[  599.827803] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: joining the lockspace group...
[  599.832848] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1
[  599.832984] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: group event done 0
[  599.833810] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: add member 1
[  599.834272] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_members 1 nodes
[  599.834663] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: generation 1 slots 1 1:1
[  599.835030] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory
[  599.835474] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 in 0 new
[  599.835868] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover_directory 0 out 0 messages
[  599.836365] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: dlm_recover 1 generation 1 done: 4 ms
[  599.836829] kernel: dlm: F06626AE7D754F11A0211679C145C8BF: join complete
[  599.845790] kernel: ocfs2: Mounting device (254,0) on (node 1, slot 0) with ordered data mode.
[  600.079285] kernel: Buffer I/O error on dev dm-0, logical block 2621424, async page read
[  600.090845] kernel: (xfs_io,5785,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
[  600.091387] kernel: (xfs_io,5785,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
[  600.091924] kernel: (xfs_io,5785,0):ocfs2_statfs:1654 ERROR: status = -5
[  600.092422] kernel: (xfs_io,5785,0):ocfs2_statfs:1686 ERROR: status = -5
[  600.094252] kernel: (xfs_io,5785,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
[  600.095029] kernel: (xfs_io,5785,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
[  600.095891] kernel: (xfs_io,5785,0):ocfs2_statfs:1654 ERROR: status = -5
[  600.096698] kernel: (xfs_io,5785,0):ocfs2_statfs:1686 ERROR: status = -5
[  600.099071] kernel: (xfs_io,5785,0):ocfs2_inode_lock_update:2354 ERROR: status = -5
[  600.099957] kernel: (xfs_io,5785,0):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
[  600.100798] kernel: (xfs_io,5785,0):ocfs2_statfs:1654 ERROR: status = -5
[  600.101623] kernel: (xfs_io,5785,0):ocfs2_statfs:1686 ERROR: status = -5
[  600.107094] kernel: (xfs_io,5785,1):ocfs2_get_refcount_tree:358 ERROR: status = -5
[  600.107659] kernel: (xfs_io,5785,1):ocfs2_lock_refcount_tree:456 ERROR: status = -5
[  600.108175] kernel: (xfs_io,5785,1):ocfs2_refcount_cow_hunk:3417 ERROR: status = -5
[  600.108654] kernel: (xfs_io,5785,1):ocfs2_refcount_cow:3478 ERROR: status = -5
[  600.109128] kernel: (xfs_io,5785,1):ocfs2_prepare_inode_for_write:2326 ERROR: status = -5
[  600.109613] kernel: (xfs_io,5785,1):ocfs2_file_write_iter:2433 ERROR: status = -5
[  600.118113] kernel: (umount,5789,3):ocfs2_inode_lock_update:2354 ERROR: status = -5
[  600.118481] kernel: (umount,5789,3):ocfs2_inode_lock_full_nested:2502 ERROR: status = -5
[  600.118898] kernel: (umount,5789,3):ocfs2_statfs:1654 ERROR: status = -5
[  600.119364] kernel: (umount,5789,3):ocfs2_statfs:1686 ERROR: status = -5
[  600.759255] systemd[1]: fstest-scratch.mount: Deactivated successfully.
[  600.127135] kernel: Buffer I/O error on dev dm-0, logical block 529, lost sync page write
[  600.127373] kernel: JBD2: I/O error when updating journal superblock for dm-0-24.
[  600.127615] kernel: Aborting journal on device dm-0-24.
[  600.127893] kernel: Buffer I/O error on dev dm-0, logical block 529, lost sync page write
[  600.128137] kernel: JBD2: I/O error when updating journal superblock for dm-0-24.
[  600.128362] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
[  600.128591] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_thread:2346 ERROR: status = -5, journal is already aborted.
[  601.147704] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
[  602.171745] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
[  603.195707] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
[  604.219709] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
[  605.243712] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
[  606.267748] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
[  607.291715] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
[  608.315742] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
[  609.339724] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
[  610.363774] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
[  611.387693] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
[  612.411727] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
[  613.435719] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
[  614.459743] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
[  615.483742] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
[  615.484503] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_thread:2346 ERROR: status = -5, journal is already aborted.
[  616.507742] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
[  617.531751] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
[  618.555743] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
[  619.579702] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
[  620.603758] kernel: (ocfs2cmt-F06626,5771,2):ocfs2_commit_cache:321 ERROR: status = -5
^C
tb-fstest1:/usr/src/linux/fs/ocfs2 #
```

Thanks,
Heming

> 
> On 4/30/23 11:13 AM, Heming Zhao wrote:
> > fstest generic cases 266 272 281 trigger hanging issue when umount.
> > 
> > I use 266 to describe the root cause.
> > 
> > ```
> >  49 _dmerror_unmount
> >  50 _dmerror_mount
> >  51
> >  52 echo "Compare files"
> >  53 md5sum $testdir/file1 | _filter_scratch
> >  54 md5sum $testdir/file2 | _filter_scratch
> >  55
> >  56 echo "CoW and unmount"
> >  57 sync
> >  58 _dmerror_load_error_table
> >  59 urk=$($XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" \
> >  60     -c "fdatasync" $testdir/file2 2>&1)
> >  61 echo $urk >> $seqres.full
> >  62 echo "$urk" | grep -q "error" || _fail "pwrite did not fail"
> >  63
> >  64 echo "Clean up the mess"
> >  65 _dmerror_unmount
> > ```
> > 
> > After line 49 50 umount & mount ocfs2 dev, this case run md5sum to
> > verify target file. Line 57 run 'sync' before line 58 changes the dm
> > target from dm-linear to dm-error. This case is hanging at line 65.
> > 
> > The md5sum calls jbd2 trans pair: ocfs2_[start|commit]_trans to
> > do journal job. But there is only ->j_num_trans+1 in ocfs2_start_trans,
> > the ocfs2_commit_trans doesn't do reduction operation, 'sync' neither.
> > finally no function reset ->j_num_trans until umount is triggered.
> > 
> > call flow:
> > ```
> > [md5sum] //line 53 54
> >  vfs_read
> >   ocfs2_file_read_iter
> >    ocfs2_inode_lock_atime
> >     ocfs2_update_inode_atime
> >      + ocfs2_start_trans //atomic_inc j_num_trans
> >      + ...
> >      + ocfs2_commit_trans//no modify j_num_trans
> > 
> > sync //line 57. no modify j_num_trans
> > 
> > _dmerror_load_error_table //all write will return error after this line
> > 
> > _dmerror_unmount //found j_num_trans is not zero, run commit thread
> >                //but the underlying dev is dm-error, journaling IO
> >                //failed all the time and keep going to retry.
> > ```
> > 
> > *** How to fix ***
> > 
> > kick commit thread in sync path, which can reset j_num_trans to 0.
> > 
> > Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> > ---
> >  fs/ocfs2/super.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> > index 0b0e6a132101..bb3fa21e9b47 100644
> > --- a/fs/ocfs2/super.c
> > +++ b/fs/ocfs2/super.c
> > @@ -412,6 +412,9 @@ static int ocfs2_sync_fs(struct super_block *sb, int wait)
> >  			jbd2_log_wait_commit(osb->journal->j_journal,
> >  					     target);
> >  	}
> > +	/* kick commit thread to reset journal->j_num_trans */
> > +	if (atomic_read(&(osb->journal->j_num_trans)))
> > +		wake_up(&osb->checkpoint_event);
> >  	return 0;
> >  }
> >  

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
