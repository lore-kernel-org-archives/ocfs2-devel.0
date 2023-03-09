Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CEF7C77B70
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VV5ycL/rrzfz40VhLSzUmLD9xTPEt4U/sG+Hr4/L+XM=;
 b=QOqen7LAtcVsWgF2SFLnVyfbwDgL5VpsbQoBcyFTnes2/Mn4TadxQvJwlV6zgnOzGd5l0RfczXid
   pFmZHTWVGwr1dtnnjz1gGhVesYpW+zbZh0YjpF8IgYU2nPyD6i5K5j9vfeyWU4wdAzfdgmbJBTpH
   0KFd7nuzafdTXlwFtxOVf+oGXdCY+a0ZvbFu1+iTIXvV7TYwiaFmYtSyUlMdJm1A+9iZtoqWlX5u
   lkITXwEohfYf9ZqH5HH7U/J/gzCaJEz9aRMlz/uJVHZodKhPBtWyrfHreexRoy9RxMENutHECSyt
   YjNsbgNcjF0oEmPf5Da275Wa1EI+9GGSiGmTAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VV5ycL/rrzfz40VhLSzUmLD9xTPEt4U/sG+Hr4/L+XM=;
 b=BiNfn3tyyGG0Ha9SDrvsID9u2aO/RUdmrRcLtoH/qKhC/GqIkalU9zG4f5+DpOKX3pTTrC70gjFA
   zEa3wr2cRNwxhECzlXnm4OE9e6UsgVJPlVhBd9MCMj05Q+dxQ8I/0hy+zKSKeUJqtJKjzaXANTQ0
   l4Y4/VfFYIcE7+24Oh8t10K7EtzFxWzvLOVTkMbf6tj521QE8GT5+36NsPGFe7Lg8AZzqQiwhewM
   1YN/kQ6GROHAZVyapYNFL+04XCD576hPUF8w7DVSX6aREMUASOBEELB1NeaGQ7/XyRIVda4Wehi1
   XzWy+Ib3sGwZNZRhTMTNMJ4IR7VSIVpB5l0axA==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX00C12M17MR20@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fcE/kJOhXB5/1pcmhSTwMa833IWizB4BGSF1LfwQVo70NFrxvYYBuSEt4pyfvYG0TUtIz0sfJLaIjz6JsuI3fDM0AlX56wDcFqhPYKeR65U0ubfrhXfzKAyG7acBsnicfMjpAgu+ZrdQND+lHVaX0ygig8u1/RwAO1rJAwxkcXg70twWebrAhOc6NFzpQr+u4pzzygukujc5zHRLZ47PZUAOr5lFLUrJC2POc6Sf1iqd4d+9nrnOMxBs3naGiTCp2ufhi+xVX1cWnb1p1ZXtyx9iMTQUuNSXa8MgWGVLpryCaKTDp6ppq5/mpSZQj1s5E410JOdxZ/p6Pk8vTV++6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G74P5nAgOBnT3973GEAuaWOahRROTtd9l+A09L6rMFE=;
 b=P1X1yguHqbUjxZC3QWtYQ4aYSQCQieiQ4MH9oYVuT1iRnTsxUt3klB68e9qW7bSLx6sLHC8Kr5GlOUukPUMDKrXyuC6R5Q4m4I/H5+G7+p51nSBCSR58Sp2r6My0/ElIZC1e5/S1+fr5zQnTJEoBFiNlTOK0InHlpQAcq6UJjB2mUb+9ulAiZqQKf9ZA0gczBa03OZ17H0CpDH5nRa9CKEYe65ChhaZJCRKcQuiHUFKVw00RJeRKCVsampITeR8IZMg97MqXQSg7eJ2ZBTySKFIa2Azft9UNsxBgUU8VLvkn11s5OuvoHIEJgFSvdi7th67ozCMasEV81twc7a2Lkw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com; dkim=pass
 header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G74P5nAgOBnT3973GEAuaWOahRROTtd9l+A09L6rMFE=;
 b=rAZE++Nip+T3xmn38Yj02pSeIhjtUtUNKbbaQq3fNVaeb7acz9fUbmqAtdWuGHhSCPNfciVwlP72UGZdUFIdEXPJydraUIgtjfVGeZTNEHs8Rk/y1atVqN+wC99w2am0WVnXyitLEQzQqR+XIO6E373/CUhKmkC2lTzquA66QtiMayyNRv8T+hrtjzG0j5eaFAtkyCa/SBmD1SVvtGZmYMI9M6IxjX+JHLToZM2XCLOGeG/WqPngz+hfKEDl1B3iE9/KZ41JaGqDwcre5R9BT4uru1YZRZC99h0LfunHdhFzfnYzK9WBeVv+XuwSLmROAUn1sKlJ+rKm6XuQIZkwwA==
To: xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com,
 jefflexu@linux.alibaba.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 rpeterso@redhat.com, agruenba@redhat.com, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, viro@zeniv.linux.org.uk, brauner@kernel.org
Date: Thu,  9 Mar 2023 23:21:25 +0800
Message-id: <20230309152127.41427-4-frank.li@vivo.com>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20230309152127.41427-1-frank.li@vivo.com>
References: <20230309152127.41427-1-frank.li@vivo.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SEZPR06MB5269.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199018)(316002)(36756003)(921005)(86362001)(38350700002)(38100700002)(1076003)(6506007)(26005)(107886003)(6512007)(83380400001)(6666004)(186003)(2616005)(8936002)(5660300002)(6486002)(478600001)(7416002)(52116002)(41300700001)(4744005)(66946007)(2906002)(66556008)(8676002)(4326008)(66476007);
 DIR:OUT; SFP:1102;
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 15:22:16.7352 (UTC)
X-Source-IP: 40.107.255.118
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10643
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 priorityscore=120 malwarescore=0
 mlxlogscore=714 adultscore=0 clxscore=85 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303090121 domainage_hfrom=9102
Cc: Yangtao Li <frank.li@vivo.com>, linux-kernel@vger.kernel.org,
 cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v3 4/6] ext4: convert to use i_blockmask()
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
From: Yangtao Li via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Yangtao Li <frank.li@vivo.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: SG2PR04CA0168.apcprd04.prod.outlook.com (2603:1096:4::30) To
 SEZPR06MB5269.apcprd06.prod.outlook.com (2603:1096:101:78::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5269:EE_|SI2PR06MB4073:EE_
X-MS-Office365-Filtering-Correlation-Id: 56a97193-f5e8-4681-cf1e-08db20b21104
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 au3ShEGDkB+EJng6ExCV4irih+z00QukWDh7Spxuy8qWzB/QKoK+CueEysS5/nkcABEu97dp/Qs1ayTZzhXvAsz9S9kDnJ9o4/dHCcLL6dw9SPf5Hh4swt8uLkao+3K7S5wwcpy1DLk4a8xtZArks1bPI5ZMPJeW0haZ57YnTWB0rRqryMEVq6DbIVnurNfBzQ5icFtLdtShWGbEMV43vrusCNvgtnRmBgKF6hE3XyLcbLfKIsz37ZcF+EChLDwf4/OCehLxwb21SCfphgueLuG74tRWKFUvywa+oU7Eb2NTNexAR+jwYzyX6c2TgKlLPmcYXDhfrCPNyGCrLOKYBNV8vBQvl89aPYa11VAuphzsWWcAe+egWE0zTbt3mAlePpoWWA2I4ys5K53VJOnHNia/q3EEhKNoHwnkMvnJaeVvPZfvg67OqGMl6MW/k7DHEK1gKJCO1K3VpMU6myXOcx14YWnXy6dEDMHRGm5ZFsRO6qxOH68vNA9azbeqackX2YB5T3dDUXQXpt7zMIxD5dSwIr57AlU7zZOAkXqHSDFTkqplNXvSpouJkFeXEqKJKwxJTMDb9QxBnXUB5HpmxQ5vLnn0lKbzJEnhKhEDSf82myryXjrQACiQ8cK0HRXVJ/u6rOA3uUeChqurd2UW+Q/cDRvDtN80GGof5sWWSigsnvE1Dy9RKEZpexV8NKFBT+96mHy47d1TUq+CaobJj7utACDMN30INvL0eQEUUsM=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?J6UAysLpoBieQVl74u8AD7N6g9pZBKiK9aoHlx5UOs8MzLg5kLQAIpekTjxX?=
 =?us-ascii?Q?4lkJHJycoA2byXmMFtjX2TsjltV0IDzQrko1CniKcojXQZ+v2TrQmQysu0lt?=
 =?us-ascii?Q?zdXL8ljZdkocXRUHm/+ybfnnKpgETDprT1p9VBnwxemoD5uLM8RECM+N8sZ5?=
 =?us-ascii?Q?naSyUzw+A8oLwjmvMA/eiWRruB22HXVEjR3bTi/lcrIiNR5vtnJAZS5t2xsZ?=
 =?us-ascii?Q?g3Za3gWYHxwYvnRMG/yi3P1AhGdMqWpUPVzL0sGlRQ4vQ/PQBmT2GUlCRh+G?=
 =?us-ascii?Q?A+cL0oyZJbxlAAwYiDwhDCu0UafTHkL9xs7O8nZoHsl2QRl+jujqRUWVIG42?=
 =?us-ascii?Q?XRHOU9qKKNoKQZG5wVXDTzcqanWuFBB7raXymFm0c/OoJ3Kd6Z5p8XiPLHj9?=
 =?us-ascii?Q?LH9eaC2twO/OKmSW51mhB54DkGDeaWFLZqBj38Xx3TdzJb7Cn7tF5guYOAXM?=
 =?us-ascii?Q?IgvAhDov3z8cLHwf4CWji9dzPEQriP4nzkp1N95//+/jpPenjCkF1kSz1Mjx?=
 =?us-ascii?Q?sMATQ7yfA+EBdy8GkcMcCH3HMiOjJZccNIC5JpYxKHvq0PUVTcVcvfPytpPc?=
 =?us-ascii?Q?0HktKrFa7QZskRqQYW6g3bovglr2xxcyu6z0ICD6EldkLMCYdO4vAraojnLG?=
 =?us-ascii?Q?49+FLyfnDY/MevPee1VucvV8IyflvFHGBdzNExocAcVb8zsKQzmDSd6GECRF?=
 =?us-ascii?Q?+l7RwdXSKiJS3XBNs+5JpPU4Q6tQSboOCFBtrDsQs1YxmzNyh2lbHkmINO8q?=
 =?us-ascii?Q?zLygGxfx9I6LoOdHuSZS8zP15AiGVP+WAR+XunpUFlIGjOtR7O+9zXE8G/vC?=
 =?us-ascii?Q?GA/6/VN3h06M/c3SAbViv49673AZkrR+lz8s13DFp2wNNb1xKH2IFYdvoZsY?=
 =?us-ascii?Q?1aK8DODNZgrcyZ3OlQ8Ds6hL43wzmloQ8POFYZORU76s8qjE/BJxMXzU0FmA?=
 =?us-ascii?Q?ipxJ5xdsvp0BL5j5idevrrzlB8x6ECMKVY//n+MaxbJbsFm3b4bBYqYS570X?=
 =?us-ascii?Q?7nkjw6UB5+mwdst05L4wRyJb3NZdfLETRhPX+AeNQB6VtC12p9L/tbcFW3e9?=
 =?us-ascii?Q?6ZLl4BZUf5G5wtjAzEfcGXs8kof5NnwBllBj0eXjPZXYUk1RV56BD9RzUC+5?=
 =?us-ascii?Q?PBkY0fi6uZ7Iiis3nwEfZEfG1BynaQ58PRRALgKZZmaQ+IwMSO7ZRM8aBhR/?=
 =?us-ascii?Q?PVm3f11wFnYJXlkcP+SLUIMEZddiGZtu1R4noim9VD0i1NORnPcq40+XOzKI?=
 =?us-ascii?Q?Dox9R3kiUx1O/r49xPnUCBcnGjxlChXnd/NJLAxIizoHT+bFdVp+ZKBfc8Ks?=
 =?us-ascii?Q?Xg65Zui7vsYSmzn1rbWmPUgD21S1ab33ztL3fOsc88aUqYm/Z4V+A/DIjSyy?=
 =?us-ascii?Q?7fWgSrwQVmsVwItUsU6v5AOMTSHiiZPME3doyCBxlVFwF3/m8L905Shz1ViG?=
 =?us-ascii?Q?PUB9P6k7J85M6sYM++MuTYjzZd1nB2kfmRN+dL3OAwlAHyfPv3eSHnYzq+IU?=
 =?us-ascii?Q?KxfuPhjA0JMFnciEOGmmBvrX7K9AAf+3b12H6LUMdpFjVEiMj2gVyrZtvXG7?=
 =?us-ascii?Q?c0xlQiWx1yN5eil2jKEmXjrQY2L8XQIegV7cGVmF?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 56a97193-f5e8-4681-cf1e-08db20b21104
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 faSx+15nOOVnxKx09cjuIr/fJZJg5x4PEYIAtclVHogsw9WqPzeR+hciF7EE/sTXuOlHCF7Jw70/lfFxIfKYDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB4073
X-ServerName: mail-psaapc01on2118.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.protection.outlook.com -all
X-Spam: Clean
X-Proofpoint-GUID: eXqYtKh7AEgxGTmWqhnolBQ1LZIm0nzy
X-Proofpoint-ORIG-GUID: eXqYtKh7AEgxGTmWqhnolBQ1LZIm0nzy
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAFlzmelxJYUdzSHAgGvziIcTlKXWfVv6VJzwfs81Z/WOU2w9Zp5jRQAyHpQ8EHf
 e3nAvPsXt2282S03ZKlutNmSV/lARUO4WGgSpXUoWsnsT5zcfyHAqQThJq8U6CHY
 gmH/yZG9j8J7kEDreRUS66fUpA58PnyTowLaBEh0s/l/eQ22/OKbfb8qoDEniPUI
 D49H8VmYiZ2/na6213TioXjXOuZXWDpMwV7eEt+cghPD2ILHjd/FZP7V0+xlApjq
 va9hvTzHod1T/wJKQAS66A0vxLrIx+fINfoS4I4cQaLpuC4IPLVU9Zv/GO2vsJbJ
 QFyZKGFkPjYWtUSMgnY3zm/iycNuD+t3We81AhTWU8kksP6l4T3szYYBGLvnG2Jc
 f2HqrQtfWqVR0ygvcACbgaVn+sU2OsQSLLlE+H0/4cMU6LsxjYaYSPkCUEYRXyHu
 ss/0l/H9WqWU2CPmbMmF4vQgiueGlvADZPZp0fK16xbkOuAGecXvdXt1MH6ATWAv
 0LaK9qqpyTqI2QtXbKIG5AhgkXM4fFL4I2J7r3Zd3Jt6

Use i_blockmask() to simplify code.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
---
v3:
-none
v2:
-convert to i_blockmask()
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d251d705c276..eec36520e5e9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2218,7 +2218,7 @@ static int mpage_process_page_bufs(struct mpage_da_data *mpd,
 {
 	struct inode *inode = mpd->inode;
 	int err;
-	ext4_lblk_t blocks = (i_size_read(inode) + i_blocksize(inode) - 1)
+	ext4_lblk_t blocks = (i_size_read(inode) + i_blockmask(inode))
 							>> inode->i_blkbits;
 
 	if (ext4_verity_in_progress(inode))
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
