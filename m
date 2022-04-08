Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22A05C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri,  8 Apr 2022 10:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sPCvSNB3lFP4cUa/oM5ueSH7cJDLyN/Y92AS3/FloaQ=;
 b=FFIH+p4Tjj5l2+z7JtuB8PqjIYipI2pFvpqZJIwtk8OfB2Q7t8CyxSCljE1RpaFeBm1jOofMsrRS
   ctaQuP40IYaWRmX41/xna9y7UrHT8BiHZIWD15hE827qhuS2FECT4iQ//OeI3ngaRETN8J3jyfsA
   TwXujXH1khX9XDCO2KKzrNFUi0vHsUaGieSR58VM7aQ5bvvuBEbZxXg6+N834FXB8JZtlwb47Ixt
   dn+wHKRQn+EStNrRRasidcr5Jmnia1DRyAy7smnfqYAY7aCB1C1a83KRs4603enF/KKynbyYx9ux
   D7eXTaZVhKnjfQa4yFXyqtzFhaR0nrRi9L+FDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=sPCvSNB3lFP4cUa/oM5ueSH7cJDLyN/Y92AS3/FloaQ=;
 b=MEX9IMUAjgyQsPnDZFa7sV4bvfVDTj1EquyFqq89vFe5ChVFAK+SMC6pbSQ75TNz7Q14GTmxB1U2
   /5UOT5Hdzrxv7kMcoFgort//im743/NPGmICtgY+VWs/mpxcEU9zPEGL3S4frJOfRH8buDRYFoZy
   FvO37vKkWArDtNRcBxiDXmQu2sM6Z2jpcBrACWJ1xZMvj7NNvKHVOQ576IbgsBkrWYZq+OK2rLrz
   PTMO3qDP1w7toxJw1z/rOKMYBS1czw5KO4YEaIJhq5uhbJXR+xQT16/5CFiSPEX3AGF3dI0zCoY6
   x8PvReTOfYu5m+vK3+7Bn15ZzxpVBdYsRcO1yg==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA000JNPNXYDL30@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 08 Apr 2022 10:32:22 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1649413879;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=YrJAzz7gRdFCcM9BdHLa5v85KiqfMqUMn0ugbqM/FOo=;
 b=la208abb9aSwBwiVz0QebeKHuqi8RFrxu8DTQefcKOv4iSn1KBH3ssNVNr3W9XG4lB3urE
 N4TMceD0z2YtVWaYzAqLv7ScEZskRJ0nVJnvYwySwbE56Zt7d6Glbey9RiVwkAPz4MSmuj
 FBkxMbteqmVWyD0Dp9P+fU2oA4PZ04w=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEqRyiLpngaP7l8FaRMgQZ0WLcUhbbCqCM1O6b9ZW8+elO/fu/ry4lwIm2teLQbB1KaEbAoUYRjratFNKT4c40rLB/5xl0UhBm9+0hTW8iRNl5bfzI32cm6FrsVLlolJ4XmgJObGHu9vonjIXqF32oXSaGkCShZk3+TBoU9CSnxhFNTRMkrBsyTTXqazAUCX76PKcnMJJLqDEP5+Bqh3T8GZyxszcTOPyyNt/QNJ0p0FIQwLybGp4cEWQcKlXMotLT07J4sg1nMRkWtdBm5jm17srBA766kT9YWEZliA9fUbzeNVXZL4DOWfKBfrCnnMu1gyFn1shSekoutm2TuUTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qqvU5DgOf4VIki/o8vUmn6BwXCZv51HmqcIJjHTdaPU=;
 b=MI9HMpi4boNKqjgBPWvmg6xkSIrWpcpk+9ilzhUew82EpFSaPkTTN8iYWyJhi1Dw+kE25GBmGF2dEeQ/RpTAl+rO7Z7j7tdb2Yj5hrKNrEvEwVUsyASWB/TP+iWZswq7pS1TryejdlVJl5oJ+3Fr1SWKfarycyyLRdb9CSLY964YTSG6lf0ZmI6vBhf14bWTn0DV8gu9nXvT3hwhBhujmSgeBashE21g77wkkkUICwlO3eiK2uoTuS+EC6jxU0oqaZ4mxwqplsVeDlMHbGUv9hfLhXQh6c03V85aKu5aunC/dZgdX+gJqI8IZsBHczRJXVpprnpP6ioIAYEDPA0L+Q==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Fri,  8 Apr 2022 18:30:12 +0800
Message-id: <20220408103012.1419-6-heming.zhao@suse.com>
X-Mailer: git-send-email 2.33.0
In-reply-to: <20220408103012.1419-1-heming.zhao@suse.com>
References: <20220408103012.1419-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(8936002)(44832011)(1076003)(6486002)(316002)(38100700002)(2616005)(86362001)(107886003)(83380400001)(2906002)(508600001)(5660300002)(4326008)(66476007)(6512007)(66946007)(66556008)(186003)(8676002)(6506007)(36756003)(6666004)(26005);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 10:31:17.0385 (UTC)
X-Source-IP: 194.104.111.102
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10310
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=999
 suspectscore=0 priorityscore=226 lowpriorityscore=0 adultscore=0
 malwarescore=0 bulkscore=0 clxscore=177 mlxscore=0 phishscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204080053
Subject: [Ocfs2-devel] [PATCH v1 5/5] ocfs2: rewrite error handling of
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
X-MC-Unique: PYFw5XMYOeurYMDSjRyG_A-1
X-ClientProxiedBy: TY2PR02CA0072.apcprd02.prod.outlook.com
 (2603:1096:404:e2::36) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf19ab57-4f17-47c3-923a-08da194ae9e6
X-MS-TrafficTypeDiagnostic: PA4PR04MB7840:EE_
X-Microsoft-Antispam-PRVS:
 <PA4PR04MB784038808FBEAB2F0439D86A97E99@PA4PR04MB7840.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 CM4QNBnIaOLDDzhlAbfyWNrmBbKFvFdGoDmupD5iDFozDQltOCPDXRjSHDkU+Oa4YXcUnmKGBeb7iuaNU67GBVrbiGH0VD/r34TAclUuUzxpMCUiit10AxZqAEt5wmool0ey+n0E9P1xyUzOE03sKdJ02nISyBKms4HxfrVTxvsWbyOPa3s10y+c1qGBKWQWvA4J/akdHPjhBlv3gJ9YvwwWAIFR8uS5Oi3urAnsg5YzXDvvD/TgiAoJhv4Uha6f1ha773pye+coiO4t6QQb/rczs+p/d5K0gehdVu957HEtwwDPPTIX6ynm9z20muwd+7hvl6tXIJCIMGxwbxLJLusdMy2beX5dNuKQqwwG4IWGE+YaE+GOgbCG3vAAEhS9Ae+tVKUOhThyE2vuqGN11tETU75HgodGZyjEXVuohY0yVu1dPv8paxb3Rs1JO3rFT0HV9B5Ewhp3mZwRwj49g7+eRKYY+2Qc0285jkpOrDKyfVH2PYcvB9B1d5OCJe8vvU0bggK+dN3gOrN5MOVjkK/p61VLJ/5jYb46Omd6TcB4esjYNZXpSWObHbjQSuKQ/TiCIx0sTPiIOjy1e+y3KyPGf786PcFwbKrnxBn/lLNY9rLF/LVkQ37NADWkbKhfB1mPYn72C6c3w6lukANfYA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?yEQ121brAzIZuuZWckPfMtsknl3zAC0cfjNaOLZQcRctl4C9uvpebNSQPyZb?=
 =?us-ascii?Q?Y/A+6hcwU+NRn4oWjA0430MrAc6Ko1e3xwb77YKZC4f79olVlwsA6OcTSl9h?=
 =?us-ascii?Q?l06ow5iXv5vuiWJxdyjH+eIrhu2fe23A0QmW1xa2Fy4vLBXP9mjD2B0a1Oar?=
 =?us-ascii?Q?AMCJE+szHF6coZYJTV8t2hpw7fQjZVmQyeQOQXPAs422L7T8vWxxxvx/FOfu?=
 =?us-ascii?Q?inOQQnE8EfnQ9j8IdjHc/9kr00Zc+HL+I6oTDoJCA5JxkXHQz81fCZOHev5+?=
 =?us-ascii?Q?lP5h5L/PecwwpgbTvxswTUG7KqVvBLftvDFu0qCYo5LbXQ65ekEkqqvjtUEk?=
 =?us-ascii?Q?zC7SKtVOmKSWQ15161xomfncw/Ud83F+XNcC2Px1Kuuyeur8cXxr3jt9rkZ1?=
 =?us-ascii?Q?IFfFtrMtA2FiXOmu6fdjoQK+HnPdQddCOYqxAq8CyKlwzkW534WJ6sB5JumL?=
 =?us-ascii?Q?dViOZUIdWkFGni5hVLfxfA+F1DyqAXZgBQTWXUzk4Kgvu4OwG09UAGhc+6oa?=
 =?us-ascii?Q?0+/n1Jiw+FZf5XrJyokx+7Jzo28qL0YJ8T8oCUB0XqGW4cTfYTwswaM0wMEH?=
 =?us-ascii?Q?teReR3S7WacSXz3aVvm5mXfajy6N3p7hZA0piQmUWk7ShjuYq6z21ZT432UT?=
 =?us-ascii?Q?jryXU/bSeOnV9t+0Af9NWqPvSBu3T0e+1BjkpYAz0mxdov/ZYJzU6z+NjUoI?=
 =?us-ascii?Q?mvB+jZtXfsnZFiEgZXzx7kuq3RhEaoXGaecim55RuwkPg5kK178AAE6m5Qm2?=
 =?us-ascii?Q?V0K+eIBP5eNIOvcWgL+edcnRjor1ZIYriVxGIo+K1v4fEU+AjglMACu6OhLM?=
 =?us-ascii?Q?LepTd5lJHd0NYWkuEMP0p3N5l6O7zeax6VNIGVlcOk4EzUL+hUeTwiTG3kwv?=
 =?us-ascii?Q?gRKsRSAvP0M67rE7pNwSzS1ljhBKrfkV54si0eLi69pBtjig65OAoTCPZulN?=
 =?us-ascii?Q?FCPoJLzqEaHg8jFo+zZGnwbhgj1c0ImgUUvQzAY3c0c1SJbtsKROkXfiq85e?=
 =?us-ascii?Q?jwMRP/vHsFVk8BKYTovstEWLLpFdIeCDcarrD+mivM2JEh4ql8F15pL/Une8?=
 =?us-ascii?Q?Q3MN6wFE0l3VTAfcQU2aQIbByp+/ekOSdJv5MY1zk/hm2Kxjt72rtfRbg1n1?=
 =?us-ascii?Q?UNsfbALoQGwCFbSwEuAYdRWV+wF4M4FSHgJfXfqkh5TLZ3gH/n/GnKBFYRpG?=
 =?us-ascii?Q?9qrNwG/Danox1o3MHA3RJ8f6LSifaeoozq9ut9UPHjj9fTeu9o2mQXD74HSV?=
 =?us-ascii?Q?70epWfeUH5ymJ8ZsWGLylYBy8kGuc7bkHWw+nlea5cFVkdhiepAU5tx3JIIm?=
 =?us-ascii?Q?QXg/ioyvvX+MpHtegpVxKriVstFK40KSk+BazY/AXRh8yLhu55sq/1hWoska?=
 =?us-ascii?Q?GfmePyOCecwWZjNigqk7tpKYa2TCZlsUOtVIa8kEEojPoWR5KKOvlkamwJxL?=
 =?us-ascii?Q?JKDv1VFMi7OsBVhfb63rFG5mPYcLmHeEGOtdaahPxS3uQCtM/DahJ5uLlx7F?=
 =?us-ascii?Q?F2KKR581TwaSti2Ru7E1pv1GrHL4XjQGOhgvTdwict+Q7wIj4I0mP0ueEWQ+?=
 =?us-ascii?Q?6XcLwoSJlZKNBJYBvg+rMfCKr9RzEymSxFrqB6fFeQ3pauKsmEfl4kmBIF2j?=
 =?us-ascii?Q?0Mf21ONQh4EOR3VVbJYceCEZ0oTXR0ha1T86Y+O6OvbP10PHNUwcPD/JaOfY?=
 =?us-ascii?Q?AO+W7d6gfiqcuWflgnrWxiqlaMIeE0LxWCpFXT8aMJb28T6LeI5btp21M4IT?=
 =?us-ascii?Q?2jJyq6Ew/A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 bf19ab57-4f17-47c3-923a-08da194ae9e6
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 EYVyL/eMJkZyf6woy/DMu3eWWkVqmcgObmVcu4kT96gflqyKzz17uIsEKwqu/orMSXRAtJhKLQxFcAZObD4cSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7840
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: AUpoktRrdHrEFvhnTqD-K4VOc8A0lbax
X-Proofpoint-GUID: AUpoktRrdHrEFvhnTqD-K4VOc8A0lbax
Reporting-Meta:
 AAEZSf6Z+kvCGWAxxk8TNTrgd/I0ZmEPvRFWfFNmacQS6nsSm6R33JTbjsGFNu5O
 VyDSkzGuYICXtkJiQzMDCGkzqiN3b7YzZnkLhsPCl9n0/iqg5nt3FXRiZj1tKyaE
 LXAuM3TMYiKSV2Tzu/P/ZliRc/ta8Q1ws6hJzXjBMjQSZSKOcXoOEwlN7nu59uzN
 5fQxeHiiZOGY2fUmfzjuQZzL4ud/vOrKPCEuXGm75e+n2W3UOoEb+s3f4v60Sxh0
 2TuCeypqrJl2pHbc8WDdXdKMpQcDgFL5TVNwcLayH9+l1mhvAVSqtqQSHmGYz6k4
 O18ONiom9Lyh0YZjRIUx8rDIfnNIwUvfYGIJmiFb37mOZdVTjZU/v6pwpFdEUiK1
 6GhUdFc08bVGBnFRQ4IHJ43aXL41Of1DBR4oxZjkSOpDd+z/ePyfXMkEZzSUm2nE
 nWz3xvqePiOZZpjyN0IiZGozLHUirrIbXau+tZ3x8c01dLpoqIpi+V/2/43LlxID
 wese9OldG5lJxOjHk7EBN3DzhbQWWNiUF1letwr1iVk=

current ocfs2_fill_super error handling is very simple, and includes
kernel crash possibility.

e.g.

ocfs2_fill_super
  ocfs2_initialize_super // fails in check max_slots & return

Then osb->osb_mount_event is not properly initialized, and then will
crash at wake_up(&osb->osb_mount_event) in goto label read_super_error.

For fixing the issue and enhancing error handling, we rewrite error
handling of ocfs2_fill_super.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/super.c | 67 ++++++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 34 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index d4b7a29cb364..c3efd9ad49ac 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -989,28 +989,27 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {
 		status = -EINVAL;
-		goto read_super_error;
+		goto out;
 	}
 
 	/* probe for superblock */
 	status = ocfs2_sb_probe(sb, &bh, &sector_size, &stats);
 	if (status < 0) {
 		mlog(ML_ERROR, "superblock probe failed!\n");
-		goto read_super_error;
+		goto out;
 	}
 
 	status = ocfs2_initialize_super(sb, bh, sector_size, &stats);
-	osb = OCFS2_SB(sb);
-	if (status < 0) {
-		mlog_errno(status);
-		goto read_super_error;
-	}
 	brelse(bh);
 	bh = NULL;
+	if (status < 0)
+		goto out;
+
+	osb = OCFS2_SB(sb);
 
 	if (!ocfs2_check_set_options(sb, &parsed_options)) {
 		status = -EINVAL;
-		goto read_super_error;
+		goto out_super;
 	}
 	osb->s_mount_opt = parsed_options.mount_opt;
 	osb->s_atime_quantum = parsed_options.atime_quantum;
@@ -1027,7 +1026,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
 	if (status)
-		goto read_super_error;
+		goto out_super;
 
 	sb->s_magic = OCFS2_SUPER_MAGIC;
 
@@ -1041,7 +1040,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 			status = -EACCES;
 			mlog(ML_ERROR, "Readonly device detected but readonly "
 			     "mount was not specified.\n");
-			goto read_super_error;
+			goto out_super;
 		}
 
 		/* You should not be able to start a local heartbeat
@@ -1050,7 +1049,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 			status = -EROFS;
 			mlog(ML_ERROR, "Local heartbeat specified on readonly "
 			     "device.\n");
-			goto read_super_error;
+			goto out_super;
 		}
 
 		status = ocfs2_check_journals_nolocks(osb);
@@ -1059,9 +1058,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 				mlog(ML_ERROR, "Recovery required on readonly "
 				     "file system, but write access is "
 				     "unavailable.\n");
-			else
-				mlog_errno(status);
-			goto read_super_error;
+			goto out_super;
 		}
 
 		ocfs2_set_ro_flag(osb, 1);
@@ -1077,10 +1074,8 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	status = ocfs2_verify_heartbeat(osb);
-	if (status < 0) {
-		mlog_errno(status);
-		goto read_super_error;
-	}
+	if (status < 0)
+		goto out_super;
 
 	osb->osb_debug_root = debugfs_create_dir(osb->uuid_str,
 						 ocfs2_debugfs_root);
@@ -1094,15 +1089,14 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	status = ocfs2_mount_volume(sb);
 	if (status < 0)
-		goto read_super_error;
+		goto out_debugfs;
 
 	if (osb->root_inode)
 		inode = igrab(osb->root_inode);
 
 	if (!inode) {
 		status = -EIO;
-		mlog_errno(status);
-		goto read_super_error;
+		goto out_journal;
 	}
 
 	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
@@ -1110,7 +1104,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	if (!osb->osb_dev_kset) {
 		status = -ENOMEM;
 		mlog(ML_ERROR, "Unable to create device kset %s.\n", sb->s_id);
-		goto read_super_error;
+		goto out_journal;
 	}
 
 	/* Create filecheck sysfs related directories/files at
@@ -1119,14 +1113,13 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 		status = -ENOMEM;
 		mlog(ML_ERROR, "Unable to create filecheck sysfs directory at "
 			"/sys/fs/ocfs2/%s/filecheck.\n", sb->s_id);
-		goto read_super_error;
+		goto out_journal;
 	}
 
 	root = d_make_root(inode);
 	if (!root) {
 		status = -ENOMEM;
-		mlog_errno(status);
-		goto read_super_error;
+		goto out_journal;
 	}
 
 	sb->s_root = root;
@@ -1178,17 +1171,23 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	return status;
 
-read_super_error:
-	brelse(bh);
+out_journal:
+	mlog_errno(status);
+	atomic_set(&osb->vol_state, VOLUME_DISABLED);
+	wake_up(&osb->osb_mount_event);
+	ocfs2_dismount_volume(sb, 1);
 
-	if (status)
-		mlog_errno(status);
+	return status;
 
-	if (osb) {
-		atomic_set(&osb->vol_state, VOLUME_DISABLED);
-		wake_up(&osb->osb_mount_event);
-		ocfs2_dismount_volume(sb, 1);
-	}
+out_debugfs:
+	debugfs_remove_recursive(osb->osb_debug_root);
+out_super:
+	ocfs2_release_system_inodes(osb);
+	kfree(osb->recovery_map);
+	ocfs2_delete_osb(osb);
+	kfree(osb);
+out:
+	mlog_errno(status);
 
 	return status;
 }
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
